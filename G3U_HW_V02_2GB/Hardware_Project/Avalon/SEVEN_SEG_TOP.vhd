LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE WORK.ALL;

ENTITY SEVEN_SEG_TOP IS
  PORT (

-------------------------------------------------------------------------------
-- GLOBAL
-------------------------------------------------------------------------------    
    CLK      : IN STD_LOGIC;
    RST      : IN STD_LOGIC;
	
-------------------------------------------------------------------------------
-- AVALON
-------------------------------------------------------------------------------
	AVALON_SLAVE_ADDRESS   : IN STD_LOGIC;
	AVALON_SLAVE_WRITE     : IN STD_LOGIC;
	AVALON_SLAVE_WRITEDATA : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

-------------------------------------------------------------------------------
-- OUTPUTS
-------------------------------------------------------------------------------
	SEVEN_SEG_DSP1_OUT : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	SEVEN_SEG_DSP0_OUT : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)

    );

END ENTITY SEVEN_SEG_TOP;


ARCHITECTURE TOP OF SEVEN_SEG_TOP IS

	-------------------------------------------------------------------------------
	-- SEVEN SEGMENT REGISTER
	-------------------------------------------------------------------------------
	SIGNAL SEG_DATA    : UNSIGNED(7 DOWNTO 0);
	SIGNAL SEG1_ON_OFF : STD_LOGIC;
	SIGNAL SEG1_UPDATE : STD_LOGIC;
	SIGNAL SEG1_TEST   : STD_LOGIC;
	SIGNAL SEG0_ON_OFF : STD_LOGIC;
	SIGNAL SEG0_UPDATE : STD_LOGIC;
	SIGNAL SEG0_TEST   : STD_LOGIC;

	-------------------------------------------------------------------------------
	-- DOUBLE DABBLE
	-------------------------------------------------------------------------------
	SIGNAL DD_ENABLE      : STD_LOGIC;
	SIGNAL DD_IDLE        : STD_LOGIC;
	SIGNAL DD_CLEAR       : STD_LOGIC;
	SIGNAL DD_INTEGER     : UNSIGNED(7 DOWNTO 0);
	SIGNAL DD_BCD1        : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL DD_BCD0        : STD_LOGIC_VECTOR(3 DOWNTO 0);

	-------------------------------------------------------------------------------
	-- SEVEN SEGMENT DISPLAY 1
	-------------------------------------------------------------------------------
	SIGNAL SEG1_ENABLE    : STD_LOGIC;
	SIGNAL SEG1_BCD_IN       : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL SEG1_DBITS_OUT     : STD_LOGIC_VECTOR(7 DOWNTO 0);

	-------------------------------------------------------------------------------
	-- SEVEN SEGMENT DISPLAY 0
	-------------------------------------------------------------------------------
	SIGNAL SEG0_ENABLE    : STD_LOGIC;
    SIGNAL SEG0_BCD_IN       : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL SEG0_DBITS_OUT     : STD_LOGIC_VECTOR(7 DOWNTO 0);

	-------------------------------------------------------------------------------
	-- STATE_MACHINE
	-------------------------------------------------------------------------------

	TYPE SST_STATE_MACHINE IS (
		S_STANDBY,
		S_WORKING,
		S_UPDATE
	);
	SIGNAL STATE_MACHINE : SST_STATE_MACHINE := S_STANDBY;
  
BEGIN

	SSDP_REGISTER : ENTITY SEVEN_SEG_REGISTER
		PORT MAP(
			CLK                   => CLK,
			RST                   => RST,
			DATA_IN_AVALON        => AVALON_SLAVE_WRITEDATA,
			ADDRESS_IN_AVALON     => AVALON_SLAVE_ADDRESS,
			ENABLE_DATA_IN_AVALON => AVALON_SLAVE_WRITE,
			SEG_DATA              => SEG_DATA,
			SEG1_ON_OFF           => SEG1_ON_OFF,
			SEG1_UPDATE           => SEG1_UPDATE,
			SEG1_TEST             => SEG1_TEST,
			SEG0_ON_OFF           => SEG0_ON_OFF,
			SEG0_UPDATE           => SEG0_UPDATE,
			SEG0_TEST             => SEG0_TEST
		);

	DOUBLE_DABBLE : ENTITY DOUBLE_DABBLE_8BIT
		PORT MAP(
		CLK           => CLK,
		RST           => RST,
		DD_ENABLE     => DD_ENABLE,
		DD_IDLE       => DD_IDLE,
		DD_CLEAR      => DD_CLEAR,
		DD_INTEGER_IN => DD_INTEGER,
		DD_BCD2_OUT   => OPEN,
		DD_BCD1_OUT   => DD_BCD1,
		DD_BCD0_OUT   => DD_BCD0
		);

	SSDP1 : ENTITY SEVEN_SEG_DPS
		PORT MAP(
			CLK           => CLK,
			RST           => RST,
			SEG_ENABLE    => SEG1_ENABLE,
			SEG_BCD_IN    => SEG1_BCD_IN,
			SEG_DBITS_OUT => SEG1_DBITS_OUT
		);

	SSDP0 : ENTITY SEVEN_SEG_DPS
		PORT MAP(
			CLK           => CLK,
			RST           => RST,
			SEG_ENABLE    => SEG0_ENABLE,
			SEG_BCD_IN    => SEG0_BCD_IN,
			SEG_DBITS_OUT => SEG0_DBITS_OUT
		);
	
	GLOBAL : PROCESS (CLK, RST)
		VARIABLE PAST_INTEGER : UNSIGNED(7 DOWNTO 0) := (OTHERS => '0');
		VARIABLE DELAY : STD_LOGIC := '0';
	BEGIN
		IF (RST = '1') THEN
			PAST_INTEGER := (OTHERS => '0');
			DD_ENABLE <= '0';
			DD_CLEAR <= '1';
			SEG1_ENABLE <= '0';
			SEG0_ENABLE <= '0';
			STATE_MACHINE <= S_STANDBY;
		ELSIF (RISING_EDGE(CLK)) THEN
			CASE STATE_MACHINE IS
			
				WHEN S_STANDBY =>
					DD_ENABLE <= '0';
					DD_CLEAR <= '0';
					SEG1_ENABLE <= '0';
					SEG0_ENABLE <= '0';
					IF ((SEG_DATA /= PAST_INTEGER) AND (DD_IDLE = '1')) THEN
						PAST_INTEGER := SEG_DATA;
						DD_INTEGER <= SEG_DATA;
						DD_ENABLE <= '1';
						DELAY := '1';
						STATE_MACHINE <= S_WORKING;
					ELSE
						STATE_MACHINE <= S_STANDBY;
					END IF;
				
				WHEN S_WORKING =>
					DD_ENABLE <= '0';
					IF (DELAY = '1') THEN
						DELAY := '0';
						STATE_MACHINE <= S_WORKING;
					ELSE
						IF (DD_IDLE = '1') THEN
					    	STATE_MACHINE <= S_UPDATE;
					    ELSE
					    	STATE_MACHINE <= S_WORKING;
					    END IF;
					END IF;
				
				WHEN S_UPDATE =>
					
					SEG1_BCD_IN <= DD_BCD1;
					IF (SEG1_UPDATE = '1') THEN
						SEG1_ENABLE <= '1';
					END IF;
					SEG0_BCD_IN <= DD_BCD0;
					IF (SEG0_UPDATE = '1') THEN
						SEG0_ENABLE <= '1';
					END IF;
					DD_CLEAR <= '1';
					STATE_MACHINE <= S_STANDBY;
					
			END CASE;
		END IF;
	END PROCESS GLOBAL;
	
	SEVEN_SEG_DSP1_OUT <= 
		X"FF"          WHEN (RST = '1')                                 ELSE
		X"FF"          WHEN (SEG1_ON_OFF = '0')                         ELSE
		X"00"          WHEN ((SEG1_ON_OFF = '1') AND (SEG1_TEST = '1')) ELSE
		SEG1_DBITS_OUT WHEN ((SEG1_ON_OFF = '1') AND (SEG1_TEST = '0')) ELSE
		X"FF";
		
	SEVEN_SEG_DSP0_OUT <= 
		X"FF"          WHEN (RST = '1')                                 ELSE
		X"FF"          WHEN (SEG0_ON_OFF = '0')                         ELSE
		X"00"          WHEN ((SEG0_ON_OFF = '1') AND (SEG0_TEST = '1')) ELSE
		SEG0_DBITS_OUT WHEN ((SEG0_ON_OFF = '1') AND (SEG0_TEST = '0')) ELSE
		X"FF";
	
END ARCHITECTURE TOP;
