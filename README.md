# RISCY
Basic RISC-V RV32I CPU in VHDL for use in FPGA Prototyping
The RISCY Processor is a simple RISC-V processor written in VHDL for use in FPGAs. It implements the 32-bit integer subset of the RISC-V Specification version 2.0 and supports large parts of the the machine mode specified in the RISC-V Privileged Architecture Specification v1.10.




![Datapath Diagram](https://github.com/mongrelgem/RISCY/blob/master/docs/diagram.png?raw=true)




The processor has been tested on an Arty board using the example SoC design provided in the example/ directory and the applications found in the software/ directory. Synthesis and implementation has been tested on various versions of Xilinx' Vivado toolchain, most recently version 2018.2.



## Features

* Supports the complete **32-bit RISC-V base integer ISA (RV32I) version 2.0**
* Supports large parts of the machine mode defined in the RISC-V Privileged Architecture version 1.10
* Support for maximum of 8 individually maskable external interrupts (IRQs)
* Implements a classic 5-stage RISC pipeline
* Optional Modular instruction cache
* Included Hardware Timer with microsecond resolution and compare interupts
* Supports the Wishbone bus ( version B4 )

## Interfacing

The processor includes a wishbone interface conforming to the B4 revision of the wishbone specification

| Interface type            | Master  | 
| ------------- |:-------------------:| 
| Address port width        | 32 bits |
| Data port width           | 32 bits |
| Data port granularity     |  8 bits |
| Maximum Operand Size      | 32 bits |
| Endianess                 | Little  |
| Sequence of Data Transfer | In-order|

## Peripheral Interfacing

The project includes a variety of Wishbone-compatible peripherals for use in system-on-chip designs based on the RISC processor. The main peripherals are:

* **Timer**  a 32-bit timer with compare interrupt
* **GPIO**  a configurable-width generic GPIO module
* **Memory**  a block RAM memory module
* **UART**  a UART module with hardware FIFOs, configurable baudrate and RX/TX interrupts

## Getting Started
To instantiate the processor, add the source files from the src/ folder to your local project. Use the pp_potato entity to instantiate a processor with a Wishbone interface. Some generics are provided to configure the processor core.

An example System-on-Chip for the Arty development board can be found in the example/ directory of the source repository.

## Compiler Toolchain

In order to run programs on the RISCY processor, an appropriate compiler toolchain is needed. Follow the instructions on the [RISCV GNU toolchain](https://github.com/riscv/riscv-gnu-toolchain) repository site to build and install a 32-bit RISC-V toolchain.
