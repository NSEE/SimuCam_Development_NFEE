library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity error_injection_ent is
	port(
		clk_i                        : in  std_logic;
		rst_i                        : in  std_logic;
		spw_errinj_eep_received_i    : in  std_logic;
		spw_errinj_sequence_cnt_i    : in  std_logic_vector(15 downto 0);
		spw_errinj_n_repeat_i        : in  std_logic_vector(15 downto 0);
		trans_errinj_tx_disabled_i   : in  std_logic;
		trans_errinj_missing_pkts_i  : in  std_logic;
		trans_errinj_missing_data_i  : in  std_logic;
		trans_errinj_frame_num_i     : in  std_logic_vector(1 downto 0);
		trans_errinj_sequence_cnt_i  : in  std_logic_vector(15 downto 0);
		trans_errinj_data_cnt_i      : in  std_logic_vector(15 downto 0);
		trans_errinj_n_repeat_i      : in  std_logic_vector(15 downto 0);
		header_errinj_enable_i       : in  std_logic;
		header_errinj_frame_num_i    : in  std_logic_vector(1 downto 0);
		header_errinj_sequence_cnt_i : in  std_logic_vector(15 downto 0);
		header_errinj_field_id_i     : in  std_logic_vector(3 downto 0);
		header_errinj_value_i        : in  std_logic_vector(15 downto 0);
		errinj_spw_tx_write_i        : in  std_logic;
		errinj_spw_tx_flag_i         : in  std_logic;
		errinj_spw_tx_data_i         : in  std_logic_vector(7 downto 0);
		fee_spw_tx_ready_i           : in  std_logic;
		header_errinj_done_o         : out std_logic;
		errinj_spw_tx_ready_o        : out std_logic;
		fee_spw_tx_write_o           : out std_logic;
		fee_spw_tx_flag_o            : out std_logic;
		fee_spw_tx_data_o            : out std_logic_vector(7 downto 0)
	);
end entity error_injection_ent;

architecture RTL of error_injection_ent is

	type t_errinj_controller_state is (
		IDLE,                           -- error injection controller idle
		COLLECT_PACKET_HEADER,          -- collect entire packet header
		PROCESS_PACKET_HEADER,          -- process packet header
		TRANSMIT_ENTIRE_PACKET,         -- transmit entire packet (no error)
		ERRINJ_TX_DISABLED,             -- inject tx disabled error
		ERRINJ_MISSING_PKTS,            -- inject missing packets error
		ERRINJ_MISSING_DATA             -- inject missing data error
	);
	signal s_errinj_controller_state : t_errinj_controller_state;

	type t_data_packet_header is array (0 to 9) of std_logic_vector(7 downto 0);
	signal s_data_packet_header : t_data_packet_header;

	alias a_dpkt_logical_addr      : std_logic_vector(7 downto 0) is s_data_packet_header(0)(7 downto 0);
	alias a_dpkt_protocol_id       : std_logic_vector(7 downto 0) is s_data_packet_header(1)(7 downto 0);
	alias a_dpkt_length_msb        : std_logic_vector(7 downto 0) is s_data_packet_header(2)(7 downto 0);
	alias a_dpkt_length_lsb        : std_logic_vector(7 downto 0) is s_data_packet_header(3)(7 downto 0);
	alias a_dpkt_type_reserved     : std_logic_vector(4 downto 0) is s_data_packet_header(4)(7 downto 3);
	alias a_dpkt_type_mode         : std_logic_vector(3 downto 0) is s_data_packet_header(4)(3 downto 0);
	alias a_dpkt_type_last_pkt     : std_logic is s_data_packet_header(5)(7);
	alias a_dpkt_type_ccd_side     : std_logic is s_data_packet_header(5)(6);
	alias a_dpkt_type_ccd_number   : std_logic_vector(1 downto 0) is s_data_packet_header(5)(5 downto 4);
	alias a_dpkt_type_frame_number : std_logic_vector(1 downto 0) is s_data_packet_header(5)(3 downto 2);
	alias a_dpkt_type_pkt_type     : std_logic_vector(1 downto 0) is s_data_packet_header(5)(1 downto 0);
	alias a_dpkt_frame_cnt_msb     : std_logic_vector(7 downto 0) is s_data_packet_header(6)(7 downto 0);
	alias a_dpkt_frame_cnt_lsb     : std_logic_vector(7 downto 0) is s_data_packet_header(7)(7 downto 0);
	alias a_dpkt_sequence_cnt_msb  : std_logic_vector(7 downto 0) is s_data_packet_header(8)(7 downto 0);
	alias a_dpkt_sequence_cnt_lsb  : std_logic_vector(7 downto 0) is s_data_packet_header(9)(7 downto 0);

	signal s_header_cnt : natural range 0 to 10;

	constant c_HEADER_ERRINJ_FIELD_ID_MODE      : std_logic_vector(3 downto 0) := x"0";
	constant c_HEADER_ERRINJ_FIELD_ID_LAST_PKT  : std_logic_vector(3 downto 0) := x"1";
	constant c_HEADER_ERRINJ_FIELD_ID_CCD_SIDE  : std_logic_vector(3 downto 0) := x"2";
	constant c_HEADER_ERRINJ_FIELD_ID_CCD_NUM   : std_logic_vector(3 downto 0) := x"3";
	constant c_HEADER_ERRINJ_FIELD_ID_FRAME_NUM : std_logic_vector(3 downto 0) := x"4";
	constant c_HEADER_ERRINJ_FIELD_ID_PKT_TYPE  : std_logic_vector(3 downto 0) := x"5";
	constant c_HEADER_ERRINJ_FIELD_ID_FRAME_CNT : std_logic_vector(3 downto 0) := x"6";
	constant c_HEADER_ERRINJ_FIELD_ID_SEQ_CNT   : std_logic_vector(3 downto 0) := x"7";
	constant c_HEADER_ERRINJ_FIELD_ID_LENGTH    : std_logic_vector(3 downto 0) := x"8";

	signal s_spw_sequence_cnt : std_logic_vector(15 downto 0);
	signal s_spw_repeat_cnt   : std_logic_vector(15 downto 0);

	signal s_trans_sequence_cnt : std_logic_vector(15 downto 0);
	signal s_trans_data_cnt     : std_logic_vector(15 downto 0);
	signal s_trans_repeat_cnt   : std_logic_vector(15 downto 0);

	signal s_pkt_byte_cnt : std_logic_vector(15 downto 0);

	signal s_pkt_byte_sent : std_logic;

	signal s_errinj_spw_tx_ready : std_logic;

begin

	p_trans_error_injection : process(clk_i, rst_i) is
		variable v_errinj_controller_state : t_errinj_controller_state     := IDLE;
		variable v_error_injected          : std_logic                     := '0';
		variable v_packet_length           : std_logic_vector(15 downto 0) := (others => '0');
	begin
		if (rst_i = '1') then
			-- fsm state reset
			s_errinj_controller_state <= IDLE;
			v_errinj_controller_state := IDLE;
			-- internal signals reset
			s_header_cnt              <= 0;
			s_data_packet_header      <= (others => x"00");
			s_spw_sequence_cnt        <= (others => '0');
			s_spw_repeat_cnt          <= (others => '0');
			s_trans_sequence_cnt      <= (others => '0');
			s_trans_data_cnt          <= (others => '0');
			s_trans_repeat_cnt        <= (others => '0');
			s_pkt_byte_cnt            <= (others => '0');
			s_pkt_byte_sent           <= '0';
			s_errinj_spw_tx_ready     <= '0';
			v_error_injected          := '0';
			v_packet_length           := (others => '0');
			-- outputs reset
			header_errinj_done_o      <= '0';
			fee_spw_tx_write_o        <= '0';
			fee_spw_tx_flag_o         <= '0';
			fee_spw_tx_data_o         <= x"00";
		elsif (rising_edge(clk_i)) then

			-- States transitions FSM
			case (s_errinj_controller_state) is

				-- state "IDLE"
				when IDLE =>
					-- error injection controller idle
					-- default state transition
					s_errinj_controller_state <= COLLECT_PACKET_HEADER;
					v_errinj_controller_state := COLLECT_PACKET_HEADER;
					-- default internal signal values
					s_header_cnt              <= 0;
					s_pkt_byte_cnt            <= (others => '0');
					s_pkt_byte_sent           <= '0';
					s_errinj_spw_tx_ready     <= '0';
					v_error_injected          := '0';
					v_packet_length           := (others => '0');
					header_errinj_done_o      <= '0';
					fee_spw_tx_write_o        <= '0';
					fee_spw_tx_flag_o         <= '0';
					fee_spw_tx_data_o         <= x"00";
				-- conditional state transition

				-- state "COLLECT_PACKET_HEADER"
				when COLLECT_PACKET_HEADER =>
					-- collect entire packet header
					-- default state transition
					s_errinj_controller_state <= COLLECT_PACKET_HEADER;
					v_errinj_controller_state := COLLECT_PACKET_HEADER;
					-- default internal signal values
					s_pkt_byte_cnt            <= (others => '0');
					s_pkt_byte_sent           <= '0';
					s_errinj_spw_tx_ready     <= '1';
					v_error_injected          := '0';
					v_packet_length           := (others => '0');
					header_errinj_done_o      <= '0';
					fee_spw_tx_write_o        <= '0';
					fee_spw_tx_flag_o         <= '0';
					fee_spw_tx_data_o         <= x"00";
					-- conditional state transition
					-- check if a write was requested
					if (errinj_spw_tx_write_i = '1') then
						-- write requested
						-- check if its a end of package (error ocurred)
						if (errinj_spw_tx_flag_i = '1') then
							-- end of package, return to idle
							fee_spw_tx_write_o        <= '1';
							fee_spw_tx_flag_o         <= '1';
							fee_spw_tx_data_o         <= x"01";
							s_errinj_controller_state <= IDLE;
							v_errinj_controller_state := IDLE;
						else
							-- not end of package, collect data
							s_data_packet_header(s_header_cnt) <= errinj_spw_tx_data_i;
							-- check if all header was collected
							if (s_header_cnt = 9) then
								-- all header collected, go to process packet header
								s_header_cnt              <= 0;
								s_errinj_spw_tx_ready     <= '0';
								s_errinj_controller_state <= PROCESS_PACKET_HEADER;
								v_errinj_controller_state := PROCESS_PACKET_HEADER;
							else
								-- more header to collect, increment header counter
								s_header_cnt <= s_header_cnt + 1;
							end if;
						end if;
					end if;

				-- state "PROCESS_PACKET_HEADER"
				when PROCESS_PACKET_HEADER =>
					-- process packet header
					-- default state transition
					s_errinj_controller_state    <= TRANSMIT_ENTIRE_PACKET;
					v_errinj_controller_state    := TRANSMIT_ENTIRE_PACKET;
					-- default internal signal values
					s_header_cnt                 <= 0;
					s_pkt_byte_cnt               <= (others => '0');
					s_pkt_byte_sent              <= '0';
					s_errinj_spw_tx_ready        <= '0';
					v_error_injected             := '0';
					v_packet_length(15 downto 8) := a_dpkt_length_msb;
					v_packet_length(7 downto 0)  := a_dpkt_length_lsb;
					header_errinj_done_o         <= '0';
					fee_spw_tx_write_o           <= '0';
					fee_spw_tx_flag_o            <= '0';
					fee_spw_tx_data_o            <= x"00";
					-- conditional state transition
					-- check if it is the first pkt in a sequence
					if ((a_dpkt_sequence_cnt_msb = x"00") and (a_dpkt_sequence_cnt_lsb = x"00")) then
						-- it is the first pkt in a sequence (start of readout)
						-- check if received eep error injection is enabled
						if (spw_errinj_eep_received_i = '1') then
							-- received eep error injection is enabled
							-- update spw counters
							s_spw_sequence_cnt <= spw_errinj_sequence_cnt_i;
							s_spw_repeat_cnt   <= spw_errinj_n_repeat_i;
						end if;
					end if;
					-- check if the header error injection is enabled
					if (header_errinj_enable_i = '1') then
						-- the header error injection is enabled
						-- check if a header error need to be injected in the current frame number
						if (header_errinj_frame_num_i = a_dpkt_type_frame_number) then
							-- a header error need to be injected in the current frame number
							-- check if a header error need to be injected in the current sequence counter
							if ((header_errinj_sequence_cnt_i(15 downto 8) = a_dpkt_sequence_cnt_msb) and (header_errinj_sequence_cnt_i(7 downto 0) = a_dpkt_sequence_cnt_lsb)) then
								-- a header error need to be injected in the current sequence counter
								-- inject the correct header field error
								case (header_errinj_field_id_i) is
									when c_HEADER_ERRINJ_FIELD_ID_MODE =>
										a_dpkt_type_mode <= header_errinj_value_i(3 downto 0);
									when c_HEADER_ERRINJ_FIELD_ID_LAST_PKT =>
										a_dpkt_type_last_pkt <= header_errinj_value_i(0);
									when c_HEADER_ERRINJ_FIELD_ID_CCD_SIDE =>
										a_dpkt_type_ccd_side <= header_errinj_value_i(0);
									when c_HEADER_ERRINJ_FIELD_ID_CCD_NUM =>
										a_dpkt_type_ccd_number <= header_errinj_value_i(1 downto 0);
									when c_HEADER_ERRINJ_FIELD_ID_FRAME_NUM =>
										a_dpkt_type_frame_number <= header_errinj_value_i(1 downto 0);
									when c_HEADER_ERRINJ_FIELD_ID_PKT_TYPE =>
										a_dpkt_type_pkt_type <= header_errinj_value_i(1 downto 0);
									when c_HEADER_ERRINJ_FIELD_ID_FRAME_CNT =>
										a_dpkt_frame_cnt_msb <= header_errinj_value_i(15 downto 8);
										a_dpkt_frame_cnt_lsb <= header_errinj_value_i(7 downto 0);
									when c_HEADER_ERRINJ_FIELD_ID_SEQ_CNT =>
										a_dpkt_sequence_cnt_msb <= header_errinj_value_i(15 downto 8);
										a_dpkt_sequence_cnt_lsb <= header_errinj_value_i(7 downto 0);
									when c_HEADER_ERRINJ_FIELD_ID_LENGTH =>
										a_dpkt_length_msb <= header_errinj_value_i(15 downto 8);
										a_dpkt_length_lsb <= header_errinj_value_i(7 downto 0);
									when others =>
										null;
								end case;
								-- set the header error injection done flag
								header_errinj_done_o <= '1';
							end if;
						end if;
						-- clear transmission error counters
						s_trans_sequence_cnt <= (others => '0');
						s_trans_data_cnt     <= (others => '0');
						s_trans_repeat_cnt   <= (others => '0');
					else
						-- the header error injection is disabled
						-- check if a transmission error can be injected in the frame number
						if (trans_errinj_frame_num_i = a_dpkt_type_frame_number) then
							-- a transmission error can be injected in the frame number
							-- check if it is the first pkt in a sequence
							if ((a_dpkt_sequence_cnt_msb = x"00") and (a_dpkt_sequence_cnt_lsb = x"00")) then
								-- first pkt in a sequence, set internal counter value
								s_trans_sequence_cnt <= trans_errinj_sequence_cnt_i;
								s_trans_data_cnt     <= trans_errinj_data_cnt_i;
								s_trans_repeat_cnt   <= trans_errinj_n_repeat_i;
							end if;
							-- check if a tx disabled error is injected
							if (trans_errinj_tx_disabled_i = '1') then
								-- tx disabled error is injected
								s_errinj_controller_state <= ERRINJ_TX_DISABLED;
								v_errinj_controller_state := ERRINJ_TX_DISABLED;
							-- check if a missing packets error is injected	
							elsif (trans_errinj_missing_pkts_i = '1') then
								-- missing packets error is injected
								s_errinj_controller_state <= ERRINJ_MISSING_PKTS;
								v_errinj_controller_state := ERRINJ_MISSING_PKTS;
							-- check if a missing data error is injected
							elsif (trans_errinj_missing_data_i = '1') then
								-- missing data error is injected
								s_errinj_controller_state <= ERRINJ_MISSING_DATA;
								v_errinj_controller_state := ERRINJ_MISSING_DATA;
							end if;
						else
							-- a transmission error cannot be injected in the frame number, clear counters
							s_trans_sequence_cnt <= (others => '0');
							s_trans_data_cnt     <= (others => '0');
							s_trans_repeat_cnt   <= (others => '0');
						end if;
					end if;

				-- state "TRANSMIT_ENTIRE_PACKET"
				when TRANSMIT_ENTIRE_PACKET =>
					-- transmit entire packet (no error)
					-- default state transition
					s_errinj_controller_state <= TRANSMIT_ENTIRE_PACKET;
					v_errinj_controller_state := TRANSMIT_ENTIRE_PACKET;
					-- default internal signal values
					s_trans_sequence_cnt      <= (others => '0');
					s_trans_data_cnt          <= (others => '0');
					s_trans_repeat_cnt        <= (others => '0');
					s_pkt_byte_cnt            <= (others => '0');
					s_pkt_byte_sent           <= '0';
					s_errinj_spw_tx_ready     <= '0';
					v_error_injected          := '0';
					v_packet_length           := (others => '0');
					header_errinj_done_o      <= '0';
					fee_spw_tx_write_o        <= '0';
					fee_spw_tx_flag_o         <= '0';
					fee_spw_tx_data_o         <= x"00";
					-- conditional state transition
					-- check if the header finished transmitting
					if (s_header_cnt = 10) then
						-- header finished transmitting
						-- check if a write was requested
						s_errinj_spw_tx_ready <= '1';
						if (errinj_spw_tx_write_i = '1') then
							-- write requested
							-- pass write forward to spw coded
							fee_spw_tx_write_o <= '1';
							fee_spw_tx_flag_o  <= errinj_spw_tx_flag_i;
							fee_spw_tx_data_o  <= errinj_spw_tx_data_i;
							-- check if its a end of package
							if (errinj_spw_tx_flag_i = '1') then
								-- end of package, return to idle
								s_errinj_spw_tx_ready     <= '0';
								s_errinj_controller_state <= IDLE;
								v_errinj_controller_state := IDLE;
							end if;
						end if;
					else
						-- header still transmitting
						-- check if the spw codec can receive data
						if (fee_spw_tx_ready_i = '1') then
							-- spw codec can receive data
							-- write header
							s_errinj_spw_tx_ready <= '0';
							fee_spw_tx_write_o    <= '1';
							fee_spw_tx_flag_o     <= '0';
							fee_spw_tx_data_o     <= s_data_packet_header(s_header_cnt);
							-- increment header counter
							s_header_cnt          <= s_header_cnt + 1;
						end if;
					end if;

				-- state "ERRINJ_TX_DISABLED"
				when ERRINJ_TX_DISABLED =>
					-- inject tx disabled error
					-- default state transition
					s_errinj_controller_state <= ERRINJ_TX_DISABLED;
					v_errinj_controller_state := ERRINJ_TX_DISABLED;
					-- default internal signal values
					s_trans_sequence_cnt      <= (others => '0');
					s_trans_data_cnt          <= (others => '0');
					s_trans_repeat_cnt        <= (others => '0');
					s_pkt_byte_cnt            <= (others => '0');
					s_pkt_byte_sent           <= '0';
					s_errinj_spw_tx_ready     <= '0';
					v_error_injected          := '1';
					v_packet_length           := (others => '0');
					header_errinj_done_o      <= '0';
					fee_spw_tx_write_o        <= '0';
					fee_spw_tx_flag_o         <= '0';
					fee_spw_tx_data_o         <= x"00";
					-- conditional state transition
					-- check if the header finished transmitting
					if (s_header_cnt = 10) then
						-- header finished transmitting
						-- check if a write was requested
						s_errinj_spw_tx_ready <= '1';
						if (errinj_spw_tx_write_i = '1') then
							-- write requested
							-- pass write forward to spw coded
							fee_spw_tx_write_o <= '0';
							fee_spw_tx_flag_o  <= errinj_spw_tx_flag_i;
							fee_spw_tx_data_o  <= errinj_spw_tx_data_i;
							-- check if its a end of package
							if (errinj_spw_tx_flag_i = '1') then
								-- end of package, return to idle
								s_errinj_spw_tx_ready     <= '0';
								s_errinj_controller_state <= IDLE;
								v_errinj_controller_state := IDLE;
							end if;
						end if;
					else
						-- header still transmitting
						-- check if the spw codec can receive data
						if (fee_spw_tx_ready_i = '1') then
							-- spw codec can receive data
							-- write header
							s_errinj_spw_tx_ready <= '0';
							fee_spw_tx_write_o    <= '0';
							fee_spw_tx_flag_o     <= '0';
							fee_spw_tx_data_o     <= s_data_packet_header(s_header_cnt);
							-- increment header counter
							s_header_cnt          <= s_header_cnt + 1;
						end if;
					end if;

				-- state "ERRINJ_MISSING_PKTS"
				when ERRINJ_MISSING_PKTS =>
					-- inject missing packets error
					-- default state transition
					s_errinj_controller_state <= ERRINJ_MISSING_PKTS;
					v_errinj_controller_state := ERRINJ_MISSING_PKTS;
					-- default internal signal values
					s_trans_data_cnt          <= (others => '0');
					s_pkt_byte_cnt            <= (others => '0');
					s_pkt_byte_sent           <= '0';
					s_errinj_spw_tx_ready     <= '0';
					v_error_injected          := '0';
					v_packet_length           := (others => '0');
					header_errinj_done_o      <= '0';
					fee_spw_tx_write_o        <= '0';
					fee_spw_tx_flag_o         <= '0';
					fee_spw_tx_data_o         <= x"00";
					-- check if the packet is written or not (inject missing pkt error)
					if ((s_trans_sequence_cnt(15 downto 8) = a_dpkt_sequence_cnt_msb) and (s_trans_sequence_cnt(7 downto 0) = a_dpkt_sequence_cnt_lsb)) then
						-- packet is not written
						v_error_injected := '1';
					end if;
					-- conditional state transition
					-- check if the header finished transmitting
					if (s_header_cnt = 10) then
						-- header finished transmitting
						-- check if a write was requested
						s_errinj_spw_tx_ready <= '1';
						if (errinj_spw_tx_write_i = '1') then
							-- write requested
							-- pass write forward to spw coded
							fee_spw_tx_write_o <= not (v_error_injected);
							fee_spw_tx_flag_o  <= errinj_spw_tx_flag_i;
							fee_spw_tx_data_o  <= errinj_spw_tx_data_i;
							-- check if its a end of package
							if (errinj_spw_tx_flag_i = '1') then
								-- end of package, return to idle
								-- check if an error was injected
								if (v_error_injected = '1') then
									-- check if the sequence counter need to be incremented
									if (s_trans_repeat_cnt /= x"0000") then
										-- need to incremet sequence counter
										s_trans_sequence_cnt <= std_logic_vector(unsigned(s_trans_sequence_cnt) + 1);
										s_trans_repeat_cnt   <= std_logic_vector(unsigned(s_trans_repeat_cnt) - 1);
									end if;
								end if;
								s_errinj_spw_tx_ready     <= '0';
								s_errinj_controller_state <= IDLE;
								v_errinj_controller_state := IDLE;
								-- check if an eep need to be injected
							end if;
						end if;
					else
						-- header still transmitting
						-- check if the spw codec can receive data
						if (fee_spw_tx_ready_i = '1') then
							-- spw codec can receive data
							-- write header
							s_errinj_spw_tx_ready <= '0';
							fee_spw_tx_write_o    <= not (v_error_injected);
							fee_spw_tx_flag_o     <= '0';
							fee_spw_tx_data_o     <= s_data_packet_header(s_header_cnt);
							-- increment header counter
							s_header_cnt          <= s_header_cnt + 1;
						end if;
					end if;

				-- state "ERRINJ_MISSING_DATA"
				when ERRINJ_MISSING_DATA =>
					-- inject missing data error
					-- default state transition
					s_errinj_controller_state <= ERRINJ_MISSING_DATA;
					v_errinj_controller_state := ERRINJ_MISSING_DATA;
					-- default internal signal values
					s_errinj_spw_tx_ready     <= '0';
					v_error_injected          := '0';
					header_errinj_done_o      <= '0';
					fee_spw_tx_write_o        <= '0';
					fee_spw_tx_flag_o         <= '0';
					fee_spw_tx_data_o         <= x"00";
					-- check if the packet is written or not (inject missing data error)
					if (((s_trans_sequence_cnt(15 downto 8) = a_dpkt_sequence_cnt_msb) and (s_trans_sequence_cnt(7 downto 0) = a_dpkt_sequence_cnt_lsb)) and (s_trans_data_cnt = s_pkt_byte_cnt)) then
						-- packet is not written
						v_error_injected := '1';
					end if;
					-- conditional state transition
					-- check if the header finished transmitting
					if (s_header_cnt = 10) then
						-- header finished transmitting
						-- check if a write was requested
						s_errinj_spw_tx_ready <= '1';
						if (errinj_spw_tx_write_i = '1') then
							-- write requested
							-- pass write forward to spw coded
							fee_spw_tx_write_o <= not (v_error_injected);
							fee_spw_tx_flag_o  <= errinj_spw_tx_flag_i;
							fee_spw_tx_data_o  <= errinj_spw_tx_data_i;
							-- increment packet byte counter
							s_pkt_byte_cnt     <= std_logic_vector(unsigned(s_pkt_byte_cnt) + 1);
							-- check if an error was injected
							if (v_error_injected = '1') then
								-- check if the data counter need to be incremented
								if (s_trans_repeat_cnt /= x"0000") then
									-- need to incremet sequence counter
									s_trans_data_cnt   <= std_logic_vector(unsigned(s_trans_data_cnt) + 1);
									s_trans_repeat_cnt <= std_logic_vector(unsigned(s_trans_repeat_cnt) - 1);
								end if;
							end if;
							-- check if its a end of package
							if (errinj_spw_tx_flag_i = '1') then
								-- end of package, return to idle
								-- write end of package
								fee_spw_tx_write_o        <= '1';
								s_errinj_spw_tx_ready     <= '0';
								s_errinj_controller_state <= IDLE;
								v_errinj_controller_state := IDLE;
							end if;
						end if;
					else
						-- header still transmitting
						-- check if the spw codec can receive data
						if (fee_spw_tx_ready_i = '1') then
							-- spw codec can receive data
							-- write header
							s_errinj_spw_tx_ready <= '0';
							fee_spw_tx_write_o    <= '1';
							fee_spw_tx_flag_o     <= '0';
							fee_spw_tx_data_o     <= s_data_packet_header(s_header_cnt);
							-- increment packet byte counter
							s_pkt_byte_cnt        <= (others => '0');
							-- check if the packet length need to be changed
							if (((s_trans_sequence_cnt(15 downto 8) = a_dpkt_sequence_cnt_msb) and (s_trans_sequence_cnt(7 downto 0) = a_dpkt_sequence_cnt_lsb)) and (s_header_cnt = 0)) then
								-- packet length need to be changed
								-- check if the data offset is inside the pkt
								if (unsigned(s_trans_data_cnt) < unsigned(v_packet_length)) then
									-- data offset is inside the pkt
									-- check if the current repeat value is acceptable
									if (unsigned(s_trans_repeat_cnt) < (unsigned(v_packet_length) - unsigned(s_trans_data_cnt) - 1)) then
										-- current repeat value is acceptable
										v_packet_length := std_logic_vector(unsigned(v_packet_length) - unsigned(s_trans_repeat_cnt) - 1);
									else
										v_packet_length := std_logic_vector(unsigned(s_trans_data_cnt));
									end if;
									-- update pkt length
									a_dpkt_length_msb <= v_packet_length(15 downto 8);
									a_dpkt_length_lsb <= v_packet_length(7 downto 0);
								end if;
							end if;
							-- increment header counter
							s_header_cnt          <= s_header_cnt + 1;
						end if;
					end if;

				-- all the other states (not defined)
				when others =>
					s_errinj_controller_state <= IDLE;
					v_errinj_controller_state := IDLE;

			end case;

			-- Output generation FSM
			case (v_errinj_controller_state) is

				-- state "IDLE"
				when IDLE =>
					-- error injection controller idle
					-- default output signals
					-- conditional output signals

					-- state "COLLECT_PACKET_HEADER"
				when COLLECT_PACKET_HEADER =>
					-- collect entire packet header
					-- default output signals
					-- conditional output signals

					-- state "PROCESS_PACKET_HEADER"
				when PROCESS_PACKET_HEADER =>
					-- process packet header
					-- default output signals
					-- conditional output signals

					-- state "TRANSMIT_ENTIRE_PACKET"
				when TRANSMIT_ENTIRE_PACKET =>
					-- transmit entire packet (no error)
					-- default output signals
					-- conditional output signals

					-- state "ERRINJ_TX_DISABLED"
				when ERRINJ_TX_DISABLED =>
					-- inject tx disabled error
					-- default output signals
					-- conditional output signals

					-- state "ERRINJ_MISSING_PKTS"
				when ERRINJ_MISSING_PKTS =>
					-- inject missing packets error
					-- default output signals
					-- conditional output signals

					-- state "ERRINJ_MISSING_DATA"
				when ERRINJ_MISSING_DATA =>
					-- inject missing data error
					-- default output signals
					-- conditional output signals

			end case;

			-- spw error injection generation
			-- check if the spw eep received error injection is enabled
			if (spw_errinj_eep_received_i = '1') then
				-- the spw eep received error injection is enabled
				-- check if its a end of package
				if (errinj_spw_tx_flag_i = '1') then
					-- its a end of package
					-- check if an eep need to be inserted in the current packet
					if (((s_spw_sequence_cnt(15 downto 8) = a_dpkt_sequence_cnt_msb) and (s_spw_sequence_cnt(7 downto 0) = a_dpkt_sequence_cnt_lsb))) then
						-- an eep need to be inserted in the current packet
						-- write error end of package
						--						fee_spw_tx_write_o    <= '1';
						fee_spw_tx_write_o    <= not (v_error_injected);
						fee_spw_tx_flag_o     <= '1';
						fee_spw_tx_data_o     <= x"01"; -- eep id is 0x01
						s_errinj_spw_tx_ready <= '0';
						-- check if the spw error need to be repeated
						if (s_spw_repeat_cnt /= x"0000") then
							-- the spw error need to be repeated
							-- increment the sequence counter
							s_spw_sequence_cnt <= std_logic_vector(unsigned(s_spw_sequence_cnt) + 1);
							-- decrement the repeat counter
							s_spw_repeat_cnt   <= std_logic_vector(unsigned(s_spw_repeat_cnt) - 1);
						end if;
					end if;
				end if;
			end if;

		end if;
	end process p_trans_error_injection;

	-- Signals Assignments --

	-- Error Injection Spw Status Assignments
	errinj_spw_tx_ready_o <= (s_errinj_spw_tx_ready) when (fee_spw_tx_ready_i = '1') else ('0');

end architecture RTL;
