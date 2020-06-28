library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.spwc_codec_pkg.all;

entity config_spw_stimuli is
	port(
		clk_spw_i                       : in  std_logic;
		rst_i                           : in  std_logic;
		spw_codec_link_command_spw_i    : in  t_spwc_codec_link_command;
		spw_codec_timecode_tx_spw_i     : in  t_spwc_codec_timecode_tx;
		spw_codec_data_rx_command_spw_i : in  t_spwc_codec_data_rx_command;
		spw_codec_data_tx_command_spw_i : in  t_spwc_codec_data_tx_command;
		spw_codec_link_status_spw_o     : out t_spwc_codec_link_status;
		spw_codec_link_error_spw_o      : out t_spwc_codec_link_error;
		spw_codec_timecode_rx_spw_o     : out t_spwc_codec_timecode_rx;
		spw_codec_data_rx_status_spw_o  : out t_spwc_codec_data_rx_status;
		spw_codec_data_tx_status_spw_o  : out t_spwc_codec_data_tx_status
	);
end entity config_spw_stimuli;

architecture RTL of config_spw_stimuli is

	signal s_counter : natural := 0;

begin

	p_config_spw_stimuli : process(clk_spw_i, rst_i) is
	begin
		if (rst_i = '1') then

			s_counter <= 0;

			spw_codec_link_status_spw_o.started    <= '0';
			spw_codec_link_status_spw_o.connecting <= '0';
			spw_codec_link_status_spw_o.running    <= '0';
			spw_codec_link_error_spw_o.errdisc     <= '0';
			spw_codec_link_error_spw_o.errpar      <= '0';
			spw_codec_link_error_spw_o.erresc      <= '0';
			spw_codec_link_error_spw_o.errcred     <= '0';
			spw_codec_timecode_rx_spw_o.tick_out   <= '0';
			spw_codec_timecode_rx_spw_o.ctrl_out   <= (others => '0');
			spw_codec_timecode_rx_spw_o.time_out   <= (others => '0');
			spw_codec_data_rx_status_spw_o.rxvalid <= '0';
			spw_codec_data_rx_status_spw_o.rxhalff <= '0';
			spw_codec_data_rx_status_spw_o.rxflag  <= '0';
			spw_codec_data_rx_status_spw_o.rxdata  <= (others => '0');
			spw_codec_data_tx_status_spw_o.txrdy   <= '0';
			spw_codec_data_tx_status_spw_o.txhalff <= '0';

		elsif rising_edge(clk_spw_i) then

			s_counter <= s_counter + 1;

			spw_codec_link_status_spw_o.started    <= '0';
			spw_codec_link_status_spw_o.connecting <= '0';
			spw_codec_link_status_spw_o.running    <= '0';
			spw_codec_link_error_spw_o.errdisc     <= '0';
			spw_codec_link_error_spw_o.errpar      <= '0';
			spw_codec_link_error_spw_o.erresc      <= '0';
			spw_codec_link_error_spw_o.errcred     <= '0';
			spw_codec_timecode_rx_spw_o.tick_out   <= '0';
			spw_codec_timecode_rx_spw_o.ctrl_out   <= (others => '0');
			spw_codec_timecode_rx_spw_o.time_out   <= (others => '0');
			spw_codec_data_rx_status_spw_o.rxvalid <= '0';
			spw_codec_data_rx_status_spw_o.rxhalff <= '0';
			spw_codec_data_rx_status_spw_o.rxflag  <= '0';
			spw_codec_data_rx_status_spw_o.rxdata  <= (others => '0');
			spw_codec_data_tx_status_spw_o.txrdy   <= '0';
			spw_codec_data_tx_status_spw_o.txhalff <= '0';

			case s_counter is

				when 500 =>
					spw_codec_timecode_rx_spw_o.tick_out <= '1';
					spw_codec_timecode_rx_spw_o.ctrl_out <= (others => '1');
					spw_codec_timecode_rx_spw_o.time_out <= (others => '1');

				when 501 =>
					spw_codec_timecode_rx_spw_o.tick_out <= '1';
					spw_codec_timecode_rx_spw_o.ctrl_out <= "10";
					spw_codec_timecode_rx_spw_o.time_out <= "101010";

				when 1500 =>
					spw_codec_data_rx_status_spw_o.rxvalid <= '1';
					spw_codec_data_rx_status_spw_o.rxhalff <= '0';
					spw_codec_data_rx_status_spw_o.rxflag  <= '1';
					spw_codec_data_rx_status_spw_o.rxdata  <= (others => '1');

				when 1502 =>
					spw_codec_data_rx_status_spw_o.rxvalid <= '1';
					spw_codec_data_rx_status_spw_o.rxhalff <= '0';
					spw_codec_data_rx_status_spw_o.rxflag  <= '0';
					spw_codec_data_rx_status_spw_o.rxdata  <= "10101010";

				when 2500 =>
					spw_codec_link_status_spw_o.started    <= '0';
					spw_codec_link_status_spw_o.connecting <= '1';
					spw_codec_link_status_spw_o.running    <= '0';
					spw_codec_link_error_spw_o.errdisc     <= '0';
					spw_codec_link_error_spw_o.errpar      <= '1';
					spw_codec_link_error_spw_o.erresc      <= '0';
					spw_codec_link_error_spw_o.errcred     <= '0';
					
				when 2501 =>
					spw_codec_link_status_spw_o.started    <= '1';
					spw_codec_link_status_spw_o.connecting <= '0';
					spw_codec_link_status_spw_o.running    <= '0';
					spw_codec_link_error_spw_o.errdisc     <= '0';
					spw_codec_link_error_spw_o.errpar      <= '0';
					spw_codec_link_error_spw_o.erresc      <= '1';
					spw_codec_link_error_spw_o.errcred     <= '0';
					
				when 2502 =>
					spw_codec_link_status_spw_o.started    <= '0';
					spw_codec_link_status_spw_o.connecting <= '0';
					spw_codec_link_status_spw_o.running    <= '0';
					spw_codec_link_error_spw_o.errdisc     <= '0';
					spw_codec_link_error_spw_o.errpar      <= '0';
					spw_codec_link_error_spw_o.erresc      <= '0';
					spw_codec_link_error_spw_o.errcred     <= '1';
					
				when 2503 =>
					spw_codec_link_status_spw_o.started    <= '0';
					spw_codec_link_status_spw_o.connecting <= '0';
					spw_codec_link_status_spw_o.running    <= '1';
					spw_codec_link_error_spw_o.errdisc     <= '1';
					spw_codec_link_error_spw_o.errpar      <= '0';
					spw_codec_link_error_spw_o.erresc      <= '0';
					spw_codec_link_error_spw_o.errcred     <= '0';
					
				when 2504 =>
					spw_codec_link_status_spw_o.started    <= '0';
					spw_codec_link_status_spw_o.connecting <= '0';
					spw_codec_link_status_spw_o.running    <= '0';
					spw_codec_link_error_spw_o.errdisc     <= '0';
					spw_codec_link_error_spw_o.errpar      <= '0';
					spw_codec_link_error_spw_o.erresc      <= '0';
					spw_codec_link_error_spw_o.errcred     <= '1';
					
				when 2505 =>
					spw_codec_link_status_spw_o.started    <= '0';
					spw_codec_link_status_spw_o.connecting <= '1';
					spw_codec_link_status_spw_o.running    <= '0';
					spw_codec_link_error_spw_o.errdisc     <= '0';
					spw_codec_link_error_spw_o.errpar      <= '1';
					spw_codec_link_error_spw_o.erresc      <= '0';
					spw_codec_link_error_spw_o.errcred     <= '0';
					
				when 2506 =>
					spw_codec_link_status_spw_o.started    <= '0';
					spw_codec_link_status_spw_o.connecting <= '0';
					spw_codec_link_status_spw_o.running    <= '0';
					spw_codec_link_error_spw_o.errdisc     <= '0';
					spw_codec_link_error_spw_o.errpar      <= '0';
					spw_codec_link_error_spw_o.erresc      <= '0';
					spw_codec_link_error_spw_o.errcred     <= '1';
					
				when 2507 =>
					spw_codec_link_status_spw_o.started    <= '0';
					spw_codec_link_status_spw_o.connecting <= '1';
					spw_codec_link_status_spw_o.running    <= '0';
					spw_codec_link_error_spw_o.errdisc     <= '0';
					spw_codec_link_error_spw_o.errpar      <= '1';
					spw_codec_link_error_spw_o.erresc      <= '0';
					spw_codec_link_error_spw_o.errcred     <= '0';
					
				when 2508 =>
					spw_codec_link_status_spw_o.started    <= '0';
					spw_codec_link_status_spw_o.connecting <= '0';
					spw_codec_link_status_spw_o.running    <= '0';
					spw_codec_link_error_spw_o.errdisc     <= '0';
					spw_codec_link_error_spw_o.errpar      <= '0';
					spw_codec_link_error_spw_o.erresc      <= '0';
					spw_codec_link_error_spw_o.errcred     <= '1';
					
				when 2509 to 3000 =>
					spw_codec_link_status_spw_o.started    <= '1';
					spw_codec_link_status_spw_o.connecting <= '1';
					spw_codec_link_status_spw_o.running    <= '1';
					spw_codec_link_error_spw_o.errdisc     <= '1';
					spw_codec_link_error_spw_o.errpar      <= '1';
					spw_codec_link_error_spw_o.erresc      <= '1';
					spw_codec_link_error_spw_o.errcred     <= '1';

				when others =>
					null;

			end case;

		end if;
	end process p_config_spw_stimuli;

end architecture RTL;
