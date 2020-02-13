.syntax unified
.cpu cortex-m0
.fpu softvfp
.thumb

/******************************************************************************

Arithmetic operations

Exercise 1
Description:
    R0, R1, R2, and R3 will be initialized with values. Fill in the provided
    subroutine body with assembly language instructions to set the value in R0
    to be (R0 * R1) + R2 - R3. Don't change any registers other than R0 - R3 to
    accomplish this.

******************************************************************************/
.global codeSegment1
codeSegment1:
	MULS	r0,r1
	ADDS	r0,r2
	SUBS	r0,r3
    bx lr

/******************************************************************************
Exercise 2
Description:
    R0, R1, R2, and R3 will be initialized with values. Fill in the provided
    subroutine body with assembly language instructions to set the value in R0
    to be ((-R0) * (R3 + R2)) - R1. Don't change any registers other than
    R0 - R3 to accomplish this.

******************************************************************************/
.global codeSegment2
codeSegment2:
	RSBS	r0,#0
	ADDS	r2,r3
	MULS	r0,r2
	SUBS	r0,r1
    bx lr

/******************************************************************************
Exercise 3
Description:
    R0, R1, R2, and R3 will be initialized with values. Fill in the provided
    subroutine body with assembly language instructions to set the value in
    R0 to be R3 - R2 - R1 - R0. Don't change any registers other than
    R0 - R3 to accomplish this.

******************************************************************************/
.global codeSegment3
codeSegment3:
	SUBS	r3,r2
	SUBS	r3,r1
	SUBS	r3,r0
	MOVS	r0,r3
    bx lr

/******************************************************************************

Logical operations
Exercise 4
Description:
    R0, R1, R2, and R3 will be initialized with values. Fill in the provided
    subroutine body with assembly language instructions to set the value in R0
    to be (R0 | R1) & (R2 ^ R3). Don't change any registers other than R0 - R3 to
    accomplish this.

******************************************************************************/
.global codeSegment4
codeSegment4:
	ORRS	r0,r1
	EORS	r2,r3
	ANDS	r0,r2
    bx lr

/******************************************************************************

Exercise 5
Description:
    R0, R1, R2, and R3 will be initialized with values. Fill in the provided
    subroutine body with assembly language instructions to set the value in R0
    to be (R0 << R3) | (R2 >> R1).
    Don't change any registers other than R0 - R3 to accomplish this.

******************************************************************************/
.global codeSegment5
codeSegment5:
	LSLS	r0,r3
	ASRS	r2,r1
	ORRS	r0,r2
    bx lr

.equ Data1, 0x5
/******************************************************************************

Immediate load operations
Exercise 6
Description:
    R0, R1, R2, and R3 are to be initialized to values specified. R0 to Data1,
    R1 to 255 (base 10), R2 to 510 (base 10), R3 to 0

******************************************************************************/
.global codeSegment6
codeSegment6:
	MOVS	r0,Data1
	MOVS	r1,#255
	MOVS	r2,#255
	ADDS	r2,#255
	MOVS	r3,#0
    bx lr

//=====================================================================
// Put all of the .equ statements for codeSegment7 below:
//=====================================================================
.equ	RCC,		0x40021000
.equ	AHBENR,		0x14
.equ	GPIOCEN,	0x00080000
.equ	GPIOC,		0x48000800
.equ	MODER,		0x00
.equ	ODR,		0x14
.equ	PIN8MOD,	0x00010000
.equ	PIN8,		0x00000100
//=====================================================================
// Fill in codeSegment7
//=====================================================================
.global codeSegment7
codeSegment7:
	// Enable clock to the GPIOC peripheral
	ldr		r2,=RCC
	ldr		r3,=AHBENR
	ldr		r1,=GPIOCEN
	ldr		r0,[r2,r3]
	orrs	r0,r1
	str		r0,[r2,r3]

	// Set the mode of pin 8 as output
	ldr		r2,=GPIOC
	ldr		r3,=MODER
	ldr		r1,=PIN8MOD
	ldr		r0,[r2,r3]
	orrs	r0,r1
	str		r0,[r2,r3]

	// Turn on LED
	ldr		r2,=GPIOC
	ldr		r3,=ODR
	ldr		r1,=PIN8
	ldr		r0,[r2,r3]

	ldr		r4,=PIN8
	orrs	r0,r4
	str		r0,[r2,r3]

loop_inf:
	bl		delay
	eors	r0,r4
	str		r0,[r2,r3]
	b		loop_inf

delay:
	ldr		r1,=6000000
delay_loop:
	subs	r1,r1,#1
	bne		delay_loop
    bx lr