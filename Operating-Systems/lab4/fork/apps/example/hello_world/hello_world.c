#include "usertraps.h"
#include "misc.h"

void main (int argc, char *argv[])
{
  int i;
  int child_pid = 0;
  sem_t s_procs_completed; // Semaphore to signal the original process that we're done
  int num_hello_world;

  if (argc != 3) { 
    Printf("Usage: %s <handle_to_procs_completed_semaphore>\n"); 
    Exit();
  } 

  // Convert the command-line strings into integers for use as handles
  s_procs_completed = dstrtol(argv[1], NULL, 10);
  num_hello_world = dstrtol(argv[2], NULL, 10);

  Printf ("The main program process ID is %d\n", (int) getpid ());
  Printf ("Trying to fork %d processes\n", num_hello_world);

  for(i = 0; i < num_hello_world; i++) {
    child_pid = fork();
    if (child_pid != 0 && getpid() == 30) {
        Printf ("this is the parent process, with id %d\n", (int) getpid ());
        Printf ("the child's process ID is %d\n", child_pid);
    } 
    else {
        Printf ("this is the child process, with id %d\n", (int) getpid ());
        break;
    }
  }

  Printf("Hello world, this is process ID: #%d\n", getpid());

  // Signal the semaphore to tell the original process that we're done
  if(sem_signal(s_procs_completed) != SYNC_SUCCESS) {
    Printf("hello_world (%d): Bad semaphore s_procs_completed (%d)!\n", getpid(), s_procs_completed);
    Exit();
  }

  Printf("hello_world (%d): Done!\n", getpid());
}
