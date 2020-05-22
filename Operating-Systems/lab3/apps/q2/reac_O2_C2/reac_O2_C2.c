#include "usertraps.h"
#include "misc.h"

void main(int argc, char** argv) {
  mbox_t mbox_CO;                 // mailbox used for S2
  mbox_t mbox_O2;
  mbox_t mbox_C2;
  mbox_t mbox_proc_completed;       // mailbox for process completed
  char tmp[2];

  if (argc != 5) {
    Printf("Usage: "); Printf(argv[0]);
    Exit();
  }

  // Convert the command-line strings into integers for use as handles
  mbox_CO = dstrtol(argv[1], NULL, 10);
  mbox_O2 = dstrtol(argv[2], NULL, 10);
  mbox_C2 = dstrtol(argv[3], NULL, 10);
  mbox_proc_completed= dstrtol(argv[4], NULL, 10);


  // open the CO mailbox
  if (mbox_open(mbox_CO) == MBOX_FAIL) {
    Printf("Error cannot open mailbox in %s\n", argv[0]);
    Exit();
  }
  // consume 4 CO molecule
  if (mbox_recv(mbox_CO, 2, tmp) == MBOX_FAIL) {
    Printf("Error cannot receive CO mailbox in %s\n", argv[0]);
    Exit();
  }
  if (mbox_recv(mbox_CO, 2, tmp) == MBOX_FAIL) {
    Printf("Error cannot receive CO mailbox in %s\n", argv[0]);
    Exit();
  }
  if (mbox_recv(mbox_CO, 2, tmp) == MBOX_FAIL) {
    Printf("Error cannot receive CO mailbox in %s\n", argv[0]);
    Exit();
  }
  if (mbox_recv(mbox_CO, 2, tmp) == MBOX_FAIL) {
    Printf("Error cannot receive CO mailbox in %s\n", argv[0]);
    Exit();
  }
  // close CO mailbox
  if (mbox_close(mbox_CO) == MBOX_FAIL) {
    Printf("Error cannot close CO mailbox in %s\n", argv[0]);
    Exit();
  }
  // open O2 mailbox
  if (mbox_open(mbox_O2) == MBOX_FAIL) {
    Printf("Error cannot open O2 mailbox in %s\n", argv[0]);
    Exit();
  }
  // release  2 O2 S molecule
  if(mbox_send(mbox_O2, 2, "O2") == MBOX_FAIL){
    Printf("Error cannot send O2 mailbox in %s\n", argv[0]);
    Exit();
  }
  if(mbox_send(mbox_O2, 2, "O2") == MBOX_FAIL){
    Printf("Error cannot send O2 mailbox in %s\n", argv[0]);
    Exit();
  }
  // close O2 mailbox
  if (mbox_close(mbox_O2) == MBOX_FAIL) {
    Printf("Error cannot close O2 mailbox in %s\n", argv[0]);
    Exit();
  }
  // open C2 mailbox
  if (mbox_open(mbox_C2) == MBOX_FAIL) {
    Printf("Error cannot open C2 mailbox in %s\n", argv[0]);
    Exit();
  }
  // release 2 C2 molecule
  if(mbox_send(mbox_C2, 2, "C2") == MBOX_FAIL){
    Printf("Error cannot send C2 mailbox in %s\n", argv[0]);
    Exit();
  }
  if(mbox_send(mbox_C2, 2, "C2") == MBOX_FAIL){
    Printf("Error cannot send C2 mailbox in %s\n", argv[0]);
    Exit();
  }
  // close C2 mailbox
  if (mbox_close(mbox_C2) == MBOX_FAIL) {
    Printf("Error cannot close C2 mailbox in %s\n", argv[0]);
    Exit();
  }

  Printf("2O2 + 2C2 are released into Radeon atmosphere, PID: %d\n", getpid());

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