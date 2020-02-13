.syntax unified
.cpu cortex-m0
.fpu softvfp
.thumb

//===================================================================
// ECE 362 Lab Experiment 3
// General Purpose I/O
//===================================================================

.equ  RCC,      0x40021000
.equ  AHBENR,   0x14
.equ  GPIOCEN,  0x00080000
.equ  GPIOBEN,  0x00040000
.equ  GPIOAEN,  0x00020000
.equ  GPIOC,    0x48000800
.equ  GPIOB,    0x48000400
.equ  GPIOA,    0x48000000
.equ  MODER,    0x00
.equ  IDR,      0x10
.equ  ODR,      0x14
.equ  PC0,      0x01
.equ  PC1,      0x04
.equ  PC2,      0x10
.equ  PC3,      0x40
.equ  PIN8,     0x00000100


//===========================================================
// Enable Ports B and C in the RCC AHBENR
// No parameters.
// No expected return value.
.global enable_ports
enable_ports:
    push    {r0,r1,r2,lr}
	ldr r0,=RCC
	ldr r1,=AHBENR
	adds r0,r1
	ldr r2,[r0]
	movs r1,#0b11
	lsls r1,r1,#18
	orrs r2,r1
	str r2,[r0]
    pop     {r0,r1,r2,pc}

//===========================================================
// Set bits 0-3 of Port C to be outputs.
// No parameters.
// No expected return value.
.global port_c_output
port_c_output:
    push    {r0,r1,r2,lr}
	ldr r0,=GPIOC
	ldr r2,[r0]
	movs r1,#0b01010101
	orrs r2,r1
	movs r1,#0b10101010
	bics r2,r1
	str r2,[r0]
    pop     {r0,r1,r2,pc}

//===========================================================
// Set the state of a single output pin to be high.
// Do not affect the other bits of the port.
// Parameter 1 is the GPIOx base address.
// Parameter 2 is the bit number of the pin.
// No expected return value.
.global setpin
setpin:
    push    {r0,r1,r2,r3,r4,lr}
    ldr r4,=ODR
	ldr r2,[r0,r4]
	movs r3,#1
	lsls r3,r1
	orrs r2,r3
	str r2,[r0,r4]
    pop     {r0,r1,r2,r3,r4,pc}

//===========================================================
// Set the state of a single output pin to be low.
// Do not affect the other bits of the port.
// Parameter 1 is the GPIOx base address.
// Parameter 2 is the bit number of the pin.
// No expected return value.
.global clrpin
clrpin:
    push    {r0,r1,r2,r3,r4,lr}
	ldr r4,=ODR
	ldr r2,[r0,r4]
	movs r3,#1
	lsls r3,r1
	bics r2,r3
	str r2,[r0,r4]
    pop     {r0,r1,r2,r3,r4,pc}

//===========================================================
// Get the state of the input data register of
// the specified GPIO.
// Parameter 1 is GPIOx base address.
// Parameter 2 is the bit number of the pin.
// The subroutine should return 0x1 if the pin is high
// or 0x0 if the pin is low.
.global getpin
getpin:
    push    {lr}
    ldr r3, =IDR
	ldr r2,[r0,r3]
	movs r3,#1
	lsls r3,r1
	ands r2,r3
	lsrs r2,r1
	movs r0,r2
    pop     {pc}

//===========================================================
// Get the state of the input data register of
// the specified GPIO.
// Parameter 1 is GPIOx base address.
// Parameter 2 is the direction of the shift
//
// Performs the following logic
// 1) Read the current content of GPIOx-ODR
// 2) If R1 = 1
//      (a) Left shift the content by 1
//      (b) Check if value exceeds 8
//      (c) If so set it to 0x1
// 3) If R1 = 0
//      (a) Right shift the content by 1
//      (b) Check if value is 0
//      (c) If so set it to 0x8
// 4) Store the new value in ODR
// No return value
.global seq_led
seq_led:
    push    {r0,r1,r2,lr}
    ldr r3,=ODR
	ldr r2,[r0,r3]
	cmp r1,#1
	beq if1
	cmp r1,#0
	beq if2
	b finish
if1:
	lsls r2,#1
	cmp r2,#8
	ble finish
	movs r2,#1
	b finish
if2:
	lsrs r2,#1
	cmp r2,#0
	bne finish
	movs r2,#8
finish:
	str r2,[r0,r3]
    pop     {r0,r1,r2,pc}

.global main
main:
    // Uncomment the line below to test "enable_ports"
    //bl  test_enable_ports

    // Uncomment the line below to test "port_c_output"
    //bl  test_port_c_output

    // Uncomment the line below to test "setpin and clrpin"
    //bl  test_set_clrpin

    // Uncomment the line below to test "getpin"
    //bl  test_getpin

    // Uncomment the line below to test "wiring"
    //bl  test_wiring

    // Uncomment to run the LED sequencing program
    //bl run_seq

inf_loop:
    b inf_loop