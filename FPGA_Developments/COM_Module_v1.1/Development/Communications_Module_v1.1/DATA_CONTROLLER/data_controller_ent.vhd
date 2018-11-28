library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.data_controller_pkg.all;
use work.data_packet_pkg.all;

entity data_controller_ent is
	port(
		clk_i                  : in  std_logic;
		rst_i                  : in  std_logic;
		sync_signal_i          : in  std_logic;
		data_fifo_wr_status_i  : in  t_data_fifo_wr_status;
		data_packet_finished_i : in  std_logic;
		imgdata_control_i      : in  t_data_packet_imgdata_control;
		data_fifo_wr_control_o : out t_data_fifo_wr_control;
		data_fifo_wr_data_o    : out t_data_fifo_wr_data;
		data_packet_start_o    : out std_logic;
		data_packet_config_o   : out t_data_packet_configdata;
		hkdata_o               : out t_data_packet_hkdata;
		imgdata_flag_o         : out t_data_packet_imgdata_flag
	);
end entity data_controller_ent;

architecture RTL of data_controller_ent is

	type t_data_controller_fsm is (
		IDLE,
		TIMECODE,
		HOUSEKEEPING_HEADER,
		HOUSEKEEPING_DATA,
		IMAGE_HEADER,
		IMAGE_DATA,
		OVERSCAN_HEADER,
		OVERSCAN_DATA
	);

	signal s_data_controller_state : t_data_controller_fsm;

begin

	-- maquina de estado:
	-- -- colocar cabeçalho do data packet no data buffer
	-- -- colocar n bytes de windowed pixel no data buffer
	-- -- prencher final do pacote no data buffer

	-- TC; HK; DATA_PACKET; OVERSCAN 

	p_data_controller : process(clk_i, rst_i) is
	begin
		if (rst_i = '1') then

		elsif rising_edge(clk_i) then

			case (s_data_controller_state) is

				when IDLE =>
					-- if sync = '1'
					-- -- goto TIMECODE
					-- else
					-- -- goto IDLE
					-- end if
					s_data_controller_state <= IDLE;
					if (sync_signal_i = '1') then
						s_data_controller_state <= TIMECODE;
					end if;

				when TIMECODE =>
					-- update timecode
					-- send timecode
					-- goto HOUSEKEEPING_HEADER
					s_data_controller_state <= HOUSEKEEPING_HEADER;

				when HOUSEKEEPING_HEADER =>
					-- start housekeeping header process
					-- if (housekeeping_header_finished = '1')
					-- -- goto HOUSEKEEPING_DATA
					-- else
					-- -- goto HOUSEKEEPING_HEADER
					-- end if
					s_data_controller_state <= HOUSEKEEPING_HEADER;

				when HOUSEKEEPING_DATA =>
					-- read housekeeping from RMAP memory area - address nh : nh_inicial -> nh_final
					-- update nh
					-- if (address = nh_final)
					-- -- goto IMAGE_HEADER
					-- else
					-- -- goto HOUSEKEEPING_DATA
					-- end if
					s_data_controller_state <= HOUSEKEEPING_DATA;

				when IMAGE_HEADER =>
					-- start image header process
					-- if (image_header_finished = '1')
					-- -- goto IMAGE_DATA
					-- else
					-- -- goto HOUSEKEEPING_HEADER
					-- end if
					s_data_controller_state <= IMAGE_HEADER;

				when IMAGE_DATA =>
					-- read image from windowing buffer - quantity nw : 0 -> nw_final (package size)
					-- update nw
					-- if (quantity = nw_final)
					-- -- goto OVERSCAN_HEADER
					-- else
					-- -- goto IMAGE_DATA
					-- end if
					s_data_controller_state <= IMAGE_DATA;

				when OVERSCAN_HEADER =>
					-- start overscan header process
					-- if (overscan_header_finished = '1')
					-- -- goto OVERSCAN_DATA
					-- else
					-- -- goto OVERSCAN_HEADER
					-- end if
					s_data_controller_state <= OVERSCAN_HEADER;

				when OVERSCAN_DATA =>
					-- read overscan from windowing buffer - quantity no : 0 -> no_final (package size)
					-- update no
					-- if (quantity = no_final)
					-- -- goto IDLE
					-- else
					-- -- goto OVERSCAN_DATA
					-- end if
					s_data_controller_state <= OVERSCAN_DATA;

			end case;

		end if;
	end process p_data_controller;

end architecture RTL;
