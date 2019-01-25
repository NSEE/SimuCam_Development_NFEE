library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.data_packet_pkg.all;

entity data_packet_top is
	port(
		-- Global input signals
		--! Local clock used by the RMAP Codec
		clk_i                  : in  std_logic; --! Local rmap clock
		reset_i                : in  std_logic; --! Reset = '1': reset active; Reset = '0': no reset

		data_packet_start_i    : in  std_logic;
		data_packet_config_i   : in  t_data_packet_configdata;
		spw_flag_i             : in  t_data_packet_spw_flag;
		hkdata_i               : in  t_data_packet_hkdata;
		imgdata_flag_i         : in  t_data_packet_imgdata_flag;
		-- global output signals

		data_packet_finished_o : out std_logic;
		spw_control_o          : out t_data_packet_spw_control;
		imgdata_control_o      : out t_data_packet_imgdata_control
		-- data bus(es)
	);
end entity data_packet_top;

architecture RTL of data_packet_top is

	signal s_data_packet_control : t_data_packet_control;
	signal s_data_packet_flags   : t_data_packet_flags;

	signal s_data_packet_headerdata : t_data_packet_headerdata;

	signal s_data_packet_spw_header_tx_control       : t_data_packet_spw_tx_control;
	signal s_data_packet_spw_housekeeping_tx_control : t_data_packet_spw_tx_control;
	signal s_data_packet_spw_image_tx_control        : t_data_packet_spw_tx_control;

	signal s_data_packet_control_busy : std_logic;

begin

	data_packet_control_ent_inst : entity work.data_packet_control_ent
		port map(
			clk_i                       => clk_i,
			reset_i                     => reset_i,
			control_i.send_data_package => data_packet_start_i,
			configdata_i                => data_packet_config_i,
			packetflags_i               => s_data_packet_flags,
			flags_o.control_busy        => s_data_packet_control_busy,
			flags_o.control_finished    => data_packet_finished_o,
			packetcontrol_o             => s_data_packet_control,
			headerdata_o                => s_data_packet_headerdata
		);

	user_packet_header_ent_inst : entity work.user_packet_header_ent
		port map(
			clk_i         => clk_i,
			reset_i       => reset_i,
			control_i     => s_data_packet_control.header_unit,
			headerdata_i  => s_data_packet_headerdata,
			spw_flag_i    => spw_flag_i.transmitter,
			flags_o       => s_data_packet_flags.header_unit,
			spw_control_o => s_data_packet_spw_header_tx_control
		);

	data_packet_houkeeping_ent_inst : entity work.data_packet_houkeeping_ent
		port map(
			clk_i         => clk_i,
			reset_i       => reset_i,
			control_i     => s_data_packet_control.housekeeping_unit,
			hkdata_i      => hkdata_i,
			spw_flag_i    => spw_flag_i.transmitter,
			flags_o       => s_data_packet_flags.housekeeping_unit,
			spw_control_o => s_data_packet_spw_housekeeping_tx_control
		);

	data_packet_image_ent_inst : entity work.data_packet_image_ent
		port map(
			clk_i                     => clk_i,
			reset_i                   => reset_i,
			control_i                 => s_data_packet_control.image_unit,
			headerdata_i.length_field => s_data_packet_headerdata.length_field,
			imgdata_flag_i            => imgdata_flag_i,
			spw_flag_i                => spw_flag_i.transmitter,
			flags_o                   => s_data_packet_flags.image_unit,
			imgdata_control_o         => imgdata_control_o,
			spw_control_o             => s_data_packet_spw_image_tx_control
		);

	-- signals assingment

	-- spw control signals
	spw_control_o.transmitter.flag  <= (s_data_packet_spw_header_tx_control.flag) or (s_data_packet_spw_housekeeping_tx_control.flag) or (s_data_packet_spw_image_tx_control.flag);
	spw_control_o.transmitter.data  <= (s_data_packet_spw_header_tx_control.data) or (s_data_packet_spw_housekeeping_tx_control.data) or (s_data_packet_spw_image_tx_control.data);
	spw_control_o.transmitter.write <= (s_data_packet_spw_header_tx_control.write) or (s_data_packet_spw_housekeeping_tx_control.write) or (s_data_packet_spw_image_tx_control.write);

end architecture RTL;
