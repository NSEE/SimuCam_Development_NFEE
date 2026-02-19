library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity avalon_32_stimuli is
	generic(
		g_ADDRESS_WIDTH : natural range 1 to 64;
		g_DATA_WIDTH    : natural range 1 to 256
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
end entity avalon_32_stimuli;

architecture RTL of avalon_32_stimuli is

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

	p_avalon_32_stimuli : process(clk_i, rst_i) is
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

				when 2500 to 2501 =>
					-- register read
					avalon_mm_address_o                 <= std_logic_vector(to_unsigned(16#00#, g_ADDRESS_WIDTH));
					avalon_mm_write_o                   <= '0';
					avalon_mm_writedata_o               <= (others => '0');
					avalon_mm_read_o                    <= '1';
					
				when 2550 to 2551 =>
					-- register read
					avalon_mm_address_o                 <= std_logic_vector(to_unsigned(16#01#, g_ADDRESS_WIDTH));
					avalon_mm_write_o                   <= '0';
					avalon_mm_writedata_o               <= (others => '0');
					avalon_mm_read_o                    <= '1';
					
				when 2600 to 2601 =>
					-- register read
					avalon_mm_address_o                 <= std_logic_vector(to_unsigned(16#02#, g_ADDRESS_WIDTH));
					avalon_mm_write_o                   <= '0';
					avalon_mm_writedata_o               <= (others => '0');
					avalon_mm_read_o                    <= '1';
					
				when 2650 to 2651 =>
					-- register read
					avalon_mm_address_o                 <= std_logic_vector(to_unsigned(16#03#, g_ADDRESS_WIDTH));
					avalon_mm_write_o                   <= '0';
					avalon_mm_writedata_o               <= (others => '0');
					avalon_mm_read_o                    <= '1';
					
				when 2700 to 2701 =>
					-- register read
					avalon_mm_address_o                 <= std_logic_vector(to_unsigned(16#04#, g_ADDRESS_WIDTH));
					avalon_mm_write_o                   <= '0';
					avalon_mm_writedata_o               <= (others => '0');
					avalon_mm_read_o                    <= '1';
					
				when 2750 to 2751 =>
					-- register read
					avalon_mm_address_o                 <= std_logic_vector(to_unsigned(16#05#, g_ADDRESS_WIDTH));
					avalon_mm_write_o                   <= '0';
					avalon_mm_writedata_o               <= (others => '0');
					avalon_mm_read_o                    <= '1';
					
				when 2800 to 2801 =>
					-- register read
					avalon_mm_address_o                 <= std_logic_vector(to_unsigned(543, g_ADDRESS_WIDTH));
					avalon_mm_write_o                   <= '0';
					avalon_mm_writedata_o               <= (others => '0');
					avalon_mm_read_o                    <= '1';
					
				when 2850 to 2851 =>
					-- register read
					avalon_mm_address_o                 <= std_logic_vector(to_unsigned(544, g_ADDRESS_WIDTH));
					avalon_mm_write_o                   <= '0';
					avalon_mm_writedata_o               <= (others => '0');
					avalon_mm_read_o                    <= '1';

				when 3000 to 3001 =>
					-- register write
					avalon_mm_address_o      <= std_logic_vector(to_unsigned(16#00#, g_ADDRESS_WIDTH));
					avalon_mm_write_o        <= '1';
					avalon_mm_writedata_o    <= (others => '0');
					avalon_mm_writedata_o(0) <= '1'; -- avstap_clear
					avalon_mm_read_o         <= '0';
--
--				-- data packet initial test
--
--				-- data_packet_config_1_reg
--				when 1050 to 1051 =>
--					-- register write
--					avalon_mm_address_o                 <= std_logic_vector(to_unsigned(16#08#, g_ADDRESS_WIDTH));
--					avalon_mm_write_o                   <= '1';
--					avalon_mm_writedata_o               <= (others => '0');
--					avalon_mm_writedata_o(15 downto 0)  <= std_logic_vector(to_unsigned(50, 16)); -- data_pkt_ccd_x_size
--					avalon_mm_writedata_o(31 downto 16) <= std_logic_vector(to_unsigned(100, 16)); -- data_pkt_ccd_y_size
--					avalon_mm_read_o                    <= '0';

				when others =>
					null;

			end case;

		end if;
	end process p_avalon_32_stimuli;

end architecture RTL;
