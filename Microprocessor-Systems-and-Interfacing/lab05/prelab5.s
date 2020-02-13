.cpu cortex-m0
.thumb
.syntax unified
//.fpu softvfp

// External interrupt for pins 0 and 1 is IRQ 5.
.equ EXTI0_1_IRQn,5

// RCC registers
.equ RCC, 0x40021000
.equ AHBENR, 0x14
.equ GPIOAEN, 0x00020000
.equ GPIOBEN, 0x00040000
.equ GPIOCEN, 0x00080000
.equ APB2ENR, 0x18
.equ SYSCFGCOMPEN, 1
.equ APB1ENR, 0x1C
.equ TIM6EN,0x16


//GPIOC registers
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
.equ BSRR,      0x18


// SYSCFG constrol registers
.equ SYSCFG, 0x40010000
.equ EXTICR1, 0x8
.equ EXTICR2, 0xc
.equ EXTICR3, 0x10
.equ EXTICR4, 0x14

// External interrupt control registers
.equ EXTI, 0x40010400
.equ IMR, 0
.equ EMR, 0x4
.equ RTSR, 0x8
.equ FTSR, 0xc
.equ SWIER, 0x10
.equ PR, 0x14

// Variables to register things for pin 0
.equ EXTI_RTSR_TR0, 1
.equ EXTI_IMR_MR0, 1
.equ EXTI_PR_PR0, 1

// NVIC control registers...
.equ NVIC, 0xe000e000
.equ ISER, 0x100
.equ ICER, 0x180
.equ ISPR, 0x200
.equ ICPR, 0x280

// SysTick counter variables...
.equ SYST, 0xe000e000
.equ CSR, 0x10
.equ RVR, 0x14
.equ CVR, 0x18

// TIM6 variables
.equ TIM6, 0x40001000
.equ PSC, 0x28
.equ ARR, 0x2C
.equ SR, 0x10
.equ DIER, 0xC


.text
.global enable_clock
enable_clock:
	push {lr}
	ldr r0,=RCC
	ldr r1,[r0,#AHBENR]
	ldr r2,=GPIOCEN
	orrs r1,r2
	str r1,[r0,#AHBENR]
	pop {pc}


.global enable_timer6
enable_timer6:
	push {lr}
	ldr r0,=RCC
	ldr r1,[r0,#APB1ENR]
	ldr r2,=TIM6EN
	orrs r1,r2
	str r1,[r0,#APB1ENR]
	pop {pc}


.global on_blue_light
on_blue_light:
	push {lr}
	ldr r0,=GPIOC
	ldr r2,[r0]
	ldr r1,=0x10000 //set moder PC8 into output
	orrs r2,r1
	str r2,[r0]
	ldr r2,=0x100  //set bit 8 of bssr to 1
	str r2,[r0,#BSRR]
	pop {pc}

.global off_blue_light
off_blue_light:
   push {lr}
   ldr r0,=GPIOC
   ldr r2,=0x1000000
   str r2,[r0,#BSRR]
   pop {pc}


.global enable_interrupt
enable_interrupt:
	push {lr}
	movs r1,#1
	lsls r1,#17
	ldr r0,=NVIC
	ldr r2,=ISER
	str r1,[r0,r2]
	pop {pc}

.global main
main:
    // Put any instructions you want here.
 	bl enable_clock
 	bl enable_timer6
	bl on_blue_light
	ldr r0,=TIM6
	ldr r1,=6000-1
	str r1,[r0,#PSC]
	ldr r1,=8000-1
	str r1,[r0,#ARR]
	ldr r1,[r0]
	movs r2,#1
	orrs r1,r2
	str r1,[r0]
	//////////////////////////
    bl  enable_interrupt
    /////////////////////////
    ldr r0,=TIM6
	ldr r1,[r0,#DIER]
	movs r2,#1
	orrs r1,r2
	str r1,[r0,#DIER]


loop:
	b loop



.type TIM6_DAC_IRQHandler, %function
.global TIM6_DAC_IRQHandler
TIM6_DAC_IRQHandler:
    push {r4,lr}
	ldr r0,=toggle
	ldr r4,[r0]
	cmp r4,#0
	beq turnoff
turnon:
	bl on_blue_light
	b done
turnoff:
	bl off_blue_light
done:
	mvns r4,r4
	ldr r0,=toggle
	str r4,[r0]
	// clear the flag
	ldr r0,=TIM6
	ldr r1,[r0,#SR]
	movs r2,#1
	bics r1,r2
	str r1,[r0,#SR]
	//////////////
	pop {r4,pc}

.data
.align 4
toggle: .word 0