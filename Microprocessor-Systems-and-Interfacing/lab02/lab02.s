.cpu cortex-m0
.thumb
.syntax unified
.fpu softvfp

.global main
main:
	// r0 reserved as value of 'i'
	// r1 reserved as value of 'count'
	movs r0,#0
	ldr r1,=count
	ldr r1,[r1]

	// r2 reserved as value of 'value'
	ldr r2,=value
	ldr r2,[r2]

	// r3 reserved as addr of 'source'
	ldr r3,=source

	// r7 reserved as addr of 'result'
	ldr r7,=result

loop0:
	cmp r0,r1
	bge finish0

	// r4 is lit. value '0xf'
	movs r4,#15
	// r4 is current index of item in source
	ands r4,r2
	// r4 is memory offset of source in bytes
	muls r4,r1
	// r6 is value of source[value & 0xf]
	ldr r6,[r3,r4]
	// value += source[value & 0xf]
	adds r2,r6
	// r4 is lit. value '0x3'
	movs r4,#3
	// r4 is value of 'target'
	ands r4,r2
	cmp r4,#1
	bgt if0

	// else statement
	// common execution for if and else
	// r4 is memory offset of result in bytes
	muls r4,r1
	// r5 is value of result[target]
	ldr r5,[r7,r4]
	adds r5,#1
	str r5,[r7,r4]
	adds r0,#1
	b loop0

if0:
    // common execution for if and else
	// r4 is memory offset of result in bytes
	muls r4,r1
	// r5 is value of result[target]
	ldr r5,[r7,r4]
	subs r5,#1
	str r5,[r7,r4]
	adds r0,#1
	b loop0

finish0:

// next segment of code

main1:
    // r0 reserved as value of 'x'
    movs r0,#0

    // r1 reserved as addr of 'str[]'
    ldr r1,=str

loop1:
    // r2 is value of str[x]
    ldrb r2,[r1,r0]
    cmp r2,#0
    beq finish1

    // check if str[x] within range 0~9
    adds r0,#1
    cmp r2,#0x30
    blt loop1
    cmp r2,#0x39
    bgt loop1

    movs r2,#0x3d
    subs r0,#1
    strb r2,[r1,r0]
    adds r0,#1
    b loop1

finish1:
    wfi

.data
.align 4
result:
    .word 0
	.word 0
	.word 0
	.word 0
source:
	.word 2
	.word 3
	.word 5
	.word 7
	.word 11
	.word 13
	.word 17
	.word 19
	.word 23
	.word 29
	.word 31
	.word 37
	.word 41
	.word 43
	.word 47
	.word 53
	.word 59
count:
	.word 4
value:
	.word 0
str:
    .string "hello, 01234 world 56789"