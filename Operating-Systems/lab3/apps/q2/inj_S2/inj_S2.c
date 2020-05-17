#include "usertraps.h"
#include "misc.h"

void main(int argc, char** argv) {
  mbox_t mbox_S2;                 // Semaphore used for SO4
  mbox_t mbox_proc_completed;       // Semaphore for process completed

  if (argc != 3) { 
    Printf("Usage: "); Printf(argv[0]);
    Exit();
  } 

  // Convert the command-line strings into integers for use as handles
  mbox_S2 = dstrtol(argv[1], NULL, 10);
  mbox_proc_completed = dstrtol(argv[2], NULL, 10);
  // open S2 mailbox 
  if (mbox_open(mbox_S2) == MBOX_FAIL) {
      Printf("Error cannot open mailbox in %s\n", argv[0]);
      Exit();
  }
  // release 1 CO molecule
  if(mbox_send(mbox_S2, 2, "S2") == MBOX_FAIL){
    Printf("Error cannot send mailbox in %s\n", argv[0]);
    Exit();
  }
  // close S2 mailbox
  if (mbox_close(mbox_S2) == MBOX_FAIL) {
      Printf("Error cannot close S2 mailbox in %s\n", argv[0]);
      Exit();
  }
  Printf("S2 is injected into Radeon atmosphere, PID: %d\n", getpid());

   // Open the mailbox
  if(mbox_open(mbox_proc_completed) == MBOX_FAIL){
    Printf("Error unable to open Mailbox");
    Exit();
  }

  // Send to notify the process we finish
  if (mbox_send(mbox_proc_completed, 9, "Completed") == MBOX_FAIL) {
    Printf("Error cannot complete process in %s\n", argv[0]);
    Exit();
  }
  // close mailbox
  if (mbox_close(mbox_proc_completed) == MBOX_FAIL) {
    Printf("Error cannot close proc mailbox in %s\n", argv[0]);
    Exit();
  }
}