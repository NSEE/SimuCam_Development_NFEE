library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.mfil_config_avalon_mm_pkg.all;
use work.mfil_config_avalon_mm_registers_pkg.all;

entity mfil_config_avalon_mm_read_ent is
	port(
		clk_i                   : in  std_logic;
		rst_i                   : in  std_logic;
		mfil_config_avalon_mm_i : in  t_mfil_config_avalon_mm_read_in;
		mfil_config_avalon_mm_o : out t_mfil_config_avalon_mm_read_out;
		mfil_config_wr_regs_i   : in  t_mfil_config_wr_registers;
		mfil_config_rd_regs_i   : in  t_mfil_config_rd_registers
	);
end entity mfil_config_avalon_mm_read_ent;

architecture rtl of mfil_config_avalon_mm_read_ent is

begin

	p_mfil_config_avalon_mm_read : process(clk_i, rst_i) is
		procedure p_readdata(read_address_i : t_mfil_config_avalon_mm_address) is
		begin

			-- Registers Data Read
			case (read_address_i) is
				-- Case for access to all registers address

				when (16#00#) =>
					-- MFIL Data Control Register : Initial Write Address [High Dword]
					-- if (mfil_config_avalon_mm_i.byteenable(0) = '1') then
					mfil_config_avalon_mm_o.readdata(7 downto 0)   <= mfil_config_wr_regs_i.data_control_reg.wr_initial_addr_high_dword(7 downto 0);
					-- end if;
					-- if (mfil_config_avalon_mm_i.byteenable(1) = '1') then
					mfil_config_avalon_mm_o.readdata(15 downto 8)  <= mfil_config_wr_regs_i.data_control_reg.wr_initial_addr_high_dword(15 downto 8);
					-- end if;
					-- if (mfil_config_avalon_mm_i.byteenable(2) = '1') then
					mfil_config_avalon_mm_o.readdata(23 downto 16) <= mfil_config_wr_regs_i.data_control_reg.wr_initial_addr_high_dword(23 downto 16);
					-- end if;
					-- if (mfil_config_avalon_mm_i.byteenable(3) = '1') then
					mfil_config_avalon_mm_o.readdata(31 downto 24) <= mfil_config_wr_regs_i.data_control_reg.wr_initial_addr_high_dword(31 downto 24);
				-- end if;

				when (16#01#) =>
					-- MFIL Data Control Register : Initial Write Address [Low Dword]
					-- if (mfil_config_avalon_mm_i.byteenable(0) = '1') then
					mfil_config_avalon_mm_o.readdata(7 downto 0)   <= mfil_config_wr_regs_i.data_control_reg.wr_initial_addr_low_dword(7 downto 0);
					-- end if;
					-- if (mfil_config_avalon_mm_i.byteenable(1) = '1') then
					mfil_config_avalon_mm_o.readdata(15 downto 8)  <= mfil_config_wr_regs_i.data_control_reg.wr_initial_addr_low_dword(15 downto 8);
					-- end if;
					-- if (mfil_config_avalon_mm_i.byteenable(2) = '1') then
					mfil_config_avalon_mm_o.readdata(23 downto 16) <= mfil_config_wr_regs_i.data_control_reg.wr_initial_addr_low_dword(23 downto 16);
					-- end if;
					-- if (mfil_config_avalon_mm_i.byteenable(3) = '1') then
					mfil_config_avalon_mm_o.readdata(31 downto 24) <= mfil_config_wr_regs_i.data_control_reg.wr_initial_addr_low_dword(31 downto 24);
				-- end if;

				when (16#02#) =>
					-- MFIL Data Control Register : Write Data Length [Bytes]
					-- if (mfil_config_avalon_mm_i.byteenable(0) = '1') then
					mfil_config_avalon_mm_o.readdata(7 downto 0)   <= mfil_config_wr_regs_i.data_control_reg.wr_data_length_bytes(7 downto 0);
					-- end if;
					-- if (mfil_config_avalon_mm_i.byteenable(1) = '1') then
					mfil_config_avalon_mm_o.readdata(15 downto 8)  <= mfil_config_wr_regs_i.data_control_reg.wr_data_length_bytes(15 downto 8);
					-- end if;
					-- if (mfil_config_avalon_mm_i.byteenable(2) = '1') then
					mfil_config_avalon_mm_o.readdata(23 downto 16) <= mfil_config_wr_regs_i.data_control_reg.wr_data_length_bytes(23 downto 16);
					-- end if;
					-- if (mfil_config_avalon_mm_i.byteenable(3) = '1') then
					mfil_config_avalon_mm_o.readdata(31 downto 24) <= mfil_config_wr_regs_i.data_control_reg.wr_data_length_bytes(31 downto 24);
				-- end if;

				when (16#03#) =>
					-- MFIL Data Control Register : Write Data Value [Dword 7]
					-- if (mfil_config_avalon_mm_i.byteenable(0) = '1') then
					mfil_config_avalon_mm_o.readdata(7 downto 0)   <= mfil_config_wr_regs_i.data_control_reg.wr_data_value_dword_7(7 downto 0);
					-- end if;
					-- if (mfil_config_avalon_mm_i.byteenable(1) = '1') then
					mfil_config_avalon_mm_o.readdata(15 downto 8)  <= mfil_config_wr_regs_i.data_control_reg.wr_data_value_dword_7(15 downto 8);
					-- end if;
					-- if (mfil_config_avalon_mm_i.byteenable(2) = '1') then
					mfil_config_avalon_mm_o.readdata(23 downto 16) <= mfil_config_wr_regs_i.data_control_reg.wr_data_value_dword_7(23 downto 16);
					-- end if;
					-- if (mfil_config_avalon_mm_i.byteenable(3) = '1') then
					mfil_config_avalon_mm_o.readdata(31 downto 24) <= mfil_config_wr_regs_i.data_control_reg.wr_data_value_dword_7(31 downto 24);
				-- end if;

				when (16#04#) =>
					-- MFIL Data Control Register : Write Data Value [Dword 6]
					-- if (mfil_config_avalon_mm_i.byteenable(0) = '1') then
					mfil_config_avalon_mm_o.readdata(7 downto 0)   <= mfil_config_wr_regs_i.data_control_reg.wr_data_value_dword_6(7 downto 0);
					-- end if;
					-- if (mfil_config_avalon_mm_i.byteenable(1) = '1') then
					mfil_config_avalon_mm_o.readdata(15 downto 8)  <= mfil_config_wr_regs_i.data_control_reg.wr_data_value_dword_6(15 downto 8);
					-- end if;
					-- if (mfil_config_avalon_mm_i.byteenable(2) = '1') then
					mfil_config_avalon_mm_o.readdata(23 downto 16) <= mfil_config_wr_regs_i.data_control_reg.wr_data_value_dword_6(23 downto 16);
					-- end if;
					-- if (mfil_config_avalon_mm_i.byteenable(3) = '1') then
					mfil_config_avalon_mm_o.readdata(31 downto 24) <= mfil_config_wr_regs_i.data_control_reg.wr_data_value_dword_6(31 downto 24);
				-- end if;

				when (16#05#) =>
					-- MFIL Data Control Register : Write Data Value [Dword 5]
					-- if (mfil_config_avalon_mm_i.byteenable(0) = '1') then
					mfil_config_avalon_mm_o.readdata(7 downto 0)   <= mfil_config_wr_regs_i.data_control_reg.wr_data_value_dword_5(7 downto 0);
					-- end if;
					-- if (mfil_config_avalon_mm_i.byteenable(1) = '1') then
					mfil_config_avalon_mm_o.readdata(15 downto 8)  <= mfil_config_wr_regs_i.data_control_reg.wr_data_value_dword_5(15 downto 8);
					-- end if;
					-- if (mfil_config_avalon_mm_i.byteenable(2) = '1') then
					mfil_config_avalon_mm_o.readdata(23 downto 16) <= mfil_config_wr_regs_i.data_control_reg.wr_data_value_dword_5(23 downto 16);
					-- end if;
					-- if (mfil_config_avalon_mm_i.byteenable(3) = '1') then
					mfil_config_avalon_mm_o.readdata(31 downto 24) <= mfil_config_wr_regs_i.data_control_reg.wr_data_value_dword_5(31 downto 24);
				-- end if;

				when (16#06#) =>
					-- MFIL Data Control Register : Write Data Value [Dword 4]
					-- if (mfil_config_avalon_mm_i.byteenable(0) = '1') then
					mfil_config_avalon_mm_o.readdata(7 downto 0)   <= mfil_config_wr_regs_i.data_control_reg.wr_data_value_dword_4(7 downto 0);
					-- end if;
					-- if (mfil_config_avalon_mm_i.byteenable(1) = '1') then
					mfil_config_avalon_mm_o.readdata(15 downto 8)  <= mfil_config_wr_regs_i.data_control_reg.wr_data_value_dword_4(15 downto 8);
					-- end if;
					-- if (mfil_config_avalon_mm_i.byteenable(2) = '1') then
					mfil_config_avalon_mm_o.readdata(23 downto 16) <= mfil_config_wr_regs_i.data_control_reg.wr_data_value_dword_4(23 downto 16);
					-- end if;
					-- if (mfil_config_avalon_mm_i.byteenable(3) = '1') then
					mfil_config_avalon_mm_o.readdata(31 downto 24) <= mfil_config_wr_regs_i.data_control_reg.wr_data_value_dword_4(31 downto 24);
				-- end if;

				when (16#07#) =>
					-- MFIL Data Control Register : Write Data Value [Dword 3]
					-- if (mfil_config_avalon_mm_i.byteenable(0) = '1') then
					mfil_config_avalon_mm_o.readdata(7 downto 0)   <= mfil_config_wr_regs_i.data_control_reg.wr_data_value_dword_3(7 downto 0);
					-- end if;
					-- if (mfil_config_avalon_mm_i.byteenable(1) = '1') then
					mfil_config_avalon_mm_o.readdata(15 downto 8)  <= mfil_config_wr_regs_i.data_control_reg.wr_data_value_dword_3(15 downto 8);
					-- end if;
					-- if (mfil_config_avalon_mm_i.byteenable(2) = '1') then
					mfil_config_avalon_mm_o.readdata(23 downto 16) <= mfil_config_wr_regs_i.data_control_reg.wr_data_value_dword_3(23 downto 16);
					-- end if;
					-- if (mfil_config_avalon_mm_i.byteenable(3) = '1') then
					mfil_config_avalon_mm_o.readdata(31 downto 24) <= mfil_config_wr_regs_i.data_control_reg.wr_data_value_dword_3(31 downto 24);
				-- end if;

				when (16#08#) =>
					-- MFIL Data Control Register : Write Data Value [Dword 2]
					-- if (mfil_config_avalon_mm_i.byteenable(0) = '1') then
					mfil_config_avalon_mm_o.readdata(7 downto 0)   <= mfil_config_wr_regs_i.data_control_reg.wr_data_value_dword_2(7 downto 0);
					-- end if;
					-- if (mfil_config_avalon_mm_i.byteenable(1) = '1') then
					mfil_config_avalon_mm_o.readdata(15 downto 8)  <= mfil_config_wr_regs_i.data_control_reg.wr_data_value_dword_2(15 downto 8);
					-- end if;
					-- if (mfil_config_avalon_mm_i.byteenable(2) = '1') then
					mfil_config_avalon_mm_o.readdata(23 downto 16) <= mfil_config_wr_regs_i.data_control_reg.wr_data_value_dword_2(23 downto 16);
					-- end if;
					-- if (mfil_config_avalon_mm_i.byteenable(3) = '1') then
					mfil_config_avalon_mm_o.readdata(31 downto 24) <= mfil_config_wr_regs_i.data_control_reg.wr_data_value_dword_2(31 downto 24);
				-- end if;

				when (16#09#) =>
					-- MFIL Data Control Register : Write Data Value [Dword 1]
					-- if (mfil_config_avalon_mm_i.byteenable(0) = '1') then
					mfil_config_avalon_mm_o.readdata(7 downto 0)   <= mfil_config_wr_regs_i.data_control_reg.wr_data_value_dword_1(7 downto 0);
					-- end if;
					-- if (mfil_config_avalon_mm_i.byteenable(1) = '1') then
					mfil_config_avalon_mm_o.readdata(15 downto 8)  <= mfil_config_wr_regs_i.data_control_reg.wr_data_value_dword_1(15 downto 8);
					-- end if;
					-- if (mfil_config_avalon_mm_i.byteenable(2) = '1') then
					mfil_config_avalon_mm_o.readdata(23 downto 16) <= mfil_config_wr_regs_i.data_control_reg.wr_data_value_dword_1(23 downto 16);
					-- end if;
					-- if (mfil_config_avalon_mm_i.byteenable(3) = '1') then
					mfil_config_avalon_mm_o.readdata(31 downto 24) <= mfil_config_wr_regs_i.data_control_reg.wr_data_value_dword_1(31 downto 24);
				-- end if;

				when (16#0A#) =>
					-- MFIL Data Control Register : Write Data Value [Dword 0]
					-- if (mfil_config_avalon_mm_i.byteenable(0) = '1') then
					mfil_config_avalon_mm_o.readdata(7 downto 0)   <= mfil_config_wr_regs_i.data_control_reg.wr_data_value_dword_0(7 downto 0);
					-- end if;
					-- if (mfil_config_avalon_mm_i.byteenable(1) = '1') then
					mfil_config_avalon_mm_o.readdata(15 downto 8)  <= mfil_config_wr_regs_i.data_control_reg.wr_data_value_dword_0(15 downto 8);
					-- end if;
					-- if (mfil_config_avalon_mm_i.byteenable(2) = '1') then
					mfil_config_avalon_mm_o.readdata(23 downto 16) <= mfil_config_wr_regs_i.data_control_reg.wr_data_value_dword_0(23 downto 16);
					-- end if;
					-- if (mfil_config_avalon_mm_i.byteenable(3) = '1') then
					mfil_config_avalon_mm_o.readdata(31 downto 24) <= mfil_config_wr_regs_i.data_control_reg.wr_data_value_dword_0(31 downto 24);
				-- end if;

				when (16#0B#) =>
					-- MFIL Data Control Register : Write Timeout
					-- if (mfil_config_avalon_mm_i.byteenable(0) = '1') then
					mfil_config_avalon_mm_o.readdata(7 downto 0)  <= mfil_config_wr_regs_i.data_control_reg.wr_timeout(7 downto 0);
					-- end if;
					-- if (mfil_config_avalon_mm_i.byteenable(1) = '1') then
					mfil_config_avalon_mm_o.readdata(15 downto 8) <= mfil_config_wr_regs_i.data_control_reg.wr_timeout(15 downto 8);
				-- end if;

				when (16#0C#) =>
					-- MFIL Data Control Register : Data Write Start
					-- if (mfil_config_avalon_mm_i.byteenable(0) = '1') then
					mfil_config_avalon_mm_o.readdata(0) <= mfil_config_wr_regs_i.data_control_reg.wr_start;
				-- end if;

				when (16#0D#) =>
					-- MFIL Data Control Register : Data Write Reset
					-- if (mfil_config_avalon_mm_i.byteenable(0) = '1') then
					mfil_config_avalon_mm_o.readdata(0) <= mfil_config_wr_regs_i.data_control_reg.wr_reset;
				-- end if;

				when (16#0E#) =>
					-- MFIL Data Status Register : Data Write Busy
					-- if (mfil_config_avalon_mm_i.byteenable(0) = '1') then
					mfil_config_avalon_mm_o.readdata(0) <= mfil_config_rd_regs_i.data_status_reg.wr_busy;
				-- end if;

				when (16#0F#) =>
					-- MFIL Data Status Register : Write Timeout Error
					-- if (mfil_config_avalon_mm_i.byteenable(0) = '1') then
					mfil_config_avalon_mm_o.readdata(0) <= mfil_config_rd_regs_i.data_status_reg.wr_timeout_err;
				-- end if;

				when others =>
					-- No register associated to the address, return with 0x00000000
					mfil_config_avalon_mm_o.readdata <= (others => '0');

			end case;

		end procedure p_readdata;

		variable v_read_address : t_mfil_config_avalon_mm_address := 0;
	begin
		if (rst_i = '1') then
			mfil_config_avalon_mm_o.readdata    <= (others => '0');
			mfil_config_avalon_mm_o.waitrequest <= '1';
			v_read_address                      := 0;
		elsif (rising_edge(clk_i)) then
			mfil_config_avalon_mm_o.readdata    <= (others => '0');
			mfil_config_avalon_mm_o.waitrequest <= '1';
			if (mfil_config_avalon_mm_i.read = '1') then
				v_read_address                      := to_integer(unsigned(mfil_config_avalon_mm_i.address));
				mfil_config_avalon_mm_o.waitrequest <= '0';
				p_readdata(v_read_address);
			end if;
		end if;
	end process p_mfil_config_avalon_mm_read;

end architecture rtl;
