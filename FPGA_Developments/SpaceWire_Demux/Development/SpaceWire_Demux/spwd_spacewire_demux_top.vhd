-- spwd_spacewire_demux_top.vhd

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

entity spwd_spacewire_demux_top is
    port(
        clock_i                            : in  std_logic                    := '0'; --          --                         clock_sink.clk
        reset_i                            : in  std_logic                    := '0'; --          --                         reset_sink.reset
        demux_select_i                     : in  std_logic_vector(1 downto 0) := (others => '0'); --           conduit_end_demux_select.demux_select_signal
        spw_link_command_autostart_i       : in  std_logic                    := '0'; --          --      conduit_end_spacewire_channel.spw_link_command_autostart_signal
        spw_link_command_linkstart_i       : in  std_logic                    := '0'; --          --                                   .spw_link_command_linkstart_signal
        spw_link_command_linkdis_i         : in  std_logic                    := '0'; --          --                                   .spw_link_command_linkdis_signal
        spw_link_command_txdivcnt_i        : in  std_logic_vector(7 downto 0) := x"01"; --        --                                   .spw_link_command_txdivcnt_signal
        spw_timecode_tx_tick_in_i          : in  std_logic                    := '0'; --          --                                   .spw_timecode_tx_tick_in_signal
        spw_timecode_tx_ctrl_in_i          : in  std_logic_vector(1 downto 0) := (others => '0'); --                                   .spw_timecode_tx_ctrl_in_signal
        spw_timecode_tx_time_in_i          : in  std_logic_vector(5 downto 0) := (others => '0'); --                                   .spw_timecode_tx_time_in_signal
        spw_data_rx_command_rxread_i       : in  std_logic                    := '0'; --          --                                   .spw_data_rx_command_rxread_signal
        spw_data_tx_command_txwrite_i      : in  std_logic                    := '0'; --          --                                   .spw_data_tx_command_txwrite_signal
        spw_data_tx_command_txflag_i       : in  std_logic                    := '0'; --          --                                   .spw_data_tx_command_txflag_signal
        spw_data_tx_command_txdata_i       : in  std_logic_vector(7 downto 0) := (others => '0'); --                                   .spw_data_tx_command_txdata_signal
        spw_errinj_ctrl_start_errinj_i     : in  std_logic                    := '0'; --          --                                   .spw_errinj_ctrl_start_errinj_signal
        spw_errinj_ctrl_reset_errinj_i     : in  std_logic                    := '0'; --          --                                   .spw_errinj_ctrl_reset_errinj_signal
        spw_errinj_ctrl_errinj_code_i      : in  std_logic_vector(3 downto 0) := (others => '0'); --                                   .spw_errinj_ctrl_errinj_code_signal
        spw_link_status_started_o          : out std_logic; --                                    --                                   .spw_link_status_started_signal
        spw_link_status_connecting_o       : out std_logic; --                                    --                                   .spw_link_status_connecting_signal
        spw_link_status_running_o          : out std_logic; --                                    --                                   .spw_link_status_running_signal
        spw_link_error_errdisc_o           : out std_logic; --                                    --                                   .spw_link_error_errdisc_signal
        spw_link_error_errpar_o            : out std_logic; --                                    --                                   .spw_link_error_errpar_signal
        spw_link_error_erresc_o            : out std_logic; --                                    --                                   .spw_link_error_erresc_signal
        spw_link_error_errcred_o           : out std_logic; --                                    --                                   .spw_link_error_errcred_signal       
        spw_timecode_rx_tick_out_o         : out std_logic; --                                    --                                   .spw_timecode_rx_tick_out_signal
        spw_timecode_rx_ctrl_out_o         : out std_logic_vector(1 downto 0); --                 --                                   .spw_timecode_rx_ctrl_out_signal
        spw_timecode_rx_time_out_o         : out std_logic_vector(5 downto 0); --                 --                                   .spw_timecode_rx_time_out_signal
        spw_data_rx_status_rxvalid_o       : out std_logic; --                                    --                                   .spw_data_rx_status_rxvalid_signal
        spw_data_rx_status_rxhalff_o       : out std_logic; --                                    --                                   .spw_data_rx_status_rxhalff_signal
        spw_data_rx_status_rxflag_o        : out std_logic; --                                    --                                   .spw_data_rx_status_rxflag_signal
        spw_data_rx_status_rxdata_o        : out std_logic_vector(7 downto 0); --                 --                                   .spw_data_rx_status_rxdata_signal
        spw_data_tx_status_txrdy_o         : out std_logic; --                                    --                                   .spw_data_tx_status_txrdy_signal
        spw_data_tx_status_txhalff_o       : out std_logic; --                                    --                                   .spw_data_tx_status_txhalff_signal
        spw_errinj_ctrl_errinj_busy_o      : out std_logic; --                                    --                                   .spw_errinj_ctrl_errinj_busy_signal
        spw_errinj_ctrl_errinj_ready_o     : out std_logic; --                                    --                                   .spw_errinj_ctrl_errinj_ready_signal
        spw_ct0_link_status_started_i      : in  std_logic                    := '0'; --          -- conduit_end_spacewire_controller_0.spw_link_status_started_signal
        spw_ct0_link_status_connecting_i   : in  std_logic                    := '0'; --          --                                   .spw_link_status_connecting_signal
        spw_ct0_link_status_running_i      : in  std_logic                    := '0'; --          --                                   .spw_link_status_running_signal
        spw_ct0_link_error_errdisc_i       : in  std_logic                    := '0'; --          --                                   .spw_link_error_errdisc_signal
        spw_ct0_link_error_errpar_i        : in  std_logic                    := '0'; --          --                                   .spw_link_error_errpar_signal
        spw_ct0_link_error_erresc_i        : in  std_logic                    := '0'; --          --                                   .spw_link_error_erresc_signal
        spw_ct0_link_error_errcred_i       : in  std_logic                    := '0'; --          --                                   .spw_link_error_errcred_signal       
        spw_ct0_timecode_rx_tick_out_i     : in  std_logic                    := '0'; --          --                                   .spw_timecode_rx_tick_out_signal
        spw_ct0_timecode_rx_ctrl_out_i     : in  std_logic_vector(1 downto 0) := (others => '0'); --                                   .spw_timecode_rx_ctrl_out_signal
        spw_ct0_timecode_rx_time_out_i     : in  std_logic_vector(5 downto 0) := (others => '0'); --                                   .spw_timecode_rx_time_out_signal
        spw_ct0_data_rx_status_rxvalid_i   : in  std_logic                    := '0'; --          --                                   .spw_data_rx_status_rxvalid_signal
        spw_ct0_data_rx_status_rxhalff_i   : in  std_logic                    := '0'; --          --                                   .spw_data_rx_status_rxhalff_signal
        spw_ct0_data_rx_status_rxflag_i    : in  std_logic                    := '0'; --          --                                   .spw_data_rx_status_rxflag_signal
        spw_ct0_data_rx_status_rxdata_i    : in  std_logic_vector(7 downto 0) := (others => '0'); --                                   .spw_data_rx_status_rxdata_signal
        spw_ct0_data_tx_status_txrdy_i     : in  std_logic                    := '0'; --          --                                   .spw_data_tx_status_txrdy_signal
        spw_ct0_data_tx_status_txhalff_i   : in  std_logic                    := '0'; --          --                                   .spw_data_tx_status_txhalff_signal
        spw_ct0_errinj_ctrl_errinj_busy_i  : in  std_logic                    := '0'; --          --                                   .spw_errinj_ctrl_errinj_busy_signal
        spw_ct0_errinj_ctrl_errinj_ready_i : in  std_logic                    := '0'; --          --                                   .spw_errinj_ctrl_errinj_ready_signal
        spw_ct0_link_command_autostart_o   : out std_logic; --                                    --                                   .spw_link_command_autostart_signal
        spw_ct0_link_command_linkstart_o   : out std_logic; --                                    --                                   .spw_link_command_linkstart_signal
        spw_ct0_link_command_linkdis_o     : out std_logic; --                                    --                                   .spw_link_command_linkdis_signal
        spw_ct0_link_command_txdivcnt_o    : out std_logic_vector(7 downto 0); --                 --                                   .spw_link_command_txdivcnt_signal
        spw_ct0_timecode_tx_tick_in_o      : out std_logic; --                                    --                                   .spw_timecode_tx_tick_in_signal
        spw_ct0_timecode_tx_ctrl_in_o      : out std_logic_vector(1 downto 0); --                 --                                   .spw_timecode_tx_ctrl_in_signal
        spw_ct0_timecode_tx_time_in_o      : out std_logic_vector(5 downto 0); --                 --                                   .spw_timecode_tx_time_in_signal
        spw_ct0_data_rx_command_rxread_o   : out std_logic; --                                    --                                   .spw_data_rx_command_rxread_signal
        spw_ct0_data_tx_command_txwrite_o  : out std_logic; --                                    --                                   .spw_data_tx_command_txwrite_signal
        spw_ct0_data_tx_command_txflag_o   : out std_logic; --                                    --                                   .spw_data_tx_command_txflag_signal
        spw_ct0_data_tx_command_txdata_o   : out std_logic_vector(7 downto 0); --                 --                                   .spw_data_tx_command_txdata_signal
        spw_ct0_errinj_ctrl_start_errinj_o : out std_logic; --                                    --                                   .spw_errinj_ctrl_start_errinj_signal
        spw_ct0_errinj_ctrl_reset_errinj_o : out std_logic; --                                    --                                   .spw_errinj_ctrl_reset_errinj_signal
        spw_ct0_errinj_ctrl_errinj_code_o  : out std_logic_vector(3 downto 0); --                 --                                   .spw_errinj_ctrl_errinj_code_signal
        spw_ct1_link_status_started_i      : in  std_logic                    := '0'; --          -- conduit_end_spacewire_controller_1.spw_link_status_started_signal
        spw_ct1_link_status_connecting_i   : in  std_logic                    := '0'; --          --                                   .spw_link_status_connecting_signal
        spw_ct1_link_status_running_i      : in  std_logic                    := '0'; --          --                                   .spw_link_status_running_signal
        spw_ct1_link_error_errdisc_i       : in  std_logic                    := '0'; --          --                                   .spw_link_error_errdisc_signal
        spw_ct1_link_error_errpar_i        : in  std_logic                    := '0'; --          --                                   .spw_link_error_errpar_signal
        spw_ct1_link_error_erresc_i        : in  std_logic                    := '0'; --          --                                   .spw_link_error_erresc_signal
        spw_ct1_link_error_errcred_i       : in  std_logic                    := '0'; --          --                                   .spw_link_error_errcred_signal       
        spw_ct1_timecode_rx_tick_out_i     : in  std_logic                    := '0'; --          --                                   .spw_timecode_rx_tick_out_signal
        spw_ct1_timecode_rx_ctrl_out_i     : in  std_logic_vector(1 downto 0) := (others => '0'); --                                   .spw_timecode_rx_ctrl_out_signal
        spw_ct1_timecode_rx_time_out_i     : in  std_logic_vector(5 downto 0) := (others => '0'); --                                   .spw_timecode_rx_time_out_signal
        spw_ct1_data_rx_status_rxvalid_i   : in  std_logic                    := '0'; --          --                                   .spw_data_rx_status_rxvalid_signal
        spw_ct1_data_rx_status_rxhalff_i   : in  std_logic                    := '0'; --          --                                   .spw_data_rx_status_rxhalff_signal
        spw_ct1_data_rx_status_rxflag_i    : in  std_logic                    := '0'; --          --                                   .spw_data_rx_status_rxflag_signal
        spw_ct1_data_rx_status_rxdata_i    : in  std_logic_vector(7 downto 0) := (others => '0'); --                                   .spw_data_rx_status_rxdata_signal
        spw_ct1_data_tx_status_txrdy_i     : in  std_logic                    := '0'; --          --                                   .spw_data_tx_status_txrdy_signal
        spw_ct1_data_tx_status_txhalff_i   : in  std_logic                    := '0'; --          --                                   .spw_data_tx_status_txhalff_signal
        spw_ct1_errinj_ctrl_errinj_busy_i  : in  std_logic                    := '0'; --          --                                   .spw_errinj_ctrl_errinj_busy_signal
        spw_ct1_errinj_ctrl_errinj_ready_i : in  std_logic                    := '0'; --          --                                   .spw_errinj_ctrl_errinj_ready_signal
        spw_ct1_link_command_autostart_o   : out std_logic; --                                    --                                   .spw_link_command_autostart_signal
        spw_ct1_link_command_linkstart_o   : out std_logic; --                                    --                                   .spw_link_command_linkstart_signal
        spw_ct1_link_command_linkdis_o     : out std_logic; --                                    --                                   .spw_link_command_linkdis_signal
        spw_ct1_link_command_txdivcnt_o    : out std_logic_vector(7 downto 0); --                 --                                   .spw_link_command_txdivcnt_signal
        spw_ct1_timecode_tx_tick_in_o      : out std_logic; --                                    --                                   .spw_timecode_tx_tick_in_signal
        spw_ct1_timecode_tx_ctrl_in_o      : out std_logic_vector(1 downto 0); --                 --                                   .spw_timecode_tx_ctrl_in_signal
        spw_ct1_timecode_tx_time_in_o      : out std_logic_vector(5 downto 0); --                 --                                   .spw_timecode_tx_time_in_signal
        spw_ct1_data_rx_command_rxread_o   : out std_logic; --                                    --                                   .spw_data_rx_command_rxread_signal
        spw_ct1_data_tx_command_txwrite_o  : out std_logic; --                                    --                                   .spw_data_tx_command_txwrite_signal
        spw_ct1_data_tx_command_txflag_o   : out std_logic; --                                    --                                   .spw_data_tx_command_txflag_signal
        spw_ct1_data_tx_command_txdata_o   : out std_logic_vector(7 downto 0); --                 --                                   .spw_data_tx_command_txdata_signal
        spw_ct1_errinj_ctrl_start_errinj_o : out std_logic; --                                    --                                   .spw_errinj_ctrl_start_errinj_signal
        spw_ct1_errinj_ctrl_reset_errinj_o : out std_logic; --                                    --                                   .spw_errinj_ctrl_reset_errinj_signal
        spw_ct1_errinj_ctrl_errinj_code_o  : out std_logic_vector(3 downto 0); --                 --                                   .spw_errinj_ctrl_errinj_code_signal
        spw_ct2_link_status_started_i      : in  std_logic                    := '0'; --          -- conduit_end_spacewire_controller_2.spw_link_status_started_signal
        spw_ct2_link_status_connecting_i   : in  std_logic                    := '0'; --          --                                   .spw_link_status_connecting_signal
        spw_ct2_link_status_running_i      : in  std_logic                    := '0'; --          --                                   .spw_link_status_running_signal
        spw_ct2_link_error_errdisc_i       : in  std_logic                    := '0'; --          --                                   .spw_link_error_errdisc_signal
        spw_ct2_link_error_errpar_i        : in  std_logic                    := '0'; --          --                                   .spw_link_error_errpar_signal
        spw_ct2_link_error_erresc_i        : in  std_logic                    := '0'; --          --                                   .spw_link_error_erresc_signal
        spw_ct2_link_error_errcred_i       : in  std_logic                    := '0'; --          --                                   .spw_link_error_errcred_signal       
        spw_ct2_timecode_rx_tick_out_i     : in  std_logic                    := '0'; --          --                                   .spw_timecode_rx_tick_out_signal
        spw_ct2_timecode_rx_ctrl_out_i     : in  std_logic_vector(1 downto 0) := (others => '0'); --                                   .spw_timecode_rx_ctrl_out_signal
        spw_ct2_timecode_rx_time_out_i     : in  std_logic_vector(5 downto 0) := (others => '0'); --                                   .spw_timecode_rx_time_out_signal
        spw_ct2_data_rx_status_rxvalid_i   : in  std_logic                    := '0'; --          --                                   .spw_data_rx_status_rxvalid_signal
        spw_ct2_data_rx_status_rxhalff_i   : in  std_logic                    := '0'; --          --                                   .spw_data_rx_status_rxhalff_signal
        spw_ct2_data_rx_status_rxflag_i    : in  std_logic                    := '0'; --          --                                   .spw_data_rx_status_rxflag_signal
        spw_ct2_data_rx_status_rxdata_i    : in  std_logic_vector(7 downto 0) := (others => '0'); --                                   .spw_data_rx_status_rxdata_signal
        spw_ct2_data_tx_status_txrdy_i     : in  std_logic                    := '0'; --          --                                   .spw_data_tx_status_txrdy_signal
        spw_ct2_data_tx_status_txhalff_i   : in  std_logic                    := '0'; --          --                                   .spw_data_tx_status_txhalff_signal
        spw_ct2_errinj_ctrl_errinj_busy_i  : in  std_logic                    := '0'; --          --                                   .spw_errinj_ctrl_errinj_busy_signal
        spw_ct2_errinj_ctrl_errinj_ready_i : in  std_logic                    := '0'; --          --                                   .spw_errinj_ctrl_errinj_ready_signal
        spw_ct2_link_command_autostart_o   : out std_logic; --                                    --                                   .spw_link_command_autostart_signal
        spw_ct2_link_command_linkstart_o   : out std_logic; --                                    --                                   .spw_link_command_linkstart_signal
        spw_ct2_link_command_linkdis_o     : out std_logic; --                                    --                                   .spw_link_command_linkdis_signal
        spw_ct2_link_command_txdivcnt_o    : out std_logic_vector(7 downto 0); --                 --                                   .spw_link_command_txdivcnt_signal
        spw_ct2_timecode_tx_tick_in_o      : out std_logic; --                                    --                                   .spw_timecode_tx_tick_in_signal
        spw_ct2_timecode_tx_ctrl_in_o      : out std_logic_vector(1 downto 0); --                 --                                   .spw_timecode_tx_ctrl_in_signal
        spw_ct2_timecode_tx_time_in_o      : out std_logic_vector(5 downto 0); --                 --                                   .spw_timecode_tx_time_in_signal
        spw_ct2_data_rx_command_rxread_o   : out std_logic; --                                    --                                   .spw_data_rx_command_rxread_signal
        spw_ct2_data_tx_command_txwrite_o  : out std_logic; --                                    --                                   .spw_data_tx_command_txwrite_signal
        spw_ct2_data_tx_command_txflag_o   : out std_logic; --                                    --                                   .spw_data_tx_command_txflag_signal
        spw_ct2_data_tx_command_txdata_o   : out std_logic_vector(7 downto 0); --                 --                                   .spw_data_tx_command_txdata_signal
        spw_ct2_errinj_ctrl_start_errinj_o : out std_logic; --                                    --                                   .spw_errinj_ctrl_start_errinj_signal
        spw_ct2_errinj_ctrl_reset_errinj_o : out std_logic; --                                    --                                   .spw_errinj_ctrl_reset_errinj_signal
        spw_ct2_errinj_ctrl_errinj_code_o  : out std_logic_vector(3 downto 0) ---                 --                                   .spw_errinj_ctrl_errinj_code_signal
    );
end entity spwd_spacewire_demux_top;

architecture rtl of spwd_spacewire_demux_top is

    -- Alias --

    -- Basic Alias
    alias a_reset is reset_i;

    -- Constants --
    constant c_DEMUX_SELECTED_CH_0 : std_logic_vector(1 downto 0) := "00";
    constant c_DEMUX_SELECTED_CH_1 : std_logic_vector(1 downto 0) := "01";
    constant c_DEMUX_SELECTED_CH_2 : std_logic_vector(1 downto 0) := "10";
    constant c_DEMUX_SELECTED_NONE : std_logic_vector(1 downto 0) := "11";

    -- Signals --

begin

    -- Entities Instantiation --

    -- Signals Assignments --

    -- SpaceWire Channel Output Signals Assignments
    spw_link_status_started_o      <= ('0') when (a_reset = '1')
                                      else (spw_ct0_link_status_started_i) when (demux_select_i = c_DEMUX_SELECTED_CH_0)
                                      else (spw_ct1_link_status_started_i) when (demux_select_i = c_DEMUX_SELECTED_CH_1)
                                      else (spw_ct2_link_status_started_i) when (demux_select_i = c_DEMUX_SELECTED_CH_2)
                                      else ('0');
    spw_link_status_connecting_o   <= ('0') when (a_reset = '1')
                                      else (spw_ct0_link_status_connecting_i) when (demux_select_i = c_DEMUX_SELECTED_CH_0)
                                      else (spw_ct1_link_status_connecting_i) when (demux_select_i = c_DEMUX_SELECTED_CH_1)
                                      else (spw_ct2_link_status_connecting_i) when (demux_select_i = c_DEMUX_SELECTED_CH_2)
                                      else ('0');
    spw_link_status_running_o      <= ('0') when (a_reset = '1')
                                      else (spw_ct0_link_status_running_i) when (demux_select_i = c_DEMUX_SELECTED_CH_0)
                                      else (spw_ct1_link_status_running_i) when (demux_select_i = c_DEMUX_SELECTED_CH_1)
                                      else (spw_ct2_link_status_running_i) when (demux_select_i = c_DEMUX_SELECTED_CH_2)
                                      else ('0');
    spw_link_error_errdisc_o       <= ('0') when (a_reset = '1')
                                      else (spw_ct0_link_error_errdisc_i) when (demux_select_i = c_DEMUX_SELECTED_CH_0)
                                      else (spw_ct1_link_error_errdisc_i) when (demux_select_i = c_DEMUX_SELECTED_CH_1)
                                      else (spw_ct2_link_error_errdisc_i) when (demux_select_i = c_DEMUX_SELECTED_CH_2)
                                      else ('0');
    spw_link_error_errpar_o        <= ('0') when (a_reset = '1')
                                      else (spw_ct0_link_error_errpar_i) when (demux_select_i = c_DEMUX_SELECTED_CH_0)
                                      else (spw_ct1_link_error_errpar_i) when (demux_select_i = c_DEMUX_SELECTED_CH_1)
                                      else (spw_ct2_link_error_errpar_i) when (demux_select_i = c_DEMUX_SELECTED_CH_2)
                                      else ('0');
    spw_link_error_erresc_o        <= ('0') when (a_reset = '1')
                                      else (spw_ct0_link_error_erresc_i) when (demux_select_i = c_DEMUX_SELECTED_CH_0)
                                      else (spw_ct1_link_error_erresc_i) when (demux_select_i = c_DEMUX_SELECTED_CH_1)
                                      else (spw_ct2_link_error_erresc_i) when (demux_select_i = c_DEMUX_SELECTED_CH_2)
                                      else ('0');
    spw_link_error_errcred_o       <= ('0') when (a_reset = '1')
                                      else (spw_ct0_link_error_errcred_i) when (demux_select_i = c_DEMUX_SELECTED_CH_0)
                                      else (spw_ct1_link_error_errcred_i) when (demux_select_i = c_DEMUX_SELECTED_CH_1)
                                      else (spw_ct2_link_error_errcred_i) when (demux_select_i = c_DEMUX_SELECTED_CH_2)
                                      else ('0');
    spw_timecode_rx_tick_out_o     <= ('0') when (a_reset = '1')
                                      else (spw_ct0_timecode_rx_tick_out_i) when (demux_select_i = c_DEMUX_SELECTED_CH_0)
                                      else (spw_ct1_timecode_rx_tick_out_i) when (demux_select_i = c_DEMUX_SELECTED_CH_1)
                                      else (spw_ct2_timecode_rx_tick_out_i) when (demux_select_i = c_DEMUX_SELECTED_CH_2)
                                      else ('0');
    spw_timecode_rx_ctrl_out_o     <= ((others => '0')) when (a_reset = '1')
                                      else (spw_ct0_timecode_rx_ctrl_out_i) when (demux_select_i = c_DEMUX_SELECTED_CH_0)
                                      else (spw_ct1_timecode_rx_ctrl_out_i) when (demux_select_i = c_DEMUX_SELECTED_CH_1)
                                      else (spw_ct2_timecode_rx_ctrl_out_i) when (demux_select_i = c_DEMUX_SELECTED_CH_2)
                                      else ((others => '0'));
    spw_timecode_rx_time_out_o     <= ((others => '0')) when (a_reset = '1')
                                      else (spw_ct0_timecode_rx_time_out_i) when (demux_select_i = c_DEMUX_SELECTED_CH_0)
                                      else (spw_ct1_timecode_rx_time_out_i) when (demux_select_i = c_DEMUX_SELECTED_CH_1)
                                      else (spw_ct2_timecode_rx_time_out_i) when (demux_select_i = c_DEMUX_SELECTED_CH_2)
                                      else ((others => '0'));
    spw_data_rx_status_rxvalid_o   <= ('0') when (a_reset = '1')
                                      else (spw_ct0_data_rx_status_rxvalid_i) when (demux_select_i = c_DEMUX_SELECTED_CH_0)
                                      else (spw_ct1_data_rx_status_rxvalid_i) when (demux_select_i = c_DEMUX_SELECTED_CH_1)
                                      else (spw_ct2_data_rx_status_rxvalid_i) when (demux_select_i = c_DEMUX_SELECTED_CH_2)
                                      else ('0');
    spw_data_rx_status_rxhalff_o   <= ('0') when (a_reset = '1')
                                      else (spw_ct0_data_rx_status_rxhalff_i) when (demux_select_i = c_DEMUX_SELECTED_CH_0)
                                      else (spw_ct1_data_rx_status_rxhalff_i) when (demux_select_i = c_DEMUX_SELECTED_CH_1)
                                      else (spw_ct2_data_rx_status_rxhalff_i) when (demux_select_i = c_DEMUX_SELECTED_CH_2)
                                      else ('0');
    spw_data_rx_status_rxflag_o    <= ('0') when (a_reset = '1')
                                      else (spw_ct0_data_rx_status_rxflag_i) when (demux_select_i = c_DEMUX_SELECTED_CH_0)
                                      else (spw_ct1_data_rx_status_rxflag_i) when (demux_select_i = c_DEMUX_SELECTED_CH_1)
                                      else (spw_ct2_data_rx_status_rxflag_i) when (demux_select_i = c_DEMUX_SELECTED_CH_2)
                                      else ('0');
    spw_data_rx_status_rxdata_o    <= ((others => '0')) when (a_reset = '1')
                                      else (spw_ct0_data_rx_status_rxdata_i) when (demux_select_i = c_DEMUX_SELECTED_CH_0)
                                      else (spw_ct1_data_rx_status_rxdata_i) when (demux_select_i = c_DEMUX_SELECTED_CH_1)
                                      else (spw_ct2_data_rx_status_rxdata_i) when (demux_select_i = c_DEMUX_SELECTED_CH_2)
                                      else ((others => '0'));
    spw_data_tx_status_txrdy_o     <= ('0') when (a_reset = '1')
                                      else (spw_ct0_data_tx_status_txrdy_i) when (demux_select_i = c_DEMUX_SELECTED_CH_0)
                                      else (spw_ct1_data_tx_status_txrdy_i) when (demux_select_i = c_DEMUX_SELECTED_CH_1)
                                      else (spw_ct2_data_tx_status_txrdy_i) when (demux_select_i = c_DEMUX_SELECTED_CH_2)
                                      else ('0');
    spw_data_tx_status_txhalff_o   <= ('0') when (a_reset = '1')
                                      else (spw_ct0_data_tx_status_txhalff_i) when (demux_select_i = c_DEMUX_SELECTED_CH_0)
                                      else (spw_ct1_data_tx_status_txhalff_i) when (demux_select_i = c_DEMUX_SELECTED_CH_1)
                                      else (spw_ct2_data_tx_status_txhalff_i) when (demux_select_i = c_DEMUX_SELECTED_CH_2)
                                      else ('0');
    spw_errinj_ctrl_errinj_busy_o  <= ('0') when (a_reset = '1')
                                      else (spw_ct0_errinj_ctrl_errinj_busy_i) when (demux_select_i = c_DEMUX_SELECTED_CH_0)
                                      else (spw_ct1_errinj_ctrl_errinj_busy_i) when (demux_select_i = c_DEMUX_SELECTED_CH_1)
                                      else (spw_ct2_errinj_ctrl_errinj_busy_i) when (demux_select_i = c_DEMUX_SELECTED_CH_2)
                                      else ('0');
    spw_errinj_ctrl_errinj_ready_o <= ('0') when (a_reset = '1')
                                      else (spw_ct0_errinj_ctrl_errinj_ready_i) when (demux_select_i = c_DEMUX_SELECTED_CH_0)
                                      else (spw_ct1_errinj_ctrl_errinj_ready_i) when (demux_select_i = c_DEMUX_SELECTED_CH_1)
                                      else (spw_ct2_errinj_ctrl_errinj_ready_i) when (demux_select_i = c_DEMUX_SELECTED_CH_2)
                                      else ('0');

    -- SpaceWire Controller 0 Output Signals Assignments
    spw_ct0_link_command_autostart_o   <= ('0') when (a_reset = '1')
                                          else (spw_link_command_autostart_i) when (demux_select_i = c_DEMUX_SELECTED_CH_0)
                                          else ('0');
    spw_ct0_link_command_linkstart_o   <= ('0') when (a_reset = '1')
                                          else (spw_link_command_linkstart_i) when (demux_select_i = c_DEMUX_SELECTED_CH_0)
                                          else ('0');
    spw_ct0_link_command_linkdis_o     <= ('0') when (a_reset = '1')
                                          else (spw_link_command_linkdis_i) when (demux_select_i = c_DEMUX_SELECTED_CH_0)
                                          else ('1');
    spw_ct0_link_command_txdivcnt_o    <= (x"01") when (a_reset = '1')
                                          else (spw_link_command_txdivcnt_i) when (demux_select_i = c_DEMUX_SELECTED_CH_0)
                                          else (x"01");
    spw_ct0_timecode_tx_tick_in_o      <= ('0') when (a_reset = '1')
                                          else (spw_timecode_tx_tick_in_i) when (demux_select_i = c_DEMUX_SELECTED_CH_0)
                                          else ('0');
    spw_ct0_timecode_tx_ctrl_in_o      <= ((others => '0')) when (a_reset = '1')
                                          else (spw_timecode_tx_ctrl_in_i) when (demux_select_i = c_DEMUX_SELECTED_CH_0)
                                          else ((others => '0'));
    spw_ct0_timecode_tx_time_in_o      <= ((others => '0')) when (a_reset = '1')
                                          else (spw_timecode_tx_time_in_i) when (demux_select_i = c_DEMUX_SELECTED_CH_0)
                                          else ((others => '0'));
    spw_ct0_data_rx_command_rxread_o   <= ('0') when (a_reset = '1')
                                          else (spw_data_rx_command_rxread_i) when (demux_select_i = c_DEMUX_SELECTED_CH_0)
                                          else ('0');
    spw_ct0_data_tx_command_txwrite_o  <= ('0') when (a_reset = '1')
                                          else (spw_data_tx_command_txwrite_i) when (demux_select_i = c_DEMUX_SELECTED_CH_0)
                                          else ('0');
    spw_ct0_data_tx_command_txflag_o   <= ('0') when (a_reset = '1')
                                          else (spw_data_tx_command_txflag_i) when (demux_select_i = c_DEMUX_SELECTED_CH_0)
                                          else ('0');
    spw_ct0_data_tx_command_txdata_o   <= ((others => '0')) when (a_reset = '1')
                                          else (spw_data_tx_command_txdata_i) when (demux_select_i = c_DEMUX_SELECTED_CH_0)
                                          else ((others => '0'));
    spw_ct0_errinj_ctrl_start_errinj_o <= ('0') when (a_reset = '1')
                                          else (spw_errinj_ctrl_start_errinj_i) when (demux_select_i = c_DEMUX_SELECTED_CH_0)
                                          else ('0');
    spw_ct0_errinj_ctrl_reset_errinj_o <= ('0') when (a_reset = '1')
                                          else (spw_errinj_ctrl_reset_errinj_i) when (demux_select_i = c_DEMUX_SELECTED_CH_0)
                                          else ('0');
    spw_ct0_errinj_ctrl_errinj_code_o  <= ((others => '0')) when (a_reset = '1')
                                          else (spw_errinj_ctrl_errinj_code_i) when (demux_select_i = c_DEMUX_SELECTED_CH_0)
                                          else ((others => '0'));

    -- SpaceWire Controller 1 Output Signals Assignments
    spw_ct1_link_command_autostart_o   <= ('0') when (a_reset = '1')
                                          else (spw_link_command_autostart_i) when (demux_select_i = c_DEMUX_SELECTED_CH_1)
                                          else ('0');
    spw_ct1_link_command_linkstart_o   <= ('0') when (a_reset = '1')
                                          else (spw_link_command_linkstart_i) when (demux_select_i = c_DEMUX_SELECTED_CH_1)
                                          else ('0');
    spw_ct1_link_command_linkdis_o     <= ('0') when (a_reset = '1')
                                          else (spw_link_command_linkdis_i) when (demux_select_i = c_DEMUX_SELECTED_CH_1)
                                          else ('1');
    spw_ct1_link_command_txdivcnt_o    <= (x"01") when (a_reset = '1')
                                          else (spw_link_command_txdivcnt_i) when (demux_select_i = c_DEMUX_SELECTED_CH_1)
                                          else (x"01");
    spw_ct1_timecode_tx_tick_in_o      <= ('0') when (a_reset = '1')
                                          else (spw_timecode_tx_tick_in_i) when (demux_select_i = c_DEMUX_SELECTED_CH_1)
                                          else ('0');
    spw_ct1_timecode_tx_ctrl_in_o      <= ((others => '0')) when (a_reset = '1')
                                          else (spw_timecode_tx_ctrl_in_i) when (demux_select_i = c_DEMUX_SELECTED_CH_1)
                                          else ((others => '0'));
    spw_ct1_timecode_tx_time_in_o      <= ((others => '0')) when (a_reset = '1')
                                          else (spw_timecode_tx_time_in_i) when (demux_select_i = c_DEMUX_SELECTED_CH_1)
                                          else ((others => '0'));
    spw_ct1_data_rx_command_rxread_o   <= ('0') when (a_reset = '1')
                                          else (spw_data_rx_command_rxread_i) when (demux_select_i = c_DEMUX_SELECTED_CH_1)
                                          else ('0');
    spw_ct1_data_tx_command_txwrite_o  <= ('0') when (a_reset = '1')
                                          else (spw_data_tx_command_txwrite_i) when (demux_select_i = c_DEMUX_SELECTED_CH_1)
                                          else ('0');
    spw_ct1_data_tx_command_txflag_o   <= ('0') when (a_reset = '1')
                                          else (spw_data_tx_command_txflag_i) when (demux_select_i = c_DEMUX_SELECTED_CH_1)
                                          else ('0');
    spw_ct1_data_tx_command_txdata_o   <= ((others => '0')) when (a_reset = '1')
                                          else (spw_data_tx_command_txdata_i) when (demux_select_i = c_DEMUX_SELECTED_CH_1)
                                          else ((others => '0'));
    spw_ct1_errinj_ctrl_start_errinj_o <= ('0') when (a_reset = '1')
                                          else (spw_errinj_ctrl_start_errinj_i) when (demux_select_i = c_DEMUX_SELECTED_CH_1)
                                          else ('0');
    spw_ct1_errinj_ctrl_reset_errinj_o <= ('0') when (a_reset = '1')
                                          else (spw_errinj_ctrl_reset_errinj_i) when (demux_select_i = c_DEMUX_SELECTED_CH_1)
                                          else ('0');
    spw_ct1_errinj_ctrl_errinj_code_o  <= ((others => '0')) when (a_reset = '1')
                                          else (spw_errinj_ctrl_errinj_code_i) when (demux_select_i = c_DEMUX_SELECTED_CH_1)
                                          else ((others => '0'));

    -- SpaceWire Controller 2 Output Signals Assignments
    spw_ct2_link_command_autostart_o   <= ('0') when (a_reset = '1')
                                          else (spw_link_command_autostart_i) when (demux_select_i = c_DEMUX_SELECTED_CH_2)
                                          else ('0');
    spw_ct2_link_command_linkstart_o   <= ('0') when (a_reset = '1')
                                          else (spw_link_command_linkstart_i) when (demux_select_i = c_DEMUX_SELECTED_CH_2)
                                          else ('0');
    spw_ct2_link_command_linkdis_o     <= ('0') when (a_reset = '1')
                                          else (spw_link_command_linkdis_i) when (demux_select_i = c_DEMUX_SELECTED_CH_2)
                                          else ('1');
    spw_ct2_link_command_txdivcnt_o    <= (x"01") when (a_reset = '1')
                                          else (spw_link_command_txdivcnt_i) when (demux_select_i = c_DEMUX_SELECTED_CH_2)
                                          else (x"01");
    spw_ct2_timecode_tx_tick_in_o      <= ('0') when (a_reset = '1')
                                          else (spw_timecode_tx_tick_in_i) when (demux_select_i = c_DEMUX_SELECTED_CH_2)
                                          else ('0');
    spw_ct2_timecode_tx_ctrl_in_o      <= ((others => '0')) when (a_reset = '1')
                                          else (spw_timecode_tx_ctrl_in_i) when (demux_select_i = c_DEMUX_SELECTED_CH_2)
                                          else ((others => '0'));
    spw_ct2_timecode_tx_time_in_o      <= ((others => '0')) when (a_reset = '1')
                                          else (spw_timecode_tx_time_in_i) when (demux_select_i = c_DEMUX_SELECTED_CH_2)
                                          else ((others => '0'));
    spw_ct2_data_rx_command_rxread_o   <= ('0') when (a_reset = '1')
                                          else (spw_data_rx_command_rxread_i) when (demux_select_i = c_DEMUX_SELECTED_CH_2)
                                          else ('0');
    spw_ct2_data_tx_command_txwrite_o  <= ('0') when (a_reset = '1')
                                          else (spw_data_tx_command_txwrite_i) when (demux_select_i = c_DEMUX_SELECTED_CH_2)
                                          else ('0');
    spw_ct2_data_tx_command_txflag_o   <= ('0') when (a_reset = '1')
                                          else (spw_data_tx_command_txflag_i) when (demux_select_i = c_DEMUX_SELECTED_CH_2)
                                          else ('0');
    spw_ct2_data_tx_command_txdata_o   <= ((others => '0')) when (a_reset = '1')
                                          else (spw_data_tx_command_txdata_i) when (demux_select_i = c_DEMUX_SELECTED_CH_2)
                                          else ((others => '0'));
    spw_ct2_errinj_ctrl_start_errinj_o <= ('0') when (a_reset = '1')
                                          else (spw_errinj_ctrl_start_errinj_i) when (demux_select_i = c_DEMUX_SELECTED_CH_2)
                                          else ('0');
    spw_ct2_errinj_ctrl_reset_errinj_o <= ('0') when (a_reset = '1')
                                          else (spw_errinj_ctrl_reset_errinj_i) when (demux_select_i = c_DEMUX_SELECTED_CH_2)
                                          else ('0');
    spw_ct2_errinj_ctrl_errinj_code_o  <= ((others => '0')) when (a_reset = '1')
                                          else (spw_errinj_ctrl_errinj_code_i) when (demux_select_i = c_DEMUX_SELECTED_CH_2)
                                          else ((others => '0'));

end architecture rtl;                   -- of spwd_spacewire_demux_top
