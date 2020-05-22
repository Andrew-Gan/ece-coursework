#include "usertraps.h"
#include "misc.h"

#include "fdisk.h"

dfs_superblock sb;
dfs_inode inodes[FDISK_NUM_INODES];
unsigned int fbv[16383-19+1];

int diskblocksize = 0; // These are global in order to speed things up
int disksize = 0;      // (i.e. fewer traps to OS to get the same number)
int num_filesystem_blocks = 0;


void main (int argc, char *argv[])
{
	// STUDENT: put your code here. Follow the guidelines below. They are just the main steps. 
	// You need to think of the finer details. You can use bzero() to zero out bytes in memory
  int i; //loop variable
  int j; //loop variable
  int k; //loop variable
  int fs_numBlock_needed_for_vector;
  int last_vector_fs_block;
  dfs_block buffer;
  char physical_disk_buffer[FDISK_PHYSICAL_BLOCK_SIZE];
  char zero_buffer[FDISK_PHYSICAL_BLOCK_SIZE];
  

  //Initializations and argc check
  if(argc != 1) {
    Printf("No arguements are needed\n");
    Exit();
  }

  // Need to invalidate filesystem before writing to it to make sure that the OS
  // doesn't wipe out what we do here with the old version in memory
  // You can use dfs_invalidate(); but it will be implemented in Problem 2. You can just do 
  // sb.valid = 0

  sb.valid = 0;
  sb.fs_blocksize = DFS_BLOCKSIZE;
  sb.fs_numblocks = DFS_MAX_FILESYSTEM_SIZE / DFS_BLOCKSIZE;
  sb.inode_start_fsblock_num = FDISK_INODE_BLOCK_START;
  sb.num_inodes = FDISK_NUM_INODES;
  sb.fbv_start_fsblock_num = FDISK_FBV_BLOCK_START;
 

  // still not sure why do we need this?
  disksize = DFS_MAX_FILESYSTEM_SIZE;
  diskblocksize = DFS_BLOCKSIZE;
  num_filesystem_blocks = DFS_MAX_FILESYSTEM_SIZE / DFS_BLOCKSIZE;

  // Make sure the disk exists before doing anything else
  if(disk_create() == DISK_FAIL) {
    Printf("Error: Cannot create disk in %s\n", argv[0]);
    Exit();
  }
  
  // Check the size before we set up
  if(sizeof(dfs_inode) != 96) {
    Printf("Error: Incorrect inode size detected!\n");
    Printf("The size is %d \n",sizeof(dfs_inode));
    Exit();
  }

  bzero(buffer.data, sizeof(buffer.data));
  bcopy((char*)buffer.data,(char *)zero_buffer,sizeof(zero_buffer)); //just to be safe
  // Write all inodes as not in use and empty (all zeros)
  for(i = FDISK_INODE_BLOCK_START; i <= FDISK_INODE_NUM_BLOCKS; i++) {
    // Here i will represent the starting file system block that we want to write
    for (j=0; j < FDISK_PHYSICAL_BLOCK_PER_FS_BLOCK; j++){
        //Here j will represent the offset of physical block 
        disk_write_block((i *FDISK_PHYSICAL_BLOCK_PER_FS_BLOCK) + j , physical_disk_buffer);
        Printf("\nWriting to physical block size %d\n",(i *FDISK_PHYSICAL_BLOCK_PER_FS_BLOCK) + j);
    }
  }
 
  Printf("Done initializing inodes to zeros\n");

  // Next, setup free block vector (fbv) and write free block vector to the disk

  //we are calculating how many fs block we need for the free block vector
  // Remember it's calculated with respects with fils system block not physical block
  fs_numBlock_needed_for_vector = (DFS_MAX_FILESYSTEM_SIZE / DFS_BLOCKSIZE) / (DFS_BLOCKSIZE * 8);
  Printf("File system block needed for vector is %d\n",fs_numBlock_needed_for_vector);

  //we can convert where physical block will end to where file system will end
  last_vector_fs_block = FDISK_FBV_BLOCK_START + fs_numBlock_needed_for_vector;
   
  Printf("Last file system block for vector is = %d\n", last_vector_fs_block);


  // now we will set up the free block vector bits

  // for testing
  k = 3;
  j = 0;
  for(i = 0; i < ( (last_vector_fs_block + 1) / 8); i++) {
    buffer.data[k - j++] = 0xFF;
    if(j == 4) {
      j = 0;
      k += 4;
    }
  }

  // mod 8 will give us how many bits we need to set up the buffer
  Printf("This many bits needs to write  %d\n",(last_vector_fs_block + 1)  % 8);
  for(i = 0; i < ( (last_vector_fs_block + 1)  % 8); i++) {
    buffer.data[k - j] |= (1 << i);
  }

  //Here j will represent the offset of physical block 
  Printf("Physical block per fs block is %d\n",FDISK_PHYSICAL_BLOCK_PER_FS_BLOCK);

  for (j=0; j < FDISK_PHYSICAL_BLOCK_PER_FS_BLOCK; j++){
    bcopy((char *) &buffer.data[ j * FDISK_PHYSICAL_BLOCK_SIZE], physical_disk_buffer, 
          sizeof(physical_disk_buffer));
    disk_write_block( (FDISK_FBV_BLOCK_START * (FDISK_PHYSICAL_BLOCK_PER_FS_BLOCK)) + j , physical_disk_buffer);
    Printf("Writing to physical block size %d\n",(FDISK_FBV_BLOCK_START * (FDISK_PHYSICAL_BLOCK_PER_FS_BLOCK)) + j);
  }

  //plus one because first block has already been written
  for(i = (FDISK_FBV_BLOCK_START +1) ; i <= last_vector_fs_block ; i++) {
    // Here i will represent the starting file system block that we want to write
    for (j=0; j < FDISK_PHYSICAL_BLOCK_PER_FS_BLOCK; j++){
        //Here j will represent the offset of physical block 
        Printf("Writing to physical block size %d\n",(i *FDISK_PHYSICAL_BLOCK_PER_FS_BLOCK) + j);
        disk_write_block((i *FDISK_PHYSICAL_BLOCK_PER_FS_BLOCK) + j , zero_buffer);
    }
  }

  
  // Finally, setup superblock as valid filesystem and write superblock and boot record to disk: 
  sb.valid = 1;
  sb.data_start_fsblock_num = last_vector_fs_block + 1;
  bzero(physical_disk_buffer,sizeof(physical_disk_buffer));
  bcopy((char *)&sb, physical_disk_buffer, sizeof(sb));
  // boot record is all zeros in the first physical block, and superblock structure goes into the second physical block
  disk_write_block(1, physical_disk_buffer);
  disk_write_block(0, zero_buffer);

  Printf("fdisk (%d): Formatted DFS disk for %d bytes.\n", getpid(), disksize);
}

