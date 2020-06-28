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
		window_buffer_o         : out t_windowing_buffer
	);
end entity avalon_mm_windowing_write_ent;

architecture rtl of avalon_mm_windowing_write_ent is

	signal s_waitrequest : std_logic;
	signal s_written     : std_logic;
	signal s_written_0     : std_logic;
	signal s_written_1     : std_logic;
	signal s_written_2     : std_logic;

begin

	p_avalon_mm_windowing_write : process(clk_i, rst_i) is
		procedure p_reset_registers is
		begin
			window_buffer_o.wrdata <= (others => '0');
			window_buffer_o.wrreq  <= '0';
			window_buffer_o.sclr   <= '1';
			s_waitrequest          <= '0';
			s_written              <= '0';
			s_written_0            <= '0';
			s_written_1            <= '0';
			s_written_2            <= '0';
		end procedure p_reset_registers;

		procedure p_control_triggers is
		begin
			window_buffer_o.wrdata <= (others => '0');
			window_buffer_o.wrreq  <= '0';
			window_buffer_o.sclr   <= '0';
		end procedure p_control_triggers;

		procedure p_writedata(write_address_i : t_avalon_mm_windowing_address) is
		begin

			-- Registers Write Data
			case (write_address_i) is
				-- Case for access to all registers address

				when 0 to t_avalon_mm_windowing_address'high =>
					-- check if the waitrequested is still active
					if (s_waitrequest = '1') then
						-- waitrequest active, execute write operation
						s_written <= '1';
						s_written_0 <= '1';
						if (window_buffer_control_i.locked = '0') then
							window_buffer_o.wrdata <= avalon_mm_windowing_i.writedata;
							window_buffer_o.wrreq  <= '1';
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
			if (s_written_0 = '1') then
				s_written_0 <= '0';
				s_written_1 <= '1'; 
			end if;
			if (s_written_1 = '1') then
				s_written_1 <= '0';
				s_written_2 <= '1'; 
			end if;
			if (s_written_2 = '1') then
				s_written_2 <= '0';
				s_written <= '0'; 
			end if;
			p_control_triggers;
			if ((s_written = '0') and (avalon_mm_windowing_i.write = '1') and (window_buffer_control_i.locked = '0')) then
				avalon_mm_windowing_o.waitrequest <= '0';
				s_waitrequest                     <= '0';
				v_write_address                   := to_integer(unsigned(avalon_mm_windowing_i.address));
				p_writedata(v_write_address);
			elsif (fee_clear_signal_i = '1') then
				window_buffer_o.wrdata <= (others => '0');
				window_buffer_o.wrreq  <= '0';
				window_buffer_o.sclr   <= '1';
			end if;
		end if;
	end process p_avalon_mm_windowing_write;

end architecture rtl;
