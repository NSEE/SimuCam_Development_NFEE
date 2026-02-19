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
        clk_50_i         : in  std_logic := '0'; --           clock_sink_50mhz.clk
        clk_200_i        : in  std_logic := '0'; --          clock_sink_200mhz.clk
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

    -- timing base
    constant c_CLK_200_HZ : natural := 200_000_000;

    -- time-based filter tuning (microseconds)
    -- For a 2.3 s high / 200 ms low signal, these defaults keep transitions fast
    -- while rejecting short glitches/chatter.
    -- Effective behavior:
    -- 1) input must stay opposite for c_FILTER_TIME_US before output toggles
    -- 2) after a toggle, output state is held at least c_MIN_HIGH_US/c_MIN_LOW_US
    --    (minimum pulse-width qualifier)
    constant c_FILTER_TIME_US : natural := 20;  -- consecutive-stable qualifier
    constant c_MIN_HIGH_US    : natural := 100; -- minimum accepted high width
    constant c_MIN_LOW_US     : natural := 100; -- minimum accepted low width

    -- convert microseconds to clock cycles (minimum 1 cycle)
    function f_us_to_cycles(p_clk_hz : natural; p_time_us : natural) return natural is
        variable v_cycles : natural;
    begin
        v_cycles := (p_clk_hz / 1_000_000) * p_time_us;
        if (v_cycles = 0) then
            return 1;
        end if;
        return v_cycles;
    end function f_us_to_cycles;

    function f_max_nat(p_a : natural; p_b : natural) return natural is
    begin
        if (p_a > p_b) then
            return p_a;
        end if;
        return p_b;
    end function f_max_nat;

    constant c_FILTER_CYCLES   : natural := f_us_to_cycles(c_CLK_200_HZ, c_FILTER_TIME_US);
    constant c_MIN_HIGH_CYCLES : natural := f_us_to_cycles(c_CLK_200_HZ, c_MIN_HIGH_US);
    constant c_MIN_LOW_CYCLES  : natural := f_us_to_cycles(c_CLK_200_HZ, c_MIN_LOW_US);
    constant c_MIN_DWELL_MAX   : natural := f_max_nat(c_MIN_HIGH_CYCLES, c_MIN_LOW_CYCLES);

    -- signals --

    -- synchronized resets (async assert, sync deassert)
    -- This avoids reset-release races between the 200 MHz and 50 MHz domains.
    signal s_reset_stage1_200 : std_logic;
    signal s_reset_200        : std_logic;
    signal s_reset_stage1_50  : std_logic;
    signal s_reset_50         : std_logic;

    -- input synchronizer (200 MHz domain)
    -- External signal is asynchronous; these 2 flops reduce metastability risk
    -- before filtering.
    signal s_unfiltered_sig_stage1_200 : std_logic;
    signal s_unfiltered_sig_sync_200   : std_logic;

    -- filtered signals (200 MHz)
    signal s_filtered_sig_200         : std_logic;
    -- opposite-run counter: counts consecutive samples that differ from output
    signal s_transition_count_200     : natural range 0 to c_FILTER_CYCLES;
    -- dwell counter: enforces minimum time in the current output state
    signal s_state_dwell_count_200    : natural range 0 to c_MIN_DWELL_MAX;

    -- filtered signals (50 MHz)
    signal s_filtered_sig_stage1_50 : std_logic;
    signal s_filtered_sig_stage2_50 : std_logic;

begin

    -- Processes --

    -- Reset Synchronizer (200 MHz)
    p_reset_sync_200 : process(a_sampling_clock, a_reset) is
    begin
        if (a_reset = '1') then
            s_reset_stage1_200 <= '1';
            s_reset_200        <= '1';
        elsif (rising_edge(a_sampling_clock)) then
            s_reset_stage1_200 <= '0';
            s_reset_200        <= s_reset_stage1_200;
        end if;
    end process p_reset_sync_200;

    -- Reset Synchronizer (50 MHz)
    p_reset_sync_50 : process(a_filtered_clock, a_reset) is
    begin
        if (a_reset = '1') then
            s_reset_stage1_50 <= '1';
            s_reset_50        <= '1';
        elsif (rising_edge(a_filtered_clock)) then
            s_reset_stage1_50 <= '0';
            s_reset_50        <= s_reset_stage1_50;
        end if;
    end process p_reset_sync_50;

    -- Input Synchronizer (200 MHz)
    p_input_sync_200 : process(a_sampling_clock) is
    begin
        if (rising_edge(a_sampling_clock)) then
            if (s_reset_200 = '1') then
                s_unfiltered_sig_stage1_200 <= '0';
                s_unfiltered_sig_sync_200   <= '0';
            else
                s_unfiltered_sig_stage1_200 <= unfiltered_sig_i;
                s_unfiltered_sig_sync_200   <= s_unfiltered_sig_stage1_200;
            end if;
        end if;
    end process p_input_sync_200;

    -- Signal Filter Latch (200 MHz) Process
    -- Hardened logic:
    -- 1) consecutive-sample qualifier (glitch rejection)
    -- 2) minimum pulse-width lock (anti-bounce/chatter)
    p_sgfl_signal_filter_latch_200 : process(a_sampling_clock) is
        variable v_required_dwell_cycles : natural;
    begin
        if (rising_edge(a_sampling_clock)) then
            if (s_reset_200 = '1') then
                -- reset signals
                s_filtered_sig_200        <= '0';
                s_transition_count_200    <= 0;
                s_state_dwell_count_200   <= 0;
            else

                -- select minimum dwell time based on current output state
                if (s_filtered_sig_200 = '1') then
                    v_required_dwell_cycles := c_MIN_HIGH_CYCLES;
                else
                    v_required_dwell_cycles := c_MIN_LOW_CYCLES;
                end if;

                -- saturating dwell counter: ensures minimum pulse width on the output state
                if (s_state_dwell_count_200 < v_required_dwell_cycles) then
                    s_state_dwell_count_200 <= s_state_dwell_count_200 + 1;
                end if;

                -- consecutive-sample qualifier for opposite transitions
                if (s_unfiltered_sig_sync_200 /= s_filtered_sig_200) then
                    if (s_state_dwell_count_200 >= v_required_dwell_cycles) then
                        if (s_transition_count_200 < c_FILTER_CYCLES) then
                            s_transition_count_200 <= s_transition_count_200 + 1;
                        end if;

                        -- accept state transition after enough consecutive opposite samples
                        if (s_transition_count_200 >= (c_FILTER_CYCLES - 1)) then
                            s_filtered_sig_200      <= s_unfiltered_sig_sync_200;
                            s_transition_count_200  <= 0;
                            s_state_dwell_count_200 <= 0;
                        end if;
                    else
                        -- ignore opposite transitions until minimum state dwell is satisfied
                        s_transition_count_200 <= 0;
                    end if;
                else
                    -- input returned to current state; opposite run is broken
                    s_transition_count_200 <= 0;
                end if;

            end if;
        end if;
    end process p_sgfl_signal_filter_latch_200;

    -- Signal Filter Latch (50 MHz) Process
    -- CDC transfer into the 50 MHz domain (2 sync stages + registered output).
    p_sgfl_signal_filter_latch_50 : process(a_filtered_clock) is
    begin
        if (rising_edge(a_filtered_clock)) then
            if (s_reset_50 = '1') then
                s_filtered_sig_stage1_50 <= '0';
                s_filtered_sig_stage2_50 <= '0';
                filtered_sig_o           <= '0';
            else

                -- get the filtered signal with 2 stage synchronization
                s_filtered_sig_stage1_50 <= s_filtered_sig_200;
                s_filtered_sig_stage2_50 <= s_filtered_sig_stage1_50;
                filtered_sig_o           <= s_filtered_sig_stage2_50;

            end if;
        end if;
    end process p_sgfl_signal_filter_latch_50;

    -- Signals Assignments --

end architecture rtl;                   -- of sgfl_signal_filter_latch_top
