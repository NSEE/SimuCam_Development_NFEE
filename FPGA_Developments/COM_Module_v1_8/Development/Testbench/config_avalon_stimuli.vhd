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

				--				-- spw_timecode_reg
				--				when 1500 to 1501 =>
				--					-- register write
				--					avalon_mm_address_o   <= std_logic_vector(to_unsigned(16#01#, g_ADDRESS_WIDTH));
				--					avalon_mm_write_o     <= '1';
				--					avalon_mm_writedata_o <= (others => '0');
				--					avalon_mm_writedata_o(8) <= '1'; -- timecode_clear

				-- spw_link_config_status_reg
				when 500 to 501 =>
					-- register write
					avalon_mm_address_o                 <= std_logic_vector(to_unsigned(16#00#, g_ADDRESS_WIDTH));
					avalon_mm_write_o                   <= '1';
					avalon_mm_writedata_o               <= (others => '0');
					avalon_mm_writedata_o(0)            <= '0'; -- spw_lnkcfg_disconnect	
					avalon_mm_writedata_o(1)            <= '1'; -- spw_lnkcfg_linkstart	
					avalon_mm_writedata_o(2)            <= '0'; -- spw_lnkcfg_autostart	
					avalon_mm_writedata_o(31 downto 24) <= x"01"; -- spw_lnkcfg_txdivcnt	
					avalon_mm_read_o                    <= '0';

				-- fee_windowing_buffers_config_reg
				when 1000 to 1001 =>
					-- register write
					avalon_mm_address_o      <= std_logic_vector(to_unsigned(16#02#, g_ADDRESS_WIDTH));
					avalon_mm_write_o        <= '1';
					avalon_mm_writedata_o    <= (others => '0');
					avalon_mm_writedata_o(0) <= '0'; -- fee_machine_clear
					avalon_mm_writedata_o(1) <= '0'; -- fee_machine_stop
					avalon_mm_writedata_o(2) <= '1'; -- fee_machine_start
					avalon_mm_writedata_o(3) <= '1'; -- fee_masking_en
					avalon_mm_read_o         <= '0';

				-- data packet initial test

				-- data_packet_config_1_reg
				when 1050 to 1051 =>
					-- register write
					avalon_mm_address_o                 <= std_logic_vector(to_unsigned(16#08#, g_ADDRESS_WIDTH));
					avalon_mm_write_o                   <= '1';
					avalon_mm_writedata_o               <= (others => '0');
					avalon_mm_writedata_o(15 downto 0)  <= std_logic_vector(to_unsigned(1000, 16)); -- data_pkt_ccd_x_size
					avalon_mm_writedata_o(31 downto 16) <= std_logic_vector(to_unsigned(2500, 16)); -- data_pkt_ccd_y_size
					avalon_mm_read_o                    <= '0';

				-- data_packet_config_2_reg
				when 1100 to 1101 =>
					-- register write
					avalon_mm_address_o                 <= std_logic_vector(to_unsigned(16#09#, g_ADDRESS_WIDTH));
					avalon_mm_write_o                   <= '1';
					avalon_mm_writedata_o               <= (others => '0');
					avalon_mm_writedata_o(15 downto 0)  <= std_logic_vector(to_unsigned(2000, 16)); -- data_pkt_data_y_size
					avalon_mm_writedata_o(31 downto 16) <= std_logic_vector(to_unsigned(500, 16)); -- data_pkt_overscan_y_size
					avalon_mm_read_o                    <= '0';

				-- data_packet_config_3_reg
				when 1150 to 1151 =>
					-- register write
					avalon_mm_address_o                <= std_logic_vector(to_unsigned(16#0A#, g_ADDRESS_WIDTH));
					avalon_mm_write_o                  <= '1';
					avalon_mm_writedata_o              <= (others => '0');
					avalon_mm_writedata_o(15 downto 0) <= std_logic_vector(to_unsigned(1024*8, 16)); -- data_pkt_packet_length
					avalon_mm_read_o                   <= '0';

				-- data_packet_config_4_reg
				when 1200 to 1201 =>
					-- register write
					avalon_mm_address_o                <= std_logic_vector(to_unsigned(16#0B#, g_ADDRESS_WIDTH));
					avalon_mm_write_o                  <= '1';
					avalon_mm_writedata_o              <= (others => '0');
					avalon_mm_writedata_o(7 downto 0)  <= std_logic_vector(to_unsigned(1+8, 8)); -- data_pkt_fee_mode
					avalon_mm_writedata_o(15 downto 8) <= std_logic_vector(to_unsigned(0, 8)); -- data_pkt_ccd_number
					avalon_mm_writedata_o(23 downto 16)  <= x"02"; -- data_pkt_protocol_id
					avalon_mm_writedata_o(31 downto 24) <= x"25"; -- data_pkt_logical_addr
					avalon_mm_read_o                   <= '0';
					
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
					avalon_mm_address_o                <= std_logic_vector(to_unsigned(16#0E#, g_ADDRESS_WIDTH));
					avalon_mm_write_o                  <= '1';
					avalon_mm_writedata_o              <= (others => '0');
					avalon_mm_writedata_o(15 downto 0)  <= std_logic_vector(to_unsigned(0, 16)); -- data_pkt_line_delay
					avalon_mm_read_o                   <= '0';
					
				-- data_packet_pixel_delay_2_reg
				when 1220 to 1221 =>
					-- register write
					avalon_mm_address_o                <= std_logic_vector(to_unsigned(16#0F#, g_ADDRESS_WIDTH));
					avalon_mm_write_o                  <= '1';
					avalon_mm_writedata_o              <= (others => '0');
					avalon_mm_writedata_o(15 downto 0)  <= std_logic_vector(to_unsigned(0, 16)); -- data_pkt_column_delay
					avalon_mm_read_o                   <= '0';
					
				-- data_packet_pixel_delay_3_reg
				when 1230 to 1231 =>
					-- register write
					avalon_mm_address_o                <= std_logic_vector(to_unsigned(16#10#, g_ADDRESS_WIDTH));
					avalon_mm_write_o                  <= '1';
					avalon_mm_writedata_o              <= (others => '0');
					avalon_mm_writedata_o(15 downto 0)  <= std_logic_vector(to_unsigned(0, 16)); -- data_pkt_adc_delay
					avalon_mm_read_o                   <= '0';

				--					
				--			    -- teste de fee buffers flags
				--
								-- comm_irq_control_reg
								when 1500 to 1501 =>
									-- register write
									avalon_mm_address_o               <= std_logic_vector(to_unsigned(16#11#, g_ADDRESS_WIDTH));
									avalon_mm_write_o                 <= '1';
									avalon_mm_writedata_o             <= (others => '0');
									avalon_mm_writedata_o(0) <= '1'; -- comm_rmap_write_command_en
									avalon_mm_writedata_o(8) <= '1'; -- comm_right_buffer_empty_en
									avalon_mm_writedata_o(9) <= '1'; -- comm_left_buffer_empty_en
									avalon_mm_writedata_o(16) <= '1'; -- comm_global_irq_en
									avalon_mm_read_o                  <= '0';
				--		
				--				-- comm_irq_flags_clear_reg
								when 120000 to 120001 =>
									-- register write
									avalon_mm_address_o               <= std_logic_vector(to_unsigned(16#13#, g_ADDRESS_WIDTH));
									avalon_mm_write_o                 <= '1';
									avalon_mm_writedata_o             <= (others => '0');
									avalon_mm_writedata_o(0) <= '1'; -- comm_rmap_write_command_flag_clear
									avalon_mm_writedata_o(8) <= '1'; -- comm_buffer_empty_flag_clear
									avalon_mm_writedata_o(9) <= '1'; -- comm_buffer_empty_flag_clear
									avalon_mm_writedata_o(10) <= '1'; -- comm_buffer_empty_flag_clear
									avalon_mm_writedata_o(11) <= '1'; -- comm_buffer_empty_flag_clear
									avalon_mm_read_o                  <= '0';
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
				--				-- fee_windowing_right_buffer_size_reg
				--				when 1050 to 1051 =>
				--					-- register write
				--					avalon_mm_address_o               <= std_logic_vector(to_unsigned(16#14#, g_ADDRESS_WIDTH));
				--					avalon_mm_write_o                 <= '1';
				--					avalon_mm_writedata_o             <= (others => '0');
				----					avalon_mm_writedata_o(3 downto 0) <= std_logic_vector(to_unsigned(16 - 1, 4)); -- right_buffer_size
				--					avalon_mm_writedata_o(3 downto 0) <= std_logic_vector(to_unsigned(4 - 1, 4)); -- right_buffer_size
				--					avalon_mm_read_o                  <= '0';
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
