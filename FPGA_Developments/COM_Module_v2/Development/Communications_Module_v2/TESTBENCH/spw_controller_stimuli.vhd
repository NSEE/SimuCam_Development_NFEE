library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity spw_controller_stimuli is
	port(
		clk_i                         : in  std_logic;
		rst_i                         : in  std_logic;
		spw_link_command_autostart_i  : in  std_logic; --                    -- spacewire_controller.spw_link_command_autostart_signal
		spw_link_command_linkstart_i  : in  std_logic; --                    --                     .spw_link_command_linkstart_signal
		spw_link_command_linkdis_i    : in  std_logic; --                    --                     .spw_link_command_linkdis_signal
		spw_link_command_txdivcnt_i   : in  std_logic_vector(7 downto 0); -- --                     .spw_link_command_txdivcnt_signal
		spw_timecode_tx_tick_in_i     : in  std_logic; --                    --                     .spw_timecode_tx_tick_in_signal
		spw_timecode_tx_ctrl_in_i     : in  std_logic_vector(1 downto 0); -- --                     .spw_timecode_tx_ctrl_in_signal
		spw_timecode_tx_time_in_i     : in  std_logic_vector(5 downto 0); -- --                     .spw_timecode_tx_time_in_signal
		spw_data_rx_command_rxread_i  : in  std_logic; --                    --                     .spw_data_rx_command_rxread_signal
		spw_data_tx_command_txwrite_i : in  std_logic; --                    --                     .spw_data_tx_command_txwrite_signal
		spw_data_tx_command_txflag_i  : in  std_logic; --                    --                     .spw_data_tx_command_txflag_signal
		spw_data_tx_command_txdata_i  : in  std_logic_vector(7 downto 0); -- --                     .spw_data_tx_command_txdata_signal
		spw_link_status_started_o     : out std_logic; --                    --                     .spw_link_status_started_signal
		spw_link_status_connecting_o  : out std_logic; --                    --                     .spw_link_status_connecting_signal
		spw_link_status_running_o     : out std_logic; --                    --                     .spw_link_status_running_signal
		spw_link_error_errdisc_o      : out std_logic; --                    --                     .spw_link_error_errdisc_signal
		spw_link_error_errpar_o       : out std_logic; --                    --                     .spw_link_error_errpar_signal
		spw_link_error_erresc_o       : out std_logic; --                    --                     .spw_link_error_erresc_signal
		spw_link_error_errcred_o      : out std_logic; --                    --                     .spw_link_error_errcred_signal
		spw_timecode_rx_tick_out_o    : out std_logic; --                    --                     .spw_timecode_rx_tick_out_signal
		spw_timecode_rx_ctrl_out_o    : out std_logic_vector(1 downto 0); -- --                     .spw_timecode_rx_ctrl_out_signal
		spw_timecode_rx_time_out_o    : out std_logic_vector(5 downto 0); -- --                     .spw_timecode_rx_time_out_signal
		spw_data_rx_status_rxvalid_o  : out std_logic; --                    --                     .spw_data_rx_status_rxvalid_signal
		spw_data_rx_status_rxhalff_o  : out std_logic; --                    --                     .spw_data_rx_status_rxhalff_signal
		spw_data_rx_status_rxflag_o   : out std_logic; --                    --                     .spw_data_rx_status_rxflag_signal
		spw_data_rx_status_rxdata_o   : out std_logic_vector(7 downto 0); -- --                     .spw_data_rx_status_rxdata_signal
		spw_data_tx_status_txrdy_o    : out std_logic; --                    --                     .spw_data_tx_status_txrdy_signal
		spw_data_tx_status_txhalff_o  : out std_logic ---                    --                     .spw_data_tx_status_txhalff_signal
	);
end entity spw_controller_stimuli;

architecture RTL of spw_controller_stimuli is

	-- rmap write command
	constant c_RMAP_WRITE_CMD_LENGTH : natural                                          := 21;
	signal s_rmap_write_cmd_cnt      : natural range 0 to (c_RMAP_WRITE_CMD_LENGTH - 1) := 0;
	type t_rmap_write_cmd is array (0 to (c_RMAP_WRITE_CMD_LENGTH - 1)) of std_logic_vector(7 downto 0);
	constant c_RMAP_WRITE_CMD_OK     : t_rmap_write_cmd                                 := (
		x"51", x"01", x"6C", x"D1", x"50", x"00", x"00", x"00", x"AA", x"AA", x"AA", x"AA", x"00", x"00", x"04", x"E6",
		x"FF", x"FF", x"FF", x"FF", x"7B"
	);
	constant c_RMAP_WRITE_CMD_NOK    : t_rmap_write_cmd                                 := (
		x"51", x"01", x"6C", x"D0", x"50", x"00", x"00", x"00", x"AA", x"AA", x"AA", x"AA", x"00", x"00", x"04", x"B4",
		x"FF", x"FF", x"FF", x"FF", x"7B"
	);

	constant c_RMAP_READ_CMD_LENGTH : natural                                         := 16;
	signal s_rmap_read_cmd_cnt      : natural range 0 to (c_RMAP_READ_CMD_LENGTH - 1) := 0;
	type t_rmap_read_cmd is array (0 to (c_RMAP_READ_CMD_LENGTH - 1)) of std_logic_vector(7 downto 0);
	constant c_RMAP_READ_CMD_OK     : t_rmap_read_cmd                                 := (
		x"51", x"01", x"4C", x"D1", x"50", x"00", x"00", x"00", x"AA", x"AA", x"AA", x"AA", x"00", x"00", x"10", x"87"
	);
	constant c_RMAP_READ_CMD_NOK    : t_rmap_read_cmd                                 := (
		x"51", x"01", x"4C", x"D0", x"50", x"00", x"00", x"00", x"AA", x"AA", x"AA", x"AA", x"00", x"00", x"10", x"D5"
	);

	signal s_counter : natural := 0;

begin

	p_spw_controller_stimuli : process(clk_i, rst_i) is
	begin
		if (rst_i = '1') then

			spw_link_status_started_o    <= '0';
			spw_link_status_connecting_o <= '0';
			spw_link_status_running_o    <= '0';
			spw_link_error_errdisc_o     <= '0';
			spw_link_error_errpar_o      <= '0';
			spw_link_error_erresc_o      <= '0';
			spw_link_error_errcred_o     <= '0';
			spw_timecode_rx_tick_out_o   <= '0';
			spw_timecode_rx_ctrl_out_o   <= (others => '0');
			spw_timecode_rx_time_out_o   <= (others => '0');
			spw_data_rx_status_rxvalid_o <= '0';
			spw_data_rx_status_rxhalff_o <= '0';
			spw_data_rx_status_rxflag_o  <= '0';
			spw_data_rx_status_rxdata_o  <= (others => '0');
			spw_data_tx_status_txrdy_o   <= '0';
			spw_data_tx_status_txhalff_o <= '0';

			s_rmap_write_cmd_cnt <= 0;
			s_rmap_read_cmd_cnt  <= 0;

			s_counter <= 0;

		elsif rising_edge(clk_i) then

			spw_link_status_started_o    <= '0';
			spw_link_status_connecting_o <= '0';
			spw_link_status_running_o    <= '1';
			spw_link_error_errdisc_o     <= '0';
			spw_link_error_errpar_o      <= '0';
			spw_link_error_erresc_o      <= '0';
			spw_link_error_errcred_o     <= '0';
			spw_timecode_rx_tick_out_o   <= '0';
			spw_timecode_rx_ctrl_out_o   <= (others => '0');
			spw_timecode_rx_time_out_o   <= (others => '0');
			spw_data_rx_status_rxvalid_o <= '0';
			spw_data_rx_status_rxhalff_o <= '0';
			spw_data_rx_status_rxflag_o  <= '0';
			spw_data_rx_status_rxdata_o  <= (others => '0');
			spw_data_tx_status_txrdy_o   <= '1';
			spw_data_tx_status_txhalff_o <= '0';

			s_counter <= s_counter + 1;

			case s_counter is

				when 100 =>
					if (spw_data_rx_command_rxread_i = '0') then
						spw_data_rx_status_rxvalid_o <= '1';
						spw_data_rx_status_rxflag_o  <= '0';
						--						spw_data_rx_status_rxdata_o  <= c_RMAP_WRITE_CMD_OK(s_rmap_write_cmd_cnt);
						spw_data_rx_status_rxdata_o  <= c_RMAP_READ_CMD_OK(s_rmap_read_cmd_cnt);
						s_counter                    <= s_counter;
					else
						--						s_counter <= 200; -- write cmd
						s_counter <= 300; -- read cmd
					end if;

				when 200 =>
					if (s_rmap_write_cmd_cnt = (c_RMAP_WRITE_CMD_LENGTH - 1)) then
						s_rmap_write_cmd_cnt <= 0;
						s_counter            <= 500;
					else
						s_rmap_write_cmd_cnt <= s_rmap_write_cmd_cnt + 1;
						s_counter            <= 100;
					end if;

				when 300 =>
					if (s_rmap_read_cmd_cnt = (c_RMAP_READ_CMD_LENGTH - 1)) then
						s_rmap_read_cmd_cnt <= 0;
						s_counter           <= 500;
					else
						s_rmap_read_cmd_cnt <= s_rmap_read_cmd_cnt + 1;
						s_counter           <= 100;
					end if;

				when 500 =>
					if (spw_data_rx_command_rxread_i = '0') then
						spw_data_rx_status_rxvalid_o <= '1';
						spw_data_rx_status_rxflag_o  <= '1';
						spw_data_rx_status_rxdata_o  <= x"00"; -- eop
						s_counter                    <= s_counter;
					end if;

				when others =>
					null;

			end case;

		end if;
	end process p_spw_controller_stimuli;

end architecture RTL;
