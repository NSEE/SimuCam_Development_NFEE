-- farm_rmap_memory_ffee_aeb_area_top.vhd

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

entity sgfl_signal_filter_latch_top is
    port(
        reset_i          : in  std_logic := '0'; --                 reset_sink.reset
        clk_50_i         : in  std_logic := '0'; --          clock_sink_500mhz.clk
        clk_200_i        : in  std_logic := '0'; --          clock_sink_100mhz.clk
        unfiltered_sig_i : in  std_logic := '0'; -- conduit_end_unfiltered_sig.unfiltered_sig_signal
        filtered_sig_o   : out std_logic ---     --   conduit_end_filtered_sig.filtered_sig_signal
    );
end entity sgfl_signal_filter_latch_top;

architecture rtl of sgfl_signal_filter_latch_top is

    -- alias --
    alias a_sampling_clock is clk_200_i;
    alias a_filtered_clock is clk_50_i;
    alias a_reset is reset_i;

    -- constants --

    -- filter contants
    constant c_FILTER_SIZE  : natural range 0 to 32                          := 8;
    constant c_STABLE_CLEAR : std_logic_vector((c_FILTER_SIZE - 1) downto 0) := (others => '0');
    constant c_STABLE_SET   : std_logic_vector((c_FILTER_SIZE - 1) downto 0) := (others => '1');

    -- signals --

    -- unfiltered signals (200 MHz)
    signal s_unfiltered_sig_samples_200 : std_logic_vector((c_FILTER_SIZE - 1) downto 0);

    -- filtered signals (200 MHz)
    signal s_filtered_sig_200 : std_logic;

    -- filtered signals (50 MHz)
    signal s_filtered_sig_stage1_50 : std_logic;
    signal s_filtered_sig_stage2_50 : std_logic;

begin

    -- Processes --

    -- Signal Filter Latch (200 MHz) Process
    p_sgfl_signal_filter_latch_200 : process(a_sampling_clock, a_reset) is
    begin
        if (a_reset = '1') then
            -- reset signals
            s_unfiltered_sig_samples_200 <= c_STABLE_CLEAR;
            s_filtered_sig_200           <= '0';
        elsif (rising_edge(a_sampling_clock)) then

            -- update the unfiltered signal samples vector
            s_unfiltered_sig_samples_200(0) <= unfiltered_sig_i;
            for index in 1 to (c_FILTER_SIZE - 1) loop
                s_unfiltered_sig_samples_200(index) <= s_unfiltered_sig_samples_200(index - 1);
            end loop;

            -- check if the signal is stable and clear
            if (s_unfiltered_sig_samples_200 = c_STABLE_CLEAR) then
                -- the signal is stable and clear
                -- clear the filtered signal
                s_filtered_sig_200 <= '0';
            -- check if the signal is stable and set
            elsif (s_unfiltered_sig_samples_200 = c_STABLE_SET) then
                -- the signal is stable and set
                -- set the filtered signal
                s_filtered_sig_200 <= '1';
            else
                -- the signal is not stable
                -- keep the last state
                s_filtered_sig_200 <= s_filtered_sig_200;
            end if;

        end if;
    end process p_sgfl_signal_filter_latch_200;

    -- Signal Filter Latch (50 MHz) Process
    p_sgfl_signal_filter_latch_50 : process(a_filtered_clock, a_reset) is
    begin
        if (a_reset = '1') then
            s_filtered_sig_stage1_50 <= '0';
            s_filtered_sig_stage2_50 <= '0';
            filtered_sig_o           <= '0';
        elsif (rising_edge(a_filtered_clock)) then

            -- get the filtered signal with 2 stage synchronization
            s_filtered_sig_stage1_50 <= s_filtered_sig_200;
            s_filtered_sig_stage2_50 <= s_filtered_sig_stage1_50;
            filtered_sig_o           <= s_filtered_sig_stage2_50;

        end if;
    end process p_sgfl_signal_filter_latch_50;

    -- Signals Assignments --

end architecture rtl;                   -- of sgfl_signal_filter_latch_top
