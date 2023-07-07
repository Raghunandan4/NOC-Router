library ieee;
use ieee.std_logic_1164.all;

entity DeMux8 is
	port
	(
		d_in : in std_logic_vector(7 downto 0);
		sel : in std_logic_vector(1 downto 0);
		en : in std_logic;
		d_out1, d_out2, d_out3, d_out4 : out std_logic_vector(7 downto 0)
	);
end DeMux8;

architecture demux of DeMux8 is

begin

	d1:
	process(en, sel, d_in) is
	begin
		if (en = '1') then
			case sel is
				when "00" => d_out1 <= d_in;
				when "01" => d_out2 <= d_in;
				when "10" => d_out3 <= d_in;
				when "11" => d_out4 <= d_in;
				when others => null;
			end case;
		end if;
	end process d1;
end demux;