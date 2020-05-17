#include "lab2-api.h"
#include "usertraps.h"
#include "misc.h"

void main (int argc, char *argv[])
{
  int num_inj_H2O_run = 0;        // Used to store number of times H2O to run
  int num_inj_SO4_run = 0;        // Used to store number of times SO4 to run
  int num_reac_H2SO4_run = 0;     // Used to store number of times H2O to run
  int num_reac_SO4_run = 0;       // Used to store number of times SO4 to run
  int num_reac_H2O_run = 0;       // Used to store number of times H2O to run                        // Loop index variable
  int H2 = 0, O2 = 0, SO2 = 0, min = 0; // For calculating num_reac_H2SO4_run

  int H2O_left = 0;               // number of H2O left
  int SO4_left = 0;               // number of SO4 left
  int H2_left = 0;                // number of H2 left
  int O2_left = 0;                // number of O2 left
  int SO2_left = 0;               // number of SO2 left
  int H2SO4_left = 0;             // number of H2SO4 left

  sem_t sem_H2O;                  // Semaphore used for H2O
  sem_t sem_SO4;                  // Semaphore used for SO4
  sem_t sem_H2;                   // Semaphore used for H2
  sem_t sem_O2;                   // Semaphore used for O2
  sem_t sem_SO2;                  // Semaphore used for SO2
  sem_t sem_H2SO4;
  sem_t sem_proc_completed;       // Semaphore for process completed

  char num_inj_H2O_run_str[10];
  char num_inj_SO4_run_str[10]; 
  char num_reac_H2SO4_run_str[10];
  char num_reac_SO4_run_str[10];
  char num_reac_H2O_run_str[10];
  
  char sem_H2O_str[10];           // Used as command-line argument to pass semaphore H2O handle to new processes 
  char sem_SO4_str[10];           // Used as command-line argument to pass semaphore SO4 handle to new processes 
  char sem_H2_str[10];            // Used as command-line argument to pass semaphore H2 handle to new processes 
  char sem_O2_str[10];            // Used as command-line argument to pass semaphore O2 handle to new processes 
  char sem_SO2_str[10];           // Used as command-line argument to pass semaphore SO2 handle to new processes 
  char sem_H2SO4_str[10];         // Used as command-line argument to pass semaphore H2SO4 handle to new processes
  char sem_proc_completed_str[10];// Used as command-line argument to pass page_mapped handle to new processes

  if (argc != 3) {
    Printf("Usage: "); Printf(argv[0]); Printf(" <number of H2O molecules> <number of SO4 molecules>\n");
    Exit();
  }

  // Convert string from ascii command line argument to integer number
  num_inj_H2O_run = dstrtol(argv[1], NULL, 10); // the "10" means base 10
  Printf("Starting with %d H2O molecules\n", num_inj_H2O_run);
  num_inj_SO4_run = dstrtol(argv[2], NULL, 10); // the "10" means base 10
  Printf("Starting with %d SO4 molecules\n", num_inj_SO4_run);

  //calculate number of times the loop in the processes has to run
  num_reac_H2O_run = num_inj_H2O_run / 2;
  num_reac_SO4_run = num_inj_SO4_run / 1;
  
  H2 = num_reac_H2O_run * 2;                            //how many H2 will be produced
  O2 = num_reac_H2O_run * 1 + num_reac_SO4_run * 1;     //how many SO2 will be produced
  SO2 = num_reac_SO4_run * 1;                           //how many SO2 will be produced
  min = H2;
  //Chose the minimum molecule as limiting agent
  if(H2 < min) min = H2;
  if(O2 < min) min = O2;
  if(SO2 < min) min = SO2;
  num_reac_H2SO4_run = min;


  //Calculate how many molecules will be left for eahc molecule
  H2O_left = num_inj_H2O_run % 2;
  SO4_left = num_inj_SO4_run % 1;
  H2_left = H2 - num_reac_H2SO4_run;
  O2_left = O2 - num_reac_H2SO4_run;
  SO2_left = SO2 - num_reac_H2SO4_run;
  

  
  // Create one semaphore for tracking number of running processes
  // Create six semaphores for tracking number of each molecule
  sem_proc_completed = sem_create(-4);
  if(sem_proc_completed == SYNC_FAIL)
  {
    Printf("Bad sem_create in "); Printf(argv[0]); Printf("\n");
    Exit();
  }
  sem_H2O = sem_create(0);
  if(sem_H2O == SYNC_FAIL)
  {
    Printf("Bad sem_create in "); Printf(argv[0]); Printf("\n");
    Exit();
  }
  sem_SO4 = sem_create(0); 
  if(sem_SO4 == SYNC_FAIL)
  {
    Printf("Bad sem_create in "); Printf(argv[0]); Printf("\n");
    Exit();
  }
  sem_H2 = sem_create(0);
  if(sem_H2 == SYNC_FAIL)
  {
    Printf("Bad sem_create in "); Printf(argv[0]); Printf("\n");
    Exit();
  }
  sem_O2 = sem_create(0);
  if(sem_O2 == SYNC_FAIL)
  {
    Printf("Bad sem_create in "); Printf(argv[0]); Printf("\n");
    Exit();
  }
  sem_SO2 = sem_create(0);
  if(sem_SO2 == SYNC_FAIL)
  {
    Printf("Bad sem_create in "); Printf(argv[0]); Printf("\n");
    Exit();
  }
  sem_H2SO4 = sem_create(0) ;
  if(sem_H2SO4== SYNC_FAIL)
  {
    Printf("Bad sem_create in "); Printf(argv[0]); Printf("\n");
    Exit();
  }
 
  // Setup the command-line arguments for the new process.  We're going to
  // pass the handles to the shared memory page and the semaphore as strings
  // on the command line, so we must first convert them from ints to strings.
  ditoa(sem_H2, sem_H2_str);
  ditoa(sem_SO4, sem_SO4_str);
  ditoa(sem_H2O, sem_H2O_str);
  ditoa(sem_O2, sem_O2_str);
  ditoa(sem_SO2, sem_SO2_str);
  ditoa(sem_H2SO4, sem_H2SO4_str);
  ditoa(sem_proc_completed, sem_proc_completed_str);
  ditoa(num_reac_H2O_run, num_reac_H2O_run_str);
  ditoa(num_reac_SO4_run, num_reac_SO4_run_str);
  ditoa(num_reac_H2SO4_run, num_reac_H2SO4_run_str);
  ditoa(num_inj_H2O_run, num_inj_H2O_run_str);
  ditoa(num_inj_SO4_run, num_inj_SO4_run_str);

  // Now we can create the processes.  Note that you MUST end your call to
  // process_create with a NULL argument so that the operating system
  // knows how many arguments you are sending.
  process_create("inj_H2O.dlx.obj", sem_H2O_str,  sem_proc_completed_str, num_inj_H2O_run_str, NULL);
  process_create("inj_SO4.dlx.obj", sem_SO4_str,  sem_proc_completed_str, num_inj_SO4_run_str, NULL);
  process_create("reac_H2O.dlx.obj", sem_H2O_str, sem_H2_str, sem_O2_str, sem_proc_completed_str, num_reac_H2O_run_str, NULL);
  process_create("reac_SO4.dlx.obj", sem_SO4_str, sem_SO2_str, sem_O2_str, sem_proc_completed_str, num_reac_SO4_run_str, NULL);
  process_create("reac_H2SO4.dlx.obj", sem_H2_str, sem_O2_str, sem_SO2_str, sem_H2SO4_str, sem_proc_completed_str, num_reac_H2SO4_run_str, NULL);

  // And finally, wait until all spawned processes have finished.
  if (sem_wait(sem_proc_completed) != SYNC_SUCCESS) {
    Printf("Bad semaphore s_procs_completed (%d) in ", sem_proc_completed); Printf(argv[0]); Printf("\n");
    Exit();
  }
  
  Printf("%d H2O's left over. ", H2O_left);
  Printf("%d SO4's left over. ", SO4_left);
  Printf("%d H2's left over. ", H2_left);
  Printf("%d O2's left over. ", O2_left);
  Printf("%d SO2's left over. ", SO2_left);
  Printf("%d H2SO4's created. \n", num_reac_H2SO4_run);
  Printf("All other processes completed, exiting main process.\n");
}