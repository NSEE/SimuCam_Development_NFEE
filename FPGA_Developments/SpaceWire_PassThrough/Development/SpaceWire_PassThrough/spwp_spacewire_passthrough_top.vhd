-- spwp_spacewire_passthrough_top.vhd

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

entity spwp_spacewire_passthrough_top is
    port(
        clock_i                            : in  std_logic                    := '0'; --          --                         clock_sink.clk
        reset_i                            : in  std_logic                    := '0'; --          --                         reset_sink.reset
        passthrough_enable_i               : in  std_logic                    := '0'; --          --     conduit_end_passthrough_enable.passthrough_enable_signal
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
        spw_ct1_errinj_ctrl_errinj_code_o  : out std_logic_vector(3 downto 0) ---                 --                                   .spw_errinj_ctrl_errinj_code_signal
    );
end entity spwp_spacewire_passthrough_top;

architecture rtl of spwp_spacewire_passthrough_top is

    -- Alias --

    -- Basic Alias
    alias a_reset is reset_i;
    alias a_clock is clock_i;

    -- Constants --

    -- Signals --
    signal s_spw_ct0_data_tx_command_txwrite : std_logic;
    signal s_spw_ct1_data_tx_command_txwrite : std_logic;

begin

    -- Entities Instantiation --

    -- Processes --

    p_pwp_spacewire_passthrough : process(a_clock, a_reset) is
        --
        procedure p_spw_disable(
            signal spw_link_command_autostart_o   : out std_logic;
            signal spw_link_command_linkstart_o   : out std_logic;
            signal spw_link_command_linkdis_o     : out std_logic;
            signal spw_link_command_txdivcnt_o    : out std_logic_vector(7 downto 0);
            signal spw_timecode_tx_tick_in_o      : out std_logic;
            signal spw_timecode_tx_ctrl_in_o      : out std_logic_vector(1 downto 0);
            signal spw_timecode_tx_time_in_o      : out std_logic_vector(5 downto 0);
            signal spw_data_rx_command_rxread_o   : out std_logic;
            signal spw_data_tx_command_txwrite_o  : out std_logic;
            signal spw_data_tx_command_txflag_o   : out std_logic;
            signal spw_data_tx_command_txdata_o   : out std_logic_vector(7 downto 0);
            signal spw_errinj_ctrl_start_errinj_o : out std_logic;
            signal spw_errinj_ctrl_reset_errinj_o : out std_logic;
            signal spw_errinj_ctrl_errinj_code_o  : out std_logic_vector(3 downto 0)
        ) is
        begin
            spw_link_command_autostart_o   <= '0';
            spw_link_command_linkstart_o   <= '0';
            spw_link_command_linkdis_o     <= '1';
            spw_link_command_txdivcnt_o    <= x"01";
            spw_timecode_tx_tick_in_o      <= '0';
            spw_timecode_tx_ctrl_in_o      <= (others => '0');
            spw_timecode_tx_time_in_o      <= (others => '0');
            spw_data_rx_command_rxread_o   <= '0';
            spw_data_tx_command_txwrite_o  <= '0';
            spw_data_tx_command_txflag_o   <= '0';
            spw_data_tx_command_txdata_o   <= (others => '0');
            spw_errinj_ctrl_start_errinj_o <= '0';
            spw_errinj_ctrl_reset_errinj_o <= '0';
            spw_errinj_ctrl_errinj_code_o  <= (others => '0');
        end procedure p_spw_disable;
        --
        procedure p_spw_link_config(
            signal spw_link_command_autostart_o : out std_logic;
            signal spw_link_command_linkstart_o : out std_logic;
            signal spw_link_command_linkdis_o   : out std_logic;
            signal spw_link_command_txdivcnt_o  : out std_logic_vector(7 downto 0)
        ) is
        begin
            spw_link_command_autostart_o <= '1';
            spw_link_command_linkstart_o <= '1';
            spw_link_command_linkdis_o   <= '0';
            spw_link_command_txdivcnt_o  <= x"01";
        end procedure p_spw_link_config;
        --
        procedure p_spw_timecode_passthrough(
            signal spw_end0_link_status_running_i  : in std_logic;
            signal spw_end1_link_status_running_i  : in std_logic;
            signal spw_end0_timecode_rx_tick_out_i : in std_logic;
            signal spw_end0_timecode_rx_ctrl_out_i : in std_logic_vector(1 downto 0);
            signal spw_end0_timecode_rx_time_out_i : in std_logic_vector(5 downto 0);
            signal spw_end1_timecode_tx_tick_in_o  : out std_logic;
            signal spw_end1_timecode_tx_ctrl_in_o  : out std_logic_vector(1 downto 0);
            signal spw_end1_timecode_tx_time_in_o  : out std_logic_vector(5 downto 0)
        ) is
        begin
            if ((spw_end0_link_status_running_i = '1') and (spw_end1_link_status_running_i = '1')) then
                spw_end1_timecode_tx_tick_in_o <= '0';
                if (spw_end0_timecode_rx_tick_out_i = '1') then
                    spw_end1_timecode_tx_tick_in_o <= '1';
                    spw_end1_timecode_tx_ctrl_in_o <= spw_end0_timecode_rx_ctrl_out_i;
                    spw_end1_timecode_tx_time_in_o <= spw_end0_timecode_rx_time_out_i;
                end if;
            end if;
        end procedure p_spw_timecode_passthrough;
        --
        procedure p_spw_data_passthrough(
            signal spw_end0_link_status_running_i      : in std_logic;
            signal spw_end1_link_status_running_i      : in std_logic;
            signal spw_end0_data_rx_status_rxvalid_i   : in std_logic;
            signal spw_end0_data_rx_status_rxflag_i    : in std_logic;
            signal spw_end0_data_rx_status_rxdata_i    : in std_logic_vector(7 downto 0);
            signal spw_end1_data_tx_status_txrdy_i     : in std_logic;
            signal spw_end0_data_rx_command_rxread_o   : out std_logic;
            signal spw_end1_data_tx_command_txwrite_o  : out std_logic;
            signal spw_end1_data_tx_command_txflag_o   : out std_logic;
            signal spw_end1_data_tx_command_txdata_o   : out std_logic_vector(7 downto 0);
            signal spw_end1_data_tx_command_txwrite_io : inout std_logic
        ) is
        begin
            spw_end0_data_rx_command_rxread_o   <= '0';
            spw_end1_data_tx_command_txwrite_o  <= '0';
            spw_end1_data_tx_command_txwrite_io <= '0';
            spw_end1_data_tx_command_txdata_o   <= (others => '0');
            spw_end1_data_tx_command_txflag_o   <= '0';
            if ((spw_end0_link_status_running_i = '1') and (spw_end1_link_status_running_i = '1')) then
                if ((spw_end0_data_rx_status_rxvalid_i = '1') and (spw_end1_data_tx_status_txrdy_i = '1') and (spw_end1_data_tx_command_txwrite_io = '0')) then
                    spw_end0_data_rx_command_rxread_o   <= '1';
                    spw_end1_data_tx_command_txwrite_o  <= '1';
                    spw_end1_data_tx_command_txwrite_io <= '1';
                    spw_end1_data_tx_command_txdata_o   <= spw_end0_data_rx_status_rxdata_i;
                    spw_end1_data_tx_command_txflag_o   <= spw_end0_data_rx_status_rxflag_i;
                end if;
            end if;
        end procedure p_spw_data_passthrough;
        --
        procedure p_spw_errinj_disable(
            signal spw_errinj_ctrl_start_errinj_o : out std_logic;
            signal spw_errinj_ctrl_reset_errinj_o : out std_logic;
            signal spw_errinj_ctrl_errinj_code_o  : out std_logic_vector(3 downto 0)
        ) is
        begin
            spw_errinj_ctrl_start_errinj_o <= '0';
            spw_errinj_ctrl_reset_errinj_o <= '0';
            spw_errinj_ctrl_errinj_code_o  <= (others => '0');
        end procedure p_spw_errinj_disable;
        --
    begin
        if (a_reset = '1') then

            -- disable all spacewire outs
            -- disable spw 0
            p_spw_disable(spw_ct0_link_command_autostart_o, spw_ct0_link_command_linkstart_o, spw_ct0_link_command_linkdis_o, spw_ct0_link_command_txdivcnt_o, spw_ct0_timecode_tx_tick_in_o, spw_ct0_timecode_tx_ctrl_in_o, spw_ct0_timecode_tx_time_in_o, spw_ct0_data_rx_command_rxread_o, spw_ct0_data_tx_command_txwrite_o, spw_ct0_data_tx_command_txflag_o, spw_ct0_data_tx_command_txdata_o, spw_ct0_errinj_ctrl_start_errinj_o, spw_ct0_errinj_ctrl_reset_errinj_o, spw_ct0_errinj_ctrl_errinj_code_o);
            -- disable spw 1
            p_spw_disable(spw_ct1_link_command_autostart_o, spw_ct1_link_command_linkstart_o, spw_ct1_link_command_linkdis_o, spw_ct1_link_command_txdivcnt_o, spw_ct1_timecode_tx_tick_in_o, spw_ct1_timecode_tx_ctrl_in_o, spw_ct1_timecode_tx_time_in_o, spw_ct1_data_rx_command_rxread_o, spw_ct1_data_tx_command_txwrite_o, spw_ct1_data_tx_command_txflag_o, spw_ct1_data_tx_command_txdata_o, spw_ct1_errinj_ctrl_start_errinj_o, spw_ct1_errinj_ctrl_reset_errinj_o, spw_ct1_errinj_ctrl_errinj_code_o);

        elsif (rising_edge(a_clock)) then

            -- check if the spw pass passthrough is enabled
            if (passthrough_enable_i = '1') then
                -- spw pass passthrough is enabled

                -- configure link for spw 0
                p_spw_link_config(spw_ct0_link_command_autostart_o, spw_ct0_link_command_linkstart_o, spw_ct0_link_command_linkdis_o, spw_ct0_link_command_txdivcnt_o);
                -- perform passthrough of timecode from spw 0 to spw 1
                p_spw_timecode_passthrough(spw_ct0_link_status_running_i, spw_ct1_link_status_running_i, spw_ct0_timecode_rx_tick_out_i, spw_ct0_timecode_rx_ctrl_out_i, spw_ct0_timecode_rx_time_out_i, spw_ct1_timecode_tx_tick_in_o, spw_ct1_timecode_tx_ctrl_in_o, spw_ct1_timecode_tx_time_in_o);
                -- perform passthrough of data from spw 0 to spw 1
                p_spw_data_passthrough(spw_ct0_link_status_running_i, spw_ct1_link_status_running_i, spw_ct0_data_rx_status_rxvalid_i, spw_ct0_data_rx_status_rxflag_i, spw_ct0_data_rx_status_rxdata_i, spw_ct1_data_tx_status_txrdy_i, spw_ct0_data_rx_command_rxread_o, spw_ct1_data_tx_command_txwrite_o, spw_ct1_data_tx_command_txflag_o, spw_ct1_data_tx_command_txdata_o, s_spw_ct1_data_tx_command_txwrite);
                -- disable error injection for spw 0
                p_spw_errinj_disable(spw_ct0_errinj_ctrl_start_errinj_o, spw_ct0_errinj_ctrl_reset_errinj_o, spw_ct0_errinj_ctrl_errinj_code_o);
                -- configure link for spw 1
                p_spw_link_config(spw_ct1_link_command_autostart_o, spw_ct1_link_command_linkstart_o, spw_ct1_link_command_linkdis_o, spw_ct1_link_command_txdivcnt_o);
                -- perform passthrough of timecode from spw 1 to spw 0
                p_spw_timecode_passthrough(spw_ct1_link_status_running_i, spw_ct0_link_status_running_i, spw_ct1_timecode_rx_tick_out_i, spw_ct1_timecode_rx_ctrl_out_i, spw_ct1_timecode_rx_time_out_i, spw_ct0_timecode_tx_tick_in_o, spw_ct0_timecode_tx_ctrl_in_o, spw_ct0_timecode_tx_time_in_o);
                -- perform passthrough of data from spw 1 to spw 0
                p_spw_data_passthrough(spw_ct1_link_status_running_i, spw_ct0_link_status_running_i, spw_ct1_data_rx_status_rxvalid_i, spw_ct1_data_rx_status_rxflag_i, spw_ct1_data_rx_status_rxdata_i, spw_ct0_data_tx_status_txrdy_i, spw_ct1_data_rx_command_rxread_o, spw_ct0_data_tx_command_txwrite_o, spw_ct0_data_tx_command_txflag_o, spw_ct0_data_tx_command_txdata_o, s_spw_ct0_data_tx_command_txwrite);
                -- disable error injection for spw 1
                p_spw_errinj_disable(spw_ct1_errinj_ctrl_start_errinj_o, spw_ct1_errinj_ctrl_reset_errinj_o, spw_ct1_errinj_ctrl_errinj_code_o);

            else
                -- spw pass passthrough is disabled

                -- disable all spacewire outs
                -- disable spw 0
                p_spw_disable(spw_ct0_link_command_autostart_o, spw_ct0_link_command_linkstart_o, spw_ct0_link_command_linkdis_o, spw_ct0_link_command_txdivcnt_o, spw_ct0_timecode_tx_tick_in_o, spw_ct0_timecode_tx_ctrl_in_o, spw_ct0_timecode_tx_time_in_o, spw_ct0_data_rx_command_rxread_o, spw_ct0_data_tx_command_txwrite_o, spw_ct0_data_tx_command_txflag_o, spw_ct0_data_tx_command_txdata_o, spw_ct0_errinj_ctrl_start_errinj_o, spw_ct0_errinj_ctrl_reset_errinj_o, spw_ct0_errinj_ctrl_errinj_code_o);
                -- disable spw 1
                p_spw_disable(spw_ct1_link_command_autostart_o, spw_ct1_link_command_linkstart_o, spw_ct1_link_command_linkdis_o, spw_ct1_link_command_txdivcnt_o, spw_ct1_timecode_tx_tick_in_o, spw_ct1_timecode_tx_ctrl_in_o, spw_ct1_timecode_tx_time_in_o, spw_ct1_data_rx_command_rxread_o, spw_ct1_data_tx_command_txwrite_o, spw_ct1_data_tx_command_txflag_o, spw_ct1_data_tx_command_txdata_o, spw_ct1_errinj_ctrl_start_errinj_o, spw_ct1_errinj_ctrl_reset_errinj_o, spw_ct1_errinj_ctrl_errinj_code_o);

            end if;

        end if;
    end process p_pwp_spacewire_passthrough;

    -- Signals Assignments --

end architecture rtl;                   -- of spwp_spacewire_passthrough_top
