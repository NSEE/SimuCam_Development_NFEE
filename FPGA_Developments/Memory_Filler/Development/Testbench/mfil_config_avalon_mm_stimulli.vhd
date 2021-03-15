library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.mfil_config_avalon_mm_registers_pkg.all;

entity mfil_config_avalon_mm_stimulli is
	port(
		clk_i                       : in  std_logic;
		rst_i                       : in  std_logic;
		avs_config_rd_regs_i        : in  t_mfil_config_rd_registers;
		avs_config_wr_regs_o        : out t_mfil_config_wr_registers;
		avs_config_rd_readdata_o    : out std_logic_vector(31 downto 0);
		avs_config_rd_waitrequest_o : out std_logic;
		avs_config_wr_waitrequest_o : out std_logic
	);
end entity mfil_config_avalon_mm_stimulli;

architecture RTL of mfil_config_avalon_mm_stimulli is

	signal s_counter : natural := 0;
	signal s_times   : natural := 0;

begin

	p_mfil_config_avalon_mm_stimulli : process(clk_i, rst_i) is
		procedure p_reset_registers is
		begin

			-- Write Registers Reset/Default State

			-- MFIL Data Control Register : Initial Write Address [High Dword]
			avs_config_wr_regs_o.data_control_reg.wr_initial_addr_high_dword <= (others => '0');
			-- MFIL Data Control Register : Initial Write Address [Low Dword]
			avs_config_wr_regs_o.data_control_reg.wr_initial_addr_low_dword  <= (others => '0');
			-- MFIL Data Control Register : Write Data Length [Bytes]
			avs_config_wr_regs_o.data_control_reg.wr_data_length_bytes       <= (others => '0');
			-- MFIL Data Control Register : Write Data Value [Dword 7]
			avs_config_wr_regs_o.data_control_reg.wr_data_value_dword_7      <= (others => '0');
			-- MFIL Data Control Register : Write Data Value [Dword 6]
			avs_config_wr_regs_o.data_control_reg.wr_data_value_dword_6      <= (others => '0');
			-- MFIL Data Control Register : Write Data Value [Dword 5]
			avs_config_wr_regs_o.data_control_reg.wr_data_value_dword_5      <= (others => '0');
			-- MFIL Data Control Register : Write Data Value [Dword 4]
			avs_config_wr_regs_o.data_control_reg.wr_data_value_dword_4      <= (others => '0');
			-- MFIL Data Control Register : Write Data Value [Dword 3]
			avs_config_wr_regs_o.data_control_reg.wr_data_value_dword_3      <= (others => '0');
			-- MFIL Data Control Register : Write Data Value [Dword 2]
			avs_config_wr_regs_o.data_control_reg.wr_data_value_dword_2      <= (others => '0');
			-- MFIL Data Control Register : Write Data Value [Dword 1]
			avs_config_wr_regs_o.data_control_reg.wr_data_value_dword_1      <= (others => '0');
			-- MFIL Data Control Register : Write Data Value [Dword 0]
			avs_config_wr_regs_o.data_control_reg.wr_data_value_dword_0      <= (others => '0');
			-- MFIL Data Control Register : Write Timeout
			avs_config_wr_regs_o.data_control_reg.wr_timeout                 <= (others => '0');
			-- MFIL Data Control Register : Data Write Start
			avs_config_wr_regs_o.data_control_reg.wr_start                   <= '0';
			-- MFIL Data Control Register : Data Write Reset
			avs_config_wr_regs_o.data_control_reg.wr_reset                   <= '0';

		end procedure p_reset_registers;

		procedure p_control_triggers is
		begin

			-- Write Registers Triggers Reset

			-- MFIL Data Control Register : Data Write Start
			avs_config_wr_regs_o.data_control_reg.wr_start <= '0';
			-- MFIL Data Control Register : Data Write Reset
			avs_config_wr_regs_o.data_control_reg.wr_reset <= '0';

		end procedure p_control_triggers;

	begin
		if (rst_i = '1') then

			s_counter <= 0;
			s_times   <= 0;
			p_reset_registers;

		elsif rising_edge(clk_i) then

			s_counter <= s_counter + 1;
			p_control_triggers;

			case s_counter is

				when 50 =>
					avs_config_wr_regs_o.data_control_reg.wr_data_length_bytes  <= x"00000280";
					avs_config_wr_regs_o.data_control_reg.wr_data_value_dword_7 <= x"FFFFFFFF";
					avs_config_wr_regs_o.data_control_reg.wr_data_value_dword_6 <= x"EEEEEEEE";
					avs_config_wr_regs_o.data_control_reg.wr_data_value_dword_5 <= x"DDDDDDDD";
					avs_config_wr_regs_o.data_control_reg.wr_data_value_dword_4 <= x"CCCCCCCC";
					avs_config_wr_regs_o.data_control_reg.wr_data_value_dword_3 <= x"BBBBBBBB";
					avs_config_wr_regs_o.data_control_reg.wr_data_value_dword_2 <= x"AAAAAAAA";
					avs_config_wr_regs_o.data_control_reg.wr_data_value_dword_1 <= x"99999999";
					avs_config_wr_regs_o.data_control_reg.wr_data_value_dword_0 <= x"88888888";
					avs_config_wr_regs_o.data_control_reg.wr_timeout            <= x"0010";
					avs_config_wr_regs_o.data_control_reg.wr_start              <= '1';

				when 100 =>
					avs_config_wr_regs_o.data_control_reg.wr_reset <= '1';

				when others =>
					null;

			end case;

		end if;
	end process p_mfil_config_avalon_mm_stimulli;

	avs_config_rd_readdata_o    <= (others => '0');
	avs_config_rd_waitrequest_o <= '1';
	avs_config_wr_waitrequest_o <= '1';

end architecture RTL;
