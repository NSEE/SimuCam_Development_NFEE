library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity avs_stimuli is
	generic (
		g_ADDRESS_WIDTH : natural range 1 to 64;
		g_DATA_WIDTH    : natural range 1 to 64
	);
	port (
		clk_i                   : in  std_logic;
		rst_i                   : in  std_logic;
		avalon_mm_readdata_i    : in  std_logic_vector((g_DATA_WIDTH - 1) downto 0);
		avalon_mm_waitrequest_i : in  std_logic;

		avalon_mm_address_o     : out std_logic_vector((g_ADDRESS_WIDTH - 1) downto 0);
		avalon_mm_write_o       : out std_logic;
		avalon_mm_writedata_o   : out std_logic_vector((g_DATA_WIDTH - 1) downto 0);
		avalon_mm_read_o        : out std_logic
	);
end entity avs_stimuli;

architecture rtl of avs_stimuli is
	-- Timeline evolution
	signal s_counter	: natural := 0;
	-- Aux address
	signal s_address	: natural := 0;
	-- Aux reg value
	signal s_value		: natural := 0;	

	-- Register writing bit mapping
	alias a_wr_reg				: std_logic_vector(31 downto 0) is avalon_mm_writedata_o(31 downto 0);
	alias a_wr_reg_bits_31_1	: std_logic_vector(30 downto 0) is avalon_mm_writedata_o(31 downto 1);
	alias a_wr_reg_bits_15_0	: std_logic_vector(15 downto 0) is avalon_mm_writedata_o(15 downto 0);
	alias a_wr_reg_bits_31_16	: std_logic_vector(15 downto 0) is avalon_mm_writedata_o(31 downto 16);
	alias a_wr_reg_bit0			: std_logic is avalon_mm_writedata_o(0);

begin
	p_avs_stimuli : process(clk_i, rst_i) is
	begin
		if (rst_i = '1') then
			avalon_mm_address_o   <= (others => '0');
			avalon_mm_write_o     <= '0';
			avalon_mm_writedata_o <= (others => '0');
			avalon_mm_read_o      <= '0';
			s_counter             <= 0;

		elsif rising_edge(clk_i) then
			avalon_mm_address_o   <= (others => '0');
			avalon_mm_write_o     <= '0';
			avalon_mm_writedata_o <= (others => '0');
			avalon_mm_read_o      <= '0';
			s_counter             <= s_counter + 1;

			case s_counter is
				when 100 to 101 =>
					-- Register write
					-- Sync config registers
					-- MBT - address: 4
					s_address				<= 4;
					avalon_mm_address_o 	<= std_logic_vector(to_unsigned(s_address,8));
					avalon_mm_read_o    	<= '0';
					avalon_mm_write_o   	<= '1';
					-- MBT - value: 20e6 (400 ms @ 20 ns)
					s_value					<= 20e6;
					a_wr_reg				<= std_logic_vector(to_unsigned(s_value,32));

				when 150 to 151 =>
					-- Register read
					-- Sync config registers
					-- MBT - address: 4
					s_address				<= 4;
					avalon_mm_address_o 	<= std_logic_vector(to_unsigned(s_address,8));
					avalon_mm_write_o   	<= '0';
					avalon_mm_read_o    	<= '1';

				when 200 to 201 =>
					-- Register read
					-- Sync status - address: 0
					avalon_mm_address_o 	<= (others => '0');
					avalon_mm_write_o   	<= '0';
					avalon_mm_read_o    	<= '1';

				when others =>
					null;
			end case;
		end if;
	end process p_avs_stimuli;

end architecture rtl;
