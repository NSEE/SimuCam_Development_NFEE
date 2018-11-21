library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.spw_codec_pkg.all;
use work.rmap_target_pkg.all;

entity comm_v1_1_top is
	port(
		clk_i : in std_logic;
		rst_i : in std_logic
	);
end entity comm_v1_1_top;

architecture RTL of comm_v1_1_top is

	alias clock is clk_i;
	alias reset is rst_i;

	-- constants

	-- rmap codec constants
	constant c_RMAP_VERIFY_BUFFER_WIDTH  : natural := 8;
	constant c_RMAP_MEMORY_ADDRESS_WIDTH : natural := 11;
	constant c_RMAP_DATA_LENGTH_WIDTH    : natural := 8;
	constant c_RMAP_MEMORY_ACCESS_WIDTH  : natural := 0;

	-- signals

	-- spw codec signals
	signal s_spw_codec_link_command    : t_spw_codec_link_command;
	signal s_spw_codec_ds_encoding_rx  : t_spw_codec_ds_encoding_rx;
	signal s_spw_codec_timecode_tx     : t_spw_codec_timecode_tx;
	signal s_spw_codec_data_rx_command : t_spw_codec_data_rx_command;
	signal s_spw_codec_data_tx_command : t_spw_codec_data_tx_command;
	signal s_spw_codec_link_status     : t_spw_codec_link_status;
	signal s_spw_codec_ds_encoding_tx  : t_spw_codec_ds_encoding_tx;
	signal s_spw_codec_link_error      : t_spw_codec_link_error;
	signal s_spw_codec_timecode_rx     : t_spw_codec_timecode_rx;
	signal s_spw_codec_data_rx_status  : t_spw_codec_data_rx_status;
	signal s_spw_codec_data_tx_status  : t_spw_codec_data_tx_status;

	-- rmap codec signals
	signal s_rmap_spw_flag            : t_rmap_target_spw_flag;
	signal s_rmap_mem_flag            : t_rmap_target_mem_flag;
	signal s_rmap_spw_control         : t_rmap_target_spw_control;
	signal s_rmap_mem_control         : t_rmap_target_mem_control;
	signal s_rmap_mem_wr_byte_address : std_logic_vector((c_RMAP_MEMORY_ADDRESS_WIDTH + c_RMAP_MEMORY_ACCESS_WIDTH - 1) downto 0);
	signal s_rmap_mem_rd_byte_address : std_logic_vector((c_RMAP_MEMORY_ADDRESS_WIDTH + c_RMAP_MEMORY_ACCESS_WIDTH - 1) downto 0);

begin

	-- spw codec instantiation
	spw_codec_ent_inst : entity work.spw_codec_ent
		port map(
			clk_200                     => clock,
			rst                         => reset,
			spw_codec_link_command_i    => s_spw_codec_link_command,
			spw_codec_ds_encoding_rx_i  => s_spw_codec_ds_encoding_rx,
			spw_codec_timecode_tx_i     => s_spw_codec_timecode_tx,
			spw_codec_data_rx_command_i => s_spw_codec_data_rx_command,
			spw_codec_data_tx_command_i => s_spw_codec_data_tx_command,
			spw_codec_link_status_o     => s_spw_codec_link_status,
			spw_codec_ds_encoding_tx_o  => s_spw_codec_ds_encoding_tx,
			spw_codec_link_error_o      => s_spw_codec_link_error,
			spw_codec_timecode_rx_o     => s_spw_codec_timecode_rx,
			spw_codec_data_rx_status_o  => s_spw_codec_data_rx_status,
			spw_codec_data_tx_status_o  => s_spw_codec_data_tx_status
		);

	-- spw mux/demux instantiation
	spw_mux_ent_inst : entity work.spw_mux_ent
		port map(
			clk_i                          => clock,
			rst_i                          => reset,
			spw_codec_rx_status_i          => s_spw_codec_data_rx_status,
			spw_codec_tx_status_i          => s_spw_codec_data_tx_status,
			spw_mux_rx_0_command_i.rxread  => s_rmap_spw_control.receiver.read,
			spw_mux_tx_0_command_i.txwrite => s_rmap_spw_control.transmitter.write,
			spw_mux_tx_0_command_i.txflag  => s_rmap_spw_control.transmitter.flag,
			spw_mux_tx_0_command_i.txdata  => s_rmap_spw_control.transmitter.data,
			spw_codec_rx_command_o         => s_spw_codec_data_rx_command,
			spw_codec_tx_command_o         => s_spw_codec_data_tx_command,
			spw_mux_rx_0_status_o.rxvalid  => s_rmap_spw_flag.receiver.valid,
			spw_mux_rx_0_status_o.rxhalff  => open,
			spw_mux_rx_0_status_o.rxflag   => s_rmap_spw_flag.receiver.flag,
			spw_mux_rx_0_status_o.rxdata   => s_rmap_spw_flag.receiver.data,
			spw_mux_tx_0_status_o.txrdy    => s_rmap_spw_flag.transmitter.ready,
			spw_mux_tx_0_status_o.txhalff  => open
		);

	-- rmap codec instantiation
	rmap_target_top_inst : entity work.rmap_target_top
		generic map(
			g_VERIFY_BUFFER_WIDTH  => c_RMAP_VERIFY_BUFFER_WIDTH,
			g_MEMORY_ADDRESS_WIDTH => c_RMAP_MEMORY_ADDRESS_WIDTH,
			g_DATA_LENGTH_WIDTH    => c_RMAP_DATA_LENGTH_WIDTH,
			g_MEMORY_ACCESS_WIDTH  => c_RMAP_MEMORY_ACCESS_WIDTH
		)
		port map(
			clk_i                 => clock,
			reset_i               => reset,
			spw_flag_i            => s_rmap_spw_flag,
			mem_flag_i            => s_rmap_mem_flag,
			spw_control_o         => s_rmap_spw_control,
			mem_control_o         => s_rmap_mem_control,
			mem_wr_byte_address_o => s_rmap_mem_wr_byte_address,
			mem_rd_byte_address_o => s_rmap_mem_rd_byte_address
		);
	s_rmap_spw_flag.receiver.error    <= '0';
	s_rmap_spw_flag.transmitter.error <= '0';

	-- rmap memory area instantiation
	rmap_memory_area_ent_inst : entity work.rmap_memory_area_ent
		generic map(
			g_MEMORY_ADDRESS_WIDTH => c_RMAP_MEMORY_ADDRESS_WIDTH,
			g_MEMORY_ACCESS_WIDTH  => c_RMAP_MEMORY_ACCESS_WIDTH
		)
		port map(
			clk_i                      => clock,
			rst_i                      => reset,
			rmap_mem_control_i         => s_rmap_mem_control,
			rmap_mem_wr_byte_address_i => s_rmap_mem_wr_byte_address,
			rmap_mem_rd_byte_address_i => s_rmap_mem_rd_byte_address,
			rmap_mem_flag_o            => s_rmap_mem_flag
		);

end architecture RTL;
