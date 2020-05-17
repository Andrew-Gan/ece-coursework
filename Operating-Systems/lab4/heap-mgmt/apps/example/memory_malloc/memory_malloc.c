#include "usertraps.h"
#include "misc.h"

void main (int argc, char *argv[])
{
  int i;
  int malloc_size;
  sem_t s_procs_completed; // Semaphore to signal the original process that we're done
  char* ptr1;
  char* ptr2;
  char* ptr3;
  char* ptr4;
  char* ptr5;
  char* ptr6;

  if (argc != 3) { 
    Printf("Usage: %s <handle_to_procs_completed_semaphore> <malloc size>\n"); 
    Exit();
  } 

  // Convert the command-line strings into integers for use as handles
  s_procs_completed = dstrtol(argv[1], NULL, 10);
  malloc_size = dstrtol(argv[2], NULL, 10);

//   Printf("-----------------------------------------------------------------------------\n");
//   Printf("Attempting to malloc a block of memory in heap of size %d\n\n", 32);
//   // Now print a message to show that everything worked
//   ptr1 = malloc(32);
//   if(ptr1 == NULL) Printf("Error: unable to allocate memory in %s\n", argv[0]);

  Printf("-----------------------------------------------------------------------------\n");
  Printf("Attempting to malloc a block of memory in heap of size %d\n\n", 64);
  // Now print a message to show that everything worked
  ptr1 = malloc(64);
  if(ptr1 == NULL) Printf("Error: unable to allocate memory in %s\n", argv[0]);

  Printf("-----------------------------------------------------------------------------\n");
  Printf("Attempting to malloc a block of memory in heap of size %d\n\n", 128);
  // Now print a message to show that everything worked
  ptr2 = malloc(128);
  if(ptr2 == NULL) Printf("Error: unable to allocate memory in %s\n", argv[0]);

  Printf("-----------------------------------------------------------------------------\n");
  Printf("Attempting to malloc a block of memory in heap of size %d\n\n", 256);
  // Now print a message to show that everything worked
  ptr3 = malloc(256);
  if(ptr3 == NULL) Printf("Error: unable to allocate memory in %s\n", argv[0]);

  Printf("-----------------------------------------------------------------------------\n");
  Printf("Attempting to malloc a block of memory in heap of size %d\n\n", 512);
  // Now print a message to show that everything worked
  ptr4 = malloc(512);
  if(ptr4 == NULL) Printf("Error: unable to allocate memory in %s\n", argv[0]);

  Printf("-----------------------------------------------------------------------------\n");
  Printf("Attempting to malloc a block of memory in heap of size %d\n\n", 1024);
  // Now print a message to show that everything worked
  ptr5 = malloc(1024);
  if(ptr5 == NULL) Printf("Error: unable to allocate memory in %s\n", argv[0]);

  Printf("-----------------------------------------------------------------------------\n");
  Printf("Attempting to malloc a block of memory in heap of size %d\n\n", 2000);
  // Now print a message to show that everything worked
  ptr6 = malloc(2000);
  if(ptr6 == NULL) Printf("Error: unable to allocate memory in %s\n", argv[0]);

  Printf("-----------------------------------------------------------------------------\n");
  Printf("Attempting to free a block of memory in heap with address\n\n");

  if(mfree(ptr1) == -1) Printf("Error: unable to free memory in %s\n", argv[0]);

  Printf("-----------------------------------------------------------------------------\n");
  Printf("Attempting to free a block of memory in heap with address\n\n");

  if(mfree(ptr2) == -1) Printf("Error: unable to free memory in %s\n", argv[0]);

  Printf("-----------------------------------------------------------------------------\n");
  Printf("Attempting to free a block of memory in heap with address\n\n");

  if(mfree(ptr3) == -1) Printf("Error: unable to free memory in %s\n", argv[0]);

  Printf("-----------------------------------------------------------------------------\n");
  Printf("Attempting to free a block of memory in heap with address\n\n");

  if(mfree(ptr4) == -1) Printf("Error: unable to free memory in %s\n", argv[0]);

  Printf("-----------------------------------------------------------------------------\n");
  Printf("Attempting to free a block of memory in heap with address\n\n");

  if(mfree(ptr5) == -1) Printf("Error: unable to free memory in %s\n", argv[0]);

  Printf("-----------------------------------------------------------------------------\n");
  Printf("Attempting to free a block of memory in heap with address\n\n");

  if(mfree(ptr6) == -1) Printf("Error: unable to free memory in %s\n", argv[0]);

  // Signal the semaphore to tell the original process that we're done
  if(sem_signal(s_procs_completed) != SYNC_SUCCESS) {
    Printf("memory_malloc (%d): Bad semaphore s_procs_completed (%d)!\n", getpid(), s_procs_completed);
    Exit();
  }

  Printf("memory_malloc (%d): Done!\n", getpid());
}