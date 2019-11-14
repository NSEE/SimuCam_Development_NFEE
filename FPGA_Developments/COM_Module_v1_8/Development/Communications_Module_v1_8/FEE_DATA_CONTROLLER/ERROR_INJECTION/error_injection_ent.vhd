library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity error_injection_ent is
	port(
		clk_i                 : in  std_logic;
		rst_i                 : in  std_logic;
		errinj_tx_disabled_i  : in  std_logic;
		errinj_missing_pkts_i : in  std_logic;
		errinj_missing_data_i : in  std_logic;
		errinj_frame_num_i    : in  std_logic(1 downto 0);
		errinj_sequence_cnt_i : in  std_logic(15 downto 0);
		errinj_data_cnt_i     : in  std_logic(15 downto 0);
		errinj_n_repeat_i     : in  std_logic(15 downto 0);
		errinj_spw_tx_write_i : in  std_logic;
		errinj_spw_tx_flag_i  : in  std_logic;
		errinj_spw_tx_data_i  : in  std_logic_vector(7 downto 0);
		fee_spw_tx_ready_i    : in  std_logic;
		errinj_spw_tx_ready_o : out std_logic;
		fee_spw_tx_write_o    : out std_logic;
		fee_spw_tx_flag_o     : out std_logic;
		fee_spw_tx_data_o     : out std_logic_vector(7 downto 0)
	);
end entity error_injection_ent;

architecture RTL of error_injection_ent is

begin

	p_error_injection : process(clk_i, rst_i) is
	begin
		if (rst_i = '1') then

		elsif (rising_edge(clk_i)) then

		end if;
	end process p_error_injection;

end architecture RTL;
