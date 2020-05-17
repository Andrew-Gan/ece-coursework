#include "lab2-api.h"
#include "usertraps.h"
#include "misc.h"

void main(int argc, char** argv) {
  sem_t sem_H2;                  // Semaphore used for SO4
  sem_t sem_O2;                  // Semaphore used for SO2
  sem_t sem_SO2;                 // Semaphore used for O2
  sem_t sem_H2SO4;               // Semaphore used for H2SO4
  sem_t sem_proc_completed;      // Semaphore for process completed
  int i = 0;
  int num_reac_H2SO4_run = 0;

  if (argc != 7) { 
    Printf("Usage: "); Printf(argv[0]);
    Exit();
  } 

  // Convert the command-line strings into integers for use as handles
  sem_H2 = dstrtol(argv[1], NULL, 10);
  sem_O2 = dstrtol(argv[2], NULL, 10);
  sem_SO2 = dstrtol(argv[3], NULL, 10);
  sem_H2SO4 = dstrtol(argv[4], NULL, 10);
  sem_proc_completed = dstrtol(argv[5], NULL, 10);
  num_reac_H2SO4_run = dstrtol(argv[6], NULL, 10);

  for(i = 0; i < num_reac_H2SO4_run; i++) {
    // consume 1 H2 molecule
    sem_wait(sem_H2);
    // consume 1 O2 molecule
    sem_wait(sem_O2);
    // consume 1 SO2 molecule
    sem_wait(sem_SO2);
    // release one H2SO4
    sem_signal(sem_H2SO4);
    //Print out statement
    Printf("H2 + O2 + SO2 -> H2SO4 reacted, PID: %d\n", getpid());
  }
  
  // Signal the semaphore to tell the original process that we're done
  if(sem_signal(sem_proc_completed) != SYNC_SUCCESS) {
    Printf("Bad semaphore sem_proc_completed (%d) in ", sem_proc_completed); Printf(argv[0]); Printf(", exiting...\n");
    Exit();
  }
}