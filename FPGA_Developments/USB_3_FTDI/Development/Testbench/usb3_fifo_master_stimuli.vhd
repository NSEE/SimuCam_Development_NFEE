library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity usb3_fifo_master_stimuli is
	port(
		clk_i                : in    std_logic;
		rst_i                : in    std_logic;
		umft_wr_n_pin_i      : in    std_logic                     := '1';
		umft_rd_n_pin_i      : in    std_logic                     := '1';
		umft_oe_n_pin_i      : in    std_logic                     := '1';
		umft_data_bus_io     : inout std_logic_vector(31 downto 0) := (others => 'Z');
		umft_wakeup_n_pin_io : inout std_logic                     := 'Z';
		umft_be_bus_io       : inout std_logic_vector(3 downto 0)  := (others => 'Z');
		umft_gpio_bus_io     : inout std_logic_vector(1 downto 0)  := (others => 'Z');
		umft_rxf_n_pin_o     : out   std_logic;
		umft_txe_n_pin_o     : out   std_logic
	);
end entity usb3_fifo_master_stimuli;

architecture RTL of usb3_fifo_master_stimuli is

	signal s_umft601a_data_out     : std_logic_vector(31 downto 0);
	signal s_umft601a_wakeup_n_out : std_logic;
	signal s_umft601a_be_out       : std_logic_vector(3 downto 0);
	signal s_umft601a_gpio_out     : std_logic_vector(1 downto 0);
	signal s_umft601a_oe           : std_logic;
	signal s_umft601a_data_in      : std_logic_vector(31 downto 0);
	signal s_umft601a_wakeup_n_in  : std_logic;
	signal s_umft601a_be_in        : std_logic_vector(3 downto 0);
	signal s_umft601a_gpio_in      : std_logic_vector(1 downto 0);

	signal s_counter   : natural := 0;
	signal s_counter2  : natural := 0;
	signal s_times_cnt : natural := 0;

begin

	-- bidir io buffer instantiation, for the umft601a module pins (fpga <--> umft601a)
	ftdi_inout_io_buffer_39b_inst : entity work.ftdi_inout_io_buffer_39b
		port map(
			datain(38 downto 7)  => s_umft601a_data_out,
			datain(6)            => s_umft601a_wakeup_n_out,
			datain(5 downto 2)   => s_umft601a_be_out,
			datain(1 downto 0)   => s_umft601a_gpio_out,
			oe(38)               => s_umft601a_oe,
			oe(37)               => s_umft601a_oe,
			oe(36)               => s_umft601a_oe,
			oe(35)               => s_umft601a_oe,
			oe(34)               => s_umft601a_oe,
			oe(33)               => s_umft601a_oe,
			oe(32)               => s_umft601a_oe,
			oe(31)               => s_umft601a_oe,
			oe(30)               => s_umft601a_oe,
			oe(29)               => s_umft601a_oe,
			oe(28)               => s_umft601a_oe,
			oe(27)               => s_umft601a_oe,
			oe(26)               => s_umft601a_oe,
			oe(25)               => s_umft601a_oe,
			oe(24)               => s_umft601a_oe,
			oe(23)               => s_umft601a_oe,
			oe(22)               => s_umft601a_oe,
			oe(21)               => s_umft601a_oe,
			oe(20)               => s_umft601a_oe,
			oe(19)               => s_umft601a_oe,
			oe(18)               => s_umft601a_oe,
			oe(17)               => s_umft601a_oe,
			oe(16)               => s_umft601a_oe,
			oe(15)               => s_umft601a_oe,
			oe(14)               => s_umft601a_oe,
			oe(13)               => s_umft601a_oe,
			oe(12)               => s_umft601a_oe,
			oe(11)               => s_umft601a_oe,
			oe(10)               => s_umft601a_oe,
			oe(9)                => s_umft601a_oe,
			oe(8)                => s_umft601a_oe,
			oe(7)                => s_umft601a_oe,
			oe(6)                => s_umft601a_oe,
			oe(5)                => s_umft601a_oe,
			oe(4)                => s_umft601a_oe,
			oe(3)                => s_umft601a_oe,
			oe(2)                => s_umft601a_oe,
			oe(1)                => s_umft601a_oe,
			oe(0)                => s_umft601a_oe,
			dataio(38 downto 7)  => umft_data_bus_io,
			dataio(6)            => umft_wakeup_n_pin_io,
			dataio(5 downto 2)   => umft_be_bus_io,
			dataio(1 downto 0)   => umft_gpio_bus_io,
			dataout(38 downto 7) => s_umft601a_data_in,
			dataout(6)           => s_umft601a_wakeup_n_in,
			dataout(5 downto 2)  => s_umft601a_be_in,
			dataout(1 downto 0)  => s_umft601a_gpio_in
		);
	s_umft601a_oe <= not (umft_oe_n_pin_i);

	p_usb3_fifo_master_stimuli : process(clk_i, rst_i) is
		variable v_data_cnt : natural := 0;
	begin
		if (rst_i = '1') then

			umft_rxf_n_pin_o        <= '1';
			umft_txe_n_pin_o        <= '1';
			s_umft601a_data_out     <= (others => '0');
			s_umft601a_wakeup_n_out <= '1';
			s_umft601a_be_out       <= (others => '0');
			s_umft601a_gpio_out     <= (others => '1');
			s_counter               <= 0;
			s_counter2              <= 0;
			v_data_cnt              := 0;
			s_times_cnt             <= 0;

		elsif rising_edge(clk_i) then

			umft_rxf_n_pin_o        <= '1';
			umft_txe_n_pin_o        <= '1';
			s_umft601a_data_out     <= (others => '0');
			s_umft601a_wakeup_n_out <= '1';
			s_umft601a_be_out       <= (others => '0');
			s_umft601a_gpio_out     <= (others => '1');
			s_counter               <= s_counter + 1;
			s_counter2              <= s_counter2 + 1;

			case s_counter is

				when 2500 to 2502 =>
					umft_rxf_n_pin_o        <= '0';
					umft_txe_n_pin_o        <= '1';
					s_umft601a_data_out     <= (others => '0');
					s_umft601a_wakeup_n_out <= '1';
					s_umft601a_be_out       <= (others => '0');
					s_umft601a_gpio_out     <= (others => '1');
					v_data_cnt              := 0;

				when 2503 to (2503 - 1 + 1024) =>
					umft_rxf_n_pin_o                  <= '0';
					umft_txe_n_pin_o                  <= '1';
					s_umft601a_data_out(7 downto 0)   <= std_logic_vector(to_unsigned(v_data_cnt, 8));
					v_data_cnt                        := v_data_cnt + 1;
					s_umft601a_data_out(15 downto 8)  <= std_logic_vector(to_unsigned(v_data_cnt, 8));
					v_data_cnt                        := v_data_cnt + 1;
					s_umft601a_data_out(23 downto 16) <= std_logic_vector(to_unsigned(v_data_cnt, 8));
					v_data_cnt                        := v_data_cnt + 1;
					s_umft601a_data_out(31 downto 24) <= std_logic_vector(to_unsigned(v_data_cnt, 8));
					v_data_cnt                        := v_data_cnt + 1;
					s_umft601a_wakeup_n_out           <= '1';
					s_umft601a_be_out                 <= (others => '1');
					s_umft601a_gpio_out               <= (others => '1');

				when (2503 + 1024) =>
					if (s_times_cnt >= (8 - 1)) then
						s_times_cnt <= 0;
					else
						s_times_cnt <= s_times_cnt + 1;
						s_counter   <= 2500 - 2000;
					end if;

				--				when 3500 to 3502 =>
				--					umft_rxf_n_pin_o        <= '0';
				--					umft_txe_n_pin_o        <= '1';
				--					s_umft601a_data_out     <= (others => '0');
				--					s_umft601a_wakeup_n_out <= '1';
				--					s_umft601a_be_out       <= (others => '0');
				--					s_umft601a_gpio_out     <= (others => '1');
				--					v_data_cnt              := 0;
				--				
				--				when 3503 to (3503 - 1 + 1024) =>
				--					umft_rxf_n_pin_o                  <= '0';
				--					umft_txe_n_pin_o                  <= '1';
				--					s_umft601a_data_out(31 downto 24) <= std_logic_vector(to_unsigned(v_data_cnt, 8));
				--					v_data_cnt                        := v_data_cnt + 1;
				--					s_umft601a_data_out(23 downto 16) <= std_logic_vector(to_unsigned(v_data_cnt, 8));
				--					v_data_cnt                        := v_data_cnt + 1;
				--					s_umft601a_data_out(15 downto 8)  <= std_logic_vector(to_unsigned(v_data_cnt, 8));
				--					v_data_cnt                        := v_data_cnt + 1;
				--					s_umft601a_data_out(7 downto 0)   <= std_logic_vector(to_unsigned(v_data_cnt, 8));
				--					v_data_cnt                        := v_data_cnt + 1;
				--					s_umft601a_wakeup_n_out           <= '1';
				--					s_umft601a_be_out                 <= (others => '1');
				--					s_umft601a_gpio_out               <= (others => '1');
				--					
				--				when 5500 to 5502 =>
				--					umft_rxf_n_pin_o        <= '0';
				--					umft_txe_n_pin_o        <= '1';
				--					s_umft601a_data_out     <= (others => '0');
				--					s_umft601a_wakeup_n_out <= '1';
				--					s_umft601a_be_out       <= (others => '0');
				--					s_umft601a_gpio_out     <= (others => '1');
				--					v_data_cnt              := 0;
				--					
				--				when 5503 to (5503 - 1 + 512) =>
				--					umft_rxf_n_pin_o                  <= '0';
				--					umft_txe_n_pin_o                  <= '1';
				--					s_umft601a_data_out(31 downto 24) <= std_logic_vector(to_unsigned(v_data_cnt, 8));
				--					v_data_cnt                        := v_data_cnt + 1;
				--					s_umft601a_data_out(23 downto 16) <= std_logic_vector(to_unsigned(v_data_cnt, 8));
				--					v_data_cnt                        := v_data_cnt + 1;
				--					s_umft601a_data_out(15 downto 8)  <= std_logic_vector(to_unsigned(v_data_cnt, 8));
				--					v_data_cnt                        := v_data_cnt + 1;
				--					s_umft601a_data_out(7 downto 0)   <= std_logic_vector(to_unsigned(v_data_cnt, 8));
				--					v_data_cnt                        := v_data_cnt + 1;
				--					s_umft601a_wakeup_n_out           <= '1';
				--					s_umft601a_be_out                 <= (others => '1');
				--					s_umft601a_gpio_out               <= (others => '1');
				--					
				--				when 7500 to 7502 =>
				--					umft_rxf_n_pin_o        <= '0';
				--					umft_txe_n_pin_o        <= '1';
				--					s_umft601a_data_out     <= (others => '0');
				--					s_umft601a_wakeup_n_out <= '1';
				--					s_umft601a_be_out       <= (others => '0');
				--					s_umft601a_gpio_out     <= (others => '1');
				--					v_data_cnt              := 0;
				--					
				--				when 7503 to (7503 - 1 + 1024) =>
				--					umft_rxf_n_pin_o                  <= '0';
				--					umft_txe_n_pin_o                  <= '1';
				--					s_umft601a_data_out(31 downto 24) <= std_logic_vector(to_unsigned(v_data_cnt, 8));
				--					v_data_cnt                        := v_data_cnt + 1;
				--					s_umft601a_data_out(23 downto 16) <= std_logic_vector(to_unsigned(v_data_cnt, 8));
				--					v_data_cnt                        := v_data_cnt + 1;
				--					s_umft601a_data_out(15 downto 8)  <= std_logic_vector(to_unsigned(v_data_cnt, 8));
				--					v_data_cnt                        := v_data_cnt + 1;
				--					s_umft601a_data_out(7 downto 0)   <= std_logic_vector(to_unsigned(v_data_cnt, 8));
				--					v_data_cnt                        := v_data_cnt + 1;
				--					s_umft601a_wakeup_n_out           <= '1';
				--					s_umft601a_be_out                 <= (others => '1');
				--					s_umft601a_gpio_out               <= (others => '1');
				--					
				--				when 9500 to 9502 =>
				--					umft_rxf_n_pin_o        <= '0';
				--					umft_txe_n_pin_o        <= '1';
				--					s_umft601a_data_out     <= (others => '0');
				--					s_umft601a_wakeup_n_out <= '1';
				--					s_umft601a_be_out       <= (others => '0');
				--					s_umft601a_gpio_out     <= (others => '1');
				--					v_data_cnt              := 0;
				--					
				--				when 9503 to (9503 - 1 + 1024) =>
				--					umft_rxf_n_pin_o                  <= '0';
				--					umft_txe_n_pin_o                  <= '1';
				--					s_umft601a_data_out(31 downto 24) <= std_logic_vector(to_unsigned(v_data_cnt, 8));
				--					v_data_cnt                        := v_data_cnt + 1;
				--					s_umft601a_data_out(23 downto 16) <= std_logic_vector(to_unsigned(v_data_cnt, 8));
				--					v_data_cnt                        := v_data_cnt + 1;
				--					s_umft601a_data_out(15 downto 8)  <= std_logic_vector(to_unsigned(v_data_cnt, 8));
				--					v_data_cnt                        := v_data_cnt + 1;
				--					s_umft601a_data_out(7 downto 0)   <= std_logic_vector(to_unsigned(v_data_cnt, 8));
				--					v_data_cnt                        := v_data_cnt + 1;
				--					s_umft601a_wakeup_n_out           <= '1';
				--					s_umft601a_be_out                 <= (others => '1');
				--					s_umft601a_gpio_out               <= (others => '1');

				--				when (1503 - 1 + 1024) =>
				--					umft_rxf_n_pin_o                  <= '0';
				--					umft_txe_n_pin_o                  <= '1';
				--					s_umft601a_data_out(31 downto 24) <= std_logic_vector(to_unsigned(v_data_cnt, 8));
				--					v_data_cnt                        := v_data_cnt + 1;
				--					s_umft601a_data_out(23 downto 16) <= std_logic_vector(to_unsigned(v_data_cnt, 8));
				--					v_data_cnt                        := v_data_cnt + 1;
				--					s_umft601a_data_out(15 downto 8)  <= std_logic_vector(to_unsigned(v_data_cnt, 8));
				--					v_data_cnt                        := v_data_cnt + 1;
				--					s_umft601a_data_out(7 downto 0)   <= std_logic_vector(to_unsigned(v_data_cnt, 8));
				--					v_data_cnt                        := v_data_cnt + 1;
				--					s_umft601a_wakeup_n_out           <= '1';
				--					s_umft601a_be_out(3)               <= '0';
				--					s_umft601a_be_out(2)               <= '0';
				--					s_umft601a_be_out(1)               <= '0';
				--					s_umft601a_be_out(0)               <= '1';
				--					s_umft601a_gpio_out               <= (others => '1');

								when 60000 to 60002 =>
									umft_rxf_n_pin_o        <= '1';
									umft_txe_n_pin_o        <= '0';
									s_umft601a_data_out     <= (others => '0');
									s_umft601a_wakeup_n_out <= '1';
									s_umft601a_be_out       <= (others => '0');
									s_umft601a_gpio_out     <= (others => '1');
									v_data_cnt              := 0;
				
								when 60003 to (60003 - 1 + 1024) =>
									umft_rxf_n_pin_o        <= '1';
									umft_txe_n_pin_o        <= '0';
									s_umft601a_data_out     <= (others => '0');
									s_umft601a_wakeup_n_out <= '1';
									s_umft601a_be_out       <= (others => '0');
									s_umft601a_gpio_out     <= (others => '1');
									v_data_cnt              := 0;
									
				when (60003 + 1024) =>
					if (s_times_cnt >= (8 - 1)) then
						s_times_cnt <= 0;
					else
						s_times_cnt <= s_times_cnt + 1;
						s_counter   <= 60000 - 2000;
					end if;
				--					
				--				when 32500 to 32502 =>
				--					umft_rxf_n_pin_o        <= '1';
				--					umft_txe_n_pin_o        <= '0';
				--					s_umft601a_data_out     <= (others => '0');
				--					s_umft601a_wakeup_n_out <= '1';
				--					s_umft601a_be_out       <= (others => '0');
				--					s_umft601a_gpio_out     <= (others => '1');
				--					v_data_cnt              := 0;
				--
				--				when 32503 to (32503 - 1 + 900) =>
				--					umft_rxf_n_pin_o        <= '1';
				--					umft_txe_n_pin_o        <= '0';
				--					s_umft601a_data_out     <= (others => '0');
				--					s_umft601a_wakeup_n_out <= '1';
				--					s_umft601a_be_out       <= (others => '0');
				--					s_umft601a_gpio_out     <= (others => '1');
				--					v_data_cnt              := 0;
				--					
				--				when 15500 to 15502 =>
				--					umft_rxf_n_pin_o        <= '1';
				--					umft_txe_n_pin_o        <= '0';
				--					s_umft601a_data_out     <= (others => '0');
				--					s_umft601a_wakeup_n_out <= '1';
				--					s_umft601a_be_out       <= (others => '0');
				--					s_umft601a_gpio_out     <= (others => '1');
				--					v_data_cnt              := 0;
				--
				--				when 15503 to (15503 - 1 + 1024) =>
				--					umft_rxf_n_pin_o        <= '1';
				--					umft_txe_n_pin_o        <= '0';
				--					s_umft601a_data_out     <= (others => '0');
				--					s_umft601a_wakeup_n_out <= '1';
				--					s_umft601a_be_out       <= (others => '0');
				--					s_umft601a_gpio_out     <= (others => '1');
				--					v_data_cnt              := 0;

				--				when 15000 =>
				--					s_counter               <= 0;

				when others =>
					null;

			end case;

			--			umft_txe_n_pin_o        <= '1';
			--			
			--			case s_counter2 is
			--				
			--				when 2526 to 2528 =>
			--					umft_txe_n_pin_o        <= '0';
			--
			--				when 2529 to (2529 - 1 + 1024) =>
			--					umft_txe_n_pin_o        <= '0';
			--					
			--				when others =>
			--					null;
			--
			--			end case;

		end if;
	end process p_usb3_fifo_master_stimuli;

end architecture RTL;
