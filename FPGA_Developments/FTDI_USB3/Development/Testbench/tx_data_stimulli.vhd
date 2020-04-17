library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tx_data_stimulli is
	generic(
		g_ADDRESS_WIDTH : natural range 1 to 64;
		g_DATA_WIDTH    : natural range 1 to 256
	);
	port(
		clk_i                   : in  std_logic;
		rst_i                   : in  std_logic;
		avalon_mm_waitrequest_i : in  std_logic; --                                     --          .waitrequest
		avalon_mm_address_o     : out std_logic_vector((g_ADDRESS_WIDTH - 1) downto 0); --          .address
		avalon_mm_write_o       : out std_logic; --                                     --          .write
		avalon_mm_writedata_o   : out std_logic_vector((g_DATA_WIDTH - 1) downto 0) --  --          .writedata
	);
end entity tx_data_stimulli;

architecture RTL of tx_data_stimulli is

	signal s_counter     : natural                                     := 0;
	signal s_address_cnt : natural range 0 to (2**g_ADDRESS_WIDTH - 1) := 0;
	signal s_times_cnt   : natural                                     := 0;

	-- Write Payload
	constant c_FTDI_WR_PAYLOAD_LENGTH  : natural                                           := 15;
	signal s_ftdi_wr_payload_cnt       : natural range 0 to (c_FTDI_WR_PAYLOAD_LENGTH - 1) := 0;
	type t_ftdi_prot_write_payload is array (0 to (c_FTDI_WR_PAYLOAD_LENGTH - 1)) of std_logic_vector(255 downto 0);
	constant c_FTDI_PROT_WRITE_PAYLOAD : t_ftdi_prot_write_payload                         := (
		x"123456789ABCDEF123456789ABCDEF123456789ABCDEF123456789ABCDEF1234",
		x"56789ABCDEF123456789ABCDEF123456789ABCDEF123456789ABCDEF12345678",
		x"9ABCDEF123456789ABCDEF123456789ABCDEF123456789ABCDEF123456789ABC",
		x"DEF123456789ABCDEF123456789ABCDEF123456789ABCDEF123456789ABCDEF1",
		x"23456789ABCDEF123456789ABCDEF123456789ABCDEF123456789ABCDEF12345",
		x"6789ABCDEF123456789ABCDEF123456789ABCDEF123456789ABCDEF123456789",
		x"ABCDEF123456789ABCDEF123456789ABCDEF123456789ABCDEF123456789ABCD",
		x"EF123456789ABCDEF123456789ABCDEF123456789ABCDEF123456789ABCDEF12",
		x"3456789ABCDEF123456789ABCDEF123456789ABCDEF123456789ABCDEF123456",
		x"789ABCDEF123456789ABCDEF123456789ABCDEF123456789ABCDEF123456789A",
		x"BCDEF123456789ABCDEF123456789ABCDEF123456789ABCDEF123456789ABCDE",
		x"F123456789ABCDEF123456789ABCDEF123456789ABCDEF123456789ABCDEF123",
		x"456789ABCDEF123456789ABCDEF123456789ABCDEF123456789ABCDEF1234567",
		x"89ABCDEF123456789ABCDEF123456789ABCDEF123456789ABCDEF123456789AB",
		x"CDEF123456789ABCDEF123456789ABCDEF123456789ABCDEF123456789ABCDEF"
	);

begin

	p_tx_data_stimulli : process(clk_i, rst_i) is
	begin
		if (rst_i = '1') then

			avalon_mm_address_o   <= (others => '0');
			avalon_mm_write_o     <= '0';
			avalon_mm_writedata_o <= (others => '0');
			s_ftdi_wr_payload_cnt <= 0;
			s_counter             <= 0;
			s_address_cnt         <= 0;
			s_times_cnt           <= 0;

		elsif rising_edge(clk_i) then

			avalon_mm_address_o   <= (others => '0');
			avalon_mm_write_o     <= '0';
			avalon_mm_writedata_o <= (others => '0');
			s_counter             <= s_counter + 1;

			case s_counter is

				--				when 100 to 101 =>
				--					-- register write
				--					--					avalon_mm_address_o                 <= std_logic_vector(to_unsigned(16#00#, g_ADDRESS_WIDTH));
				--					avalon_mm_address_o   <= std_logic_vector(to_unsigned(s_wr_addr, g_ADDRESS_WIDTH));
				--					avalon_mm_writedata_o <= c_FTDI_PROT_WRITE_PAYLOAD(v_payload_cnt);
				--					if (s_counter = 101) then
				--						if (v_payload_cnt < t_ftdi_prot_write_payload'high) then
				--							v_payload_cnt := v_payload_cnt + 1;
				--						else
				--							v_payload_cnt := 0;
				--						end if;
				--					end if;
				--					avalon_mm_write_o     <= '1';
				--					if (s_counter = 101) then
				--						if (s_wr_addr < (16 - 1)) then
				--							s_wr_addr <= s_wr_addr + 1;
				--							s_counter <= 100 - 1;
				--						else
				--							s_wr_addr <= 0;
				--							if (s_times >= (1 - 1)) then
				--								s_times   <= 0;
				--								s_counter <= 100 + 2;
				--							else
				--								s_times   <= s_times + 1;
				--								s_counter <= 100 - 5 - 1;
				--							end if;
				--						end if;
				--					end if;

				when 100 =>
					-- register write
					avalon_mm_address_o   <= std_logic_vector(to_unsigned(s_address_cnt, g_ADDRESS_WIDTH));
					avalon_mm_write_o     <= '1';
					avalon_mm_writedata_o <= c_FTDI_PROT_WRITE_PAYLOAD(s_ftdi_wr_payload_cnt);

				when 101 =>
					if (avalon_mm_waitrequest_i = '1') then
						s_counter <= 101;
					end if;
					-- register write
					avalon_mm_address_o   <= std_logic_vector(to_unsigned(s_address_cnt, g_ADDRESS_WIDTH));
					avalon_mm_write_o     <= '1';
					avalon_mm_writedata_o <= c_FTDI_PROT_WRITE_PAYLOAD(s_ftdi_wr_payload_cnt);

				when 102 =>
					s_counter     <= 100;
					if (s_ftdi_wr_payload_cnt = (c_FTDI_WR_PAYLOAD_LENGTH - 1)) then
						s_ftdi_wr_payload_cnt <= 0;
					else
						s_ftdi_wr_payload_cnt <= s_ftdi_wr_payload_cnt + 1;
					end if;
					s_address_cnt <= s_address_cnt + 1;
					--					if (s_address_cnt = ((2 ** g_ADDRESS_WIDTH) - 1)) then
					if (s_address_cnt = (16 - 1)) then
						if (s_times_cnt < (1 - 1)) then
							s_counter     <= 100;
							s_address_cnt <= 0;
							s_times_cnt   <= s_times_cnt + 1;
						else
							s_counter     <= 5000;
							s_address_cnt <= 0;
							s_times_cnt   <= 0;
						end if;
					end if;

				--				when 50000 to 50001 =>
				--					-- register write
				--					--					avalon_mm_address_o                 <= std_logic_vector(to_unsigned(16#00#, g_ADDRESS_WIDTH));
				--					avalon_mm_address_o                 <= std_logic_vector(to_unsigned(s_wr_addr, g_ADDRESS_WIDTH));
				--					avalon_mm_writedata_o(7 downto 0)   <= std_logic_vector(to_unsigned(v_data_cnt, 8));
				--					v_data_cnt                          := v_data_cnt + 1;
				--					avalon_mm_writedata_o(15 downto 8)  <= std_logic_vector(to_unsigned(v_data_cnt, 8));
				--					v_data_cnt                          := v_data_cnt + 1;
				--					avalon_mm_writedata_o(23 downto 16) <= std_logic_vector(to_unsigned(v_data_cnt, 8));
				--					v_data_cnt                          := v_data_cnt + 1;
				--					avalon_mm_writedata_o(31 downto 24) <= std_logic_vector(to_unsigned(v_data_cnt, 8));
				--					v_data_cnt                          := v_data_cnt + 1;
				--					avalon_mm_writedata_o(39 downto 32) <= std_logic_vector(to_unsigned(v_data_cnt, 8));
				--					v_data_cnt                          := v_data_cnt + 1;
				--					avalon_mm_writedata_o(47 downto 40) <= std_logic_vector(to_unsigned(v_data_cnt, 8));
				--					v_data_cnt                          := v_data_cnt + 1;
				--					avalon_mm_writedata_o(55 downto 48) <= std_logic_vector(to_unsigned(v_data_cnt, 8));
				--					v_data_cnt                          := v_data_cnt + 1;
				--					avalon_mm_writedata_o(63 downto 56) <= std_logic_vector(to_unsigned(v_data_cnt, 8));
				--					v_data_cnt                          := v_data_cnt + 1;
				--					avalon_mm_write_o                   <= '1';
				--					if (s_counter = 50001) then
				--						if (s_wr_addr < 1023) then
				--							s_wr_addr <= s_wr_addr + 1;
				--							s_counter <= 50000 - 1;
				--						else
				--							s_wr_addr <= 0;
				--							if (s_times >= (4 - 1)) then
				--								s_times   <= 0;
				--								s_counter <= 50000 + 2;
				--							else
				--								s_times   <= s_times + 1;
				--								s_counter <= 50000 - 5000 - 1;
				--							end if;
				--						end if;
				--					end if;

				when others =>
					null;

			end case;

		end if;
	end process p_tx_data_stimulli;

end architecture RTL;
