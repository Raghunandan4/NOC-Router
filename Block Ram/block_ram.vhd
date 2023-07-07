library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity block_ram is
	port
	(
		d_in : in std_logic_vector(7 downto 0);
		addRA : in std_logic_vector(2 downto 0);
		addRB : in std_logic_vector(2 downto 0);
		wea : in std_logic := '1';
		rea : in std_logic := '1';
		clka : in std_logic;
		clkb : in std_logic;
		d_out : out std_logic_vector(7 downto 0)
	);
end block_ram;

architecture Behaviour of block_ram is

	subtype memo is std_logic_vector(7 downto 0);
	type mem is array(7 downto 0) of memo;
	signal ram : mem;

begin

	process(clka) is  
	begin 
		if(rising_edge(clka)) then
			if(wea = '1') then
				ram(to_integer(unsigned(addRA))) <= d_in;
			end if;	
		end if;
	end process;
	
	process(clkb) is  
	begin 
		if(rising_edge(clkb)) then
			if(rea = '1') then
				d_out <= ram(to_integer(unsigned(addRB)));
			elsif(rea = '0') then
				d_out <= "ZZZZZZZZ";
			end if;	
		end if;
	end process;  
	
end Behaviour;

