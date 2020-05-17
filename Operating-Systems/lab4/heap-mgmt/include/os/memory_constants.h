#ifndef	_memory_constants_h_
#define	_memory_constants_h_

//------------------------------------------------
// #define's that you are given:
//------------------------------------------------

// We can read this address in I/O space to figure out how much memory
// is available on the system.
#define	DLX_MEMSIZE_ADDRESS	0xffff0000

// Return values for success and failure of functions
#define MEM_SUCCESS 1
#define MEM_FAIL -1

//--------------------------------------------------------
// Put your constant definitions related to memory here.
// Be sure to prepend any constant names with "MEM_" so 
// that the grader knows they are defined in this file.

//--------------------------------------------------------
#define MEM_L1FIELD_FIRST_BITNUM    12                  // page number (20 bit) | page offset (12 bit)
#define MEM_MAX_VIRTUAL_ADDRESS     0xfffff             // (1 MB)   -> (2^20 - 1)
#define MEM_MAX_SIZE                0x200000            // (2 MB)   -> (2 * 2^20)
#define MEM_PTE_READONLY            0x4                 // if set, page cannot be manipulated
#define MEM_PTE_DIRTY               0x2                 // if set, page is manipulated and must be written back to virtual address
#define MEM_PTE_VALID               0x1                 // if set, virtual page is allocated a physical page
#define MEM_PAGESIZE                0x1000              // (4 kB)   -> (4 * 2^10)
#define MEM_ADDRESS_OFFSET_MASK     MEM_PAGESIZE - 1    // mask bits to obtain page offset in address
#define MEM_L1FIELD_PAGE_TABLE_SIZE (MEM_MAX_VIRTUAL_ADDRESS + 1) >> MEM_L1FIELD_FIRST_BITNUM
#define MEM_PAGE_OFFSET_MASK        MEM_PAGESIZE - 1
#define MEM_PTE_MASK                ~(MEM_PTE_READONLY | MEM_PTE_DIRTY | MEM_PTE_VALID)
#define MEM_FREEMAP_SIZE            ((MEM_MAX_SIZE / MEM_PAGESIZE) + 31) / 32
#define MEM_HEAP_BUDDY_SIZE         0x20                // smallest unit of memory in buddy memory
#define PAGE_IN_USE                 0
#define PAGE_NOT_IN_USE             1
#define MEM_HEAP_MAX_ADDRESS        0x4fff

#endif	// _memory_constants_h_
