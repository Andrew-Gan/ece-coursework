#ifndef	_memory_h_
#define	_memory_h_

// Put all your #define's in memory_constants.h
#include "memory_constants.h"

extern int lastosaddress; // Defined in an assembly file

//--------------------------------------------------------
// Existing function prototypes:
//--------------------------------------------------------
inline uint32 invert (uint32 n);
int MemoryGetSize();
void MemoryModuleInit();
uint32 MemoryTranslateUserToSystem (PCB *pcb, uint32 addr);
int MemoryMoveBetweenSpaces (PCB *pcb, unsigned char *system, unsigned char *user, int n, int dir);
int MemoryCopySystemToUser (PCB *pcb, unsigned char *from, unsigned char *to, int n);
int MemoryCopyUserToSystem (PCB *pcb, unsigned char *from, unsigned char *to, int n);
int MemoryPageFaultHandler(PCB *pcb);

//---------------------------------------------------------
// Put your function prototypes here
//---------------------------------------------------------
// All function prototypes including the malloc and mfree functions go here
inline uint32 MemorySetupPte (uint32 page_num);
int MemoryAllocPage(void);
uint32 MemorySetupPte (uint32 page_num);
void MemoryFreePage(uint32 page_num);
void MemoryFreePte (uint32 pte);
void* malloc(int memsize);
int mfree(void* ptr);
void buildTree(MemNode* root, int currentOffs, short* ptr);
int allocateNode(MemNode* root, int currentOffs, short* ptr, uint32 requested_size, int order);
int freeNode(MemNode* root, int currentOffs, uint32 addr, int order);
#endif	// _memory_h_
