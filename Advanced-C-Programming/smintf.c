#define HW06_BONUS
#include <stdarg.h>
#include <stdbool.h>
#include <stdlib.h>
#include <stdio.h> 	// for bonus option
#include "smintf.h"

int _count_format(const char*);
void _read_format(char*, bool, const char*, va_list);
void _base_conv(bool, int, int, char*, char*);
void _conc_str(char*, char);

// receive user input with supported formatting codes and return formatted output string
char* smintf(const char* format, ...) {
	va_list list;
	int format_size = _count_format(format);
	char* output = malloc(sizeof(*output) * format_size * 40);
	for(int i = 0; i < sizeof(*output) * format_size * 40; i++) {
		output[i] = '\0';
	}
	va_start(list, format);
	if(output != NULL) {
		_read_format(output, false, format, list);
	}
	va_end(list);
	return(output);	
}

// count number of elements present in user input
int _count_format(const char* format) {
	int format_size = 1;
	while(format[format_size] != '\0') {
		format_size++;
	}
	return(format_size);
}

// receive user input in printf() format and print to stdout terminal
void mintf(const char* format, ...) {
	va_list list;
	char* output = "";
	va_start(list, format);
	_read_format(output, true, format, list);
	va_end(list);
}

// read user input and replace formatting codes with corresponding argument values
void _read_format(char* output, bool is_mintf, const char* format, va_list list) {
	char type, currChar;							
	char* strTemp;					
	int strIdx, intArg, index = 0;					
	double dblTemp;	
	do{
		type = format[index + 1];
		// determine if formatting code is present in user input
		if(format[index] == '%'){
			switch(type) {
				case 'd' : _base_conv(is_mintf, va_arg(list, int), 10, "\0", output);
						break;
				case 'x' : _base_conv(is_mintf, va_arg(list, int), 16, "0x", output);
						break;
				case 'b' : _base_conv(is_mintf, va_arg(list, int), 2, "0b", output);
						break;
				case '$' : dblTemp = va_arg(list, double);
				_base_conv(is_mintf, (int)dblTemp, 10, "$", output);
				_base_conv(is_mintf, abs((long int)(dblTemp * 100) % 100), 10, ".", output);
						break;
				case 's' : strIdx = 0;		
				strTemp = va_arg(list, char*);
				do{						
					currChar = strTemp[strIdx];
					is_mintf ? (void)fputc(currChar, stdout) : _conc_str(output, currChar);
					strIdx++;		
				}while(strTemp[strIdx] != '\0');
						break;
				case 'c' : intArg = va_arg(list, int);
				is_mintf ? (void)fputc(intArg, stdout) : _conc_str(output, intArg);
						break;
				case '%' : is_mintf ? (void)fputc('%', stdout) : _conc_str(output, '%');
						break;
				default : currChar = format[index];
				is_mintf ? (void)fputc(currChar, stdout) : _conc_str(output, currChar);
				index--;
			}
			index++;
		}								
		else{	
			is_mintf ? (void)fputc(format[index], stdout) : _conc_str(output, format[index]);
		}								
		index++;
	}while(format[index] != '\0');
}

// convert number into different radix form and add prefix
void _base_conv(bool is_mintf, int n, int radix, char* prefix, char* output){
	long int quo = n;						
	long int count = 0;					
	long int absVal = n;					
	int conVal;							
	long int radixPower = 1;			 
	int offs = 0;						
	if(n < 0){									
		is_mintf ? (void)fputc('-', stdout) : _conc_str(output, '-');
		absVal = (long int)n * -1;		
		quo *= -1;						
	}									
	if(prefix[0] == '.' && prefix[1] == '$'){									
		is_mintf ? (void)fputc('.', stdout) : _conc_str(output, '.');
	}									
	else{									
		do{								
			if(prefix[offs] != '\0'){				
				is_mintf ? (void)fputc(prefix[offs], stdout) : _conc_str(output, prefix[offs]);
			}							
			offs++;					
		}while(prefix[offs] != '\0');	
	}		
	// insert additional zero if post-decimal value is less than 10
	if(*prefix == '.' && n < 10){
		is_mintf ? (void)fputc('0', stdout) : _conc_str(output, '0');
	}									
	do{									
		quo = quo / radix;				
		count += 1;						
	}while(quo > 0);					
	for(int i = count - 1; i >= 0; i--){									
		radixPower = 1;					
		for(int j = 0; j < i; j++){								
			radixPower *= radix;		
		}								
		conVal = (absVal / radixPower) % radix;
		if(conVal >= 10){								
			is_mintf ? (void)fputc(conVal + 'W', stdout) : _conc_str(output, conVal + 'W');
		}								
		else{								
			is_mintf ? (void)fputc(conVal + '0', stdout) : _conc_str(output, conVal + '0');
		}								
	}
}

// concatenate string with new character
void _conc_str(char* orgString, char addChar){
	int addIndex;
	for(addIndex = 0; orgString[addIndex] != '\0'; addIndex++){	
	}
	orgString[addIndex] = addChar;
}

/* vim: set tabstop=4 shiftwidth=4 fileencoding=utf-8 noexpandtab: */
