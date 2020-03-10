library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.nrme_avalon_mm_rmap_nfee_pkg.all;

entity testbench_top is
end entity testbench_top;

architecture RTL of testbench_top is

	-- clk and rst signals
	signal clk100 : std_logic := '0';
	signal rst    : std_logic := '1';

	-- dut signals

	-- rmap_avalon_stimuli signals
	signal s_rmap_avalon_stimuli_mm_readdata    : std_logic_vector(31 downto 0); -- -- avalon_mm.readdata
	signal s_rmap_avalon_stimuli_mm_waitrequest : std_logic; --                                     --          .waitrequest
	signal s_rmap_avalon_stimuli_mm_address     : std_logic_vector(11 downto 0); --          .address
	signal s_rmap_avalon_stimuli_mm_write       : std_logic; --                                     --          .write
	signal s_rmap_avalon_stimuli_mm_writedata   : std_logic_vector(31 downto 0); -- --          .writedata
	signal s_rmap_avalon_stimuli_mm_read        : std_logic; --                                     --          .read

begin

	clk100 <= not clk100 after 5 ns;    -- 100 MHz
	rst    <= '0' after 100 ns;

	rmap_avalon_stimuli_inst : entity work.rmap_avalon_stimuli
		generic map(
			g_ADDRESS_WIDTH => 12,
			g_DATA_WIDTH    => 32
		)
		port map(
			clk_i                   => clk100,
			rst_i                   => rst,
			avalon_mm_readdata_i    => s_rmap_avalon_stimuli_mm_readdata,
			avalon_mm_waitrequest_i => s_rmap_avalon_stimuli_mm_waitrequest,
			avalon_mm_address_o     => s_rmap_avalon_stimuli_mm_address,
			avalon_mm_write_o       => s_rmap_avalon_stimuli_mm_write,
			avalon_mm_writedata_o   => s_rmap_avalon_stimuli_mm_writedata,
			avalon_mm_read_o        => s_rmap_avalon_stimuli_mm_read
		);
		
		
	nrme_rmap_memory_nfee_area_top_inst : entity work.nrme_rmap_memory_nfee_area_top
		port map(
			reset_i                           => rst,
			clk_100_i                         => clk100,
			avs_0_rmap_address_i              => s_rmap_avalon_stimuli_mm_address,
			avs_0_rmap_write_i                => s_rmap_avalon_stimuli_mm_write,
			avs_0_rmap_read_i                 => s_rmap_avalon_stimuli_mm_read,
			avs_0_rmap_readdata_o             => s_rmap_avalon_stimuli_mm_readdata,
			avs_0_rmap_writedata_i            => s_rmap_avalon_stimuli_mm_writedata,
			avs_0_rmap_waitrequest_o          => s_rmap_avalon_stimuli_mm_waitrequest,
			avs_0_rmap_byteenable_i           => "1111",
			fee_0_rmap_wr_address_i           => (others => '0'),
			fee_0_rmap_write_i                => '0',
			fee_0_rmap_writedata_i            => (others => '0'),
			fee_0_rmap_rd_address_i           => (others => '0'),
			fee_0_rmap_read_i                 => '0',
			fee_0_rmap_wr_waitrequest_o       => open,
			fee_0_rmap_readdata_o             => open,
			fee_0_rmap_rd_waitrequest_o       => open,
			fee_1_rmap_wr_address_i           => (others => '0'),
			fee_1_rmap_write_i                => '0',
			fee_1_rmap_writedata_i            => (others => '0'),
			fee_1_rmap_rd_address_i           => (others => '0'),
			fee_1_rmap_read_i                 => '0',
			fee_1_rmap_wr_waitrequest_o       => open,
			fee_1_rmap_readdata_o             => open,
			fee_1_rmap_rd_waitrequest_o       => open,
			channel_hk_timecode_control_i     => (others => '0'),
			channel_hk_timecode_time_i        => (others => '0'),
			channel_hk_rmap_target_status_i   => (others => '0'),
			channel_hk_rmap_target_indicate_i => '0',
			channel_hk_spw_link_escape_err_i  => '0',
			channel_hk_spw_link_credit_err_i  => '0',
			channel_hk_spw_link_parity_err_i  => '0',
			channel_hk_spw_link_disconnect_i  => '0',
			channel_hk_spw_link_running_i     => '0',
			channel_hk_frame_counter_i        => (others => '0'),
			channel_hk_frame_number_i         => (others => '0')
		);
	
end architecture RTL;
