#include "lab2-api.h"
#include "usertraps.h"
#include "misc.h"

#include "../include/spawn.h"

void main (int argc, char *argv[])
{
  int numprocs = 0;               // Used to store number of processes to create
  int i;                          // Loop index variable
  CircularBuffer *buffer;         // Used to get address of shared memory page
  uint32 handle_memory;           // Used to hold handle to shared memory page
  sem_t s_proc_completed;         // Semaphore used to wait until all processes have completed
  lock_t l_buffer_proc;         // Lock used to wait for consumer and producer to finish
  char handle_memory_str[10];     // Used as command-line argument to pass mem_handle to new processes
  char s_proc_completed_str[10];  // Used as command-line argument to pass page_mapped handle to new processes
  char l_buffer_proc_str[10];      // Used as command-line argument to pass page_mapped handle to finish


  if (argc != 2) {
    Printf("Usage: "); Printf(argv[0]); Printf(" <number of processes to create>\n");
    Exit();
  }

  // Convert string from ascii command line argument to integer number
  numprocs = dstrtol(argv[1], NULL, 10); // the "10" means base 10
  Printf("Creating %d processes\n", numprocs);

  // Allocate space for a shared memory page, which is exactly 64KB
  // Note that it doesn't matter how much memory we actually need: we 
  // always get 64KB
  if ((handle_memory = shmget()) == 0) {
    Printf("ERROR: could not allocate shared memory page in "); Printf(argv[0]); Printf(", exiting...\n");
    Exit();
  }

  // Map shared memory page into this process's memory space
  if ((buffer = (CircularBuffer*)shmat(handle_memory)) == NULL) {
    Printf("Could not map the shared page to virtual address in "); Printf(argv[0]); Printf(", exiting..\n");
    Exit();
  }

  // Put some values in the shared memory, to be read by other processes
  buffer->numElements = 0;
  buffer->start = 0;
  buffer->end = 0;


  // Create a lock 
  if((l_buffer_proc = lock_create()) == SYNC_SUCCESS) {
    Printf("Bad lock_create in"); Printf(argv[0]); Printf("\n");
    Exit();
  }


  // Create semaphore to not exit this process until all other processes 
  // have signalled that they are complete.  To do this, we will initialize
  // the semaphore to (-1) * (number of signals), where "number of signals"
  // should be equal to the number of processes we're spawning - 1.  Once 
  // each of the processes has signaled, the semaphore should be back to
  // zero and the final sem_wait below will return.
  s_proc_completed = sem_create(-(2 * numprocs-1));
  if(s_proc_completed == SYNC_FAIL)
  {
    Printf("Bad sem_create in "); Printf(argv[0]); Printf("\n");
    Exit();
  }

  // Setup the command-line arguments for the new process.  We're going to
  // pass the handles to the shared memory page and the semaphore as strings
  // on the command line, so we must first convert them from ints to strings.
  ditoa(handle_memory, handle_memory_str);
  ditoa(s_proc_completed, s_proc_completed_str);
  ditoa(l_buffer_proc, l_buffer_proc_str);

  // Now we can create the processes.  Note that you MUST end your call to
  // process_create with a NULL argument so that the operating system
  // knows how many arguments you are sending.
  for(i=0; i<numprocs; i++) {
    process_create("producer.dlx.obj", handle_memory_str, s_proc_completed_str, l_buffer_proc_str, NULL);
    Printf("Producer's Process %d created\n", i);
    process_create("consumer.dlx.obj", handle_memory_str, s_proc_completed_str, l_buffer_proc_str, NULL);
    Printf("Consumer's Process %d created\n", i);
  }

  // And finally, wait until all spawned processes have finished.
  if (sem_wait(s_proc_completed) != SYNC_SUCCESS) {
    Printf("Bad semaphore s_procs_completed (%d) in ", s_proc_completed); Printf(argv[0]); Printf("\n");
    Exit();
  }
  Printf("All other processes completed, exiting main process.\n");
}
