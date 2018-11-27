library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.data_packet_pkg.all;

entity data_packet_control_ent is
	port(
		-- Global input signals
		--! Local clock used by the RMAP Codec
		clk_i           : in  std_logic; --! Local data packet clock
		reset_i         : in  std_logic; --! Reset = '0': reset active; Reset = '1': no reset

		control_i       : in  t_data_packet_control_control;
		configdata_i    : in  t_data_packet_configdata;
		packetflags_i   : in  t_data_packet_flags;
		-- global output signals
		flags_o         : out t_data_packet_control_flags;
		packetcontrol_o : out t_data_packet_control;
		headerdata_o    : out t_data_packet_headerdata
		-- data bus(es)
	);
end entity data_packet_control_ent;

architecture RTL of data_packet_control_ent is

	-- SYMBOLIC ENCODED state machine: s_DATA_PACKET_CONTROL_STATE
	-- ===========================================================
	type t_data_packet_control_state is (
		IDLE,
		SEND_HEADER,
		WAITING_HEADER_FINISH,
		SEND_HOUSEKEEPING,
		WAITING_HOUSEKEEPING_FINISH,
		SEND_IMAGE,
		WAITING_IMAGE_FINISH,
		FINISH_CONTROL_UNIT_OPERATION
	);
	signal s_data_packet_control_state : t_data_packet_control_state; -- current state

begin

	p_data_packet_control_FSM_state : process(clk_i, reset_i)
	begin
		-- on asynchronous reset in any state we jump to the idle state
		if (reset_i = '1') then
			s_data_packet_control_state <= IDLE;
		-- state transitions are always synchronous to the clock
		elsif (rising_edge(clk_i)) then
			case (s_data_packet_control_state) is

				-- state "IDLE"
				when IDLE =>
					-- does nothing until a request to send a data packet is received
					-- default state transition
					s_data_packet_control_state <= IDLE;
					-- default internal signal values
					-- conditional state transition and internal signal values
					-- check if a request to send a data packet arrived
					if (control_i.send_data_package = '1') then
						-- request received, go to send header
						s_data_packet_control_state <= SEND_HEADER;
					end if;

				-- state "SEND_HEADER"
				when SEND_HEADER =>
					-- send header to target
					-- default state transition
					s_data_packet_control_state <= WAITING_HEADER_FINISH;
				-- default internal signal values
				-- conditional state transition and internal signal values

				-- state "WAITING_HEADER_FINISH"
				when WAITING_HEADER_FINISH =>
					-- wait the end of the header unit operation
					-- default state transition
					s_data_packet_control_state <= WAITING_HEADER_FINISH;
					-- default internal signal values
					-- conditional state transition and internal signal values
					-- check if the header unit operation is finished
					if (packetflags_i.header_unit.header_finished = '1') then
						-- header unit operation finished
						-- check if the data packet is a hkdata or imgdata
						if (configdata_i.package_type(1 downto 0) = c_PACKET_TYPE_HOUSEKEEPING_PACKET) then
							-- hkdata, go to send housekeeping
							s_data_packet_control_state <= SEND_HOUSEKEEPING;
						else
							-- imgdata, go to send image
							s_data_packet_control_state <= SEND_IMAGE;
						end if;
					end if;

				-- state "SEND_HOUSEKEEPING"
				when SEND_HOUSEKEEPING =>
					-- send housekeeping to target
					-- default state transition
					s_data_packet_control_state <= WAITING_HOUSEKEEPING_FINISH;
				-- default internal signal values
				-- conditional state transition and internal signal values

				-- state "WAITING_HOUSEKEEPING_FINISH"
				when WAITING_HOUSEKEEPING_FINISH =>
					-- wait the end of the housekeeping unit operation
					-- default state transition
					s_data_packet_control_state <= WAITING_HOUSEKEEPING_FINISH;
					-- default internal signal values
					-- check if the housekeeping unit operation is finished
					if ((packetflags_i.housekeeping_unit.housekeeping_finished = '1') or (packetflags_i.housekeeping_unit.housekeeping_error = '1')) then
						-- housekeeping unit operation finished
						s_data_packet_control_state <= FINISH_CONTROL_UNIT_OPERATION;
					end if;
				-- conditional state transition and internal signal values

				-- state "SEND_IMAGE"
				when SEND_IMAGE =>
					-- send image to target
					-- default state transition
					s_data_packet_control_state <= WAITING_IMAGE_FINISH;
				-- default internal signal values
				-- conditional state transition and internal signal values

				-- state "WAITING_IMAGE_FINISH"
				when WAITING_IMAGE_FINISH =>
					-- wait the end of the image unit operation
					-- default state transition
					s_data_packet_control_state <= WAITING_IMAGE_FINISH;
					-- default internal signal values
					-- conditional state transition and internal signal values
					-- check if the image unit operation is finished
					if ((packetflags_i.image_unit.image_finished = '1') or (packetflags_i.image_unit.image_error = '1')) then
						-- image unit operation finished
						s_data_packet_control_state <= FINISH_CONTROL_UNIT_OPERATION;
					end if;

				-- state "FINISH_CONTROL_UNIT_OPERATION"
				when FINISH_CONTROL_UNIT_OPERATION =>
					-- finish control unit operation
					-- default state transition
					s_data_packet_control_state <= IDLE;
				-- default internal signal values
				-- conditional state transition and internal signal values

				-- all the other states (not defined)
				when others =>
					-- jump to save state (ERROR?!)
					s_data_packet_control_state <= IDLE;

			end case;
		end if;
	end process p_data_packet_control_FSM_state;

	p_data_packet_control_FSM_output : process(s_data_packet_control_state, reset_i)
	begin
		-- asynchronous reset
		if (reset_i = '1') then
			flags_o.control_busy                                 <= '0';
			flags_o.control_finished                             <= '0';
			packetcontrol_o.header_unit.send_header              <= '0';
			packetcontrol_o.header_unit.header_reset             <= '0';
			packetcontrol_o.housekeeping_unit.send_housekeeping  <= '0';
			packetcontrol_o.housekeeping_unit.housekeeping_reset <= '0';
			packetcontrol_o.image_unit.send_image                <= '0';
			packetcontrol_o.image_unit.image_reset               <= '0';
			headerdata_o.logical_address                         <= (others => '0');
			headerdata_o.length_field                            <= (others => "00");
			headerdata_o.type_field                              <= (others => "00");
			headerdata_o.frame_counter                           <= (others => "00");
			headerdata_o.sequence_counter                        <= (others => "00");
		-- output generation when s_data_packet_control_state changes
		else
			case (s_data_packet_control_state) is

				-- state "IDLE"
				when IDLE =>
					-- does nothing until a request to send a data packet is received
					-- default output signals
					flags_o.control_busy                                 <= '0';
					flags_o.control_finished                             <= '0';
					packetcontrol_o.header_unit.send_header              <= '0';
					packetcontrol_o.header_unit.header_reset             <= '0';
					packetcontrol_o.housekeeping_unit.send_housekeeping  <= '0';
					packetcontrol_o.housekeeping_unit.housekeeping_reset <= '0';
					packetcontrol_o.image_unit.send_image                <= '0';
					packetcontrol_o.image_unit.image_reset               <= '0';
					headerdata_o.logical_address                         <= (others => '0');
					headerdata_o.length_field                            <= (others => "00");
					headerdata_o.type_field                              <= (others => "00");
					headerdata_o.frame_counter                           <= (others => "00");
					headerdata_o.sequence_counter                        <= (others => "00");
				-- conditional output signals

				-- state "SEND_HEADER"
				when SEND_HEADER =>
					-- send header to target
					-- default output signals
					flags_o.control_busy                                <= '1';
					flags_o.control_finished                            <= '0';
					packetcontrol_o.header_unit.send_header             <= '1';
					packetcontrol_o.housekeeping_unit.send_housekeeping <= '0';
					packetcontrol_o.image_unit.send_image               <= '0';
					headerdata_o.logical_address                        <= c_DPU_LOGICAL_ADDRESS;
					headerdata_o.length_field(1)                        <= configdata_i.package_length(15 downto 8);
					headerdata_o.length_field(0)                        <= configdata_i.package_length(7 downto 0);
					headerdata_o.type_field(1)                          <= configdata_i.package_type(15 downto 8);
					headerdata_o.type_field(0)                          <= configdata_i.package_type(7 downto 0);
					headerdata_o.frame_counter(1)                       <= configdata_i.package_frame_counter(15 downto 8);
					headerdata_o.frame_counter(0)                       <= configdata_i.package_frame_counter(7 downto 0);
					headerdata_o.sequence_counter(1)                    <= configdata_i.package_sequence_counter(15 downto 8);
					headerdata_o.sequence_counter(0)                    <= configdata_i.package_sequence_counter(7 downto 0);
				-- conditional output signals

				-- state "WAITING_HEADER_FINISH"
				when WAITING_HEADER_FINISH =>
					-- wait the end of the header unit operation
					-- default output signals
					flags_o.control_busy                                <= '1';
					flags_o.control_finished                            <= '0';
					packetcontrol_o.header_unit.send_header             <= '1';
					packetcontrol_o.housekeeping_unit.send_housekeeping <= '0';
					packetcontrol_o.image_unit.send_image               <= '0';
				-- conditional output signals

				-- state "SEND_HOUSEKEEPING"
				when SEND_HOUSEKEEPING =>
					-- send housekeeping to target
					-- default output signals
					flags_o.control_busy                                <= '1';
					flags_o.control_finished                            <= '0';
					packetcontrol_o.header_unit.send_header             <= '0';
					packetcontrol_o.housekeeping_unit.send_housekeeping <= '1';
					packetcontrol_o.image_unit.send_image               <= '0';
				-- conditional output signals

				-- state "WAITING_HOUSEKEEPING_FINISH"
				when WAITING_HOUSEKEEPING_FINISH =>
					-- wait the end of the housekeeping unit operation
					-- default output signals
					flags_o.control_busy                                <= '1';
					flags_o.control_finished                            <= '0';
					packetcontrol_o.header_unit.send_header             <= '0';
					packetcontrol_o.housekeeping_unit.send_housekeeping <= '1';
					packetcontrol_o.image_unit.send_image               <= '0';
				-- conditional output signals

				-- state "SEND_IMAGE"
				when SEND_IMAGE =>
					-- send image to target
					-- default output signals
					flags_o.control_busy                                <= '1';
					flags_o.control_finished                            <= '0';
					packetcontrol_o.header_unit.send_header             <= '0';
					packetcontrol_o.housekeeping_unit.send_housekeeping <= '0';
					packetcontrol_o.image_unit.send_image               <= '1';
				-- conditional output signals

				-- state "WAITING_IMAGE_FINISH"
				when WAITING_IMAGE_FINISH =>
					-- wait the end of the image unit operation
					-- default output signals
					flags_o.control_busy                                <= '1';
					flags_o.control_finished                            <= '0';
					packetcontrol_o.header_unit.send_header             <= '0';
					packetcontrol_o.housekeeping_unit.send_housekeeping <= '0';
					packetcontrol_o.image_unit.send_image               <= '1';
				-- conditional output signals

				-- state "FINISH_CONTROL_UNIT_OPERATION"
				when FINISH_CONTROL_UNIT_OPERATION =>
					-- finish control unit operation
					-- default output signals
					flags_o.control_busy                                 <= '1';
					flags_o.control_finished                             <= '1';
					packetcontrol_o.header_unit.send_header              <= '0';
					packetcontrol_o.header_unit.header_reset             <= '1';
					packetcontrol_o.housekeeping_unit.send_housekeeping  <= '0';
					packetcontrol_o.housekeeping_unit.housekeeping_reset <= '1';
					packetcontrol_o.image_unit.send_image                <= '0';
					packetcontrol_o.image_unit.image_reset               <= '1';
					headerdata_o.logical_address                         <= (others => '0');
					headerdata_o.length_field                            <= (others => "00");
					headerdata_o.type_field                              <= (others => "00");
					headerdata_o.frame_counter                           <= (others => "00");
					headerdata_o.sequence_counter                        <= (others => "00");
				-- conditional output signals

				-- all the other states (not defined)
				when others =>
					null;

			end case;
		end if;
	end process p_data_packet_control_FSM_output;

end architecture RTL;
