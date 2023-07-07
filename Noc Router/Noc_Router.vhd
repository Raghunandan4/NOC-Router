library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity Noc_Router is
	port
	(
		datai1, datai2, datai3, datai4 : in std_logic_vector(7 downto 0);
		wr1, wr2, wr3, wr4 : in std_logic;
		wclock, rclock, rst : in std_logic;
		data_out1, data_out2, data_out3, data_out4 : out std_logic_vector(7 downto 0)
	);
end Noc_Router;

architecture Behaviour of Noc_Router is

	component Reg8
	port
	(
		clk, Reset, clk_en : in std_logic;
		D_in : in std_logic_vector(7 downto 0);
		D_out : out std_logic_vector(7 downto 0)
	);
	end component;

	FOR ALL : Reg8 USE ENTITY WORK.Reg8(Reg8);

	component DeMux8
	port
	(
		d_in : in std_logic_vector(7 downto 0);
		sel : in std_logic_vector(1 downto 0);
		en : in std_logic;
		d_out1, d_out2, d_out3, d_out4 : out std_logic_vector(7 downto 0)
	);
	end component;
	
	FOR ALL : DeMux8 USE ENTITY WORK.DeMux8(demux);

	component round_robin is 
	port
	(
		din1, din2, din3, din4 : in std_logic_vector(7 downto 0);
		clk : in std_logic;
		dout : out std_logic_vector(7 downto 0)
	);
	end component;

--	FOR ALL: round_robin USE ENTITY WORK.round_robin(Behaviour);

	component r_controller is
	port
	(
		rclk : in  std_logic;
		f1, f2, f3, f4  : in std_logic;
		rd_req : out std_logic
	);
	end component;

--	FOR ALL: r_controller USE ENTITY WORK.r_controller(controller);

	type arrOfVectors_sig is array(0 to 3) of std_logic_vector (7 downto 0);
	type arrOfVectors_2D_sig is array (0 to 3, 0 to 3) of std_logic_vector(7 downto 0); 
	type arr_2D_sig is array(0 to 3,0 to 3) of std_logic;
	type arr4x1 is array (0 to 3) of std_logic; 

	signal RegOutput: arrOfVectors_sig;
	signal OBOutput: arrOfVectors_sig;
	signal DeMuxArrOutput: arrOfVectors_2D_sig;
	signal FifoOutput: arrOfVectors_2D_sig;
	signal FifotoRR: arrOfVectors_2D_sig;
	signal Empty: arr_2D_sig;
	signal Full: arr_2D_sig;
	signal controllerFlag: arr4x1;
	signal Wrreq_arr: arr4x1;
	signal Wrreq: arr_2D_sig;
	signal Data_in: arrOfVectors_sig;
	signal Data_out: arrOfVectors_sig;

begin	

	Wrreq_arr <= (wr1, wr2, wr3, wr4);
	Data_in <= (datai1, datai2, datai3, datai4);


	p1: process (Data_in, Wrreq_arr, wclock) is 
	begin
		loop1: for i in 0 to 3 loop
			loop2: for j in 0 to 3 loop
				if Wrreq_arr(i)= '1' and RegOutput(i)(1 downto 0) = j then
					Wrreq(i,j) <= '1';
				else 
					Wrreq(i,j) <= '0';
				end if;
			end loop loop2;
		end loop loop1;
	end process p1;
	

	-- Input REGISTER -- 
	IB1 : Reg8 
	port map(clk => wclock, D_in => datai1, reset => rst, clk_en => wr1, D_out => RegOutput(0));
	
	IB2 : Reg8
	port map(clk => wclock, D_in => datai2, reset => rst, clk_en => wr2, D_out => RegOutput(1));
	
	IB3 : Reg8
	port map(clk => wclock, D_in => datai3, reset => rst, clk_en => wr3, D_out => RegOutput(2));
	
	IB4 : Reg8
	port map(clk => wclock, D_in => datai4, reset => rst, clk_en => wr4, D_out => RegOutput(3));
	

	-- DEMUX -- 
	DeMux1: DeMux8
	port map(d_in => RegOutput(0), sel => (RegOutput(0)(1 downto 0)), en => wr1, d_out1 => DeMuxArrOutput(0,0),
         d_out2 => DeMuxArrOutput(0, 1), d_out3 => DeMuxArrOutput(0,2), d_out4 => DeMuxArrOutput(0,3));
         
    DeMux2: DeMux8
	port map(d_in => RegOutput(1), sel => (RegOutput(1)(1 downto 0)), en => wr2, d_out1 => DeMuxArrOutput(1,0),
         d_out2 => DeMuxArrOutput(1,1), d_out3 => DeMuxArrOutput(1,2),d_out4 => DeMuxArrOutput(1,3));
         
	DeMux3: DeMux8
	port map(d_in => RegOutput(2), sel => (RegOutput(2)(1 downto 0)), en => wr3, d_out1 => DeMuxArrOutput(2,0),
         d_out2 => DeMuxArrOutput(2,1), d_out3 => DeMuxArrOutput(2,2), d_out4 => DeMuxArrOutput(2,3));
         
	DeMux4: DeMux8
	port map(d_in => RegOutput(3), sel => (RegOutput(3)(1 downto 0)), en => wr4, d_out1 => DeMuxArrOutput(3,0),
         d_out2 => DeMuxArrOutput(3,1), d_out3 => DeMuxArrOutput(3,2), d_out4 => DeMuxArrOutput(3,3));
    
	
	-- Round Robin -- 
	RR1: round_robin
	port map(clk => rclock, din1 => FifotoRR(0,0), din2 => FifotoRR(0,1), 
	din3 => FifotoRR(0,2), din4 => FifotoRR(0,3), dout => Data_out(0));
	
	RR2: round_robin
	port map(clk => rclock, din1 => FifotoRR(1,0), din2 => FifotoRR(1,1), 
	din3 => FifotoRR(1,2), din4 => FifotoRR(1,3), dout => Data_out(1));
	
	RR3: round_robin
	port map(clk => rclock, din1 => FifotoRR(2,0), din2 => FifotoRR(2,1), 
	din3 => FifotoRR(2,2), din4 => FifotoRR(2,3), dout => Data_out(2));
	
	RR4: round_robin
	port map(clk => rclock, din1 => FifotoRR(3,0), din2 => FifotoRR(3,1), 
	din3 => FifotoRR(3,2), din4 => FifotoRR(3,3), dout => Data_out(3));
	

	-- Router Controller -- 
	CTRL1: r_controller
	port map(rclk => rclock, f1 => Empty(0,0), f2 => Empty(0,1), f3 => Empty(0,2), f4 => Empty(0,3), rd_req => controllerFlag(0));  
	
	CTRL2: r_controller
	port map(rclk=> rclock, f1 => Empty(1,0), f2 => Empty(1,1), f3 => Empty(1,2), f4 => Empty(1,3), rd_req => controllerFlag(1));
	  
	CTRL3: r_controller
	port map(rclk=> rclock, f1 => Empty(2,0), f2 => Empty(2,1), f3 => Empty(2,2), f4 => Empty(2,3), rd_req => controllerFlag(2));
	  
	CTRL4: r_controller
	port map(rclk=> rclock, f1 => Empty(3,0), f2 => Empty(3,1), f3 => Empty(3,2), f4 => Empty(3,3), rd_req => controllerFlag(3));  

	Fifo_outer_loop: FOR i IN 0 TO 3 GENERATE
		begin
			Fifo_inner_loop: FOR j IN 0 TO 3 GENERATE

--	FOR ALL: fifo USE ENTITY WORK.fifo(struct);

--	begin
--	routerFIFO: fifo
--		port map(reset => rst, rclk => rclock, wclk => wclock, rreq => controllerFlag(i), wreq => Wrreq(i, j), datain => DeMuxArrOutput(j, i), dataout => FifotoRR(i, j), full => Full(i, j), empty => Empty(i, j)); 
		END GENERATE Fifo_inner_loop;
	END GENERATE Fifo_outer_loop;

	-- Output REGISTER -- 
	OB1 : Reg8 
	port map(clk => rclock, D_in => Data_out(0), reset => rst, clk_en => '1', D_out => OBOutput(0));
	
	OB2 : Reg8
	port map(clk => rclock, D_in => Data_out(1), reset => rst, clk_en => '1', D_out => OBOutput(1));
	
	OB3 : Reg8
	port map(clk => rclock, D_in => Data_out(2), reset =>rst, clk_en => '1', D_out => OBOutput(2));
	
	OB4 : Reg8
	port map(clk => rclock, D_in => Data_out(3), reset => rst, clk_en => '1', D_out => OBOutput(3));

	data_out1 <= OBOutput(0);
	data_out2 <= OBOutput(1);
	data_out3 <= OBOutput(2);
	data_out4 <= OBOutput(3);

end Behaviour;