# The RISCY Processor Software Components
# The RISCY Processor - A simple RISC-V based processor for FPGAs
# (c) Krishna Subramanian <https://github.com/mongrelgem>


.PHONY: all clean
include ../common.mk

TARGET_LDFLAGS += -Wl,-T../riscy.ld -Wl,--Map,hello.map

OBJECTS := main.o start.o

all: hello.elf hello.bin hello.coe

hello.elf: $(OBJECTS)
	$(TARGET_LD) -o hello.elf $(TARGET_LDFLAGS) $(OBJECTS)
	$(TARGET_SIZE) hello.elf

clean:
	-$(RM) $(OBJECTS)
	-$(RM) hello.elf hello.bin hello.coe

# Object file rules:

main.o: main.c ../../riscy.h
	$(TARGET_CC) -c -o $@ $(TARGET_CFLAGS) $<

start.o: ../start.S
	$(TARGET_CC) -c -o $@ $(TARGET_CFLAGS) $<

