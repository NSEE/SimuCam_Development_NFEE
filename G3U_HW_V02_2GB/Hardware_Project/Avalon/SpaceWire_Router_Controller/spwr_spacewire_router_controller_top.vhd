-- spwr_spacewire_router_controller_top.vhd

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

entity spwr_spacewire_router_controller_top is
    port(
        clock_i                : in  std_logic                    := '0'; --          --                       clock_sink.clk
        reset_i                : in  std_logic                    := '0'; --          --                       reset_sink.reset
        router_config_en_i     : in  std_logic                    := '0'; --          --       conduit_end_router_control.router_config_en_signal
        router_path_0_select_i : in  std_logic_vector(1 downto 0) := (others => '0'); --                                 .router_path_0_select_signal
        router_path_1_select_i : in  std_logic_vector(1 downto 0) := (others => '0'); --                                 .router_path_1_select_signal
        drivers_isolator_en_o  : out std_logic; --                                    --  conduit_end_drivers_isolator_en.drivers_isolator_en_signal
        passthrough_0_enable_o : out std_logic; --                                    -- conduit_end_passthrough_0_enable.passthrough_enable_signal
        passthrough_1_enable_o : out std_logic; --                                    -- conduit_end_passthrough_1_enable.passthrough_enable_signal
        demux_0_select_o       : out std_logic_vector(1 downto 0); --                 --       conduit_end_demux_0_select.demux_select_signal
        demux_1_select_o       : out std_logic_vector(1 downto 0) --                  --       conduit_end_demux_1_select.demux_select_signal
    );
end entity spwr_spacewire_router_controller_top;

architecture rtl of spwr_spacewire_router_controller_top is

    -- Alias --

    -- Basic Alias
    alias a_reset is reset_i;
    alias a_clock is clock_i;

    -- Constants --
    constant c_ROUTER_PATH_SELECTED_NONE : std_logic_vector(1 downto 0) := "00";
    constant c_ROUTER_PATH_SELECTED_END0 : std_logic_vector(1 downto 0) := "01";
    constant c_ROUTER_PATH_SELECTED_END1 : std_logic_vector(1 downto 0) := "10";
    constant c_ROUTER_PATH_SELECTED_END2 : std_logic_vector(1 downto 0) := "11";

    constant c_DEMUX_SELECTED_CH_0 : std_logic_vector(1 downto 0) := "00";
    constant c_DEMUX_SELECTED_CH_1 : std_logic_vector(1 downto 0) := "01";
    constant c_DEMUX_SELECTED_CH_2 : std_logic_vector(1 downto 0) := "10";
    constant c_DEMUX_SELECTED_NONE : std_logic_vector(1 downto 0) := "11";

    -- Signals --
    signal s_buffered_router_path_0_select  : std_logic_vector(1 downto 0);
    signal s_buffered_router_path_1_select  : std_logic_vector(1 downto 0);
    signal s_unbuffered_drivers_isolator_en : std_logic;

begin

    -- Entities Instantiation --

    -- SpaceWire Router Path 0 Select Inputs ALTIOBUF Instantiation
    spwr_select_0_in_altiobuf_inst : entity work.spwr_select_in_altiobuf
        port map(
            datain  => router_path_0_select_i,
            dataout => s_buffered_router_path_0_select
        );

    -- SpaceWire Router Path 1 Select Inputs ALTIOBUF Instantiation
    spwr_select_1_in_altiobuf_inst : entity work.spwr_select_in_altiobuf
        port map(
            datain  => router_path_1_select_i,
            dataout => s_buffered_router_path_1_select
        );

    -- SpaceWire Router Drivers-Isolator Enable Output ALTIOBUF Instantiation    
    spwr_dvriso_en_out_altiobuf_inst : entity work.spwr_dvriso_en_out_altiobuf
        port map(
            datain(0)  => s_unbuffered_drivers_isolator_en,
            dataout(0) => drivers_isolator_en_o
        );

    -- Processes --

    p_spwr_spacewire_router_controller : process(a_clock, a_reset) is
        --
        procedure p_config_router_path(
            signal router_path_select_i : in std_logic_vector(1 downto 0);
            signal passthrough_enable_o : out std_logic;
            signal demux_select_o       : out std_logic_vector(1 downto 0)
        ) is
        begin
            -- select the appropriate demux path based on the router path select
            case (router_path_select_i) is
                when (c_ROUTER_PATH_SELECTED_NONE) =>
                    demux_select_o       <= c_DEMUX_SELECTED_NONE;
                    passthrough_enable_o <= '0';
                when (c_ROUTER_PATH_SELECTED_END0) =>
                    demux_select_o       <= c_DEMUX_SELECTED_CH_0;
                    passthrough_enable_o <= '1';
                when (c_ROUTER_PATH_SELECTED_END1) =>
                    demux_select_o       <= c_DEMUX_SELECTED_CH_1;
                    passthrough_enable_o <= '1';
                when (c_ROUTER_PATH_SELECTED_END2) =>
                    demux_select_o       <= c_DEMUX_SELECTED_CH_2;
                    passthrough_enable_o <= '1';
                when others =>
                    demux_select_o       <= c_DEMUX_SELECTED_NONE;
                    passthrough_enable_o <= '0';
            end case;
        end procedure p_config_router_path;
        --
    begin
        if (a_reset = '1') then
            s_unbuffered_drivers_isolator_en <= '0';
            passthrough_0_enable_o           <= '0';
            passthrough_1_enable_o           <= '0';
            demux_0_select_o                 <= c_ROUTER_PATH_SELECTED_NONE;
            demux_1_select_o                 <= c_ROUTER_PATH_SELECTED_NONE;
        elsif (rising_edge(a_clock)) then

            -- check if the router configuration mode is enabled
            if (router_config_en_i = '1') then
                -- router configuration mode is enabled
                -- keep all spacewire channels disconnected
                s_unbuffered_drivers_isolator_en <= '0';
                -- keep both passthrough disabled
                passthrough_0_enable_o           <= '0';
                passthrough_1_enable_o           <= '0';
                -- keep both passthrough with no selection
                demux_0_select_o                 <= c_ROUTER_PATH_SELECTED_NONE;
                demux_1_select_o                 <= c_ROUTER_PATH_SELECTED_NONE;
            else
                -- router configuration mode is disabled
                -- connect the spacewire channels
                s_unbuffered_drivers_isolator_en <= '1';
                -- set the configuration for path 0
                p_config_router_path(s_buffered_router_path_0_select, passthrough_0_enable_o, demux_0_select_o);
                -- set the configuration for path 1
                p_config_router_path(s_buffered_router_path_1_select, passthrough_1_enable_o, demux_1_select_o);
            end if;

        end if;
    end process p_spwr_spacewire_router_controller;

    -- Signals Assignments --

end architecture rtl;                   -- of spwr_spacewire_router_controller_top
