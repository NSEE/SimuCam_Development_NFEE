-------------------------------------------------------------------------------
-- Instituto Maua de Tecnologia
-- 	Nucleo de Sistemas Eletronicos Embarcados
--
-- Rodrigo França - rodmarfran@gmail.com | rodrigo.franca@maua.br
-- Platao Simucam X - FTDI Module
--
-- Jun/2017
--
--------------------------------------------------------------------------------
--
-- Modificado para uso do Módulo FTDI
--
-- NOTE
--
--  DDR2
--  When switch : 1.Run Analysis & Synthesis 2.Run Tcl 3.Full Compile
--------------------------------------------------------------------------------

-- Bibliotecas
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity MebX_TopLevel is
port(
    -- Global
    OSC_50_BANK2 : in std_logic;
    OSC_50_BANK4 : in std_logic;
    OSC_50_BANK3 : in std_logic;

    -- RST
    CPU_RESET_n	 : in std_logic;
    RESET_PAINEL_n : in std_logic;  -- painel GPIO1

    -- Buttons
    Button      : in std_logic_vector(3 downto 0);
    SW 		    : in std_logic_vector(7 downto 0);
    EXT_IO		 : in std_logic;
	 
    -- LEDs
    LED_DE4    	: out std_logic_vector(7 downto 0);
    LED_PAINEL   	: out std_logic_vector(12 downto 0);   -- painel GPIO1

	 -- Seven Segment Display
    SEVEN_SEG_HEX1 : out std_logic_vector(7  downto 0);
    SEVEN_SEG_HEX0 : out std_logic_vector(7  downto 0);
	
    -- FANs
    FAN_CTRL	: out std_logic;
	 
	 -- SD CARD
    SD_WP_n   : in    std_logic;
    SD_CMD    : inout std_logic;            
    SD_CLK    : out   std_logic;                                      
    SD_DAT    : inout std_logic_vector(3 downto 0);

    -- Ethernet
    ETH_MDC   : out std_logic_vector(3 downto 0);
    ETH_INT_n : in  std_logic_vector(3 downto 0);  
    ETH_MDIO  : inout  std_logic_vector(3 downto 0); 
    ETH_RST_n : out std_logic;
    ETH_RX_p  : in  std_logic_vector(3 downto 0); 
    ETH_TX_p  : out std_logic_vector(3 downto 0); 

    -- DDR2 DIM2
    M2_DDR2_addr    : out   std_logic_vector(15 downto 0);      
    M2_DDR2_ba      : out   std_logic_vector(2  downto 0);
    M2_DDR2_cas_n   : out   std_logic_vector(0 downto 0);  
    M2_DDR2_cke     : out   std_logic_vector(1  downto 0);
    M2_DDR2_clk     : inout std_logic_vector(1  downto 0);    
    M2_DDR2_clk_n   : inout std_logic_vector(1  downto 0);
    M2_DDR2_cs_n    : out   std_logic_vector(1  downto 0);
    M2_DDR2_dm      : out   std_logic_vector(7  downto 0); 
    M2_DDR2_dq      : inout std_logic_vector(63 downto 0); 
    M2_DDR2_dqs     : inout std_logic_vector(7  downto 0);
    M2_DDR2_dqsn    : inout std_logic_vector(7  downto 0);
    M2_DDR2_odt     : out   std_logic_vector(1  downto 0);
    M2_DDR2_ras_n   : out   std_logic_vector(0 downto 0);  
    M2_DDR2_SA      : out   std_logic_vector(1  downto 0);
    M2_DDR2_we_n    : out   std_logic_vector(0 downto 0);  
    M2_DDR2_SCL     : out   std_logic;
    M2_DDR2_SDA     : inout std_logic;
    M2_DDR2_oct_rdn : in    std_logic;
    M2_DDR2_oct_rup : in    std_logic;
	 
	 -- DDR2 DIM2
    M1_DDR2_addr    : out   std_logic_vector(15 downto 0);      
    M1_DDR2_ba      : out   std_logic_vector(2  downto 0);
    M1_DDR2_cas_n   : out   std_logic_vector(0 downto 0);  
    M1_DDR2_cke     : out   std_logic_vector(1  downto 0);
    M1_DDR2_clk     : inout std_logic_vector(1  downto 0);    
    M1_DDR2_clk_n   : inout std_logic_vector(1  downto 0);
    M1_DDR2_cs_n    : out   std_logic_vector(1  downto 0);
    M1_DDR2_dm      : out   std_logic_vector(7  downto 0); 
    M1_DDR2_dq      : inout std_logic_vector(63 downto 0); 
    M1_DDR2_dqs     : inout std_logic_vector(7  downto 0);
    M1_DDR2_dqsn    : inout std_logic_vector(7  downto 0);
    M1_DDR2_odt     : out   std_logic_vector(1  downto 0);
    M1_DDR2_ras_n   : out   std_logic_vector(0 downto 0);  
    M1_DDR2_SA      : out   std_logic_vector(1  downto 0);
    M1_DDR2_we_n    : out   std_logic_vector(0 downto 0);  
    M1_DDR2_SCL     : out   std_logic;
    M1_DDR2_SDA     : inout std_logic;
    M1_DDR2_oct_rdn : in    std_logic;
    M1_DDR2_oct_rup : in    std_logic;

    -- Memory acess
    FSM_A : out std_logic_vector(25 downto 0);
    FSM_D : inout std_logic_vector(15 downto 0);

    -- Flash control
    FLASH_ADV_n     : out std_logic;
    FLASH_CE_n      : out std_logic_vector(0 downto 0);
    FLASH_CLK       : out std_logic;
    FLASH_OE_n      : out std_logic_vector(0 downto 0);
    FLASH_RESET_n   : out std_logic;
    FLASH_RYBY_n    : in std_logic;
    FLASH_WE_n      : out std_logic_vector(0 downto 0);

    -- Temperature 
	 TEMP_INT_n		: in    std_logic;
	 TEMP_SMCLK		: out   std_logic;
	 TEMP_SMDAT		: inout std_logic;

	 -- Current 
	 CSENSE_ADC_FO	: out std_logic;
	 CSENSE_CS_n		: out std_logic_vector(1 downto 0);
	 CSENSE_SCK		: out std_logic;
	 CSENSE_SDI		: out std_logic;
	 CSENSE_SDO 		: in  std_logic;
	 
	 -- FTDI Module
    FTDI_DATA     : inout std_logic_vector(31 downto 0);
    FTDI_BE       : inout std_logic_vector(3 downto 0);
    FTDI_RESET_N  : out   std_logic;
    FTDI_WAKEUP_N : inout std_logic;
    FTDI_CLOCK    : in    std_logic;
    FTDI_RXF_N    : in    std_logic;
    FTDI_TXE_N    : in    std_logic;
    FTDI_GPIO     : inout std_logic_vector(1 downto 0);
    FTDI_WR_N     : out   std_logic;
    FTDI_RD_N     : out   std_logic;
    FTDI_OE_N     : out   std_logic;
    FTDI_SIWU_N   : out   std_logic

  );
end entity;

architecture bhv of MebX_TopLevel is

-----------------------------------------
-- Clock e reset
-----------------------------------------
signal clk125, clk100, clk80 : std_logic;

signal forceIntRst_n : std_logic := '0';

attribute KEEP: boolean;
attribute KEEP of clk100: signal is true;
attribute KEEP of clk80: signal is true;

-----------------------------------------
-- Ethernet 
-----------------------------------------
signal rst_eth            : std_logic := '0';
signal tse_mdio_mdio_in   : std_logic;  
signal tse_mdio_mdio_out  : std_logic; 
signal tse_mdio_mdio_oen  : std_logic;
signal enet_mdc : std_logic;

-----------------------------------------
-- LEDs
-----------------------------------------
signal leds_i : std_logic_vector(7  downto 0);
signal leds_p : std_logic_vector(12 downto 0);

-----------------------------------------
-- RST CPU
-----------------------------------------
signal rst : std_logic;


signal pll_locked : std_logic;

-----------------------------------------
-- Component
-----------------------------------------
  
    component MebX_Qsys_Project is
        port (

            rst_reset_n             : in    std_logic;

            m2_ddr2_memory_mem_a             : out   std_logic_vector(13 downto 0);                    
            m2_ddr2_memory_mem_ba            : out   std_logic_vector(2 downto 0);                     
            m2_ddr2_memory_mem_ck            : out   std_logic_vector(1 downto 0);                     
            m2_ddr2_memory_mem_ck_n          : out   std_logic_vector(1 downto 0);                     
            m2_ddr2_memory_mem_cke           : out   std_logic_vector(0 downto 0);                     
            m2_ddr2_memory_mem_cs_n          : out   std_logic_vector(0 downto 0);                     
            m2_ddr2_memory_mem_dm            : out   std_logic_vector(7 downto 0);                     
            m2_ddr2_memory_mem_ras_n         : out   std_logic_vector(0 downto 0);                     
            m2_ddr2_memory_mem_cas_n         : out   std_logic_vector(0 downto 0);                     
            m2_ddr2_memory_mem_we_n          : out   std_logic_vector(0 downto 0);                     
            m2_ddr2_memory_mem_dq            : inout std_logic_vector(63 downto 0) := (others => 'X'); 
            m2_ddr2_memory_mem_dqs           : inout std_logic_vector(7 downto 0)  := (others => 'X'); 
            m2_ddr2_memory_mem_dqs_n         : inout std_logic_vector(7 downto 0)  := (others => 'X'); 
            m2_ddr2_memory_mem_odt           : out   std_logic_vector(0 downto 0);                     
            m2_ddr2_oct_rdn                  : in    std_logic                     := 'X';             
            m2_ddr2_oct_rup                  : in    std_logic                     := 'X';             

            m1_ddr2_memory_pll_ref_clk_clk        : in    std_logic                     := 'X'   ;           -- clk
            m1_ddr2_memory_mem_a             : out   std_logic_vector(13 downto 0);                    
            m1_ddr2_memory_mem_ba            : out   std_logic_vector(2 downto 0);                     
            m1_ddr2_memory_mem_ck            : out   std_logic_vector(1 downto 0);                     
            m1_ddr2_memory_mem_ck_n          : out   std_logic_vector(1 downto 0);                     
            m1_ddr2_memory_mem_cke           : out   std_logic_vector(0 downto 0);                     
            m1_ddr2_memory_mem_cs_n          : out   std_logic_vector(0 downto 0);                     
            m1_ddr2_memory_mem_dm            : out   std_logic_vector(7 downto 0);                     
            m1_ddr2_memory_mem_ras_n         : out   std_logic_vector(0 downto 0);                     
            m1_ddr2_memory_mem_cas_n         : out   std_logic_vector(0 downto 0);                     
            m1_ddr2_memory_mem_we_n          : out   std_logic_vector(0 downto 0);                     
            m1_ddr2_memory_mem_dq            : inout std_logic_vector(63 downto 0) := (others => 'X'); 
            m1_ddr2_memory_mem_dqs           : inout std_logic_vector(7 downto 0)  := (others => 'X'); 
            m1_ddr2_memory_mem_dqs_n         : inout std_logic_vector(7 downto 0)  := (others => 'X'); 
            m1_ddr2_memory_mem_odt           : out   std_logic_vector(0 downto 0);                     
            m1_ddr2_oct_rdn                  : in    std_logic                     := 'X';             
            m1_ddr2_oct_rup                  : in    std_logic                     := 'X';             
            
            clk50_clk                : in    std_logic                     := 'X';             

            ETH_rst_export                        : out   std_logic;
            tse_clk_clk                           : in    std_logic;      
            tse_mdio_mdc                          : out   std_logic;                                 
            tse_mdio_mdio_in                      : in    std_logic;      
            tse_mdio_mdio_out                     : out   std_logic;                                 
            tse_mdio_mdio_oen                     : out   std_logic;                                 
            tse_led_crs                           : out   std_logic;                                 
            tse_led_link                          : out   std_logic;                                 
            tse_led_col                           : out   std_logic;                                 
            tse_led_an                            : out   std_logic;                                 
            tse_led_char_err                      : out   std_logic;                                 
            tse_led_disp_err                      : out   std_logic;                                 
            tse_serial_txp                        : out   std_logic;                                 
            tse_serial_rxp                        : in    std_logic;      
            tristate_conduit_tcm_address_out      : out   std_logic_vector(25 downto 0);             
            tristate_conduit_tcm_read_n_out       : out   std_logic_vector(0 downto 0);              
            tristate_conduit_tcm_write_n_out      : out   std_logic_vector(0 downto 0);              
            tristate_conduit_tcm_data_out         : inout std_logic_vector(15 downto 0); 					
            tristate_conduit_tcm_chipselect_n_out : out   std_logic_vector(0 downto 0);              
				
            button_export      : in    std_logic_vector(3 downto 0);
            dip_export         : in    std_logic_vector(7 downto 0);
            ext_export         : in    std_logic;            
				
            led_de4_export                        : out   std_logic_vector(7 downto 0);  
            led_painel_export                     : out   std_logic_vector(12 downto 0);
            ssdp_ssdp1                            : out   std_logic_vector(7 downto 0);
            ssdp_ssdp0                            : out   std_logic_vector(7 downto 0);
            sd_wp_n_export     : in    std_logic;            
            sd_cmd_export      : inout std_logic;            
            sd_clk_export      : out   std_logic;                                       
            sd_dat_export      : inout std_logic_vector(3 downto 0);
				
				
            m1_ddr2_i2c_scl_export  : out   std_logic;                                 
            m1_ddr2_i2c_sda_export  : inout std_logic;      
            m2_ddr2_i2c_scl_export  : out   std_logic;                                 
            m2_ddr2_i2c_sda_export  : inout std_logic;    


            temp_scl_export       : out   std_logic;                     
            temp_sda_export       : inout std_logic;
            csense_adc_fo_export  : out   std_logic;                     
            csense_cs_n_export    : out   std_logic_vector(1 downto 0);  
            csense_sck_export     : out   std_logic;                     
            csense_sdi_export     : out   std_logic;                     
            csense_sdo_export     : in    std_logic;
				
            ftdi_ftdi_data_signal     : inout std_logic_vector(31 downto 0) := (others => 'X'); -- ftdi_data_signal
            ftdi_ftdi_be_signal       : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- ftdi_be_signal
            ftdi_ftdi_reset_n_signal  : out   std_logic;                                        -- ftdi_reset_n_signal
            ftdi_ftdi_wakeup_n_signal : inout std_logic                     := 'X';             -- ftdi_wakeup_n_signal
            ftdi_ftdi_clock_signal    : in    std_logic                     := 'X';             -- ftdi_clock_signal
            ftdi_ftdi_rxf_n_signal    : in    std_logic                     := 'X';             -- ftdi_rxf_n_signal
            ftdi_ftdi_txe_n_signal    : in    std_logic                     := 'X';             -- ftdi_txe_n_signal
            ftdi_ftdi_gpio_signal     : inout std_logic_vector(1 downto 0)  := (others => 'X'); -- ftdi_gpio_signal
            ftdi_ftdi_wr_n_signal     : out   std_logic;                                        -- ftdi_wr_n_signal
            ftdi_ftdi_rd_n_signal     : out   std_logic;                                        -- ftdi_rd_n_signal
            ftdi_ftdi_oe_n_signal     : out   std_logic;                                        -- ftdi_oe_n_signal
            ftdi_ftdi_siwu_n_signal   : out   std_logic                                         -- ftdi_siwu_n_signal
				
        );
    end component MebX_Qsys_Project;

component pll_125
	PORT
	(
		inclk0		: IN STD_LOGIC  := '0';
		c0				: OUT STD_LOGIC 
	);
end component;


------------------------------------------------------------
begin

--==========--
-- Clk
--==========--
PLL_inst_125 : pll_125 PORT MAP (
		inclk0	 => OSC_50_BANK2,
		c0	 	    => clk125
	);

--==========--
-- AVALON
--==========--
--==========--
-- AVALON
--==========--
SOPC_INST : MebX_Qsys_Project
	port map (

    clk50_clk	 => OSC_50_Bank4,
    rst_reset_n => rst,

    led_de4_export    => leds_i,
    led_painel_export => leds_p,
	
	ssdp_ssdp1        => SEVEN_SEG_HEX1,
	ssdp_ssdp0        => SEVEN_SEG_HEX0,

    dip_export      => SW,
    button_export   => Button,
    ext_export	     => EXT_IO,

    sd_wp_n_export   => sd_wp_n,
    sd_cmd_export    => sd_cmd,
    sd_clk_export    => sd_clk,
    sd_dat_export    => sd_dat,

    tse_clk_clk 						          => clk125, 
    ETH_rst_export                         => rst_eth,
    tse_mdio_mdc                           => OPEN,
    tse_mdio_mdio_in                       => tse_mdio_mdio_in,
    tse_mdio_mdio_out                      => tse_mdio_mdio_out,
    tse_mdio_mdio_oen                      => tse_mdio_mdio_oen,
    tse_led_crs                            => OPEN, 
    tse_led_link                           => OPEN, 
    tse_led_col                            => OPEN, 
    tse_led_an                             => OPEN, 
    tse_led_char_err                       => OPEN, 
    tse_led_disp_err                       => OPEN, 
    tse_serial_txp                         => ETH_TX_p(0), 
    tse_serial_rxp                         => ETH_RX_p(0),
    
    tristate_conduit_tcm_address_out       => FSM_A(25 downto 0),
    tristate_conduit_tcm_data_out          => FSM_D,
    tristate_conduit_tcm_chipselect_n_out  => FLASH_CE_n, 
    tristate_conduit_tcm_read_n_out        => FLASH_OE_n,
    tristate_conduit_tcm_write_n_out       => FLASH_WE_n,
    
    m1_ddr2_memory_pll_ref_clk_clk=> OSC_50_Bank3,
    m1_ddr2_memory_mem_a          => M1_DDR2_addr(13 DOWNTO 0),
    m1_ddr2_memory_mem_ba         => M1_DDR2_ba,
    m1_ddr2_memory_mem_ck         => M1_DDR2_clk, 
    m1_ddr2_memory_mem_ck_n       => M1_DDR2_clk_n,
    m1_ddr2_memory_mem_cke        => M1_DDR2_cke(0 downto 0),
    m1_ddr2_memory_mem_cs_n       => M1_DDR2_cs_n(0 downto 0),
    m1_ddr2_memory_mem_dm         => M1_DDR2_dm, 
    m1_ddr2_memory_mem_ras_n      => M1_DDR2_ras_n,
    m1_ddr2_memory_mem_cas_n      => M1_DDR2_cas_n,
    m1_ddr2_memory_mem_we_n       => M1_DDR2_we_n, 
    m1_ddr2_memory_mem_dq         => M1_DDR2_dq, 
    m1_ddr2_memory_mem_dqs        => M1_DDR2_dqs,
    m1_ddr2_memory_mem_dqs_n      => M1_DDR2_dqsn,
    m1_ddr2_memory_mem_odt        => M1_DDR2_odt(0 downto 0), 
    m1_ddr2_oct_rdn               => M1_DDR2_oct_rdn,
    m1_ddr2_oct_rup               => M1_DDR2_oct_rup,
    m1_ddr2_i2c_scl_export        => M1_DDR2_SCL,
    m1_ddr2_i2c_sda_export        => M1_DDR2_SDA,

    m2_ddr2_memory_mem_a          => M2_DDR2_addr(13 DOWNTO 0),
    m2_ddr2_memory_mem_ba         => M2_DDR2_ba,
    m2_ddr2_memory_mem_ck         => M2_DDR2_clk, 
    m2_ddr2_memory_mem_ck_n       => M2_DDR2_clk_n,
    m2_ddr2_memory_mem_cke        => M2_DDR2_cke(0 downto 0),
    m2_ddr2_memory_mem_cs_n       => M2_DDR2_cs_n(0 downto 0),
    m2_ddr2_memory_mem_dm         => M2_DDR2_dm, 
    m2_ddr2_memory_mem_ras_n      => M2_DDR2_ras_n,
    m2_ddr2_memory_mem_cas_n      => M2_DDR2_cas_n,
    m2_ddr2_memory_mem_we_n       => M2_DDR2_we_n, 
    m2_ddr2_memory_mem_dq         => M2_DDR2_dq, 
    m2_ddr2_memory_mem_dqs        => M2_DDR2_dqs,
    m2_ddr2_memory_mem_dqs_n      => M2_DDR2_dqsn,
    m2_ddr2_memory_mem_odt        => M2_DDR2_odt(0 downto 0), 
    m2_ddr2_oct_rdn               => M2_DDR2_oct_rdn,
    m2_ddr2_oct_rup               => M2_DDR2_oct_rup,
    m2_ddr2_i2c_scl_export        => M2_DDR2_SCL,
    m2_ddr2_i2c_sda_export        => M2_DDR2_SDA,
    
    temp_scl_export          => TEMP_SMCLK,
    temp_sda_export          => TEMP_SMDAT,
                                           
    csense_adc_fo_export     => csense_adc_fo,
    csense_cs_n_export       => csense_cs_n,
    csense_sck_export        => csense_sck,
    csense_sdi_export        => csense_sdi,
    csense_sdo_export        => csense_sdo,
	 
    ftdi_ftdi_data_signal     => FTDI_DATA,
    ftdi_ftdi_be_signal       => FTDI_BE,
    ftdi_ftdi_reset_n_signal  => FTDI_RESET_N,
    ftdi_ftdi_wakeup_n_signal => FTDI_WAKEUP_N,
    ftdi_ftdi_clock_signal    => FTDI_CLOCK,
    ftdi_ftdi_rxf_n_signal    => FTDI_RXF_N,
    ftdi_ftdi_txe_n_signal    => FTDI_TXE_N,
    ftdi_ftdi_gpio_signal     => FTDI_GPIO,
    ftdi_ftdi_wr_n_signal     => FTDI_WR_N,
    ftdi_ftdi_rd_n_signal     => FTDI_RD_N,
    ftdi_ftdi_oe_n_signal     => FTDI_OE_N,
    ftdi_ftdi_siwu_n_signal   => FTDI_SIWU_N

 );

--==========--
-- rst
--==========--

rst <= CPU_RESET_n AND RESET_PAINEL_n;
 
--==========--
-- I/Os
--==========--    

-- Ativa ventoinha
FAN_CTRL <= '1';

-- LEDs assumem estado diferente no rst.
LED_DE4    <= X"F0" when rst = '0' else
              leds_i;
                    
LED_PAINEL <= ('0' & X"F0F") when rst = '0' else
              leds_p;                    

--==========--
-- eth
--==========--

tse_mdio_mdio_in <= ETH_MDIO(0);

ETH_MDIO(0) <=  tse_mdio_mdio_out WHEN (tse_mdio_mdio_oen = '0') else
                '1';

ETH_RST_n <= rst AND rst_eth;

--==========--
-- Flash
--==========--

FLASH_RESET_n <= rst;
FLASH_CLK     <= '0';
FLASH_ADV_n   <= '0';

end bhv;