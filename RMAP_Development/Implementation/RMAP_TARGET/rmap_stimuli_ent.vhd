library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.rmap_target_pkg.all;

entity rmap_stimuli_ent is
	port(
		clk            : in  std_logic;
		rst            : in  std_logic;
		spw_tx_flag    : in  t_rmap_target_spw_tx_flag;
		spw_tx_control : out t_rmap_target_spw_tx_control
	);
end entity rmap_stimuli_ent;

architecture RTL of rmap_stimuli_ent is

begin

	stimuli_proc : process(clk, rst) is
		variable counter : natural range 0 to 16535 := 0;
	begin
		if rst = '1' then
			spw_tx_control.write <= '0';
			spw_tx_control.flag  <= '0';
			spw_tx_control.data  <= x"00";
		elsif rising_edge(clk) then

			counter := counter + 1;

			spw_tx_control.write <= '0';
			spw_tx_control.flag  <= '0';
			spw_tx_control.data  <= x"00";

			case counter is
				when 1001 =>
					spw_tx_control.write <= '1';
					spw_tx_control.flag  <= '0';
					spw_tx_control.data  <= x"FE";

				when 1002 =>
					spw_tx_control.write <= '1';
					spw_tx_control.flag  <= '0';
					spw_tx_control.data  <= x"01";

				when 1003 =>
					spw_tx_control.write <= '1';
					spw_tx_control.flag  <= '0';
					spw_tx_control.data  <= x"6C";

				when 1004 =>
					spw_tx_control.write <= '1';
					spw_tx_control.flag  <= '0';
					spw_tx_control.data  <= x"00";

				when 1005 =>
					spw_tx_control.write <= '1';
					spw_tx_control.flag  <= '0';
					spw_tx_control.data  <= x"67";

				when 1006 =>
					spw_tx_control.write <= '1';
					spw_tx_control.flag  <= '0';
					spw_tx_control.data  <= x"00";

				when 1007 =>
					spw_tx_control.write <= '1';
					spw_tx_control.flag  <= '0';
					spw_tx_control.data  <= x"00";

				when 1008 =>
					spw_tx_control.write <= '1';
					spw_tx_control.flag  <= '0';
					spw_tx_control.data  <= x"00";

				when 1009 =>
					spw_tx_control.write <= '1';
					spw_tx_control.flag  <= '0';
					spw_tx_control.data  <= x"A0";

				when 1010 =>
					spw_tx_control.write <= '1';
					spw_tx_control.flag  <= '0';
					spw_tx_control.data  <= x"00";

				when 1011 =>
					spw_tx_control.write <= '1';
					spw_tx_control.flag  <= '0';
					spw_tx_control.data  <= x"00";

				when 1012 =>
					spw_tx_control.write <= '1';
					spw_tx_control.flag  <= '0';
					spw_tx_control.data  <= x"00";

				when 1013 =>
					spw_tx_control.write <= '1';
					spw_tx_control.flag  <= '0';
					spw_tx_control.data  <= x"00";

				when 1014 =>
					spw_tx_control.write <= '1';
					spw_tx_control.flag  <= '0';
					spw_tx_control.data  <= x"00";

				when 1015 =>
					spw_tx_control.write <= '1';
					spw_tx_control.flag  <= '0';
					spw_tx_control.data  <= x"10";

				when 1016 =>
					spw_tx_control.write <= '1';
					spw_tx_control.flag  <= '0';
					spw_tx_control.data  <= x"9F";

				when 1017 =>
					spw_tx_control.write <= '1';
					spw_tx_control.flag  <= '0';
					spw_tx_control.data  <= x"01";

				when 1018 =>
					spw_tx_control.write <= '1';
					spw_tx_control.flag  <= '0';
					spw_tx_control.data  <= x"23";

				when 1019 =>
					spw_tx_control.write <= '1';
					spw_tx_control.flag  <= '0';
					spw_tx_control.data  <= x"45";

				when 1020 =>
					spw_tx_control.write <= '1';
					spw_tx_control.flag  <= '0';
					spw_tx_control.data  <= x"67";

				when 1021 =>
					spw_tx_control.write <= '1';
					spw_tx_control.flag  <= '0';
					spw_tx_control.data  <= x"89";

				when 1022 =>
					spw_tx_control.write <= '1';
					spw_tx_control.flag  <= '0';
					spw_tx_control.data  <= x"AB";

				when 1023 =>
					spw_tx_control.write <= '1';
					spw_tx_control.flag  <= '0';
					spw_tx_control.data  <= x"CD";

				when 1024 =>
					spw_tx_control.write <= '1';
					spw_tx_control.flag  <= '0';
					spw_tx_control.data  <= x"EF";

				when 1025 =>
					spw_tx_control.write <= '1';
					spw_tx_control.flag  <= '0';
					spw_tx_control.data  <= x"10";

				when 1026 =>
					spw_tx_control.write <= '1';
					spw_tx_control.flag  <= '0';
					spw_tx_control.data  <= x"11";

				when 1027 =>
					spw_tx_control.write <= '1';
					spw_tx_control.flag  <= '0';
					spw_tx_control.data  <= x"12";

				when 1028 =>
					spw_tx_control.write <= '1';
					spw_tx_control.flag  <= '0';
					spw_tx_control.data  <= x"13";

				when 1029 =>
					spw_tx_control.write <= '1';
					spw_tx_control.flag  <= '0';
					spw_tx_control.data  <= x"14";

				when 1030 =>
					spw_tx_control.write <= '1';
					spw_tx_control.flag  <= '0';
					spw_tx_control.data  <= x"15";

				when 1031 =>
					spw_tx_control.write <= '1';
					spw_tx_control.flag  <= '0';
					spw_tx_control.data  <= x"16";

				when 1032 =>
					spw_tx_control.write <= '1';
					spw_tx_control.flag  <= '0';
					spw_tx_control.data  <= x"17";

				when 1033 =>
					spw_tx_control.write <= '1';
					spw_tx_control.flag  <= '0';
					spw_tx_control.data  <= x"56";

				when 1034 =>
					spw_tx_control.write <= '1';
					spw_tx_control.flag  <= '1';
					spw_tx_control.data  <= x"00";

				when others =>
					null;

			end case;
		end if;
	end process stimuli_proc;

end architecture RTL;
