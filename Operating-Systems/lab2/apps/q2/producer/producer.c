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
  int strIndex = 0;              // String index to be incremented
  const char textStr[] = "Hello world"; // the string to be read into buffer

  if (argc != 4) { 
    Printf("Usage: "); Printf(argv[0]); Printf(" <handle_to_shared_memory_page> <handle_to_page_mapped_semaphore>\n"); 
    Exit();
  } 

  // Convert the command-line strings into integers for use as handles
  handle_memory = dstrtol(argv[1], NULL, 10); // The "10" means base 10
  s_procs_completed = dstrtol(argv[2], NULL, 10);
  l_buffer_proc = dstrtol(argv[3],NULL,10);

  // Map shared memory page into this process's memory space
  if ((buffer = (CircularBuffer*)shmat(handle_memory)) == NULL) {
    Printf("Could not map the virtual address to the memory in "); Printf(argv[0]); Printf(", exiting...\n");
    Exit();
  }

  while(strIndex < (sizeof(textStr)-1)){
    // if lock not acquired, do nothing
      if(lock_acquire(l_buffer_proc) != SYNC_SUCCESS){
        Printf(" Lock cannot be acquired\n"); Printf(argv[0]); Printf(", exiting...\n");
        Exit();
      }
    
      // if buffer is not full, read current char from string and add to end of circular buffer  
      if(buffer->numElements != sizeof(buffer->buff)) {
        Printf("Producer %d is putting ", getpid());
        Printf("%c ", textStr[strIndex]);
        buffer->buff[buffer->end] = textStr[strIndex++];
        buffer->end = (buffer->end + 1) % sizeof(buffer->buff);
        (buffer->numElements)++;
        Printf("start = %d ", buffer->start);
        Printf("end = %d\n", buffer->end);
      }
  
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
