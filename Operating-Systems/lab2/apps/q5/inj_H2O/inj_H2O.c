#include "lab2-api.h"
#include "usertraps.h"
#include "misc.h"

void main(int argc, char** argv) {
  sem_t sem_H2O;                  // Semaphore used for H2O
  int num_inj_H2O_run;          // number of injections
  sem_t sem_proc_completed;       // Semaphore for process completed
  int i = 0;
  
  if (argc != 4) { 
    Printf("Usage: "); Printf(argv[0]);
    Exit();
  } 

  // Convert the command-line strings into integers for use as handles
  sem_H2O = dstrtol(argv[1], NULL, 10);
  sem_proc_completed = dstrtol(argv[2], NULL, 10);
  num_inj_H2O_run = dstrtol(argv[3], NULL, 10);

  for(i = 0; i < num_inj_H2O_run; i++) {
    // release 1 H2O molecule
    sem_signal(sem_H2O);
    Printf("H2O injected into Radeon atmosphere, PID: %d\n", getpid());
  }
  
  // Signal the semaphore to tell the original process that we're done
  if(sem_signal(sem_proc_completed) != SYNC_SUCCESS) {
    Printf("Bad semaphore sem_proc_completed (%d) in ", sem_proc_completed); Printf(argv[0]); Printf(", exiting...\n");
    Exit();
  }
}