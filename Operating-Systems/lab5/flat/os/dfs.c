#include "ostraps.h"
#include "dlxos.h"
#include "traps.h"
#include "queue.h"
#include "disk.h"
#include "dfs.h"
#include "synch.h"

// any function must acquire lock before accessing these information
// inode array has been relocated to dfs.h for usage by files.c
static dfs_superblock sb; // superblock
static uint32 fbv[512]; // Free block vector
static char inode_buffer[192 * sizeof(dfs_inode)];
static disk_block disk_buffer;
static dfs_superblock superblock_buffer;
static dfs_block buffer;

static lock_t inode_lock;
static lock_t superblock_lock;
static lock_t fbv_lock;

static uint32 negativeone = 0xFFFFFFFF;
static inline uint32 invert(uint32 n) { return n ^ negativeone; }

// You should use locks when modifying shared data structures. Use locks in the following cases:
// whenever you allocate inodes and file descriptors
// whenever you allocate or deallocate file system blocks using the free block vector

// STUDENT: put your file system level functions below.
// Some skeletons are provided. You can implement additional functions.

int GetBlocksize() {
  int size;

  LockHandleAcquire(superblock_lock);
  size = sb.fs_blocksize;
  LockHandleRelease(superblock_lock);
  
  return size;
}

static int CheckInode(uint32 handle ){
  int num_of_inodes;
  
  dbprintf('d',"Checking inode %d \n",handle);
    
  LockHandleAcquire(superblock_lock);
  if(sb.valid == 0) {
    printf("Error in Checking Inode: filesystem is already closed!\n");
    LockHandleRelease(superblock_lock);
    return DFS_FAIL;
  }
  // here we will get the number of inodes
  num_of_inodes = sb.num_inodes;
  LockHandleRelease(superblock_lock);
 
  // check if handle is valid
  if(handle >= num_of_inodes) {
    printf("Error in Checking Inode: handle is invalid\n");
    return DFS_FAIL;
  }
  
  // get inode lock
  LockHandleAcquire(inode_lock);
  
  //if inode is inuse
  if(inodes[handle].inuse == 0) {
    printf("Error in Checking Inode: inode is not in use!\n");
    LockHandleRelease(inode_lock);
    return DFS_FAIL;
  }
  //Release Inode lock
  LockHandleRelease(inode_lock);
  return DFS_SUCCESS;
}

///////////////////////////////////////////////////////////////////
// Non-inode functions first
///////////////////////////////////////////////////////////////////

//-----------------------------------------------------------------
// DfsModuleInit is called at boot time to initialize things and
// open the file system for use.
//-----------------------------------------------------------------

void DfsModuleInit() {

// You essentially set the file system as invalid and then open 
// using DfsOpenFileSystem().
  dbprintf('d',"Entering DfsModuleInit\n");
  // create locks for accessing the inode 
  inode_lock = LockCreate();
  // create locks for accessing the superblock
  superblock_lock = LockCreate();
  // create locks for accessing the fbv
  fbv_lock = LockCreate();

  dbprintf('d',"Make sure we invalidating superblock %d\n",sb.valid);
  // open file system
  DfsOpenFileSystem();
  
  dbprintf('d',"Opened file system\n");
  dbprintf('d',"Leaving DfsModuleInit\n");
  
}

//-----------------------------------------------------------------
// DfsInavlidate marks the current version of the filesystem in
// memory as invalid.  This is really only useful when formatting
// the disk, to prevent the current memory version from overwriting
// what you already have on the disk when the OS exits.
//-----------------------------------------------------------------

void DfsInvalidate() {
// This is just a one-line function which sets the valid bit of the 
// superblock to 0.
  sb.valid = 0;
}

//-------------------------------------------------------------------
// DfsOpenFileSystem loads the file system metadata from the disk
// into memory.  Returns DFS_SUCCESS on success, and DFS_FAIL on 
// failure.
//-------------------------------------------------------------------

int DfsOpenFileSystem() {

  int i; //loop variable
  int j; //loop variable

  

//Basic steps:
//read if physical disk is not up to date first
  DiskReadBlock(1, &disk_buffer);
  bcopy(disk_buffer.data,(char *)&superblock_buffer, sizeof(superblock_buffer));
  if(superblock_buffer.valid == 0){
    printf("Physical disk is not up to date. The OS might crash before closing !\n");
  }
  
// Check that filesystem is not already open
  LockHandleAcquire(superblock_lock);
  if(sb.valid == 1) {
    printf("Error in DfsOpenFileSystem(): filesystem is already opened!\n");
    LockHandleRelease(superblock_lock);
    return DFS_FAIL;
  }
  LockHandleRelease(superblock_lock);

dbprintf('d',"Opening the DFS file system\n");
// Read superblock from disk.  Note this is using the disk read rather 
// than the DFS read function because the DFS read requires a valid 
// filesystem in memory already, and the filesystem cannot be valid 
// until we read the superblock. Also, we don't know the block size 
// until we read the superblock, either.
  

  // Copy the data from the block we just read into the superblock in memory
  DiskReadBlock(1, &disk_buffer);

  // acquire lock for superblock
  LockHandleAcquire(superblock_lock);
  bcopy((char *)&disk_buffer, (char *)&sb, sizeof(dfs_superblock));
  LockHandleRelease(superblock_lock);
  
  dbprintf('d',"superblock has valid value %d\n", (int)sb.valid);
  dbprintf('d',"superblock has fs_blocksize %d\n",(int)sb.fs_blocksize);
  dbprintf('d',"superblock has inode start fsblock num %d\n",sb.inode_start_fsblock_num);
  dbprintf('d',"superblock has number of inode %d\n",sb.num_inodes);
  dbprintf('d',"superblock has starting file system block num %d\n",sb.fbv_start_fsblock_num);
  
  // All other blocks are sized by virtual block size:

  // Read inodes
  LockHandleAcquire(inode_lock);
  j = 0;
  for(i = sb.inode_start_fsblock_num; i < sb.fbv_start_fsblock_num; i++) {
    DfsReadBlock(i, (dfs_block *)&inode_buffer[j * DFS_BLOCKSIZE]);
    j++;
  }
  bcopy(inode_buffer, (char*)inodes, 192 * sizeof(dfs_inode));
  LockHandleRelease(inode_lock);

  dbprintf('d',"Copied the inode\n");
  // Read free block vector
  LockHandleAcquire(fbv_lock);
  j = 0;
  // 1 file system block has 1024 bytes
  // each element in fbv[] is uint32 -> 32 bits -> 4 bytes
  // 256 fbv = 1024 bytes
  for(i = sb.fbv_start_fsblock_num; i < sb.data_start_fsblock_num; i++) {
    DfsReadBlock(i,  (dfs_block *) &fbv[j * 256]);
    j++;
  }
  LockHandleRelease(fbv_lock);
  

  // Change superblock to be invalid, write back to disk, then change 
  // it back to be valid in memory  
  LockHandleAcquire(superblock_lock);
  // set sb to invalid, and write it to disk
  DfsInvalidate();
  bcopy((char *)&sb, (char *)&disk_buffer, sizeof(dfs_superblock));
  
  DiskWriteBlock(1, &disk_buffer);

  // set memory version of sb to valid
  sb.valid = 1;
  dbprintf('d',"superblock has valid value after changed %d\n", (int)sb.valid);

  LockHandleRelease(superblock_lock);
  dbprintf('d', "Exiting DfsOpenFileSystem\n");
  return DFS_SUCCESS;
}


//-------------------------------------------------------------------
// DfsCloseFileSystem writes the current memory version of the
// filesystem metadata to the disk, and invalidates the memory's 
// version.
//-------------------------------------------------------------------

int DfsCloseFileSystem() {

  int i; //loop variable
  int j; //loop variable

//Basic steps:
  //read if physical disk is up to date first
  DiskReadBlock(1, &disk_buffer);
  bcopy(disk_buffer.data,(char *)&superblock_buffer, sizeof(superblock_buffer));
  if(superblock_buffer.valid == 1){
    printf("Physical disk is up to date already ! don't need to write anything!\n");
    printf("Exiting\n");
    return DFS_SUCCESS;
  }

  // Check that filesystem is not already open
  LockHandleAcquire(superblock_lock);
  if(sb.valid == 0) {
    printf("Error in DfsCloseFileSystem(): filesystem is already closed!\n");
    LockHandleRelease(superblock_lock);
    return DFS_FAIL;
  }
  LockHandleRelease(superblock_lock);


  dbprintf('d',"Closing the DFS file system\n");
  dbprintf('d',"superblock has valid value %d\n", (int)sb.valid);
  dbprintf('d',"superblock has fs_blocksize %d\n",(int)sb.fs_blocksize);
  dbprintf('d',"superblock has inode start fsblock num %d\n",sb.inode_start_fsblock_num);
  dbprintf('d',"superblock has number of inode %d\n",sb.num_inodes);
  dbprintf('d',"superblock has starting file system block num %d\n",sb.fbv_start_fsblock_num);
  
  // All other blocks are sized by virtual block size:
 

  // Read inodes
  LockHandleAcquire(inode_lock);
  //copy the inodes to buffer
  bcopy((char*)inodes, inode_buffer, sb.num_inodes * sizeof(dfs_inode));
  j = 0;
  for(i = sb.inode_start_fsblock_num; i < sb.fbv_start_fsblock_num; i++) {
    //send it to the file system block
    DfsWriteBlock(i,  (dfs_block *) &inode_buffer[j * DFS_BLOCKSIZE]);
    j++;
  }
  LockHandleRelease(inode_lock);

  dbprintf('d',"Sent the inode to file system block\n");
  // Write free block vector
  LockHandleAcquire(fbv_lock);
  j = 0;
  // write all fbv to file system block
  for(i = sb.fbv_start_fsblock_num; i < sb.data_start_fsblock_num; i++) {
    DfsWriteBlock(i,  (dfs_block *) &fbv[j * 256]);
    j++;
  }
  LockHandleRelease(fbv_lock);
  

  // Change superblock to be invalid, write back to disk, then change 
  // it back to be valid in memory  
  LockHandleAcquire(superblock_lock);
  
  // set sb to valid, and write it to disk
  sb.valid = 1;
  bcopy((char *)&sb, (char *)&disk_buffer, sizeof(dfs_superblock));
  // send the superblock back
  DiskWriteBlock(1, &disk_buffer);
  dbprintf('d',"Sent superblock back\n");
  // set memory version of sb to invalid
  DfsInvalidate();
  dbprintf('d',"superblock has valid value %d after closed\n", (int)sb.valid);

  LockHandleRelease(superblock_lock);
  dbprintf('d',"Closed the file system\n");
  return DFS_SUCCESS;
}


//-----------------------------------------------------------------
// DfsAllocateBlock allocates a DFS block for use. Remember to use 
// locks where necessary.
//-----------------------------------------------------------------

int DfsAllocateBlock() {
// Check that file system has been validly loaded into memory
// Find the first free block using the free block vector (FBV), mark it in use
// Return handle to block
  int i; //loop variable
  int free_block_index;
  int bit_position;

  LockHandleAcquire(superblock_lock);
  if(sb.valid == 0) {
    printf("Error in DfsCloseFileSystem(): filesystem is already closed!\n");
    LockHandleRelease(superblock_lock);
    return DFS_FAIL;
  }
  LockHandleRelease(superblock_lock);

  dbprintf('d', "Entering DfsAllocateBlock\n");


  // iterate through the fbv array until a 32-bit containing 0 is found
  LockHandleAcquire(fbv_lock);

  i = 0;
  free_block_index = 0;
  while((fbv[i] == 0xFFFFFFFF) && (i < 512)) {
    free_block_index +=32;
    i++;
    if(i == 512) 
    {
        printf("Cannot find free fbv in DfsAllocateBlock!\n");
        return DFS_FAIL;
    }
  }
  bit_position = 0;
  dbprintf('d',"fbv %d has empty handle which has value %x\n",i,fbv[i]);
  // iterate through a 32-bit until the bit 0 is found
  while((fbv[i] & (1 << bit_position)) > 0) {
    bit_position++;
  }
  // set block as in use
  fbv[i] |= (1 << bit_position);

  LockHandleRelease(fbv_lock);
  
  free_block_index += bit_position;
  dbprintf('d',"bit position is %d\n",bit_position);
  dbprintf('d',"free block index is %d\n",free_block_index);

  dbprintf('d', "Exiting DfsAllocateBlock\n");
  return free_block_index;
}


//-----------------------------------------------------------------
// DfsFreeBlock deallocates a DFS block.
//-----------------------------------------------------------------

int DfsFreeBlock(uint32 blocknum) {
  int fbv_index = blocknum / 32;
  int bit_pos = blocknum % 32;

  dbprintf('d',"In DfsFreeBlock The block number is %d \n",blocknum);

  // check if blocknum is within free-able range
  if(blocknum < sb.data_start_fsblock_num) {
    printf("FATAL Error: The block number provided cannot be free! Too small!\n");
    return DFS_FAIL;
  }
  if(blocknum >= (DFS_MAX_FILESYSTEM_SIZE / sb.fs_blocksize)) {
    printf("FATAL Error: The block number provided cannot be free! Too Big!\n");
    return DFS_FAIL;
  }

  LockHandleAcquire(superblock_lock);
  if(sb.valid == 0) {
    printf("Error in DfsCloseFileSystem(): filesystem is already closed!\n");
    LockHandleRelease(superblock_lock);
    return DFS_FAIL;
  }
  LockHandleRelease(superblock_lock);


  dbprintf('d',"In DfsFreeBlock: free block index %d",fbv_index);
  dbprintf('d',"bit position %d wants to be freed \n",bit_pos);

  LockHandleAcquire(fbv_lock);
   if ((fbv[fbv_index] & (uint32)(1 << bit_pos)) == 0) {
    printf("FATAL Error: in DfsFreeBlock(): Block already freed!\n");
    return DFS_FAIL;
  }
  fbv[fbv_index] &= invert((uint32)(1 << bit_pos));
  LockHandleRelease(fbv_lock);

  dbprintf('d', "Exiting DfsFreeBlock\n");
  return DFS_SUCCESS;
}


//-----------------------------------------------------------------
// DfsReadBlock reads an allocated DFS block from the disk
// (which could span multiple physical disk blocks).  The block
// must be allocated in order to read from it.  Returns DFS_FAIL
// on failure, and the number of bytes read on success.  
//-----------------------------------------------------------------

int DfsReadBlock(uint32 blocknum, dfs_block *b) {
  int i;
  int physical_num;
  int physical_num_start;
  int physical_num_end;
  int physical_block_per_fs_block ;


  LockHandleAcquire(superblock_lock);
  if(sb.valid == 0) {
    printf("Error in DfsCloseFileSystem(): filesystem is already closed!\n");
    LockHandleRelease(superblock_lock);
    return DFS_FAIL;
  }
  LockHandleRelease(superblock_lock);

  dbprintf('d',"In DfsReadBlock\n");

  physical_block_per_fs_block =  sb.fs_blocksize / 512;
  dbprintf('d',"Physical block per fs block is %d\n",physical_block_per_fs_block);
  physical_num_start = blocknum * physical_block_per_fs_block;
  dbprintf('d',"Physical block num start is %d\n",physical_num_start);
  physical_num_end = physical_num_start + physical_block_per_fs_block;
  dbprintf('d',"Physical block num end is %d\n",physical_num_end);

  
  if(blocknum > (DFS_MAX_FILESYSTEM_SIZE / sb.fs_blocksize)){
      printf("FATAL Error IN dFSrReadBLOCK: In DfsRead the block number is too big\n");
      return DFS_FAIL;
  }
  if (b == NULL){
      printf("FATAL Error IN dFSrReadBLOCK: dfs block is NULL\n");
      return DFS_FAIL;
  }

  i = 0;
  dbprintf('d', "Copying content from physical block into fs block in DfsReadBlock\n");
  for(physical_num = physical_num_start; physical_num < physical_num_end; physical_num++) {
    // read physical block into offset in fs block
    DiskReadBlock(physical_num, (disk_block*) &(b->data[i * 512]));
    i++;
  }
  dbprintf('d', "Exiting DfsReadBlock\n");
  return DFS_SUCCESS;
}


//-----------------------------------------------------------------
// DfsWriteBlock writes to an allocated DFS block on the disk
// (which could span multiple physical disk blocks).  The block
// must be allocated in order to write to it.  Returns DFS_FAIL
// on failure, and the number of bytes written on success.  
//-----------------------------------------------------------------

int DfsWriteBlock(uint32 blocknum, dfs_block *b){
  int i;
  int physical_num;
  int physical_num_start;
  int physical_num_end;
  int physical_block_per_fs_block;

  LockHandleAcquire(superblock_lock);
  if(sb.valid == 0) {
    printf("Error in DfsCloseFileSystem(): filesystem is already closed!\n");
    LockHandleRelease(superblock_lock);
    return DFS_FAIL;
  }
  LockHandleRelease(superblock_lock);
  dbprintf('d',"In DfsWriteBlock\n");

  physical_block_per_fs_block =  sb.fs_blocksize / 512;
  dbprintf('d',"Physical block per fs block is %d\n",physical_block_per_fs_block);
  physical_num_start = blocknum * physical_block_per_fs_block;
  dbprintf('d',"Physical block num start is %d\n",physical_num_start);
  physical_num_end = physical_num_start + physical_block_per_fs_block;
  dbprintf('d',"Physical block num end is %d\n",physical_num_end);

  
  if(blocknum > (DFS_MAX_FILESYSTEM_SIZE / sb.fs_blocksize)){
      printf("FATAL Error: In DfsWrite the block number is too big\n");
      return DFS_FAIL;
  }
  if (b == NULL){
      printf("FATAL Error IN dFSrReadBLOCK: dfs block is NULL\n");
      return DFS_FAIL;
  }


  i = 0;
  dbprintf('d', "Copying content from physical block into fs block in DfsWriteBlock\n");
  for(physical_num = physical_num_start; physical_num < physical_num_end; physical_num++) {
    // read physical block into offset in fs block
    DiskWriteBlock(physical_num, (disk_block*) &(b->data[i * 512]));
    i++;
  }
  dbprintf('d', "Exiting DfsWriteBlock\n");
  return DFS_SUCCESS;
}


////////////////////////////////////////////////////////////////////////////////
// Inode-based functions
////////////////////////////////////////////////////////////////////////////////


static int my_strcmp(char * source, char * target){
  int i;
  
  i = 0;

  //No null character allow
  if(source[i] == 0) return 0;

  while(source[i] != '\0' && i < FILE_MAX_FILENAME_LENGTH){
    if(source[i] != target[i]) {return 0;}
    i++;
  }
  //This is to check if it's fully the same
  if(target[i] != '\0') {return 0;}
  //it's true
  return 1;
}



//-----------------------------------------------------------------
// DfsInodeFilenameExists looks through all the inuse inodes for 
// the given filename. If the filename is found, return the handle 
// of the inode. If it is not found, return DFS_FAIL.
//-----------------------------------------------------------------

int DfsInodeFilenameExists(char *filename) {
    
  int i; //loop variable
  int num_of_inodes;

  LockHandleAcquire(superblock_lock);
  if(sb.valid == 0) {
    printf("Error in DfsInodeFilenameExists(): filesystem is already closed!\n");
    LockHandleRelease(superblock_lock);
    return -2;
  }
  if(filename == NULL){
    printf("Error in DfsInodeFilenameExists(): char is NULL\n");
    LockHandleRelease(superblock_lock);
    return -2;
  }
  if(dstrlen(filename) > FILE_MAX_FILENAME_LENGTH){
    printf("Error in DfsInodeFilenameExists(): Filename is too long\n");
    LockHandleRelease(superblock_lock);
    return -2;
  }

  // here we will get the number of inodes
  num_of_inodes = sb.num_inodes;
  LockHandleRelease(superblock_lock);
  
  dbprintf('d',"In DfsInodeFilenameExists\n");

  LockHandleAcquire(inode_lock);
  for(i = 0; i < num_of_inodes; i++){
    if(inodes[i].inuse == 1){
      if(my_strcmp(filename,inodes[i].filename) == 1)
      {
        LockHandleRelease(inode_lock);
        dbprintf('d',"a filename exits, returning handle %d\n",i);
        return i; 
      }
    }
  }

  dbprintf('d', "Exiting DfsInodeFilenameExists\n");
  LockHandleRelease(inode_lock);
  return DFS_FAIL;
}


//-----------------------------------------------------------------
// DfsInodeOpen: search the list of all inuse inodes for the 
// specified filename. If the filename exists, return the handle 
// of the inode. If it does not, allocate a new inode for this 
// filename and return its handle. Return DFS_FAIL on failure. 
// Remember to use locks whenever you allocate a new inode.
//-----------------------------------------------------------------

int DfsInodeOpen(char *filename) {
  int filename_handle;
  int num_of_inodes;
  int i;


  LockHandleAcquire(superblock_lock);
  if(sb.valid == 0) {
    printf("Error in DfsInodeOpen(): filesystem is already closed!\n");
    LockHandleRelease(superblock_lock);
    return DFS_FAIL;
  }
   LockHandleRelease(superblock_lock);
   
  dbprintf('d', "Entering DfsInodeOpen\n");
  
  filename_handle =  DfsInodeFilenameExists(filename);

  if(filename_handle == -2) {
    dbprintf('d', "Error occured in DfsInodeOpen\n");
    return DFS_FAIL;
  }

  if(filename_handle != DFS_FAIL) {
    dbprintf('d', "Filename found in DfsInodeOpen\n");
    return filename_handle;
  }


  LockHandleAcquire(superblock_lock);
  num_of_inodes = sb.num_inodes;
  dbprintf('d', "Num of Inodes in DfsInodeOpen: %d\n", num_of_inodes);
  LockHandleRelease(superblock_lock);

  LockHandleAcquire(inode_lock);
  i = 0;
  while( (inodes[i].inuse == 1) && (i < num_of_inodes) ){
    if(i == num_of_inodes) 
    {
        printf("Cannot find any available inode in DFSInodeOpen\n");
        LockHandleRelease(inode_lock);
        return DFS_FAIL;
    }
    i++;
  }
  // allocate new inode for filename
  dbprintf('d', "Handle %d found in DfsInodeOpen\n",i);
  inodes[i].inuse = 1;
  inodes[i].size = 0;
  bcopy(filename,inodes[i].filename,dstrlen(filename)+1);
  
  
  LockHandleRelease(inode_lock);


  dbprintf('d', "Exiting DfsInodeOpen\n");
  return i;
}


//-----------------------------------------------------------------
// DfsInodeDelete de-allocates any data blocks used by this inode, 
// including the indirect addressing block if necessary, then mark 
// the inode as no longer in use. Use locks when modifying the 
// "inuse" flag in an inode.Return DFS_FAIL on failure, and 
// DFS_SUCCESS on success.
//-----------------------------------------------------------------

int DfsInodeDelete(uint32 handle) {
  //divide by 4 bytes ! because 4 bytes is 32 bits
  uint32 indirect_table[DFS_BLOCKSIZE / 4];
  int i;
  int check_inode;
  
  check_inode =  CheckInode(handle);
  if(check_inode == DFS_FAIL){
      printf("FATAL ERROR: Error when checking inode in DFsInodeDelete\n");
      return DFS_FAIL;
  }

  dbprintf('d',"Entering DfsInodeDelete\n");
  LockHandleAcquire(inode_lock);
  // indirectTableBlockNum is a block number of a file system block on the disk 
  // which holds a table of indirect address translations for the virtual blocks beyond the first 10.
  // inode-> indirectlblocknum
  // fs block [indirectblock num] -> indirect block table [256]

  // deallocate all fs blocks in indirect table
  if(inodes[handle].indirectTableBlockNum != 0) {
    // read fsblock containing indirect table into buffer
    if (DfsReadBlock(inodes[handle].indirectTableBlockNum, &buffer) == DFS_FAIL) {
      printf("Error in DfsInodeDelete: Cannot read block\n");   
      LockHandleRelease(inode_lock);
      return DFS_FAIL;
    }
    // copy and cast buffer into block table structure
    bcopy( (char *)&buffer,(char *)indirect_table, sizeof(indirect_table));
    // free any fsblocks in indirect table
    for(i = 0; i < (DFS_BLOCKSIZE / 4); i++) {
      if(indirect_table[i] != 0) {
        if(DfsFreeBlock(indirect_table[i]) == DFS_FAIL) {
          printf("Error in DfsInodeDelete: Cannot free block\n"); 
          LockHandleRelease(inode_lock);         
          return DFS_FAIL;
        }
      }
    }

    // deallocate block occupied by indirect table
    if (DfsFreeBlock(inodes[handle].indirectTableBlockNum) == DFS_FAIL) {
      printf("Error in DfsInodeDelete: Cannot free block\n");
      LockHandleRelease(inode_lock);
      return DFS_FAIL;
    }

    // clear fs block indirectTableBlockNum
    inodes[handle].indirectTableBlockNum = 0;
  }
  
  // deallocate first 10 fs blocks
    for(i = 0 ; i < 10; i++){
        if(inodes[handle].blockTable[i] != 0){
            if(DfsFreeBlock(inodes[handle].blockTable[i] ) == DFS_FAIL) {
              printf("Error in DfsInodeDelete: Cannot free block\n");     
              LockHandleRelease(inode_lock);     
              return DFS_FAIL;
            }
          inodes[handle].blockTable[i] = 0;
        }
    }
   
  // set inode to not in use
  inodes[handle].inuse = 0;
  // set the size to 0
  inodes[handle].size = 0;
  // clear out filename
  bzero(inodes[handle].filename, sizeof(inodes[handle].filename));


  //Debugging purpose
    for(i = 0 ; i < 10; i++){
        dbprintf('d',"In DfsInodeDelete the block table %d value is %d\n",
        i, inodes[handle].blockTable[i]);
    }
    dbprintf('d',"In DfsInodeDelete the indirect block table value is %d\n",
    inodes[handle].indirectTableBlockNum);
  ///////////////////////////////////////
  LockHandleRelease(inode_lock);
  
  dbprintf('d',"Exit DfsInodeDelete\n");
  return DFS_SUCCESS;
}


//-----------------------------------------------------------------
// DfsInodeReadBytes reads num_bytes from the file represented by 
// the inode handle, starting at virtual byte start_byte, copying 
// the data to the address pointed to by mem. Return DFS_FAIL on 
// failure, and the number of bytes read on success.
//-----------------------------------------------------------------

int DfsInodeReadBytes(uint32 handle, void *mem, int start_byte, int num_bytes) {
  int block_counter;
  int virtual_blocknum_start;
  int virtual_blocknum_end;
  int virtual_bytenum_start;
  int virtual_bytenum_end;
  int fsblock_num;
  uint32 bytes_read;  // keep track of how many bytes read so far
  int check_inode;
  
  check_inode =  CheckInode(handle);
  if(check_inode == DFS_FAIL){
      printf("FATAL ERROR: Error when checking inode in DFSInodeReadBytes\n");
      return DFS_FAIL;
  }

  LockHandleAcquire(inode_lock);

  dbprintf('d',"In DfsInodeReadBytes\n");
  dbprintf('d',"start byte is %d, num buytes is %d\n",start_byte,num_bytes);
  // get virtual num to start reading
  virtual_blocknum_start = start_byte / DFS_BLOCKSIZE;
  dbprintf('d',"virtual block number start is %d\n",virtual_blocknum_start);
  // get starting byte in starting virtual block
  virtual_bytenum_start = start_byte % DFS_BLOCKSIZE;
  dbprintf('d',"virtual byte number start is %d\n",virtual_bytenum_start);
  // get number of fsblocks that needs to be read based on num_bytes
  virtual_blocknum_end = (start_byte + num_bytes - 1) / DFS_BLOCKSIZE;
  dbprintf('d',"virtual block number end is %d\n",virtual_blocknum_end);
  // get ending byte in last virtual block
  virtual_bytenum_end = (start_byte + num_bytes - 1) % DFS_BLOCKSIZE;
  dbprintf('d',"virtual byte number end is %d\n",virtual_bytenum_end);

  bytes_read = 0;
  for(block_counter = virtual_blocknum_start; block_counter <= virtual_blocknum_end; block_counter++) {
    // translate virtual num to corresponding fs block num
    // translate virtual num to corresponding fs block num
    dbprintf('d',"In virtual block number %d\n",block_counter);
    fsblock_num = DfsInodeTranslateVirtualToFilesys(handle, block_counter);
    
    // allocate a new virtual block if unallocated
    if(fsblock_num == DFS_FAIL) {
      dbprintf('d',"DfsInodeReadBytes: fsblock not found error\n");
      return DFS_FAIL;
    }
    
    dbprintf('d',"Translated file system block number %d\n",fsblock_num);
    

    DfsReadBlock(fsblock_num, &buffer);

    if (block_counter == virtual_blocknum_start){
        if (block_counter == virtual_blocknum_end) {
          dbprintf('d',"Start byte of the start virtual block: %d\n", virtual_bytenum_start);
          bcopy(&(buffer.data[virtual_bytenum_start]), (char *) &mem[bytes_read], num_bytes);
          bytes_read += num_bytes;
        }
        else {
          dbprintf('d',"Start byte of the start virtual block: %d\n", virtual_bytenum_start);
          bcopy(&(buffer.data[virtual_bytenum_start]), (char *) &mem[bytes_read], DFS_BLOCKSIZE - virtual_bytenum_start);
          bytes_read += DFS_BLOCKSIZE - virtual_bytenum_start;
        }
    }
    // if this is the last virtual block to be read, read until virtual_bytenum_end
    else if(block_counter == virtual_blocknum_end) {
      dbprintf('d',"End byte of the last virtual block: %d\n", virtual_bytenum_end);
      bcopy(buffer.data, (char *) &mem[bytes_read], virtual_bytenum_end + 1);
      bytes_read += virtual_bytenum_end + 1;
    }
    else {
      dbprintf('d',"In the Middle byte of the virtual block\n");
      bcopy(buffer.data, (char *) &mem[bytes_read], DFS_BLOCKSIZE);
      bytes_read += DFS_BLOCKSIZE;
    }
  }

  LockHandleRelease(inode_lock);
  dbprintf('d',"The read byte is %d\n",bytes_read);
  dbprintf('d',"Exiting DfsInodeReadBytes\n");
  return bytes_read;
}


//-----------------------------------------------------------------
// DfsInodeWriteBytes writes num_bytes from the memory pointed to 
// by mem to the file represented by the inode handle, starting at 
// virtual byte start_byte. Note that if you are only writing part 
// of a given file system block, you'll need to read that block 
// from the disk first. Return DFS_FAIL on failure and the number 
// of bytes written on success.
//-----------------------------------------------------------------

int DfsInodeWriteBytes(uint32 handle, void *mem, int start_byte, int num_bytes) {
  int block_counter;
  int virtual_blocknum_start;
  int virtual_blocknum_end;
  int virtual_bytenum_start;
  int virtual_bytenum_end;
  int fsblock_num;
  uint32 bytes_write;  // keep track of how many bytes read so far
  int check_inode;


  check_inode =  CheckInode(handle);
  if(check_inode == DFS_FAIL){
      printf("FATAL ERROR: Error when checking inode in DFSInodeWriteBytes\n");
      return DFS_FAIL;
  }

  LockHandleAcquire(inode_lock);

  dbprintf('d',"In DfsInodeWriteBytes\n");
  dbprintf('d',"start byte is %d, num buytes is %d\n",start_byte,num_bytes);
  // get virtual num to start reading
  virtual_blocknum_start = start_byte / DFS_BLOCKSIZE;
  dbprintf('d',"virtual block number start is %d\n",virtual_blocknum_start);
  // get starting byte in starting virtual block
  virtual_bytenum_start = start_byte % DFS_BLOCKSIZE;
  dbprintf('d',"virtual byte number start is %d\n",virtual_bytenum_start);
  // get number of fsblocks that needs to be read based on num_bytes
  virtual_blocknum_end = (start_byte + num_bytes - 1) / DFS_BLOCKSIZE;
  dbprintf('d',"virtual block number end is %d\n",virtual_blocknum_end);
  // get ending byte in last virtual block
  virtual_bytenum_end = (start_byte + num_bytes - 1) % DFS_BLOCKSIZE;
  dbprintf('d',"virtual byte number end is %d\n",virtual_bytenum_end);

  bytes_write = 0;
  for(block_counter = virtual_blocknum_start; block_counter <= virtual_blocknum_end; block_counter++) {
    // translate virtual num to corresponding fs block num
    dbprintf('d',"In virtual block number %d\n",block_counter);
    fsblock_num = DfsInodeTranslateVirtualToFilesys(handle, block_counter);
    

    if(fsblock_num == DFS_FAIL) {
      dbprintf('d',"DfsInodeWriteBytes: fsblock not found, will allocate for it\n");
      fsblock_num = DfsInodeAllocateVirtualBlock(handle,block_counter);
      if(fsblock_num == DFS_FAIL){
        printf("Could not allocate virtual block in DFSWriteBytes\n");
        return DFS_FAIL;
      }
    }
    else{
      dbprintf('d',"Translated file system block number %d\n",fsblock_num);
    }

    if (block_counter == virtual_blocknum_start) {
        if(block_counter == virtual_blocknum_end){
          // read block because not all bytes will be modified
          DfsReadBlock(fsblock_num, &buffer);
          dbprintf('d',"Start byte of the start virtual block: %d\n", virtual_bytenum_start);
          bcopy((char *) &mem[bytes_write], &(buffer.data[virtual_bytenum_start]), num_bytes);
          DfsWriteBlock(fsblock_num, &buffer);
          bytes_write = num_bytes;
        }
        else {
          // read block because not all bytes will be modified
          DfsReadBlock(fsblock_num, &buffer);
          dbprintf('d',"Start byte of the start virtual block: %d\n", virtual_bytenum_start);
          bcopy((char *) &mem[bytes_write], &(buffer.data[virtual_bytenum_start]), DFS_BLOCKSIZE - virtual_bytenum_start);
          DfsWriteBlock(fsblock_num, &buffer);
          bytes_write += DFS_BLOCKSIZE - virtual_bytenum_start;
        }
    }
    // if this is the last virtual block to be read, read until virtual_bytenum_end
    else if(block_counter == virtual_blocknum_end) {
      // read block because not all bytes will be modified
      DfsReadBlock(fsblock_num, &buffer);
      dbprintf('d',"End byte of the last virtual block: %d\n", virtual_bytenum_end);
      bcopy((char *)&mem[bytes_write], buffer.data, virtual_bytenum_end + 1);
      DfsWriteBlock(fsblock_num, &buffer);
      bytes_write += virtual_bytenum_end + 1;
    }

    else {
      dbprintf('d',"In the Middle byte of the virtual block\n");
      bcopy((char *) &mem[bytes_write], buffer.data, DFS_BLOCKSIZE);
      DfsWriteBlock(fsblock_num, &buffer);
      bytes_write += DFS_BLOCKSIZE;
    }
  }

  
  if (inodes[handle].size < start_byte + bytes_write) {
		inodes[handle].size = start_byte + bytes_write;
	}

  dbprintf('d',"The new file size is %d\n",inodes[handle].size);
  dbprintf('d',"The written byte is %d\n",bytes_write);

  LockHandleRelease(inode_lock);

  dbprintf('d',"Exit DfsInodeWriteBytes\n");
  
  return bytes_write;
}

//-----------------------------------------------------------------
// DfsInodeFilesize simply returns the size of an inode's file. 
// This is defined as the maximum virtual byte number that has 
// been written to the inode thus far. Return DFS_FAIL on failure.
//-----------------------------------------------------------------

int DfsInodeFilesize(uint32 handle) {
  int check_inode;


  dbprintf('d',"Entering DfsInodeFilesize\n");
  check_inode =  CheckInode(handle);
  if(check_inode == DFS_FAIL){
      printf("FATAL ERROR: Error when checking inode in DfsInodeFilesize\n");
      return DFS_FAIL;
  }
   dbprintf('d',"In DfsInodeFilesize The file size is %d\n",inodes[handle].size);
  return inodes[handle].size;
}

//-----------------------------------------------------------------
// DfsInodeAllocateVirtualBlock allocates a new filesystem block 
// for the given inode, storing its blocknumber at index 
// virtual_blocknumber in the translation table. If the 
// virtual_blocknumber resides in the indirect address space, and 
// there is not an allocated indirect addressing table, allocate it. 
// Return DFS_FAIL on failure, and the newly allocated file system 
// block number on success.
//-----------------------------------------------------------------

int DfsInodeAllocateVirtualBlock(uint32 handle, uint32 virtual_blocknum) {
  
  uint32 indirect_table[DFS_BLOCKSIZE / 4];
  int check_inode;
  int allocated_fs_blocknum;
  


  dbprintf('d', "Entering DfsInodeAllocateVirtualBlock\n");
  
  check_inode =  CheckInode(handle);
  if(check_inode == DFS_FAIL){
    printf("FATAL ERROR: Error when checking inode in DfsInodeAllocateVirtualBlock\n");
    return DFS_FAIL;
  }

  if(virtual_blocknum >= 266)  {
    printf("FATAL ERROR: Invalid virtual blocknum detected\n");
    return DFS_FAIL;
  }

  LockHandleAcquire(inode_lock);
  dbprintf('d', "Check if virtual blocknum exists inside direct table\n");
  

  // if virtual_blocknum inside direct table
  if(virtual_blocknum < 10) {
    allocated_fs_blocknum = DfsAllocateBlock();
    if(allocated_fs_blocknum == DFS_FAIL) {
      printf("FATAL ERROR: allocated error in DfsInodeAllocateVirtualBlock\n");
      LockHandleRelease(inode_lock);
      return DFS_FAIL;
    }
    inodes[handle].blockTable[virtual_blocknum] = allocated_fs_blocknum;
    dbprintf('d', "Allocated file system block number %d\n",allocated_fs_blocknum);
    LockHandleRelease(inode_lock);
    return allocated_fs_blocknum;
  }

  dbprintf('d', "Check if fsblock allocated for indirect table\n");

  if(inodes[handle].indirectTableBlockNum == 0) {
    allocated_fs_blocknum = DfsAllocateBlock();
    // clear out the block for use as indirect blocktable
    bzero( (char *)&buffer, sizeof(buffer));
    if(DfsWriteBlock(allocated_fs_blocknum, &buffer) == DFS_FAIL) {
      printf("FATAL ERROR: unable to write empty buffer into fsblock allocated for indirect blocktable\n");
    }

    if(allocated_fs_blocknum == DFS_FAIL) {
      printf("FATAL ERROR: allocated error in DfsInodeAllocateVirtualBlock\n");
      LockHandleRelease(inode_lock);
      return DFS_FAIL;
    }
    dbprintf('d', "Allocated file system block number %d\n",allocated_fs_blocknum);  
    inodes[handle].indirectTableBlockNum = allocated_fs_blocknum;
  }

  dbprintf('d', "Read indirect table from fsblock\n");

  // if virtual blocknum inside indirect table
  if(DfsReadBlock(inodes[handle].indirectTableBlockNum, &buffer) == DFS_FAIL) {
    printf("FATAL ERROR: Unable to read block in fsInodeAllocateVirtualBlock\n");
    LockHandleRelease(inode_lock);
    return DFS_FAIL;
  }

  dbprintf('d', "Copying buffer into indirect table\n");

  // copy buffer into indirect table
  bcopy((char*)&buffer, (char*)indirect_table, sizeof(indirect_table));
  allocated_fs_blocknum = DfsAllocateBlock();
  if(allocated_fs_blocknum == DFS_FAIL) {
    printf("FATAL ERROR: allocated error in DfsInodeAllocateVirtualBlock\n");
    LockHandleRelease(inode_lock);
    return DFS_FAIL;
  }
  indirect_table[virtual_blocknum - 10] = allocated_fs_blocknum;

  bcopy((char*)indirect_table, (char*) &buffer, sizeof(indirect_table));

  dbprintf('d', "Writing updated indirect table %d back into fsblock\n",virtual_blocknum);

  // write new indirect table to disk
  if(DfsWriteBlock(inodes[handle].indirectTableBlockNum, &buffer) == DFS_FAIL) {
    printf("FATAL ERROR: unable to write to disk in DfsInodeAllocateVirtualBlock\n");
    LockHandleRelease(inode_lock);
    return DFS_FAIL;
  }

  LockHandleRelease(inode_lock);

  dbprintf('d',"Exit Allocate Virtual Block\n");
  return allocated_fs_blocknum;
}

//-----------------------------------------------------------------
// DfsInodeTranslateVirtualToFilesys translates the 
// virtual_blocknum to the corresponding file system block using 
// the inode identified by handle. Return DFS_FAIL on failure.
//-----------------------------------------------------------------

int DfsInodeTranslateVirtualToFilesys(uint32 handle, uint32 virtual_blocknum) {
  int fsblock_num;
  uint32 indirect_table[DFS_BLOCKSIZE / 4];
  int check_inode;


  dbprintf('d', "Entering DfsInodeTranslateVirtualToFilesys\n"); 
  
  check_inode =  CheckInode(handle);
  if(check_inode == DFS_FAIL){
      printf("FATAL ERROR: Error when checking inode in DfsInodeTranslateVirtualToFilesys\n");
      return DFS_FAIL;
  }

  LockHandleAcquire(inode_lock);
  dbprintf('d', "Check if virtual blocknum exists inside direct table\n");


  dbprintf('d', "Checking if virtual blocknum is invalid\n");
  if(virtual_blocknum >= 266)  {
    printf("FATAL ERROR: Invalid virtual blocknum detected\n");
    LockHandleRelease(inode_lock);
    return DFS_FAIL;
  }


  // use direct table if blocknum < 10
  if(virtual_blocknum < 10) {
    fsblock_num = inodes[handle].blockTable[virtual_blocknum];
    if(fsblock_num == 0) {
      dbprintf('d',"Error in DfsInodeTranslateVirtualToFilesys: direct virtual block not allocated\n");
      LockHandleRelease(inode_lock);
      return DFS_FAIL;
    }
    else{
      LockHandleRelease(inode_lock);
      return fsblock_num;
    }
  }

  dbprintf('d', "Checking if fsblock allocated for indirect table\n");

  if(inodes[handle].indirectTableBlockNum == 0) {
    dbprintf('d',"Error in DfsInodeTranslateVirtualToFilesys: indirect virtual block not allocated\n");
    LockHandleRelease(inode_lock);
    return DFS_FAIL;
  }

  // use indirect table if blocknum >= 10
  dbprintf('d',"Read the indirect block number %d which correspond to file system block %d to buffer\n"
           ,virtual_blocknum, inodes[handle].indirectTableBlockNum);
  
  if (DfsReadBlock(inodes[handle].indirectTableBlockNum, &buffer) == DFS_FAIL) {
    printf("Error in DfsInodeTranslateVirtualToFilesys: cannot read block\n");
    LockHandleRelease(inode_lock);
    return DFS_FAIL;
  }
  bcopy((char*) &buffer, (char*) indirect_table, sizeof(indirect_table));
  
  fsblock_num = indirect_table[virtual_blocknum - 10];
  
  if(fsblock_num == 0) {
    dbprintf('d',"Error in DfsInodeTranslateVirtualToFilesys: indirect virtual block not allocated\n");
    LockHandleRelease(inode_lock);
    return DFS_FAIL;
  }

  dbprintf('d', "DfsInodeTranslateVirtualToFilesys returns fsblock_num %d\n",fsblock_num );
  dbprintf('d', "Leaving DfsInodeTranslateVirtualToFilesys\n");
  LockHandleRelease(inode_lock);
  return fsblock_num;
}
