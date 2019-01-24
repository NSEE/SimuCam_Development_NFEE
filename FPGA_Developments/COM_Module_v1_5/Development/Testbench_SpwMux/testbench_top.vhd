library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.spw_codec_pkg.all;

entity testbench_top is
end entity testbench_top;

architecture RTL of testbench_top is

	-- clk and rst signals
	signal clk200 : std_logic := '0';
	signal clk100 : std_logic := '0';
	signal rst    : std_logic := '1';

	-- dut signals

	-- spw mux
	signal s_mux_rx_channel_command : t_spw_codec_data_rx_command;
	signal s_mux_rx_channel_status  : t_spw_codec_data_rx_status;
	signal s_mux_tx_channel_command : t_spw_codec_data_tx_command;
	signal s_mux_tx_channel_status  : t_spw_codec_data_tx_status;

	signal s_mux_rx_0_command : t_spw_codec_data_rx_command;
	signal s_mux_rx_0_status  : t_spw_codec_data_rx_status;
	signal s_mux_tx_0_command : t_spw_codec_data_tx_command;
	signal s_mux_tx_0_status  : t_spw_codec_data_tx_status;

	signal s_mux_tx_1_command : t_spw_codec_data_tx_command;
	signal s_mux_tx_1_status  : t_spw_codec_data_tx_status;

	signal s_time_counter : natural;

	signal s_tx_0_counter : natural;
	signal s_tx_1_counter : natural;

begin

	clk200 <= not clk200 after 2.5 ns;  -- 200 MHz
	clk100 <= not clk100 after 5 ns;    -- 100 MHz
	rst    <= '0' after 100 ns;

	spw_mux_ent_inst : entity work.spw_mux_ent
		port map(
			clk_i                  => clk100,
			rst_i                  => rst,
			spw_codec_rx_status_i  => s_mux_rx_channel_status,
			spw_codec_tx_status_i  => s_mux_tx_channel_status,
			spw_mux_rx_0_command_i => s_mux_rx_0_command,
			spw_mux_tx_0_command_i => s_mux_tx_0_command,
			spw_mux_tx_1_command_i => s_mux_tx_1_command,
			spw_codec_rx_command_o => s_mux_rx_channel_command,
			spw_codec_tx_command_o => s_mux_tx_channel_command,
			spw_mux_rx_0_status_o  => s_mux_rx_0_status,
			spw_mux_tx_0_status_o  => s_mux_tx_0_status,
			spw_mux_tx_1_status_o  => s_mux_tx_1_status
		);

	p_channel_stimulli : process(clk100, rst) is
	begin
		if (rst = '1') then
			s_time_counter                  <= 0;
			s_mux_rx_channel_status.rxdata  <= x"00";
			s_mux_rx_channel_status.rxflag  <= '0';
			s_mux_rx_channel_status.rxhalff <= '0';
			s_mux_rx_channel_status.rxvalid <= '0';
			s_mux_tx_channel_status.txhalff <= '0';
			s_mux_tx_channel_status.txrdy   <= '0';
		elsif rising_edge(clk100) then

			s_time_counter <= s_time_counter + 1;

			s_mux_rx_channel_status.rxdata  <= x"00";
			s_mux_rx_channel_status.rxflag  <= '0';
			s_mux_rx_channel_status.rxhalff <= '0';
			s_mux_rx_channel_status.rxvalid <= '0';
			s_mux_tx_channel_status.txhalff <= '0';
			s_mux_tx_channel_status.txrdy   <= '0';

			case (s_time_counter) is
				when 120 to 174 =>
					s_mux_rx_channel_status.rxdata  <= std_logic_vector(to_unsigned(s_time_counter, 8));
					s_mux_rx_channel_status.rxflag  <= '0';
					s_mux_rx_channel_status.rxhalff <= '0';
					s_mux_rx_channel_status.rxvalid <= '1';
					s_mux_tx_channel_status.txhalff <= '0';
					s_mux_tx_channel_status.txrdy   <= '1';
				when 180 to 200 =>
					s_mux_rx_channel_status.rxdata  <= std_logic_vector(to_unsigned(s_time_counter, 8));
					s_mux_rx_channel_status.rxflag  <= '0';
					s_mux_rx_channel_status.rxhalff <= '0';
					s_mux_rx_channel_status.rxvalid <= '1';
					s_mux_tx_channel_status.txhalff <= '0';
					s_mux_tx_channel_status.txrdy   <= '1';
				when others =>
					null;
			end case;

		end if;
	end process p_channel_stimulli;

	p_ch0_stimulli : process(clk100, rst) is
	begin
		if (rst = '1') then
			s_mux_rx_0_command.rxread  <= '0';
			s_mux_tx_0_command.txdata  <= x"00";
			s_mux_tx_0_command.txflag  <= '0';
			s_mux_tx_0_command.txwrite <= '0';
			s_tx_0_counter             <= 16#10#;
		elsif rising_edge(clk100) then
			s_mux_rx_0_command.rxread  <= '0';
			s_mux_tx_0_command.txdata  <= x"00";
			s_mux_tx_0_command.txflag  <= '0';
			s_mux_tx_0_command.txwrite <= '0';

			case (s_time_counter) is
				when 110 to 140 =>
					s_mux_rx_0_command.rxread <= '1';
					if (s_mux_tx_0_status.txrdy = '1') then
						s_tx_0_counter             <= s_tx_0_counter + 1;
						s_mux_tx_0_command.txdata  <= std_logic_vector(to_unsigned(s_tx_0_counter, 8));
						s_mux_tx_0_command.txflag  <= '0';
						s_mux_tx_0_command.txwrite <= '1';
					end if;
				when 145 =>
					s_mux_rx_0_command.rxread <= '1';
					if (s_mux_tx_0_status.txrdy = '1') then
						s_mux_tx_0_command.txdata  <= x"00";
						s_mux_tx_0_command.txflag  <= '1';
						s_mux_tx_0_command.txwrite <= '1';
					end if;
				when 150 to 170 =>
					s_mux_rx_0_command.rxread <= '1';
					if (s_mux_tx_0_status.txrdy = '1') then
						s_tx_0_counter             <= s_tx_0_counter + 1;
						s_mux_tx_0_command.txdata  <= std_logic_vector(to_unsigned(s_tx_0_counter, 8));
						s_mux_tx_0_command.txflag  <= '0';
						s_mux_tx_0_command.txwrite <= '1';
					end if;
				when 175 =>
					s_mux_rx_0_command.rxread <= '1';
					if (s_mux_tx_0_status.txrdy = '1') then
						s_mux_tx_0_command.txdata  <= x"01";
						s_mux_tx_0_command.txflag  <= '1';
						s_mux_tx_0_command.txwrite <= '1';
					end if;
				when others =>
					null;
			end case;
		end if;
	end process p_ch0_stimulli;

	p_ch1_stimulli : process(clk100, rst) is
	begin
		if (rst = '1') then
			s_mux_tx_1_command.txdata  <= x"00";
			s_mux_tx_1_command.txflag  <= '0';
			s_mux_tx_1_command.txwrite <= '0';
			s_tx_1_counter             <= 16#50#;
		elsif rising_edge(clk100) then
			s_mux_tx_1_command.txdata  <= x"00";
			s_mux_tx_1_command.txflag  <= '0';
			s_mux_tx_1_command.txwrite <= '0';

			case (s_time_counter) is
				when 160 to 195 =>
					if (s_mux_tx_1_status.txrdy = '1') then
						s_tx_1_counter             <= s_tx_1_counter + 1;
						s_mux_tx_1_command.txdata  <= std_logic_vector(to_unsigned(s_tx_1_counter, 8));
						s_mux_tx_1_command.txflag  <= '0';
						s_mux_tx_1_command.txwrite <= '1';
					end if;
				when 200 =>
					if (s_mux_tx_1_status.txrdy = '1') then
						s_mux_tx_1_command.txdata  <= x"00";
						s_mux_tx_1_command.txflag  <= '1';
						s_mux_tx_1_command.txwrite <= '1';
					end if;
				when others =>
					null;
			end case;
		end if;
	end process p_ch1_stimulli;

end architecture RTL;
