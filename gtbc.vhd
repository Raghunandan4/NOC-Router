library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity gtbc is
	port
	(
		gin : in std_logic_vector(3 downto 0);
		bout : out std_logic_vector(3 downto 0)
	);
end gtbc;

architecture Behaviour of gtbc is

begin

	gtb1:
	process(gin) is
	begin
		bout(3) <= gin(3);
		bout(2) <= gin(3) xor gin(2);
		bout(1) <= gin(3) xor gin(2) xor gin(1);
		bout(0) <= gin(3) xor gin(2) xor gin(1) xor gin(0);
	end process gtb1;

end Behaviour;


