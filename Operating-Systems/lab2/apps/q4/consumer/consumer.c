#include "lab2-api.h"
#include "usertraps.h"
#include "misc.h"

#include "../include/spawn.h"

void main (int argc, char *argv[])
{
  CircularBuffer *buffer;        // Used to access missile codes in shared memory page
  uint32 handle_memory;          // Handle to the shared memory page
  sem_t s_procs_completed;       // Semaphore to signal the original process that we're done
  lock_t l_buffer_proc;          // Sempahore used to wait for consumer and producer to finish
  cond_t dataAvailable;          // Conditional variable to check if data is available
  cond_t spaceAvailable;         // Conditional variable to check if space is available
  int printIndex = 0;
  int i = 0;
  const char textStr[] = "Hello world"; // the string to be read into buffer

  if (argc != 6) { 
    Printf("Usage: "); Printf(argv[0]); Printf(" <handle_to_shared_memory_page> <handle_to_page_mapped_semaphore> <handle_data_avail> <handle_space_avail>\n"); 
    Exit();
  } 

  // Convert the command-line strings into integers for use as handles
  handle_memory = dstrtol(argv[1], NULL, 10); // The "10" means base 10
  s_procs_completed = dstrtol(argv[2], NULL, 10);
  l_buffer_proc = dstrtol(argv[3],NULL,10);
  dataAvailable = dstrtol(argv[4],NULL,10);
  spaceAvailable = dstrtol(argv[5],NULL,10);

  // Map shared memory page into this process's memory space
  if ((buffer = (CircularBuffer*)shmat(handle_memory)) == NULL) {
    Printf("Could not map the virtual address to the memory in "); Printf(argv[0]); Printf(", exiting...\n");
    Exit();
  }

  while(printIndex < (sizeof(textStr) - 1)){
    // if lock not acquired, do nothing
    if(lock_acquire(l_buffer_proc) != SYNC_SUCCESS){
      Printf(" Lock cannot be acquired\n"); Printf(argv[0]); Printf(", exiting...\n");
      Exit();
    }

    // if buffer is empty, wait till it is not empty (there is dataAvailable)
    while(buffer->numElements == 0) {
        cond_wait(dataAvailable);
    }
  
    // read start char from string ,print it and increment by 1  
    Printf("Buffer is: ");
    for ( i = 0; i < 10; i++){
      Printf("%c", buffer->buff[i]);
    }
      Printf("\n");
      
    Printf("Consumer %d is printing ", getpid());
    Printf("%c ", buffer->buff[buffer->start]);
    buffer->start = (buffer->start + 1) % sizeof(buffer->buff); //increment start index
    printIndex++; //increment print Index until it reaches the length of string
    (buffer->numElements)--;
    Printf("start = %d ", buffer->start);
    Printf("end = %d\n", buffer->end);

    //Signal the condition variable that we are done (space is avaiable now)
    cond_signal(spaceAvailable);

    //Release the lock then
    if(lock_release(l_buffer_proc) != SYNC_SUCCESS){
      Printf(" Lock cannot be released\n"); Printf(argv[0]); Printf(", exiting...\n");
      Exit();
    }
  }
 
  // Signal the semaphore to tell the original process that we're done
  if(sem_signal(s_procs_completed) != SYNC_SUCCESS) {
    Printf("Bad semaphore s_procs_completed (%d) in ", s_procs_completed); Printf(argv[0]); Printf(", exiting...\n");
    Exit();
  }

}