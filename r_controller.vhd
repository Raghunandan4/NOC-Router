library ieee;
use ieee.std_logic_1164.all;

entity r_controller is
	port
	(
		rclk : in  std_logic;
		f1, f2, f3, f4  : in std_logic;
		rd_req : out std_logic
	);
end r_controller;

architecture controller of r_controller is

	type state is (fifo1, fifo2, fifo3, fifo4);
	signal current_fifo: state;
	signal next_fifo: state;

begin

	rc1 : process (rclk) is
	begin 
		if rising_edge(rclk) then
			current_fifo <= next_fifo;
		end if;
	end process rc1; 

	rc2 : process (current_fifo, f1, f2 , f3, f4) is 
	begin
		case current_fifo is
			when fifo1 =>
				next_fifo <= fifo2;
				if f1 = '0' then
					rd_req <= '1';
				else 
					rd_req <= '0';
				end if;
			
			when fifo2 =>
				next_fifo <= fifo3;
				if f2 = '0' then
					rd_req <= '1';
				else 
					rd_req <= '0';
				end if;

			when fifo3 =>
				next_fifo <= fifo4;
				if f3 = '0' then
					rd_req <= '1';
				else 
					rd_req <= '0';
				end if;

			when fifo4 =>
				next_fifo <= fifo1;
				if f4 = '0' then
					rd_req <= '1';
				else 
					rd_req <= '0';
				end if;
		end case;
	end process rc2;
end controller;

