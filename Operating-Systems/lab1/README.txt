Files that needed to be changed for adding a new trap are identified.
First, the userprog.c is added with a user-side function "Getpid()".
Then, in traps.h, a new trap vector is defined for Getpid(), 0x500.
In usertraps.s, an assembly process "_getpid()" is added that invokes traps.c.
traps.c handles the trap in "dointerrupt()" and calls kernel function in process.c
Kernel function "GetCurrentPid()" performs pointer arithmetic by deducting pcbs from currentPCB.
The int value is then returned to traps.c and "dointerrupt()" invokes "ProcessSetResult()"
Finally, the userprog.c receives the returned value and uses "Printf()" to display the value.
