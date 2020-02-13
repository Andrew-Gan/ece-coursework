#include "stm32f0xx.h"
#include "stm32f0_discovery.h"
#include <stdio.h>
#include <stdlib.h>

#define RATE 100000
#define N 1000
#define OUTPUT_FREQ 554.365
extern const short int wavetable[N];

int offset1 = 0;
int offset2 = 0;
int step1 = 554.365 * N / RATE * (1<<16);
int step2 = 698.456 * N / RATE * (1<<16);

// This function
// 1) enables clock to port A,
// 2) sets PA0, PA1, PA2 and PA4 to analog mode
void setup_gpio() {
    RCC->AHBENR |= RCC_AHBENR_GPIOAEN;
    GPIOA->MODER |= 3 + (3 << 2) + (3 << 4) + (3 << 8);
}

// This function should enable the clock to the
// onboard DAC, enable trigger,
// setup software trigger and finally enable the DAC.
void setup_dac() {
    RCC->APB1ENR |= RCC_APB1ENR_DACEN;
    DAC->CR &= ~DAC_CR_EN1;
    DAC->CR &= ~DAC_CR_BOFF1;
    DAC->CR |= DAC_CR_TEN1;
    DAC->CR |= DAC_CR_TSEL1;
    DAC->CR |= DAC_CR_EN1;
    while((DAC->SWTRIGR & DAC_SWTRIGR_SWTRIG1) == DAC_SWTRIGR_SWTRIG1);
}

// This function should,
// enable clock to timer6,
// setup pre scalar and arr so that the interrupt is triggered every
// 10us, enable the timer 6 interrupt, and start the timer.
void setup_timer6() {
    RCC->APB1ENR |= RCC_APB1ENR_TIM6EN;
    TIM6->PSC = 48-1;
    TIM6->ARR = 10-1;
    TIM6->DIER |= TIM_DIER_UIE;
    NVIC->ISER[0] = 1 << 17;
    TIM6->CR1 |= TIM_CR1_CEN;
}

// This function should enable the clock to ADC,
// turn on the clocks, wait for ADC to be ready.
void setup_adc() {
    RCC->APB2ENR |= RCC_APB2ENR_ADC1EN;
    RCC->CR2 |= RCC_CR2_HSI14ON;
    while(RCC->CR2 &= RCC_CR2_HSI14RDY == 0);
    ADC->CR |= ADC_CR_ADEN;
    while(ADC->ISR &= ADC_ISR_ADRDY == 0);
}

// This function should return the value from the ADC
// conversion of the channel specified by the “channel” variable.
// Make sure to set the right bit in channel selection
// register and do not forget to start adc conversion.
int read_adc_channel(unsigned int channel) {
    ADC->CHSELR = 0;
    ADC->CHSELR |= 1 << channel;
    while(ADC->ISR &= ADC_ISR_ADRDY == 0);
    ADC->CR |= ADC_CR_ADSTART;
    while(ADC->ISR &= ADC->ISR->EOC == 0);
}

void TIM6_DAC_IRQHandler(void) {
    TIM6->SR &= ~TIM_SR_UIF;
    offset1 += step1;
    offset2 += step2;
    if((offset1 >> 16) >= N)
        offset1 -= N<<16;
    if((offset2 >> 16) >= N)
        offset2 -= N<<16;

    int sample = wavetable[offset1>>16] + wavetable[offset2>>16];
    sample = sample / 32 + 2048;
    DAC->DHR12R1 = sample;
    DAC->SWTRIGR |= DAC_SWTRIGR_SWTRIG1;
}

int main(void)
{
    init_wavetable();
    setup_gpio();
    setup_dac();
    setup_timer6();
    while(1);
}