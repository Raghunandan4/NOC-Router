library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity gCounter is
	port
	(
		clk, reset, en : in std_logic;
		c_out : out std_logic_vector(3 downto 0)
	);
end Reg8;

architecture Behaviour of gCounter is

	component bCounter is
	
	port
	(
		clk, reset, en : in std_logic;
		c_out : out std_logic_vector(3 downto 0)
	);

	end component;
	
	FOR ALL : bCounter USE ENTITY WORK.bCounter(Behaviour);
	signal b_counter : unsigned(3 downto 0);
	
begin

	b_count : bCounter port map(clk => clk, en => en, reset => reset, c_out => b_counter);
	
	g1 :
	process (b_counter) is
	begin
		c_out(3) <= b_counter(3);
		
		for i in 2 downto 0 loop
			c_out(i) <= b_counter (i + 1) XOR b_counter(i);
		end loop;
	end process g1;
	
end Behaviour;

