/* Linker script for standalone test applications for the RISCY SoC
   The RISCY Processor - A simple RISC-V based processor for FPGAs
   (c) Krishna Subramanian <https://github.com/mongrelgem>
*/

ENTRY(_start)

MEMORY
{
	RAM (rwx)    : ORIGIN = 0x00000000, LENGTH = 0x00020000
	AEE_ROM (rx) : ORIGIN = 0xffff8000, LENGTH = 0x00004000
	AEE_RAM (rw) : ORIGIN = 0xffffc000, LENGTH = 0x00004000
}

SECTIONS
{
	.text :
	{
		*(.init)
		*(.text*)
		__text_end = .;
		*(.rodata*)
	} > AEE_ROM

	.data : AT(ADDR(.text) + SIZEOF(.text))
	{
		__data_begin = .;
		*(.data*)
		*(.eh_frame*)
		__data_end = ALIGN(4);
	} > AEE_RAM

	.bss ALIGN(4) :
	{
		__bss_begin = .;
		*(.bss*)
		*(.sbss)
		__bss_end = ALIGN(4);
	} > AEE_RAM

	/* Use the top of RAM and downwards for the stack: */
	__stack_top = 0x00000000;

	/DISCARD/ :
	{
		*(.comment)
	}
}

