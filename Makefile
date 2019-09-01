# The RISCY Processor - A simple RISC-V based processor for FPGAs
# (c) Krishna Subramanian <https://github.com/mongrelgem>


.PHONY: all clean riscy.prj

SOURCE_FILES := \
	src/ry_alu.vhd \
	src/ry_alu_mux.vhd \
	src/ry_alu_control_unit.vhd \
	src/ry_icache.vhd \
	src/ry_comparator.vhd \
	src/ry_constants.vhd \
	src/ry_control_unit.vhd \
	src/ry_core.vhd \
	src/ry_counter.vhd \
	src/ry_csr.vhd \
	src/ry_csr_unit.vhd \
	src/ry_csr_alu.vhd \
	src/ry_decode.vhd \
	src/ry_execute.vhd \
	src/ry_fetch.vhd \
	src/ry_imm_decoder.vhd \
	src/ry_memory.vhd \
	src/ry_potato.vhd \
	src/ry_register_file.vhd \
	src/ry_types.vhd \
	src/ry_utilities.vhd \
	src/ry_wb_arbiter.vhd \
	src/ry_wb_adapter.vhd \
	src/ry_writeback.vhd
TESTBENCHES := \
	testbenches/tb_processor.vhd \
	testbenches/tb_soc.vhd \
	soc/ry_soc_memory.vhd

TOOLCHAIN_PREFIX ?= riscv32-unknown-elf

# ISA tests to use from the riscv-tests repository:
RISCV_TESTS += \
	simple \
	add \
	addi \
	and \
	andi \
	auipc \
	beq \
	bge \
	bgeu \
	blt \
	bltu \
	bne \
	jal \
	jalr \
	lb \
	lbu \
	lh \
	lhu \
	lui \
	lw \
	or \
	ori \
	sb \
	sh \
	sll \
	slt \
	slti \
	sltiu \
	sltu \
	sra \
	srai \
	srl \
	sub \
	sw \
	xor \
	xori

# Local tests to run:
LOCAL_TESTS += \
	csr_hazard

# Compiler flags to use when building tests:
TARGET_CFLAGS += -march=rv32i -Wall -O0
TARGET_LDFLAGS +=

all: riscy.prj run-tests run-soc-tests

riscy.prj:
	-$(RM) riscy.prj
	for file in $(SOURCE_FILES) $(TESTBENCHES); do \
		echo "vhdl work $$file" >> riscy.prj; \
	done

copy-riscv-tests:
	test -d tests || mkdir tests
	for test in $(RISCV_TESTS); do \
		cp riscv-tests/$$test.S tests; \
	done

compile-tests: copy-riscv-tests
	test -d tests-build || mkdir tests-build
	for test in $(RISCV_TESTS) $(LOCAL_TESTS); do \
		echo "Compiling test $$test..."; \
		$(TOOLCHAIN_PREFIX)-gcc -c $(TARGET_CFLAGS) -Driscy_TEST_ASSEMBLY -Iriscv-tests -o tests-build/$$test.o tests/$$test.S; \
		$(TOOLCHAIN_PREFIX)-ld $(TARGET_LDFLAGS) -T tests.ld tests-build/$$test.o -o tests-build/$$test.elf; \
		scripts/extract_hex.sh tests-build/$$test.elf tests-build/$$test-imem.hex tests-build/$$test-dmem.hex; \
	done

run-tests: riscy.prj compile-tests
	for test in $(RISCV_TESTS) $(LOCAL_TESTS); do \
		echo -ne "Running test $$test:\t"; \
		DMEM_FILENAME="empty_dmem.hex"; \
		test -f tests-build/$$test-dmem.hex && DMEM_FILENAME="tests-build/$$test-dmem.hex"; \
		xelab tb_processor -generic_top "IMEM_FILENAME=tests-build/$$test-imem.hex" -generic_top "DMEM_FILENAME=$$DMEM_FILENAME" -prj riscy.prj > /dev/null; \
		xsim tb_processor -R --onfinish quit > tests-build/$$test.results; \
		cat tests-build/$$test.results | awk '/Note:/ {print}' | sed 's/Note://' | awk '/Success|Failure/ {print}'; \
	done

run-soc-tests: riscy.prj compile-tests
	for test in $(RISCV_TESTS) $(LOCAL_TESTS); do \
		echo -ne "Running SOC test $$test:\t"; \
		DMEM_FILENAME="empty_dmem.hex"; \
		test -f tests-build/$$test-dmem.hex && DMEM_FILENAME="tests-build/$$test-dmem.hex"; \
		xelab tb_soc -generic_top "IMEM_FILENAME=tests-build/$$test-imem.hex" -generic_top "DMEM_FILENAME=$$DMEM_FILENAME" -prj riscy.prj > /dev/null; \
		xsim tb_soc -R --onfinish quit > tests-build/$$test.results-soc; \
		cat tests-build/$$test.results-soc | awk '/Note:/ {print}' | sed 's/Note://' | awk '/Success|Failure/ {print}'; \
	done

remove-xilinx-garbage:
	-$(RM) -r xsim.dir 
	-$(RM) xelab.* webtalk* xsim*

clean: remove-xilinx-garbage
	for test in $(RISCV_TESTS); do $(RM) tests/$$test.S; done
	-$(RM) -r tests-build
	-$(RM) riscy.prj

distclean: clean

