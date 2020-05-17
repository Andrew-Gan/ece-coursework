#include "usertraps.h"
#include "misc.h"

void main(int argc, char** argv) {
  mbox_t mbox_S;                 // mailbox used for S2
  mbox_t mbox_O2;                // mailbox used for O2
  mbox_t mbox_SO4;               // mailbox used for SO4
  mbox_t mbox_proc_completed;    // mailbox for process completed
  char tmp[3];

  if (argc != 5) {
    Printf("Usage: "); Printf(argv[0]);
    Exit();
  }

  // Convert the command-line strings into integers for use as handles
  mbox_S = dstrtol(argv[1], NULL, 10);
  mbox_O2 = dstrtol(argv[2], NULL, 10);
  mbox_SO4 = dstrtol(argv[3], NULL, 10);
  mbox_proc_completed = dstrtol(argv[4], NULL, 10);
  
   // open S mailbox
  if (mbox_open(mbox_S) == MBOX_FAIL) {
      Printf("Error cannot open S mailbox in %s\n", argv[0]);
      Exit();
  }
  // consume 1 S molecule
  if (mbox_recv(mbox_S, 1, tmp) == MBOX_FAIL) {
      Printf("Error cannot receive S mailbox in %s\n", argv[0]);
      Exit();
  }
  // close S mailbox
  if (mbox_close(mbox_S) == MBOX_FAIL) {
      Printf("Error cannot close S mailbox in %s\n", argv[0]);
      Exit();
  }
  // open O2 mailbox
  if (mbox_open(mbox_O2) == MBOX_FAIL) {
    Printf("Error cannot open O2 mailbox in %s\n", argv[0]);
    Exit();
  }
  // consume 2 O2 molecule
  if(mbox_recv(mbox_O2, 2, tmp) == MBOX_FAIL){
    Printf("Error cannot send O2 mailbox in %s\n", argv[0]);
    Exit();
  }
  if(mbox_recv(mbox_O2, 2, tmp) == MBOX_FAIL){
    Printf("Error cannot send O2 mailbox in %s\n", argv[0]);
    Exit();
  }
  // close O2 mailbox
  if (mbox_close(mbox_O2) == MBOX_FAIL) {
    Printf("Error cannot close O2 mailbox in %s\n", argv[0]);
    Exit();
  }
  // open SO4 mailbox
  if (mbox_open(mbox_SO4) == MBOX_FAIL) {
    Printf("Error cannot open C2 mailbox in %s\n", argv[0]);
    Exit();
  }
  // release 1 SO4 molecule
  if(mbox_send(mbox_SO4, 3, tmp) == MBOX_FAIL){
    Printf("Error cannot send SO4 mailbox in %s\n", argv[0]);
    Exit();
  }
  // close SO4 mailbox
  if (mbox_close(mbox_SO4) == MBOX_FAIL) {
    Printf("Error cannot close SO4 mailbox in %s\n", argv[0]);
    Exit();
  }

  Printf("SO4 is released into Radeon atmosphere, PID: %d\n", getpid());
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