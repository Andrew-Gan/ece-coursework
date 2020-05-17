#include "lab2-api.h"
#include "usertraps.h"
#include "misc.h"

void main(int argc, char** argv) {
  sem_t sem_SO4;                  // Semaphore used for SO4
  int num_inj_SO4_run;          // number of injections
  sem_t sem_proc_completed;       // Semaphore for process completed
  int i = 0;

  if (argc != 4) { 
    Printf("Usage: "); Printf(argv[0]);
    Exit();
  } 

  // Convert the command-line strings into integers for use as handles
  sem_SO4 = dstrtol(argv[1], NULL, 10);
  sem_proc_completed = dstrtol(argv[2], NULL, 10);
  num_inj_SO4_run = dstrtol(argv[3], NULL, 10);

  for(i = 0; i < num_inj_SO4_run; i++) {
    // release 1 SO4 molecule
    sem_signal(sem_SO4);
    Printf("SO4 injected into Radeon atmosphere, PID: %d\n", getpid());
  }
  
  // Signal the semaphore to tell the original process that we're done
  if(sem_signal(sem_proc_completed) != SYNC_SUCCESS) {
    Printf("Bad semaphore sem_proc_completed (%d) in ", sem_proc_completed); Printf(argv[0]); Printf(", exiting...\n");
    Exit();
  }
}