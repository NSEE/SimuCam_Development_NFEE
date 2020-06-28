library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.spwc_codec_pkg.all;

entity config_avs_stimuli is
	port(
		clk_avs_i                       : in  std_logic;
		rst_i                           : in  std_logic;
		spw_codec_link_status_avs_i     : in  t_spwc_codec_link_status;
		spw_codec_link_error_avs_i      : in  t_spwc_codec_link_error;
		spw_codec_timecode_rx_avs_i     : in  t_spwc_codec_timecode_rx;
		spw_codec_data_rx_status_avs_i  : in  t_spwc_codec_data_rx_status;
		spw_codec_data_tx_status_avs_i  : in  t_spwc_codec_data_tx_status;
		spw_codec_link_command_avs_o    : out t_spwc_codec_link_command;
		spw_codec_timecode_tx_avs_o     : out t_spwc_codec_timecode_tx;
		spw_codec_data_rx_command_avs_o : out t_spwc_codec_data_rx_command;
		spw_codec_data_tx_command_avs_o : out t_spwc_codec_data_tx_command
	);
end entity config_avs_stimuli;

architecture RTL of config_avs_stimuli is

	signal s_counter : natural := 0;

begin

	p_config_avs_stimuli : process(clk_avs_i, rst_i) is
	begin
		if (rst_i = '1') then

			s_counter <= 0;

			spw_codec_link_command_avs_o.autostart  <= '0';
			spw_codec_link_command_avs_o.linkstart  <= '0';
			spw_codec_link_command_avs_o.linkdis    <= '0';
			spw_codec_link_command_avs_o.txdivcnt   <= x"01";
			spw_codec_timecode_tx_avs_o.tick_in     <= '0';
			spw_codec_timecode_tx_avs_o.ctrl_in     <= (others => '0');
			spw_codec_timecode_tx_avs_o.time_in     <= (others => '0');
			spw_codec_data_rx_command_avs_o.rxread  <= '0';
			spw_codec_data_tx_command_avs_o.txwrite <= '0';
			spw_codec_data_tx_command_avs_o.txflag  <= '0';
			spw_codec_data_tx_command_avs_o.txdata  <= (others => '0');

		elsif rising_edge(clk_avs_i) then

			s_counter <= s_counter + 1;

			spw_codec_link_command_avs_o.autostart  <= '0';
			spw_codec_link_command_avs_o.linkstart  <= '0';
			spw_codec_link_command_avs_o.linkdis    <= '0';
			spw_codec_link_command_avs_o.txdivcnt   <= x"FF";
			spw_codec_timecode_tx_avs_o.tick_in     <= '0';
			spw_codec_timecode_tx_avs_o.ctrl_in     <= (others => '0');
			spw_codec_timecode_tx_avs_o.time_in     <= (others => '0');
			spw_codec_data_rx_command_avs_o.rxread  <= '0';
			spw_codec_data_tx_command_avs_o.txwrite <= '0';
			spw_codec_data_tx_command_avs_o.txflag  <= '0';
			spw_codec_data_tx_command_avs_o.txdata  <= (others => '0');

			case s_counter is

				when 500 =>
					spw_codec_timecode_tx_avs_o.tick_in <= '1';
					spw_codec_timecode_tx_avs_o.ctrl_in <= (others => '1');
					spw_codec_timecode_tx_avs_o.time_in <= (others => '1');

				when 502 =>
					spw_codec_timecode_tx_avs_o.tick_in <= '1';
					spw_codec_timecode_tx_avs_o.ctrl_in <= "10";
					spw_codec_timecode_tx_avs_o.time_in <= "101010";

				when 1500 =>
					spw_codec_data_tx_command_avs_o.txwrite <= '1';
					spw_codec_data_tx_command_avs_o.txflag  <= '1';
					spw_codec_data_tx_command_avs_o.txdata  <= (others => '1');

				when 1501 =>
					spw_codec_data_tx_command_avs_o.txwrite <= '1';
					spw_codec_data_tx_command_avs_o.txflag  <= '0';
					spw_codec_data_tx_command_avs_o.txdata  <= "10101010";

				when 2500 =>
					spw_codec_link_command_avs_o.autostart <= '1';
					spw_codec_link_command_avs_o.linkstart <= '0';
					spw_codec_link_command_avs_o.linkdis   <= '0';
					spw_codec_link_command_avs_o.txdivcnt  <= x"01";

				when others =>
					null;

			end case;

		end if;
	end process p_config_avs_stimuli;

end architecture RTL;
