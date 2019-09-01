-- The RISCY Processor - A simple RISC-V based processor for FPGAs
-- (c) Krishna Subramanian <https://github.com/mongrelgem>
library ieee;
use ieee.std_logic_1164.all;

use work.ry_types.all;

package ry_constants is

	--! No-operation instruction, addi x0, x0, 0.
	constant RISCV_NOP : std_logic_vector(31 downto 0) := (31 downto 5 => '0') & b"10011"; --! ADDI x0, x0, 0.

end package ry_constants;
