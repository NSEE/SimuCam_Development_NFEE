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
	
	constant c_TIME_OFFSET   : natural range 0 to 16535     := 1500;

	-- Register writing bit mapping
	alias a_wr_reg				: std_logic_vector(31 downto 0) is avalon_mm_writedata_o(31 downto 0);
	alias a_wr_reg_bits_31_16	: std_logic_vector(15 downto 0) is avalon_mm_writedata_o(31 downto 16);
	alias a_wr_reg_bits_15_0	: std_logic_vector(15 downto 0) is avalon_mm_writedata_o(15 downto 0);
	alias a_wr_reg_bits_8_0		: std_logic_vector(8 downto 0)  is avalon_mm_writedata_o(8 downto 0);
	alias a_wr_reg_bits_7_0		: std_logic_vector(7 downto 0)  is avalon_mm_writedata_o(7 downto 0);
	alias a_wr_reg_bit31		: std_logic is avalon_mm_writedata_o(31);
	alias a_wr_reg_bit19		: std_logic is avalon_mm_writedata_o(19);
	alias a_wr_reg_bit18		: std_logic is avalon_mm_writedata_o(18);
	alias a_wr_reg_bit17		: std_logic is avalon_mm_writedata_o(17);
	alias a_wr_reg_bit16		: std_logic is avalon_mm_writedata_o(16);
	alias a_wr_reg_bit8			: std_logic is avalon_mm_writedata_o(8);
	alias a_wr_reg_bit0			: std_logic is avalon_mm_writedata_o(0);

begin
	p_avs_stimuli : process(clk_i, rst_i) is
	
	-- Timeline counter
	variable v_counter  : natural range 0 to 16535 := 0; 
	-- Aux reg address
	variable v_address	: natural := 0;
	-- Aux reg value
	variable v_value	: natural := 0;	
			
	begin
		if (rst_i = '1') then
			avalon_mm_address_o   <= (others => '0');
			avalon_mm_write_o     <= '0';
			avalon_mm_writedata_o <= (others => '0');
			avalon_mm_read_o      <= '0';
			v_counter             := 0;

		elsif rising_edge(clk_i) then
			avalon_mm_address_o   <= (others => '0');
			avalon_mm_write_o     <= '0';
			avalon_mm_writedata_o <= (others => '0');
			avalon_mm_read_o      <= '0';
			v_counter             :=  v_counter + 1;

			case v_counter is
				when (c_TIME_OFFSET + 2000) to (c_TIME_OFFSET + 2001) =>
					-- Register read
					-- Address: 0x40
					v_address				:= 16#40#;
					avalon_mm_address_o 	<= std_logic_vector(to_unsigned(v_address,8));
					avalon_mm_write_o   	<= '0';
					avalon_mm_read_o    	<= '1';

				when (c_TIME_OFFSET + 3000) to (c_TIME_OFFSET + 3001) =>
					-- Register write
					-- Value: 0x7ABBCCDD
					-- Address: 0x42
					v_address				:= 16#42#;
					avalon_mm_address_o 	<= std_logic_vector(to_unsigned(v_address,8));
					avalon_mm_read_o    	<= '0';
					v_value					:= 16#7ABBCCDD#;
					a_wr_reg				<= std_logic_vector(to_unsigned(v_value,32));
					avalon_mm_write_o   	<= '1';

				when (c_TIME_OFFSET + 7000) to (c_TIME_OFFSET + 7001) =>
					-- Register read
					-- Address: 0xA0
					v_address				:= 16#A0#;
					avalon_mm_address_o 	<= std_logic_vector(to_unsigned(v_address,8));
					avalon_mm_write_o   	<= '0';
					avalon_mm_read_o    	<= '1';

				when (c_TIME_OFFSET + 7500) to (c_TIME_OFFSET + 7501) =>
					-- Register read
					-- Address: 0x42
					v_address				:= 16#42#;
					avalon_mm_address_o 	<= std_logic_vector(to_unsigned(v_address,8));
					avalon_mm_write_o   	<= '0';
					avalon_mm_read_o    	<= '1';

				when others =>
					null;
			end case;
		end if;
	end process p_avs_stimuli;

end architecture rtl;
