#include "usertraps.h"
#include "misc.h"

void main (int argc, char *argv[])
{
  int i = 0;
  sem_t s_procs_completed; // Semaphore to signal the original process that we're done

  if (argc != 2) { 
    Printf("Usage: %s <handle_to_procs_completed_semaphore>\n"); 
    Exit();
  } 

  // Convert the command-line strings into integers for use as handles
  s_procs_completed = dstrtol(argv[1], NULL, 10);

  Printf("q2_p6 (%d): starting to print\n", getpid());

  // print counting in a loop
  for(i = 0; i < 10; i++) {
    Printf("q2_p6 (%d): %d\n", getpid(), i);
  }

  Printf("q2_p6 (%d): finish printing\n", getpid());

  // Signal the semaphore to tell the original process that we're done
  if(sem_signal(s_procs_completed) != SYNC_SUCCESS) {
    Printf("q2_p6 (%d): Bad semaphore s_procs_completed (%d)!\n", getpid(), s_procs_completed);
    Exit();
  }

  Printf("q2_p6 (%d): Done!\n", getpid());
}