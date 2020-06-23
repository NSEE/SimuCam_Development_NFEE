-- spwg_spw_glutton_top.vhd

-- This file was auto-generated as a prototype implementation of a module
-- created in component editor.  It ties off all outputs to ground and
-- ignores all inputs.  It needs to be edited to make it do something
-- useful.
-- 
-- This file will not be automatically regenerated.  You should check it in
-- to your version control system if you want to keep it.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.spw_codec_pkg.all;

entity spwg_spw_glutton_top is
	port(
		reset_i                       : in  std_logic                    := '0'; --          --                       reset_sink.reset
		clk_100_i                     : in  std_logic                    := '0'; --          --                clock_sink_100mhz.clk
		spw_link_status_started_i     : in  std_logic; --                                    -- conduit_end_spacewire_controller.spw_link_status_started_signal
		spw_link_status_connecting_i  : in  std_logic; --                                    --                                 .spw_link_status_connecting_signal
		spw_link_status_running_i     : in  std_logic; --                                    --                                 .spw_link_status_running_signal
		spw_link_error_errdisc_i      : in  std_logic; --                                    --                                 .spw_link_error_errdisc_signal
		spw_link_error_errpar_i       : in  std_logic; --                                    --                                 .spw_link_error_errpar_signal
		spw_link_error_erresc_i       : in  std_logic; --                                    --                                 .spw_link_error_erresc_signal
		spw_link_error_errcred_i      : in  std_logic; --                                    --                                 .spw_link_error_errcred_signal		
		spw_timecode_rx_tick_out_i    : in  std_logic; --                                    --                                 .spw_timecode_rx_tick_out_signal
		spw_timecode_rx_ctrl_out_i    : in  std_logic_vector(1 downto 0); --                 --                                 .spw_timecode_rx_ctrl_out_signal
		spw_timecode_rx_time_out_i    : in  std_logic_vector(5 downto 0); --                 --                                 .spw_timecode_rx_time_out_signal
		spw_data_rx_status_rxvalid_i  : in  std_logic; --                                    --                                 .spw_data_rx_status_rxvalid_signal
		spw_data_rx_status_rxhalff_i  : in  std_logic; --                                    --                                 .spw_data_rx_status_rxhalff_signal
		spw_data_rx_status_rxflag_i   : in  std_logic; --                                    --                                 .spw_data_rx_status_rxflag_signal
		spw_data_rx_status_rxdata_i   : in  std_logic_vector(7 downto 0); --                 --                                 .spw_data_rx_status_rxdata_signal
		spw_data_tx_status_txrdy_i    : in  std_logic; --                                    --                                 .spw_data_tx_status_txrdy_signal
		spw_data_tx_status_txhalff_i  : in  std_logic; --                                    --                                 .spw_data_tx_status_txhalff_signal
		spw_link_command_autostart_o  : out std_logic                    := '0'; --          --                                 .spw_link_command_autostart_signal
		spw_link_command_linkstart_o  : out std_logic                    := '0'; --          --                                 .spw_link_command_linkstart_signal
		spw_link_command_linkdis_o    : out std_logic                    := '0'; --          --                                 .spw_link_command_linkdis_signal
		spw_link_command_txdivcnt_o   : out std_logic_vector(7 downto 0) := (others => '0'); --                                 .spw_link_command_txdivcnt_signal
		spw_timecode_tx_tick_in_o     : out std_logic                    := '0'; --          --                                 .spw_timecode_tx_tick_in_signal
		spw_timecode_tx_ctrl_in_o     : out std_logic_vector(1 downto 0) := (others => '0'); --                                 .spw_timecode_tx_ctrl_in_signal
		spw_timecode_tx_time_in_o     : out std_logic_vector(5 downto 0) := (others => '0'); --                                 .spw_timecode_tx_time_in_signal
		spw_data_rx_command_rxread_o  : out std_logic                    := '0'; --          --                                 .spw_data_rx_command_rxread_signal
		spw_data_tx_command_txwrite_o : out std_logic                    := '0'; --          --                                 .spw_data_tx_command_txwrite_signal
		spw_data_tx_command_txflag_o  : out std_logic                    := '0'; --          --                                 .spw_data_tx_command_txflag_signal
		spw_data_tx_command_txdata_o  : out std_logic_vector(7 downto 0) := (others => '0') ---                                 .spw_data_tx_command_txdata_signal		

	);
end entity spwg_spw_glutton_top;

architecture rtl of spwg_spw_glutton_top is

	-- Alias --

	-- Common Ports Alias
	alias a_spw_clock_i is clk_100_i;
	alias a_reset_i is reset_i;

	-- Signals --

begin

	-- Entities Instantiation --

	-- Signals Assignments and Processes --

	-- SpaceWire Channel Codec Configuration
	p_spwc_codec_config : process(a_spw_clock_i, a_reset_i) is
	begin
		if (a_reset_i = '1') then
			spw_link_command_autostart_o <= '0';
			spw_link_command_linkstart_o <= '0';
			spw_link_command_linkdis_o   <= '0';
			spw_link_command_txdivcnt_o  <= x"01";
			spw_timecode_tx_tick_in_o    <= '0';
			spw_timecode_tx_ctrl_in_o    <= (others => '0');
			spw_timecode_tx_time_in_o    <= (others => '0');
		elsif rising_edge(a_spw_clock_i) then
			spw_link_command_autostart_o <= '1';
			spw_link_command_linkstart_o <= '0';
			spw_link_command_linkdis_o   <= '0';
			spw_link_command_txdivcnt_o  <= x"01";
			spw_timecode_tx_tick_in_o    <= '0';
			spw_timecode_tx_ctrl_in_o    <= (others => '0');
			spw_timecode_tx_time_in_o    <= (others => '0');
		end if;
	end process p_spwc_codec_config;

	-- SpaceWire Channel Glutton Reader
	p_spw_codec_glutton_reader : process(a_spw_clock_i, a_reset_i) is
	begin
		if (a_reset_i = '1') then
			spw_data_rx_command_rxread_o <= '0';
		elsif rising_edge(a_spw_clock_i) then
			spw_data_rx_command_rxread_o <= '0';
			if (spw_data_rx_status_rxvalid_i = '1') then
				spw_data_rx_command_rxread_o <= '1';
			end if;
		end if;
	end process p_spw_codec_glutton_reader;

end architecture rtl;                   -- of spwg_spw_glutton_top
