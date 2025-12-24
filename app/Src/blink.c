#include <msp430.h>

/* ===== USER CONFIGURATION ===== */
#define LED_ON_DELAY    200000UL   // LED ON time (cycles)
#define LED_OFF_DELAY   8000000UL   // LED OFF time (cycles)
/* ============================== */

int main(void)
{
    WDTCTL = WDTPW | WDTHOLD;   // Stop watchdog timer

    // --- Clock system initialization (CRITICAL) ---
    DCOCTL = 0;
    BCSCTL1 = CALBC1_1MHZ;
    DCOCTL = CALDCO_1MHZ;
    // ----------------------------------------------

    P1DIR |= BIT0;              // Set P1.0 as output (RED LED)
    P1OUT &= ~BIT0;             // Ensure LED is OFF at start

    while (1)
    {
        P1OUT |= BIT0;          // LED ON
        __delay_cycles(LED_ON_DELAY);

        P1OUT &= ~BIT0;         // LED OFF
        __delay_cycles(LED_OFF_DELAY);
    }
}
