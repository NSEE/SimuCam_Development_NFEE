library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity avalon_buffer_L_stimuli is
	generic(
		g_ADDRESS_WIDTH : natural range 1 to 64;
		g_DATA_WIDTH    : natural range 1 to 256
	);
	port(
		clk_i                   : in  std_logic;
		rst_i                   : in  std_logic;
		avalon_mm_waitrequest_i : in  std_logic; --                                     -- avalon_mm.waitrequest
		avalon_mm_address_o     : out std_logic_vector((g_ADDRESS_WIDTH - 1) downto 0); --          .address
		avalon_mm_write_o       : out std_logic; --                                     --          .write
		avalon_mm_writedata_o   : out std_logic_vector((g_DATA_WIDTH - 1) downto 0) --  --          .writedata
	);
end entity avalon_buffer_L_stimuli;

architecture RTL of avalon_buffer_L_stimuli is

	function f_next_data(
		curr_data_i   : natural range 0 to 255;
		start_value_i : natural range 0 to 255;
		final_value_i : natural range 0 to 255;
		step_i        : natural range 0 to 255;
		inc_i         : std_logic
	) return natural is
		variable v_next_data : natural range 0 to 255;
	begin

		if (inc_i = '1') then
			if (curr_data_i >= final_value_i) then
				v_next_data := start_value_i;
			else
				v_next_data := curr_data_i + step_i;
			end if;
		else
			if (curr_data_i <= final_value_i) then
				v_next_data := start_value_i;
			else
				v_next_data := curr_data_i - step_i;
			end if;
		end if;

		return v_next_data;
	end function f_next_data;

	--	constant c_RESET_DATA : natural := 255;
	--	constant c_FINAL_DATA : natural := 1;

	constant c_RESET_DATA : natural := 0;
	constant c_FINAL_DATA : natural := 255;

	signal s_counter     : natural                                     := 0;
	signal s_address_cnt : natural range 0 to (2**g_ADDRESS_WIDTH - 1) := 0;
	--	signal s_mask_cnt    : natural range 0 to 16                       := 0;
	signal s_times_cnt   : natural                                     := 0;

begin

	p_avalon_buffer_L_stimuli : process(clk_i, rst_i) is
		variable v_data_cnt             : natural range 0 to 255 := c_RESET_DATA;
		variable v_mask_cnt             : natural range 0 to 16  := 0;
		variable v_registered_data      : std_logic_vector(63 downto 0);
		variable v_registered_writedata : std_logic_vector(255 downto 0);
	begin
		if (rst_i = '1') then

			avalon_mm_address_o    <= (others => '0');
			avalon_mm_write_o      <= '0';
			avalon_mm_writedata_o  <= (others => '0');
			s_counter              <= 0;
			s_counter              <= 5000;
			--			s_counter             <= 900;
			s_address_cnt          <= 0;
			--			s_mask_cnt            <= 0;
			v_mask_cnt             := 0;
			s_times_cnt            <= 0;
			v_data_cnt             := c_RESET_DATA;
			v_registered_data      := (others => '0');
			v_registered_writedata := (others => '0');

		elsif rising_edge(clk_i) then

			avalon_mm_address_o   <= (others => '0');
			avalon_mm_write_o     <= '0';
			avalon_mm_writedata_o <= (others => '0');
			s_counter             <= s_counter + 1;

			case s_counter is

				when 2500 =>
					-- register write
					avalon_mm_address_o   <= std_logic_vector(to_unsigned(s_address_cnt, g_ADDRESS_WIDTH));
					avalon_mm_write_o     <= '1';
					for cnt in 0 to 3 loop
						v_registered_data                                           := (others => '0');
						--						if (s_mask_cnt < 16) then
						--							s_mask_cnt <= s_mask_cnt + 1;
						if (v_mask_cnt < 16) then
							v_mask_cnt                      := v_mask_cnt + 1;
							--						v_registered_data(7 downto 0)   := std_logic_vector(to_unsigned(v_data_cnt, 8));
							--						v_data_cnt                      := f_next_data(v_data_cnt, c_RESET_DATA, c_FINAL_DATA, 2, '0');
							--						v_registered_data(15 downto 8)  := std_logic_vector(to_unsigned(v_data_cnt, 8));
							--						v_data_cnt                      := f_next_data(v_data_cnt, c_RESET_DATA, c_FINAL_DATA, 2, '0');
							--						v_registered_data(23 downto 16) := std_logic_vector(to_unsigned(v_data_cnt, 8));
							--						v_data_cnt                      := f_next_data(v_data_cnt, c_RESET_DATA, c_FINAL_DATA, 2, '0');
							--						v_registered_data(31 downto 24) := std_logic_vector(to_unsigned(v_data_cnt, 8));
							--						v_data_cnt                      := f_next_data(v_data_cnt, c_RESET_DATA, c_FINAL_DATA, 2, '0');
							--						v_registered_data(39 downto 32) := std_logic_vector(to_unsigned(v_data_cnt, 8));
							--						v_data_cnt                      := f_next_data(v_data_cnt, c_RESET_DATA, c_FINAL_DATA, 2, '0');
							--						v_registered_data(47 downto 40) := std_logic_vector(to_unsigned(v_data_cnt, 8));
							--						v_data_cnt                      := f_next_data(v_data_cnt, c_RESET_DATA, c_FINAL_DATA, 2, '0');
							--						v_registered_data(55 downto 48) := std_logic_vector(to_unsigned(v_data_cnt, 8));
							--						v_data_cnt                      := f_next_data(v_data_cnt, c_RESET_DATA, c_FINAL_DATA, 2, '0');
							--						v_registered_data(63 downto 56) := std_logic_vector(to_unsigned(v_data_cnt, 8));
							--						v_data_cnt                      := f_next_data(v_data_cnt, c_RESET_DATA, c_FINAL_DATA, 2, '0');
							v_registered_data(7 downto 0)   := std_logic_vector(to_unsigned(v_data_cnt, 8));
							v_data_cnt                      := f_next_data(v_data_cnt, c_RESET_DATA, c_FINAL_DATA, 1, '1');
							v_registered_data(15 downto 8)  := std_logic_vector(to_unsigned(v_data_cnt, 8));
							v_data_cnt                      := f_next_data(v_data_cnt, c_RESET_DATA, c_FINAL_DATA, 1, '1');
							v_registered_data(23 downto 16) := std_logic_vector(to_unsigned(v_data_cnt, 8));
							v_data_cnt                      := f_next_data(v_data_cnt, c_RESET_DATA, c_FINAL_DATA, 1, '1');
							v_registered_data(31 downto 24) := std_logic_vector(to_unsigned(v_data_cnt, 8));
							v_data_cnt                      := f_next_data(v_data_cnt, c_RESET_DATA, c_FINAL_DATA, 1, '1');
							v_registered_data(39 downto 32) := std_logic_vector(to_unsigned(v_data_cnt, 8));
							v_data_cnt                      := f_next_data(v_data_cnt, c_RESET_DATA, c_FINAL_DATA, 1, '1');
							v_registered_data(47 downto 40) := std_logic_vector(to_unsigned(v_data_cnt, 8));
							v_data_cnt                      := f_next_data(v_data_cnt, c_RESET_DATA, c_FINAL_DATA, 1, '1');
							v_registered_data(55 downto 48) := std_logic_vector(to_unsigned(v_data_cnt, 8));
							v_data_cnt                      := f_next_data(v_data_cnt, c_RESET_DATA, c_FINAL_DATA, 1, '1');
							v_registered_data(63 downto 56) := std_logic_vector(to_unsigned(v_data_cnt, 8));
							v_data_cnt                      := f_next_data(v_data_cnt, c_RESET_DATA, c_FINAL_DATA, 1, '1');
						else
							--							s_mask_cnt        <= 0;
							v_mask_cnt        := 0;
							v_registered_data := (others => '1');
							--						v_registered_data := x"AAAAAAAAAAAAAAAA";
						end if;
						v_registered_writedata(((64 * cnt) + 63) downto (64 * cnt)) := v_registered_data;
					end loop;
					avalon_mm_writedata_o <= v_registered_writedata;

				when 2501 =>
					avalon_mm_address_o   <= std_logic_vector(to_unsigned(s_address_cnt, g_ADDRESS_WIDTH));
					avalon_mm_write_o     <= '1';
					avalon_mm_writedata_o <= v_registered_writedata;

				when 2502 =>
					s_counter     <= 2500;
					s_address_cnt <= s_address_cnt + 1;
					--if (s_address_cnt = (2**g_ADDRESS_WIDTH - 2)) then
					--					if (s_address_cnt = (1020 - 1)) then
					--					if (s_address_cnt = (272 - 1)) then
					if (s_address_cnt = (68 - 1)) then
						--					if (s_address_cnt = (68 - 1)) then
						if (s_times_cnt < 1000) then
							--						if (s_times_cnt < 1) then
							--							s_counter     <= 2000;
							s_counter     <= 2450;
							s_address_cnt <= 0;
							s_times_cnt   <= s_times_cnt + 1;
						else
							s_counter     <= 5000;
							s_address_cnt <= 0;
							s_times_cnt   <= 0;
						end if;
					end if;

				when others =>
					null;

			end case;

		end if;
	end process p_avalon_buffer_L_stimuli;

end architecture RTL;
