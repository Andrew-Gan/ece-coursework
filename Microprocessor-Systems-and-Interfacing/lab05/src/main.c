#include "stm32f0xx.h"
#include "stm32f0_discovery.h"

// Prototypes.
void init_GPIO(void);
void init_TIM6(void);
void testTIM6(void);
void testInitGPIO(void);
void testProb3(void);
int getKeyPressed(void);
int getKeyReleased(void);

int col = 0;
int8_t history[16] = {0};
uint32_t tick = 0;

void displayKey(int key) {
	GPIOC->ODR = key & 0xf;
}

void testDebounce() {
    init_GPIO();
    init_TIM6();
    while(1) {
    	int key = getKeyPressed();
    	if (key == getKeyReleased())
    	    displayKey(key);
    }
}

int main(void)
{
	// testTIM6();
	// testInitGPIO();
	// testProb3();
	testDebounce();
	while(1);
}
