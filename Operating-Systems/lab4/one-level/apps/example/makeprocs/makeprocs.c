#include "usertraps.h"
#include "misc.h"

#define PART_1 "q2_p1.dlx.obj"
#define PART_2 "q2_p2.dlx.obj"
#define PART_3 "q2_p3.dlx.obj"
#define PART_4 "q2_p4.dlx.obj"
#define PART_6 "q2_p6.dlx.obj"

void main (int argc, char *argv[])
{
  int choice = 0;             // Choice for testing
  int i;                               // Loop index variable
  sem_t s_procs_completed;             // Semaphore used to wait until all spawned processes have completed
  char s_procs_completed_str[10];      // Used as command-line argument to pass page_mapped handle to new processes

  if (argc != 2) {
    Printf("Usage: %s <test option>\n", argv[0]);
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

  if(choice == 0 || choice == 1) {
    // Create Hello World processes
    Printf("-------------------------------------------------------------------------------------\n");
    Printf("makeprocs (%d): Print Hello World and exit\n");

    process_create(PART_1, s_procs_completed_str, NULL);
    if (sem_wait(s_procs_completed) != SYNC_SUCCESS) {
      Printf("Bad semaphore s_procs_completed (%d) in %s\n", s_procs_completed, argv[0]);
      Exit();
    }
  }

  if(choice == 0 || choice == 3) {
    Printf("-------------------------------------------------------------------------------------\n");
    Printf("makeprocs (%d): Access memory inside the virtual address space, but outside of currently allocated pages\n", getpid());

    process_create(PART_3, s_procs_completed_str, NULL);
    if (sem_wait(s_procs_completed) != SYNC_SUCCESS) {
      Printf("Bad semaphore s_procs_completed (%d) in %s\n", s_procs_completed, argv[0]);
      Exit();
    }
  }

  if(choice == 0 || choice == 4) {
    Printf("-------------------------------------------------------------------------------------\n");
    Printf("makeprocs (%d): Cause the user function call stack to grow larger than 1 page.\n", getpid());
    process_create(PART_4, s_procs_completed_str, NULL);
    if (sem_wait(s_procs_completed) != SYNC_SUCCESS) {
      Printf("Bad semaphore s_procs_completed (%d) in %s\n", s_procs_completed, argv[0]);
      Exit();
    }
  }

  if(choice == 0 || choice == 5) {
    Printf("-------------------------------------------------------------------------------------\n");
    Printf("makeprocs (%d): Call the Hello World program 100 times to make sure you are rightly allocating and freeing pages.\n", getpid());
    for (i = 0; i < 100; i++) {
      process_create(PART_1, s_procs_completed_str, NULL);
      if (sem_wait(s_procs_completed) != SYNC_SUCCESS) {
        Printf("Bad semaphore s_procs_completed (%d) in %s\n", s_procs_completed, argv[0]);
        Exit();
      }
    }
  }

  if(choice == 0 || choice == 6) {
    Printf("-------------------------------------------------------------------------------------\n");
    Printf("makeprocs (%d): Spawn 30 simultaneous processes that print a message, etc.\n", getpid());
    if ((s_procs_completed = sem_create(-29)) == SYNC_FAIL) {
      Printf("makeprocs (%d): Bad sem_create\n", getpid());
      Exit();
    }
    ditoa(s_procs_completed, s_procs_completed_str);
    for(i = 0; i < 30; i++) process_create(PART_6, s_procs_completed_str, NULL);
    if (sem_wait(s_procs_completed) != SYNC_SUCCESS) {
        Printf("Bad semaphore s_procs_completed (%d) in %s\n", s_procs_completed, argv[0]);
        Exit();
    }
  }

  if(choice == 0 || choice == 2) {
    Printf("-------------------------------------------------------------------------------------\n");
    Printf("makeprocs (%d): Access memory beyond the maximum virtual address\n", getpid());

    process_create(PART_2, s_procs_completed_str, NULL);
    if (sem_wait(s_procs_completed) != SYNC_SUCCESS) {
      Printf("Bad semaphore s_procs_completed (%d) in %s\n", s_procs_completed, argv[0]);
      Exit();
    }
  }

  Printf("-------------------------------------------------------------------------------------\n");
  Printf("makeprocs (%d): All other processes completed, exiting main process.\n", getpid());

}
