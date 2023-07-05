library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity r_testbench is
end r_testbench;

architecture Behaviour of r_testbench is

  component Noc_Router is
    port (
      datai1, datai2, datai3, datai4 : in std_logic_vector(7 downto 0);
      wr1, wr2, wr3, wr4 : in std_logic;
      wclock, rclock, rst : in std_logic;
      data_out1, data_out2, data_out3, data_out4 : out std_logic_vector(7 downto 0)
    );
  end component Noc_Router;
  
--  FOR ALL: Noc_Router USE ENTITY WORK.Noc_Router(Behaviour);

  signal datai1, datai2, datai3, datai4 : std_logic_vector(7 downto 0);
  signal wr1, wr2, wr3, wr4 : std_logic;
  signal data_out1, data_out2, data_out3, data_out4 : std_logic_vector(7 downto 0);
  signal wclock, rclock, rst : std_logic;

  constant clk_period : time := 100 ns;

begin

  DUT : Noc_Router
    port map (
      rst => rst,
      rclock => rclock,
      wclock => wclock,
      datai1 => datai1,
      datai2 => datai2,
      datai3 => datai3,
      datai4 => datai4,
      wr1 => wr1,
      wr2 => wr2,
      wr3 => wr3,
      wr4 => wr4,
      data_out1 => data_out1,
      data_out2 => data_out2,
      data_out3 => data_out3,
      data_out4 => data_out4
    );

  rclk_process : process
  begin
    rclock <= '0';
    wait for clk_period / 2;
    rclock <= '1';
    wait for clk_period / 2;
  end process rclk_process;

  wrclk_process : process
  begin
    wclock <= '0';
    wait for clk_period / 2;
    wclock <= '1';
    wait for clk_period / 2;
  end process wrclk_process;

  stim_p : process
  begin
    rst <= '1';
    datai1 <= "00000100";
    datai2 <= "00000011";
    datai3 <= "00000010";
    datai4 <= "00000001";
    wr1 <= '1';
    wr2 <= '1';
    wr3 <= '1';
    wr4 <= '1';

    wait for clk_period;
    datai1 <= "00000100";
    datai2 <= "00000011";
    datai3 <= "00000010";
    datai4 <= "00000001";
    rst <= '0';
    wr1 <= '1';
    wr2 <= '1';
    wr3 <= '1';
    wr4 <= '1';

    wait for clk_period;
    datai1 <= "00010000";
    datai2 <= "00100000";
    datai3 <= "00110000";
    datai4 <= "01000000";

    wait for clk_period;
    datai2 <= "00100000";

    wait for clk_period;
    assert data_out2 = "001000000"
    severity error;

    wait for clk_period;
    wr1 <= '0';
    wr2 <= '0';
	wr3 <= '0';
	wr4 <= '0';
        
	wait for clk_period;
	datai1 <= "00000000";
	datai2 <= "00000011";
	datai3 <= "00000000";
	datai4 <= "00000000";
			
	wait for clk_period;
	assert data_out2 = "00000001"
	severity Error;
			
	wait for clk_period;
	datai1 <= "00000100";
	datai2 <= "00000000";
	datai3 <= "00000000";
	datai4 <= "00000000";
			
	wait for clk_period;
	assert data_out1 = "00000100"
	severity Error;
			
	wait for clk_period;
	datai1 <= "00000000";
	datai2 <= "00000000";
	datai3 <= "00000000";
	datai4 <= "00000011";
			
	wait for clk_period;
	assert data_out4 = "00000011"
	severity Error;
			
	wait for clk_period;
	datai1 <= "00000000";
	datai2 <= "00000000";
	datai3 <= "00000010";
	datai4 <= "00000000";
			
	wait for clk_period;
	assert data_out3 = "00000010"
	severity Error;
			
	wait for clk_period;
	datai1 <= "00010000";
	datai2 <= "00100000";
	datai3 <= "00110000";
	datai4 <= "01000000";
			
	wait for clk_period / 2;

    wait;
    end process;

end Behaviour;
