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

	signal s_counter : natural                                         := 0;
	signal s_times   : natural                                         := 0;
	signal s_wr_addr : natural range 0 to ((2 ** g_ADDRESS_WIDTH) - 1) := 0;

	-- Write Payload
	type t_ftdi_prot_write_payload is array (0 to 7) of std_logic_vector(255 downto 0);
	constant c_FTDI_PROT_WRITE_PAYLOAD : t_ftdi_prot_write_payload := (
		x"F440F441F425F426F423F424F421F422F406F420F404F405F402F403F400F401",
		x"F482F483F480F481F465F466F463F464F461F462F446F460F444F445F442F443",
		x"F4C4F4C5F4C2F4C3F4C0F4C1F4A5F4A6F4A3F4A4F4A1F4A2F486F4A0F484F485",
		x"F506F520F504F505F502F503F500F501F4E5F4E6F4E3F4E4F4E1F4E2F4C6F4E0",
		x"F544F545F542F543F540F541F525F526F523F524F521F522FFFFFFFFFFFFFFFF",
		x"F586F5A0F584F585F582F583F580F581F565F566F563F564F561F562F546F560",
		x"F5E1F5E2F5C6F5E0F5C4F5C5F5C2F5C3F5C0F5C1F5A5F5A6F5A3F5A4F5A1F5A2",
		x"55555555555555555555555555555555FFFF0000FFFFFFFFF5E5F5E6F5E3F5E4"
	);

begin

	p_tx_data_stimulli : process(clk_i, rst_i) is
		variable v_data_cnt    : natural := 0;
		variable v_payload_cnt : natural := 0;
	begin
		if (rst_i = '1') then

			avalon_mm_address_o   <= (others => '0');
			avalon_mm_write_o     <= '0';
			avalon_mm_writedata_o <= (others => '0');
			s_counter             <= 0;
			s_times               <= 0;
			s_wr_addr             <= 0;
			v_data_cnt            := 0;
			v_payload_cnt         := 0;

		elsif rising_edge(clk_i) then

			avalon_mm_address_o   <= (others => '0');
			avalon_mm_write_o     <= '0';
			avalon_mm_writedata_o <= (others => '0');
			s_counter             <= s_counter + 1;

			case s_counter is

				when 100 to 101 =>
					-- register write
					--					avalon_mm_address_o                 <= std_logic_vector(to_unsigned(16#00#, g_ADDRESS_WIDTH));
					avalon_mm_address_o <= std_logic_vector(to_unsigned(s_wr_addr, g_ADDRESS_WIDTH));
					if (v_payload_cnt < 8) then
						avalon_mm_writedata_o <= c_FTDI_PROT_WRITE_PAYLOAD(v_payload_cnt);
						if (s_counter = 101) then
							v_payload_cnt := v_payload_cnt + 1;
						end if;
					else
						for i in 0 to 31 loop
							avalon_mm_writedata_o((i * 8 + 7) downto (i * 8)) <= std_logic_vector(to_unsigned(v_data_cnt, 8));
							v_data_cnt                                        := v_data_cnt + 1;
						end loop;
					end if;
					avalon_mm_write_o   <= '1';
					if (s_counter = 101) then
						if (s_wr_addr < 255) then
							s_wr_addr <= s_wr_addr + 1;
							s_counter <= 100 - 1;
						else
							s_wr_addr <= 0;
							if (s_times >= (1 - 1)) then
								s_times   <= 0;
								s_counter <= 100 + 2;
							else
								s_times   <= s_times + 1;
								s_counter <= 100 - 5 - 1;
							end if;
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
