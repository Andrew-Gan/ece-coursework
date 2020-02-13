#ifndef __MINIUNIT_H__
#define __MINIUNIT_H__
#include <stdbool.h>
#include "clog.h"

int __mu_lineFailed;
const char* __func_name;

#define mu_start() __mu_lineFailed = 0

#define mu_check(condition) \
	if(condition == false) {__mu_lineFailed = __LINE__;} \
	__func_name = __func__

#define mu_run(function) \
	if(function() == false) {log_green("Test passed: (%s)\n", __func_name);} \
	else {log_red("Test failed: (%s) at line %d\n", __func_name, __mu_lineFailed);}

#define mu_end() return(__mu_lineFailed)

#endif
