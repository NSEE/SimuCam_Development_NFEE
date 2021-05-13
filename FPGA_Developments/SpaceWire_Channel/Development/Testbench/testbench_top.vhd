library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.spwpkg.all;
use work.spwc_errinj_pkg.all;

entity testbench_top is
end entity testbench_top;

architecture RTL of testbench_top is

    -- clk and rst signals
    signal clk200 : std_logic := '0';
    signal clk100 : std_logic := '0';
    signal rst    : std_logic := '1';

    -- dut signals

    -- lvds signals (comm)
    signal s_spw_codec_comm_di : std_logic;
    signal s_spw_codec_comm_do : std_logic;
    signal s_spw_codec_comm_si : std_logic;
    signal s_spw_codec_comm_so : std_logic;

    -- lvds signals (dummy)
    signal s_spw_codec_dummy_di : std_logic;
    signal s_spw_codec_dummy_do : std_logic;
    signal s_spw_codec_dummy_si : std_logic;
    signal s_spw_codec_dummy_so : std_logic;

    -- spacewire clock signal
    signal s_spw_clock : std_logic;

    -- spacewire enable signal
    signal s_spw_enable : std_logic;

    --dummy
    signal s_dummy_spw_rxvalid : std_logic;
    signal s_dummy_spw_rxhalff : std_logic;
    signal s_dummy_spw_rxflag  : std_logic;
    signal s_dummy_spw_rxdata  : std_logic_vector(7 downto 0);
    signal s_dummy_spw_rxread  : std_logic;

    signal s_spwcfg_autostart : std_logic;
    signal s_spwcfg_linkstart : std_logic;
    signal s_spwcfg_linkdis   : std_logic;
    signal s_spwcfg_txdivcnt  : std_logic_vector(7 downto 0);

    signal s_spwerr_start_errinj : std_logic;
    signal s_spwerr_reset_errinj : std_logic;
    signal s_spwerr_errinj_code  : std_logic_vector(3 downto 0);

    signal s_stats_spw_started    : std_logic;
    signal s_stats_spw_connecting : std_logic;
    signal s_stats_spw_running    : std_logic;
    signal s_error_spw_errdisc    : std_logic;
    signal s_error_spw_errpar     : std_logic;
    signal s_error_spw_erresc     : std_logic;
    signal s_error_spw_errcred    : std_logic;

    constant c_SPW_DI_RANDOM_NOISE : std_logic_vector(1023 downto 0) := "1110001000110011001111001001110101100101011010000101100110000000110110100100011110000111110001111101011111101110110101111010100010100001011111111010111110001111010101000101011010110000000111010011010110101100000110101000010110101100110111111001100001100101101100010100100101100110111010011000000111100001010000110000111111110101001011110011010011110000101101111110110000101001010110110011100011000101110000000001101111000000110110010110100011100000011100101110000111001110001000101000001101100110111001011001011000011000010111110010100110010100011010110110111011111010111011001001000000011100101101111000100000001101011011000001111111000101010101001110110010110001111000000000100011000001111110100001001100010110110010001010101000001001000000100111011111100110000000101100001101110100110110001101111000011011011100110110001100011111101111011101010111101100110111001111111000000011010111111000110100100100010100000110101001000010001110001000001011110000111011110000101100000110100111101001000001111111101100010000010100110110";
    constant c_SPW_SI_RANDOM_NOISE : std_logic_vector(1023 downto 0) := "0011101011111111011110101100111000101011100001101001011001111011100111111011110111010111100010110010101100111111100110101100110100000011110100110101101111000010001011000101111101111011101111111000111111001100111001011101100001110110000001010101111010010101100111001100000111111101010011100100001011000101001110010011010100001011001001000000101000000110110101111101001001010011000111110110010111011110010111000011101100011001100110000100110001100001011110010011101101001011100010000001000000010100110110101000110001010111111011000011000000001000100010000100011001000101001100110100110001000100001111010000001010010001100000010101010001111111100100111100000101000011101011111110100100100101111010010110111101010010110001110110101101101110001111101101011101001010011000100111001110110100011100000011110011010011100001000000010110111110110110011001000000111111001110001000111100100111110110000010000111110101100011000101001101101101100101010001010011000000011111001000111010100110010001111101111001010100000100001001000001100011";

    signal s_random_noise_cnt : natural range 0 to 1023;

begin

    clk200 <= not clk200 after 2.5 ns;  -- 200 MHz
    clk100 <= not clk100 after 5 ns;    -- 100 MHz
    rst    <= '0' after 100 ns;

    spwc_spacewire_channel_top_inst : entity work.spwc_spacewire_channel_top
        generic map(
            g_SPWC_TESTBENCH_MODE => '1'
        )
        port map(
            reset_i                        => rst,
            clk_100_i                      => clk100,
            clk_200_i                      => clk200,
            spw_lvds_p_data_in_i           => s_spw_codec_comm_di,
            spw_lvds_n_data_in_i           => '0',
            spw_lvds_p_strobe_in_i         => s_spw_codec_comm_si,
            spw_lvds_n_strobe_in_i         => '0',
            spw_lvds_p_data_out_o          => s_spw_codec_comm_do,
            spw_lvds_n_data_out_o          => open,
            spw_lvds_p_strobe_out_o        => s_spw_codec_comm_so,
            spw_lvds_n_strobe_out_o        => open,
            spw_rx_enable_i                => s_spw_enable,
            spw_tx_enable_i                => s_spw_enable,
            spw_red_status_led_o           => open,
            spw_green_status_led_o         => open,
            spw_link_command_autostart_i   => s_spwcfg_autostart,
            spw_link_command_linkstart_i   => s_spwcfg_linkstart,
            spw_link_command_linkdis_i     => s_spwcfg_linkdis,
            spw_link_command_txdivcnt_i    => s_spwcfg_txdivcnt,
            spw_timecode_tx_tick_in_i      => '0',
            spw_timecode_tx_ctrl_in_i      => (others => '0'),
            spw_timecode_tx_time_in_i      => (others => '0'),
            spw_data_rx_command_rxread_i   => '0',
            spw_data_tx_command_txwrite_i  => '0',
            spw_data_tx_command_txflag_i   => '0',
            spw_data_tx_command_txdata_i   => (others => '0'),
            spw_errinj_ctrl_start_errinj_i => s_spwerr_start_errinj,
            spw_errinj_ctrl_reset_errinj_i => s_spwerr_reset_errinj,
            spw_errinj_ctrl_errinj_code_i  => s_spwerr_errinj_code,
            spw_link_status_started_o      => open,
            spw_link_status_connecting_o   => open,
            spw_link_status_running_o      => open,
            spw_link_error_errdisc_o       => open,
            spw_link_error_errpar_o        => open,
            spw_link_error_erresc_o        => open,
            spw_link_error_errcred_o       => open,
            spw_timecode_rx_tick_out_o     => open,
            spw_timecode_rx_ctrl_out_o     => open,
            spw_timecode_rx_time_out_o     => open,
            spw_data_rx_status_rxvalid_o   => open,
            spw_data_rx_status_rxhalff_o   => open,
            spw_data_rx_status_rxflag_o    => open,
            spw_data_rx_status_rxdata_o    => open,
            spw_data_tx_status_txrdy_o     => open,
            spw_data_tx_status_txhalff_o   => open,
            spw_errinj_ctrl_errinj_busy_o  => open,
            spw_errinj_ctrl_errinj_ready_o => open
        );

    s_spw_enable <= '0', '1' after 5 us;

    --	s_spw_codec_comm_di <= s_spw_codec_comm_do;
    --	s_spw_codec_comm_si <= s_spw_codec_comm_so;

    p_spw_cfg : process(clk100, rst) is
        variable v_cnt : natural := 0;
    begin
        if rst = '1' then
            s_spwcfg_autostart    <= '0';
            s_spwcfg_linkstart    <= '0';
            s_spwcfg_linkdis      <= '0';
            s_spwcfg_txdivcnt     <= x"01";
            s_spwerr_start_errinj <= '0';
            s_spwerr_reset_errinj <= '0';
            s_spwerr_errinj_code  <= c_SPWC_ERRINJ_CODE_NONE;
            s_random_noise_cnt    <= 1023;
            v_cnt                 := 0;
        elsif rising_edge(clk100) then
            s_spwcfg_autostart <= '1';
            s_spwcfg_linkstart <= '1';
            s_spwcfg_linkdis   <= '0';
            s_spwcfg_txdivcnt  <= x"01";

            s_spwerr_start_errinj <= '0';
            s_spwerr_reset_errinj <= '0';
            s_spwerr_errinj_code  <= c_SPWC_ERRINJ_CODE_NONE;
            --            s_spwerr_errinj_code  <= c_SPWC_ERRINJ_CODE_PARITY;
            case (v_cnt) is
                when 5000 =>
                    --                    s_spwerr_start_errinj <= '1';
                    --            s_spwcfg_autostart <= '1';
                    --            s_spwcfg_linkstart <= '1';
                    --            s_spwcfg_linkdis   <= '0';
                when 6000 =>
                    --                    s_spwerr_reset_errinj <= '1';
                when others =>
                    null;
            end case;
            v_cnt := v_cnt + 1;

            if (s_random_noise_cnt = 0) then
                s_random_noise_cnt <= 1023;
            else
                s_random_noise_cnt <= s_random_noise_cnt - 1;
            end if;

        end if;
    end process p_spw_cfg;

    s_spw_clock <= (s_spw_codec_comm_so) xor (s_spw_codec_comm_do);

    -- spw connection
    -- SpaceWire Light Codec Component 
    spw_stimuli_spwstream_inst : entity work.spwstream
        generic map(
            sysfreq         => 200000000.0,
            txclkfreq       => 0.0,
            rximpl          => impl_generic,
            rxchunk         => 1,
            tximpl          => impl_generic,
            rxfifosize_bits => 11,
            txfifosize_bits => 11
        )
        port map(
            clk        => clk200,
            rxclk      => clk200,
            txclk      => clk200,
            rst        => rst,
            autostart  => '1',
            linkstart  => '1',
            linkdis    => '0',
            txdivcnt   => x"01",
            tick_in    => '0',
            ctrl_in    => "00",
            time_in    => "000000",
            txwrite    => '0',
            txflag     => '0',
            txdata     => x"00",
            txrdy      => open,
            txhalff    => open,
            tick_out   => open,
            ctrl_out   => open,
            time_out   => open,
            rxvalid    => s_dummy_spw_rxvalid,
            rxhalff    => s_dummy_spw_rxhalff,
            rxflag     => s_dummy_spw_rxflag,
            rxdata     => s_dummy_spw_rxdata,
            rxread     => s_dummy_spw_rxread,
            started    => s_stats_spw_started,
            connecting => s_stats_spw_connecting,
            running    => s_stats_spw_running,
            errdisc    => s_error_spw_errdisc,
            errpar     => s_error_spw_errpar,
            erresc     => s_error_spw_erresc,
            errcred    => s_error_spw_errcred,
            spw_di     => s_spw_codec_dummy_di,
            spw_si     => s_spw_codec_dummy_si,
            spw_do     => s_spw_codec_dummy_do,
            spw_so     => s_spw_codec_dummy_so,
            err_inj_i  => '0',
            err_sel_i  => reserved,
            err_stat_o => open
        );

--    s_spw_codec_comm_di  <= c_SPW_DI_RANDOM_NOISE(s_random_noise_cnt);
--    s_spw_codec_comm_si  <= c_SPW_SI_RANDOM_NOISE(s_random_noise_cnt);
        s_spw_codec_comm_di  <= s_spw_codec_dummy_do;
        s_spw_codec_comm_si  <= s_spw_codec_dummy_so;
    s_spw_codec_dummy_di <= s_spw_codec_comm_do;
    s_spw_codec_dummy_si <= s_spw_codec_comm_so;

end architecture RTL;
