library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.spwc_codec_pkg.all;

entity spw_stimuli_ent is
	port(
		clk_200                     : in  std_logic;
		rst                         : in  std_logic;
		spwc_codec_link_command_out : out spwc_codec_link_command_in_type;
		spwc_codec_link_status_in   : in  spwc_codec_link_status_out_type;
		spwc_codec_link_error_in    : in  spwc_codec_link_error_out_type;
		spwc_codec_timecode_rx_in   : in  spwc_codec_timecode_rx_out_type;
		spwc_codec_timecode_tx_out  : out spwc_codec_timecode_tx_in_type;
		spwc_codec_data_rx_out      : out spwc_codec_data_rx_in_type;
		spwc_codec_data_rx_in       : in  spwc_codec_data_rx_out_type;
		spwc_codec_data_tx_out      : out spwc_codec_data_tx_in_type;
		spwc_codec_data_tx_in       : in  spwc_codec_data_tx_out_type
	);
end entity spw_stimuli_ent;

architecture RTL of spw_stimuli_ent is

	signal cnt : natural := 0;

begin

	spw_stimuli_proc : process(clk_200, rst) is
	begin
		if (rst = '1') then

			spwc_codec_link_command_out.autostart <= '1';
			spwc_codec_link_command_out.linkstart <= '0';
			spwc_codec_link_command_out.linkdis   <= '0';
			spwc_codec_link_command_out.txdivcnt  <= x"01";

			spwc_codec_timecode_tx_out.ctrl_in <= (others => '0');
			spwc_codec_timecode_tx_out.time_in <= (others => '0');
			spwc_codec_timecode_tx_out.tick_in <= '0';

			spwc_codec_data_rx_out.rxread <= '0';

			spwc_codec_data_tx_out.txflag  <= '0';
			spwc_codec_data_tx_out.txdata  <= (others => '0');
			spwc_codec_data_tx_out.txwrite <= '0';

			cnt <= 0;

		elsif rising_edge(clk_200) then

			spwc_codec_link_command_out.linkstart <= '1' after 10 us;

			cnt <= cnt + 1;

			spwc_codec_data_tx_out.txflag  <= '0';
			spwc_codec_data_tx_out.txdata  <= (others => '0');
			spwc_codec_data_tx_out.txwrite <= '0';

			case (cnt) is

				when 10000 =>
					spwc_codec_data_tx_out.txflag  <= '0';
					spwc_codec_data_tx_out.txdata  <= X"F1";
					spwc_codec_data_tx_out.txwrite <= '1';

				when 10005 =>
					spwc_codec_data_tx_out.txflag  <= '0';
					spwc_codec_data_tx_out.txdata  <= X"F2";
					spwc_codec_data_tx_out.txwrite <= '1';

				when 10010 =>
					spwc_codec_data_tx_out.txflag  <= '0';
					spwc_codec_data_tx_out.txdata  <= X"F3";
					spwc_codec_data_tx_out.txwrite <= '1';

				when 10015 =>
					spwc_codec_data_tx_out.txflag  <= '0';
					spwc_codec_data_tx_out.txdata  <= X"F4";
					spwc_codec_data_tx_out.txwrite <= '1';

				when 10020 =>
					spwc_codec_data_tx_out.txflag  <= '0';
					spwc_codec_data_tx_out.txdata  <= X"F5";
					spwc_codec_data_tx_out.txwrite <= '1';

				when 10025 =>
					spwc_codec_data_tx_out.txflag  <= '0';
					spwc_codec_data_tx_out.txdata  <= X"F6";
					spwc_codec_data_tx_out.txwrite <= '1';
					
				when 10030 =>
					spwc_codec_data_tx_out.txflag  <= '0';
					spwc_codec_data_tx_out.txdata  <= X"F7";
					spwc_codec_data_tx_out.txwrite <= '1';

				when 10035 =>
					spwc_codec_data_tx_out.txflag  <= '0';
					spwc_codec_data_tx_out.txdata  <= X"F8";
					spwc_codec_data_tx_out.txwrite <= '1';

				when 10040 =>
					spwc_codec_data_tx_out.txflag  <= '0';
					spwc_codec_data_tx_out.txdata  <= X"F9";
					spwc_codec_data_tx_out.txwrite <= '1';

				when 10045 =>
					spwc_codec_data_tx_out.txflag  <= '0';
					spwc_codec_data_tx_out.txdata  <= X"FA";
					spwc_codec_data_tx_out.txwrite <= '1';

				when 10050 =>
					spwc_codec_data_tx_out.txflag  <= '0';
					spwc_codec_data_tx_out.txdata  <= X"FB";
					spwc_codec_data_tx_out.txwrite <= '1';

				when others => null;

			end case;

		end if;
	end process spw_stimuli_proc;

end architecture RTL;
