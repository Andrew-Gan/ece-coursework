//
//	memory.c
//
//	Routines for dealing with memory management.

//static char rcsid[] = "$Id: memory.c,v 1.1 2000/09/20 01:50:19 elm Exp elm $";

#include "ostraps.h"
#include "dlxos.h"
#include "process.h"
#include "memory.h"
#include "queue.h"

static uint32 freemap[MEM_FREEMAP_SIZE];
static uint32 pagestart;
static int nfreepages;
static int freemapmax;

// map reference counter
static int pageReferenceCounter[MEM_L1FIELD_PAGE_TABLE_SIZE];

//----------------------------------------------------------------------
//
//	This silliness is required because the compiler believes that
//	it can invert a number by subtracting it from zero and subtracting
//	an additional 1.  This works unless you try to negate 0x80000000,
//	which causes an overflow when subtracted from 0.  Simply
//	trying to do an XOR with 0xffffffff results in the same code
//	being emitted.
//
//----------------------------------------------------------------------
static int negativeone = 0xFFFFFFFF;
inline uint32 invert (uint32 n) {
  return (n ^ negativeone);
}

//----------------------------------------------------------------------
//
//	MemoryGetSize
//
//	Return the total size of memory in the simulator.  This is
//	available by reading a special location.
//
//----------------------------------------------------------------------
int MemoryGetSize() {
  return (*((int *)DLX_MEMSIZE_ADDRESS));
}

inline
void
MemorySetFreemap (int page_num, int bitset)
{
  uint32	which_freemap_index = page_num / 32;
  uint32	bitnum = page_num % 32;

  freemap[which_freemap_index] = (freemap[which_freemap_index] & invert((uint32)1 << bitnum)) | (bitset << bitnum);
  dbprintf ('m', "Set freemap entry %d to 0x%x.\n",
	    which_freemap_index, freemap[which_freemap_index]);
}

//----------------------------------------------------------------------
//
//	MemoryModuleInit
//
//	Initialize the memory module of the operating system.
//      Basically just need to setup the freemap for pages, and mark
//      the ones in use by the operating system as "VALID", and mark
//      all the rest as not in use.
//
//----------------------------------------------------------------------
void MemoryModuleInit() {
  int i;
  int curpage;
  
  // find the page for user program to start, 
  // minus 4 to make sure it's 4 byte aligned
  pagestart = ((lastosaddress + MEM_PAGESIZE) & invert((uint32) 0x3)) / MEM_PAGESIZE; 
  dbprintf ('m', "Map has %d entries, memory size is 0x%x.\n",
	    freemapmax, MEM_MAX_SIZE / MEM_PAGESIZE);
  dbprintf ('m', "Free pages start with page # 0x%x.\n", pagestart);
  
  
  //Intialize all the freemap by setting all pages to used
  for (i = 0; i < MEM_FREEMAP_SIZE; i++) {
    pageReferenceCounter[i] += 1;
    freemap[i] = PAGE_IN_USE;
  }
  nfreepages = 0;
  
  // set all pages not used by OS as not in use
  for (curpage = pagestart; curpage < (MEM_MAX_SIZE / MEM_PAGESIZE); curpage++) {
    nfreepages += 1;
    MemorySetFreemap(curpage, PAGE_NOT_IN_USE);
  }
  dbprintf ('m', "Initialized %d free pages.\n", nfreepages);
}


//----------------------------------------------------------------------
//
// MemoryTranslateUserToSystem
//
//	Translate a user address (in the process referenced by pcb)
//	into an OS (physical) address.  Return the physical address.
//
//----------------------------------------------------------------------
uint32 MemoryTranslateUserToSystem (PCB *pcb, uint32 addr) {
  // get page number and offset within page from address
  int	virtual_page_num = addr >> MEM_L1FIELD_FIRST_BITNUM;
  int offset = addr & (MEM_PAGESIZE - 1);

  // Check if the addr is greater than max virtual address
  if(addr > MEM_MAX_VIRTUAL_ADDRESS){
    printf("FATAL ERROR: In  MemoryTranslateUserToSystem given address is larger
            than max virtual address\n");
    ProcessKill();
    return MEM_FAIL;
  }

  if((pcb->pagetable[virtual_page_num] & MEM_PTE_VALID) == 0)
  {
    dbprintf('m',"Page Fault when translating!\n");
    MemoryPageFaultHandler(pcb);
  }

  // remove status bits from pte and return only page + offset
  dbprintf('m',"Translated User to Physical 0x%x  \n",addr);
  dbprintf('m',"The pagetable value is %x \n",pcb->pagetable[virtual_page_num]);
  return ((pcb->pagetable[virtual_page_num] & MEM_PTE_MASK) | offset);
}

//----------------------------------------------------------------------
//
//	MemoryMoveBetweenSpaces
//
//	Copy data between user and system spaces.  This is done page by
//	page by:
//	* Translating the user address into system space.
//	* Copying all of the data in that page
//	* Repeating until all of the data is copied.
//	A positive direction means the copy goes from system to user
//	space; negative direction means the copy goes from user to system
//	space.
//
//	This routine returns the number of bytes copied.  Note that this
//	may be less than the number requested if there were unmapped pages
//	in the user range.  If this happens, the copy stops at the
//	first unmapped address.
//
//----------------------------------------------------------------------
int MemoryMoveBetweenSpaces (PCB *pcb, unsigned char *system, unsigned char *user, int n, int dir) {
  unsigned char *curUser;         // Holds current physical address representing user-space virtual address
  int		bytesCopied = 0;  // Running counter
  int		bytesToCopy;      // Used to compute number of bytes left in page to be copied

  while (n > 0) {
    // Translate current user page to system address.  If this fails, return
    // the number of bytes copied so far.
    curUser = (unsigned char *)MemoryTranslateUserToSystem (pcb, (uint32)user);

    // If we could not translate address, exit now
    if (curUser == (unsigned char *)0) break;

    // Calculate the number of bytes to copy this time.  If we have more bytes
    // to copy than there are left in the current page, we'll have to just copy to the
    // end of the page and then go through the loop again with the next page.
    // In other words, "bytesToCopy" is the minimum of the bytes left on this page 
    // and the total number of bytes left to copy ("n").

    // First, compute number of bytes left in this page.  This is just
    // the total size of a page minus the current offset part of the physical
    // address.  MEM_PAGESIZE should be the size (in bytes) of 1 page of memory.
    // MEM_ADDRESS_OFFSET_MASK should be the bit mask required to get just the
    // "offset" portion of an address.
    bytesToCopy = MEM_PAGESIZE - ((uint32)curUser & MEM_ADDRESS_OFFSET_MASK);
    
    // Now find minimum of bytes in this page vs. total bytes left to copy
    if (bytesToCopy > n) {
      bytesToCopy = n;
    }

    // Perform the copy.
    if (dir >= 0) {
      bcopy (system, curUser, bytesToCopy);
    } else {
      bcopy (curUser, system, bytesToCopy);
    }

    // Keep track of bytes copied and adjust addresses appropriately.
    n -= bytesToCopy;           // Total number of bytes left to copy
    bytesCopied += bytesToCopy; // Total number of bytes copied thus far
    system += bytesToCopy;      // Current address in system space to copy next bytes from/into
    user += bytesToCopy;        // Current virtual address in user space to copy next bytes from/into
  }
  return (bytesCopied);
}

//----------------------------------------------------------------------
//
//	These two routines copy data between user and system spaces.
//	They call a common routine to do the copying; the only difference
//	between the calls is the actual call to do the copying.  Everything
//	else is identical.
//
//----------------------------------------------------------------------
int MemoryCopySystemToUser (PCB *pcb, unsigned char *from,unsigned char *to, int n) {
  return (MemoryMoveBetweenSpaces (pcb, from, to, n, 1));
}

int MemoryCopyUserToSystem (PCB *pcb, unsigned char *from,unsigned char *to, int n) {
  return (MemoryMoveBetweenSpaces (pcb, to, from, n, -1));
}

//---------------------------------------------------------------------
// MemoryPageFaultHandler is called in traps.c whenever a page fault 
// (better known as a "seg fault" occurs.  If the address that was
// being accessed is on the stack, we need to allocate a new page 
// for the stack.  If it is not on the stack, then this is a legitimate
// seg fault and we should kill the process.  Returns MEM_SUCCESS
// on success, and kills the current process on failure.  Note that
// fault_address is the beginning of the page of the virtual address that 
// caused the page fault, i.e. it is the vaddr with the offset zero-ed
// out.
//
// Note: The existing code is incomplete and only for reference. 
// Feel free to edit.
//---------------------------------------------------------------------
int MemoryPageFaultHandler(PCB *pcb) {
  
  uint32 fault_address;
  uint32 user_stack_ptr;
  uint32 pagenum_fault_addr;
  uint32 pagenum_user_stack;
  uint32 physical_pagenum_allocated; 

  dbprintf('m', "Entering Memory page fault..\n");

  //grab faulting addr (the comments mentioned it's offset 0 ?)
  fault_address = pcb->currentSavedFrame[PROCESS_STACK_FAULT];
  //get user stack address
  user_stack_ptr = pcb->currentSavedFrame[PROCESS_STACK_USER_STACKPOINTER];
  // find pagenum for faulting address
  pagenum_fault_addr = fault_address >> MEM_L1FIELD_FIRST_BITNUM;
  // find pagenum for the user stack
  pagenum_user_stack = user_stack_ptr >> MEM_L1FIELD_FIRST_BITNUM;

  // if it's segfault,  
  if(pagenum_fault_addr < pagenum_user_stack){
    printf("FATAL ERROR: SEGFAULT! Exiting Process! \n");
    ProcessKill();
    return MEM_FAIL;
  }

    //allocate page
   physical_pagenum_allocated = MemoryAllocPage();
    //if physical page is full
    if(physical_pagenum_allocated == MEM_FAIL) 
    {
      ProcessKill();
      printf("FATAL: not enough physical memory to be allocated! \n");
      return MEM_FAIL;
    }
    // it's not full
    dbprintf('m',"Allocated physical memory, with page number: %d\n",physical_pagenum_allocated);
    // assign the page to page table
    pcb->pagetable[pagenum_fault_addr] = MemorySetupPte(physical_pagenum_allocated);
    // allocated one more page
    pcb->npages++;

    return MEM_SUCCESS;
 
}

//---------------------------------------------------------------------
// You may need to implement the following functions and access them from process.c
// Feel free to edit/remove them
//---------------------------------------------------------------------

int MemoryAllocPage(void) {
  static int	mapnum = 0;
  int		bitnum;
  uint32  available_freemap;
  uint32	available_page_index;

  //if there is no free page
  if (nfreepages == 0) {
    return MEM_FAIL;
  }
  dbprintf ('m', "Allocating memory, starting with page %d\n", mapnum);
  // loop through freemap to search for page not in use
  while (freemap[mapnum] == PAGE_IN_USE) {
    mapnum += 1;
    if (mapnum >= MEM_FREEMAP_SIZE) mapnum = 0;
  }
  //Found the available freemap!
  available_freemap = freemap[mapnum];
  // Find exact bit in uint32 that represents the page not in use
  for (bitnum = 0; (available_freemap & (1 << bitnum)) == 0; bitnum++) {
  }
  //clear the freemap bit as inused
  freemap[mapnum] &= invert((uint32)(PAGE_NOT_IN_USE << bitnum));
  //convert it to page index
  available_page_index = (mapnum * 32) + bitnum;
  dbprintf ('m', "Allocated memory, from map %d, page %d, map=0x%x.\n",
	    mapnum, available_page_index, freemap[mapnum]);
  // decrease number of free pages
  nfreepages -= 1;
  pageReferenceCounter[available_page_index] += 1;
  return available_page_index;
}

//----------------------------------------------------------------------
//
// MemoryFreePte
//
//      Free a page given its PTE.
//
//----------------------------------------------------------------------
void
MemoryFreePte (uint32 pte)
{
  MemoryFreePage (pte >> MEM_L1FIELD_FIRST_BITNUM);
}



//----------------------------------------------------------------------
//
// MemorySetupPte
//
//	Set up a PTE given a page number.
//
//----------------------------------------------------------------------
uint32 MemorySetupPte (uint32 page_num) {
  pageReferenceCounter[page_num] += 1;
  return ((page_num << MEM_L1FIELD_FIRST_BITNUM) | MEM_PTE_VALID);
}

//----------------------------------------------------------------------
//
//	MemoryFreePage
//
//	Free a page of memory.
//
//----------------------------------------------------------------------
void MemoryFreePage(uint32 page_num) {
  pageReferenceCounter[page_num] -= 1;
  // set page to not in use
  if(pageReferenceCounter[page_num] <= 0) {
    MemorySetFreemap(page_num, PAGE_NOT_IN_USE);
    nfreepages += 1;
  }

  dbprintf ('m',"Freed page 0x%x, %d remaining.\n", page_num, nfreepages);
}

int MemoryROPAccessHandler(PCB *pcb) {
  int i = 0;
  uint32 pagenum;
  int intrs;
  uint32 src_physical_addr;
  uint32 des_physical_addr;

  dbprintf('a', "(pid: %d) Entering MemoryROPAccessHandler()\n", GetCurrentPid());

  pagenum = pcb->currentSavedFrame[PROCESS_STACK_FAULT] >> MEM_L1FIELD_FIRST_BITNUM;

  // // something is wrong if reference count is 0
  // if(pageReferenceCounter[pagenum] == 0) {
  //   printf("Error (PID: %d, pagenum: %d): Unreferenced page being accessed in MemoryROPAccessHandler\n", GetCurrentPid(), pagenum);
  //   // exitsim();
  // }

  dbprintf('a', "(pid: %d) Allocating new pages in MemoryROPAccessHandler()\n", GetCurrentPid());

  if (pageReferenceCounter[pagenum] > 1) {
    // duplicate page and replace PTE set to read/write if reference count is > 1
    src_physical_addr = (pcb->pagetable[pagenum] & MEM_PTE_MASK);

    pcb->pagetable[pagenum] = MemorySetupPte(MemoryAllocPage());

    des_physical_addr = (pcb->pagetable[pagenum] & MEM_PTE_MASK);
    bcopy((char*) src_physical_addr, (char*) des_physical_addr, MEM_PAGESIZE);

    pageReferenceCounter[pagenum] -= 1;
  }
  
  pcb->pagetable[pagenum] &= ~MEM_PTE_READONLY;

  dbprintf('a', "(pid: %d) Exiting MemoryROPAccessHandler()\n", GetCurrentPid());

  return MEM_SUCCESS;
}

void* malloc(int size){
  return 0;
}

int mfree(void* ptr){
  return 0;
}