/*
 * Linker Script for the RISCY Processor test applications.
 * The RISCY Processor - A simple RISC-V based processor for FPGAs
 * (c) Krishna Subramanian <https://github.com/mongrelgem>
*/

/*
 * The linker script assumes that default testbench settings are used, that is,
 * 2048 bytes (each) of separate instruction and data memory.
 */

OUTPUT_ARCH(riscv);
ENTRY(_start);

SECTIONS
{
	.text 0x100 :
	{
		*(.text.init)
		*(.text)
	}

	.data 0x1000 :
	{
		__data_begin = .;
		*(.data*)
	}

	.bss :
	{
		__bss_begin = .;
		*(.bss*)
		__bss_end = .;
	}
	__data_end = .;

	__stack_top = 0x2000;
}

