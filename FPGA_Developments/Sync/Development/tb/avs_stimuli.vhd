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
	alias a_wr_reg_bit4			: std_logic is avalon_mm_writedata_o(4);
	alias a_wr_reg_bit3			: std_logic is avalon_mm_writedata_o(3);
	alias a_wr_reg_bit2			: std_logic is avalon_mm_writedata_o(2);
	alias a_wr_reg_bit1			: std_logic is avalon_mm_writedata_o(1);
	alias a_wr_reg_bit0			: std_logic is avalon_mm_writedata_o(0);

begin
	p_avs_stimuli : process(clk_i, rst_i) is
		
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
					v_address				:= 4;
					avalon_mm_address_o 	<= std_logic_vector(to_unsigned(v_address,8));
					avalon_mm_read_o    	<= '0';
					-- MBT = 20 (400 ns @ 20 ns)
					v_value					:= 20;
					a_wr_reg				<= std_logic_vector(to_unsigned(v_value,32));
					avalon_mm_write_o   	<= '1';

				when 150 to 151 =>
					-- Register write
					-- Sync config registers
					-- BT - address: 5
					v_address				:= 5;
					avalon_mm_address_o 	<= std_logic_vector(to_unsigned(v_address,8));
					avalon_mm_read_o    	<= '0';
					-- BT = 10 (200 ns @ 20 ns)
					v_value					:= 10;
					a_wr_reg				<= std_logic_vector(to_unsigned(v_value,32));
					avalon_mm_write_o   	<= '1';

				when 200 to 201 =>
					-- Register write
					-- Sync config registers
					-- PER - address: 6
					v_address				:= 6;
					avalon_mm_address_o 	<= std_logic_vector(to_unsigned(v_address,8));
					avalon_mm_read_o    	<= '0';
					-- PER = 312 (6,25 us @ 20 ns)
					v_value					:= 312;
					a_wr_reg				<= std_logic_vector(to_unsigned(v_value,32));
					avalon_mm_write_o   	<= '1';

				when 250 to 251 =>
					-- Register write
					-- Sync config registers
					-- OST - address: 7
					v_address				:= 7;
					avalon_mm_address_o 	<= std_logic_vector(to_unsigned(v_address,8));
					avalon_mm_read_o    	<= '0';
					-- OST = 5 (100 ns @ 20 ns)
					v_value					:= 5;
					a_wr_reg				<= std_logic_vector(to_unsigned(v_value,32));
					avalon_mm_write_o   	<= '1';

				when 300 to 301 =>
					-- Register write
					-- Sync config registers
					-- General.signal_polarity | number_of_cycles - address: 8
					v_address				:= 8;
					avalon_mm_address_o 	<= std_logic_vector(to_unsigned(v_address,8));
					avalon_mm_read_o    	<= '0';
					-- Signal polarity = '0'
					a_wr_reg_bit8			<= '0';
					-- Number of cycles = 4
					v_value					:= 4;
					a_wr_reg_bits_7_0		<= std_logic_vector(to_unsigned(v_value,8));
					avalon_mm_write_o   	<= '1';

				when 350 to 351 =>
					-- Register write
					-- Sync control register - address: 10
					v_address				:= 10;
					avalon_mm_address_o 	<= std_logic_vector(to_unsigned(v_address,8));
					avalon_mm_read_o    	<= '0';
					-- Enable all outen bits
					a_wr_reg_bits_8_0		<= (others => '1'); 
					avalon_mm_write_o   	<= '1';

				when 800 to 801 =>
					-- Register write
					-- Sync control register - address: 10
					v_address				:= 10;
					avalon_mm_address_o 	<= std_logic_vector(to_unsigned(v_address,8));
					avalon_mm_read_o    	<= '0';
					-- Enable all outen bits
					a_wr_reg_bits_8_0		<= (others => '1'); 
					-- Switch to internal sync gen
					a_wr_reg_bit31			<= '1'; 
					avalon_mm_write_o   	<= '1';

				when 900 to 901 =>
					-- Register write
					-- Sync control register - address: 10
					v_address				:= 10;
					avalon_mm_address_o 	<= std_logic_vector(to_unsigned(v_address,8));
					avalon_mm_read_o    	<= '0';
					-- Enable all outen bits
					a_wr_reg_bits_8_0		<= (others => '1'); 
					-- Switch to internal sync gen
					a_wr_reg_bit31			<= '1'; 
					-- Start gen
					a_wr_reg_bit19			<= '1'; 
					avalon_mm_write_o   	<= '1';

				when 950 to 951 =>
					-- Register read
					-- Sync config registers
					-- General - address: 8
					v_address				:= 8;
					avalon_mm_address_o 	<= std_logic_vector(to_unsigned(v_address,8));
					avalon_mm_write_o   	<= '0';
					avalon_mm_read_o    	<= '1';

				when 1000 to 1001 =>
					-- Register read
					-- Sync status register - address: 0
					v_address				:= 0;
					avalon_mm_address_o 	<= std_logic_vector(to_unsigned(v_address,8));
					avalon_mm_write_o   	<= '0';
					avalon_mm_read_o    	<= '1';

				when 1050 to 1051 =>
					-- Register write
					-- Sync config registers
					-- BT - address: 5
					-- Try to reconfig gen in running state, must not work!
					v_address				:= 5;
					avalon_mm_address_o 	<= std_logic_vector(to_unsigned(v_address,8));
					avalon_mm_read_o    	<= '0';
					-- BT = 30 (600 ns @ 20 ns)
					v_value					:= 30;
					a_wr_reg				<= std_logic_vector(to_unsigned(v_value,32));
					avalon_mm_write_o   	<= '1';

				when 1100 to 1101 =>
					-- Register read
					-- Sync control register - address: 10
					v_address				:= 10;
					avalon_mm_address_o 	<= std_logic_vector(to_unsigned(v_address,8));
					avalon_mm_write_o   	<= '0';
					avalon_mm_read_o    	<= '1';

				when 1275 to 1276 =>
					-- Register read
					-- Sync status register - address: 0
					v_address				:= 0;
					avalon_mm_address_o 	<= std_logic_vector(to_unsigned(v_address,8));
					avalon_mm_write_o   	<= '0';
					avalon_mm_read_o    	<= '1';

				when 1600 to 1601 =>
					-- Register read
					-- Sync status register - address: 0
					v_address				:= 0;
					avalon_mm_address_o 	<= std_logic_vector(to_unsigned(v_address,8));
					avalon_mm_write_o   	<= '0';
					avalon_mm_read_o    	<= '1';

				when 1925 to 1926 =>
					-- Register read
					-- Sync status register - address: 0
					v_address				:= 0;
					avalon_mm_address_o 	<= std_logic_vector(to_unsigned(v_address,8));
					avalon_mm_write_o   	<= '0';
					avalon_mm_read_o    	<= '1';

				when 2000 to 2001 =>
					-- Register write
					-- Sync control register - address: 10
					v_address				:= 10;
					avalon_mm_address_o 	<= std_logic_vector(to_unsigned(v_address,8));
					avalon_mm_read_o    	<= '0';
					-- Enable all outen bits
					a_wr_reg_bits_8_0		<= (others => '1'); 
					-- Switch to internal sync gen
					a_wr_reg_bit31			<= '1'; 
					-- Reset gen
					a_wr_reg_bit18			<= '1'; 
					avalon_mm_write_o   	<= '1';

				when 2050 to 2051 =>
					-- Register write
					-- Sync control register - address: 10
					v_address				:= 10;
					avalon_mm_address_o 	<= std_logic_vector(to_unsigned(v_address,8));
					avalon_mm_read_o    	<= '0';
					-- Enable all outen bits
					a_wr_reg_bits_8_0		<= (others => '1'); 
					-- Switch to internal sync gen
					a_wr_reg_bit31			<= '1'; 
					-- Start gen
					a_wr_reg_bit19			<= '1'; 
					avalon_mm_write_o   	<= '1';

				when 3000 to 3001 =>
					-- Register write
					-- Sync control register - address: 10
					v_address				:= 10;
					avalon_mm_address_o 	<= std_logic_vector(to_unsigned(v_address,8));
					avalon_mm_read_o    	<= '0';
					-- Enable all outen bits
					a_wr_reg_bits_8_0		<= (others => '1'); 
					-- Switch to internal sync gen
					a_wr_reg_bit31			<= '1'; 
					-- Reset gen
					a_wr_reg_bit18			<= '1'; 
					avalon_mm_write_o   	<= '1';

				when 3100 to 3101 =>
					-- Register write
					-- Sync control register - address: 10
					v_address				:= 10;
					avalon_mm_address_o 	<= std_logic_vector(to_unsigned(v_address,8));
					avalon_mm_read_o    	<= '0';
					-- Enable all outen bits
					a_wr_reg_bits_8_0		<= (others => '1'); 
					-- Switch to internal sync gen
					a_wr_reg_bit31			<= '1'; 
					-- One shot gen
					a_wr_reg_bit17			<= '1'; 
					avalon_mm_write_o   	<= '1';

				when 3500 to 3501 =>
					-- Register write
					-- Sync config registers
					-- BT - address: 5
					v_address				:= 5;
					avalon_mm_address_o 	<= std_logic_vector(to_unsigned(v_address,8));
					avalon_mm_read_o    	<= '0';
					-- BT = 10 (200 ns @ 20 ns)
					v_value					:= 10;
					a_wr_reg				<= std_logic_vector(to_unsigned(v_value,32));
					avalon_mm_write_o   	<= '1';

				when 3550 to 3551 =>
					-- Register write
					-- Sync control register - address: 10
					v_address				:= 10;
					avalon_mm_address_o 	<= std_logic_vector(to_unsigned(v_address,8));
					avalon_mm_read_o    	<= '0';
					-- Enable all outen bits
					a_wr_reg_bits_8_0		<= (others => '1'); 
					-- Switch to internal sync gen
					a_wr_reg_bit31			<= '1'; 
					-- Err_inj gen
					a_wr_reg_bit16			<= '1';
					avalon_mm_write_o   	<= '1';

				when 3600 to 3601 =>
					-- Register read
					-- Sync status register - address: 0
					v_address				:= 0;
					avalon_mm_address_o 	<= std_logic_vector(to_unsigned(v_address,8));
					avalon_mm_write_o   	<= '0';
					avalon_mm_read_o    	<= '1';

				when 3650 to 3651 =>
					-- Register write
					-- Sync control register - address: 10
					v_address				:= 10;
					avalon_mm_address_o 	<= std_logic_vector(to_unsigned(v_address,8));
					avalon_mm_read_o    	<= '0';
					-- Enable all outen bits
					a_wr_reg_bits_8_0		<= (others => '1'); 
					-- Switch to internal sync gen
					a_wr_reg_bit31			<= '1'; 
					-- Reset gen
					a_wr_reg_bit18			<= '1'; 
					avalon_mm_write_o   	<= '1';

				when 3700 to 3701 =>
					-- Register write
					-- Sync config registers
					-- General.signal_polarity | number_of_cycles - address: 8
					v_address				:= 8;
					avalon_mm_address_o 	<= std_logic_vector(to_unsigned(v_address,8));
					avalon_mm_read_o    	<= '0';
					-- Signal polarity = '0'
					a_wr_reg_bit8			<= '0';
					-- Number of cycles = 1
					v_value					:= 4;
					a_wr_reg_bits_7_0		<= std_logic_vector(to_unsigned(v_value,8));
					avalon_mm_write_o   	<= '1';

				when 3750 to 3751 =>
					-- Register write
					-- Sync control register - address: 10
					v_address				:= 10;
					avalon_mm_address_o 	<= std_logic_vector(to_unsigned(v_address,8));
					avalon_mm_read_o    	<= '0';
					-- Enable all outen bits
					a_wr_reg_bits_8_0		<= (others => '1'); 
					-- Switch to internal sync gen
					a_wr_reg_bit31			<= '1'; 
					-- Start gen
					a_wr_reg_bit19			<= '1'; 
					avalon_mm_write_o   	<= '1';

				when 4500 to 4501 =>
					-- Register write
					-- Sync control register - address: 10
					v_address				:= 10;
					avalon_mm_address_o 	<= std_logic_vector(to_unsigned(v_address,8));
					avalon_mm_read_o    	<= '0';
					-- Enable all outen bits
					a_wr_reg_bits_8_0		<= (others => '1'); 
					-- Switch to internal sync gen
					a_wr_reg_bit31			<= '1'; 
					-- Reset gen
					a_wr_reg_bit18			<= '1';
					avalon_mm_write_o   	<= '1';

				when 4550 to 4551 =>
					-- Register write
					-- Sync config registers
					-- Interrupt enable register - address: 1
					v_address				:= 1;
					avalon_mm_address_o 	<= std_logic_vector(to_unsigned(v_address,8));
					avalon_mm_read_o    	<= '0';
					-- Blank pulse int enable
					a_wr_reg_bit4			<= '1';
					a_wr_reg_bit3			<= '1';
					a_wr_reg_bit2			<= '1';
					a_wr_reg_bit1			<= '1';
					a_wr_reg_bit0			<= '1';
					avalon_mm_write_o   	<= '1';

				when 5000 to 5001 =>
					-- Register write
					-- Sync control register - address: 10
					v_address				:= 10;
					avalon_mm_address_o 	<= std_logic_vector(to_unsigned(v_address,8));
					avalon_mm_read_o    	<= '0';
					-- Enable all outen bits
					a_wr_reg_bits_8_0		<= (others => '1'); 
					-- Switch to internal sync gen
					a_wr_reg_bit31			<= '1'; 
					-- Start gen
					a_wr_reg_bit19			<= '1'; 
					avalon_mm_write_o   	<= '1';

--				when 5500 to 5501 =>
--					-- Register write
--					-- Sync config registers
--					-- Interrupt enable register - address: 1
--					v_address				:= 1;
--					avalon_mm_address_o 	<= std_logic_vector(to_unsigned(v_address,8));
--					avalon_mm_read_o    	<= '0';
--					-- Blank pulse int disable
--					a_wr_reg_bit4			<= '0';
--					a_wr_reg_bit3			<= '0';
--					a_wr_reg_bit2			<= '0';
--					a_wr_reg_bit1			<= '0';
--					a_wr_reg_bit0			<= '0';
--					avalon_mm_write_o   	<= '1';
--					
				when 5630 to 5631 =>
					-- Register write
					-- Sync config registers
					-- Interrupt enable register - address: 1
					v_address				:= 2;
					avalon_mm_address_o 	<= std_logic_vector(to_unsigned(v_address,8));
					avalon_mm_read_o    	<= '0';
					-- Blank pulse int disable
					a_wr_reg_bit4			<= '1';
					a_wr_reg_bit3			<= '1';
					a_wr_reg_bit2			<= '1';
					a_wr_reg_bit1			<= '1';
					a_wr_reg_bit0			<= '1';
					avalon_mm_write_o   	<= '1';

				when others =>
					null;
			end case;
		end if;
	end process p_avs_stimuli;

end architecture rtl;
