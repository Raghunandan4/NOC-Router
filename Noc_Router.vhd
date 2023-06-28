library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity Noc_Router is
	port
	(
		data_in1, data_in2, data_in3, data_in4 : in std_logic_vector(7 downto 0);
		wr1, wr2, wr3, wr4 : in std_logic;
		wclock, rclock, rst : in std_logic;
		data_out1, data_out2, data_out3, data_out4 : out std_logic_vector(7 downto 0)
	);
end Noc_Router;

architecture Behaviour of Noc_Router is

begin

	component Reg
	port
	(
		clk, Reset, clk_en : in std_logic;
		D_in : in std_logic_vector(7 downto 0);
		D_out : out std_logic_vector(7 downto 0)
	);
	end component;

	FOR ALL : Reg USE ENTITY WORK.Reg(Reg8);

	component DEMUX
	port
	(
		d_in : in std_logic_vector(7 downto 0);
		sel : in std_logic_vector(1 downto 0);
		en : in std_logic;
		d_out1, d_out2, d_out3, d_out4 : out std_logic_vector(7 downto 0)
	);
	end component;
	
	FOR ALL : DEMUX USE ENTITY WORK.DEMUX(demux)


end Behaviour;


