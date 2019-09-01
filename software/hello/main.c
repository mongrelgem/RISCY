/* The RISCY Processor Benchmark Applications
   The RISCY Processor - A simple RISC-V based processor for FPGAs
   (c) Krishna Subramanian <https://github.com/mongrelgem>
*/

#include <stdint.h>

#include "platform.h"
#include "uart.h"

static struct uart uart0;

void exception_handler(uint32_t cause, void * epc, void * regbase)
{
	// Not used in this application
}

int main(void)
{
	uart_initialize(&uart0, (volatile void *) PLATFORM_UART0_BASE);
	uart_set_divisor(&uart0, uart_baud2divisor(115200, PLATFORM_SYSCLK_FREQ));
	uart_tx_string(&uart0, "Hello world. I  am the RISCY Processor\n\r");

	return 0;
}

