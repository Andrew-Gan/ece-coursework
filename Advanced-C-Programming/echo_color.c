#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "clog.h"


int main(int argc, char* argv[])
{
	if(argc != 3)
	{
		fprintf(stderr, "Usage: %%s <\"red\", \"green\", \"yellow\", \"blue\", \"magenta\", \"cyan\"> STRING");
	}
	else
	{
		if(!strcmp(argv[1], "red"))
		{
			log_red("%s", argv[2]);
		}
		else if(!strcmp(argv[1], "green"))
		{
			log_green("%s", argv[2]);
		}
		else if(!strcmp(argv[1], "yellow"))
		{
			log_yellow("%s", argv[2]);
		}
		else if(!strcmp(argv[1], "blue"))
		{
			log_blue("%s", argv[2]);
		}
		else if(!strcmp(argv[1], "magenta"))
		{
			log_magenta("%s", argv[2]);
		}
		else if(!strcmp(argv[1], "cyan"))
		{
			log_cyan("%s", argv[2]);
		}
		else
		{
			fprintf(stderr, "Usage: %%s <\"red\", \"green\", \"yellow\", \"blue\", \"magenta\", \"cyan\"> STRING");

		}
	}

	return EXIT_SUCCESS;
}
