#include <msp430.h>

void delay_ms(unsigned int ms);

int main(void)
{
    WDTCTL = WDTPW | WDTHOLD;   // Stop watchdog timer

    P1DIR |= BIT0;             // Set P1.0 (LED) as output
    P1OUT &= ~BIT0;            // LED OFF initially

    while (1)
    {
        P1OUT ^= BIT0;         // Toggle LED
        delay_ms(500);         // 500 ms delay
    }
}

void delay_ms(unsigned int ms)
{
    while (ms--)
    {
        __delay_cycles(1000);  // ~1 ms @ 1 MHz
    }
}
