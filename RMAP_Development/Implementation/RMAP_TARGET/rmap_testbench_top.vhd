library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.rmap_target_pkg.all;

entity rmap_testbench_top is
end entity rmap_testbench_top;

architecture RTL of rmap_testbench_top is

	constant c_TESTBENCH_VERIFY_BUFFER_WIDTH  : natural := 8;
	constant c_TESTBENCH_MEMORY_ADDRESS_WIDTH : natural := 8;
	constant c_TESTBENCH_DATA_LENGTH_WIDTH    : natural := 8;
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

	type t_rmap_memory_type is array (0 to 255) of std_logic_vector(7 downto 0);
	signal s_rmap_write_memory         : t_rmap_memory_type := (others => x"00");
	signal s_rmap_write_memory_data    : std_logic_vector(((8 * (2 ** c_TESTBENCH_MEMORY_ACCESS_WIDTH)) - 1) downto 0);
	signal s_rmap_write_memory_address : std_logic_vector((c_TESTBENCH_MEMORY_ADDRESS_WIDTH - 1) downto 0);
	signal s_rmap_read_memory          : t_rmap_memory_type := (others => x"00");
	signal s_rmap_read_memory_data     : std_logic_vector(((8 * (2 ** c_TESTBENCH_MEMORY_ACCESS_WIDTH)) - 1) downto 0);
	signal s_rmap_read_memory_address  : std_logic_vector((c_TESTBENCH_MEMORY_ADDRESS_WIDTH - 1) downto 0);

	signal s_codec_fifo_control : t_rmap_target_spw_control;
	signal s_codec_fifo_flag    : t_rmap_target_spw_flag;

	signal s_codec_tx_fifo_data    : std_logic_vector(8 downto 0);
	signal s_codec_tx_fifo_q       : std_logic_vector(8 downto 0);
	signal s_codec_tx_fifo_ready_n : std_logic;
	signal s_codec_tx_fifo_valid_n : std_logic;
	signal s_codec_rx_fifo_data    : std_logic_vector(8 downto 0);
	signal s_codec_rx_fifo_q       : std_logic_vector(8 downto 0);
	signal s_codec_rx_fifo_ready_n : std_logic;
	signal s_codec_rx_fifo_valid_n : std_logic;

begin

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

	rmap_target_spw_rx_ent_inst : entity work.rmap_target_spw_rx_ent
		port map(
			clk_i         => clk,
			reset_n_i     => rst_n,
			spw_control_i => s_rmap_spw_control.receiver,
			codec_valid_i => s_codec_fifo_flag.receiver.valid,
			codec_flag_i  => s_codec_fifo_flag.receiver.flag,
			codec_data_i  => s_codec_fifo_flag.receiver.data,
			spw_flag_o    => s_rmap_spw_flag.receiver,
			codec_read_o  => s_codec_fifo_control.receiver.read
		);

	rmap_target_spw_tx_ent_inst : entity work.rmap_target_spw_tx_ent
		port map(
			clk_i         => clk,
			reset_n_i     => rst_n,
			spw_control_i => s_rmap_spw_control.transmitter,
			codec_ready_i => s_codec_fifo_flag.transmitter.ready,
			spw_flag_o    => s_rmap_spw_flag.transmitter,
			codec_write_o => s_codec_fifo_control.transmitter.write,
			codec_flag_o  => s_codec_fifo_control.transmitter.flag,
			codec_data_o  => s_codec_fifo_control.transmitter.data
		);

	s_rmap_read_memory <= s_rmap_write_memory;

	rmap_target_mem_rd_ent_inst : entity work.rmap_target_mem_rd_ent
		generic map(
			g_MEMORY_ADDRESS_WIDTH => c_TESTBENCH_MEMORY_ADDRESS_WIDTH,
			g_MEMORY_ACCESS_WIDTH  => c_TESTBENCH_MEMORY_ACCESS_WIDTH
		)
		port map(
			clk_i              => clk,
			reset_n_i          => rst_n,
			mem_control_i      => s_rmap_mem_control.read,
			memory_data_i      => s_rmap_read_memory_data,
			mem_byte_address_i => s_rmap_mem_rd_byte_address,
			mem_flag_o         => s_rmap_mem_flag.read,
			memory_address_o   => s_rmap_read_memory_address
		);

	s_rmap_read_memory_data <= s_rmap_read_memory(to_integer(unsigned(s_rmap_read_memory_address)));

	rmap_target_mem_wr_ent_inst : entity work.rmap_target_mem_wr_ent
		generic map(
			g_MEMORY_ADDRESS_WIDTH => c_TESTBENCH_MEMORY_ADDRESS_WIDTH,
			g_MEMORY_ACCESS_WIDTH  => c_TESTBENCH_MEMORY_ACCESS_WIDTH
		)
		port map(
			clk_i              => clk,
			reset_n_i          => rst_n,
			mem_control_i      => s_rmap_mem_control.write,
			mem_byte_address_i => s_rmap_mem_wr_byte_address,
			mem_flag_o         => s_rmap_mem_flag.write,
			memory_address_o   => s_rmap_write_memory_address,
			memory_data_o      => s_rmap_write_memory_data
		);

	s_rmap_write_memory(to_integer(unsigned(s_rmap_write_memory_address))) <= s_rmap_write_memory_data;

	spw_rx_fifo_inst : entity work.spw_fifo
		port map(
			aclr  => rst,
			clock => clk,
			data  => s_codec_rx_fifo_data,
			rdreq => s_codec_fifo_control.receiver.read,
			sclr  => '0',
			wrreq => s_stimuli_spw_tx_control.write,
			empty => s_codec_rx_fifo_valid_n,
			full  => s_codec_rx_fifo_ready_n,
			q     => s_codec_rx_fifo_q
		);

	s_codec_rx_fifo_data(8)          <= s_stimuli_spw_tx_control.flag;
	s_codec_rx_fifo_data(7 downto 0) <= s_stimuli_spw_tx_control.data;
	s_codec_fifo_flag.receiver.valid <= not s_codec_rx_fifo_valid_n;
	s_stimuli_spw_tx_flag.ready      <= not s_codec_rx_fifo_ready_n;
	s_codec_fifo_flag.receiver.flag  <= s_codec_rx_fifo_q(8);
	s_codec_fifo_flag.receiver.data  <= s_codec_rx_fifo_q(7 downto 0);

	spw_tx_fifo_inst : entity work.spw_fifo
		port map(
			aclr  => rst,
			clock => clk,
			data  => s_codec_tx_fifo_data,
			rdreq => '0',
			sclr  => '0',
			wrreq => s_codec_fifo_control.transmitter.write,
			empty => s_codec_tx_fifo_valid_n,
			full  => s_codec_tx_fifo_ready_n,
			q     => open
		);

	s_codec_tx_fifo_data(8)             <= s_codec_fifo_control.transmitter.flag;
	s_codec_tx_fifo_data(7 downto 0)    <= s_codec_fifo_control.transmitter.data;
	s_codec_fifo_flag.transmitter.ready <= not s_codec_tx_fifo_ready_n;

end architecture RTL;
