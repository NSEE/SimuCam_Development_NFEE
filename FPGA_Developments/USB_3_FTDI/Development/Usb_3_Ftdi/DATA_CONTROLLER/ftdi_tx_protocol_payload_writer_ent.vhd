library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.ftdi_protocol_pkg.all;
use work.ftdi_protocol_crc_pkg.all;

entity ftdi_tx_protocol_payload_writer_ent is
	port(
		clk_i                         : in  std_logic;
		rst_i                         : in  std_logic;
		data_tx_stop_i                : in  std_logic;
		data_tx_start_i               : in  std_logic;
		payload_writer_start_i        : in  std_logic;
		payload_length_bytes_i        : in  std_logic_vector(31 downto 0);
		buffer_stat_empty_i           : in  std_logic;
		buffer_rddata_i               : in  std_logic_vector(255 downto 0);
		buffer_rdready_i              : in  std_logic;
		tx_dc_data_fifo_wrfull_i      : in  std_logic;
		tx_dc_data_fifo_wrusedw_i     : in  std_logic_vector(11 downto 0);
		payload_writer_busy_o         : out std_logic;
		buffer_rdreq_o                : out std_logic;
		buffer_change_o               : out std_logic;
		tx_dc_data_fifo_wrdata_data_o : out std_logic_vector(31 downto 0);
		tx_dc_data_fifo_wrdata_be_o   : out std_logic_vector(3 downto 0);
		tx_dc_data_fifo_wrreq_o       : out std_logic
	);
end entity ftdi_tx_protocol_payload_writer_ent;

architecture RTL of ftdi_tx_protocol_payload_writer_ent is

	signal s_payload_length_cnt : std_logic_vector(31 downto 0);
	signal s_payload_crc32      : std_logic_vector(31 downto 0);

	type t_ftdi_tx_prot_payload_writer_fsm is (
		STOPPED,                        -- payload writer stopped
		IDLE,                           -- payload writer idle
		WAITING_TX_READY,               -- wait until there is data to be fetched and space to write
		FETCH_TX_QQWORD,                -- fetch tx qqword data (256b)
		FETCH_DELAY,                    -- fetch delay
		WRITE_TX_DWORD_0,               -- write tx dword data 0 (32b)
		WRITE_TX_DWORD_1,               -- write tx dword data 1 (32b)
		WRITE_TX_DWORD_2,               -- write tx dword data 2 (32b)
		WRITE_TX_DWORD_3,               -- write tx dword data 3 (32b)
		WRITE_TX_DWORD_4,               -- write tx dword data 4 (32b)
		WRITE_TX_DWORD_5,               -- write tx dword data 5 (32b)
		WRITE_TX_DWORD_6,               -- write tx dword data 6 (32b)
		WRITE_TX_DWORD_7,               -- write tx dword data 7 (32b)
		WRITE_DELAY,                    -- write delay
		CHANGE_BUFFER,                  -- change tx buffer
		WAITING_TX_SPACE_CRC,           -- wait until there is enough space in the tx fifo for the crc and eop 
		WRITE_TX_PAYLOAD_CRC,           -- write the payload crc to the tx fifo
		WAITING_TX_SPACE_EOP,           -- wait until there is enough space in the tx fifo for the eop
		WRITE_TX_END_OF_PAYLOAD,        -- write a end of payload to the tx fifo
		FINISH_PAYLOAD_TX               -- finish the payload write

	);
	signal s_ftdi_tx_prot_payload_writer_state : t_ftdi_tx_prot_payload_writer_fsm;

	signal s_tx_dword_0 : std_logic_vector(31 downto 0);
	signal s_tx_dword_1 : std_logic_vector(31 downto 0);
	signal s_tx_dword_2 : std_logic_vector(31 downto 0);
	signal s_tx_dword_3 : std_logic_vector(31 downto 0);
	signal s_tx_dword_4 : std_logic_vector(31 downto 0);
	signal s_tx_dword_5 : std_logic_vector(31 downto 0);
	signal s_tx_dword_6 : std_logic_vector(31 downto 0);
	signal s_tx_dword_7 : std_logic_vector(31 downto 0);

begin

	p_ftdi_tx_protocol_payload_writer : process(clk_i, rst_i) is
		variable v_ftdi_tx_prot_payload_writer_state : t_ftdi_tx_prot_payload_writer_fsm := STOPPED;
	begin
		if (rst_i = '1') then
			-- fsm state reset
			s_ftdi_tx_prot_payload_writer_state <= STOPPED;
			v_ftdi_tx_prot_payload_writer_state := STOPPED;
			-- internal signals reset
			s_payload_length_cnt                <= (others => '0');
			-- outputs reset
			payload_writer_busy_o               <= '0';
			s_payload_crc32                     <= (others => '0');
			buffer_rdreq_o                      <= '0';
			buffer_change_o                     <= '0';
			tx_dc_data_fifo_wrdata_data_o       <= (others => '0');
			tx_dc_data_fifo_wrdata_be_o         <= (others => '0');
			tx_dc_data_fifo_wrreq_o             <= '0';
		elsif rising_edge(clk_i) then

			-- States transitions FSM
			case (s_ftdi_tx_prot_payload_writer_state) is

				-- state "STOPPED"
				when STOPPED =>
					-- payload writer stopped
					-- default state transition
					s_ftdi_tx_prot_payload_writer_state <= STOPPED;
					v_ftdi_tx_prot_payload_writer_state := STOPPED;
					-- default internal signal values
					s_payload_length_cnt                <= (others => '0');
					-- conditional state transition
					-- check if a start command was issued
					if (data_tx_start_i = '1') then
						s_ftdi_tx_prot_payload_writer_state <= IDLE;
						v_ftdi_tx_prot_payload_writer_state := IDLE;
					end if;

				-- state "IDLE"
				when IDLE =>
					-- payload writer idle
					-- default state transition
					s_ftdi_tx_prot_payload_writer_state <= IDLE;
					v_ftdi_tx_prot_payload_writer_state := IDLE;
					-- default internal signal values
					s_payload_length_cnt                <= (others => '0');
					-- conditional state transition
					-- check if a payload writer start was issued
					if (payload_writer_start_i = '1') then
						s_ftdi_tx_prot_payload_writer_state <= WAITING_TX_READY;
						v_ftdi_tx_prot_payload_writer_state := WAITING_TX_READY;
						if (unsigned(payload_length_bytes_i) >= 8) then
							s_payload_length_cnt <= payload_length_bytes_i;
						else
							s_ftdi_tx_prot_payload_writer_state <= WAITING_TX_SPACE_EOP;
							v_ftdi_tx_prot_payload_writer_state := WAITING_TX_SPACE_EOP;
						end if;
					end if;

				-- state "WAITING_TX_READY"
				when WAITING_TX_READY =>
					-- wait until there is data to be fetched and space to write
					-- default state transition
					s_ftdi_tx_prot_payload_writer_state <= WAITING_TX_READY;
					v_ftdi_tx_prot_payload_writer_state := WAITING_TX_READY;
					-- default internal signal values
					-- conditional state transition
					-- check (if the tx data buffer is ready and not empty) and (if there is enough space in the tx dc data fifo for the fetched qword) 
					if (((buffer_rdready_i = '1') and (buffer_stat_empty_i = '0')) and ((tx_dc_data_fifo_wrfull_i = '0') and (to_integer(unsigned(tx_dc_data_fifo_wrusedw_i)) <= ((2 ** tx_dc_data_fifo_wrusedw_i'length) - 8)))) then
						s_ftdi_tx_prot_payload_writer_state <= FETCH_TX_QQWORD;
						v_ftdi_tx_prot_payload_writer_state := FETCH_TX_QQWORD;
						s_payload_length_cnt                <= std_logic_vector(unsigned(s_payload_length_cnt) - 8);
					end if;

				-- state "FETCH_TX_QQWORD"
				when FETCH_TX_QQWORD =>
					-- fetch tx qqword data (256b)
					-- default state transition
					s_ftdi_tx_prot_payload_writer_state <= FETCH_DELAY;
					v_ftdi_tx_prot_payload_writer_state := FETCH_DELAY;
				-- default internal signal values
				-- conditional state transition

				-- state "FETCH_DELAY"
				when FETCH_DELAY =>
					-- fetch delay
					-- default state transition
					s_ftdi_tx_prot_payload_writer_state <= WRITE_TX_DWORD_0;
					v_ftdi_tx_prot_payload_writer_state := WRITE_TX_DWORD_0;
				-- default internal signal values
				-- conditional state transition

				-- state "WRITE_TX_DWORD_0"
				when WRITE_TX_DWORD_0 =>
					-- write tx dword data 0 (32b)
					-- default state transition
					s_ftdi_tx_prot_payload_writer_state <= WRITE_TX_DWORD_1;
					v_ftdi_tx_prot_payload_writer_state := WRITE_TX_DWORD_1;
				-- default internal signal values
				-- conditional state transition

				-- state "WRITE_TX_DWORD_1"
				when WRITE_TX_DWORD_1 =>
					-- write tx dword data 1 (32b)
					-- default state transition
					s_ftdi_tx_prot_payload_writer_state <= WRITE_TX_DWORD_2;
					v_ftdi_tx_prot_payload_writer_state := WRITE_TX_DWORD_2;
				-- default internal signal values
				-- conditional state transition

				-- state "WRITE_TX_DWORD_2"
				when WRITE_TX_DWORD_2 =>
					-- write tx dword data 2 (32b)
					-- default state transition
					s_ftdi_tx_prot_payload_writer_state <= WRITE_TX_DWORD_3;
					v_ftdi_tx_prot_payload_writer_state := WRITE_TX_DWORD_3;
				-- default internal signal values
				-- conditional state transition

				-- state "WRITE_TX_DWORD_3"
				when WRITE_TX_DWORD_3 =>
					-- write tx dword data 3 (32b)
					-- default state transition
					s_ftdi_tx_prot_payload_writer_state <= WRITE_TX_DWORD_4;
					v_ftdi_tx_prot_payload_writer_state := WRITE_TX_DWORD_4;
				-- default internal signal values
				-- conditional state transition

				-- state "WRITE_TX_DWORD_4"
				when WRITE_TX_DWORD_4 =>
					-- write tx dword data 4 (32b)
					-- default state transition
					s_ftdi_tx_prot_payload_writer_state <= WRITE_TX_DWORD_5;
					v_ftdi_tx_prot_payload_writer_state := WRITE_TX_DWORD_5;
				-- default internal signal values
				-- conditional state transition

				-- state "WRITE_TX_DWORD_5"
				when WRITE_TX_DWORD_5 =>
					-- write tx dword data 5 (32b)
					-- default state transition
					s_ftdi_tx_prot_payload_writer_state <= WRITE_TX_DWORD_6;
					v_ftdi_tx_prot_payload_writer_state := WRITE_TX_DWORD_6;
				-- default internal signal values
				-- conditional state transition

				-- state "WRITE_TX_DWORD_6"
				when WRITE_TX_DWORD_6 =>
					-- write tx dword data 6 (32b)
					-- default state transition
					s_ftdi_tx_prot_payload_writer_state <= WRITE_TX_DWORD_7;
					v_ftdi_tx_prot_payload_writer_state := WRITE_TX_DWORD_7;
				-- default internal signal values
				-- conditional state transition

				-- state "WRITE_TX_DWORD_7"
				when WRITE_TX_DWORD_7 =>
					-- write tx dword data 7 (32b)
					-- default state transition
					s_ftdi_tx_prot_payload_writer_state <= WRITE_DELAY;
					v_ftdi_tx_prot_payload_writer_state := WRITE_DELAY;
				-- default internal signal values
				-- conditional state transition

				-- state "WRITE_DELAY"
				when WRITE_DELAY =>
					-- write delay
					-- default state transition
					s_ftdi_tx_prot_payload_writer_state <= WAITING_TX_READY;
					v_ftdi_tx_prot_payload_writer_state := WAITING_TX_READY;
					-- default internal signal values
					-- conditional state transition
					-- check if the tx data buffer is empty
					if (buffer_stat_empty_i = '1') then
						-- tx data buffer empty, change the buffer
						s_ftdi_tx_prot_payload_writer_state <= CHANGE_BUFFER;
						v_ftdi_tx_prot_payload_writer_state := CHANGE_BUFFER;
					else
						if (unsigned(payload_length_bytes_i) < 8) then
							s_payload_length_cnt                <= (others => '0');
							s_ftdi_tx_prot_payload_writer_state <= WAITING_TX_SPACE_CRC;
							v_ftdi_tx_prot_payload_writer_state := WAITING_TX_SPACE_CRC;
						else
							s_payload_length_cnt <= std_logic_vector(unsigned(s_payload_length_cnt) - 8);
							-- check (if the tx data buffer is ready and not empty) and (if there is enough space in the tx dc data fifo for the fetched qword)
							if (((buffer_rdready_i = '1') and (buffer_stat_empty_i = '0')) and ((tx_dc_data_fifo_wrfull_i = '0') and (to_integer(unsigned(tx_dc_data_fifo_wrusedw_i)) <= ((2 ** tx_dc_data_fifo_wrusedw_i'length) - 8)))) then
								s_ftdi_tx_prot_payload_writer_state <= FETCH_TX_QQWORD;
								v_ftdi_tx_prot_payload_writer_state := FETCH_TX_QQWORD;
							end if;
						end if;
					end if;

				-- state "CHANGE_BUFFER"
				when CHANGE_BUFFER =>
					-- change tx buffer
					-- default state transition
					s_ftdi_tx_prot_payload_writer_state <= WAITING_TX_READY;
					v_ftdi_tx_prot_payload_writer_state := WAITING_TX_READY;
					-- default internal signal values
					-- conditional state transition
					if (unsigned(payload_length_bytes_i) < 8) then
						s_payload_length_cnt                <= (others => '0');
						s_ftdi_tx_prot_payload_writer_state <= WAITING_TX_SPACE_CRC;
						v_ftdi_tx_prot_payload_writer_state := WAITING_TX_SPACE_CRC;
					end if;

				-- state "WAITING_TX_SPACE_CRC"
				when WAITING_TX_SPACE_CRC =>
					-- wait until there is enough space in the tx fifo for the crc and eop 
					-- default state transition
					s_ftdi_tx_prot_payload_writer_state <= WAITING_TX_SPACE_CRC;
					v_ftdi_tx_prot_payload_writer_state := WAITING_TX_SPACE_CRC;
					-- default internal signal values
					s_payload_length_cnt                <= (others => '0');
					-- conditional state transition
					if ((tx_dc_data_fifo_wrfull_i = '0') and (to_integer(unsigned(tx_dc_data_fifo_wrusedw_i)) <= ((2 ** tx_dc_data_fifo_wrusedw_i'length) - 2))) then
						s_ftdi_tx_prot_payload_writer_state <= WRITE_TX_PAYLOAD_CRC;
						v_ftdi_tx_prot_payload_writer_state := WRITE_TX_PAYLOAD_CRC;
					end if;

				-- state "WRITE_TX_PAYLOAD_CRC"
				when WRITE_TX_PAYLOAD_CRC =>
					-- write the payload crc to the tx fifo
					-- default state transition
					s_ftdi_tx_prot_payload_writer_state <= WRITE_TX_END_OF_PAYLOAD;
					v_ftdi_tx_prot_payload_writer_state := WRITE_TX_END_OF_PAYLOAD;
					-- default internal signal values
					s_payload_length_cnt                <= (others => '0');
				-- conditional state transition

				-- state "WAITING_TX_SPACE_EOP"
				when WAITING_TX_SPACE_EOP =>
					-- wait until there is enough space in the tx fifo for the eop 
					-- default state transition
					s_ftdi_tx_prot_payload_writer_state <= WAITING_TX_SPACE_EOP;
					v_ftdi_tx_prot_payload_writer_state := WAITING_TX_SPACE_EOP;
					-- default internal signal values
					s_payload_length_cnt                <= (others => '0');
					-- conditional state transition
					if (tx_dc_data_fifo_wrfull_i = '0') then
						s_ftdi_tx_prot_payload_writer_state <= WRITE_TX_PAYLOAD_CRC;
						v_ftdi_tx_prot_payload_writer_state := WRITE_TX_PAYLOAD_CRC;
					end if;

				-- state "WRITE_TX_END_OF_PAYLOAD"
				when WRITE_TX_END_OF_PAYLOAD =>
					-- write a end of payload to the tx fifo 
					-- default state transition
					s_ftdi_tx_prot_payload_writer_state <= FINISH_PAYLOAD_TX;
					v_ftdi_tx_prot_payload_writer_state := FINISH_PAYLOAD_TX;
					-- default internal signal values
					s_payload_length_cnt                <= (others => '0');
				-- conditional state transition

				-- state "FINISH_PAYLOAD_TX"
				when FINISH_PAYLOAD_TX =>
					-- finish the payload write
					-- default state transition
					s_ftdi_tx_prot_payload_writer_state <= IDLE;
					v_ftdi_tx_prot_payload_writer_state := IDLE;
					-- default internal signal values
					s_payload_length_cnt                <= (others => '0');
				-- conditional state transition

				-- all the other states (not defined)
				when others =>
					s_ftdi_tx_prot_payload_writer_state <= STOPPED;
					v_ftdi_tx_prot_payload_writer_state := STOPPED;

			end case;

			-- check if a stop command was received
			if (data_tx_stop_i = '1') then
				s_ftdi_tx_prot_payload_writer_state <= STOPPED;
				v_ftdi_tx_prot_payload_writer_state := STOPPED;
			end if;

			-- Output generation FSM
			case (v_ftdi_tx_prot_payload_writer_state) is

				-- state "STOPPED"
				when STOPPED =>
					-- payload writer stopped
					-- default output signals
					payload_writer_busy_o         <= '0';
					s_payload_crc32               <= (others => '0');
					buffer_rdreq_o                <= '0';
					buffer_change_o               <= '0';
					tx_dc_data_fifo_wrdata_data_o <= (others => '0');
					tx_dc_data_fifo_wrdata_be_o   <= (others => '0');
					tx_dc_data_fifo_wrreq_o       <= '0';
				-- conditional output signals

				-- state "IDLE"
				when IDLE =>
					-- payload writer idle
					-- default output signals
					payload_writer_busy_o         <= '0';
					s_payload_crc32               <= (others => '0');
					buffer_rdreq_o                <= '0';
					buffer_change_o               <= '0';
					tx_dc_data_fifo_wrdata_data_o <= (others => '0');
					tx_dc_data_fifo_wrdata_be_o   <= (others => '0');
					tx_dc_data_fifo_wrreq_o       <= '0';
				-- conditional output signals

				-- state "WAITING_TX_READY"
				when WAITING_TX_READY =>
					-- wait until there is data to be fetched and space to write
					-- default output signals
					payload_writer_busy_o         <= '1';
					buffer_rdreq_o                <= '0';
					buffer_change_o               <= '0';
					tx_dc_data_fifo_wrdata_data_o <= (others => '0');
					tx_dc_data_fifo_wrdata_be_o   <= (others => '0');
					tx_dc_data_fifo_wrreq_o       <= '0';
				-- conditional output signals

				-- state "FETCH_TX_QQWORD"
				when FETCH_TX_QQWORD =>
					-- fetch tx qqword data (256b)
					-- default output signals
					payload_writer_busy_o         <= '1';
					buffer_rdreq_o                <= '1';
					buffer_change_o               <= '0';
					tx_dc_data_fifo_wrdata_data_o <= (others => '0');
					tx_dc_data_fifo_wrdata_be_o   <= (others => '0');
					tx_dc_data_fifo_wrreq_o       <= '0';
				-- conditional output signals

				-- state "FETCH_DELAY"
				when FETCH_DELAY =>
					-- fetch delay
					-- default output signals
					payload_writer_busy_o         <= '1';
					buffer_rdreq_o                <= '0';
					buffer_change_o               <= '0';
					tx_dc_data_fifo_wrdata_data_o <= (others => '0');
					tx_dc_data_fifo_wrdata_be_o   <= (others => '0');
					tx_dc_data_fifo_wrreq_o       <= '0';
				-- conditional output signals

				-- state "WRITE_TX_DWORD_0"
				when WRITE_TX_DWORD_0 =>
					-- write tx dword data 0 (32b)
					-- default output signals
					payload_writer_busy_o         <= '1';
					s_payload_crc32               <= f_ftdi_protocol_calculate_crc32(s_payload_crc32, s_tx_dword_0);
					buffer_rdreq_o                <= '0';
					buffer_change_o               <= '0';
					tx_dc_data_fifo_wrdata_data_o <= s_tx_dword_0;
					tx_dc_data_fifo_wrdata_be_o   <= (others => '1');
					tx_dc_data_fifo_wrreq_o       <= '1';
				-- conditional output signals

				-- state "WRITE_TX_DWORD_1"
				when WRITE_TX_DWORD_1 =>
					-- write tx dword data 1 (32b)
					-- default output signals
					payload_writer_busy_o         <= '1';
					s_payload_crc32               <= f_ftdi_protocol_calculate_crc32(s_payload_crc32, s_tx_dword_1);
					buffer_rdreq_o                <= '0';
					buffer_change_o               <= '0';
					tx_dc_data_fifo_wrdata_data_o <= s_tx_dword_1;
					tx_dc_data_fifo_wrdata_be_o   <= (others => '1');
					tx_dc_data_fifo_wrreq_o       <= '1';
				-- conditional output signals

				-- state "WRITE_TX_DWORD_2"
				when WRITE_TX_DWORD_2 =>
					-- write tx dword data 2 (32b)
					-- default output signals
					payload_writer_busy_o         <= '1';
					s_payload_crc32               <= f_ftdi_protocol_calculate_crc32(s_payload_crc32, s_tx_dword_2);
					buffer_rdreq_o                <= '0';
					buffer_change_o               <= '0';
					tx_dc_data_fifo_wrdata_data_o <= s_tx_dword_2;
					tx_dc_data_fifo_wrdata_be_o   <= (others => '1');
					tx_dc_data_fifo_wrreq_o       <= '1';
				-- conditional output signals

				-- state "WRITE_TX_DWORD_3"
				when WRITE_TX_DWORD_3 =>
					-- write tx dword data 3 (32b)
					-- default output signals
					payload_writer_busy_o         <= '1';
					s_payload_crc32               <= f_ftdi_protocol_calculate_crc32(s_payload_crc32, s_tx_dword_3);
					buffer_rdreq_o                <= '0';
					buffer_change_o               <= '0';
					tx_dc_data_fifo_wrdata_data_o <= s_tx_dword_3;
					tx_dc_data_fifo_wrdata_be_o   <= (others => '1');
					tx_dc_data_fifo_wrreq_o       <= '1';
				-- conditional output signals

				-- state "WRITE_TX_DWORD_4"
				when WRITE_TX_DWORD_4 =>
					-- write tx dword data 4 (32b)
					-- default output signals
					payload_writer_busy_o         <= '1';
					s_payload_crc32               <= f_ftdi_protocol_calculate_crc32(s_payload_crc32, s_tx_dword_4);
					buffer_rdreq_o                <= '0';
					buffer_change_o               <= '0';
					tx_dc_data_fifo_wrdata_data_o <= s_tx_dword_4;
					tx_dc_data_fifo_wrdata_be_o   <= (others => '1');
					tx_dc_data_fifo_wrreq_o       <= '1';
				-- conditional output signals

				-- state "WRITE_TX_DWORD_5"
				when WRITE_TX_DWORD_5 =>
					-- write tx dword data 5 (32b)
					-- default output signals
					payload_writer_busy_o         <= '1';
					s_payload_crc32               <= f_ftdi_protocol_calculate_crc32(s_payload_crc32, s_tx_dword_5);
					buffer_rdreq_o                <= '0';
					buffer_change_o               <= '0';
					tx_dc_data_fifo_wrdata_data_o <= s_tx_dword_5;
					tx_dc_data_fifo_wrdata_be_o   <= (others => '1');
					tx_dc_data_fifo_wrreq_o       <= '1';
				-- conditional output signals

				-- state "WRITE_TX_DWORD_6"
				when WRITE_TX_DWORD_6 =>
					-- write tx dword data 6 (32b)
					-- default output signals
					payload_writer_busy_o         <= '1';
					s_payload_crc32               <= f_ftdi_protocol_calculate_crc32(s_payload_crc32, s_tx_dword_6);
					buffer_rdreq_o                <= '0';
					buffer_change_o               <= '0';
					tx_dc_data_fifo_wrdata_data_o <= s_tx_dword_6;
					tx_dc_data_fifo_wrdata_be_o   <= (others => '1');
					tx_dc_data_fifo_wrreq_o       <= '1';
				-- conditional output signals

				-- state "WRITE_TX_DWORD_7"
				when WRITE_TX_DWORD_7 =>
					-- write tx dword data 7 (32b)
					-- default output signals
					payload_writer_busy_o         <= '1';
					s_payload_crc32               <= f_ftdi_protocol_calculate_crc32(s_payload_crc32, s_tx_dword_7);
					buffer_rdreq_o                <= '0';
					buffer_change_o               <= '0';
					tx_dc_data_fifo_wrdata_data_o <= s_tx_dword_7;
					tx_dc_data_fifo_wrdata_be_o   <= (others => '1');
					tx_dc_data_fifo_wrreq_o       <= '1';
				-- conditional output signals

				-- state "WRITE_DELAY"
				when WRITE_DELAY =>
					-- write delay
					-- default output signals
					payload_writer_busy_o         <= '1';
					buffer_rdreq_o                <= '0';
					buffer_change_o               <= '0';
					tx_dc_data_fifo_wrdata_data_o <= (others => '0');
					tx_dc_data_fifo_wrdata_be_o   <= (others => '0');
					tx_dc_data_fifo_wrreq_o       <= '0';
				-- conditional output signals

				-- state "CHANGE_BUFFER"
				when CHANGE_BUFFER =>
					-- change tx buffer
					-- default output signals
					payload_writer_busy_o         <= '1';
					buffer_rdreq_o                <= '0';
					buffer_change_o               <= '1';
					tx_dc_data_fifo_wrdata_data_o <= (others => '0');
					tx_dc_data_fifo_wrdata_be_o   <= (others => '0');
					tx_dc_data_fifo_wrreq_o       <= '0';
				-- conditional output signals

				-- state "WAITING_TX_SPACE_CRC"
				when WAITING_TX_SPACE_CRC =>
					-- wait until there is enough space in the tx fifo for the crc and eop 
					-- default output signals
					payload_writer_busy_o         <= '1';
					buffer_rdreq_o                <= '0';
					buffer_change_o               <= '0';
					tx_dc_data_fifo_wrdata_data_o <= (others => '0');
					tx_dc_data_fifo_wrdata_be_o   <= (others => '0');
					tx_dc_data_fifo_wrreq_o       <= '0';
				-- conditional output signals

				-- state "WRITE_TX_PAYLOAD_CRC"
				when WRITE_TX_PAYLOAD_CRC =>
					-- write the payload crc to the tx fifo
					-- default output signals
					payload_writer_busy_o         <= '1';
					s_payload_crc32               <= (others => '0');
					buffer_rdreq_o                <= '0';
					buffer_change_o               <= '0';
					tx_dc_data_fifo_wrdata_data_o <= s_payload_crc32;
					tx_dc_data_fifo_wrdata_be_o   <= (others => '1');
					tx_dc_data_fifo_wrreq_o       <= '1';
				-- conditional output signals

				-- state "WAITING_TX_SPACE_EOP"
				when WAITING_TX_SPACE_EOP =>
					-- wait until there is enough space in the tx fifo for the eop
					-- default output signals
					payload_writer_busy_o         <= '1';
					s_payload_crc32               <= (others => '0');
					buffer_rdreq_o                <= '0';
					buffer_change_o               <= '0';
					tx_dc_data_fifo_wrdata_data_o <= (others => '0');
					tx_dc_data_fifo_wrdata_be_o   <= (others => '0');
					tx_dc_data_fifo_wrreq_o       <= '0';
				-- conditional output signals

				-- state "WRITE_TX_END_OF_PAYLOAD"
				when WRITE_TX_END_OF_PAYLOAD =>
					-- write a end of payload to the tx fifo
					-- default output signals
					payload_writer_busy_o         <= '1';
					s_payload_crc32               <= (others => '0');
					buffer_rdreq_o                <= '0';
					buffer_change_o               <= '0';
					tx_dc_data_fifo_wrdata_data_o <= c_FTDI_PROT_END_OF_PAYLOAD;
					tx_dc_data_fifo_wrdata_be_o   <= (others => '1');
					tx_dc_data_fifo_wrreq_o       <= '1';
				-- conditional output signals

				-- state "FINISH_PAYLOAD_TX"
				when FINISH_PAYLOAD_TX =>
					-- finish the payload write
					-- default output signals
					payload_writer_busy_o         <= '1';
					s_payload_crc32               <= (others => '0');
					buffer_rdreq_o                <= '0';
					buffer_change_o               <= '0';
					tx_dc_data_fifo_wrdata_data_o <= (others => '0');
					tx_dc_data_fifo_wrdata_be_o   <= (others => '0');
					tx_dc_data_fifo_wrreq_o       <= '0';
					-- conditional output signals

			end case;

		end if;
	end process p_ftdi_tx_protocol_payload_writer;

	-- Signals Assingments
	s_tx_dword_0 <= buffer_rddata_i(31 downto 0);
	s_tx_dword_1 <= buffer_rddata_i(63 downto 32);
	s_tx_dword_2 <= buffer_rddata_i(95 downto 64);
	s_tx_dword_3 <= buffer_rddata_i(127 downto 96);
	s_tx_dword_4 <= buffer_rddata_i(159 downto 128);
	s_tx_dword_5 <= buffer_rddata_i(191 downto 160);
	s_tx_dword_6 <= buffer_rddata_i(223 downto 192);
	s_tx_dword_7 <= buffer_rddata_i(255 downto 224);

end architecture RTL;
