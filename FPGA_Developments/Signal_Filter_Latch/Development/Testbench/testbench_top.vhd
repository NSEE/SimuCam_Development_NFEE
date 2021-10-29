library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testbench_top is
end entity testbench_top;

architecture RTL of testbench_top is

    -- clk and rst signals
    signal rst    : std_logic := '1';
    signal clk50  : std_logic := '0';
    signal clk200 : std_logic := '0';

    -- dut signals

    -- tb unfiltered signals
--    constant c_TB_UNFILTERED_SAMPLES : std_logic_vector(31 downto 0) := x"00000000";
--    constant c_TB_UNFILTERED_SAMPLES : std_logic_vector(31 downto 0) := x"FFFFFFFF";
    constant c_TB_UNFILTERED_SAMPLES : std_logic_vector(31 downto 0) := x"FFFA0001";
    signal s_tb_sample_cnt           : natural range 0 to 31;
    signal s_tb_unfiltered_sig       : std_logic;

begin

    clk50  <= not clk50 after 10 ns;    -- 50 MHz
    clk200 <= not clk200 after 2.5 ns;  -- 200 MHz
    rst    <= '0' after 100 ns;

    -- sgfl signal filter latch top instantiation
    sgfl_signal_filter_latch_top_inst : entity work.sgfl_signal_filter_latch_top
        port map(
            reset_i          => rst,
            clk_50_i         => clk50,
            clk_200_i        => clk200,
            unfiltered_sig_i => s_tb_unfiltered_sig,
            filtered_sig_o   => open
        );

    -- testbench unfilteres signal samples process
    p_unfiltered_signal_samples : process(clk200, rst) is
    begin
        if (rst = '1') then
            s_tb_sample_cnt     <= 0;
            s_tb_unfiltered_sig <= '0';
        elsif (rising_edge(clk200)) then

            -- update sample counter
            if (s_tb_sample_cnt = 31) then
                s_tb_sample_cnt <= 0;
            else
                s_tb_sample_cnt <= s_tb_sample_cnt + 1;
            end if;

            -- update unfiltered signal
            s_tb_unfiltered_sig <= c_TB_UNFILTERED_SAMPLES(s_tb_sample_cnt);

        end if;
    end process p_unfiltered_signal_samples;

end architecture RTL;
