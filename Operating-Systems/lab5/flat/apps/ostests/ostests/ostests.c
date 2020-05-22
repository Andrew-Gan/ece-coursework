#include "usertraps.h"

void main (int argc, char *argv[])
{
	int retval;
	int handle;
	char *file1 = "test_file";
	char *file2 = "test_file_1";
	char data[4096];
	char read_data[4096];
	int i = 0;

    // run_os_tests();

	/////////////test 1
	Printf("\n\ntest1\n");
	retval = file_open(file1, "rw");
	Printf("called file_open, return %d\n", retval);

	/////////////test 2
	Printf("\n\ntest2\n");
	handle = retval;
	retval = file_close(handle);
	Printf("called file_close, return %d\n", retval);

	/////////////test 3
	Printf("\n\ntest3\n");
	retval = file_open(file1, "rw");
	Printf("called file_open, return %d\n", retval);
	handle = retval;
	for (i=0; i<2048; i++) {
		data[i] = 'A';
	}
	retval = file_write(handle, (void *)data, 512);
	Printf("called file_write, return %d\n", retval);
	retval = file_close(handle);
	Printf("called file_close, return %d\n", retval);

	/////////////test 4
	Printf("\n\ntest4\n");
	retval = file_open(file1, "rw");
	Printf("called file_open, return %d\n", retval);
	handle = retval;
	for (i=0; i<2048; i++) {
		read_data[i] = '\0';
	}
	retval = file_read(handle, (void *)read_data, 512);
	Printf("called file_read, return %d\n", retval);
	for (i=0; i<1024; i++) {
		Printf("%c", read_data[i]);
	}
	Printf("\n");
	retval = file_close(handle);
	Printf("called file_close, return %d\n", retval);

	/////////////test 5
	Printf("\n\ntest5 integreated test\n");
	retval = file_open(file2, "w");
	Printf("open file - handle %d\n", retval);
	handle = retval;
	for (i=0; i<3333; i++) {
		data[i] = 'z';
	}
	retval = file_write(handle, (void *)data, 3333);
	Printf("write to file, return %d\n", retval);
	retval = file_close(handle);
	Printf("close file, return %d\n", retval);
	retval = file_open(file2, "rw");
	Printf("open same file again, return %d\n", retval);
	handle = retval;
	//empty the read buffer
	for (i=0; i<4096; i++) {
		read_data[i] = '\0';
	}
	retval = file_read(handle, (void *)read_data, 3333);
	Printf("read file into read_data, return %d\n", retval);
	Printf("print read_data content: \n");
	for (i=0; i<3333; i++) {
		Printf("%c", read_data[i]);
	}
	Printf("\n");

	/////////////test 6
	Printf("\n\ntest6 integreated test with seek\n");
	for (i=0; i<4000; i++) {
		data[i] = 'h';
	}
	retval = file_write(handle, (void *)data, 2000);
	Printf("write to file 2000, return %d\n", retval);
	retval = file_seek(handle, -2010, 3);
	Printf("file seek -2010, return %d\n", retval);
	//empty the read buffer
	for (i=0; i<4096; i++) {
		read_data[i] = '\0';
	}
	retval = file_read(handle, (void *)read_data, 2000);
	Printf("print read_data content (should only see 10 z characters): \n");
	for (i=0; i<3000; i++) {
		Printf("%c", read_data[i]);
	}

	/////////////test 7
	Printf("\n");
	retval = file_seek(handle,0, 1);
	Printf("file seek 0, return %d\n", retval);
	//empty the read buffer
	for (i=0; i<4096; i++) {
		read_data[i] = '\0';
	}
	retval = file_read(handle, (void *)read_data, 2000);
	Printf("print read_data content (should see everything): \n");
	for (i=0; i<2000; i++) {
		Printf("%c", read_data[i]);
	}
	Printf("\n");

	/////////////test 8
	Printf("\n");
	retval = file_seek(handle,-10, 2);
	Printf("file seek -10, return %d\n", retval);
	//empty the read buffer
	for (i=0; i<4096; i++) {
		read_data[i] = '\0';
	}
	retval = file_read(handle, (void *)read_data, 10);
	Printf("print read_data content (should see 10 h characters): \n");
	for (i=0; i<10; i++) {
		Printf("%c", read_data[i]);
	}

	Printf("\n");
	retval = file_close(handle);
	Printf("close file, return %d\n", retval);

	/////////////test 9
	Printf("\n\ntest9\n");
	retval = file_delete(file2);
	Printf("called file_delete, return %d\n\n", retval);

	/////////////test 10
	Printf("Test 10 is to see if it will overwrite old content\n");
	retval = file_open(file2, "w");
	Printf("open file - handle %d\n", retval);
	handle = retval;
	for (i=0; i<3333; i++) {
		data[i] = 'a';
	}
	retval = file_write(handle, (void *)data, 3333);
	Printf("write to file, return %d\n", retval);
	retval = file_close(handle);
	Printf("close file, return %d\n", retval);
	Printf("Should see only character a h A\n");

	/////////////test 11
	Printf("Test 11 is to see if the mode is correct\n");
	retval = file_open(file1, "r");
	Printf("write to file in read mode, return %d\n", retval);
	retval = file_write(handle, (void *)data, 3333);
	if(retval != -1) {
		printf(" Test fail! Written to read-only mode\n\n");
	}

	return 0;
}