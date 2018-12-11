library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.avalon_mm_windowing_pkg.all;
use work.comm_mm_registers_pkg.all;
use work.spwc_mm_registers_pkg.all;
use work.tran_mm_registers_pkg.all;

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

	signal s_windown_data_ctn : natural range 0 to 16;

begin

	p_avalon_mm_windowing_write : process(clk_i, rst_i) is
		procedure p_reset_registers is
		begin
			window_data_write_o <= '0';
			window_mask_write_o <= '0';
			window_data_o       <= (others => '0');
			s_windown_data_ctn  <= 0;
		end procedure p_reset_registers;

		procedure p_control_triggers is
		begin
			window_data_write_o <= '0';
			window_mask_write_o <= '0';
			window_data_o       <= (others => '0');
		end procedure p_control_triggers;

		procedure p_writedata(write_address_i : t_avalon_mm_windowing_address) is
		begin

			-- check if it is the beggining of a new cicle
			if (write_address_i = 0) then
				-- address is zero, new cicle
				window_data_write_o <= '1';
				window_data_o       <= avalon_mm_windowing_i.writedata;
				s_windown_data_ctn  <= 0;
			else
				-- address not zero, verify counter
				if (s_windown_data_ctn < 16) then
					-- counter at data address
					window_data_write_o <= '1';
					window_data_o       <= avalon_mm_windowing_i.writedata;
					-- increment counter
					s_windown_data_ctn  <= s_windown_data_ctn + 1;
				else
					-- counter at mask address
					-- check if masking is enabled
					if (mask_enable_i = '1') then
						-- masking enabled
						window_mask_write_o <= '1';
						window_data_o       <= avalon_mm_windowing_i.writedata;
						-- reset counter
						s_windown_data_ctn  <= 0;
					else
						-- masking disabled
						window_data_write_o <= '1';
						window_data_o       <= avalon_mm_windowing_i.writedata;
						-- set counter to first data
						s_windown_data_ctn  <= 1;
					end if;
				end if;
			end if;

		end procedure p_writedata;

		variable v_write_address : t_avalon_mm_windowing_address := 0;
	begin
		if (rst_i = '1') then
			avalon_mm_windowing_o.waitrequest <= '1';
			v_write_address                   := 0;
			p_reset_registers;
		elsif (rising_edge(clk_i)) then
			avalon_mm_windowing_o.waitrequest <= '1';
			p_control_triggers;
			if (avalon_mm_windowing_i.write = '1') then
				avalon_mm_windowing_o.waitrequest <= '0';
				v_write_address                   := to_integer(unsigned(avalon_mm_windowing_i.address));
				p_writedata(v_write_address);
			end if;
		end if;
	end process p_avalon_mm_windowing_write;

end architecture rtl;
