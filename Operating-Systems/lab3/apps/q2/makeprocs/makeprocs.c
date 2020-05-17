#include "usertraps.h"
#include "misc.h"

void main (int argc, char *argv[])
{
  int num_inj_S2_run = 0;        // Used to store number of times S2 to run
  int num_inj_CO_run = 0;        // Used to store number of times CO to run
  int num_reac_S_run = 0;     // Used to store number of times S to run
  int num_reac_O2_C2_run = 0;       // Used to store number of times O2 C2 to run
  int num_reac_SO4_run = 0;       // Used to store number of times SO4 to run                        // Loop index variable
  int S = 0; int O2 = 0;
  int i;
  int procCount;
  char tmp[9];

  int S2_left = 0;               // number of S2 left
  int S_left = 0;               // number of S left
  int CO_left = 0;                // number of CO left
  int O2_left = 0;                // number of O2 left
  int C2_left = 0;               // number of C2 left
  int SO4_left = 0;             // number of SO4 left

  mbox_t mbox_S2;                  // mailbox used for H2O
  mbox_t mbox_S;                  // mailbox used for SO4
  mbox_t mbox_CO;                   //mailbox used for H2
  mbox_t mbox_O2;                   // mailbox used for O2
  mbox_t mbox_C2;                  // mailbox used for SO2
  mbox_t mbox_SO4;
  mbox_t mbox_proc_completed;
  
  char mbox_S2_str[10];           // Used as command-line argument to pass semaphore H2O handle to new processes 
  char mbox_S_str[10];           // Used as command-line argument to pass semaphore SO4 handle to new processes 
  char mbox_CO_str[10];            // Used as command-line argument to pass semaphore H2 handle to new processes 
  char mbox_O2_str[10];            // Used as command-line argument to pass semaphore O2 handle to new processes 
  char mbox_C2_str[10];           // Used as command-line argument to pass semaphore SO2 handle to new processes 
  char mbox_SO4_str[10];         // Used as command-line argument to pass semaphore H2SO4 handle to new processes
  char mbox_proc_completed_str[10];// Used as command-line argument to pass page_mapped handle to new processes

  if (argc != 3) {
    Printf("Usage: "); Printf(argv[0]); Printf(" <number of H2O molecules> <number of SO4 molecules>\n");
    Exit();
  }

  // Convert string from ascii command line argument to integer number
  num_inj_S2_run = dstrtol(argv[1], NULL, 10); // the "10" means base 10
  Printf("Starting with %d S2 molecules\n", num_inj_S2_run);
  num_inj_CO_run = dstrtol(argv[2], NULL, 10); // the "10" means base 10
  Printf("Starting with %d CO molecules\n", num_inj_CO_run);

  //calculate number of times the loop in the processes has to run
  num_reac_S_run = num_inj_S2_run / 1;
  num_reac_O2_C2_run = num_inj_CO_run / 4;
  
  S = num_reac_S_run * 2;          //how many S will be produced
  O2 = num_reac_O2_C2_run * 2;     //how many O2 will be produced
  num_reac_SO4_run = S < (O2 / 2) ? S : O2 / 2;                     //how many SO2 will be produced

  //Calculate how many molecules will be left for eahc molecule
  S2_left = num_inj_S2_run % 1;
  S_left =  S - num_reac_SO4_run;
  CO_left = num_inj_CO_run % 4;
  O2_left = O2 - (2 * num_reac_O2_C2_run);
  C2_left = 2 * num_reac_O2_C2_run;
  SO4_left = num_reac_SO4_run;

  
  // Create one semaphore for tracking number of running processes
  // Create six semaphores for tracking number of each molecule
  mbox_proc_completed = mbox_create();
  if(mbox_proc_completed == MBOX_FAIL){
    Printf("Bad Mailbox Created in "); Printf(argv[0]); Printf("\n");
    Exit();
  }
  mbox_S2 = mbox_create();
  if(mbox_S2 == MBOX_FAIL){
    Printf("Bad Mailbox Created in "); Printf(argv[0]); Printf("\n");
    Exit();
  }
  mbox_S = mbox_create();
  if(mbox_S == MBOX_FAIL){
    Printf("Bad Mailbox Created in "); Printf(argv[0]); Printf("\n");
    Exit();
  }
  mbox_CO = mbox_create();
  if(mbox_CO == MBOX_FAIL){
    Printf("Bad Mailbox Created in "); Printf(argv[0]); Printf("\n");
    Exit();
  }
  mbox_O2 = mbox_create();
  if(mbox_O2 == MBOX_FAIL){
    Printf("Bad Mailbox Created in "); Printf(argv[0]); Printf("\n");
    Exit();
  }
  mbox_C2 = mbox_create();
  if(mbox_C2 == MBOX_FAIL){
    Printf("Bad Mailbox Created in "); Printf(argv[0]); Printf("\n");
    Exit();
  }
  
  mbox_SO4 = mbox_create();
  if(mbox_SO4 == MBOX_FAIL){
    Printf("Bad Mailbox Created in "); Printf(argv[0]); Printf("\n");
    Exit();
  }
  
  // open S2 mailbox 
  if (mbox_open(mbox_S2) == MBOX_FAIL) {
      Printf("Error cannot open mailbox in %s\n", argv[0]);
      Exit();
  }
  // open S mailbox
  if (mbox_open(mbox_S) == MBOX_FAIL) {
      Printf("Error cannot open S mailbox in %s\n", argv[0]);
      Exit();
  }

// open the CO mailbox
  if (mbox_open(mbox_CO) == MBOX_FAIL) {
    Printf("Error cannot open mailbox in %s\n", argv[0]);
    Exit();
  }
  // open O2 mailbox
  if (mbox_open(mbox_O2) == MBOX_FAIL) {
    Printf("Error cannot open O2 mailbox in %s\n", argv[0]);
    Exit();
  }
  // open C2 mailbox
  if (mbox_open(mbox_C2) == MBOX_FAIL) {
    Printf("Error cannot open C2 mailbox in %s\n", argv[0]);
    Exit();
  }
  // open SO4 mailbox
  if (mbox_open(mbox_SO4) == MBOX_FAIL) {
    Printf("Error cannot open C2 mailbox in %s\n", argv[0]);
    Exit();
  }
  // Open the mailbox
  if(mbox_open(mbox_proc_completed) == MBOX_FAIL){
    Printf("Error unable to open Mailbox");
    Exit();
  }

  // Setup the command-line arguments for the new process.  We're going to
  // pass the handles to the shared memory page and the semaphore as strings
  // on the command line, so we must first convert them from ints to strings.
  ditoa(mbox_C2, mbox_C2_str);
  ditoa(mbox_CO, mbox_CO_str);
  ditoa(mbox_O2, mbox_O2_str);
  ditoa(mbox_S2, mbox_S2_str);
  ditoa(mbox_S, mbox_S_str);
  ditoa(mbox_SO4, mbox_SO4_str);
  ditoa(mbox_proc_completed, mbox_proc_completed_str);

  // Now we can create the processes.  Note that you MUST end your call to
  // process_create with a NULL argument so that the operating system
  // knows how many arguments you are sending.
  for (i = 0; i < num_inj_S2_run; i++){
    process_create("inj_S2.dlx.obj", 0, 0, mbox_S2_str,  mbox_proc_completed_str, NULL);
  }
  for (i = 0; i < num_inj_CO_run; i++) {
    process_create("inj_CO.dlx.obj", 0, 0, mbox_CO_str,  mbox_proc_completed_str, NULL);
  }
  for (i = 0; i < num_reac_S_run;i++){
    process_create("reac_S.dlx.obj", 0, 0, mbox_S2_str, mbox_S_str, mbox_proc_completed_str,  NULL);
  }
  for (i = 0; i < num_reac_O2_C2_run; i++) {
    process_create("reac_O2_C2.dlx.obj", 0, 0, mbox_CO_str, mbox_O2_str,mbox_C2_str, mbox_proc_completed_str, NULL);
  }
  for (i = 0; i < num_reac_SO4_run; i++) {
    process_create("reac_SO4.dlx.obj", 0, 0, mbox_S_str, mbox_O2_str, mbox_SO4_str, mbox_proc_completed_str,  NULL);
  }
  
  // make the process to sleep if it hasn't finished
  procCount = num_inj_CO_run + num_inj_S2_run + num_reac_S_run + num_reac_O2_C2_run + num_reac_SO4_run;
  for(i = 0; i < procCount ; i++) {
      mbox_recv(mbox_proc_completed, 9,  &tmp);
  }
  //close all the mailboxes
  if (mbox_close(mbox_proc_completed) == MBOX_FAIL) {
    Printf("Error cannot close proc mailbox in %s\n", argv[0]);
    Exit();
  }

  if (mbox_close(mbox_CO) == MBOX_FAIL) {
    Printf("Error cannot close CO mailbox in %s\n", argv[0]);
    Exit();
  }
 
  if (mbox_close(mbox_O2) == MBOX_FAIL) {
    Printf("Error cannot close O2 mailbox in %s\n", argv[0]);
    Exit();
  }
  
  if (mbox_close(mbox_C2) == MBOX_FAIL) {
    Printf("Error cannot close C2 mailbox in %s\n", argv[0]);
    Exit();
  }
 
  if (mbox_close(mbox_S2) == MBOX_FAIL) {
      Printf("Error cannot close S2 mailbox in %s\n", argv[0]);
      Exit();
  }
  if (mbox_close(mbox_S) == MBOX_FAIL) {
      Printf("Error cannot close S mailbox in %s\n", argv[0]);
      Exit();
  }
  if (mbox_close(mbox_SO4) == MBOX_FAIL) {
      Printf("Error cannot close SO4 mailbox in %s\n", argv[0]);
      Exit();
  }
  Printf("%d S2's left over. ", S2_left);
  Printf("%d S's left over. ", S_left);
  Printf("%d CO's left over. ", CO_left);
  Printf("%d O2's left over. ", O2_left);
  Printf("%d C2's left over. ", C2_left);
  Printf("%d SO4's created. \n", num_reac_SO4_run);
  Printf("All other processes completed, exiting main process.\n");
}