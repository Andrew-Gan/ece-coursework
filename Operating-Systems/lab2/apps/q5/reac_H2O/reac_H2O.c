#include "lab2-api.h"
#include "usertraps.h"
#include "misc.h"

void main(int argc, char** argv) {
  sem_t sem_H2O;                  // Semaphore used for H2O
  sem_t sem_H2;                   // Semaphore used for H2
  sem_t sem_O2;                   // Semaphore used for O2
  sem_t sem_proc_completed;       // Semaphore for process completed
  int i = 0;
  int num_reac_H2O_run = 0;

  if (argc != 6) { 
    Printf("Usage: "); Printf(argv[0]);
    Exit();
  } 

  // Convert the command-line strings into integers for use as handles
  sem_H2O = dstrtol(argv[1], NULL, 10);
  sem_H2 = dstrtol(argv[2], NULL, 10);
  sem_O2 = dstrtol(argv[3], NULL, 10);
  sem_proc_completed = dstrtol(argv[4], NULL, 10);
  num_reac_H2O_run = dstrtol(argv[5], NULL, 10);

  for(i = 0; i < num_reac_H2O_run; i++) {
    // consume 2 H2O molecules
    sem_wait(sem_H2O);
    sem_wait(sem_H2O);
    // release 2 H2 molecules
    sem_signal(sem_H2);
    sem_signal(sem_H2);
    // release 1 O2 molecule
    sem_signal(sem_O2);
    Printf("2 H2O -> 2 H2 + O2 reacted, PID: %d\n", getpid());
  }
  
  // Signal the semaphore to tell the original process that we're done
  if(sem_signal(sem_proc_completed) != SYNC_SUCCESS) {
    Printf("Bad semaphore sem_proc_completed (%d) in ", sem_proc_completed); Printf(argv[0]); Printf(", exiting...\n");
    Exit();
  }
}