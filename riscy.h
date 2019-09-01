/* The RISCY Processor - A simple RISC-V based processor for FPGAs
 (c) Krishna Subramanian <https://github.com/mongrelgem>
*/
#ifndef RISCY_H
#define RISCY_H

#include <stdint.h>

// Number of IRQs supported:
#define RISCY_NUM_IRQS		8

// Exception cause values:
#define RISCY_MCAUSE_INSTR_MISALIGN	0x00
#define RISCY_MCAUSE_INSTR_FETCH	0x01
#define RISCY_MCAUSE_INVALID_INSTR	0x02
#define RISCY_MCAUSE_BREAKPOINT	0x03
#define RISCY_MCAUSE_LOAD_MISALIGN	0x04
#define RISCY_MCAUSE_LOAD_ERROR	0x05
#define RISCY_MCAUSE_STORE_MISALIGN	0x06
#define RISCY_MCAUSE_STORE_ERROR	0x07
#define RISCY_MCAUSE_ECALL		0x0b

// IRQ base value
#define RISCY_MCAUSE_IRQ_BASE		0x80000010

// IRQ number mask
#define RISCY_MCAUSE_IRQ_MASK		0x0f

// Interrupt bit in the cause register:
#define RISCY_MCAUSE_INTERRUPT_BIT	31

// IRQ bit in the cause register:
#define RISCY_MCAUSE_IRQ_BIT		 4

// Status register bit indices:
#define STATUS_MIE	3		// Enable Interrupts
#define STATUS_MPIE	7		// Previous value of Enable Interrupts

#define riscy_enable_interrupts()	asm volatile("csrsi mstatus, 1 << %[mie_bit]\n" \
		:: [mie_bit] "i" (STATUS_MIE))
#define riscy_disable_interrupts() \
	do { \
		uint32_t temp = 1 << STATUS_MIE | 1 << STATUS_MPIE; \
		asm volatile("csrc mstatus, %[temp]\n" :: [temp] "r" (temp)); \
	} while(0)

#define riscy_write_host(data)	\
	do { \
		register uint32_t temp = data; \
		asm volatile("csrw mtohost, %[temp]\n" \
			:: [temp] "r" (temp)); \
	} while(0);

#define riscy_wfi() asm volatile("wfi\n\t")

/**
 * Gets the value of the MCAUSE register.
 */
static inline uint32_t riscy_get_mcause(void)
{
	register uint32_t retval = 0;
	asm volatile(
		"csrr %[retval], mcause\n"
		: [retval] "=r" (retval)
	);

	return retval;
}

/**
 * Enables a specific IRQ.
 * @note To globally enable IRQs, use the @ref riscy_enable_interrupts() function.
 */
static inline void riscy_enable_irq(uint8_t n)
{
	register uint32_t temp = 1 << (n + 24);
	asm volatile(
		"csrs mie, %[temp]\n"
		:: [temp] "r" (temp)
	);
}

/**
 * Disables a specific IRQ.
 */
static inline void riscy_disable_irq(uint8_t n)
{
	register uint32_t temp = 1 << (n + 24);
	asm volatile(
		"csrc mie, %[temp]\n"
		:: [temp] "r" (temp)
	);
}

#define riscy_get_badaddr(n) \
	do { \
		register uint32_t temp = 0; \
		asm volatile ( \
			"csrr %[temp], mbadaddr\n" \
			: [temp] "=r" (temp)); \
		n = temp; \
	} while(0)

#endif

