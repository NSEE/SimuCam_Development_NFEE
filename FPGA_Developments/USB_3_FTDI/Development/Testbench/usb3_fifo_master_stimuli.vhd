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

	-- ACK Package
	type t_ftdi_prot_ack_package is array (0 to 7) of std_logic_vector(31 downto 0);
	constant c_FTDI_PROT_ACK_PACKAGE : t_ftdi_prot_ack_package := (
		x"55555555",
		x"20202020",
		x"00000000",
		x"00000000",
		x"00000000",
		x"00000000",
		x"58374840",
		x"33333333"
	);

	-- Reply Package
	type t_ftdi_prot_reply_package is array (0 to 7) of std_logic_vector(31 downto 0);
	constant c_FTDI_PROT_REPLY_PACKAGE : t_ftdi_prot_reply_package := (
		x"55555555",
		x"02020202",
		x"01020300",
		x"07001000",
		x"6B030000",
		x"10010000",  
		x"30DB8FEB",
		x"33333333"
	);

	-- Reply Payload
	type t_ftdi_prot_reply_payload is array (0 to 69) of std_logic_vector(31 downto 0);
	constant c_FTDI_PROT_REPLY_PAYLOAD : t_ftdi_prot_reply_payload := (
		x"01F400F4",
		x"03F402F4",
		x"05F404F4",
		x"20F406F4",
		x"22F421F4",
		x"24F423F4",
		x"26F425F4",
		x"41F440F4",
		x"43F442F4",
		x"45F444F4",
		x"60F446F4",
		x"62F461F4",
		x"64F463F4",
		x"66F465F4",
		x"81F480F4",
		x"83F482F4",
		x"85F484F4",
		x"A0F486F4",
		x"A2F4A1F4",
		x"A4F4A3F4",
		x"A6F4A5F4",
		x"C1F4C0F4",
		x"C3F4C2F4",
		x"C5F4C4F4",
		x"E0F4C6F4",
		x"E2F4E1F4",
		x"E4F4E3F4",
		x"E6F4E5F4",
		x"01F500F5",
		x"03F502F5",
		x"05F504F5",
		x"20F506F5",
		x"FFFFFFFF",
		x"FFFFFFFF",
		x"22F521F5",
		x"24F523F5",
		x"26F525F5",
		x"41F540F5",
		x"43F542F5",
		x"45F544F5",
		x"60F546F5",
		x"62F561F5",
		x"64F563F5",
		x"66F565F5",
		x"81F580F5",
		x"83F582F5",
		x"85F584F5",
		x"A0F586F5",
		x"A2F5A1F5",
		x"A4F5A3F5",
		x"A6F5A5F5",
		x"C1F5C0F5",
		x"C3F5C2F5",
		x"C5F5C4F5",
		x"E0F5C6F5",
		x"E2F5E1F5",
		x"E4F5E3F5",
		x"E6F5E5F5",
		x"00000000",
		x"00000000",
		x"00000000",
		x"00000000",
		x"00000000",
		x"00000000",
		x"00000000",
		x"00000000",
		x"FFFFFFFF",
		x"0000FFFF",
		x"37AB0228",
		x"77777777"
	);

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

				when 30 to 32 =>
					umft_rxf_n_pin_o        <= '0';
					umft_txe_n_pin_o        <= '1';
					s_umft601a_data_out     <= (others => '0');
					s_umft601a_wakeup_n_out <= '1';
					s_umft601a_be_out       <= (others => '0');
					s_umft601a_gpio_out     <= (others => '1');
					v_data_cnt              := 0;

				when 33 to (33 - 1 + 8) =>
					umft_rxf_n_pin_o        <= '0';
					umft_txe_n_pin_o        <= '1';
					s_umft601a_data_out     <= c_FTDI_PROT_ACK_PACKAGE(v_data_cnt);
					v_data_cnt              := v_data_cnt + 1;
					s_umft601a_wakeup_n_out <= '1';
					s_umft601a_be_out       <= (others => '1');
					s_umft601a_gpio_out     <= (others => '1');

				when 70 to 72 =>
					umft_rxf_n_pin_o        <= '0';
					umft_txe_n_pin_o        <= '1';
					s_umft601a_data_out     <= (others => '0');
					s_umft601a_wakeup_n_out <= '1';
					s_umft601a_be_out       <= (others => '0');
					s_umft601a_gpio_out     <= (others => '1');
					v_data_cnt              := 0;

				when 73 to (73 - 1 + 8) =>
					umft_rxf_n_pin_o        <= '0';
					umft_txe_n_pin_o        <= '1';
					s_umft601a_data_out     <= c_FTDI_PROT_REPLY_PACKAGE(v_data_cnt);
					v_data_cnt              := v_data_cnt + 1;
					s_umft601a_wakeup_n_out <= '1';
					s_umft601a_be_out       <= (others => '1');
					s_umft601a_gpio_out     <= (others => '1');
					
				when 120 to 122 =>
					umft_rxf_n_pin_o        <= '0';
					umft_txe_n_pin_o        <= '1';
					s_umft601a_data_out     <= (others => '0');
					s_umft601a_wakeup_n_out <= '1';
					s_umft601a_be_out       <= (others => '0');
					s_umft601a_gpio_out     <= (others => '1');
					v_data_cnt              := 0;

				when 123 to (123 - 1 + 70) =>
					umft_rxf_n_pin_o        <= '0';
					umft_txe_n_pin_o        <= '1';
					s_umft601a_data_out     <= c_FTDI_PROT_REPLY_PAYLOAD(v_data_cnt);
					v_data_cnt              := v_data_cnt + 1;
					s_umft601a_wakeup_n_out <= '1';
					s_umft601a_be_out       <= (others => '1');
					s_umft601a_gpio_out     <= (others => '1');

				--				when 2500 to 2502 =>
				--					umft_rxf_n_pin_o        <= '0';
				--					umft_txe_n_pin_o        <= '1';
				--					s_umft601a_data_out     <= (others => '0');
				--					s_umft601a_wakeup_n_out <= '1';
				--					s_umft601a_be_out       <= (others => '0');
				--					s_umft601a_gpio_out     <= (others => '1');
				--					v_data_cnt              := 0;
				--
				--				when 2503 to (2503 - 1 + 1024) =>
				--					umft_rxf_n_pin_o                  <= '0';
				--					umft_txe_n_pin_o                  <= '1';
				--					s_umft601a_data_out(7 downto 0)   <= std_logic_vector(to_unsigned(v_data_cnt, 8));
				--					v_data_cnt                        := v_data_cnt + 1;
				--					s_umft601a_data_out(15 downto 8)  <= std_logic_vector(to_unsigned(v_data_cnt, 8));
				--					v_data_cnt                        := v_data_cnt + 1;
				--					s_umft601a_data_out(23 downto 16) <= std_logic_vector(to_unsigned(v_data_cnt, 8));
				--					v_data_cnt                        := v_data_cnt + 1;
				--					s_umft601a_data_out(31 downto 24) <= std_logic_vector(to_unsigned(v_data_cnt, 8));
				--					v_data_cnt                        := v_data_cnt + 1;
				--					s_umft601a_wakeup_n_out           <= '1';
				--					s_umft601a_be_out                 <= (others => '1');
				--					s_umft601a_gpio_out               <= (others => '1');
				--
				--				when (2503 + 1024) =>
				--					if (s_times_cnt >= (8 - 1)) then
				--						s_times_cnt <= 0;
				--					else
				--						s_times_cnt <= s_times_cnt + 1;
				--						s_counter   <= 2500 - 2000;
				--					end if;

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

				--								when 60000 to 60002 =>
				--									umft_rxf_n_pin_o        <= '1';
				--									umft_txe_n_pin_o        <= '0';
				--									s_umft601a_data_out     <= (others => '0');
				--									s_umft601a_wakeup_n_out <= '1';
				--									s_umft601a_be_out       <= (others => '0');
				--									s_umft601a_gpio_out     <= (others => '1');
				--									v_data_cnt              := 0;
				--				
				--								when 60003 to (60003 - 1 + 1024) =>
				--									umft_rxf_n_pin_o        <= '1';
				--									umft_txe_n_pin_o        <= '0';
				--									s_umft601a_data_out     <= (others => '0');
				--									s_umft601a_wakeup_n_out <= '1';
				--									s_umft601a_be_out       <= (others => '0');
				--									s_umft601a_gpio_out     <= (others => '1');
				--									v_data_cnt              := 0;

				--				when (60003 + 1024) =>
				--					if (s_times_cnt >= (8 - 1)) then
				--						s_times_cnt <= 0;
				--					else
				--						s_times_cnt <= s_times_cnt + 1;
				--						s_counter   <= 60000 - 2000;
				--					end if;
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
