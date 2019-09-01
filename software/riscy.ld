/* Linker script for standalone test applications for the RISCY SoC
   The RISCY Processor - A simple processor for FPGA Prototyping
   The RISCY Processor - A simple RISC-V based processor for FPGAs
   (c) Krishna Subramanian <https://github.com/mongrelgem>
*/
ENTRY(_start)

MEMORY
{
	RAM (rwx)    : ORIGIN = 0x00000000, LENGTH = 0x00020000
}

SECTIONS
{
	.text :
	{
		*(.init)

		__text_begin = .;
		*(.text*)
		__text_end = .;
	} > RAM

	.rodata :
	{
		__rodata_begin = .;
		*(.rodata*)
		__rodata_end = .;
	} > RAM

	.data :
	{
		__data_begin = .;
		*(.data*)
		*(.eh_frame*)
		__data_end = .;
	} > RAM

	.bss ALIGN(4) :
	{
		__bss_begin = .;
		*(.bss*)
		*(.sbss*)
		__bss_end = ALIGN(4);
	} > RAM

	/* Set the start of the stack to the top of RAM: */
	__stack_top = 0x00020000;

	/DISCARD/ :
	{
		*(.comment)
	}
}

