library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.avalon_mm_windowing_pkg.all;

entity avalon_mm_windowing_write_ent is
	port(
		clk_i                 : in  std_logic;
		rst_i                 : in  std_logic;
		avalon_mm_windowing_i : in  t_avalon_mm_windowing_write_in;
		mask_enable_i         : in  std_logic;
		avalon_mm_windowing_o : out t_avalon_mm_windowing_write_out;
		window_data_write_o   : out std_logic;
		window_mask_write_o   : out std_logic;
		window_data_o         : out std_logic_vector(63 downto 0)
	);
end entity avalon_mm_windowing_write_ent;

architecture rtl of avalon_mm_windowing_write_ent is

	function f_pixels_data_little_to_big_endian(little_endian_pixel_data_i : in std_logic_vector) return std_logic_vector is
		variable v_big_endian_pixel_data : std_logic_vector(63 downto 0);
	begin

		-- pixels arrangement for little endian (avalon standart and real memory organization):
		-- |  pixel_3_msb |  pixel_3_lsb |  pixel_2_msb |  pixel_2_lsb |  pixel_1_msb |  pixel_1_lsb |  pixel_0_msb |  pixel_0_lsb | 
		-- | 63 downto 56 | 55 downto 48 | 47 downto 40 | 39 downto 32 | 31 downto 24 | 23 downto 16 | 15 downto  8 |  7 downto  0 |
		--
		-- pixels arrangement for big endian (for spacewire transmission):
		-- |  pixel_3_lsb |  pixel_3_msb |  pixel_2_lsb |  pixel_2_msb |  pixel_1_lsb |  pixel_1_msb |  pixel_0_lsb |  pixel_0_msb | 
		-- | 55 downto 48 | 63 downto 56 | 39 downto 32 | 47 downto 40 | 23 downto 16 | 31 downto 24 |  7 downto  0 | 15 downto  8 |
		--
		-- little endian to big endian conversion:
		-- s_big_endian(55 downto 48) <= s_little_endian(63 downto 56);
		-- s_big_endian(63 downto 56) <= s_little_endian(55 downto 48);
		-- s_big_endian(39 downto 32) <= s_little_endian(47 downto 40);
		-- s_big_endian(47 downto 40) <= s_little_endian(39 downto 32);
		-- s_big_endian(23 downto 16) <= s_little_endian(31 downto 24);
		-- s_big_endian(31 downto 24) <= s_little_endian(23 downto 16);
		-- s_big_endian( 7 downto  0) <= s_little_endian(15 downto  8);
		-- s_big_endian(15 downto  8) <= s_little_endian( 7 downto  0);

		-- little endian to big endian conversion:
		-- pixel 3 lsb
		v_big_endian_pixel_data(55 downto 48) := little_endian_pixel_data_i(63 downto 56);
		-- pixel 3 msb
		v_big_endian_pixel_data(63 downto 56) := little_endian_pixel_data_i(55 downto 48);
		-- pixel 2 lsb
		v_big_endian_pixel_data(39 downto 32) := little_endian_pixel_data_i(47 downto 40);
		-- pixel 2 msb
		v_big_endian_pixel_data(47 downto 40) := little_endian_pixel_data_i(39 downto 32);
		-- pixel 1 lsb
		v_big_endian_pixel_data(23 downto 16) := little_endian_pixel_data_i(31 downto 24);
		-- pixel 1 msb
		v_big_endian_pixel_data(31 downto 24) := little_endian_pixel_data_i(23 downto 16);
		-- pixel 0 lsb
		v_big_endian_pixel_data(7 downto 0)   := little_endian_pixel_data_i(15 downto 8);
		-- pixel 0 msb
		v_big_endian_pixel_data(15 downto 8)  := little_endian_pixel_data_i(7 downto 0);

		return v_big_endian_pixel_data;
	end function f_pixels_data_little_to_big_endian;

	signal s_windown_data_ctn : natural range 0 to 16;
	signal s_waitrequest      : std_logic;

begin

	p_avalon_mm_windowing_write : process(clk_i, rst_i) is
		procedure p_reset_registers is
		begin
			window_data_write_o <= '0';
			window_mask_write_o <= '0';
			window_data_o       <= (others => '0');
			s_windown_data_ctn  <= 0;
			s_waitrequest       <= '0';
		end procedure p_reset_registers;

		procedure p_control_triggers is
		begin
			window_data_write_o <= '0';
			window_mask_write_o <= '0';
			window_data_o       <= (others => '0');
		end procedure p_control_triggers;

		procedure p_writedata(write_address_i : t_avalon_mm_windowing_address) is
		begin

			-- check if masking is enabled
			if (mask_enable_i = '1') then
				-- masking enabled
				-- Registers Write Data
				case (write_address_i) is
					-- Case for access to all registers address

					when 0 to 271 =>
						-- check if the waitrequested is still active
						if (s_waitrequest = '1') then
							-- waitrequest active, execute write operation
							-- check if it is the beggining of a new cicle
							if (write_address_i = 0) then
								-- address is zero, new cicle
								window_data_write_o <= '1';
								window_data_o       <= f_pixels_data_little_to_big_endian(avalon_mm_windowing_i.writedata);
								s_windown_data_ctn  <= 1;
							else
								-- address not zero, verify counter
								if (s_windown_data_ctn < 16) then
									-- counter at data address
									window_data_write_o <= '1';
									window_data_o       <= f_pixels_data_little_to_big_endian(avalon_mm_windowing_i.writedata);
									-- increment counter
									s_windown_data_ctn  <= s_windown_data_ctn + 1;
								else
									-- counter at mask address
									window_mask_write_o <= '1';
									window_data_o       <= f_pixels_data_little_to_big_endian(avalon_mm_windowing_i.writedata);
									-- reset counter
									s_windown_data_ctn  <= 0;
								end if;
							end if;
						end if;

					when others =>
						null;
				end case;
			else
				-- masking disabled
				-- Registers Write Data
				case (write_address_i) is
					-- Case for access to all registers address

					when 0 to 254 =>
						-- check if the waitrequested is still active
						if (s_waitrequest = '1') then
							-- waitrequest active, execute write operation
							-- check if it is the beggining of a new cicle
							if (write_address_i = 0) then
								-- address is zero, new cicle
								window_data_write_o <= '1';
								window_data_o       <= f_pixels_data_little_to_big_endian(avalon_mm_windowing_i.writedata);
								s_windown_data_ctn  <= 1;
							else
								-- address not zero, verify counter
								if (s_windown_data_ctn < 16) then
									-- counter at data address
									window_data_write_o <= '1';
									window_data_o       <= f_pixels_data_little_to_big_endian(avalon_mm_windowing_i.writedata);
									-- increment counter
									s_windown_data_ctn  <= s_windown_data_ctn + 1;
								else
									-- counter at mask address
									window_data_write_o <= '1';
									window_data_o       <= f_pixels_data_little_to_big_endian(avalon_mm_windowing_i.writedata);
									-- set counter to first data
									s_windown_data_ctn  <= 1;
								end if;
							end if;
						end if;

					when others =>
						null;
				end case;
			end if;

		end procedure p_writedata;

		variable v_write_address : t_avalon_mm_windowing_address := 0;
	begin
		if (rst_i = '1') then
			avalon_mm_windowing_o.waitrequest <= '1';
			s_waitrequest                     <= '1';
			v_write_address                   := 0;
			p_reset_registers;
		elsif (rising_edge(clk_i)) then
			avalon_mm_windowing_o.waitrequest <= '1';
			s_waitrequest                     <= '1';
			p_control_triggers;
			if (avalon_mm_windowing_i.write = '1') then
				avalon_mm_windowing_o.waitrequest <= '0';
				s_waitrequest                     <= '0';
				v_write_address                   := to_integer(unsigned(avalon_mm_windowing_i.address));
				p_writedata(v_write_address);
			end if;
		end if;
	end process p_avalon_mm_windowing_write;

end architecture rtl;
