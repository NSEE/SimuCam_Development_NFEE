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
		headerdata_i      : in  t_data_packet_image_headerdata;
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

	signal s_byte_counter        : std_logic_vector(15 downto 0);
	constant c_BYTE_COUNTER_ZERO : std_logic_vector(15 downto 0) := (others => '0');

	signal s_img_error : std_logic;

	signal s_image_length_vector : std_logic_vector(15 downto 0);

begin

	s_image_length_vector <= headerdata_i.length_field(1) & headerdata_i.length_field(0);

	p_data_packet_image_FSM_state : process(clk_i, reset_n_i)
	begin
		-- on asynchronous reset in any state we jump to the idle state
		if (reset_n_i = '0') then
			s_data_packet_image_state      <= IDLE;
			s_data_packet_image_next_state <= IDLE;
			s_byte_counter                 <= (others => '0');
		-- state transitions are always synchronous to the clock
		elsif (rising_edge(clk_i)) then
			case (s_data_packet_image_state) is

				-- state "IDLE"
				when IDLE =>
					-- does nothing until the control unit signals it is ready to send image data
					-- default state transition
					s_data_packet_image_state      <= IDLE;
					s_data_packet_image_next_state <= IDLE;
					-- default internal signal values
					s_byte_counter                 <= (others => '0');
					-- conditional state transition and internal signal values
					-- check if the control unit is ready to send image data
					if (control_i.send_housekeeping = '1') then
						-- control unit ready to send image data
						-- prepare byte counter for multi-byte read data
						s_byte_counter                 <= std_logic_vector(unsigned(s_image_length_vector) - 1);
						-- go to wating buffer space
						s_data_packet_image_state      <= WAITING_BUFFER_SPACE;
						-- prepare for next field (imgdata field)
						s_data_packet_image_next_state <= FIELD_IMGDATA;
					end if;

				-- state "WAITING_BUFFER_SPACE"
				when WAITING_BUFFER_SPACE =>
					-- wait until the spacewire tx buffer has space
					-- default state transition
					s_data_packet_image_state <= WAITING_BUFFER_SPACE;
					-- default internal signal values
					-- conditional state transition and internal signal values
					-- check if tx buffer can receive data
					if (spw_flag_i.ready = '1') then
						-- tx buffer can receive data
						-- go to next field
						s_data_packet_image_state <= s_data_packet_image_next_state;
					end if;

				-- state "FIELD_IMGDATA"
				when FIELD_IMGDATA =>
					-- img data field, send img data to the target
					-- default state transition
					s_data_packet_image_state      <= WAITING_BUFFER_SPACE;
					s_data_packet_image_next_state <= READ_IMGDATA;
					-- default internal signal values
					s_byte_counter                 <= (others => '0');
					-- conditional state transition and internal signal values
					-- check if all imgdata has been read
					if (s_byte_counter = c_BYTE_COUNTER_ZERO) then
						-- all data read
						-- go to next field (eop)
						s_data_packet_image_next_state <= FIELD_EOP;
					else
						-- there is still more imgdata to be read
						-- update byte counter (for next byte)
						s_byte_counter <= std_logic_vector(unsigned(s_byte_counter) - 1);
					end if;

				-- state "FIELD_EOP"
				when FIELD_EOP =>
					-- eop field, send eop to the target
					-- default state transition
					s_data_packet_image_state      <= IMAGE_UNIT_FINISH_OPERATION;
					s_data_packet_image_next_state <= IDLE;
					-- default internal signal values
					s_byte_counter                 <= (others => '0');
				-- conditional state transition and internal signal values

				-- state "READ_IMGDATA"
				when READ_IMGDATA =>
					-- fetch image data
					-- default state transition
					s_data_packet_image_state <= READ_IMGDATA;
					-- default internal signal values
					-- conditional state transition and internal signal values
					-- check if imgdata is valid
					if (imgdata_flag_i.valid = '1') then
						-- imgdata is valid
						-- go to next imgdata field
						s_data_packet_image_state <= FIELD_IMGDATA;
					-- check if a imgdata error ocurred
					elsif (imgdata_flag_i.error = '1') then
						-- imgdata error occured
						-- go to img error state
						s_data_packet_image_state      <= IMG_ERROR;
						s_data_packet_image_next_state <= IDLE;
					end if;

				-- state "IMG_ERROR"
				when IMG_ERROR =>
					-- img error ocurred, send eep to the target
					-- default state transition
					s_data_packet_image_state      <= IMAGE_UNIT_FINISH_OPERATION;
					s_data_packet_image_next_state <= IDLE;
					-- default internal signal values
					s_byte_counter                 <= (others => '0');
				-- default internal signal values
				-- conditional state transition and internal signal values

				-- state "IMAGE_UNIT_FINISH_OPERATION"
				when IMAGE_UNIT_FINISH_OPERATION =>
					-- finish image unit operation
					-- default state transition
					s_data_packet_image_state      <= IMAGE_UNIT_FINISH_OPERATION;
					s_data_packet_image_next_state <= IDLE;
					-- default internal signal values
					s_byte_counter                 <= (others => '0');
					-- default internal signal values
					-- conditional state transition and internal signal values
					-- check if control unit commanded a image reset
					if (control_i.image_reset = '1') then
						-- image reset commanded, go back to idle
						s_data_packet_image_state      <= IDLE;
						s_data_packet_image_next_state <= IDLE;
					end if;

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
			flags_o.image_busy     <= '0';
			flags_o.image_finished <= '0';
			flags_o.image_error    <= '0';
			spw_control_o.data     <= x"00";
			spw_control_o.flag     <= '0';
			spw_control_o.write    <= '0';
			imgdata_control_o.read <= '0';
			s_img_error            <= '0';
		-- output generation when s_data_packet_image_state changes
		else
			case (s_data_packet_image_state) is

				-- state "IDLE"
				when IDLE =>
					-- does nothing until the control unit signals it is ready to send image data
					-- default output signals
					flags_o.image_busy     <= '0';
					flags_o.image_finished <= '0';
					flags_o.image_error    <= '0';
					spw_control_o.data     <= x"00";
					spw_control_o.flag     <= '0';
					spw_control_o.write    <= '0';
					imgdata_control_o.read <= '0';
					s_img_error            <= '0';
				-- conditional output signals

				-- state "WAITING_BUFFER_SPACE"
				-- TODO
				when WAITING_BUFFER_SPACE =>
					-- wait until the spacewire tx buffer has space
					-- default output signals
					flags_o.image_busy     <= '1';
					flags_o.image_finished <= '0';
					flags_o.image_error    <= '0';
					s_img_error            <= '0';
					-- clear spw tx write signal
					spw_control_o.write    <= '0';
				-- conditional output signals

				-- state "FIELD_IMGDATA"
				when FIELD_IMGDATA =>
					-- img data field, send img data to the target
					-- default output signals
					flags_o.image_busy     <= '1';
					flags_o.image_finished <= '0';
					flags_o.image_error    <= '0';
					imgdata_control_o.read <= '0';
					s_img_error            <= '0';
					-- clear spw flag (to indicate a data)
					spw_control_o.flag     <= '0';
					-- fill spw data with field data
					spw_control_o.data     <= imgdata_flag_i.data;
					-- write the spw data
					spw_control_o.write    <= '1';
				-- conditional output signals

				-- state "FIELD_EOP"
				when FIELD_EOP =>
					-- eop field, send eop to the target
					-- default output signals
					flags_o.image_busy     <= '1';
					flags_o.image_finished <= '0';
					flags_o.image_error    <= '0';
					s_img_error            <= '0';
					-- set spw flag (to indicate a package end)
					spw_control_o.flag     <= '1';
					-- fill spw data with the eop identifier (0x00)
					spw_control_o.data     <= c_EOP_VALUE;
					-- write the spw data
					spw_control_o.write    <= '1';
				-- conditional output signals

				-- state "READ_IMGDATA"
				when READ_IMGDATA =>
					-- fetch image data
					-- default output signals
					flags_o.image_busy     <= '1';
					flags_o.image_finished <= '0';
					flags_o.image_error    <= '0';
					s_img_error            <= '0';
					-- set imgdata read request
					imgdata_control_o.read <= '1';
				-- conditional output signals

				-- state "IMG_ERROR"
				when IMG_ERROR =>
					-- img error ocurred, send eep to the target
					-- default output signals
					flags_o.image_busy     <= '1';
					flags_o.image_finished <= '0';
					flags_o.image_error    <= '0';
					s_img_error            <= '1';
					-- set spw flag (to indicate a package end)
					spw_control_o.flag     <= '1';
					-- fill spw data with the eep identifier (0x01)
					spw_control_o.data     <= c_EEP_VALUE;
					-- write the spw data
					spw_control_o.write    <= '1';
				-- conditional output signals

				-- state "IMAGE_UNIT_FINISH_OPERATION"
				when IMAGE_UNIT_FINISH_OPERATION =>
					-- finish image unit operation
					-- default output signals
					flags_o.image_busy     <= '1';
					flags_o.image_finished <= '0';
					flags_o.image_error    <= '0';
					spw_control_o.write    <= '0';
					spw_control_o.flag     <= '0';
					spw_control_o.data     <= x"00";
					imgdata_control_o.read <= '0';
					-- conditional output signals
					-- check if a img error ocurred
					if (s_img_error = '1') then
						-- error ocurred, image operation failed
						flags_o.image_error <= '1';
					else
						-- operation successful
						flags_o.image_finished <= '1';
					end if;

				-- all the other states (not defined)
				when others =>
					null;

			end case;
		end if;
	end process p_data_packet_image_FSM_output;

end architecture RTL;
