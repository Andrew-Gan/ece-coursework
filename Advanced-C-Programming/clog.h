#ifndef __CLOG_H__
#define __CLOG_H__
#include <unistd.h>

const char* ANSI_RED = "\x1b[31m";
const char* ANSI_GREEN = "\x1b[32m";
const char* ANSI_YELLOW = "\x1b[33m";
const char* ANSI_BLUE = "\x1b[34m";
const char* ANSI_MAGENTA ="\x1b[35m";
const char* ANSI_CYAN ="\x1b[36m";
const char* ANSI_RESET ="\x1b[0m";

#ifdef DEBUG
#	define log_msg(msg) fprintf(stderr, "%s", msg)
#	define log_int(n) fprintf(stderr, "%s == %d", #n, n)
#	define log_str(s) fprintf(stderr, "%s == %s", s, *s)
#	define log_char(c) fprintf(stderr, "%c == %c", c, *c)
#	define log_addr(addr) fprintf(stderr, "%s == %p", addr, &n)
#	define log_red(format, ...) if(isatty(STDERR_FILENO)) \
		{											\
			fprintf(stderr, ANSI_RED); 				\
			fprintf(stderr, format, __VA_ARGS__); 	\
			fprintf(stderr, ANSI_RESET);			\
		}
#	define log_green(format, ...) if(isatty(STDERR_FILENO)) \
		{											\
			fprintf(stderr, ANSI_GREEN); 			\
			fprintf(stderr, format, __VA_ARGS__); 	\
			fprintf(stderr, ANSI_RESET);			\
		}
#	define log_yellow(format, ...) if(isatty(STDERR_FILENO)) \
		{											\
			fprintf(stderr, ANSI_YELLOW); 			\
			fprintf(stderr, format, __VA_ARGS__); 	\
			fprintf(stderr, ANSI_RESET);			\
		}
#	define log_blue(format, ...) if(isatty(STDERR_FILENO)) \
		{											\
			fprintf(stderr, ANSI_BLUE); 			\
			fprintf(stderr, format, __VA_ARGS__); 	\
			fprintf(stderr, ANSI_RESET);			\
		}
#	define log_magenta(format, ...) if(isatty(STDERR_FILENO)) \
		{											\
			fprintf(stderr, ANSI_MAGENTA); 			\
			fprintf(stderr, format, __VA_ARGS__); 	\
			fprintf(stderr, ANSI_RESET);			\
		}
#	define log_cyan(format, ...) if(isatty(STDERR_FILENO)) \
		{											\
			fprintf(stderr, ANSI_CYAN); 			\
			fprintf(stderr, format, __VA_ARGS__); 	\
			fprintf(stderr, ANSI_RESET);			\
		}
#else
#	define log_msg(msg)
#	define log_int(n) 
#	define log_str(s) 
#	define log_char(c)
#	define log_addr(addr)
#	define log_red(format, ...)
#	define log_green(format, ...)
#	define log_yellow(format, ...)
#	define log_blue(format, ...)
#	define log_magenta(format, ...)
#	define log_cyan(format, ...)
#endif

#endif
