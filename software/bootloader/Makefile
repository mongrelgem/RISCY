# The RISCY Processor Software Components
# The RISCY Processor - A simple RISC-V based processor for FPGAs
# (c) Krishna Subramanian <https://github.com/mongrelgem>

.PHONY: all clean
include ../common.mk

TARGET_LDFLAGS += -Wl,-Tbootloader.ld -Wl,--Map,bootloader.map

OBJECTS := main.o start.o

all: bootloader.elf bootloader.bin bootloader.coe

bootloader.elf: $(OBJECTS)
	$(TARGET_LD) -o bootloader.elf $(TARGET_LDFLAGS) $(OBJECTS)
	$(TARGET_SIZE) bootloader.elf

clean:
	-$(RM) $(OBJECTS)
	-$(RM) bootloader.elf bootloader.bin bootloader.coe

# Object file rules:

main.o: main.c ../../riscy.h
	$(TARGET_CC) -c -o $@ $(TARGET_CFLAGS) $<

start.o: ../start.S
	$(TARGET_CC) -DCOPY_DATA_TO_RAM -c -o $@ $(TARGET_CFLAGS) $<

