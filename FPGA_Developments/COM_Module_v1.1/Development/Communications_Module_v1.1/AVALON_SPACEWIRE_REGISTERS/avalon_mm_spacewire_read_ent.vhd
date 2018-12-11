library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.avalon_mm_spacewire_pkg.all;
use work.avalon_mm_spacewire_registers_pkg.all;

entity avalon_mm_spacewire_read_ent is
	port(
		clk_i                       : in  std_logic;
		rst_i                       : in  std_logic;
		avalon_mm_spacewire_i       : in  t_avalon_mm_spacewire_read_in;
		avalon_mm_spacewire_o       : out t_avalon_mm_spacewire_read_out;
		spacewire_write_registers_i : in  t_windowing_write_registers;
		spacewire_read_registers_i  : in  t_windowing_read_registers
	);
end entity avalon_mm_spacewire_read_ent;

architecture rtl of avalon_mm_spacewire_read_ent is

	signal s_timecode_rx_received_flag : std_logic;

begin

	p_avalon_mm_spacewire_read : process(clk_i, rst_i) is
		procedure p_reset_registers is
		begin
			s_timecode_rx_received_flag <= '0';
		end procedure p_reset_registers;

		procedure p_flags_hold is
		begin
			if (spacewire_write_registers_i.timecode_rx_flags.rx_received_clear = '1') then
				s_timecode_rx_received_flag <= '0';
			end if;
			if (spacewire_read_registers_i.timecode_rx.rx_received = '1') then
				s_timecode_rx_received_flag <= '1';
			end if;
		end procedure p_flags_hold;

		procedure p_readdata(read_address_i : t_avalon_mm_spacewire_address) is
		begin
			-- Registers Data Read
			case (read_address_i) is
				-- Case for access to all registers address

				--  Windowing Control Register                     (32 bits):
				when (c_WINDOWING_CONTROL_MM_REG_ADDRESS + c_WINDOWING_AVALON_MM_REG_OFFSET) =>
					--    31- 9 : Reserved                               [-/-]
					--     8- 8 : Masking enable control bit             [R/W]
					avalon_mm_spacewire_o.readdata(8) <= spacewire_write_registers_i.windowing_control.mask_enable;
					--     7- 3 : Reserved                               [-/-]
					--     2- 2 : Autostart control bit                  [R/W]
					avalon_mm_spacewire_o.readdata(2) <= spacewire_write_registers_i.windowing_control.autostart;
					--     1- 1 : Link Start control bit                 [R/W]
					avalon_mm_spacewire_o.readdata(1) <= spacewire_write_registers_i.windowing_control.linkstart;
					--     0- 0 : Link Disconnect control bit            [R/W]
					avalon_mm_spacewire_o.readdata(0) <= spacewire_write_registers_i.windowing_control.linkdis;

				--  Windowing Status Register                      (32 bits):
				when (c_WINDOWING_STATUS_MM_REG_ADDRESS + c_WINDOWING_AVALON_MM_REG_OFFSET) =>
					--    31-12 : Reserved                               [-/-]
					--    11-11 : Link Disconnect error bit              [R/-]
					avalon_mm_spacewire_o.readdata(11) <= spacewire_read_registers_i.windowing_status.errdis;
					--    10-10 : Link Parity error bit                  [R/-]
					avalon_mm_spacewire_o.readdata(10) <= spacewire_read_registers_i.windowing_status.errpar;
					--     9- 9 : Link Escape error bit                  [R/-]
					avalon_mm_spacewire_o.readdata(9)  <= spacewire_read_registers_i.windowing_status.erresc;
					--     8- 8 : Link Credit error bit                  [R/-]
					avalon_mm_spacewire_o.readdata(8)  <= spacewire_read_registers_i.windowing_status.errcred;
					--     7- 3 : Reserved                               [-/-]	
					--     2- 2 : Link Started status bit                [R/-]
					avalon_mm_spacewire_o.readdata(2)  <= spacewire_read_registers_i.windowing_status.started;
					--     1- 1 : Link Connecting status bit             [R/-]
					avalon_mm_spacewire_o.readdata(1)  <= spacewire_read_registers_i.windowing_status.connecting;
					--     0- 0 : Link Running status bit                [R/-]
					avalon_mm_spacewire_o.readdata(0)  <= spacewire_read_registers_i.windowing_status.running;

				--  Timecode RX Register                           (32 bits):
				when (c_TIMECODE_RX_MM_REG_ADDRESS + c_WINDOWING_AVALON_MM_REG_OFFSET) =>
					--    31- 9 : Reserved                               [-/-]
					--     8- 7 : RX TimeCode Control bits               [R/-]
					avalon_mm_spacewire_o.readdata(8 downto 7) <= spacewire_read_registers_i.timecode_rx.rx_control;
					--     6- 1 : RX TimeCode Counter value              [R/-]
					avalon_mm_spacewire_o.readdata(6 downto 1) <= spacewire_read_registers_i.timecode_rx.rx_time;
					--     0- 0 : RX TimeCode status bit                 [R/-]
					avalon_mm_spacewire_o.readdata(0)          <= s_timecode_rx_received_flag;
				--     0- 0 : RX TimeCode status bit clear           [-/W]

				--  Timecode TX Register                           (32 bits):
				when (c_TIMECODE_TX_MM_REG_ADDRESS + c_WINDOWING_AVALON_MM_REG_OFFSET) =>
					--    31- 9 : Reserved                               [-/-]
					--     8- 7 : TX TimeCode Control bits               [R/W]
					avalon_mm_spacewire_o.readdata(8 downto 7) <= spacewire_write_registers_i.timecode_tx.tx_control;
					--     6- 1 : TX TimeCode Counter value              [R/W]
					avalon_mm_spacewire_o.readdata(6 downto 1) <= spacewire_write_registers_i.timecode_tx.tx_time;
					--     0- 0 : TX TimeCode control bit                [R/W]
					avalon_mm_spacewire_o.readdata(0)          <= spacewire_write_registers_i.timecode_tx.tx_send;

				when others =>
					avalon_mm_spacewire_o.readdata <= (others => '0');
			end case;
		end procedure p_readdata;

		variable v_read_address : t_avalon_mm_spacewire_address := 0;
	begin
		if (rst_i = '1') then
			avalon_mm_spacewire_o.readdata    <= (others => '0');
			avalon_mm_spacewire_o.waitrequest <= '1';
			v_read_address                    := 0;
			p_reset_registers;
		elsif (rising_edge(clk_i)) then
			avalon_mm_spacewire_o.readdata    <= (others => '0');
			avalon_mm_spacewire_o.waitrequest <= '1';
			p_flags_hold;
			if (avalon_mm_spacewire_i.read = '1') then
				avalon_mm_spacewire_o.waitrequest <= '0';
				v_read_address                    := to_integer(unsigned(avalon_mm_spacewire_i.address));
				p_readdata(v_read_address);
			end if;
		end if;
	end process p_avalon_mm_spacewire_read;

end architecture rtl;
