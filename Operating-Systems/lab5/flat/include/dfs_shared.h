#ifndef __DFS_SHARED__
#define __DFS_SHARED__


typedef struct dfs_superblock {
  // STUDENT: put superblock internals here
  unsigned char valid;           // a valid indicator for the file system
  unsigned int fs_blocksize;   // the file system block size
  unsigned int fs_numblocks;      // the total number of file system blocks
  unsigned int inode_start_fsblock_num;   // the starting file system block number for the array of inodes
  unsigned int num_inodes;        // the number of inodes in the inodes array
  unsigned int fbv_start_fsblock_num;     // the starting file system block number for the free block vector.
  unsigned int data_start_fsblock_num;
} dfs_superblock;

#define FILE_MAX_FILENAME_LENGTH 47
#define DFS_BLOCKSIZE 1024  // Must be an integer multiple of the disk blocksize

typedef struct dfs_block {
  char data[DFS_BLOCKSIZE];
} dfs_block;

typedef struct dfs_inode {
  // STUDENT: put inode structure internals here
  // IMPORTANT: sizeof(dfs_inode) MUST return 96 in order to fit in enough
  // inodes in the filesystem (and to make your life easier).  To do this, 
  // adjust the maximumm length of the filename until the size of the overall inode 
  // is 96 bytes.
  char filename[FILE_MAX_FILENAME_LENGTH];
  char inuse; // 1 bytes
  int size; // 4 bytes
  int blockTable [10]; // first 10 virtual blocks, 40 bytes
  int indirectTableBlockNum; // may or may not be allocated, 4 bytes
} dfs_inode;

#define DFS_MAX_FILESYSTEM_SIZE 0x1000000  // 16MB
#define DFS_FAIL -1
#define DFS_SUCCESS 1



#endif
