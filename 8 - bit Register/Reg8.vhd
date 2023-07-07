library ieee;
use ieee.std_logic_1164.all;

entity Reg8 is
	port
	(
		clk, Reset, clk_en : in std_logic;
		D_in : in std_logic_vector(7 downto 0);
		D_out : out std_logic_vector(7 downto 0)
	);
end Reg8;

architecture Reg8 of Reg8 is

begin

	r1:
	process(clk_en, clk, Reset) is  
	begin 
		if(Reset = '1') then
			D_out <= "00000000"; 
		elsif(rising_edge(clk) and clk_en = '1') then
			D_out <= D_in;
		end if;
	end process r1; 
end Reg8;
