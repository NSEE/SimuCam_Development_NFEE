library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.avalon_mm_windowing_pkg.all;
use work.avalon_mm_spacewire_pkg.all;
use work.avalon_mm_spacewire_registers_pkg.all;
use work.spw_codec_pkg.all;

entity comm_v1_01_top is
	port(
		clk_i : in std_logic;
		rst_i : in std_logic
	);
end entity comm_v1_01_top;

architecture RTL of comm_v1_01_top is

	alias clock is clk_i;
	alias reset is rst_i;

	-- constants

	-- signals

	-- windowing avalon mm read signals
	signal s_avalon_mm_spacewire_read_in  : t_avalon_mm_spacewire_read_in;
	signal s_avalon_mm_spacewire_read_out : t_avalon_mm_spacewire_read_out;

	-- windowing avalon mm write signals
	signal s_avalon_mm_spacewire_write_in  : t_avalon_mm_spacewire_write_in;
	signal s_avalon_mm_spacewire_write_out : t_avalon_mm_spacewire_write_out;

	-- windowing avalon mm registers signals
	signal s_spacewire_write_registers : t_windowing_write_registers;
	signal s_spacewire_read_registers  : t_windowing_read_registers;

	-- rigth avalon mm windowing write signals
	signal s_R_avalon_mm_windowing_write_in  : t_avalon_mm_windowing_write_in;
	signal s_R_mask_enable                   : std_logic;
	signal s_R_avalon_mm_windowing_write_out : t_avalon_mm_windowing_write_out;
	signal s_R_window_data                   : std_logic_vector(63 downto 0);

	-- rigth windowing buffer signals
	signal s_R_window_data_write   : std_logic;
	signal s_R_window_mask_write   : std_logic;
	signal s_R_window_data_in      : std_logic_vector(63 downto 0);
	signal s_R_window_data_read    : std_logic;
	signal s_R_window_mask_read    : std_logic;
	signal s_R_window_data_out     : std_logic_vector(63 downto 0);
	signal s_R_window_mask_out     : std_logic_vector(63 downto 0);
	signal s_R_window_data_ready   : std_logic;
	signal s_R_window_mask_ready   : std_logic;
	signal s_R_window_buffer_empty : std_logic;

	-- left avalon mm windowing signals
	signal s_L_avalon_mm_windowing_write_in  : t_avalon_mm_windowing_write_in;
	signal s_L_mask_enable                   : std_logic;
	signal s_L_avalon_mm_windowing_write_out : t_avalon_mm_windowing_write_out;
	signal s_L_window_data                   : std_logic_vector(63 downto 0);

	-- left windowing buffer signals
	signal s_L_window_data_write   : std_logic;
	signal s_L_window_mask_write   : std_logic;
	signal s_L_window_data_in      : std_logic_vector(63 downto 0);
	signal s_L_window_data_read    : std_logic;
	signal s_L_window_mask_read    : std_logic;
	signal s_L_window_data_out     : std_logic_vector(63 downto 0);
	signal s_L_window_mask_out     : std_logic_vector(63 downto 0);
	signal s_L_window_data_ready   : std_logic;
	signal s_L_window_mask_ready   : std_logic;
	signal s_L_window_buffer_empty : std_logic;

	-- data controller signals
	signal s_mask_enable         : std_logic;
	signal s_window_data_R       : std_logic_vector(63 downto 0);
	signal s_window_mask_R       : std_logic_vector(63 downto 0);
	signal s_window_data_R_ready : std_logic;
	signal s_window_mask_R_ready : std_logic;
	signal s_window_data_L       : std_logic_vector(63 downto 0);
	signal s_window_mask_L       : std_logic_vector(63 downto 0);
	signal s_window_data_L_ready : std_logic;
	signal s_window_mask_L_ready : std_logic;
	signal s_spw_txrdy           : std_logic;
	signal s_window_data_R_read  : std_logic;
	signal s_window_mask_R_read  : std_logic;
	signal s_window_data_L_read  : std_logic;
	signal s_window_mask_L_read  : std_logic;
	signal s_spw_txwrite         : std_logic;
	signal s_spw_txflag          : std_logic;
	signal s_spw_txdata          : std_logic_vector(7 downto 0);

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

begin

	-- windowing avalon mm read instantiation
	avalon_mm_spacewire_read_ent_inst : entity work.avalon_mm_spacewire_read_ent
		port map(
			clk_i                       => clock,
			rst_i                       => reset,
			avalon_mm_spacewire_i       => s_avalon_mm_spacewire_read_in,
			avalon_mm_spacewire_o       => s_avalon_mm_spacewire_read_out,
			spacewire_write_registers_i => s_spacewire_write_registers,
			spacewire_read_registers_i  => s_spacewire_read_registers
		);

	-- windowing avalon mm write instantiation
	avalon_mm_spacewire_write_ent_inst : entity work.avalon_mm_spacewire_write_ent
		port map(
			clk_i                       => clock,
			rst_i                       => reset,
			avalon_mm_spacewire_i       => s_avalon_mm_spacewire_write_in,
			avalon_mm_spacewire_o       => s_avalon_mm_spacewire_write_out,
			spacewire_write_registers_o => s_spacewire_write_registers
		);

	-- rigth avalon mm windowing write instantiation
	rigth_avalon_mm_windowing_write_ent_inst : entity work.avalon_mm_windowing_write_ent
		port map(
			clk_i                 => clock,
			rst_i                 => reset,
			avalon_mm_windowing_i => s_R_avalon_mm_windowing_write_in,
			mask_enable_i         => s_R_mask_enable,
			avalon_mm_windowing_o => s_R_avalon_mm_windowing_write_out,
			window_data_write_o   => s_R_window_data_write,
			window_mask_write_o   => s_R_window_mask_write,
			window_data_o         => s_R_window_data
		);

	-- rigth windowing buffer instantiation
	rigth_windowing_buffer_ent_inst : entity work.windowing_buffer_ent
		port map(
			clk_i                 => clock,
			rst_i                 => reset,
			window_data_write_i   => s_R_window_data_write,
			window_mask_write_i   => s_R_window_mask_write,
			window_data_i         => s_R_window_data_in,
			window_data_read_i    => s_R_window_data_read,
			window_mask_read_i    => s_R_window_mask_read,
			window_data_o         => s_R_window_data_out,
			window_mask_o         => s_R_window_mask_out,
			window_data_ready_o   => s_R_window_data_ready,
			window_mask_ready_o   => s_R_window_mask_ready,
			window_buffer_empty_o => s_R_window_buffer_empty
		);

	-- left avalon mm windowing write instantiation
	left_avalon_mm_windowing_write_ent_inst : entity work.avalon_mm_windowing_write_ent
		port map(
			clk_i                 => clock,
			rst_i                 => reset,
			avalon_mm_windowing_i => s_L_avalon_mm_windowing_write_in,
			mask_enable_i         => s_L_mask_enable,
			avalon_mm_windowing_o => s_L_avalon_mm_windowing_write_out,
			window_data_write_o   => s_L_window_data_write,
			window_mask_write_o   => s_L_window_mask_write,
			window_data_o         => s_L_window_data
		);

	-- left windowing buffer instantiation
	left_windowing_buffer_ent_inst : entity work.windowing_buffer_ent
		port map(
			clk_i                 => clock,
			rst_i                 => reset,
			window_data_write_i   => s_L_window_data_write,
			window_mask_write_i   => s_L_window_mask_write,
			window_data_i         => s_L_window_data_in,
			window_data_read_i    => s_L_window_data_read,
			window_mask_read_i    => s_L_window_mask_read,
			window_data_o         => s_L_window_data_out,
			window_mask_o         => s_L_window_mask_out,
			window_data_ready_o   => s_L_window_data_ready,
			window_mask_ready_o   => s_L_window_mask_ready,
			window_buffer_empty_o => s_L_window_buffer_empty
		);

	-- data controller instantiation
	data_controller_ent_inst : entity work.data_controller_ent
		port map(
			clk_i                 => clock,
			rst_i                 => reset,
			mask_enable_i         => s_mask_enable,
			window_data_R_i       => s_window_data_R,
			window_mask_R_i       => s_window_mask_R,
			window_data_R_ready_i => s_window_data_R_ready,
			window_mask_R_ready_i => s_window_mask_R_ready,
			window_data_L_i       => s_window_data_L,
			window_mask_L_i       => s_window_mask_L,
			window_data_L_ready_i => s_window_data_L_ready,
			window_mask_L_ready_i => s_window_mask_L_ready,
			spw_txrdy_i           => s_spw_txrdy,
			window_data_R_read_o  => s_window_data_R_read,
			window_mask_R_read_o  => s_window_mask_R_read,
			window_data_L_read_o  => s_window_data_L_read,
			window_mask_L_read_o  => s_window_mask_L_read,
			spw_txwrite_o         => s_spw_txwrite,
			spw_txflag_o          => s_spw_txflag,
			spw_txdata_o          => s_spw_txdata
		);

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

end architecture RTL;
