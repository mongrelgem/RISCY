-- The RISCY Processor - A simple RISC-V based processor for FPGAs
-- (c) Krishna Subramanian <https://github.com/mongrelgem>

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.ry_csr.all;

--! @brief ALU used for calculating new values of control and status registers.
entity ry_csr_alu is
	port(
		x, y          : in  std_logic_vector(31 downto 0);
		result        : out std_logic_vector(31 downto 0);
		immediate     : in  std_logic_vector(4 downto 0);
		use_immediate : in  std_logic;
		write_mode    : in  csr_write_mode
	);
end entity ry_csr_alu;

architecture behaviour of ry_csr_alu is
	signal a, b : std_logic_vector(31 downto 0);
begin

	a <= x;
	b <= y when use_immediate = '0' else std_logic_vector(resize(unsigned(immediate), b'length));

	calculate: process(a, b, write_mode)
	begin
		case write_mode is
			when CSR_WRITE_NONE =>
				result <= a;
			when CSR_WRITE_SET =>
				result <= a or b;
			when CSR_WRITE_CLEAR =>
				result <= a and (not b);
			when CSR_WRITE_REPLACE =>
				result <= b;
		end case;
	end process calculate;

end architecture behaviour;
