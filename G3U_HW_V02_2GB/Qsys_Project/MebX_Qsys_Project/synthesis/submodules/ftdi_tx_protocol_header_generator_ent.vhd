library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.ftdi_protocol_pkg.all;
use work.ftdi_protocol_crc_pkg.all;

entity ftdi_tx_protocol_header_generator_ent is
	port(
		clk_i                         : in  std_logic;
		rst_i                         : in  std_logic;
		data_tx_stop_i                : in  std_logic;
		data_tx_start_i               : in  std_logic;
		header_generator_start_i      : in  std_logic;
		header_generator_reset_i      : in  std_logic;
		header_data_i                 : in  t_ftdi_prot_header_fields;
		tx_dc_data_fifo_wrempty_i     : in  std_logic;
		tx_dc_data_fifo_wrfull_i      : in  std_logic;
		tx_dc_data_fifo_wrusedw_i     : in  std_logic_vector(11 downto 0);
		header_generator_busy_o       : out std_logic;
		tx_dc_data_fifo_wrdata_data_o : out std_logic_vector(31 downto 0);
		tx_dc_data_fifo_wrdata_be_o   : out std_logic_vector(3 downto 0);
		tx_dc_data_fifo_wrreq_o       : out std_logic
	);
end entity ftdi_tx_protocol_header_generator_ent;

-- (Tx: FPGA => FTDI)

architecture RTL of ftdi_tx_protocol_header_generator_ent is

	signal s_registered_header_data : t_ftdi_prot_header_fields;
	signal s_header_crc32           : std_logic_vector(31 downto 0);

	type t_ftdi_tx_prot_header_generator_fsm is (
		STOPPED,                        -- header generator stopped
		IDLE,                           -- header generator idle
		WAITING_TX_SPACE,               -- wait until the tx fifo have enough space for a full header
		HEADER_TX_START_OF_PACKAGE,     -- write a start of package to the tx fifo
		HEADER_TX_PACKAGE_ID,           -- write the package id to the tx fifo
		HEADER_TX_IMAGE_SELECTION,      -- write the image selection to the tx fifo
		HEADER_TX_IMAGE_SIZE,           -- write the image size to the tx fifo
		HEADER_TX_EXPOSURE_NUMBER,      -- write the exposure number to the tx fifo
		HEADER_TX_PAYLOAD_LENGTH,       -- write the payload length to the tx fifo
		HEADER_TX_HEADER_CRC,           -- write the header crc to the tx fifo
		HEADER_TX_END_OF_HEADER,        -- write a end of header to the tx fifo
		FINISH_HEADER_TX                -- finish the header transmission
	);
	signal s_ftdi_tx_prot_header_generator_state : t_ftdi_tx_prot_header_generator_fsm;

begin

	p_ftdi_tx_prot_header_generator : process(clk_i, rst_i) is
		variable v_ftdi_tx_prot_header_generator_state : t_ftdi_tx_prot_header_generator_fsm := STOPPED;
		variable v_header_dword                        : std_logic_vector(31 downto 0)       := (others => '0');
	begin
		if (rst_i = '1') then
			-- fsm state reset
			s_ftdi_tx_prot_header_generator_state <= STOPPED;
			v_ftdi_tx_prot_header_generator_state := STOPPED;
			-- internal signals reset
			s_registered_header_data              <= c_FTDI_PROT_HEADER_RESET;
			-- outputs reset
			header_generator_busy_o               <= '0';
			v_header_dword                        := (others => '0');
			s_header_crc32                        <= (others => '0');
			tx_dc_data_fifo_wrdata_data_o         <= (others => '0');
			tx_dc_data_fifo_wrdata_be_o           <= (others => '0');
			tx_dc_data_fifo_wrreq_o               <= '0';
		elsif rising_edge(clk_i) then

			-- States transitions FSM
			case (s_ftdi_tx_prot_header_generator_state) is

				-- state "STOPPED"
				when STOPPED =>
					-- header generator stopped
					-- default state transition
					s_ftdi_tx_prot_header_generator_state <= STOPPED;
					v_ftdi_tx_prot_header_generator_state := STOPPED;
					-- default internal signal values
					s_registered_header_data              <= c_FTDI_PROT_HEADER_RESET;
					-- conditional state transition
					-- check if a start command was issued
					if (data_tx_start_i = '1') then
						s_ftdi_tx_prot_header_generator_state <= IDLE;
						v_ftdi_tx_prot_header_generator_state := IDLE;
					end if;

				-- state "IDLE"
				when IDLE =>
					-- header generator idle
					-- default state transition
					s_ftdi_tx_prot_header_generator_state <= IDLE;
					v_ftdi_tx_prot_header_generator_state := IDLE;
					-- default internal signal values
					s_registered_header_data              <= c_FTDI_PROT_HEADER_RESET;
					-- conditional state transition
					-- check if a header generator start was issued
					if (header_generator_start_i = '1') then
						s_ftdi_tx_prot_header_generator_state <= WAITING_TX_SPACE;
						v_ftdi_tx_prot_header_generator_state := WAITING_TX_SPACE;
						s_registered_header_data              <= header_data_i;
					end if;

				-- state "WAITING_TX_SPACE"
				when WAITING_TX_SPACE =>
					-- wait until the tx fifo have enough space for a full header
					-- default state transition
					s_ftdi_tx_prot_header_generator_state <= WAITING_TX_SPACE;
					v_ftdi_tx_prot_header_generator_state := WAITING_TX_SPACE;
					-- default internal signal values
					-- conditional state transition
					-- check if there is enough space in the tx dc data fifo for a full header (8 dwords)
					if ((tx_dc_data_fifo_wrfull_i = '0') and (to_integer(unsigned(tx_dc_data_fifo_wrusedw_i)) <= ((2 ** tx_dc_data_fifo_wrusedw_i'length) - c_FTDI_PROT_HEADER_SIZE))) then
						s_ftdi_tx_prot_header_generator_state <= HEADER_TX_START_OF_PACKAGE;
						v_ftdi_tx_prot_header_generator_state := HEADER_TX_START_OF_PACKAGE;
					end if;

				-- state "HEADER_TX_START_OF_PACKAGE"
				when HEADER_TX_START_OF_PACKAGE =>
					-- write a start of package to the tx fifo
					-- default state transition
					s_ftdi_tx_prot_header_generator_state <= HEADER_TX_PACKAGE_ID;
					v_ftdi_tx_prot_header_generator_state := HEADER_TX_PACKAGE_ID;
				-- default internal signal values
				-- conditional state transition

				-- state "HEADER_TX_PACKAGE_ID"
				when HEADER_TX_PACKAGE_ID =>
					-- write the package id to the tx fifo
					-- default state transition
					s_ftdi_tx_prot_header_generator_state <= HEADER_TX_IMAGE_SELECTION;
					v_ftdi_tx_prot_header_generator_state := HEADER_TX_IMAGE_SELECTION;
				-- default internal signal values
				-- conditional state transition

				-- state "HEADER_TX_IMAGE_SELECTION"
				when HEADER_TX_IMAGE_SELECTION =>
					-- write the image selection to the tx fifo
					-- default state transition
					s_ftdi_tx_prot_header_generator_state <= HEADER_TX_IMAGE_SIZE;
					v_ftdi_tx_prot_header_generator_state := HEADER_TX_IMAGE_SIZE;
				-- default internal signal values
				-- conditional state transition

				-- state "HEADER_TX_IMAGE_SIZE"
				when HEADER_TX_IMAGE_SIZE =>
					-- write the image size to the tx fifo
					-- default state transition
					s_ftdi_tx_prot_header_generator_state <= HEADER_TX_EXPOSURE_NUMBER;
					v_ftdi_tx_prot_header_generator_state := HEADER_TX_EXPOSURE_NUMBER;
				-- default internal signal values
				-- conditional state transition

				-- state "HEADER_TX_EXPOSURE_NUMBER"
				when HEADER_TX_EXPOSURE_NUMBER =>
					-- write the exposure number to the tx fifo
					-- default state transition
					s_ftdi_tx_prot_header_generator_state <= HEADER_TX_PAYLOAD_LENGTH;
					v_ftdi_tx_prot_header_generator_state := HEADER_TX_PAYLOAD_LENGTH;
				-- default internal signal values
				-- conditional state transition

				-- state "HEADER_TX_PAYLOAD_LENGTH"
				when HEADER_TX_PAYLOAD_LENGTH =>
					-- write the payload length to the tx fifo
					-- default state transition
					s_ftdi_tx_prot_header_generator_state <= HEADER_TX_HEADER_CRC;
					v_ftdi_tx_prot_header_generator_state := HEADER_TX_HEADER_CRC;
				-- default internal signal values
				-- conditional state transition

				-- state "HEADER_TX_HEADER_CRC"
				when HEADER_TX_HEADER_CRC =>
					-- write the header crc to the tx fifo
					-- default state transition
					s_ftdi_tx_prot_header_generator_state <= HEADER_TX_END_OF_HEADER;
					v_ftdi_tx_prot_header_generator_state := HEADER_TX_END_OF_HEADER;
				-- default internal signal values
				-- conditional state transition

				-- state "HEADER_TX_END_OF_HEADER"
				when HEADER_TX_END_OF_HEADER =>
					-- write a end of header to the tx fifo
					-- default state transition
					s_ftdi_tx_prot_header_generator_state <= FINISH_HEADER_TX;
					v_ftdi_tx_prot_header_generator_state := FINISH_HEADER_TX;
				-- default internal signal values
				-- conditional state transition

				-- state "FINISH_HEADER_TX"
				when FINISH_HEADER_TX =>
					-- finish the header transmission
					-- default state transition
					s_ftdi_tx_prot_header_generator_state <= FINISH_HEADER_TX;
					v_ftdi_tx_prot_header_generator_state := FINISH_HEADER_TX;
					-- default internal signal values
					-- conditional state transition
					-- check if a header generator reset was issued
					if (header_generator_reset_i = '1') then
						s_ftdi_tx_prot_header_generator_state <= IDLE;
						v_ftdi_tx_prot_header_generator_state := IDLE;
						s_registered_header_data              <= c_FTDI_PROT_HEADER_RESET;
					end if;

			end case;

			-- check if a stop command was received
			if (data_tx_stop_i = '1') then
				s_ftdi_tx_prot_header_generator_state <= STOPPED;
				v_ftdi_tx_prot_header_generator_state := STOPPED;
			end if;

			-- Output generation FSM
			case (v_ftdi_tx_prot_header_generator_state) is

				-- state "STOPPED"
				when STOPPED =>
					-- header generator stopped
					-- default output signals
					header_generator_busy_o       <= '0';
					v_header_dword                := (others => '0');
					s_header_crc32                <= (others => '0');
					tx_dc_data_fifo_wrdata_data_o <= (others => '0');
					tx_dc_data_fifo_wrdata_be_o   <= (others => '0');
					tx_dc_data_fifo_wrreq_o       <= '0';
				-- conditional output signals

				-- state "IDLE"
				when IDLE =>
					-- header generator idle
					-- default output signals
					header_generator_busy_o       <= '0';
					v_header_dword                := (others => '0');
					s_header_crc32                <= (others => '0');
					tx_dc_data_fifo_wrdata_data_o <= (others => '0');
					tx_dc_data_fifo_wrdata_be_o   <= (others => '0');
					tx_dc_data_fifo_wrreq_o       <= '0';
				-- conditional output signals

				-- state "WAITING_TX_SPACE"
				when WAITING_TX_SPACE =>
					-- wait until the tx fifo have enough space for a full header
					-- default output signals
					header_generator_busy_o       <= '1';
					v_header_dword                := (others => '0');
					s_header_crc32                <= (others => '0');
					tx_dc_data_fifo_wrdata_data_o <= (others => '0');
					tx_dc_data_fifo_wrdata_be_o   <= (others => '0');
					tx_dc_data_fifo_wrreq_o       <= '0';
				-- conditional output signals

				-- state "HEADER_TX_START_OF_PACKAGE"
				when HEADER_TX_START_OF_PACKAGE =>
					-- write a start of package to the tx fifo
					-- default output signals
					header_generator_busy_o       <= '1';
					v_header_dword                := (others => '0');
					s_header_crc32                <= c_FTDI_PROT_CRC32_START;
					tx_dc_data_fifo_wrdata_data_o <= c_FTDI_PROT_START_OF_PACKAGE;
					tx_dc_data_fifo_wrdata_be_o   <= (others => '1');
					tx_dc_data_fifo_wrreq_o       <= '1';
				-- conditional output signals

				-- state "HEADER_TX_PACKAGE_ID"
				when HEADER_TX_PACKAGE_ID =>
					-- write the package id to the tx fifo
					-- default output signals
					header_generator_busy_o       <= '1';
					v_header_dword                := s_registered_header_data.package_id;
					s_header_crc32                <= f_ftdi_protocol_calculate_crc32_dword(s_header_crc32, v_header_dword);
					tx_dc_data_fifo_wrdata_data_o <= v_header_dword;
					tx_dc_data_fifo_wrdata_be_o   <= (others => '1');
					tx_dc_data_fifo_wrreq_o       <= '1';
				-- conditional output signals

				-- state "HEADER_TX_IMAGE_SELECTION"
				when HEADER_TX_IMAGE_SELECTION =>
					-- write the image selection to the tx fifo
					-- default output signals
					header_generator_busy_o       <= '1';
					v_header_dword                := (others => '0');
					v_header_dword(18 downto 16)  := s_registered_header_data.image_selection.fee_number;
					v_header_dword(9 downto 8)    := s_registered_header_data.image_selection.ccd_number;
					v_header_dword(0)             := s_registered_header_data.image_selection.ccd_side;
					s_header_crc32                <= f_ftdi_protocol_calculate_crc32_dword(s_header_crc32, v_header_dword);
					tx_dc_data_fifo_wrdata_data_o <= v_header_dword;
					tx_dc_data_fifo_wrdata_be_o   <= (others => '1');
					tx_dc_data_fifo_wrreq_o       <= '1';
				-- conditional output signals

				-- state "HEADER_TX_IMAGE_SIZE"
				when HEADER_TX_IMAGE_SIZE =>
					-- write the image size to the tx fifo
					-- default output signals
					header_generator_busy_o       <= '1';
					v_header_dword                := (others => '0');
					v_header_dword(28 downto 16)  := s_registered_header_data.image_size.ccd_height;
					v_header_dword(11 downto 0)   := s_registered_header_data.image_size.ccd_width;
					s_header_crc32                <= f_ftdi_protocol_calculate_crc32_dword(s_header_crc32, v_header_dword);
					tx_dc_data_fifo_wrdata_data_o <= v_header_dword;
					tx_dc_data_fifo_wrdata_be_o   <= (others => '1');
					tx_dc_data_fifo_wrreq_o       <= '1';
				-- conditional output signals

				-- state "HEADER_TX_EXPOSURE_NUMBER"
				when HEADER_TX_EXPOSURE_NUMBER =>
					-- write the exposure number to the tx fifo
					-- default output signals
					header_generator_busy_o       <= '1';
					v_header_dword                := (others => '0');
					v_header_dword(15 downto 0)   := s_registered_header_data.exposure_number;
					s_header_crc32                <= f_ftdi_protocol_calculate_crc32_dword(s_header_crc32, v_header_dword);
					tx_dc_data_fifo_wrdata_data_o <= v_header_dword;
					tx_dc_data_fifo_wrreq_o       <= '1';
				-- conditional output signals

				-- state "HEADER_TX_PAYLOAD_LENGTH"
				when HEADER_TX_PAYLOAD_LENGTH =>
					-- write the payload length to the tx fifo
					-- default output signals
					header_generator_busy_o       <= '1';
					v_header_dword                := s_registered_header_data.payload_length;
					s_header_crc32                <= f_ftdi_protocol_calculate_crc32_dword(s_header_crc32, v_header_dword);
					tx_dc_data_fifo_wrdata_data_o <= v_header_dword;
					tx_dc_data_fifo_wrdata_be_o   <= (others => '1');
					tx_dc_data_fifo_wrreq_o       <= '1';
				-- conditional output signals

				-- state "HEADER_TX_HEADER_CRC"
				when HEADER_TX_HEADER_CRC =>
					-- write the header crc to the tx fifo
					-- default output signals
					header_generator_busy_o       <= '1';
					v_header_dword                := (others => '0');
					s_header_crc32                <= (others => '0');
					tx_dc_data_fifo_wrdata_data_o <= f_ftdi_protocol_finish_crc32(s_header_crc32);
					tx_dc_data_fifo_wrdata_be_o   <= (others => '1');
					tx_dc_data_fifo_wrreq_o       <= '1';
				-- conditional output signals

				-- state "HEADER_TX_END_OF_HEADER"
				when HEADER_TX_END_OF_HEADER =>
					-- write a end of header to the tx fifo
					-- default output signals
					header_generator_busy_o       <= '1';
					v_header_dword                := (others => '0');
					s_header_crc32                <= (others => '0');
					tx_dc_data_fifo_wrdata_data_o <= c_FTDI_PROT_END_OF_HEADER;
					tx_dc_data_fifo_wrdata_be_o   <= (others => '1');
					tx_dc_data_fifo_wrreq_o       <= '1';
				-- conditional output signals

				-- state "FINISH_HEADER_TX"
				when FINISH_HEADER_TX =>
					-- finish the header transmission
					-- default output signals
					header_generator_busy_o       <= '0';
					v_header_dword                := (others => '0');
					s_header_crc32                <= (others => '0');
					tx_dc_data_fifo_wrdata_data_o <= (others => '0');
					tx_dc_data_fifo_wrdata_be_o   <= (others => '0');
					tx_dc_data_fifo_wrreq_o       <= '0';
					-- conditional output signals

			end case;

		end if;
	end process p_ftdi_tx_prot_header_generator;

end architecture RTL;
