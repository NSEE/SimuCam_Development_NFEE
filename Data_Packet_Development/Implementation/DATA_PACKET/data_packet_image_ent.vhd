library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.data_packet_pkg.all;

entity data_packet_image_ent is
	port(
		-- Global input signals
		--! Local clock used by the RMAP Codec
		clk_i             : in  std_logic; --! Local data packet clock
		reset_n_i         : in  std_logic; --! Reset = '0': reset active; Reset = '1': no reset

		control_i         : in  t_data_packet_image_control;
		imgdata_flag_i    : in  t_data_packet_imgdata_rd_flag;
		spw_flag_i        : in  t_data_packet_spw_tx_flag;
		-- global output signals
		flags_o           : out t_data_packet_image_flags;
		imgdata_control_o : out t_data_packet_imgdata_rd_control;
		spw_control_o     : out t_data_packet_spw_tx_control
		-- data bus(es)
	);
end entity data_packet_image_ent;

architecture RTL of data_packet_image_ent is

	-- SYMBOLIC ENCODED state machine: s_DATA_PACKET_IMAGE_STATE
	-- =========================================================
	type t_data_packet_image_state is (
		IDLE,
		WAITING_BUFFER_SPACE,
		FIELD_IMGDATA,
		FIELD_EOP,
		READ_IMGDATA,
		IMG_ERROR,
		IMAGE_UNIT_FINISH_OPERATION
	);
	signal s_data_packet_image_state      : t_data_packet_image_state; -- current state
	signal s_data_packet_image_next_state : t_data_packet_image_state;

begin

	p_data_packet_image_FSM_state : process(clk_i, reset_n_i)
	begin
		-- on asynchronous reset in any state we jump to the idle state
		if (reset_n_i = '0') then
			s_data_packet_image_state      <= IDLE;
			s_data_packet_image_next_state <= IDLE;
		-- state transitions are always synchronous to the clock
		elsif (rising_edge(clk_i)) then
			case (s_data_packet_image_state) is

				-- state "IDLE"
					-- TODO
				when IDLE =>
					-- does nothing until the control unit signals it is ready to send image data
					-- default state transition
					s_data_packet_image_state      <= IDLE;
					s_data_packet_image_next_state <= IDLE;
				-- default internal signal values
				-- conditional state transition and internal signal values

				-- state "WAITING_BUFFER_SPACE"
					-- TODO
				when WAITING_BUFFER_SPACE =>
					-- wait until the spacewire tx buffer has space
					-- default state transition
					-- default internal signal values
					-- conditional state transition and internal signal values

					-- state "FIELD_IMGDATA"
					-- TODO
				when FIELD_IMGDATA =>
					-- img data field, send img data to the target
					-- default state transition
					-- default internal signal values
					-- conditional state transition and internal signal values

					-- state "FIELD_EOP"
					-- TODO
				when FIELD_EOP =>
					-- eop field, send eop to the target
					-- default state transition
					-- default internal signal values
					-- conditional state transition and internal signal values

					-- state "READ_IMGDATA"
					-- TODO
				when READ_IMGDATA =>
					-- fetch image data
					-- default state transition
					-- default internal signal values
					-- conditional state transition and internal signal values

					-- state "IMG_ERROR"
					-- TODO
				when IMG_ERROR =>
					-- img error ocurred, send eep to the target
					-- default state transition
					-- default internal signal values
					-- conditional state transition and internal signal values

					-- state "IMAGE_UNIT_FINISH_OPERATION"
					-- TODO
				when IMAGE_UNIT_FINISH_OPERATION =>
					-- finish image unit operation
					-- default state transition
					-- default internal signal values
					-- conditional state transition and internal signal values

					-- all the other states (not defined)
				when others =>
					-- jump to save state (ERROR?!)
					s_data_packet_image_state      <= IDLE;
					s_data_packet_image_next_state <= IDLE;

			end case;
		end if;
	end process p_data_packet_image_FSM_state;

	p_data_packet_image_FSM_output : process(s_data_packet_image_state, reset_n_i)
	begin
		-- asynchronous reset
		if (reset_n_i = '0') then

		-- output generation when s_data_packet_image_state changes
		else
			case (s_data_packet_image_state) is

				-- state "IDLE"
					-- TODO
				when IDLE =>
					-- does nothing until the control unit signals it is ready to send image data
					-- default output signals
					-- conditional output signals

					-- state "WAITING_BUFFER_SPACE"
					-- TODO
				when WAITING_BUFFER_SPACE =>
					-- wait until the spacewire tx buffer has space
					-- default output signals
					-- conditional output signals

					-- state "FIELD_IMGDATA"
					-- TODO
				when FIELD_IMGDATA =>
					-- img data field, send img data to the target
					-- default output signals
					-- conditional output signals

					-- state "FIELD_EOP"
					-- TODO
				when FIELD_EOP =>
					-- eop field, send eop to the target
					-- default output signals
					-- conditional output signals

					-- state "READ_IMGDATA"
					-- TODO
				when READ_IMGDATA =>
					-- fetch image data
					-- default output signals
					-- conditional output signals

					-- state "IMG_ERROR"
					-- TODO
				when IMG_ERROR =>
					-- img error ocurred, send eep to the target
					-- default output signals
					-- conditional output signals

					-- state "IMAGE_UNIT_FINISH_OPERATION"
					-- TODO
				when IMAGE_UNIT_FINISH_OPERATION =>
					-- finish image unit operation
					-- default output signals
					-- conditional output signals

					-- all the other states (not defined)
				when others =>
					null;

			end case;
		end if;
	end process p_data_packet_image_FSM_output;

end architecture RTL;
