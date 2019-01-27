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

				-- fee_windowing_buffers_config_reg
				when 1000 to 1001 =>
					-- register write
					avalon_mm_address_o      <= std_logic_vector(to_unsigned(16#02#, g_ADDRESS_WIDTH));
					avalon_mm_write_o        <= '1';
					avalon_mm_writedata_o    <= (others => '0');
					avalon_mm_writedata_o(0) <= '0'; -- fee_machine_clear
					avalon_mm_writedata_o(1) <= '0'; -- fee_machine_stop
					avalon_mm_writedata_o(2) <= '1'; -- fee_machine_start
					avalon_mm_writedata_o(3) <= '0'; -- fee_masking_en
					avalon_mm_read_o         <= '0';
					
				-- comm_irq_control_reg
				when 1200 to 1201 =>
					-- register write
					avalon_mm_address_o               <= std_logic_vector(to_unsigned(16#11#, g_ADDRESS_WIDTH));
					avalon_mm_write_o                 <= '1';
					avalon_mm_writedata_o             <= (others => '0');
					avalon_mm_writedata_o(0) <= '1'; -- comm_rmap_write_command_en
					avalon_mm_writedata_o(8) <= '1'; -- comm_right_buffer_empty_en
					avalon_mm_writedata_o(9) <= '1'; -- comm_left_buffer_empty_en
					avalon_mm_writedata_o(16) <= '1'; -- comm_global_irq_en
					avalon_mm_read_o                  <= '0';
					
				-- comm_irq_flags_clear_reg
				when 6000 to 6001 =>
					-- register write
					avalon_mm_address_o               <= std_logic_vector(to_unsigned(16#13#, g_ADDRESS_WIDTH));
					avalon_mm_write_o                 <= '1';
					avalon_mm_writedata_o             <= (others => '0');
					avalon_mm_writedata_o(0) <= '1'; -- comm_rmap_write_command_flag_clear
					avalon_mm_writedata_o(8) <= '1'; -- comm_buffer_empty_flag_clear
					avalon_mm_read_o                  <= '0';
					
				-- comm_irq_flags_clear_reg
				when 6050 to 6051 =>
					-- register write
					avalon_mm_address_o               <= std_logic_vector(to_unsigned(16#13#, g_ADDRESS_WIDTH));
					avalon_mm_write_o                 <= '1';
					avalon_mm_writedata_o             <= (others => '0');
					avalon_mm_writedata_o(0) <= '1'; -- comm_rmap_write_command_flag_clear
					avalon_mm_writedata_o(8) <= '1'; -- comm_buffer_empty_flag_clear
					avalon_mm_read_o                  <= '0';
					
				-- comm_irq_flags_clear_reg
				when 6100 to 6101 =>
					-- register write
					avalon_mm_address_o               <= std_logic_vector(to_unsigned(16#13#, g_ADDRESS_WIDTH));
					avalon_mm_write_o                 <= '1';
					avalon_mm_writedata_o             <= (others => '0');
					avalon_mm_writedata_o(0) <= '1'; -- comm_rmap_write_command_flag_clear
					avalon_mm_writedata_o(8) <= '1'; -- comm_buffer_empty_flag_clear
					avalon_mm_read_o                  <= '0';
			
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

				-- fee_windowing_right_buffer_size_reg
				when 1050 to 1051 =>
					-- register write
					avalon_mm_address_o               <= std_logic_vector(to_unsigned(16#14#, g_ADDRESS_WIDTH));
					avalon_mm_write_o                 <= '1';
					avalon_mm_writedata_o             <= (others => '0');
--					avalon_mm_writedata_o(3 downto 0) <= std_logic_vector(to_unsigned(16 - 1, 4)); -- right_buffer_size
					avalon_mm_writedata_o(3 downto 0) <= std_logic_vector(to_unsigned(4 - 1, 4)); -- right_buffer_size
					avalon_mm_read_o                  <= '0';

				-- fee_windowing_left_buffer_size_reg
				when 1100 to 1101 =>
					-- register write
					avalon_mm_address_o               <= std_logic_vector(to_unsigned(16#15#, g_ADDRESS_WIDTH));
					avalon_mm_write_o                 <= '1';
					avalon_mm_writedata_o             <= (others => '0');
--					avalon_mm_writedata_o(3 downto 0) <= std_logic_vector(to_unsigned(16 - 1, 4)); -- left_buffer_size
					avalon_mm_writedata_o(3 downto 0) <= std_logic_vector(to_unsigned(4 - 1, 4)); -- left_buffer_size
					avalon_mm_read_o                  <= '0';

				--					avalon_mm_read_o      <= '0';
				--
				--				when 550 to 551 =>
				--					-- register write
				--					avalon_mm_address_o                      <= std_logic_vector(to_unsigned(c_TIMECODE_RX_MM_REG_ADDRESS, g_ADDRESS_WIDTH));
				--					avalon_mm_write_o                        <= '1';
				--					-- avalon_mm_writedata_o <= (others => '0');
				--					-- Ex:
				--					a_wr_timecode_rx_flags_rx_received_clear <= '0';
				--					avalon_mm_read_o                         <= '0';
				--
				--				when 8600 to 8601 =>
				--					-- register write
				--					avalon_mm_address_o                  <= std_logic_vector(to_unsigned(c_TIMECODE_TX_MM_REG_ADDRESS, g_ADDRESS_WIDTH));
				--					avalon_mm_write_o                    <= '1';
				--					-- avalon_mm_writedata_o <= (others => '0');
				--					-- Ex:
				----					a_wr_timecode_tx_register_tx_control <= (others => '0');
				----					a_wr_timecode_tx_register_tx_time    <= (others => '0');
				----					a_wr_timecode_tx_register_tx_send    <= '0';
				--					a_wr_timecode_tx_register_tx_control <= (others => '0');
				--					a_wr_timecode_tx_register_tx_time    <= "111111";
				--					a_wr_timecode_tx_register_tx_send    <= '1';
				--					avalon_mm_read_o                     <= '0';
				--					
				--				when 8620 to 8621 =>
				--					-- register write
				--					avalon_mm_address_o                  <= std_logic_vector(to_unsigned(c_TIMECODE_TX_MM_REG_ADDRESS, g_ADDRESS_WIDTH));
				--					avalon_mm_write_o                    <= '1';
				--					-- avalon_mm_writedata_o <= (others => '0');
				--					-- Ex:
				----					a_wr_timecode_tx_register_tx_control <= (others => '0');
				----					a_wr_timecode_tx_register_tx_time    <= (others => '0');
				----					a_wr_timecode_tx_register_tx_send    <= '0';
				--					a_wr_timecode_tx_register_tx_control <= (others => '0');
				--					a_wr_timecode_tx_register_tx_time    <= "100001";
				--					a_wr_timecode_tx_register_tx_send    <= '1';
				--					avalon_mm_read_o                     <= '0';
				--					
				--				when 8640 to 8641 =>
				--					-- register write
				--					avalon_mm_address_o                  <= std_logic_vector(to_unsigned(c_TIMECODE_TX_MM_REG_ADDRESS, g_ADDRESS_WIDTH));
				--					avalon_mm_write_o                    <= '1';
				--					-- avalon_mm_writedata_o <= (others => '0');
				--					-- Ex:
				----					a_wr_timecode_tx_register_tx_control <= (others => '0');
				----					a_wr_timecode_tx_register_tx_time    <= (others => '0');
				----					a_wr_timecode_tx_register_tx_send    <= '0';
				--					a_wr_timecode_tx_register_tx_control <= (others => '0');
				--					a_wr_timecode_tx_register_tx_time    <= "110011";
				--					a_wr_timecode_tx_register_tx_send    <= '1';
				--					avalon_mm_read_o                     <= '0';
				--					
				--				when 8660 to 8661 =>
				--					-- register write
				--					avalon_mm_address_o                  <= std_logic_vector(to_unsigned(c_TIMECODE_TX_MM_REG_ADDRESS, g_ADDRESS_WIDTH));
				--					avalon_mm_write_o                    <= '1';
				--					-- avalon_mm_writedata_o <= (others => '0');
				--					-- Ex:
				----					a_wr_timecode_tx_register_tx_control <= (others => '0');
				----					a_wr_timecode_tx_register_tx_time    <= (others => '0');
				----					a_wr_timecode_tx_register_tx_send    <= '0';
				--					a_wr_timecode_tx_register_tx_control <= (others => '0');
				--					a_wr_timecode_tx_register_tx_time    <= "100101";
				--					a_wr_timecode_tx_register_tx_send    <= '1';
				--					avalon_mm_read_o                     <= '0';
				--					
				--				when 8680 to 8681 =>
				--					-- register write
				--					avalon_mm_address_o                  <= std_logic_vector(to_unsigned(c_TIMECODE_TX_MM_REG_ADDRESS, g_ADDRESS_WIDTH));
				--					avalon_mm_write_o                    <= '1';
				--					-- avalon_mm_writedata_o <= (others => '0');
				--					-- Ex:
				----					a_wr_timecode_tx_register_tx_control <= (others => '0');
				----					a_wr_timecode_tx_register_tx_time    <= (others => '0');
				----					a_wr_timecode_tx_register_tx_send    <= '0';
				--					a_wr_timecode_tx_register_tx_control <= (others => '0');
				--					a_wr_timecode_tx_register_tx_time    <= "010010";
				--					a_wr_timecode_tx_register_tx_send    <= '1';
				--					avalon_mm_read_o                     <= '0';
				--
				--				--when 650 to 651 =>
				--				when 7000 to 7001 =>
				--					-- register write
				--					avalon_mm_address_o                         <= std_logic_vector(to_unsigned(c_INTERRUPT_FLAG_MM_REG_ADDRESS, g_ADDRESS_WIDTH));
				--					avalon_mm_write_o                           <= '1';
				--					-- avalon_mm_writedata_o <= (others => '0');
				--					-- Ex:
				--					a_wr_interrupt_flag_clear_buffer_empty_flag <= '1';
				--					avalon_mm_read_o                            <= '0';
				--
				--				when 700 to 701 =>
				--					-- register write
				--					avalon_mm_address_o                          <= std_logic_vector(to_unsigned(c_INTERRUPT_CONTROL_MM_REG_ADDRESS, g_ADDRESS_WIDTH));
				--					avalon_mm_write_o                            <= '1';
				--					-- avalon_mm_writedata_o <= (others => '0');
				--					-- Ex:
				--					a_wr_interrupt_control_L_buffer_empty_enable <= '1';
				--					a_wr_interrupt_control_R_buffer_empty_enable <= '1';
				--					avalon_mm_read_o                             <= '0';
				--					
				--				when 7500 to 7501 =>
				--					-- register write
				--					avalon_mm_address_o                <= std_logic_vector(to_unsigned(c_WINDOWING_CONTROL_MM_REG_ADDRESS, g_ADDRESS_WIDTH));
				--					avalon_mm_write_o                  <= '1';
				--					-- avalon_mm_writedata_o <= (others => '0');
				--					-- Ex:
				--					a_wr_windowing_control_mask_enable <= '1';
				--					a_wr_windowing_control_autostart   <= '1';
				--					a_wr_windowing_control_linkstart   <= '1';
				--					a_wr_windowing_control_linkdis     <= '0';
				--					avalon_mm_read_o                   <= '0';

				when others =>
					null;

			end case;

		end if;
	end process p_config_avalon_stimuli;

end architecture RTL;
