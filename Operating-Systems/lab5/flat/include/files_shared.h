#ifndef __FILES_SHARED__
#define __FILES_SHARED__

#define FILE_SEEK_SET 1
#define FILE_SEEK_END 2
#define FILE_SEEK_CUR 3

#define FILE_MAX_FILENAME_LENGTH 47
#define FILE_MAX_FILE_DESCRIPTOR 192

#define FILE_MAX_READWRITE_BYTES 4096

typedef struct file_descriptor {
  // STUDENT: put file descriptor info here
  unsigned char eof_flag;                       // end of file flag
  unsigned char mode;                           // mode
  char filename[FILE_MAX_FILENAME_LENGTH];      // filename
  int pid;                             // pid
  int inode_handle;                    // inode handle
  int cur_pos;                         // current positio
} file_descriptor;


#define FILE_MODE_READ    0x1
#define FILE_MODE_WRITE   0x2
#define FILE_MODE_RW      0x3

#define FILE_FAIL -1
#define FILE_EOF -1
#define FILE_SUCCESS 1

#endif
