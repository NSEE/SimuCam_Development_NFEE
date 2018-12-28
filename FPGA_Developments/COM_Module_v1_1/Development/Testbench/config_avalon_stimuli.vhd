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
	alias a_wr_windowing_control_mask_enable           : std_logic is avalon_mm_writedata_o(8);
	alias a_wr_windowing_control_autostart             : std_logic is avalon_mm_writedata_o(2);
	alias a_wr_windowing_control_linkstart             : std_logic is avalon_mm_writedata_o(1);
	alias a_wr_windowing_control_linkdis               : std_logic is avalon_mm_writedata_o(0);
	alias a_wr_timecode_rx_flags_rx_received_clear     : std_logic is avalon_mm_writedata_o(0);
	alias a_wr_timecode_tx_register_tx_control         : std_logic_vector(1 downto 0) is avalon_mm_writedata_o(8 downto 7);
	alias a_wr_timecode_tx_register_tx_time            : std_logic_vector(5 downto 0) is avalon_mm_writedata_o(6 downto 1);
	alias a_wr_timecode_tx_register_tx_send            : std_logic is avalon_mm_writedata_o(0);
	alias a_wr_interrupt_flag_clear_buffer_empty_flag  : std_logic is avalon_mm_writedata_o(0);
	alias a_wr_interrupt_control_L_buffer_empty_enable : std_logic is avalon_mm_writedata_o(8);
	alias a_wr_interrupt_control_R_buffer_empty_enable : std_logic is avalon_mm_writedata_o(0);

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

				when 500 to 501 =>
					-- register write
					avalon_mm_address_o                <= std_logic_vector(to_unsigned(c_WINDOWING_CONTROL_MM_REG_ADDRESS, g_ADDRESS_WIDTH));
					avalon_mm_write_o                  <= '1';
					-- avalon_mm_writedata_o <= (others => '0');
					-- Ex:
					a_wr_windowing_control_mask_enable <= '1';
					a_wr_windowing_control_autostart   <= '0';
					a_wr_windowing_control_linkstart   <= '0';
					a_wr_windowing_control_linkdis     <= '0';
					avalon_mm_read_o                   <= '0';

				when 550 to 551 =>
					-- register write
					avalon_mm_address_o                      <= std_logic_vector(to_unsigned(c_TIMECODE_RX_MM_REG_ADDRESS, g_ADDRESS_WIDTH));
					avalon_mm_write_o                        <= '1';
					-- avalon_mm_writedata_o <= (others => '0');
					-- Ex:
					a_wr_timecode_rx_flags_rx_received_clear <= '0';
					avalon_mm_read_o                         <= '0';

				when 600 to 601 =>
					-- register write
					avalon_mm_address_o                  <= std_logic_vector(to_unsigned(c_TIMECODE_TX_MM_REG_ADDRESS, g_ADDRESS_WIDTH));
					avalon_mm_write_o                    <= '1';
					-- avalon_mm_writedata_o <= (others => '0');
					-- Ex:
					a_wr_timecode_tx_register_tx_control <= (others => '0');
					a_wr_timecode_tx_register_tx_time    <= (others => '0');
					a_wr_timecode_tx_register_tx_send    <= '0';
					avalon_mm_read_o                     <= '0';

				--when 650 to 651 =>
				when 7000 to 7001 =>
					-- register write
					avalon_mm_address_o                         <= std_logic_vector(to_unsigned(c_INTERRUPT_FLAG_MM_REG_ADDRESS, g_ADDRESS_WIDTH));
					avalon_mm_write_o                           <= '1';
					-- avalon_mm_writedata_o <= (others => '0');
					-- Ex:
					a_wr_interrupt_flag_clear_buffer_empty_flag <= '1';
					avalon_mm_read_o                            <= '0';

				when 700 to 701 =>
					-- register write
					avalon_mm_address_o                          <= std_logic_vector(to_unsigned(c_INTERRUPT_CONTROL_MM_REG_ADDRESS, g_ADDRESS_WIDTH));
					avalon_mm_write_o                            <= '1';
					-- avalon_mm_writedata_o <= (others => '0');
					-- Ex:
					a_wr_interrupt_control_L_buffer_empty_enable <= '1';
					a_wr_interrupt_control_R_buffer_empty_enable <= '1';
					avalon_mm_read_o                             <= '0';
					
				when 7500 to 7501 =>
					-- register write
					avalon_mm_address_o                <= std_logic_vector(to_unsigned(c_WINDOWING_CONTROL_MM_REG_ADDRESS, g_ADDRESS_WIDTH));
					avalon_mm_write_o                  <= '1';
					-- avalon_mm_writedata_o <= (others => '0');
					-- Ex:
					a_wr_windowing_control_mask_enable <= '1';
					a_wr_windowing_control_autostart   <= '1';
					a_wr_windowing_control_linkstart   <= '1';
					a_wr_windowing_control_linkdis     <= '0';
					avalon_mm_read_o                   <= '0';

				when others =>
					null;

			end case;

		end if;
	end process p_config_avalon_stimuli;

end architecture RTL;
