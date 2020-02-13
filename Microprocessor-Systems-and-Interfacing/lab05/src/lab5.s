.syntax unified
.cpu cortex-m0
.fpu softvfp
.thumb

//=============================================================================
// ECE 362 Lab Experiment 5
// Timers
//
//=============================================================================

.equ  RCC,      0x40021000
.equ  APB1ENR,  0x1C
.equ  AHBENR,   0x14
.equ  TIM6EN,	0x10
.equ  GPIOCEN,  0x00080000
.equ  GPIOBEN,  0x00040000
.equ  GPIOAEN,  0x00020000
.equ  GPIOC,    0x48000800
.equ  GPIOB,    0x48000400
.equ  GPIOA,    0x48000000
.equ  MODER,    0x00
.equ  PUPDR,    0x0c
.equ  IDR,      0x10
.equ  ODR,      0x14
.equ  PC0,      0x01
.equ  PC1,      0x04
.equ  PC2,      0x10
.equ  PC3,      0x40
.equ  PIN8,     0x00000100

// NVIC control registers...
.equ NVIC,		0xe000e000
.equ ISER, 		0x100
.equ ICER, 		0x180
.equ ISPR, 		0x200
.equ ICPR, 		0x280

// TIM6 control registers
.equ  TIM6, 	0x40001000
.equ  CR1,		0x00
.equ  DIER,		0x0C
.equ  PSC,		0x28
.equ  ARR,		0x2C
.equ  TIM6_DAC_IRQn, 17
.equ  SR,		0x10

//=======================================================
// 6.1: Configure timer 6
//=======================================================
.global init_TIM6
init_TIM6:
	push {lr}
	// enable system clock to TIM6
	ldr r0, =RCC
	ldr r1, [r0, #APB1ENR]
	movs r2, #TIM6EN
	orrs r1, r2
	str r1, [r0, #APB1ENR]
	// set PSC and ARR
	ldr r0, =TIM6
	ldr r1, =48-1
	str r1, [r0, #PSC]
	ldr r1, =1000-1
	str r1, [r0, #ARR]
	ldr r1, [r0, #CR1]
	movs r2, #1
	orrs r1, r2
	str r1, [r0, #CR1]
	// enable UIE in TIM6_DIER
	movs r1, #1
	str r1, [r0, #DIER]
	// enable TIM6 intr in NVIC_ISER
	ldr r0, =NVIC
	ldr r1, =ISER
	ldr r2, [r0, r1]
	movs r3, #1
	lsls r3, #TIM6_DAC_IRQn
	orrs r2, r3
	str r2, [r0, r1]
	pop {pc}

//=======================================================
// 6.2: Confiure GPIO
//=======================================================
.global init_GPIO
init_GPIO:
	push {lr}
	ldr r0, =RCC
	ldr r1, [r0, #AHBENR]
	ldr r2, =GPIOAEN
	ldr r3, =GPIOCEN
	orrs r2, r3
	orrs r1, r2
	str r1, [r0, #AHBENR]
	ldr r0, =GPIOC
	ldr r1, [r0, #MODER]
	ldr r2, =0x10055
	orrs r1, r2
	str r1, [r0, #MODER]
	ldr r0, =GPIOA
	ldr r1, [r0, #MODER]
	ldr r2, =0x55
	orrs r1, r2
	str r1, [r0, #MODER]
	ldr r1, [r0, #PUPDR]
	ldr r2, =0xAA00
	orrs r1, r2
	str r1, [r0, #PUPDR]
	pop {pc}

//=======================================================
// 6.3 Blink blue LED using Timer 6 interrupt
// Write your interrupt service routine below.
//=======================================================
.type TIM6_DAC_IRQHandler,%function
.global TIM6_DAC_IRQHandler
TIM6_DAC_IRQHandler:
	// acknowledge interrupt
	push {lr}
	ldr r0, =TIM6
	ldr r1, [r0, #SR]
	movs r2, #1
	bics r1, r2
	str r1, [r0, #SR]
	// increment global var 'tick'
	ldr r0, =tick
	ldr r1, [r0]
	adds r1, #1
	str r1, [r0]
	// check if tick == 1000
	ldr r2, =1000
	cmp r1, r2
	bne added_feature
	// toggle bit 8 of GPIOC_ODR
	ldr r0, =GPIOC
	ldr r1, [r0, #ODR]
	movs r2, #1
	lsls r2, #8
	mvns r3, r2
	ands r3, r1
	mvns r4, r1
	ands r2, r4
	orrs r2, r3
	str r2, [r0, #ODR]
	ldr r0, =tick
	movs r1, #0
	str r1, [r0]

added_feature:
	// additions
	ldr r0, =col
	ldr r1, [r0]
	adds r1, #1
	movs r2, #3
	ands r1, r2
	str r1, [r0]

	movs r2, #1
	lsls r2, r1
	ldr r0, =GPIOA
	str r2, [r0, #ODR]

	lsls r1, #2
	ldr r0, =index
	str r1, [r0]

	movs r2, #0
	movs r3, #3
col_loop:
	cmp r2, r3
	bgt end_col_loop
	ldr r0, =history
	lsls r2, #2
	ldr r1, [r0, r2]
	lsls r1, #1
	str r1, [r0, r2]
	lsrs r2, #2
	adds r2, #1
	b col_loop
end_col_loop:

	movs r0, #0 //row
	ldr r1, =GPIOA
	ldr r0, [r1, #IDR]
	lsrs r0, #4
	movs r1, #0xf
	ands r0, r1

	movs r2, #0
	movs r3, #3
col_loop2:
	movs r5, r0
	cmp r2, r3
	bgt finish
	lsrs r5, r2
	movs r4, #1
	ands r5, r4
	ldr r1, =history
	lsls r2, #2
	ldr r4, [r1, r2]
	orrs r4, r5
	str r4, [r1, r2]
	lsrs r2, #2
	adds r2, #1
	b col_loop2
finish:
	pop {pc}

//=======================================================
// 6.5 Debounce keypad
//=======================================================
.global getKeyPressed
getKeyPressed:
	// r0:i, r1:16, r2:history
	push {r4, lr}
while_loop:
	movs r0, #0
	movs r1, #16
	ldr r2, =history
for_loop:
	cmp r0, r1
	bge end_for_loop
	lsls r0, #2
	ldr r3, [r2, r0]
	lsrs r0, #2

	movs r4, #1
	cmp r3, r4
	bne endif
if:
	ldr r3, =tick
	movs r4, #0
	str r4, [r3]
	b return
endif:
	adds r0, #1
	b for_loop
end_for_loop:
	b while_loop
return:
	pop {r4, pc}

.global getKeyReleased
getKeyReleased:
	// r0:i, r1:16, r2:history
	push {r4, lr}
while_loop_2:
	movs r0, #0
	movs r1, #16
	ldr r2, =history
for_loop_2:
	cmp r0, r1
	bge end_for_loop_2
	lsls r0, #2
	ldr r3, [r2, r0]
	lsrs r0, #2

	movs r4, #2
	mvns r4, r4
	cmp r3, r4
	bne endif_2
if_2:
	ldr r3, =tick
	movs r4, #0
	str r4, [r3]
	b return_2
endif_2:
	adds r0, #1
	b for_loop_2
end_for_loop_2:
	b while_loop_2
return_2:
	pop {r4, pc}
