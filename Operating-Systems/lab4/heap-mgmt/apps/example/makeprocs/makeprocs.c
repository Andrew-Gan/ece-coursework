#include "usertraps.h"
#include "misc.h"

#define MEMORY_MALLOC "memory_malloc.dlx.obj"

void main (int argc, char *argv[])
{
  int choice = 0;             // Choice for testing
  sem_t s_procs_completed;             // Semaphore used to wait until all spawned processes have completed
  char s_procs_completed_str[10];      // Used as command-line argument to pass page_mapped handle to new processes
  char choice_str[5];   // size to malloc

  if (argc != 2) {
    Printf("Usage: %s <number of hello world processes to create>\n", argv[0]);
    Exit();
  }

  // Convert string from ascii command line argument to integer number
  choice = dstrtol(argv[1], NULL, 10); // the "10" means base 10

  // Create semaphore to not exit this process until all other processes 
  // have signalled that they are complete.
  if ((s_procs_completed = sem_create(0)) == SYNC_FAIL) {
    Printf("makeprocs (%d): Bad sem_create\n", getpid());
    Exit();
  }

  // Setup the command-line arguments for the new processes.  We're going to
  // pass the handles to the semaphore as strings
  // on the command line, so we must first convert them from ints to strings.
  ditoa(s_procs_completed, s_procs_completed_str);
  ditoa(choice, choice_str);

  // Create Hello World processes
  Printf("-------------------------------------------------------------------------------------\n");
  Printf("makeprocs (%d): Create malloc program and exit\n");

  process_create(MEMORY_MALLOC, s_procs_completed_str, choice_str, NULL);
  if (sem_wait(s_procs_completed) != SYNC_SUCCESS) {
      Printf("Bad semaphore s_procs_completed (%d) in %s\n", s_procs_completed, argv[0]);
      Exit();
  }

  Printf("-------------------------------------------------------------------------------------\n");
  Printf("makeprocs (%d): All other processes completed, exiting main process.\n", getpid());

}