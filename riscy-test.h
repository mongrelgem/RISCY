/* The RISCY Processor - A simple RISC-V based processor for FPGAs
 (c) Krishna Subramanian <https://github.com/mongrelgem>
*/

#ifndef RISCY_TEST_H
#define RISCY_TEST_H

// Ensure that the following define is set to use this header in assembly code:
// #define RISCY_TEST_ASSEMBLY

// Address of the test and debug CSR:
#define RISCY_TEST_CSR		0xbf0

// Value of the test state field when no test is running:
#define RISCY_TEST_STATE_IDLE		0x0
// Value of the test state field when a test is running:
#define RISCY_TEST_STATE_RUNNING	0x1
// Value of the test state field when a test has failed:
#define RISCY_TEST_STATE_FAILED	0x2
// Value of the test state field when a test has passed:
#define RISCY_TEST_STATE_PASSED	0x3

#ifdef RISCY_TEST_ASSEMBLY

#define RISCY_TEST_START(testnum, tempreg) \
	li tempreg, testnum; \
	slli tempreg, tempreg, 2; \
	ori tempreg, tempreg, RISCY_TEST_STATE_RUNNING; \
	csrw RISCY_TEST_CSR, tempreg;

#define RISCY_TEST_FAIL() \
	csrci RISCY_TEST_CSR, 3; \
	csrsi RISCY_TEST_CSR, RISCY_TEST_STATE_FAILED;

#define RISCY_TEST_PASS() \
	csrci RISCY_TEST_CSR, 3; \
	csrsi RISCY_TEST_CSR, RISCY_TEST_STATE_PASSED;
#else

#define RISCY_TEST_START(testnum) \
	do { \
		uint32_t temp = testnum << 3 | RISCY_TEST_STATE_RUNNING; \
		asm volatile("csrw %[regname], %[regval]\n\t" :: [regname] "i" (RISCY_TEST_CSR), [regval] "r" (temp)); \
	} while(0)

#define RISCY_TEST_FAIL() \
	asm volatile("csrrci x0, %[regname], 3\n\tcsrrsi x0, %[regname], %[state]\n\t" \
		:: [regname] "i" (RISCY_TEST_CSR), [state] "i" (RISCY_TEST_STATE_FAILED))
#define RISCY_TEST_PASS() \
	asm volatile("csrrci x0, %[regname], 3\n\tcsrrsi x0, %[regname], %[state]\n\t" \
		:: [regname] "i" (RISCY_TEST_CSR), [state] "i" (RISCY_TEST_STATE_PASSED))
#endif

#endif

