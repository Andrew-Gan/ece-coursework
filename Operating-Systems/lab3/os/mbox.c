#include "ostraps.h"
#include "dlxos.h"
#include "process.h"
#include "synch.h"
#include "queue.h"
#include "mbox.h"


mbox mboxes[MBOX_NUM_MBOXES];
mbox_message mbox_messages[MBOX_NUM_BUFFERS];

//-------------------------------------------------------
//
// void MboxModuleInit();
//
// Initialize all mailboxes.  This process does not need
// to worry about synchronization as it is called at boot
// time.  Only initialize necessary items here: you can
// initialize others in MboxCreate.  In other words, 
// don't waste system resources like locks and semaphores
// on unused mailboxes.
//
//-------------------------------------------------------

void MboxModuleInit() {
  int i;
  int j;
  for(i = 0; i < MBOX_NUM_MBOXES; i++) {
      mboxes[i].inuse = 0;
  }
  for(j = 0; j < MBOX_NUM_BUFFERS; j++) {
      mbox_messages[j].inuse = 0;
  }
  return; 
}


//-------------------------------------------------------
//
// mbox_t MboxCreate();
//
// Allocate an available mailbox structure for use. 
//
// Returns the mailbox handle on success
// Returns MBOX_FAIL on error.
//
//-------------------------------------------------------
mbox_t MboxCreate() {
  uint32 intrval;
  mbox_t mbox_handle;
  int p;
  //Disable interrupts
  intrval = DisableIntrs();
  // grab available mbox
  for(mbox_handle = 0; mbox_handle < MBOX_NUM_MBOXES; mbox_handle++) {
    if(mboxes[mbox_handle].inuse == 0) {
      mboxes[mbox_handle].inuse = 1;
      break;
    }
  }
  //Restore Interrupts
  RestoreIntrs(intrval);
  // if no unused mbox found
  if(mbox_handle == MBOX_NUM_MBOXES) return MBOX_FAIL;
  // attach lock
  mboxes[mbox_handle].lock_handle = LockCreate();
  // Create two condition variables
  mboxes[mbox_handle].notfull = CondCreate(mboxes[mbox_handle].lock_handle);
  if ( mboxes[mbox_handle].notfull == SYNC_FAIL){
    printf("FATAL ERROR: could not initialize conditional variable in MboxCreate\n");
    return MBOX_FAIL;
  }
  mboxes[mbox_handle].notempty = CondCreate(mboxes[mbox_handle].lock_handle);
  if ( mboxes[mbox_handle].notempty == SYNC_FAIL){
    printf("FATAL ERROR: could not initialize conditional variable in mBoxCreate\n");
    return MBOX_FAIL;
  }
  //Initialize Message queue
  if(AQueueInit(&(mboxes[mbox_handle].msg_queue)) != QUEUE_SUCCESS){
    printf("FATAL ERROR: could not initialize Mailbox message queue in MboxCreate\n");
    return MBOX_FAIL;
  }
  // check no process has opened mailbox
  for(p = 0; p < PROCESS_MAX_PROCS; p++) {
    if(mboxes[mbox_handle].arr_pid[p] != 0) return MBOX_FAIL;
  }
  return mbox_handle;
}

//-------------------------------------------------------
// 
// void MboxOpen(mbox_t);
//
// Open the mailbox for use by the current process.  Note
// that it is assumed that the internal lock/mutex handle 
// of the mailbox and the inuse flag will not be changed 
// during execution.  This allows us to get the a valid 
// lock handle without a need for synchronization.
//
// Returns MBOX_FAIL on failure.
// Returns MBOX_SUCCESS on success.
//
//-------------------------------------------------------
int MboxOpen(mbox_t handle) {
  //Get current pid
  int current_pid;
  current_pid = GetCurrentPid();
  // acquire lock for process
  if(LockHandleAcquire(mboxes[handle].lock_handle) == SYNC_FAIL) {
    printf("Error on acquiring the lock\n");
    return MBOX_FAIL;
  }
  // add to proc list
  mboxes[handle].arr_pid[current_pid] = 1;

  //release the lock
  if(LockHandleRelease(mboxes[handle].lock_handle) == SYNC_FAIL) {
    printf("Error on releasing the lock\n");
    return MBOX_FAIL;
  }
  return MBOX_SUCCESS;
}

//-------------------------------------------------------
//
// int MboxClose(mbox_t);
//
// Close the mailbox for use to the current process.
// If the number of processes using the given mailbox
// is zero, then disable the mailbox structure and
// return it to the set of available mboxes.
//
// Returns MBOX_FAIL on failure.
// Returns MBOX_SUCCESS on success.
//
//-------------------------------------------------------
int MboxClose(mbox_t handle) {
  
  int current_pid;
  int p;
  Link* l;
  //Get current pid
  current_pid = GetCurrentPid();
  // acquire lock for process
  if(LockHandleAcquire(mboxes[handle].lock_handle) == SYNC_FAIL) {
    printf("Error on acquiring the lock\n");
    return MBOX_FAIL;
  }
  // proc sanity check
  if(mboxes[handle].arr_pid[current_pid] == 0) return MBOX_FAIL;
  // remove from proc list
  mboxes[handle].arr_pid[current_pid] = 0;
  // check if other process using mbox, otherwise free resources
  for(p = 0; p < PROCESS_MAX_PROCS; p++) {
    //if an element is '1', break the loop and do not free the resources
    if(mboxes[handle].arr_pid[p] == 1) {
      break;
    }
    //else if all elements are 0, free the resources
    else if(p == PROCESS_MAX_PROCS - 1) {
      mboxes[handle].inuse = 0;
      while(!AQueueEmpty(&mboxes[handle].msg_queue)) {
        l = AQueueFirst(&mboxes[handle].msg_queue);
        AQueueRemove(&l);
      }
    }
  }
  
  //release the lock
  if(LockHandleRelease(mboxes[handle].lock_handle) == SYNC_FAIL) {
    printf("Error on releasing the lock\n");
    return MBOX_FAIL;
  }

  return MBOX_SUCCESS;
}

//-------------------------------------------------------
//
// int MboxSend(mbox_t handle,int length, void* message);
//
// Send a message (pointed to by "message") of length
// "length" bytes to the specified mailbox.  Messages of
// length 0 are allowed.  The call 
// blocks when there is not enough space in the mailbox.
// Messages cannot be longer than MBOX_MAX_MESSAGE_LENGTH.
// Note that the calling process must have opened the 
// mailbox via MboxOpen.
//
// Returns MBOX_FAIL on failure.
// Returns MBOX_SUCCESS on success.
//
//-------------------------------------------------------
int MboxSend(mbox_t handle, int length, void* message) {
  
  
  int intrval;
  int current_pid;
  int mbox_messages_handle;
  Link* l;
 
  // Get current pid
  current_pid = GetCurrentPid();
  // acquire lock for process
  if(LockHandleAcquire(mboxes[handle].lock_handle) == SYNC_FAIL) {
    printf("Error on acquiring the lock\n");
    return MBOX_FAIL;
  }
  // proc sanity check
  if(mboxes[handle].arr_pid[current_pid] == 0) return MBOX_FAIL;

  
  //if mbox is full, wait for notFull
  while(mboxes[handle].msg_queue.nitems == MBOX_MAX_BUFFERS_PER_MBOX) {
    CondHandleWait(mboxes[handle].notfull);
  }
  // disable interrupts
  intrval = DisableIntrs();
  // get unused buffer
  for(mbox_messages_handle = 0; mbox_messages_handle < MBOX_NUM_BUFFERS; mbox_messages_handle++) {
    if(mbox_messages[mbox_messages_handle].inuse == 0) {
      mbox_messages[mbox_messages_handle].inuse = 1;
      break;
    }
  }
  //restore interrupts
  RestoreIntrs(intrval);
  // set length and copy data
  mbox_messages[mbox_messages_handle].length = length;
  bcopy((char*)message, mbox_messages[mbox_messages_handle].buffer, length);
  // add to mbox_message to the link
  l = AQueueAllocLink(&mbox_messages[mbox_messages_handle]);
  // add the link to the queue
  AQueueInsertLast(&mboxes[handle].msg_queue,l);
  // signal not empty 
  CondHandleSignal(mboxes[handle].notempty);
  //Release the lock
  if(LockHandleRelease(mboxes[handle].lock_handle) == SYNC_FAIL) {
    printf("Error on releasing the lock\n");
    return MBOX_FAIL;
  }
  return MBOX_SUCCESS;
}

//-------------------------------------------------------
//
// int MboxRecv(mbox_t handle, int maxlength, void* message);
//
// Receive a message from the specified mailbox.  The call 
// blocks when there is no message in the buffer.  Maxlength
// should indicate the maximum number of bytes that can be
// copied from the buffer into the address of "message".  
// An error occurs if the message is larger than maxlength.
// Note that the calling process must have opened the mailbox 
// via MboxOpen.
//   
// Returns MBOX_FAIL on failure.
// Returns number of bytes written into message on success.
//
//-------------------------------------------------------
int MboxRecv(mbox_t handle, int maxlength, void* message) {
  
  Link *l;
  mbox_message* msg;
  int current_pid;
  current_pid = GetCurrentPid();

  // acquire lock for process
  if(LockHandleAcquire(mboxes[handle].lock_handle) == SYNC_FAIL) {
    printf("Error on acquiring the lock\n");
    return MBOX_FAIL;
  }

  // proc sanity check
  if(mboxes[handle].arr_pid[current_pid] == 0) return MBOX_FAIL;

  //if mbox is empty, wait for notEmpty
  while(mboxes[handle].msg_queue.nitems == 0) {
    CondHandleWait(mboxes[handle].notempty);
  }
  //Get the first element from the queue  
  l = AQueueFirst(&mboxes[handle].msg_queue);
  msg = (mbox_message*)(l->object);
  //An error occurs if the message is larger than maxlength.
  if(msg->length > maxlength){
    return MBOX_FAIL;
  }

  // copy the node's mboxes message to the target's process
  bcopy(msg->buffer, (char*)message, msg->length);

  //make the mbox messages available
  mbox_messages[handle].inuse = 0;
  // pop up the first node from the linked list
  AQueueRemove(&l);
  // signal not full 
  CondHandleSignal(mboxes[handle].notfull);
  //Release the lock
  if(LockHandleRelease(mboxes[handle].lock_handle) == SYNC_FAIL) {
    printf("Error on releasing the lock\n");
    return MBOX_FAIL;
  }
  // Returns number of bytes written into message on success.
  return msg->length;
}

//--------------------------------------------------------------------------------
// 
// int MboxCloseAllByPid(int pid);
//
// Scans through all mailboxes and removes this pid from their "open procs" list.
// If this was the only open process, then it makes the mailbox available.  Call
// this function in ProcessFreeResources in process.c.
//
// Returns MBOX_FAIL on failure.
// Returns MBOX_SUCCESS on success.
//
//--------------------------------------------------------------------------------
int MboxCloseAllByPid(int pid) {
  int i;
  int j;
 
  //loop through mailbox
  for(i = 0 ; i < MBOX_NUM_MBOXES; i++){
    // acquire lock for process
    if(LockHandleAcquire(mboxes[i].lock_handle) == SYNC_FAIL) {
      printf("Error on acquiring the lock\n");
      return MBOX_FAIL;
    }
    if(mboxes[i].arr_pid[pid] == 1) {
      mboxes[i].arr_pid[pid] = 0;
      //loop through the rest of the pid array 
      //to see if all elements are zero
      //if yes, set mbox.inuse = 0
      for(j = 0; j < PROCESS_MAX_PROCS; j++) {
        if(mboxes[i].arr_pid[j] == 1) {
          break;
        }
        else if (j == MBOX_NUM_MBOXES - 1){
          mboxes[i].inuse = 0;
          while(!AQueueEmpty(&mboxes[i].msg_queue)) {
            AQueueRemove(&mboxes[i].msg_queue.first);
          }
        }
      }
    }
    //Release the lock
    if(LockHandleRelease(mboxes[i].lock_handle) == SYNC_FAIL) {
      printf("Error on releasing the lock\n");
      return MBOX_FAIL;
    }
  }

  return MBOX_SUCCESS;
}

