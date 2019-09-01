-- The RISCY Processor - A simple RISC-V based processor for FPGAs
-- (c) Krishna Subramanian <https://github.com/mongrelgem>

library ieee;
use ieee.std_logic_1164.all;

--! @brief Module decoding immediate values from instruction words.
entity ry_imm_decoder is
	port(
		instruction : in  std_logic_vector(31 downto 2);
		immediate   : out std_logic_vector(31 downto 0)
	);
end entity ry_imm_decoder;

architecture behaviour of ry_imm_decoder is
begin
	decode: process(instruction)
	begin
		case instruction(6 downto 2) is
			when b"01101" | b"00101" => -- U type
				immediate <= instruction(31 downto 12) & (11 downto 0 => '0');
			when b"11011" => -- J type
				immediate <= (31 downto 20 => instruction(31)) & instruction(19 downto 12) & instruction(20) & instruction(30 downto 21) & '0';
			when b"11001" | b"00000" | b"00100"  | b"11100"=> -- I type
				immediate <= (31 downto 11 => instruction(31)) & instruction(30 downto 20);
			when b"11000" => -- B type
				immediate <= (31 downto 12 => instruction(31)) & instruction(7) & instruction(30 downto 25) & instruction(11 downto 8) & '0';
			when b"01000" => -- S type
				immediate <= (31 downto 11 => instruction(31)) & instruction(30 downto 25) & instruction(11 downto 7);
			when others =>
				immediate <= (others => '0');
		end case;
	end process decode;
end architecture behaviour;
