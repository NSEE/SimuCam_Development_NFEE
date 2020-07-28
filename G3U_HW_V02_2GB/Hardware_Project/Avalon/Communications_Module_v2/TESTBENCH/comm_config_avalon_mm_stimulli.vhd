library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.avalon_mm_spacewire_registers_pkg.all;
use work.fee_data_controller_pkg.all;

entity comm_config_avalon_mm_stimulli is
	port(
		clk_i                       : in  std_logic;
		rst_i                       : in  std_logic;
		avs_config_rd_regs_i        : in  t_windowing_read_registers;
		avs_config_wr_regs_o        : out t_windowing_write_registers;
		avs_config_rd_readdata_o    : out std_logic_vector(31 downto 0);
		avs_config_rd_waitrequest_o : out std_logic;
		avs_config_wr_waitrequest_o : out std_logic
	);
end entity comm_config_avalon_mm_stimulli;

architecture RTL of comm_config_avalon_mm_stimulli is

	signal s_counter : natural := 0;
	signal s_times   : natural := 0;

begin

	p_comm_config_avalon_mm_stimulli : process(clk_i, rst_i) is
		procedure p_reset_registers is
		begin

		end procedure p_reset_registers;

		procedure p_control_triggers is
		begin

		end procedure p_control_triggers;

	begin
		if (rst_i = '1') then

			s_counter                   <= 0;
			s_times                     <= 0;
			p_reset_registers;
			avs_config_rd_readdata_o    <= (others => '0');
			avs_config_rd_waitrequest_o <= '1';
			avs_config_wr_waitrequest_o <= '1';

		elsif rising_edge(clk_i) then

			s_counter                   <= s_counter + 1;
			p_control_triggers;
			avs_config_rd_readdata_o    <= (others => '0');
			avs_config_rd_waitrequest_o <= '1';
			avs_config_wr_waitrequest_o <= '1';

			case s_counter is

				when 5 =>
					-- stop the comm module
					avs_config_wr_regs_o.fee_machine_config_reg.fee_machine_stop <= '1';

				when 10 =>
					-- clear the comm module
					avs_config_wr_regs_o.fee_machine_config_reg.fee_machine_clear <= '1';

				when 15 =>
					-- start the comm module
					avs_config_wr_regs_o.fee_machine_config_reg.fee_machine_start <= '1';

				when 20 =>
					-- configure simulation parameters
					-- data packet parameters
					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_x_size              <= std_logic_vector(to_unsigned(25, 16));
					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_y_size              <= std_logic_vector(to_unsigned(50, 16));
					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_data_y_size             <= std_logic_vector(to_unsigned(35, 16));
					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_overscan_y_size         <= std_logic_vector(to_unsigned(15, 16));
					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_v_start             <= std_logic_vector(to_unsigned(0, 16));
					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_v_end               <= std_logic_vector(to_unsigned(49, 16));
					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_img_v_end           <= std_logic_vector(to_unsigned(34, 16));
					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_ovs_v_end           <= std_logic_vector(to_unsigned(14, 16));
					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_h_start             <= std_logic_vector(to_unsigned(0, 16));
					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_h_end               <= std_logic_vector(to_unsigned(24, 16));
					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_packet_length           <= std_logic_vector(to_unsigned(1024, 16));
					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_logical_addr            <= x"25";
					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_protocol_id             <= x"02";
					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_number              <= std_logic_vector(to_unsigned(3, 2));
					--					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_fee_mode                <= c_DPKT_OFF_MODE; -- N-FEE Off Mode
					--					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_fee_mode                <= c_DPKT_ON_MODE; -- N-FEE On Mode
					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_fee_mode                <= c_DPKT_FULLIMAGE_PATTERN_MODE; -- N-FEE Full-Image Pattern Mode
					--					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_fee_mode                <= c_DPKT_WINDOWING_PATTERN_MODE; -- N-FEE Windowing Pattern Mode
					--					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_fee_mode                <= c_DPKT_STANDBY_MODE; -- N-FEE Standby Mode
					--					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_fee_mode                <= c_DPKT_FULLIMAGE_MODE_PATTERN_MODE; -- N-FEE Full-Image Mode / Pattern Mode
					--					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_fee_mode                <= c_DPKT_FULLIMAGE_MODE_SSD_MODE; -- N-FEE Full-Image Mode / SSD Mode
					--					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_fee_mode                <= c_DPKT_WINDOWING_MODE_PATTERN_MODE; -- N-FEE Windowing Mode / Pattern Mode
					--					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_fee_mode                <= c_DPKT_WINDOWING_MODE_SSDIMG_MODE; -- N-FEE Windowing Mode / SSD Image Mode
					--					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_fee_mode                <= c_DPKT_WINDOWING_MODE_SSDWIN_MODE; -- N-FEE Windowing Mode / SSD Window Mode
					--					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_fee_mode                <= c_DPKT_PERFORMANCE_TEST_MODE; -- N-FEE Performance Test Mode
					--					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_fee_mode                <= c_DPKT_PAR_TRAP_PUMP_1_MODE_PUMP_MODE; -- N-FEE Parallel Trap Pumping 1 Mode / Pumping Mode
					--					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_fee_mode                <= c_DPKT_PAR_TRAP_PUMP_1_MODE_DATA_MODE; -- N-FEE Parallel Trap Pumping 1 Mode / Data Emiting Mode
					--					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_fee_mode                <= c_DPKT_PAR_TRAP_PUMP_2_MODE_PUMP_MODE; -- N-FEE Parallel Trap Pumping 2 Mode / Pumping Mode
					--					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_fee_mode                <= c_DPKT_PAR_TRAP_PUMP_2_MODE_DATA_MODE; -- N-FEE Parallel Trap Pumping 2 Mode / Data Emiting Mode
					--					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_fee_mode                <= c_DPKT_SER_TRAP_PUMP_1_MODE; -- N-FEE Serial Trap Pumping 1 Mode
					--					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_fee_mode                <= c_DPKT_SER_TRAP_PUMP_2_MODE; -- N-FEE Serial Trap Pumping 2 Mode
					-- pixel delays parameters
					avs_config_wr_regs_o.data_packet_pixel_delay_reg.data_pkt_start_delay        <= std_logic_vector(to_unsigned(1000, 32));
					avs_config_wr_regs_o.data_packet_pixel_delay_reg.data_pkt_skip_delay         <= std_logic_vector(to_unsigned(500, 32));
					avs_config_wr_regs_o.data_packet_pixel_delay_reg.data_pkt_line_delay         <= std_logic_vector(to_unsigned(100, 32));
					avs_config_wr_regs_o.data_packet_pixel_delay_reg.data_pkt_adc_delay          <= std_logic_vector(to_unsigned(50, 32));
					-- fee machine parameters
					avs_config_wr_regs_o.fee_machine_config_reg.fee_buffer_overflow_en           <= '0';
					avs_config_wr_regs_o.fee_machine_config_reg.fee_digitalise_en                <= '1';
					avs_config_wr_regs_o.fee_machine_config_reg.fee_readout_en                   <= '1';
					-- buffers data control
					avs_config_wr_regs_o.fee_buffers_data_control_reg.left_rd_data_length_bytes  <= (others => '1');
					avs_config_wr_regs_o.fee_buffers_data_control_reg.left_rd_start              <= '1';
					avs_config_wr_regs_o.fee_buffers_data_control_reg.right_rd_data_length_bytes <= (others => '1');
				--					avs_config_wr_regs_o.fee_buffers_data_control_reg.right_rd_start             <= '1';

				when others =>
					null;

			end case;

		end if;
	end process p_comm_config_avalon_mm_stimulli;

	avs_config_rd_readdata_o    <= (others => '0');
	avs_config_rd_waitrequest_o <= '1';
	avs_config_wr_waitrequest_o <= '1';

end architecture RTL;
