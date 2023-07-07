library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity fifo is 
	port(
		reset, rclk, wclk, rreq, wreq : in std_logic;
		empty, full : out std_logic;
		datain : in std_logic_vector (7 downto 0);
		dataout : out std_logic_vector(7 downto 0)
		);
end fifo;

architecture Behaviour of fifo is 
	component fifo_c is 
		port(
		reset, rdclk, wrclk, r_req, w_req : in std_logic;
		write_valid, read_valid, empty, full : out std_logic;
		wr_ptr, rd_ptr : out std_logic_vector(2 downto 0)
		);
	end component;

	component block_ram is 
		port(
		d_in : in std_logic_vector(7 downto 0); --input
		d_out : out std_logic_vector(7 downto 0); --output
		wea : in std_logic ; --enable write
		rea : in std_logic ; --enable read
		addRA : in std_logic_vector(2 downto 0); --plsce to write
		addRB : in std_logic_vector(2 downto 0); --place to read
		clka : in std_logic ; --write clock
		clkb : in std_logic  --read clock
		);
	end component;


	signal rdvptr, wvptr : std_logic;
	signal addra_ptr ,addrb_ptr : std_logic_vector(2 downto 0);
	
begin
      
    controller : fifo_c
	port map(
		reset => reset,
		rdclk => rclk,
		wrclk => wclk,
		r_req => rreq,
		w_req => wreq,
		write_valid => wvptr,
		read_valid => rdvptr,
		wr_ptr => addra_ptr, 
		rd_ptr => addrb_ptr,
		full => full,
		empty => empty
		);

	memory : block_ram
	port map(
		wea => wvptr,
		rea => rdvptr,
		addRA => addra_ptr,
		addRB => addrb_ptr,
		clka => wclk,
		clkb => rclk,
		d_in => datain,
		d_out => dataout
		);

end Behaviour;
