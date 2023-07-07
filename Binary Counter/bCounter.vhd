library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity bCounter is
	port
	(
		clk, reset, en : in std_logic;
		c_out : out std_logic_vector(3 downto 0)
	);
end bCounter;

architecture Behaviour of bCounter is

	signal counter : unsigned(3 downto 0);

begin

	b1:
	process(clk) is 
	begin 
		if(rising_edge(clk)) then
			if(reset = '1') then
				counter <= "0000";
			elsif(en = '1') then
				counter <= counter + 1;
			end if;
		end if;	
	end process b1; 
	
	c_out <= counter;

end Behaviour;