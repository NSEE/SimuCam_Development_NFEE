library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.rmap_target_pkg.all;
use work.rmap_mem_area_nfee_pkg.all;
use work.spwpkg.all;

entity rmap_testbench_top is
end entity rmap_testbench_top;

architecture RTL of rmap_testbench_top is

	-- 256 max quantity of buffer verification
	constant c_TESTBENCH_VERIFY_BUFFER_WIDTH  : natural := 8;
	-- 32-bit addressing:
	constant c_TESTBENCH_MEMORY_ADDRESS_WIDTH : natural := 32;
	-- 256 max quantity of read/write request
	constant c_TESTBENCH_DATA_LENGTH_WIDTH    : natural := 8;
	-- Byte access:
	constant c_TESTBENCH_MEMORY_ACCESS_WIDTH  : natural := 0;

	signal clk   : std_logic := '0';
	signal rst   : std_logic := '1';
	signal rst_n : std_logic;

	signal s_stimuli_spw_tx_flag    : t_rmap_target_spw_tx_flag;
	signal s_stimuli_spw_tx_control : t_rmap_target_spw_tx_control;

	signal s_rmap_spw_control : t_rmap_target_spw_control;
	signal s_rmap_spw_flag    : t_rmap_target_spw_flag;

	signal s_rmap_mem_control : t_rmap_target_mem_control;
	signal s_rmap_mem_flag    : t_rmap_target_mem_flag;

	signal s_rmap_mem_wr_byte_address : std_logic_vector((c_TESTBENCH_MEMORY_ADDRESS_WIDTH + c_TESTBENCH_MEMORY_ACCESS_WIDTH - 1) downto 0);
	signal s_rmap_mem_rd_byte_address : std_logic_vector((c_TESTBENCH_MEMORY_ADDRESS_WIDTH + c_TESTBENCH_MEMORY_ACCESS_WIDTH - 1) downto 0);

	signal s_rmap_mem_config_area : t_rmap_memory_config_area;
	signal s_rmap_mem_hk_area     : t_rmap_memory_hk_area;

	signal s_codec_fifo_control : t_rmap_target_spw_control;
	signal s_codec_fifo_flag    : t_rmap_target_spw_flag;

--	signal s_codec_tx_fifo_data    : std_logic_vector(8 downto 0);
--	signal s_codec_tx_fifo_q       : std_logic_vector(8 downto 0);
--	signal s_codec_tx_fifo_ready_n : std_logic;
--	signal s_codec_tx_fifo_valid_n : std_logic;
--	signal s_codec_rx_fifo_data    : std_logic_vector(8 downto 0);
--	signal s_codec_rx_fifo_q       : std_logic_vector(8 downto 0);
--	signal s_codec_rx_fifo_ready_n : std_logic;
--	signal s_codec_rx_fifo_valid_n : std_logic;

	signal s_spw_codec_stimuli_di : std_logic;
	signal s_spw_codec_stimuli_si : std_logic;
	signal s_spw_codec_stimuli_do : std_logic;
	signal s_spw_codec_stimuli_so : std_logic;

	signal s_spw_codec_rmap_di : std_logic;
	signal s_spw_codec_rmap_si : std_logic;
	signal s_spw_codec_rmap_do : std_logic;
	signal s_spw_codec_rmap_so : std_logic;
	
	signal s_spw_rxvalid : std_logic;
	signal s_spw_rxhalff : std_logic;
	signal s_spw_rxflag  : std_logic;
	signal s_spw_rxdata  : std_logic_vector(7 downto 0);
	signal s_spw_rxread  : std_logic;

begin
	-- 100 MHz clock
	clk   <= not clk after 5 ns;
	rst   <= '0' after 100 ns;
	rst_n <= not rst;

	rmap_stimuli_ent_inst : entity work.rmap_stimuli_ent
		port map(
			clk            => clk,
			rst            => rst,
			spw_tx_flag    => s_stimuli_spw_tx_flag,
			spw_tx_control => s_stimuli_spw_tx_control
		);

	rmap_target_top_inst : entity work.rmap_target_top
		generic map(
			g_VERIFY_BUFFER_WIDTH  => c_TESTBENCH_VERIFY_BUFFER_WIDTH,
			g_MEMORY_ADDRESS_WIDTH => c_TESTBENCH_MEMORY_ADDRESS_WIDTH,
			g_DATA_LENGTH_WIDTH    => c_TESTBENCH_DATA_LENGTH_WIDTH,
			g_MEMORY_ACCESS_WIDTH  => c_TESTBENCH_MEMORY_ACCESS_WIDTH
		)
		port map(
			clk_i                 => clk,
			reset_n_i             => rst_n,
			spw_flag_i            => s_rmap_spw_flag,
			mem_flag_i            => s_rmap_mem_flag,
			spw_control_o         => s_rmap_spw_control,
			mem_control_o         => s_rmap_mem_control,
			mem_wr_byte_address_o => s_rmap_mem_wr_byte_address,
			mem_rd_byte_address_o => s_rmap_mem_rd_byte_address
		);

	rmap_mem_area_nfee_read_inst : entity work.rmap_mem_area_nfee_read
		port map(
			clk_i                   => clk,
			rst_i                   => rst,
			rmap_read_i             => s_rmap_mem_control.read.read,
			rmap_readaddr_i         => s_rmap_mem_rd_byte_address,
			rmap_config_registers_i => s_rmap_mem_config_area,
			rmap_hk_registers_i     => s_rmap_mem_hk_area,
			rmap_memerror_o         => s_rmap_mem_flag.read.error,
			rmap_datavalid_o        => s_rmap_mem_flag.read.valid,
			rmap_readdata_o         => s_rmap_mem_flag.read.data
		);

	rmap_mem_area_nfee_write_inst : entity work.rmap_mem_area_nfee_write
		port map(
			clk_i                   => clk,
			rst_i                   => rst,
			rmap_write_i            => s_rmap_mem_control.write.write,
			rmap_writeaddr_i        => s_rmap_mem_wr_byte_address,
			rmap_writedata_i        => s_rmap_mem_control.write.data,
			rmap_memerror_o         => s_rmap_mem_flag.write.error,
			rmap_memready_o         => s_rmap_mem_flag.write.ready,
			rmap_config_registers_o => s_rmap_mem_config_area,
			rmap_hk_registers_o     => s_rmap_mem_hk_area
		);

--	spw_rx_fifo_inst : entity work.spw_fifo
--		port map(
--			aclr  => rst,
--			clock => clk,
--			data  => s_codec_rx_fifo_data,
--			rdreq => s_codec_fifo_control.receiver.read,
--			sclr  => '0',
--			wrreq => s_stimuli_spw_tx_control.write,
--			empty => s_codec_rx_fifo_valid_n,
--			full  => s_codec_rx_fifo_ready_n,
--			q     => s_codec_rx_fifo_q
--		);
--
--	s_codec_rx_fifo_data(8)          <= s_stimuli_spw_tx_control.flag;
--	s_codec_rx_fifo_data(7 downto 0) <= s_stimuli_spw_tx_control.data;
--	s_codec_fifo_flag.receiver.valid <= not s_codec_rx_fifo_valid_n;
--	s_stimuli_spw_tx_flag.ready      <= not s_codec_rx_fifo_ready_n;
--	s_codec_fifo_flag.receiver.flag  <= s_codec_rx_fifo_q(8);
--	s_codec_fifo_flag.receiver.data  <= s_codec_rx_fifo_q(7 downto 0);
--
--	spw_tx_fifo_inst : entity work.spw_fifo
--		port map(
--			aclr  => rst,
--			clock => clk,
--			data  => s_codec_tx_fifo_data,
--			rdreq => '0',
--			sclr  => '0',
--			wrreq => s_codec_fifo_control.transmitter.write,
--			empty => s_codec_tx_fifo_valid_n,
--			full  => s_codec_tx_fifo_ready_n,
--			q     => open
--		);
--
--	s_codec_tx_fifo_data(8)             <= s_codec_fifo_control.transmitter.flag;
--	s_codec_tx_fifo_data(7 downto 0)    <= s_codec_fifo_control.transmitter.data;
--	s_codec_fifo_flag.transmitter.ready <= not s_codec_tx_fifo_ready_n;

	-- SpaceWire Light Codec Component 
	spw_stimuli_spwstream_inst : entity work.spwstream
		generic map(
			sysfreq         => 100000000.0,
			txclkfreq       => 0.0,
			rximpl          => impl_generic,
			rxchunk         => 1,
			tximpl          => impl_generic,
			rxfifosize_bits => 11,
			txfifosize_bits => 11
		)
		port map(
			clk        => clk,
			rxclk      => clk,
			txclk      => clk,
			rst        => rst,
			autostart  => '1',
			linkstart  => '1',
			linkdis    => '0',
			txdivcnt   => x"01",
			tick_in    => '0',
			ctrl_in    => "00",
			time_in    => "000000",
			txwrite    => s_stimuli_spw_tx_control.write,
			txflag     => s_stimuli_spw_tx_control.flag,
			txdata     => s_stimuli_spw_tx_control.data,
			txrdy      => s_stimuli_spw_tx_flag.ready,
			txhalff    => open,
			tick_out   => open,
			ctrl_out   => open,
			time_out   => open,
			rxvalid    => s_spw_rxvalid,
			rxhalff    => s_spw_rxhalff,
			rxflag     => s_spw_rxflag,
			rxdata     => s_spw_rxdata,
			rxread     => s_spw_rxread,
			started    => open,
			connecting => open,
			running    => open,
			errdisc    => open,
			errpar     => open,
			erresc     => open,
			errcred    => open,
			spw_di     => s_spw_codec_stimuli_di,
			spw_si     => s_spw_codec_stimuli_si,
			spw_do     => s_spw_codec_stimuli_do,
			spw_so     => s_spw_codec_stimuli_so
		);

	-- SpaceWire Light Codec Component 
	spw_rmap_spwstream_inst : entity work.spwstream
		generic map(
			sysfreq         => 100000000.0,
			txclkfreq       => 0.0,
			rximpl          => impl_generic,
			rxchunk         => 1,
			tximpl          => impl_generic,
			rxfifosize_bits => 11,
			txfifosize_bits => 11
		)
		port map(
			clk        => clk,
			rxclk      => clk,
			txclk      => clk,
			rst        => rst,
			autostart  => '1',
			linkstart  => '0',
			linkdis    => '0',
			txdivcnt   => x"01",
			tick_in    => '0',
			ctrl_in    => "00",
			time_in    => "000000",
			txwrite    => s_rmap_spw_control.transmitter.write,
			txflag     => s_rmap_spw_control.transmitter.flag,
			txdata     => s_rmap_spw_control.transmitter.data,
			txrdy      => s_rmap_spw_flag.transmitter.ready,
			txhalff    => open,
			tick_out   => open,
			ctrl_out   => open,
			time_out   => open,
			rxvalid    => s_rmap_spw_flag.receiver.valid,
			rxhalff    => open,
			rxflag     => s_rmap_spw_flag.receiver.flag,
			rxdata     => s_rmap_spw_flag.receiver.data,
			rxread     => s_rmap_spw_control.receiver.read,
			started    => open,
			connecting => open,
			running    => open,
			errdisc    => open,
			errpar     => open,
			erresc     => open,
			errcred    => open,
			spw_di     => s_spw_codec_rmap_di,
			spw_si     => s_spw_codec_rmap_si,
			spw_do     => s_spw_codec_rmap_do,
			spw_so     => s_spw_codec_rmap_so
		);

	s_spw_codec_rmap_di    <= s_spw_codec_stimuli_do;
	s_spw_codec_rmap_si    <= s_spw_codec_stimuli_so;
	s_spw_codec_stimuli_di <= s_spw_codec_rmap_do;
	s_spw_codec_stimuli_si <= s_spw_codec_rmap_so;
	
	p_codec_dummy_read : process(clk, rst) is
	begin
		if (rst = '1') then
			s_spw_rxread <= '0';
		elsif rising_edge(clk) then
			s_spw_rxread <= '0';
			if (s_spw_rxvalid = '1') then
				s_spw_rxread <= '1';
			end if;
		end if;
	end process p_codec_dummy_read;

end architecture RTL;
