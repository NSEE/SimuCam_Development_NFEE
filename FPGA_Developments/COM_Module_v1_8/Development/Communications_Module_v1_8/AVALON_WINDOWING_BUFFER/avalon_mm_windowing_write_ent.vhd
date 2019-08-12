library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.avalon_mm_windowing_pkg.all;
use work.windowing_dataset_pkg.all;

entity avalon_mm_windowing_write_ent is
	port(
		clk_i                   : in  std_logic;
		rst_i                   : in  std_logic;
		avalon_mm_windowing_i   : in  t_avalon_mm_windowing_write_in;
		--		mask_enable_i           : in  std_logic;
		fee_clear_signal_i      : in  std_logic;
		window_buffer_size_i    : in  std_logic_vector(3 downto 0);
		window_buffer_control_i : in  t_windowing_buffer_control;
		avalon_mm_windowing_o   : out t_avalon_mm_windowing_write_out;
		window_double_buffer_o  : out t_windowing_double_buffer
	);
end entity avalon_mm_windowing_write_ent;

architecture rtl of avalon_mm_windowing_write_ent is

	signal s_waitrequest : std_logic;

begin

	p_avalon_mm_windowing_write : process(clk_i, rst_i) is
		procedure p_reset_registers is
		begin
			window_double_buffer_o(0).dbuffer <= (others => x"0000000000000000");
			window_double_buffer_o(0).full    <= '0';
			window_double_buffer_o(0).size    <= (others => '1');
			window_double_buffer_o(1).dbuffer <= (others => x"0000000000000000");
			window_double_buffer_o(1).full    <= '0';
			window_double_buffer_o(1).size    <= (others => '1');
			s_waitrequest                     <= '0';
		end procedure p_reset_registers;

		procedure p_control_triggers is
		begin
			window_double_buffer_o(0).full <= '0';
			window_double_buffer_o(1).full <= '0';
		end procedure p_control_triggers;

		procedure p_writedata(write_address_i : t_avalon_mm_windowing_address) is
		begin

			-- Registers Write Data
			case (write_address_i) is
				-- Case for access to all registers address

				when 0 to 67 =>
					-- check if the waitrequested is still active
					if (s_waitrequest = '1') then
						-- waitrequest active, execute write operation
						if (window_buffer_control_i.locked = '0') then
							window_double_buffer_o(window_buffer_control_i.selected).dbuffer((write_address_i * 8) + 0) <= avalon_mm_windowing_i.writedata((32 * 0 + 31) downto (32 * 0));
							window_double_buffer_o(window_buffer_control_i.selected).dbuffer((write_address_i * 8) + 1) <= avalon_mm_windowing_i.writedata((32 * 1 + 31) downto (32 * 1));
							window_double_buffer_o(window_buffer_control_i.selected).dbuffer((write_address_i * 8) + 2) <= avalon_mm_windowing_i.writedata((32 * 2 + 31) downto (32 * 2));
							window_double_buffer_o(window_buffer_control_i.selected).dbuffer((write_address_i * 8) + 3) <= avalon_mm_windowing_i.writedata((32 * 3 + 31) downto (32 * 3));
							window_double_buffer_o(window_buffer_control_i.selected).dbuffer((write_address_i * 8) + 4) <= avalon_mm_windowing_i.writedata((32 * 4 + 31) downto (32 * 4));
							window_double_buffer_o(window_buffer_control_i.selected).dbuffer((write_address_i * 8) + 5) <= avalon_mm_windowing_i.writedata((32 * 5 + 31) downto (32 * 5));
							window_double_buffer_o(window_buffer_control_i.selected).dbuffer((write_address_i * 8) + 6) <= avalon_mm_windowing_i.writedata((32 * 6 + 31) downto (32 * 6));
							window_double_buffer_o(window_buffer_control_i.selected).dbuffer((write_address_i * 8) + 7) <= avalon_mm_windowing_i.writedata((32 * 7 + 31) downto (32 * 7));
						end if;
						if (write_address_i = c_BUFFER_SIZE_TO_ADDR(to_integer(unsigned(window_buffer_size_i)))) then
							window_double_buffer_o(window_buffer_control_i.selected).full <= '1';
							window_double_buffer_o(window_buffer_control_i.selected).size <= window_buffer_size_i;
						end if;
					end if;

				when others =>
					null;

			end case;

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
			elsif (fee_clear_signal_i = '1') then
				window_double_buffer_o(0).dbuffer <= (others => x"0000000000000000");
				window_double_buffer_o(0).full    <= '0';
				window_double_buffer_o(0).size    <= (others => '1');
				window_double_buffer_o(1).dbuffer <= (others => x"0000000000000000");
				window_double_buffer_o(1).full    <= '0';
				window_double_buffer_o(1).size    <= (others => '1');
			end if;
		end if;
	end process p_avalon_mm_windowing_write;

end architecture rtl;
