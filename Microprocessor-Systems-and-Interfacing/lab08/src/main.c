#include "stm32f0xx.h"
#include "stm32f0_discovery.h"
#include <stdint.h>
#include <stdio.h>

// These are function pointers.  They can be called like functions
// after you set them to point to other functions.
// e.g.  cmd = bitbang_cmd;
// They will be set by the stepX() subroutines to point to the new
// subroutines you write below.
void (*cmd)(char b) = 0;
void (*data)(char b) = 0;
void (*display1)(const char *) = 0;
void (*display2)(const char *) = 0;

int col = 0;
int8_t history[16] = {0};
int8_t lookup[16] = {1,4,7,0xe,2,5,8,0,3,6,9,0xf,0xa,0xb,0xc,0xd};
char char_lookup[16] = {'1','4','7','*','2','5','8','0','3','6','9','#','A','B','C','D'};
extern int count;

// Prototypes for subroutines in support.c
void generic_lcd_startup(void);
void countdown(void);
void step1(void);
void step2(void);
void step3(void);
void step4(void);
void step6(void);

// This array will be used with dma_display1() and dma_display2() to mix
// commands that set the cursor location at zero and 64 with characters.
//
uint16_t dispmem[34] = {
        0x080 + 0,
        0x220, 0x220, 0x220, 0x220, 0x220, 0x220, 0x220, 0x220,
        0x220, 0x220, 0x220, 0x220, 0x220, 0x220, 0x220, 0x220,
        0x080 + 64,
        0x220, 0x220, 0x220, 0x220, 0x220, 0x220, 0x220, 0x220,
        0x220, 0x220, 0x220, 0x220, 0x220, 0x220, 0x220, 0x220,
};

//=========================================================================
// Subroutines for step 2.
//=========================================================================
void spi_cmd(char b) {
	while((SPI2->SR & SPI_SR_TXE) == 0) {
    	;
    }
	SPI2->DR = b;
}

void spi_data(char b) {
	while((SPI2->SR & SPI_SR_TXE) == 0) {
		;
	}
	SPI2->DR = 0x200 + b;
}

void spi_init_lcd(void) {
    RCC->AHBENR |= RCC_AHBENR_GPIOBEN;
    GPIOB->MODER |= 2<<24 | 2<<26 | 2<<30;
    GPIOB->AFR[1] &= ~(15<<16 | 15<<20 | 15<<28);
    RCC->APB1ENR |= RCC_APB1ENR_SPI2EN;
    SPI2->CR1 |= SPI_CR1_MSTR | SPI_CR1_BR_1 | SPI_CR1_BR_0; //highest baud rate is fPCLK/16 or 250 kHz
    SPI2->CR1 |= SPI_CR1_BIDIMODE | SPI_CR1_BIDIOE;
    SPI2->CR2 = SPI_CR2_DS_3 | SPI_CR2_DS_0 | SPI_CR2_SSOE | SPI_CR2_NSSP;
    SPI2->CR1 |= SPI_CR1_SPE;
    generic_lcd_startup();
}

//===========================================================================
// Subroutines for step 3.
//===========================================================================

// Display a string on line 1 using DMA.
void dma_display1(const char *s) {
	cmd(0x80 + 0);
	int x;
	for(x=0; x<16; x+=1)
		if (s[x])
			dispmem[x+1] = s[x] | 0x200;
		else
			break;
	for(   ; x<16; x+=1)
		dispmem[x+1] = 0x220;

	RCC->AHBENR |= RCC_AHBENR_DMA1EN;
	DMA1_Channel5->CCR &= ~DMA_CCR_EN;
	DMA1_Channel5->CMAR = (uint32_t)dispmem;
	DMA1_Channel5->CPAR = &(SPI2->DR);
	DMA1_Channel5->CNDTR = sizeof dispmem;
	DMA1_Channel5->CCR |= DMA_CCR_DIR | DMA_CCR_MINC | DMA_CCR_DIR;
	DMA1_Channel5->CCR &= ~(DMA_CCR_MSIZE | DMA_CCR_PSIZE | DMA_CCR_PL);
	SPI2->CR2 |= SPI_CR2_TXDMAEN;
	DMA1_Channel5->CCR |= DMA_CCR_EN;
}

//===========================================================================
// Subroutines for Step 4.
//===========================================================================

void dma_spi_init_lcd(void) {
    spi_init_lcd();
    RCC->AHBENR |= RCC_AHBENR_DMA1EN;
    DMA1_Channel5->CCR &= ~DMA_CCR_EN;
    DMA1_Channel5->CMAR = (uint32_t)dispmem;
    DMA1_Channel5->CPAR = (uint32_t)&(SPI2->DR);
    DMA1_Channel5->CNDTR = 34;
    DMA1_Channel5->CCR |= DMA_CCR_MINC | DMA_CCR_DIR | DMA_CCR_CIRC;
    DMA1_Channel5->CCR &= ~(DMA_CCR_PL | DMA_CCR_PSIZE_1 | DMA_CCR_MSIZE_1);
    DMA1_Channel5->CCR |= DMA_CCR_PSIZE_0 | DMA_CCR_MSIZE_0;
    NVIC->ISER[0] = 1<<DMA1_Channel4_5_IRQn;
    SPI2->CR2 |= SPI_CR2_TXDMAEN;
    DMA1_Channel5->CCR |= DMA_CCR_EN;
}

// Display a string on line 1 by copying a string into the
// memory region circularly moved into the display by DMA.
void circdma_display1(const char *s) {
    int x;
    for(x=0; x<16; x+=1)
        if (s[x])
            dispmem[x+1] = s[x] | 0x200;
        else
            break;
    for(   ; x<16; x+=1)
        dispmem[x+1] = 0x220;
}

//===========================================================================
// Display a string on line 2 by copying a string into the
// memory region circularly moved into the display by DMA.
void circdma_display2(const char *s) {
    int x;
    for(x=0; x<16; x+=1)
        if (s[x])
            dispmem[x+18] = s[x] | 0x200;
        else
            break;
    for(   ; x<16; x+=1)
        dispmem[x+18] = 0x220;
}

//===========================================================================
// Subroutines for Step 6.
//===========================================================================
void init_keypad() {
    RCC->AHBENR |= RCC_AHBENR_GPIOAEN;
    GPIOA->MODER &= ~(2<<0 | 2<<2 | 2<<4 | 2<<6);
    GPIOA->MODER |= 1<<0 | 1<<2 | 1<<4 | 1<<6;
    GPIOA->MODER &= ~(3<<8 | 3<<10 | 3<<12 | 3<<14);
    GPIOA->PUPDR &= ~(1<<8 | 1<<10 | 1<<12 | 1<<14);
    GPIOA->PUPDR |= 2<<8 | 2<<10 | 2<<12 | 2<<14;
}

void init_tim6(void) {
    RCC->APB1ENR |= RCC_APB1ENR_TIM6EN;
    TIM6->PSC = 480-1;
    TIM6->ARR = 100-1;
    TIM6->DIER |= TIM_DIER_UIE;
    NVIC->ISER[0] |= 1<<TIM6_DAC_IRQn;
    TIM6->CR1 |= TIM_CR1_CEN;
}

void TIM6_DAC_IRQHandler() {
    TIM6->SR &= ~TIM_SR_UIF;
    int row = (GPIOA->IDR >> 4) & 0xf;
    int index = col << 2;
    for(int i = 0; i < 4; i++) {
        history[index + i] = history[index + i] << 1;
        history[index + i] |= (row >> i) & 0x1;
    }
    col++;
    if(col > 3) {col = 0;}
    GPIOA->ODR = 1 << col;
    countdown();
}

int main(void)
{
    //step1();
    //step2();
    //step3();
    //step4();
    step6();
}
