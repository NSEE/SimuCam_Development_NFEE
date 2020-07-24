library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.avalon_mm_spacewire_registers_pkg.all;

entity config_avalon_stimuli is
	generic(
		g_ADDRESS_WIDTH : natural range 1 to 64;
		g_DATA_WIDTH    : natural range 1 to 64
	);
	port(
		clk_i                   : in  std_logic;
		rst_i                   : in  std_logic;
		avalon_mm_readdata_i    : in  std_logic_vector((g_DATA_WIDTH - 1) downto 0); -- -- avalon_mm.readdata
		avalon_mm_waitrequest_i : in  std_logic; --                                     --          .waitrequest
		avalon_mm_address_o     : out std_logic_vector((g_ADDRESS_WIDTH - 1) downto 0); --          .address
		avalon_mm_write_o       : out std_logic; --                                     --          .write
		avalon_mm_writedata_o   : out std_logic_vector((g_DATA_WIDTH - 1) downto 0); -- --          .writedata
		avalon_mm_read_o        : out std_logic --                                      --          .read
	);
end entity config_avalon_stimuli;

architecture RTL of config_avalon_stimuli is

	signal s_counter : natural := 0;

	-- Registers Here
	--	alias a_wr_windowing_control_mask_enable           : std_logic is avalon_mm_writedata_o(8);
	--	alias a_wr_windowing_control_autostart             : std_logic is avalon_mm_writedata_o(2);
	--	alias a_wr_windowing_control_linkstart             : std_logic is avalon_mm_writedata_o(1);
	--	alias a_wr_windowing_control_linkdis               : std_logic is avalon_mm_writedata_o(0);
	--	alias a_wr_timecode_rx_flags_rx_received_clear     : std_logic is avalon_mm_writedata_o(0);
	--	alias a_wr_timecode_tx_register_tx_control         : std_logic_vector(1 downto 0) is avalon_mm_writedata_o(8 downto 7);
	--	alias a_wr_timecode_tx_register_tx_time            : std_logic_vector(5 downto 0) is avalon_mm_writedata_o(6 downto 1);
	--	alias a_wr_timecode_tx_register_tx_send            : std_logic is avalon_mm_writedata_o(0);
	--	alias a_wr_interrupt_flag_clear_buffer_empty_flag  : std_logic is avalon_mm_writedata_o(0);
	--	alias a_wr_interrupt_control_L_buffer_empty_enable : std_logic is avalon_mm_writedata_o(8);
	--	alias a_wr_interrupt_control_R_buffer_empty_enable : std_logic is avalon_mm_writedata_o(0);

	-- fee mode constants
	constant c_DPKT_OFF_MODE                       : std_logic_vector(4 downto 0) := "00000"; -- d0 : N-FEE Off Mode
	constant c_DPKT_ON_MODE                        : std_logic_vector(4 downto 0) := "00001"; -- d1 : N-FEE On Mode
	constant c_DPKT_FULLIMAGE_PATTERN_MODE         : std_logic_vector(4 downto 0) := "00010"; -- d2 : N-FEE Full-Image Pattern Mode
	constant c_DPKT_WINDOWING_PATTERN_MODE         : std_logic_vector(4 downto 0) := "00011"; -- d3 : N-FEE Windowing Pattern Mode
	constant c_DPKT_STANDBY_MODE                   : std_logic_vector(4 downto 0) := "00100"; -- d4 : N-FEE Standby Mode
	constant c_DPKT_FULLIMAGE_MODE_PATTERN_MODE    : std_logic_vector(4 downto 0) := "00101"; -- d5 : N-FEE Full-Image Mode / Pattern Mode
	constant c_DPKT_FULLIMAGE_MODE_SSD_MODE        : std_logic_vector(4 downto 0) := "00110"; -- d6 : N-FEE Full-Image Mode / SSD Mode
	constant c_DPKT_WINDOWING_MODE_PATTERN_MODE    : std_logic_vector(4 downto 0) := "00111"; -- d7 : N-FEE Windowing Mode / Pattern Mode
	constant c_DPKT_WINDOWING_MODE_SSDIMG_MODE     : std_logic_vector(4 downto 0) := "01000"; -- d8 : N-FEE Windowing Mode / SSD Image Mode
	constant c_DPKT_WINDOWING_MODE_SSDWIN_MODE     : std_logic_vector(4 downto 0) := "01001"; -- d9 : N-FEE Windowing Mode / SSD Window Mode
	constant c_DPKT_PERFORMANCE_TEST_MODE          : std_logic_vector(4 downto 0) := "01010"; -- d10: N-FEE Performance Test Mode
	constant c_DPKT_PAR_TRAP_PUMP_1_MODE_PUMP_MODE : std_logic_vector(4 downto 0) := "01011"; -- d11: N-FEE Parallel Trap Pumping 1 Mode / Pumping Mode
	constant c_DPKT_PAR_TRAP_PUMP_1_MODE_DATA_MODE : std_logic_vector(4 downto 0) := "01100"; -- d12: N-FEE Parallel Trap Pumping 1 Mode / Data Emiting Mode
	constant c_DPKT_PAR_TRAP_PUMP_2_MODE_PUMP_MODE : std_logic_vector(4 downto 0) := "01101"; -- d13: N-FEE Parallel Trap Pumping 2 Mode / Pumping Mode
	constant c_DPKT_PAR_TRAP_PUMP_2_MODE_DATA_MODE : std_logic_vector(4 downto 0) := "01110"; -- d14: N-FEE Parallel Trap Pumping 2 Mode / Data Emiting Mode
	constant c_DPKT_SER_TRAP_PUMP_1_MODE           : std_logic_vector(4 downto 0) := "01111"; -- d15: N-FEE Serial Trap Pumping 1 Mode
	constant c_DPKT_SER_TRAP_PUMP_2_MODE           : std_logic_vector(4 downto 0) := "10000"; -- d16: N-FEE Serial Trap Pumping 2 Mode

begin

	p_config_avalon_stimuli : process(clk_i, rst_i) is
	begin
		if (rst_i = '1') then

			avalon_mm_address_o   <= (others => '0');
			avalon_mm_write_o     <= '0';
			avalon_mm_writedata_o <= (others => '0');
			avalon_mm_read_o      <= '0';
			s_counter             <= 0;

		elsif rising_edge(clk_i) then

			avalon_mm_address_o   <= (others => '0');
			avalon_mm_write_o     <= '0';
			avalon_mm_writedata_o <= (others => '0');
			avalon_mm_read_o      <= '0';
			s_counter             <= s_counter + 1;

			case s_counter is

				-- spw_timecode_config_reg
				when 300 to 301 =>
					-- register write
					avalon_mm_address_o      <= std_logic_vector(to_unsigned(16#0E#, g_ADDRESS_WIDTH));
					avalon_mm_write_o        <= '1';
					avalon_mm_writedata_o    <= (others => '0');
					avalon_mm_writedata_o(0) <= '1'; -- timecode_clear

				-- spw_timecode_config_reg
				when 310 to 311 =>
					-- register write
					avalon_mm_address_o      <= std_logic_vector(to_unsigned(16#0F#, g_ADDRESS_WIDTH));
					avalon_mm_write_o        <= '1';
					avalon_mm_writedata_o    <= (others => '0');
					avalon_mm_writedata_o(0) <= '1'; -- timecode_trans_en

				-- spw_timecode_config_reg
				when 320 to 321 =>
					-- register write
					avalon_mm_address_o      <= std_logic_vector(to_unsigned(16#10#, g_ADDRESS_WIDTH));
					avalon_mm_write_o        <= '1';
					avalon_mm_writedata_o    <= (others => '0');
					avalon_mm_writedata_o(0) <= '1'; -- timecode_sync_trigger_en

				-- spw_timecode_config_reg
				when 330 to 331 =>
					-- register write
					avalon_mm_address_o               <= std_logic_vector(to_unsigned(16#11#, g_ADDRESS_WIDTH));
					avalon_mm_write_o                 <= '1';
					avalon_mm_writedata_o             <= (others => '0');
					avalon_mm_writedata_o(5 downto 0) <= std_logic_vector(to_unsigned(0, 6)); -- timecode_time_offset

				-- spw_timecode_config_reg
				when 340 to 341 =>
					-- register write
					avalon_mm_address_o      <= std_logic_vector(to_unsigned(16#12#, g_ADDRESS_WIDTH));
					avalon_mm_write_o        <= '1';
					avalon_mm_writedata_o    <= (others => '0');
					avalon_mm_writedata_o(0) <= '0'; -- timecode_sync_delay_trigger_en

				-- spw_timecode_config_reg
				when 350 to 351 =>
					-- register write
					avalon_mm_address_o   <= std_logic_vector(to_unsigned(16#13#, g_ADDRESS_WIDTH));
					avalon_mm_write_o     <= '1';
					avalon_mm_writedata_o <= (others => '0');
					avalon_mm_writedata_o <= std_logic_vector(to_unsigned(0, 32)); -- timecode_sync_delay_value

				-- spw_error_injection_control_reg
				when 370 to 371 =>
					-- register write
					avalon_mm_address_o      <= std_logic_vector(to_unsigned(16#70#, g_ADDRESS_WIDTH));
					avalon_mm_write_o        <= '1';
					avalon_mm_writedata_o    <= (others => '0');
					avalon_mm_writedata_o(0) <= '0'; -- spw_errinj_eep_received

				-- spw_error_injection_control_reg
				when 380 to 381 =>
					-- register write
					avalon_mm_address_o                 <= std_logic_vector(to_unsigned(16#71#, g_ADDRESS_WIDTH));
					avalon_mm_write_o                   <= '1';
					avalon_mm_writedata_o               <= (others => '0');
					avalon_mm_writedata_o(31 downto 16) <= std_logic_vector(to_unsigned(0, 16)); -- spw_errinj_n_repeat
					avalon_mm_writedata_o(15 downto 0)  <= std_logic_vector(to_unsigned(0, 16)); -- spw_errinj_sequence_cnt

				-- trans_error_injection_control_reg
				when 390 to 391 =>
					-- register write
					avalon_mm_address_o      <= std_logic_vector(to_unsigned(16#72#, g_ADDRESS_WIDTH));
					avalon_mm_write_o        <= '1';
					avalon_mm_writedata_o    <= (others => '0');
					avalon_mm_writedata_o(0) <= '0'; -- trans_errinj_tx_disabled

				-- trans_error_injection_control_reg
				when 400 to 401 =>
					-- register write
					avalon_mm_address_o      <= std_logic_vector(to_unsigned(16#73#, g_ADDRESS_WIDTH));
					avalon_mm_write_o        <= '1';
					avalon_mm_writedata_o    <= (others => '0');
					avalon_mm_writedata_o(0) <= '0'; -- trans_errinj_missing_pkts

				-- trans_error_injection_control_reg
				when 410 to 411 =>
					-- register write
					avalon_mm_address_o      <= std_logic_vector(to_unsigned(16#74#, g_ADDRESS_WIDTH));
					avalon_mm_write_o        <= '1';
					avalon_mm_writedata_o    <= (others => '0');
					avalon_mm_writedata_o(0) <= '0'; -- trans_errinj_missing_data

				-- trans_error_injection_control_reg
				when 420 to 421 =>
					-- register write
					avalon_mm_address_o                 <= std_logic_vector(to_unsigned(16#75#, g_ADDRESS_WIDTH));
					avalon_mm_write_o                   <= '1';
					avalon_mm_writedata_o               <= (others => '0');
					avalon_mm_writedata_o(31 downto 16) <= std_logic_vector(to_unsigned(0, 16)); -- trans_errinj_sequence_cnt
					avalon_mm_writedata_o(1 downto 0)   <= "00"; -- trans_errinj_frame_num

				-- trans_error_injection_control_reg
				when 430 to 431 =>
					-- register write
					avalon_mm_address_o                 <= std_logic_vector(to_unsigned(16#76#, g_ADDRESS_WIDTH));
					avalon_mm_write_o                   <= '1';
					avalon_mm_writedata_o               <= (others => '0');
					avalon_mm_writedata_o(31 downto 16) <= std_logic_vector(to_unsigned(0, 16)); -- trans_errinj_n_repeat
					avalon_mm_writedata_o(15 downto 0)  <= std_logic_vector(to_unsigned(0, 16)); -- trans_errinj_data_cnt

				-- spw_link_config_status_reg
				when 500 to 501 =>
					-- register write
					avalon_mm_address_o      <= std_logic_vector(to_unsigned(16#04#, g_ADDRESS_WIDTH));
					avalon_mm_write_o        <= '1';
					avalon_mm_writedata_o    <= (others => '0');
					avalon_mm_writedata_o(0) <= '1'; -- spw_lnkcfg_linkstart	
					avalon_mm_read_o         <= '0';

				-- fee_windowing_buffers_config_reg
				when 1000 to 1001 =>
					-- register write
					avalon_mm_address_o      <= std_logic_vector(to_unsigned(16#18#, g_ADDRESS_WIDTH));
					avalon_mm_write_o        <= '1';
					avalon_mm_writedata_o    <= (others => '0');
					avalon_mm_writedata_o(0) <= '1'; -- fee_machine_start
					avalon_mm_read_o         <= '0';

				-- data packet initial test

				-- data_packet_config_1_reg
				when 1050 to 1051 =>
					-- register write
					avalon_mm_address_o                 <= std_logic_vector(to_unsigned(16#64#, g_ADDRESS_WIDTH));
					avalon_mm_write_o                   <= '1';
					avalon_mm_writedata_o               <= (others => '0');
					avalon_mm_writedata_o(15 downto 0)  <= std_logic_vector(to_unsigned(25, 16)); -- data_pkt_ccd_x_size
					avalon_mm_writedata_o(31 downto 16) <= std_logic_vector(to_unsigned(50, 16)); -- data_pkt_ccd_y_size
					avalon_mm_read_o                    <= '0';

				-- data_packet_config_2_reg
				when 1100 to 1101 =>
					-- register write
					avalon_mm_address_o                 <= std_logic_vector(to_unsigned(16#65#, g_ADDRESS_WIDTH));
					avalon_mm_write_o                   <= '1';
					avalon_mm_writedata_o               <= (others => '0');
					avalon_mm_writedata_o(15 downto 0)  <= std_logic_vector(to_unsigned(35, 16)); -- data_pkt_data_y_size
					avalon_mm_writedata_o(31 downto 16) <= std_logic_vector(to_unsigned(15, 16)); -- data_pkt_overscan_y_size
					avalon_mm_read_o                    <= '0';

				-- data_packet_config_3_reg
				when 1125 to 1126 =>
					-- register write
					avalon_mm_address_o                 <= std_logic_vector(to_unsigned(16#66#, g_ADDRESS_WIDTH));
					avalon_mm_write_o                   <= '1';
					avalon_mm_writedata_o               <= (others => '0');
					avalon_mm_writedata_o(15 downto 0)  <= std_logic_vector(to_unsigned(0, 16)); -- data_pkt_ccd_v_start
					avalon_mm_writedata_o(31 downto 16) <= std_logic_vector(to_unsigned(49, 16)); -- data_pkt_ccd_v_end
					avalon_mm_read_o                    <= '0';

				-- data_packet_config_4_reg
				when 1150 to 1151 =>
					-- register write
					avalon_mm_address_o                 <= std_logic_vector(to_unsigned(16#67#, g_ADDRESS_WIDTH));
					avalon_mm_write_o                   <= '1';
					avalon_mm_writedata_o               <= (others => '0');
					--					avalon_mm_writedata_o(15 downto 0)  <= std_logic_vector(to_unsigned(1024, 16)); -- data_pkt_packet_length
					avalon_mm_writedata_o(15 downto 0)  <= std_logic_vector(to_unsigned(522, 16)); -- data_pkt_packet_length
					avalon_mm_writedata_o(23 downto 16) <= x"25"; -- data_pkt_logical_addr
					avalon_mm_writedata_o(31 downto 24) <= x"02"; -- data_pkt_protocol_id
					avalon_mm_read_o                    <= '0';

				-- data_packet_config_5_reg
				when 1200 to 1201 =>
					-- register write
					avalon_mm_address_o               <= std_logic_vector(to_unsigned(16#68#, g_ADDRESS_WIDTH));
					avalon_mm_write_o                 <= '1';
					avalon_mm_writedata_o             <= (others => '0');
					avalon_mm_writedata_o(4 downto 0) <= c_DPKT_FULLIMAGE_PATTERN_MODE; -- data_pkt_fee_mode
					--										avalon_mm_writedata_o(4 downto 0) <= c_DPKT_FULLIMAGE_MODE_SSD_MODE; -- data_pkt_fee_mode
					--										avalon_mm_writedata_o(4 downto 0) <= c_DPKT_WINDOWING_PATTERN_MODE; -- data_pkt_fee_mode
					avalon_mm_writedata_o(9 downto 8) <= std_logic_vector(to_unsigned(3, 2)); -- data_pkt_ccd_number
					avalon_mm_read_o                  <= '0';

				--				-- data_packet_pixel_delay_1_reg
				--				when 1210 to 1211 =>
				--					-- register write
				--					avalon_mm_address_o                <= std_logic_vector(to_unsigned(16#0E#, g_ADDRESS_WIDTH));
				--					avalon_mm_write_o                  <= '1';
				--					avalon_mm_writedata_o              <= (others => '0');
				--					avalon_mm_writedata_o(15 downto 0)  <= std_logic_vector(to_unsigned(10, 16)); -- data_pkt_line_delay
				--					avalon_mm_read_o                   <= '0';
				--					
				--				-- data_packet_pixel_delay_2_reg
				--				when 1220 to 1221 =>
				--					-- register write
				--					avalon_mm_address_o                <= std_logic_vector(to_unsigned(16#0F#, g_ADDRESS_WIDTH));
				--					avalon_mm_write_o                  <= '1';
				--					avalon_mm_writedata_o              <= (others => '0');
				--					avalon_mm_writedata_o(15 downto 0)  <= std_logic_vector(to_unsigned(10, 16)); -- data_pkt_column_delay
				--					avalon_mm_read_o                   <= '0';
				--					
				--				-- data_packet_pixel_delay_3_reg
				--				when 1230 to 1231 =>
				--					-- register write
				--					avalon_mm_address_o                <= std_logic_vector(to_unsigned(16#10#, g_ADDRESS_WIDTH));
				--					avalon_mm_write_o                  <= '1';
				--					avalon_mm_writedata_o              <= (others => '0');
				--					avalon_mm_writedata_o(15 downto 0)  <= std_logic_vector(to_unsigned(10, 16)); -- data_pkt_adc_delay
				--					avalon_mm_read_o                   <= '0';

				-- data_packet_pixel_delay_1_reg
				when 1210 to 1211 =>
					-- register write
					avalon_mm_address_o   <= std_logic_vector(to_unsigned(16#6C#, g_ADDRESS_WIDTH));
					avalon_mm_write_o     <= '1';
					avalon_mm_writedata_o <= (others => '0');
					avalon_mm_writedata_o <= std_logic_vector(to_unsigned(1000, 32)); -- data_pkt_start_delay
					avalon_mm_read_o      <= '0';

				-- data_packet_pixel_delay_2_reg
				when 1220 to 1221 =>
					-- register write
					avalon_mm_address_o   <= std_logic_vector(to_unsigned(16#6D#, g_ADDRESS_WIDTH));
					avalon_mm_write_o     <= '1';
					avalon_mm_writedata_o <= (others => '0');
					avalon_mm_writedata_o <= std_logic_vector(to_unsigned(500, 32)); -- data_pkt_skip_delay
					avalon_mm_read_o      <= '0';

				-- data_packet_pixel_delay_3_reg
				when 1230 to 1231 =>
					-- register write
					avalon_mm_address_o   <= std_logic_vector(to_unsigned(16#6E#, g_ADDRESS_WIDTH));
					avalon_mm_write_o     <= '1';
					avalon_mm_writedata_o <= (others => '0');
					avalon_mm_writedata_o <= std_logic_vector(to_unsigned(100, 32)); -- data_pkt_line_delay
					avalon_mm_read_o      <= '0';

				-- data_packet_pixel_delay_4_reg
				when 1240 to 1241 =>
					-- register write
					avalon_mm_address_o   <= std_logic_vector(to_unsigned(16#6F#, g_ADDRESS_WIDTH));
					avalon_mm_write_o     <= '1';
					avalon_mm_writedata_o <= (others => '0');
					avalon_mm_writedata_o <= std_logic_vector(to_unsigned(50, 32)); -- data_pkt_adc_delay
					avalon_mm_read_o      <= '0';

				--				-- data_packet_pixel_delay_2_reg
				--				when 1220 to 1221 =>
				--					-- register write
				--					avalon_mm_address_o                <= std_logic_vector(to_unsigned(16#0F#, g_ADDRESS_WIDTH));
				--					avalon_mm_write_o                  <= '1';
				--					avalon_mm_writedata_o              <= (others => '0');
				--					avalon_mm_writedata_o(15 downto 0)  <= std_logic_vector(to_unsigned(0, 16)); -- data_pkt_column_delay
				--					avalon_mm_read_o                   <= '0';
				--					
				--				-- data_packet_pixel_delay_3_reg
				--				when 1230 to 1231 =>
				--					-- register write
				--					avalon_mm_address_o                <= std_logic_vector(to_unsigned(16#10#, g_ADDRESS_WIDTH));
				--					avalon_mm_write_o                  <= '1';
				--					avalon_mm_writedata_o              <= (others => '0');
				--					avalon_mm_writedata_o(15 downto 0)  <= std_logic_vector(to_unsigned(0, 16)); -- data_pkt_adc_delay
				--					avalon_mm_read_o                   <= '0';

				when 1175 to 1176 =>
					-- register write
					avalon_mm_address_o      <= std_logic_vector(to_unsigned(16#19#, g_ADDRESS_WIDTH));
					avalon_mm_write_o        <= '1';
					avalon_mm_writedata_o    <= (others => '0');
					avalon_mm_writedata_o(0) <= '0'; -- fee_buffer_overflow_en
					avalon_mm_read_o         <= '0';

				when 1300 to 1301 =>
					-- register write
					avalon_mm_address_o      <= std_logic_vector(to_unsigned(16#1A#, g_ADDRESS_WIDTH));
					avalon_mm_write_o        <= '1';
					avalon_mm_writedata_o    <= (others => '0');
					avalon_mm_writedata_o(0) <= '1'; -- fee_digitalise_en
					avalon_mm_read_o         <= '0';

				when 1350 to 1351 =>
					-- register write
					avalon_mm_address_o      <= std_logic_vector(to_unsigned(16#1B#, g_ADDRESS_WIDTH));
					avalon_mm_write_o        <= '1';
					avalon_mm_writedata_o    <= (others => '0');
					avalon_mm_writedata_o(0) <= '1'; -- fee_readout_en
					avalon_mm_read_o         <= '0';

				when 1360 to 1361 =>
					-- register write
					avalon_mm_address_o      <= std_logic_vector(to_unsigned(16#1C#, g_ADDRESS_WIDTH));
					avalon_mm_write_o        <= '1';
					avalon_mm_writedata_o    <= (others => '0');
					avalon_mm_writedata_o(0) <= '1'; -- fee_window_list_en
					avalon_mm_read_o         <= '0';

				when 1400 to 1401 =>
					-- register write
					avalon_mm_address_o   <= std_logic_vector(to_unsigned(16#2E#, g_ADDRESS_WIDTH));
					avalon_mm_write_o     <= '1';
					avalon_mm_writedata_o <= (others => '1'); -- right_rd_data_length_bytes
					avalon_mm_read_o      <= '0';

				when 1450 to 1451 =>
					-- register write
					avalon_mm_address_o      <= std_logic_vector(to_unsigned(16#2F#, g_ADDRESS_WIDTH));
					avalon_mm_write_o        <= '1';
					avalon_mm_writedata_o    <= (others => '0');
					avalon_mm_writedata_o(0) <= '0'; -- right_rd_start
					avalon_mm_read_o         <= '0';

				when 1500 to 1501 =>
					-- register write
					avalon_mm_address_o   <= std_logic_vector(to_unsigned(16#33#, g_ADDRESS_WIDTH));
					avalon_mm_write_o     <= '1';
					avalon_mm_writedata_o <= (others => '1'); -- left_rd_data_length_bytes
					avalon_mm_read_o      <= '0';

				when 1550 to 1551 =>
					-- register write
					avalon_mm_address_o      <= std_logic_vector(to_unsigned(16#34#, g_ADDRESS_WIDTH));
					avalon_mm_write_o        <= '1';
					avalon_mm_writedata_o    <= (others => '0');
					avalon_mm_writedata_o(0) <= '1'; -- left_rd_start
					avalon_mm_read_o         <= '0';

				--				-- fee_windowing_buffers_config_reg
				--				when 52222 to 52223 =>
				--					-- register write
				--					avalon_mm_address_o      <= std_logic_vector(to_unsigned(16#13#, g_ADDRESS_WIDTH));
				--					avalon_mm_write_o        <= '1';
				--					avalon_mm_writedata_o    <= (others => '0');
				--					avalon_mm_writedata_o(0) <= '1'; -- FEE Machine Stop
				--					avalon_mm_read_o         <= '0';

				--					
				--			    -- teste de fee buffers flags
				--
				--								-- comm_irq_control_reg
				--								when 1500 to 1501 =>
				--									-- register write
				--									avalon_mm_address_o               <= std_logic_vector(to_unsigned(16#11#, g_ADDRESS_WIDTH));
				--									avalon_mm_write_o                 <= '1';
				--									avalon_mm_writedata_o             <= (others => '0');
				--									avalon_mm_writedata_o(0) <= '1'; -- comm_rmap_write_command_en
				--									avalon_mm_writedata_o(8) <= '1'; -- comm_right_buffer_empty_en
				--									avalon_mm_writedata_o(9) <= '1'; -- comm_left_buffer_empty_en
				--									avalon_mm_writedata_o(16) <= '1'; -- comm_global_irq_en
				--									avalon_mm_read_o                  <= '0';
				--				--		
				--				--				-- comm_irq_flags_clear_reg
				--								when 120000 to 120001 =>
				--									-- register write
				--									avalon_mm_address_o               <= std_logic_vector(to_unsigned(16#13#, g_ADDRESS_WIDTH));
				--									avalon_mm_write_o                 <= '1';
				--									avalon_mm_writedata_o             <= (others => '0');
				--									avalon_mm_writedata_o(0) <= '1'; -- comm_rmap_write_command_flag_clear
				--									avalon_mm_writedata_o(8) <= '1'; -- comm_buffer_empty_flag_clear
				--									avalon_mm_writedata_o(9) <= '1'; -- comm_buffer_empty_flag_clear
				--									avalon_mm_writedata_o(10) <= '1'; -- comm_buffer_empty_flag_clear
				--									avalon_mm_writedata_o(11) <= '1'; -- comm_buffer_empty_flag_clear
				--									avalon_mm_read_o                  <= '0';
				--					
				--				-- comm_irq_flags_clear_reg
				--				when 6050 to 6051 =>
				--					-- register write
				--					avalon_mm_address_o               <= std_logic_vector(to_unsigned(16#13#, g_ADDRESS_WIDTH));
				--					avalon_mm_write_o                 <= '1';
				--					avalon_mm_writedata_o             <= (others => '0');
				--					avalon_mm_writedata_o(0) <= '1'; -- comm_rmap_write_command_flag_clear
				--					avalon_mm_writedata_o(8) <= '1'; -- comm_buffer_empty_flag_clear
				--					avalon_mm_read_o                  <= '0';
				--					
				--				-- comm_irq_flags_clear_reg
				--				when 6100 to 6101 =>
				--					-- register write
				--					avalon_mm_address_o               <= std_logic_vector(to_unsigned(16#13#, g_ADDRESS_WIDTH));
				--					avalon_mm_write_o                 <= '1';
				--					avalon_mm_writedata_o             <= (others => '0');
				--					avalon_mm_writedata_o(0) <= '1'; -- comm_rmap_write_command_flag_clear
				--					avalon_mm_writedata_o(8) <= '1'; -- comm_buffer_empty_flag_clear
				--					avalon_mm_read_o                  <= '0';
				--			
				-- fee_windowing_buffers_config_reg

				--				when 4000 to 4001 =>
				--					-- register write
				--					avalon_mm_address_o      <= std_logic_vector(to_unsigned(16#02#, g_ADDRESS_WIDTH));
				--					avalon_mm_write_o        <= '1';
				--					avalon_mm_writedata_o    <= (others => '0');
				--					avalon_mm_writedata_o(0) <= '0'; -- fee_machine_clear
				--					avalon_mm_writedata_o(1) <= '1'; -- fee_machine_stop
				--					avalon_mm_writedata_o(2) <= '0'; -- fee_machine_start
				--					avalon_mm_writedata_o(3) <= '0'; -- fee_masking_en
				--					avalon_mm_read_o         <= '0';
				--					
				--				-- fee_windowing_buffers_config_reg
				--				when 4250 to 4251 =>
				--					-- register write
				--					avalon_mm_address_o      <= std_logic_vector(to_unsigned(16#02#, g_ADDRESS_WIDTH));
				--					avalon_mm_write_o        <= '1';
				--					avalon_mm_writedata_o    <= (others => '0');
				--					avalon_mm_writedata_o(0) <= '1'; -- fee_machine_clear
				--					avalon_mm_writedata_o(1) <= '0'; -- fee_machine_stop
				--					avalon_mm_writedata_o(2) <= '0'; -- fee_machine_start
				--					avalon_mm_writedata_o(3) <= '0'; -- fee_masking_en
				--					avalon_mm_read_o         <= '0';
				--					
				--				-- fee_windowing_buffers_config_reg
				--				when 5000 to 5001 =>
				--					-- register write
				--					avalon_mm_address_o      <= std_logic_vector(to_unsigned(16#02#, g_ADDRESS_WIDTH));
				--					avalon_mm_write_o        <= '1';
				--					avalon_mm_writedata_o    <= (others => '0');
				--					avalon_mm_writedata_o(0) <= '0'; -- fee_machine_clear
				--					avalon_mm_writedata_o(1) <= '0'; -- fee_machine_stop
				--					avalon_mm_writedata_o(2) <= '1'; -- fee_machine_start
				--					avalon_mm_writedata_o(3) <= '0'; -- fee_masking_en
				--					avalon_mm_read_o         <= '0';

				--              -- teste de mudança de tamanho de buffer
				--
				--								-- fee_windowing_right_buffer_size_reg
				--								when 1350 to 1351 =>
				--									-- register write
				--									avalon_mm_address_o               <= std_logic_vector(to_unsigned(16#14#, g_ADDRESS_WIDTH));
				--									avalon_mm_write_o                 <= '1';
				--									avalon_mm_writedata_o             <= (others => '0');
				--				--					avalon_mm_writedata_o(3 downto 0) <= std_logic_vector(to_unsigned(16 - 1, 4)); -- right_buffer_size
				--									avalon_mm_writedata_o(3 downto 0) <= std_logic_vector(to_unsigned(16 - 1, 4)); -- right_buffer_size
				--									avalon_mm_read_o                  <= '0';
				--
				--				-- fee_windowing_left_buffer_size_reg
				--				when 1100 to 1101 =>
				--					-- register write
				--					avalon_mm_address_o               <= std_logic_vector(to_unsigned(16#15#, g_ADDRESS_WIDTH));
				--					avalon_mm_write_o                 <= '1';
				--					avalon_mm_writedata_o             <= (others => '0');
				----					avalon_mm_writedata_o(3 downto 0) <= std_logic_vector(to_unsigned(16 - 1, 4)); -- left_buffer_size
				--					avalon_mm_writedata_o(3 downto 0) <= std_logic_vector(to_unsigned(4 - 1, 4)); -- left_buffer_size
				--					avalon_mm_read_o                  <= '0';

				when others =>
					null;

			end case;

		end if;
	end process p_config_avalon_stimuli;

end architecture RTL;
