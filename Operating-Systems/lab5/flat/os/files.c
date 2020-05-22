#include "ostraps.h"
#include "dlxos.h"
#include "process.h"
#include "dfs.h"
#include "files.h"
#include "synch.h"

// referenced from files.c
file_descriptor files_arr[FILE_MAX_FILE_DESCRIPTOR];
lock_t file_descriptor_lock;
static int isInit = 0;


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






////////////////////////////////////////////////////////////
//
//  Check file_handle
//
//
////////////////////////////////////////////////////////////

static int check_handle(int handle){

    dbprintf('F',"Checking if the handle is valid\n");
    if(handle < 0){
        printf("FATAL ERROR: file handle too small in FileClose\n");
        return FILE_FAIL;
    }
    if(handle > FILE_MAX_FILE_DESCRIPTOR) {
        printf("FATAL ERROR: file handle too large in FileClose\n");
        return FILE_FAIL;
    }
    if(files_arr[handle].mode == 0){    
        printf("File array is not allocated\n");
        return FILE_FAIL;
    }


    return FILE_SUCCESS;
}


////////////////////////////////////////////////////////////
//
//  Initialize files_arr
//
//
////////////////////////////////////////////////////////////
static void init_check() {
    int i;
    
    dbprintf('F',"Initialize the files_arr...\n");
    if(isInit == 1) 
    {
        dbprintf('F',"Already initialized files_arr\n");
        return;
    }

    LockHandleAcquire(file_descriptor_lock);
    for(i = 0; i < FILE_MAX_FILE_DESCRIPTOR; i++) {
        files_arr[i].mode = 0;
        files_arr[i].eof_flag = 0;
        bzero(files_arr[i].filename, sizeof(files_arr[i].filename));
        files_arr[i].pid = -1;
        files_arr[i].inode_handle = -1;
        files_arr[i].cur_pos = 0;
    }
    LockHandleRelease(file_descriptor_lock);

    isInit = 1;
    
    dbprintf('F', "Exiting init_check");
}

////////////////////////////////////////////////////////////
//
//  Convert string to byte mode
//
//
////////////////////////////////////////////////////////////
static char mode_str_to_mode_byte(char *mode)
{
    dbprintf('F',"in mode_str_to_mode_byte\n");

    if(dstrlen(mode) > 2 ){
        printf("The mode should not have more than 2 characters\n");
        return (char)FILE_FAIL;
    }

    if(my_strcmp(mode, "r") == 1){
        dbprintf('F', "The string inserted is r\n");
        return (char)FILE_MODE_READ;
    }

    if(my_strcmp(mode, "w") == 1){
        dbprintf('F', "The string inserted is w\n");
        return (char)FILE_MODE_WRITE;
    }

    if(my_strcmp(mode, "rw") == 1){
        dbprintf('F', "The string inserted is rw\n");
        return (char)FILE_MODE_RW;
    }

    printf("Mode does not contain r or w or rw\n");
    return (char)FILE_FAIL;
}


////////////////////////////////////////////////////////////
//
//  This is to get the free file description array handle
//
//
////////////////////////////////////////////////////////////
static int get_file_descript_handle() {
    int i;
    
    dbprintf('F',"in get_file_descript_handle\n");

    LockHandleAcquire(file_descriptor_lock);

    for (i = 0; i < FILE_MAX_FILE_DESCRIPTOR; i++){
        if(files_arr[i].mode == 0){
            dbprintf('F',"Found free files array %d handle\n",i);
            LockHandleRelease(file_descriptor_lock);
            return i;
        }
    }
    
    LockHandleRelease(file_descriptor_lock);
    printf("FATAL ERROR: Unable to find free file descriptor in helper function!\n");
    return FILE_FAIL;
}

////////////////////////////////////////////////////////////
//
//  free the file_description_array given the array handle
//
//
////////////////////////////////////////////////////////////
static int free_file_descript_handle(unsigned int handle)
{
    dbprintf('F',"in free_file_descript_handle\n");

    LockHandleAcquire(file_descriptor_lock);
    
    if(files_arr[handle].mode == 0) {
        printf("Error: Attempting to free already unallocated file descriptor\n");
        LockHandleRelease(file_descriptor_lock);
        return FILE_FAIL;
    }
    files_arr[handle].eof_flag = 0;
    files_arr[handle].mode = 0;
    bzero(files_arr[handle].filename, FILE_MAX_FILENAME_LENGTH);
    files_arr[handle].pid = -1;
    files_arr[handle].inode_handle = -1;
    files_arr[handle].cur_pos = 0;

    dbprintf('F',"Successfully free file_array\n");
    LockHandleRelease(file_descriptor_lock);
    return FILE_SUCCESS;
}


////////////////////////////////////////////////////////////
//
//  Find the file description, return FAIL if file is not found
//
//
////////////////////////////////////////////////////////////
int FileDescriptorExists(char *filename) {
    
    int i; //loop variable

    dbprintf('F',"In FileDescriptorExists\n");

    if(filename == NULL){
        printf("Error in FileDescriptorExists(): char is NULL\n");
        return -2;
    }
    if(dstrlen(filename) > FILE_MAX_FILENAME_LENGTH){
        printf("Error in FileDescriptorExists(): Filename is too long\n");
        return -2;
    }
    
    LockHandleAcquire(file_descriptor_lock);
    for(i = 0; i < FILE_MAX_FILE_DESCRIPTOR; i++){
        if(dstrncmp(filename, files_arr[i].filename, dstrlen(filename)) == 1) {
            if(files_arr[i].pid == GetCurrentPid()) {
                dbprintf('F', "File already previously opened by same process. Returning same \
                descriptor handle in FileOpen\n");
                LockHandleRelease(file_descriptor_lock);
                return i;
            }
            else {
                dbprintf('F',"Process #%d trying to open a file that was opened by Process #%d\n", 
                GetCurrentPid(), files_arr[i].pid);
                LockHandleRelease(file_descriptor_lock);
                return -2;
            }
        }
        i++;
    }

    dbprintf('F', "Exiting FileDescriptorExists\n");
    LockHandleRelease(file_descriptor_lock);
    dbprintf('F', "No file descriptor for the filename %s was found\n", filename);
    
    return FILE_FAIL;
}



//Remember to use locks whenever you allocate a new file descriptor.

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Open the given filename with one of three possible modes: "r", "w", or "rw". 
// return FILE_FAIL on failure (e.g., when a process tries to open a file that is already open for another process),
// and the handle of a file descriptor on success. Remember to use locks whenever you allocate a new file descriptor.
int FileOpen(char *filename, char *mode)
{
    int what_mode;
    unsigned int inode_handle;
    unsigned int file_handle;

    init_check();

    dbprintf('F', "In FileOpen\n");
    // search if file descriptor for the filename has been previously allocated
    file_handle = FileDescriptorExists(filename);
    
    // return fail if file descriptor opened by another process or filename invalid
    if(file_handle == -2) {
        printf("FATAL ERROR: Cannot get file handle in FileOpen\n");
        return DFS_FAIL;
    }
    // return handle if file descriptor opened by same process
    if(file_handle != FILE_FAIL) {
        dbprintf('F', "The handle %d is found \n", file_handle);
        return file_handle;
    }

    // check if inode exists for that filename
    inode_handle =  DfsInodeOpen(filename);
    if(inode_handle == DFS_FAIL) {
        printf("FATAL ERROR: Cannot find nor allocate inode for filename %s in FileOpen\n", filename);
        return FILE_FAIL;
    }

    // Get free file_handle
    file_handle =  get_file_descript_handle();
    if(file_handle == FILE_FAIL) {
        printf("FATAL ERROR: Cannot get available file descriptor in FileOpen\n");
        return FILE_FAIL;
    }
    dbprintf('F', "The handle %d is found \n", file_handle);
    
    // check what mode the file has
    what_mode = (int) mode_str_to_mode_byte(mode);
    dbprintf('F', "what mode is %d\n",what_mode);
    if(what_mode == FILE_FAIL) {
        printf("FATAL ERROR: Unrecognized mode in FileOpen\n");
        return FILE_FAIL;
    }

    LockHandleAcquire(file_descriptor_lock);
    // initialize the filename
    bcopy(filename, files_arr[file_handle].filename, dstrlen(filename));
    // initilaize inode handle
    files_arr[file_handle].inode_handle = inode_handle;
    // initialize mode
    files_arr[file_handle].mode = what_mode;
    // assign pid to each file array
    files_arr[file_handle].pid = GetCurrentPid();
    LockHandleRelease(file_descriptor_lock);

    return file_handle;
}

// Close the given file descriptor handle. Return FILE_FAIL on failure, and FILE_SUCCESS on success
int FileClose(int handle)
{
    dbprintf('F', "In FileClose\n");
    //Check if handle is valid
    if(check_handle(handle) == FILE_FAIL) {
        printf("FATAL ERROR: Invalid handle in FileClose\n");
        return FILE_FAIL;
    }
    
    //Check if the file is opened
    LockHandleAcquire(file_descriptor_lock);
    if(files_arr[handle].mode == 0) {
        dbprintf('F', "File handle %d is already closed in FileClose\n", handle);
        LockHandleRelease(file_descriptor_lock);
        return FILE_FAIL;
    }

    //Check if same process is closing the file
    if(files_arr[handle].pid != GetCurrentPid()) {
        dbprintf('F', "Process #%d trying to open a file that was opened by Process #%d\n", 
        GetCurrentPid(), files_arr[handle].pid);
        LockHandleRelease(file_descriptor_lock);
        return FILE_FAIL;
    }

    // Reset the files_array
    if(free_file_descript_handle(handle) == FILE_FAIL) {
        printf("FATAL ERROR: Unable to free file descriptor %d\n", handle);
        return FILE_FAIL;
    }
   
    LockHandleRelease(file_descriptor_lock);
    return FILE_SUCCESS;
}


// Read num_bytes from the open file descriptor identified by handle. 
// Return FILE_FAIL on failure or upon reaching end of file, and the number of bytes read on success. 
// If end of file is reached, the end-of-file flag in the file descriptor should be set.
int FileRead(int handle, void *mem, int num_bytes)
{
    int inode_handle;

    dbprintf('F', "In FileRead\n");
    
    //Check if handle is valid
    if(check_handle(handle) == FILE_FAIL) {
        printf("FATAL ERROR: Invalid handle in FileRead\n");
        return FILE_FAIL;
    }
    //check if num_bytes is more than allowed bytes
    if(num_bytes > FILE_MAX_READWRITE_BYTES){
        printf("FATAL ERROR: Number of bytes to read exceeds limit\n");
        return FILE_FAIL;
    }


    LockHandleAcquire(file_descriptor_lock);

    // Check if the file is in read mode 
    if((files_arr[handle].mode & FILE_MODE_READ) != FILE_MODE_READ) {
        printf("FATAL ERROR: The file does not have read access\n");
        LockHandleRelease(file_descriptor_lock);
        return FILE_FAIL;
    }
    // Check if EOF bit is set
    if(files_arr[handle].eof_flag == 1) {
        printf("File descriptor has reached end of file in FileRead\n");
        LockHandleRelease(file_descriptor_lock);
        return FILE_EOF;
    }

    // get the inode handle for the file
    inode_handle = files_arr[handle].inode_handle;
    dbprintf('F', "Inode handle %d acquired for file descriptor handle %d\n", inode_handle, handle);

    // if remaining unread bytes is less than number of bytes to read, set EOF flag
    if((inodes[inode_handle].size - files_arr[handle].cur_pos) < num_bytes) {
        dbprintf('F', "inodes size %d, current pos %d, numbytes %d\n"
        ,inodes[inode_handle].size, files_arr[handle].cur_pos, num_bytes);
        dbprintf('F', "Setting EOF flag in FileRead\n");
        files_arr[handle].eof_flag = 1;
        LockHandleRelease(file_descriptor_lock);
        return FILE_EOF;
    }

    if(DfsInodeReadBytes(inode_handle, mem, files_arr[handle].cur_pos, num_bytes) == num_bytes) {
        files_arr[handle].cur_pos += num_bytes;
        LockHandleRelease(file_descriptor_lock);
        dbprintf('F', "File read successfully in FileRead\n");
        return num_bytes;
    }

    printf("FATAL ERROR: Unable to read bytes from file\n");
    LockHandleRelease(file_descriptor_lock);
    dbprintf('F', "Leaving FileRead\n");
    return FILE_FAIL;
}

// Write num_bytes to the open file descriptor identified by handle. 
// Return FILE_FAIL on failure, and the number of bytes written on success.
int FileWrite(int handle, void *mem, int num_bytes)
{
    int inode_handle;
    int fs_blocksize;

    dbprintf('F', "In FileWrite\n");
    //Check if handle is valid
    if(check_handle(handle) == FILE_FAIL) {
        printf("FATAL ERROR: Invalid handle in FileWrite\n");
        return FILE_FAIL;
    }
    //check if num_bytes is more than allowed bytes
    if(num_bytes > FILE_MAX_READWRITE_BYTES) {
        printf("FATAL ERROR: Number of bytes to read exceeds limit\n");
        return FILE_FAIL;
    }

    fs_blocksize = GetBlocksize();

    LockHandleAcquire(file_descriptor_lock);

    // Check if the file is in write mode 
    if((files_arr[handle].mode & FILE_MODE_WRITE) != FILE_MODE_WRITE) {
        printf("FATAL ERROR: The file does not have write access\n");
        LockHandleRelease(file_descriptor_lock);
        return FILE_FAIL;
    }

    // get the inode handle for the file
    inode_handle = files_arr[handle].inode_handle;
    dbprintf('F', "Inode handle %d acquired for file descriptor handle %d\n", inode_handle, handle);

    // if remaining space available in file is less than num byte to write, return fail
    if((fs_blocksize * (10 + fs_blocksize / 4) - inodes[inode_handle].size) < num_bytes) {
        printf("FATAL ERROR: Attempting to write more bytes than available bytes in file\n");
        LockHandleRelease(file_descriptor_lock);
        return FILE_FAIL;
    }

    if(DfsInodeWriteBytes(inode_handle, mem, files_arr[handle].cur_pos, num_bytes) == num_bytes) {
        files_arr[handle].cur_pos += num_bytes;
        dbprintf('F', "File written successfully in FileWrite\n");
        LockHandleRelease(file_descriptor_lock);
        return num_bytes;
    }

    printf("FATAL ERROR: Unable to write bytes into file\n");
    dbprintf('F', "Leaving FileWrite\n");
    LockHandleRelease(file_descriptor_lock);
    return FILE_FAIL;
}

// Seek num_bytes within the file descriptor identified by handle, 
// from the location specified by from_where. There are three possible values for from_where:
// FILE_SEEK_CUR (seek relative to the current position), FILE_SEEK_SET (seek relative to the beginning of the file), 
// and FILE_SEEK_END (seek relative to the end of the file). Any seek operation will clear the eof flag.
int FileSeek(int handle, int num_bytes, int from_where)
{
    int inode_handle;
    int check;

    dbprintf('F', "Entering FileSeek\n");
    //Check if handle is valid
    if(check_handle(handle) == FILE_FAIL) {
        printf("FATAL ERROR: Invalid handle in FileSeek\n");
        return FILE_FAIL;
    }

    LockHandleAcquire(file_descriptor_lock);
    inode_handle = files_arr[handle].inode_handle;
    dbprintf('F', "Acquired inode %d for file handle %d in FileSeek\n", inode_handle, handle);

    switch (from_where)
    {
        case FILE_SEEK_SET:
            check = num_bytes;
            break;
        case FILE_SEEK_CUR:
            check = files_arr[handle].cur_pos + num_bytes;
            break;
        case FILE_SEEK_END:
            check = inodes[inode_handle].size + num_bytes;
            break;
        default:
            printf("The Mode Provided is not valid! \n");
            LockHandleRelease(file_descriptor_lock);
            return FILE_FAIL;
    }

    if((check >= 0) && (check < inodes[inode_handle].size)) {
        dbprintf('F', "File Seeek value is valid, resetting eof flag\n");
        files_arr[handle].eof_flag = 0;
        files_arr[handle].cur_pos = check;
        LockHandleRelease(file_descriptor_lock);
        return FILE_SUCCESS;
    }

    LockHandleRelease(file_descriptor_lock);
    printf("FATAL ERROR: Unable to seek file position %d\n", check);
    dbprintf('F', "Leaving FileSeek\n");
    return FILE_FAIL;
}

// Delete the file specified by filename. 
// Return FILE_FAIL on failure, and FILE_SUCCESS on success.

int FileDelete(char *filename)
{
    int file_handle;
    int inode_handle;

    dbprintf('F', "Entering FileDelete...\n");
    //Check the filename if it exits on file array
    file_handle = FileDescriptorExists(filename);
    // return fail if name is invalid
    if(file_handle == -2) {
        printf("FATAL ERROR: Invalid filename received in FileDelete\n");
        return FILE_FAIL;
    }
    // if file descriptor exists, deallocate it
    if(file_handle != FILE_FAIL) {
        if(FileClose(file_handle) == FILE_FAIL) {
            printf("FATAL ERROR: Cannot closed a allocated file with handle %d",file_handle);
            return FILE_FAIL;
        }
    }

    // file descriptor already deallocated
    // remove inode representing file
    inode_handle = DfsInodeFilenameExists(filename);
    if(inode_handle == -2){
        dbprintf('d', "Error occured in DfsInodeFilenameExists\n");
        return FILE_FAIL;
    }
    if(inode_handle == DFS_FAIL) {
        printf("FATAL ERROR: Inode %d for file already deallocated in FileDelete\n", inode_handle);
        return FILE_FAIL;
    }
    if(DfsInodeDelete(inode_handle) == DFS_FAIL) {
        printf("FATAL ERROR: Unable to delete inode %d in FileDelete\n", inode_handle);
        return FILE_FAIL;
    }
    
    dbprintf('F', "Leaving FileDelete...\n");

    return FILE_SUCCESS;
}