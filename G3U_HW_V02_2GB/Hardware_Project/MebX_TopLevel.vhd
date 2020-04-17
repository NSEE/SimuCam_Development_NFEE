-------------------------------------------------------------------------------
-- Instituto Maua de Tecnologia
-- 	Nucleo de Sistemas Eletronicos Embarcados
--
-- Rafael Corsi - rafael.corsi@maua.br
-- Platao Simucam 2.0
--
-- Set/2014
--
--------------------------------------------------------------------------------
-- Descriao
-- 	Topo Level TransBlock
-- 		Inicializa SpW Codec, memorias compartilhadas, resgistradores, CRCs.
--		Faz uso de subsistemas desenvolvidos para o Simucam 1.0
--
--Funcionalidade
--	Possui os elementos basicos para a transmissao de dados entre um (N/F)-FEE e
-- 	uma (N/F)-DPU, o sistema e controlado via registradores que serao geridos
--	por um uc (NIOS).
--  A transmissao das imagems, hk e controle da FEE e´ realizada via comandos RMAP
--  esse bloco deve portanto implemnetar comandos RMAP de Leitura, Escrita, Leitura-Escrita
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
		OSC_50_BANK2           : in    std_logic;
		OSC_50_BANK4           : in    std_logic;
		OSC_50_BANK3           : in    std_logic;
		-- RST
		CPU_RESET_n            : in    std_logic;
		RESET_PAINEL_n         : in    std_logic; -- painel GPIO1

		-- Buttons
		Button                 : in    std_logic_vector(3 downto 0);
		SW                     : in    std_logic_vector(7 downto 0);
		EXT_IO                 : in    std_logic;
		-- LEDs
		LED_DE4                : out   std_logic_vector(7 downto 0);
		-- painel GPIO1
		LED_PAINEL_LED_1G      : out   std_logic;
		LED_PAINEL_LED_1R      : out   std_logic;
		LED_PAINEL_LED_2G      : out   std_logic;
		LED_PAINEL_LED_2R      : out   std_logic;
		LED_PAINEL_LED_3G      : out   std_logic;
		LED_PAINEL_LED_3R      : out   std_logic;
		LED_PAINEL_LED_4G      : out   std_logic;
		LED_PAINEL_LED_4R      : out   std_logic;
		LED_PAINEL_LED_5G      : out   std_logic;
		LED_PAINEL_LED_5R      : out   std_logic;
		LED_PAINEL_LED_6G      : out   std_logic;
		LED_PAINEL_LED_6R      : out   std_logic;
		LED_PAINEL_LED_7G      : out   std_logic;
		LED_PAINEL_LED_7R      : out   std_logic;
		LED_PAINEL_LED_8G      : out   std_logic;
		LED_PAINEL_LED_8R      : out   std_logic;
		LED_PAINEL_LED_POWER   : out   std_logic;
		LED_PAINEL_LED_ST1     : out   std_logic;
		LED_PAINEL_LED_ST2     : out   std_logic;
		LED_PAINEL_LED_ST3     : out   std_logic;
		LED_PAINEL_LED_ST4     : out   std_logic;
		-- Seven Segment Display
		SEVEN_SEG_HEX1         : out   std_logic_vector(7 downto 0);
		SEVEN_SEG_HEX0         : out   std_logic_vector(7 downto 0);
		-- FANs
		FAN_CTRL               : out   std_logic;
		-- SD CARD
		I_SD_CARD_WP_n         : in    std_logic;
		B_SD_CARD_CMD          : inout std_logic;
		B_SD_CARD_DAT          : inout std_logic;
		B_SD_CARD_DAT3         : inout std_logic;
		O_SD_CARD_CLOCK        : out   std_logic;
		--		-- Ethernet
		--		ETH_MDC                : out   std_logic_vector(3 downto 0);
		--		ETH_INT_n              : in    std_logic_vector(3 downto 0);
		--		ETH_MDIO               : inout std_logic_vector(3 downto 0);
		--		ETH_RST_n              : out   std_logic;
		--		ETH_RX_p               : in    std_logic_vector(3 downto 0);
		--		ETH_TX_p               : out   std_logic_vector(3 downto 0);
		-- DDR2 DIM2
		M2_DDR2_addr           : out   std_logic_vector(13 downto 0);
		M2_DDR2_ba             : out   std_logic_vector(2 downto 0);
		M2_DDR2_clk            : inout std_logic_vector(1 downto 0);
		M2_DDR2_clk_n          : inout std_logic_vector(1 downto 0);
		M2_DDR2_cke            : out   std_logic_vector(1 downto 0);
		M2_DDR2_cs_n           : out   std_logic_vector(1 downto 0);
		M2_DDR2_dm             : out   std_logic_vector(7 downto 0);
		M2_DDR2_ras_n          : out   std_logic_vector(0 downto 0);
		M2_DDR2_cas_n          : out   std_logic_vector(0 downto 0);
		M2_DDR2_we_n           : out   std_logic_vector(0 downto 0);
		M2_DDR2_dq             : inout std_logic_vector(63 downto 0);
		M2_DDR2_dqs            : inout std_logic_vector(7 downto 0);
		M2_DDR2_dqsn           : inout std_logic_vector(7 downto 0);
		M2_DDR2_odt            : out   std_logic_vector(1 downto 0);
		M2_DDR2_oct_rdn        : in    std_logic;
		M2_DDR2_oct_rup        : in    std_logic;
		M2_DDR2_SCL            : out   std_logic;
		M2_DDR2_SDA            : inout std_logic;
		M2_DDR2_SA             : out   std_logic_vector(1 downto 0);
		-- DDR2 DIM2
		M1_DDR2_addr           : out   std_logic_vector(13 downto 0);
		M1_DDR2_ba             : out   std_logic_vector(2 downto 0);
		M1_DDR2_clk            : inout std_logic_vector(1 downto 0);
		M1_DDR2_clk_n          : inout std_logic_vector(1 downto 0);
		M1_DDR2_cke            : out   std_logic_vector(1 downto 0);
		M1_DDR2_cs_n           : out   std_logic_vector(1 downto 0);
		M1_DDR2_dm             : out   std_logic_vector(7 downto 0);
		M1_DDR2_ras_n          : out   std_logic_vector(0 downto 0);
		M1_DDR2_cas_n          : out   std_logic_vector(0 downto 0);
		M1_DDR2_we_n           : out   std_logic_vector(0 downto 0);
		M1_DDR2_dq             : inout std_logic_vector(63 downto 0);
		M1_DDR2_dqs            : inout std_logic_vector(7 downto 0);
		M1_DDR2_dqsn           : inout std_logic_vector(7 downto 0);
		M1_DDR2_odt            : out   std_logic_vector(1 downto 0);
		M1_DDR2_oct_rdn        : in    std_logic;
		M1_DDR2_oct_rup        : in    std_logic;
		M1_DDR2_SCL            : out   std_logic;
		M1_DDR2_SDA            : inout std_logic;
		M1_DDR2_SA             : out   std_logic_vector(1 downto 0);
		-- Memory acess
		FSM_A                  : out   std_logic_vector(25 downto 0);
		FSM_D                  : inout std_logic_vector(15 downto 0);
		-- Flash control
		FLASH_ADV_n            : out   std_logic;
		FLASH_CE_n             : out   std_logic_vector(0 downto 0);
		FLASH_CLK              : out   std_logic;
		FLASH_OE_n             : out   std_logic_vector(0 downto 0);
		FLASH_RESET_n          : out   std_logic;
		FLASH_RYBY_n           : in    std_logic;
		FLASH_WE_n             : out   std_logic_vector(0 downto 0);
		-- Sinais de controle - placa isoladora - habilitacao dos transmissores SpW e Sinc_out
		EN_ISO_DRIVERS         : out   std_logic;
		-- Sinais externos LVDS HSMC-B
		-- Sinais de controle - placa drivers_lvds
		HSMB_BUFFER_PWDN_N     : out   std_logic;
		HSMB_BUFFER_PEM1       : out   std_logic;
		HSMB_BUFFER_PEM0       : out   std_logic;
		-- SpaceWire A
		HSMB_LVDS_RX_SPWA_DI_P : in    std_logic_vector(0 downto 0);
		--	HSMB_LVDS_RX_SPWA_DI_N : in  std_logic_vector(0 downto 0);
		HSMB_LVDS_RX_SPWA_SI_P : in    std_logic_vector(0 downto 0);
		--	HSMB_LVDS_RX_SPWA_SI_N : in  std_logic_vector(0 downto 0);
		HSMB_LVDS_TX_SPWA_DO_P : out   std_logic_vector(0 downto 0);
		--	HSMB_LVDS_TX_SPWA_DO_N : out std_logic_vector(0 downto 0);
		HSMB_LVDS_TX_SPWA_SO_P : out   std_logic_vector(0 downto 0);
		--	HSMB_LVDS_TX_SPWA_SO_N : out std_logic_vector(0 downto 0);
		-- SpaceWire B
		HSMB_LVDS_RX_SPWB_DI_P : in    std_logic_vector(0 downto 0);
		--	HSMB_LVDS_RX_SPWB_DI_N : in  std_logic_vector(0 downto 0);
		HSMB_LVDS_RX_SPWB_SI_P : in    std_logic_vector(0 downto 0);
		--	HSMB_LVDS_RX_SPWB_SI_N : in  std_logic_vector(0 downto 0);
		HSMB_LVDS_TX_SPWB_DO_P : out   std_logic_vector(0 downto 0);
		--	HSMB_LVDS_TX_SPWB_DO_N : out std_logic_vector(0 downto 0);
		HSMB_LVDS_TX_SPWB_SO_P : out   std_logic_vector(0 downto 0);
		--	HSMB_LVDS_TX_SPWB_SO_N : out std_logic_vector(0 downto 0);
		-- SpaceWire C
		HSMB_LVDS_RX_SPWC_DI_P : in    std_logic_vector(0 downto 0);
		--	HSMB_LVDS_RX_SPWC_DI_N : in  std_logic_vector(0 downto 0);
		HSMB_LVDS_RX_SPWC_SI_P : in    std_logic_vector(0 downto 0);
		--	HSMB_LVDS_RX_SPWC_SI_N : in  std_logic_vector(0 downto 0);
		HSMB_LVDS_TX_SPWC_DO_P : out   std_logic_vector(0 downto 0);
		--	HSMB_LVDS_TX_SPWC_DO_N : out std_logic_vector(0 downto 0);
		HSMB_LVDS_TX_SPWC_SO_P : out   std_logic_vector(0 downto 0);
		--	HSMB_LVDS_TX_SPWC_SO_N : out std_logic_vector(0 downto 0);
		-- SpaceWire D
		HSMB_LVDS_RX_SPWD_DI_P : in    std_logic_vector(0 downto 0);
		--	HSMB_LVDS_RX_SPWD_DI_N : in  std_logic_vector(0 downto 0);
		HSMB_LVDS_RX_SPWD_SI_P : in    std_logic_vector(0 downto 0);
		--	HSMB_LVDS_RX_SPWD_SI_N : in  std_logic_vector(0 downto 0);
		HSMB_LVDS_TX_SPWD_DO_P : out   std_logic_vector(0 downto 0);
		--	HSMB_LVDS_TX_SPWD_DO_N : out std_logic_vector(0 downto 0);
		HSMB_LVDS_TX_SPWD_SO_P : out   std_logic_vector(0 downto 0);
		--	HSMB_LVDS_TX_SPWD_SO_N : out std_logic_vector(0 downto 0);
		-- SpaceWire E
		HSMB_LVDS_RX_SPWE_DI_P : in    std_logic_vector(0 downto 0);
		--	HSMB_LVDS_RX_SPWE_DI_N : in  std_logic_vector(0 downto 0);
		HSMB_LVDS_RX_SPWE_SI_P : in    std_logic_vector(0 downto 0);
		--	HSMB_LVDS_RX_SPWE_SI_N : in  std_logic_vector(0 downto 0);
		HSMB_LVDS_TX_SPWE_DO_P : out   std_logic_vector(0 downto 0);
		--	HSMB_LVDS_TX_SPWE_DO_N : out std_logic_vector(0 downto 0);
		HSMB_LVDS_TX_SPWE_SO_P : out   std_logic_vector(0 downto 0);
		--	HSMB_LVDS_TX_SPWE_SO_N : out std_logic_vector(0 downto 0);
		-- SpaceWire F
		HSMB_LVDS_RX_SPWF_DI_P : in    std_logic_vector(0 downto 0);
		--	HSMB_LVDS_RX_SPWF_DI_N : in  std_logic_vector(0 downto 0);
		HSMB_LVDS_RX_SPWF_SI_P : in    std_logic_vector(0 downto 0);
		--	HSMB_LVDS_RX_SPWF_SI_N : in  std_logic_vector(0 downto 0);
		HSMB_LVDS_TX_SPWF_DO_P : out   std_logic_vector(0 downto 0);
		--	HSMB_LVDS_TX_SPWF_DO_N : out std_logic_vector(0 downto 0);
		HSMB_LVDS_TX_SPWF_SO_P : out   std_logic_vector(0 downto 0);
		--	HSMB_LVDS_TX_SPWF_SO_N : out std_logic_vector(0 downto 0);
		-- SpaceWire G
		HSMB_LVDS_RX_SPWG_DI_P : in    std_logic_vector(0 downto 0);
		--	HSMB_LVDS_RX_SPWG_DI_N : in  std_logic_vector(0 downto 0);
		HSMB_LVDS_RX_SPWG_SI_P : in    std_logic_vector(0 downto 0);
		--	HSMB_LVDS_RX_SPWG_SI_N : in  std_logic_vector(0 downto 0);
		HSMB_LVDS_TX_SPWG_DO_P : out   std_logic_vector(0 downto 0);
		--	HSMB_LVDS_TX_SPWG_DO_N : out std_logic_vector(0 downto 0);
		HSMB_LVDS_TX_SPWG_SO_P : out   std_logic_vector(0 downto 0);
		--	HSMB_LVDS_TX_SPWG_SO_N : out std_logic_vector(0 downto 0);
		-- SpaceWire H
		HSMB_LVDS_RX_SPWH_DI_P : in    std_logic_vector(0 downto 0);
		--	HSMB_LVDS_RX_SPWH_DI_N : in  std_logic_vector(0 downto 0);
		HSMB_LVDS_RX_SPWH_SI_P : in    std_logic_vector(0 downto 0);
		--	HSMB_LVDS_RX_SPWH_SI_N : in  std_logic_vector(0 downto 0);
		HSMB_LVDS_TX_SPWH_DO_P : out   std_logic_vector(0 downto 0);
		--	HSMB_LVDS_TX_SPWH_DO_N : out std_logic_vector(0 downto 0);
		HSMB_LVDS_TX_SPWH_SO_P : out   std_logic_vector(0 downto 0);
		--	HSMB_LVDS_TX_SPWH_SO_N : out std_logic_vector(0 downto 0);
		-- Temperature 
		TEMP_INT_n             : in    std_logic;
		TEMP_SMCLK             : out   std_logic;
		TEMP_SMDAT             : inout std_logic;
		-- Current 
		CSENSE_ADC_FO          : out   std_logic;
		CSENSE_CS_n            : out   std_logic_vector(1 downto 0);
		CSENSE_SCK             : out   std_logic;
		CSENSE_SDI             : out   std_logic;
		CSENSE_SDO             : in    std_logic;
		-- Real Time Clock
		RTCC_ALARM             : in    std_logic;
		RTCC_CS_n              : out   std_logic;
		RTCC_SCK               : out   std_logic;
		RTCC_SDI               : out   std_logic;
		RTCC_SDO               : in    std_logic;
		-- Synchronization
		SYNC_IN                : in    std_logic;
		SYNC_OUT               : out   std_logic;
		-- RS232 UART	 
		I_RS232_UART_RXD       : in    std_logic;
		O_RS232_UART_TXD       : out   std_logic;
		-- GPIO Expansion Header (JP3) Pins
--		JP3_GPIO0_D0_IO        : inout std_logic;
--		JP3_GPIO0_D1_IO        : inout std_logic;
--		JP3_GPIO0_D2_IO        : inout std_logic;
--		JP3_GPIO0_D3_IO        : inout std_logic;
--		JP3_GPIO0_D4_IO        : inout std_logic;
--		JP3_GPIO0_D5_IO        : inout std_logic;
--		JP3_GPIO0_D6_IO        : inout std_logic;
--		JP3_GPIO0_D7_IO        : inout std_logic;
--		JP3_GPIO0_D8_IO        : inout std_logic;
--		JP3_GPIO0_D9_IO        : inout std_logic;
		JP3_GPIO0_D10_IO       : out   std_logic;
		JP3_GPIO0_D11_IO       : out   std_logic;
--		JP3_GPIO0_D12_IO       : inout std_logic;
--		JP3_GPIO0_D13_IO       : inout std_logic;
		JP3_GPIO0_D14_IO       : out   std_logic;
		JP3_GPIO0_D15_IO       : out   std_logic;
		JP3_GPIO0_D16_IO       : out   std_logic;
		JP3_GPIO0_D17_IO       : out   std_logic;
		JP3_GPIO0_D18_IO       : out   std_logic;
		JP3_GPIO0_D19_IO       : out   std_logic;
		JP3_GPIO0_D20_IO       : out   std_logic;
		JP3_GPIO0_D21_IO       : out   std_logic;
		JP3_GPIO0_D22_IO       : out   std_logic;
		JP3_GPIO0_D23_IO       : out   std_logic;
		JP3_GPIO0_D24_IO       : out   std_logic;
		JP3_GPIO0_D25_IO       : out   std_logic;
--		JP3_GPIO0_D26_IO       : inout std_logic;
--		JP3_GPIO0_D27_IO       : inout std_logic;
--		JP3_GPIO0_D28_IO       : inout std_logic;
--		JP3_GPIO0_D29_IO       : inout std_logic;
		JP3_GPIO0_D30_IO       : out   std_logic;
		JP3_GPIO0_D31_IO       : out   std_logic;
		JP3_GPIO0_D32_IO       : out   std_logic;
		JP3_GPIO0_D33_IO       : out   std_logic;
		JP3_GPIO0_D34_IO       : out   std_logic;
		JP3_GPIO0_D35_IO       : out   std_logic;
		-- FTDI UMFT601A Module Pins
		FTDI_DATA              : inout std_logic_vector(31 downto 0);
		FTDI_BE                : inout std_logic_vector(3 downto 0);
		FTDI_RESET_N           : out   std_logic;
		FTDI_WAKEUP_N          : inout std_logic;
		FTDI_CLOCK             : in    std_logic;
		FTDI_RXF_N             : in    std_logic;
		FTDI_TXE_N             : in    std_logic;
		FTDI_GPIO              : inout std_logic_vector(1 downto 0);
		FTDI_WR_N              : out   std_logic;
		FTDI_RD_N              : out   std_logic;
		FTDI_OE_N              : out   std_logic;
		FTDI_SIWU_N            : out   std_logic
	);
end entity;

architecture bhv of MebX_TopLevel is

	-----------------------------------------
	-- Clock e reset
	-----------------------------------------
	signal clk125, clk100, clk80 : std_logic;

	signal forceIntRst_n : std_logic := '0';
	
	signal rst_ctrl_input : std_logic := '0';
	signal simucam_rst    : std_logic := '0';

	attribute KEEP : boolean;
	attribute KEEP of clk100 : signal is true;
	attribute KEEP of clk80 : signal is true;

	-----------------------------------------
	-- Ethernet 
	-----------------------------------------
	--signal rst_eth            : std_logic := '0';
	--signal enet_refclk_125MHz : std_logic := '0';
	--
	--signal enet_mdc      : std_logic;
	--signal enet_mdio_in  : std_logic;
	--signal enet_mdio_oen : std_logic;
	--signal enet_mdio_out : std_logic;
	--
	--signal lvds_rxp : std_logic;
	--signal lvds_txp : std_logic;

	-----------------------------------------
	-- LEDs
	-----------------------------------------
	signal leds_b : std_logic_vector(7 downto 0);
	signal leds_p : std_logic_vector(20 downto 0);

	-----------------------------------------
	-- Ctrl io lvds
	-----------------------------------------
	signal ctrl_io_lvds : std_logic_vector(3 downto 0);

	-----------------------------------------
	-- RST CPU
	-----------------------------------------
	signal rst_n : std_logic;

	signal pll_locked : std_logic;

	-----------------------------------------
	-- Signals
	-----------------------------------------
	signal spw_a_si : std_logic_vector(0 downto 0);
	signal spw_a_so : std_logic_vector(0 downto 0);
	signal spw_a_di : std_logic_vector(0 downto 0);
	signal spw_a_do : std_logic_vector(0 downto 0);
	signal spw_b_si : std_logic_vector(0 downto 0);
	signal spw_b_so : std_logic_vector(0 downto 0);
	signal spw_b_di : std_logic_vector(0 downto 0);
	signal spw_b_do : std_logic_vector(0 downto 0);
	signal spw_c_si : std_logic_vector(0 downto 0);
	signal spw_c_so : std_logic_vector(0 downto 0);
	signal spw_c_di : std_logic_vector(0 downto 0);
	signal spw_c_do : std_logic_vector(0 downto 0);
	signal spw_d_si : std_logic_vector(0 downto 0);
	signal spw_d_so : std_logic_vector(0 downto 0);
	signal spw_d_di : std_logic_vector(0 downto 0);
	signal spw_d_do : std_logic_vector(0 downto 0);
	signal spw_e_si : std_logic_vector(0 downto 0);
	signal spw_e_so : std_logic_vector(0 downto 0);
	signal spw_e_di : std_logic_vector(0 downto 0);
	signal spw_e_do : std_logic_vector(0 downto 0);
	signal spw_f_si : std_logic_vector(0 downto 0);
	signal spw_f_so : std_logic_vector(0 downto 0);
	signal spw_f_di : std_logic_vector(0 downto 0);
	signal spw_f_do : std_logic_vector(0 downto 0);
	signal spw_g_si : std_logic_vector(0 downto 0);
	signal spw_g_so : std_logic_vector(0 downto 0);
	signal spw_g_di : std_logic_vector(0 downto 0);
	signal spw_g_do : std_logic_vector(0 downto 0);
	signal spw_h_si : std_logic_vector(0 downto 0);
	signal spw_h_so : std_logic_vector(0 downto 0);
	signal spw_h_di : std_logic_vector(0 downto 0);
	signal spw_h_do : std_logic_vector(0 downto 0);

	signal spw_1_sync : std_logic;
	signal spw_2_sync : std_logic;
	signal spw_3_sync : std_logic;
	signal spw_4_sync : std_logic;
	signal spw_5_sync : std_logic;
	signal spw_6_sync : std_logic;
	signal spw_7_sync : std_logic;
	signal spw_8_sync : std_logic;

	signal spw_a_measure : std_logic_vector(7 downto 0);
	signal spw_b_measure : std_logic_vector(7 downto 0);
	signal spw_c_measure : std_logic_vector(7 downto 0);
	signal spw_d_measure : std_logic_vector(7 downto 0);
	signal spw_e_measure : std_logic_vector(7 downto 0);
	signal spw_f_measure : std_logic_vector(7 downto 0);
	signal spw_g_measure : std_logic_vector(7 downto 0);
	signal spw_h_measure : std_logic_vector(7 downto 0);

	signal spw_a_red_led   : std_logic;
	signal spw_a_green_led : std_logic;
	signal spw_b_red_led   : std_logic;
	signal spw_b_green_led : std_logic;
	signal spw_c_red_led   : std_logic;
	signal spw_c_green_led : std_logic;
	signal spw_d_red_led   : std_logic;
	signal spw_d_green_led : std_logic;
	signal spw_e_red_led   : std_logic;
	signal spw_e_green_led : std_logic;
	signal spw_f_red_led   : std_logic;
	signal spw_f_green_led : std_logic;
	signal spw_g_red_led   : std_logic;
	signal spw_g_green_led : std_logic;
	signal spw_h_red_led   : std_logic;
	signal spw_h_green_led : std_logic;

	-----------------------------------------
	-- Sync - test
	-----------------------------------------
	signal s_sync_out : std_logic := '0';
	signal s_sync_in  : std_logic := '0';

	-----------------------------------------
	-- Component
	-----------------------------------------

	component MebX_Qsys_Project is
		port(
			rst_reset_n                                                 : in    std_logic;
			--
			rst_controller_conduit_reset_input_t_reset_input_signal     : in    std_logic                     := 'X'; --          -- t_reset_input_signal
			rst_controller_conduit_simucam_reset_t_simucam_reset_signal : out   std_logic; --                                     -- t_simucam_reset_signal
			--
			m2_ddr2_memory_mem_a                                        : out   std_logic_vector(13 downto 0);
			m2_ddr2_memory_mem_ba                                       : out   std_logic_vector(2 downto 0);
			m2_ddr2_memory_mem_ck                                       : out   std_logic_vector(1 downto 0);
			m2_ddr2_memory_mem_ck_n                                     : out   std_logic_vector(1 downto 0);
			m2_ddr2_memory_mem_cke                                      : out   std_logic_vector(1 downto 0);
			m2_ddr2_memory_mem_cs_n                                     : out   std_logic_vector(1 downto 0);
			m2_ddr2_memory_mem_dm                                       : out   std_logic_vector(7 downto 0);
			m2_ddr2_memory_mem_ras_n                                    : out   std_logic_vector(0 downto 0);
			m2_ddr2_memory_mem_cas_n                                    : out   std_logic_vector(0 downto 0);
			m2_ddr2_memory_mem_we_n                                     : out   std_logic_vector(0 downto 0);
			m2_ddr2_memory_mem_dq                                       : inout std_logic_vector(63 downto 0) := (others => 'X');
			m2_ddr2_memory_mem_dqs                                      : inout std_logic_vector(7 downto 0)  := (others => 'X');
			m2_ddr2_memory_mem_dqs_n                                    : inout std_logic_vector(7 downto 0)  := (others => 'X');
			m2_ddr2_memory_mem_odt                                      : out   std_logic_vector(1 downto 0);
			m2_ddr2_oct_rdn                                             : in    std_logic                     := 'X';
			m2_ddr2_oct_rup                                             : in    std_logic                     := 'X';
			--
			m1_ddr2_memory_pll_ref_clk_clk                              : in    std_logic                     := 'X'; -- clk
			m1_ddr2_memory_mem_a                                        : out   std_logic_vector(13 downto 0);
			m1_ddr2_memory_mem_ba                                       : out   std_logic_vector(2 downto 0);
			m1_ddr2_memory_mem_ck                                       : out   std_logic_vector(1 downto 0);
			m1_ddr2_memory_mem_ck_n                                     : out   std_logic_vector(1 downto 0);
			m1_ddr2_memory_mem_cke                                      : out   std_logic_vector(1 downto 0);
			m1_ddr2_memory_mem_cs_n                                     : out   std_logic_vector(1 downto 0);
			m1_ddr2_memory_mem_dm                                       : out   std_logic_vector(7 downto 0);
			m1_ddr2_memory_mem_ras_n                                    : out   std_logic_vector(0 downto 0);
			m1_ddr2_memory_mem_cas_n                                    : out   std_logic_vector(0 downto 0);
			m1_ddr2_memory_mem_we_n                                     : out   std_logic_vector(0 downto 0);
			m1_ddr2_memory_mem_dq                                       : inout std_logic_vector(63 downto 0) := (others => 'X');
			m1_ddr2_memory_mem_dqs                                      : inout std_logic_vector(7 downto 0)  := (others => 'X');
			m1_ddr2_memory_mem_dqs_n                                    : inout std_logic_vector(7 downto 0)  := (others => 'X');
			m1_ddr2_memory_mem_odt                                      : out   std_logic_vector(1 downto 0);
			m1_ddr2_oct_rdn                                             : in    std_logic                     := 'X';
			m1_ddr2_oct_rup                                             : in    std_logic                     := 'X';
			--
			clk50_clk                                                   : in    std_logic                     := 'X';
			--
			tristate_conduit_tcm_address_out                            : out   std_logic_vector(25 downto 0);
			tristate_conduit_tcm_read_n_out                             : out   std_logic_vector(0 downto 0);
			tristate_conduit_tcm_write_n_out                            : out   std_logic_vector(0 downto 0);
			tristate_conduit_tcm_data_out                               : inout std_logic_vector(15 downto 0);
			tristate_conduit_tcm_chipselect_n_out                       : out   std_logic_vector(0 downto 0);
			--
			button_export                                               : in    std_logic_vector(3 downto 0);
			dip_export                                                  : in    std_logic_vector(7 downto 0);
			ext_export                                                  : in    std_logic;
			--
			led_de4_export                                              : out   std_logic_vector(7 downto 0);
			led_painel_export                                           : out   std_logic_vector(20 downto 0);
			--
			ssdp_ssdp1                                                  : out   std_logic_vector(7 downto 0);
			ssdp_ssdp0                                                  : out   std_logic_vector(7 downto 0);
			--
			ctrl_io_lvds_export                                         : out   std_logic_vector(3 downto 0);
			--
			m1_ddr2_i2c_scl_export                                      : out   std_logic;
			m1_ddr2_i2c_sda_export                                      : inout std_logic;
			--
			m2_ddr2_i2c_scl_export                                      : out   std_logic;
			m2_ddr2_i2c_sda_export                                      : inout std_logic;
			--
			spwc_a_lvds_spw_data_in_signal                              : in    std_logic                     := 'X'; -- spw_data_in_signal
			spwc_a_lvds_spw_strobe_in_signal                            : in    std_logic                     := 'X'; -- spw_strobe_in_signal
			spwc_a_lvds_spw_data_out_signal                             : out   std_logic; --                         -- spw_data_out_signal
			spwc_a_lvds_spw_strobe_out_signal                           : out   std_logic; --                         -- spw_strobe_out_signal
			--
			spwc_b_lvds_spw_data_in_signal                              : in    std_logic                     := 'X'; -- spw_data_in_signal
			spwc_b_lvds_spw_strobe_in_signal                            : in    std_logic                     := 'X'; -- spw_strobe_in_signal
			spwc_b_lvds_spw_data_out_signal                             : out   std_logic; --                         -- spw_data_out_signal
			spwc_b_lvds_spw_strobe_out_signal                           : out   std_logic; --                         -- spw_strobe_out_signal
			--
			spwc_c_lvds_spw_data_in_signal                              : in    std_logic                     := 'X'; -- spw_data_in_signal
			spwc_c_lvds_spw_strobe_in_signal                            : in    std_logic                     := 'X'; -- spw_strobe_in_signal
			spwc_c_lvds_spw_data_out_signal                             : out   std_logic; --                         -- spw_data_out_signal
			spwc_c_lvds_spw_strobe_out_signal                           : out   std_logic; --                         -- spw_strobe_out_signal
			--
			spwc_d_lvds_spw_data_in_signal                              : in    std_logic                     := 'X'; -- spw_data_in_signal
			spwc_d_lvds_spw_strobe_in_signal                            : in    std_logic                     := 'X'; -- spw_strobe_in_signal
			spwc_d_lvds_spw_data_out_signal                             : out   std_logic; --                         -- spw_data_out_signal
			spwc_d_lvds_spw_strobe_out_signal                           : out   std_logic; --                         -- spw_strobe_out_signal
			--
			spwc_e_lvds_spw_data_in_signal                              : in    std_logic                     := 'X'; -- spw_data_in_signal
			spwc_e_lvds_spw_strobe_in_signal                            : in    std_logic                     := 'X'; -- spw_strobe_in_signal
			spwc_e_lvds_spw_data_out_signal                             : out   std_logic; --                         -- spw_data_out_signal
			spwc_e_lvds_spw_strobe_out_signal                           : out   std_logic; --                         -- spw_strobe_out_signal
			--
			spwc_f_lvds_spw_data_in_signal                              : in    std_logic                     := 'X'; -- spw_data_in_signal
			spwc_f_lvds_spw_strobe_in_signal                            : in    std_logic                     := 'X'; -- spw_strobe_in_signal
			spwc_f_lvds_spw_data_out_signal                             : out   std_logic; --                         -- spw_data_out_signal
			spwc_f_lvds_spw_strobe_out_signal                           : out   std_logic; --                         -- spw_strobe_out_signal
			--
			spwc_g_lvds_spw_data_in_signal                              : in    std_logic                     := 'X'; -- spw_data_in_signal
			spwc_g_lvds_spw_strobe_in_signal                            : in    std_logic                     := 'X'; -- spw_strobe_in_signal
			spwc_g_lvds_spw_data_out_signal                             : out   std_logic; --                         -- spw_data_out_signal
			spwc_g_lvds_spw_strobe_out_signal                           : out   std_logic; --                         -- spw_strobe_out_signal
			--
			spwc_h_lvds_spw_data_in_signal                              : in    std_logic                     := 'X'; -- spw_data_in_signal
			spwc_h_lvds_spw_strobe_in_signal                            : in    std_logic                     := 'X'; -- spw_strobe_in_signal
			spwc_h_lvds_spw_data_out_signal                             : out   std_logic;                            -- spw_data_out_signal
			spwc_h_lvds_spw_strobe_out_signal                           : out   std_logic;                            -- spw_strobe_out_signal
			--
			comm_a_sync_end_sync_channel_signal                         : in    std_logic                     := 'X'; -- sync_channel_signal
			comm_b_sync_end_sync_channel_signal                         : in    std_logic                     := 'X'; -- sync_channel_signal
			comm_c_sync_end_sync_channel_signal                         : in    std_logic                     := 'X'; -- sync_channel_signal
			comm_d_sync_end_sync_channel_signal                         : in    std_logic                     := 'X'; -- sync_channel_signal
			comm_e_sync_end_sync_channel_signal                         : in    std_logic                     := 'X'; -- sync_channel_signal
			comm_f_sync_end_sync_channel_signal                         : in    std_logic                     := 'X'; -- sync_channel_signal
			--			comm_g_sync_end_sync_channel_signal                         : in    std_logic                     := 'X'; -- sync_channel_signal
			--			comm_h_sync_end_sync_channel_signal                         : in    std_logic                     := 'X'; -- sync_channel_signal
			--
			comm_a_measurements_conduit_end_measurements_channel_signal : out   std_logic_vector(7 downto 0); -- measurements_channel_signal
			comm_b_measurements_conduit_end_measurements_channel_signal : out   std_logic_vector(7 downto 0); -- measurements_channel_signal
			comm_c_measurements_conduit_end_measurements_channel_signal : out   std_logic_vector(7 downto 0); -- measurements_channel_signal
			comm_d_measurements_conduit_end_measurements_channel_signal : out   std_logic_vector(7 downto 0); -- measurements_channel_signal
			comm_e_measurements_conduit_end_measurements_channel_signal : out   std_logic_vector(7 downto 0); -- measurements_channel_signal
			comm_f_measurements_conduit_end_measurements_channel_signal : out   std_logic_vector(7 downto 0); -- measurements_channel_signal
			--
         spwc_a_leds_spw_red_status_led_signal                       : out   std_logic;                            -- spw_red_status_led_signal
         spwc_a_leds_spw_green_status_led_signal                     : out   std_logic;                            -- spw_green_status_led_signal
			--
         spwc_b_leds_spw_red_status_led_signal                       : out   std_logic;                            -- spw_red_status_led_signal
         spwc_b_leds_spw_green_status_led_signal                     : out   std_logic;                            -- spw_green_status_led_signal
			--
         spwc_c_leds_spw_red_status_led_signal                       : out   std_logic;                            -- spw_red_status_led_signal
         spwc_c_leds_spw_green_status_led_signal                     : out   std_logic;                            -- spw_green_status_led_signal
			--
         spwc_d_leds_spw_red_status_led_signal                       : out   std_logic;                            -- spw_red_status_led_signal
         spwc_d_leds_spw_green_status_led_signal                     : out   std_logic;                            -- spw_green_status_led_signal
			--
         spwc_e_leds_spw_red_status_led_signal                       : out   std_logic;                            -- spw_red_status_led_signal
         spwc_e_leds_spw_green_status_led_signal                     : out   std_logic;                            -- spw_green_status_led_signal
			--
         spwc_f_leds_spw_red_status_led_signal                       : out   std_logic;                            -- spw_red_status_led_signal
         spwc_f_leds_spw_green_status_led_signal                     : out   std_logic;                            -- spw_green_status_led_signal
			--
         spwc_g_leds_spw_red_status_led_signal                       : out   std_logic;                            -- spw_red_status_led_signal
         spwc_g_leds_spw_green_status_led_signal                     : out   std_logic;                            -- spw_green_status_led_signal
			--
         spwc_h_leds_spw_red_status_led_signal                       : out   std_logic;                            -- spw_red_status_led_signal
         spwc_h_leds_spw_green_status_led_signal                     : out   std_logic;                            -- spw_green_status_led_signal
			--
			temp_scl_export                                             : out   std_logic;
			temp_sda_export                                             : inout std_logic;
			--
			csense_adc_fo_export                                        : out   std_logic;
			csense_cs_n_export                                          : out   std_logic_vector(1 downto 0);
			csense_sck_export                                           : out   std_logic;
			csense_sdi_export                                           : out   std_logic;
			csense_sdo_export                                           : in    std_logic;
			--
			rtcc_alarm_export                                           : in    std_logic                     := 'X'; -- export
			rtcc_cs_n_export                                            : out   std_logic; -- export
			rtcc_sck_export                                             : out   std_logic; -- export
			rtcc_sdi_export                                             : out   std_logic; -- export
			rtcc_sdo_export                                             : in    std_logic                     := 'X'; -- export
			--
			sync_in_conduit                                             : in    std_logic                     := 'X'; -- conduit
			sync_out_conduit                                            : out   std_logic; -- conduit
			sync_spw1_conduit                                           : out   std_logic; -- conduit
			sync_spw2_conduit                                           : out   std_logic; -- conduit
			sync_spw3_conduit                                           : out   std_logic; -- conduit
			sync_spw4_conduit                                           : out   std_logic; -- conduit
			sync_spw5_conduit                                           : out   std_logic; -- conduit
			sync_spw6_conduit                                           : out   std_logic; -- conduit
			sync_spw7_conduit                                           : out   std_logic; -- conduit
			sync_spw8_conduit                                           : out   std_logic; -- conduit
			--
			sd_card_wp_n_io_export                                      : in    std_logic                     := 'X'; -- export
			sd_card_ip_b_SD_cmd                                         : inout std_logic                     := 'X'; -- b_SD_cmd
			sd_card_ip_b_SD_dat                                         : inout std_logic                     := 'X'; -- b_SD_dat
			sd_card_ip_b_SD_dat3                                        : inout std_logic                     := 'X'; -- b_SD_dat3
			sd_card_ip_o_SD_clock                                       : out   std_logic; --                         -- o_SD_clock
			--
			rs232_uart_rxd                                              : in    std_logic                     := 'X'; -- rxd
			rs232_uart_txd                                              : out   std_logic; --                         -- txd
			--
			ftdi_clk_clk                                                : in    std_logic                     := 'X'; --          -- clk
			--
			umft601a_pins_umft_data_signal                              : inout std_logic_vector(31 downto 0) := (others => 'X'); -- umft_data_signal
			umft601a_pins_umft_reset_n_signal                           : out   std_logic; --                                     -- umft_reset_n_signal
			umft601a_pins_umft_rxf_n_signal                             : in    std_logic                     := 'X'; --          -- umft_rxf_n_signal
			umft601a_pins_umft_clock_signal                             : in    std_logic                     := 'X'; --          -- umft_clock_signal
			umft601a_pins_umft_wakeup_n_signal                          : inout std_logic                     := 'X'; --          -- umft_wakeup_n_signal
			umft601a_pins_umft_be_signal                                : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- umft_be_signal
			umft601a_pins_umft_txe_n_signal                             : in    std_logic                     := 'X'; --          -- umft_txe_n_signal
			umft601a_pins_umft_gpio_bus_signal                          : inout std_logic_vector(1 downto 0)  := (others => 'X'); -- umft_gpio_bus_signal
			umft601a_pins_umft_wr_n_signal                              : out   std_logic; --                                     -- umft_wr_n_signal
			umft601a_pins_umft_rd_n_signal                              : out   std_logic; --                                     -- umft_rd_n_signal
			umft601a_pins_umft_oe_n_signal                              : out   std_logic; --                                     -- umft_oe_n_signal
			umft601a_pins_umft_siwu_n_signal                            : out   std_logic --                                      -- umft_siwu_n_signal
		);
	end component MebX_Qsys_Project;

	component pll_125
		port(
			inclk0 : in  std_logic := '0';
			c0     : out std_logic
		);
	end component;

	------------------------------------------------------------
begin

	--==========--
	-- Clk
	--==========--
	--PLL_inst_125 : pll_125 port map (
	--		inclk0 => OSC_50_BANK2,
	--		c0     => enet_refclk_125MHz
	--	);

	--==========--
	-- AVALON
	--==========--
	SOPC_INST : MebX_Qsys_Project
		port map(
			clk50_clk                                                   => OSC_50_Bank4,
			--
			rst_reset_n                                                 => rst_n,
			--
			rst_controller_conduit_reset_input_t_reset_input_signal     => rst_ctrl_input, --              --   rst_controller_conduit_reset_input.t_reset_input_signal
			rst_controller_conduit_simucam_reset_t_simucam_reset_signal => simucam_rst, --                 -- rst_controller_conduit_simucam_reset.t_simucam_reset_signal
			--
			led_de4_export                                              => leds_b,
			led_painel_export                                           => leds_p,
			--
			ssdp_ssdp1                                                  => SEVEN_SEG_HEX1,
			ssdp_ssdp0                                                  => SEVEN_SEG_HEX0,
			--
			dip_export                                                  => SW,
			button_export                                               => Button,
			ext_export                                                  => EXT_IO,
			--
			ctrl_io_lvds_export                                         => ctrl_io_lvds,
			--
			tristate_conduit_tcm_address_out                            => FSM_A(25 downto 0),
			tristate_conduit_tcm_data_out                               => FSM_D,
			tristate_conduit_tcm_chipselect_n_out                       => FLASH_CE_n,
			tristate_conduit_tcm_read_n_out                             => FLASH_OE_n,
			tristate_conduit_tcm_write_n_out                            => FLASH_WE_n,
			--
			m1_ddr2_memory_pll_ref_clk_clk                              => OSC_50_Bank3,
			m1_ddr2_memory_mem_a                                        => M1_DDR2_addr,
			m1_ddr2_memory_mem_ba                                       => M1_DDR2_ba,
			m1_ddr2_memory_mem_ck                                       => M1_DDR2_clk,
			m1_ddr2_memory_mem_ck_n                                     => M1_DDR2_clk_n,
			m1_ddr2_memory_mem_cke                                      => M1_DDR2_cke,
			m1_ddr2_memory_mem_cs_n                                     => M1_DDR2_cs_n,
			m1_ddr2_memory_mem_dm                                       => M1_DDR2_dm,
			m1_ddr2_memory_mem_ras_n                                    => M1_DDR2_ras_n,
			m1_ddr2_memory_mem_cas_n                                    => M1_DDR2_cas_n,
			m1_ddr2_memory_mem_we_n                                     => M1_DDR2_we_n,
			m1_ddr2_memory_mem_dq                                       => M1_DDR2_dq,
			m1_ddr2_memory_mem_dqs                                      => M1_DDR2_dqs,
			m1_ddr2_memory_mem_dqs_n                                    => M1_DDR2_dqsn,
			m1_ddr2_memory_mem_odt                                      => M1_DDR2_odt,
			m1_ddr2_oct_rdn                                             => M1_DDR2_oct_rdn,
			m1_ddr2_oct_rup                                             => M1_DDR2_oct_rup,
			--
			m1_ddr2_i2c_scl_export                                      => M1_DDR2_SCL,
			m1_ddr2_i2c_sda_export                                      => M1_DDR2_SDA,
			--
			m2_ddr2_memory_mem_a                                        => M2_DDR2_addr,
			m2_ddr2_memory_mem_ba                                       => M2_DDR2_ba,
			m2_ddr2_memory_mem_ck                                       => M2_DDR2_clk,
			m2_ddr2_memory_mem_ck_n                                     => M2_DDR2_clk_n,
			m2_ddr2_memory_mem_cke                                      => M2_DDR2_cke,
			m2_ddr2_memory_mem_cs_n                                     => M2_DDR2_cs_n,
			m2_ddr2_memory_mem_dm                                       => M2_DDR2_dm,
			m2_ddr2_memory_mem_ras_n                                    => M2_DDR2_ras_n,
			m2_ddr2_memory_mem_cas_n                                    => M2_DDR2_cas_n,
			m2_ddr2_memory_mem_we_n                                     => M2_DDR2_we_n,
			m2_ddr2_memory_mem_dq                                       => M2_DDR2_dq,
			m2_ddr2_memory_mem_dqs                                      => M2_DDR2_dqs,
			m2_ddr2_memory_mem_dqs_n                                    => M2_DDR2_dqsn,
			m2_ddr2_memory_mem_odt                                      => M2_DDR2_odt,
			m2_ddr2_oct_rdn                                             => M2_DDR2_oct_rdn,
			m2_ddr2_oct_rup                                             => M2_DDR2_oct_rup,
			--
			m2_ddr2_i2c_scl_export                                      => M2_DDR2_SCL,
			m2_ddr2_i2c_sda_export                                      => M2_DDR2_SDA,
			--
			spwc_a_lvds_spw_data_in_signal                              => spw_a_di(0),         --                           spwc_a_lvds.spw_data_in_signal
			spwc_a_lvds_spw_strobe_in_signal                            => spw_a_si(0),         --                                      .spw_strobe_in_signal
			spwc_a_lvds_spw_data_out_signal                             => spw_a_do(0),         --                                      .spw_data_out_signal
			spwc_a_lvds_spw_strobe_out_signal                           => spw_a_so(0),         --                                      .spw_strobe_out_signal
			--
			spwc_b_lvds_spw_data_in_signal                              => spw_b_di(0),         --                           spwc_b_lvds.spw_data_in_signal
			spwc_b_lvds_spw_strobe_in_signal                            => spw_b_si(0),         --                                      .spw_strobe_in_signal
			spwc_b_lvds_spw_data_out_signal                             => spw_b_do(0),         --                                      .spw_data_out_signal
			spwc_b_lvds_spw_strobe_out_signal                           => spw_b_so(0),         --                                      .spw_strobe_out_signal
			--
			spwc_c_lvds_spw_data_in_signal                              => spw_c_di(0),         --                           spwc_c_lvds.spw_data_in_signal
			spwc_c_lvds_spw_strobe_in_signal                            => spw_c_si(0),         --                                      .spw_strobe_in_signal
			spwc_c_lvds_spw_data_out_signal                             => spw_c_do(0),         --                                      .spw_data_out_signal
			spwc_c_lvds_spw_strobe_out_signal                           => spw_c_so(0),         --                                      .spw_strobe_out_signal
			--
			spwc_d_lvds_spw_data_in_signal                              => spw_d_di(0),         --                           spwc_d_lvds.spw_data_in_signal
			spwc_d_lvds_spw_strobe_in_signal                            => spw_d_si(0),         --                                      .spw_strobe_in_signal
			spwc_d_lvds_spw_data_out_signal                             => spw_d_do(0),         --                                      .spw_data_out_signal
			spwc_d_lvds_spw_strobe_out_signal                           => spw_d_so(0),         --                                      .spw_strobe_out_signal
			--
			spwc_e_lvds_spw_data_in_signal                              => spw_e_di(0),         --                           spwc_e_lvds.spw_data_in_signal
			spwc_e_lvds_spw_strobe_in_signal                            => spw_e_si(0),         --                                      .spw_strobe_in_signal
			spwc_e_lvds_spw_data_out_signal                             => spw_e_do(0),         --                                      .spw_data_out_signal
			spwc_e_lvds_spw_strobe_out_signal                           => spw_e_so(0),         --                                      .spw_strobe_out_signal
			--
			spwc_f_lvds_spw_data_in_signal                              => spw_f_di(0),         --                           spwc_f_lvds.spw_data_in_signal
			spwc_f_lvds_spw_strobe_in_signal                            => spw_f_si(0),         --                                      .spw_strobe_in_signal
			spwc_f_lvds_spw_data_out_signal                             => spw_f_do(0),         --                                      .spw_data_out_signal
			spwc_f_lvds_spw_strobe_out_signal                           => spw_f_so(0),         --                                      .spw_strobe_out_signal
			--
			spwc_g_lvds_spw_data_in_signal                              => spw_g_di(0),         --                           spwc_g_lvds.spw_data_in_signal
			spwc_g_lvds_spw_strobe_in_signal                            => spw_g_si(0),         --                                      .spw_strobe_in_signal
			spwc_g_lvds_spw_data_out_signal                             => spw_g_do(0),         --                                      .spw_data_out_signal
			spwc_g_lvds_spw_strobe_out_signal                           => spw_g_so(0),         --                                      .spw_strobe_out_signal
			--
         spwc_h_lvds_spw_data_in_signal                              => spw_h_di(0),         --                           spwc_h_lvds.spw_data_in_signal
         spwc_h_lvds_spw_strobe_in_signal                            => spw_h_si(0),         --                                      .spw_strobe_in_signal
         spwc_h_lvds_spw_data_out_signal                             => spw_h_do(0),         --                                      .spw_data_out_signal
         spwc_h_lvds_spw_strobe_out_signal                           => spw_h_so(0),         --                                      .spw_strobe_out_signal
			--
			comm_a_sync_end_sync_channel_signal                         => spw_1_sync, --       --                       comm_a_sync_end.sync_channel_signal
			comm_b_sync_end_sync_channel_signal                         => spw_2_sync, --       --                       comm_b_sync_end.sync_channel_signal
			comm_c_sync_end_sync_channel_signal                         => spw_3_sync, --       --                       comm_c_sync_end.sync_channel_signal
			comm_d_sync_end_sync_channel_signal                         => spw_4_sync, --       --                       comm_d_sync_end.sync_channel_signal
			comm_e_sync_end_sync_channel_signal                         => spw_5_sync, --       --                       comm_e_sync_end.sync_channel_signal
			comm_f_sync_end_sync_channel_signal                         => spw_6_sync, --       --                       comm_f_sync_end.sync_channel_signal
			--			comm_g_sync_end_sync_channel_signal                         => spw_7_sync, --       --                       comm_g_sync_end.sync_channel_signal
			--			comm_h_sync_end_sync_channel_signal                         => spw_8_sync, --       --                       comm_h_sync_end.sync_channel_signal
			--
			comm_a_measurements_conduit_end_measurements_channel_signal => spw_a_measure, --    -- comm_a_measurements_conduit_end.measurements_channel_signal
			comm_b_measurements_conduit_end_measurements_channel_signal => spw_b_measure, --    -- comm_b_measurements_conduit_end.measurements_channel_signal
			comm_c_measurements_conduit_end_measurements_channel_signal => spw_c_measure, --    -- comm_c_measurements_conduit_end.measurements_channel_signal
			comm_d_measurements_conduit_end_measurements_channel_signal => spw_d_measure, --    -- comm_d_measurements_conduit_end.measurements_channel_signal
			comm_e_measurements_conduit_end_measurements_channel_signal => spw_e_measure, --    -- comm_e_measurements_conduit_end.measurements_channel_signal
			comm_f_measurements_conduit_end_measurements_channel_signal => spw_f_measure, --    -- comm_f_measurements_conduit_end.measurements_channel_signal
			--
         spwc_a_leds_spw_red_status_led_signal                       => spw_a_red_led,       --                           spwc_a_leds.spw_red_status_led_signal
         spwc_a_leds_spw_green_status_led_signal                     => spw_a_green_led,     --                                      .spw_green_status_led_signal
			--
         spwc_b_leds_spw_red_status_led_signal                       => spw_b_red_led,       --                           spwc_b_leds.spw_red_status_led_signal
         spwc_b_leds_spw_green_status_led_signal                     => spw_b_green_led,     --                                      .spw_green_status_led_signal
			--
         spwc_c_leds_spw_red_status_led_signal                       => spw_c_red_led,       --                           spwc_c_leds.spw_red_status_led_signal
         spwc_c_leds_spw_green_status_led_signal                     => spw_c_green_led,     --                                      .spw_green_status_led_signal
			--
         spwc_d_leds_spw_red_status_led_signal                       => spw_d_red_led,       --                           spwc_d_leds.spw_red_status_led_signal
         spwc_d_leds_spw_green_status_led_signal                     => spw_d_green_led,     --                                      .spw_green_status_led_signal
			--
         spwc_e_leds_spw_red_status_led_signal                       => spw_e_red_led,       --                           spwc_e_leds.spw_red_status_led_signal
         spwc_e_leds_spw_green_status_led_signal                     => spw_e_green_led,     --                                      .spw_green_status_led_signal
			--
         spwc_f_leds_spw_red_status_led_signal                       => spw_f_red_led,       --                           spwc_f_leds.spw_red_status_led_signal
         spwc_f_leds_spw_green_status_led_signal                     => spw_f_green_led,     --                                      .spw_green_status_led_signal
			--
         spwc_g_leds_spw_red_status_led_signal                       => spw_g_red_led,       --                           spwc_g_leds.spw_red_status_led_signal
         spwc_g_leds_spw_green_status_led_signal                     => spw_g_green_led,     --                                      .spw_green_status_led_signal
			--
         spwc_h_leds_spw_red_status_led_signal                       => spw_h_red_led,       --                           spwc_h_leds.spw_red_status_led_signal
         spwc_h_leds_spw_green_status_led_signal                     => spw_h_green_led,     --                                      .spw_green_status_led_signal
			--
			temp_scl_export                                             => TEMP_SMCLK,
			temp_sda_export                                             => TEMP_SMDAT,
			--
			csense_adc_fo_export                                        => csense_adc_fo,
			csense_cs_n_export                                          => csense_cs_n,
			csense_sck_export                                           => csense_sck,
			csense_sdi_export                                           => csense_sdi,
			csense_sdo_export                                           => csense_sdo,
			--
			rtcc_alarm_export                                           => RTCC_ALARM,
			rtcc_cs_n_export                                            => RTCC_CS_n,
			rtcc_sck_export                                             => RTCC_SCK,
			rtcc_sdi_export                                             => RTCC_SDI,
			rtcc_sdo_export                                             => RTCC_SDO,
			--
			sync_in_conduit                                             => s_sync_in, --        --                               sync_in.conduit
			sync_out_conduit                                            => s_sync_out, --       --                              sync_out.conduit
			sync_spw1_conduit                                           => spw_1_sync, --       --                             sync_spw1.conduit
			sync_spw2_conduit                                           => spw_2_sync, --       --                             sync_spw2.conduit
			sync_spw3_conduit                                           => spw_3_sync, --       --                             sync_spw3.conduit
			sync_spw4_conduit                                           => spw_4_sync, --       --                             sync_spw4.conduit
			sync_spw5_conduit                                           => spw_5_sync, --       --                             sync_spw5.conduit
			sync_spw6_conduit                                           => spw_6_sync, --       --                             sync_spw6.conduit
			sync_spw7_conduit                                           => spw_7_sync, --       --                             sync_spw7.conduit
			sync_spw8_conduit                                           => spw_8_sync, --       --                             sync_spw8.conduit
			--
			sd_card_wp_n_io_export                                      => I_SD_CARD_WP_n, --   --                       sd_card_wp_n_io.export
			sd_card_ip_b_SD_cmd                                         => B_SD_CARD_CMD, --    --                            sd_card_ip.b_SD_cmd
			sd_card_ip_b_SD_dat                                         => B_SD_CARD_DAT, --    --                                      .b_SD_dat
			sd_card_ip_b_SD_dat3                                        => B_SD_CARD_DAT3, --   --                                      .b_SD_dat3
			sd_card_ip_o_SD_clock                                       => O_SD_CARD_CLOCK, --  --                                      .o_SD_clock
			--
			rs232_uart_rxd                                              => I_RS232_UART_RXD, -- --                            rs232_uart.rxd
			rs232_uart_txd                                              => O_RS232_UART_TXD, -- --                                      .txd
			--
			ftdi_clk_clk                                                => FTDI_CLOCK, --       --                              ftdi_clk.clk
			--
			umft601a_pins_umft_data_signal                              => FTDI_DATA, --        --                         umft601a_pins.umft_data_signal
			umft601a_pins_umft_reset_n_signal                           => open, --             --                                      .umft_reset_n_signal
			umft601a_pins_umft_rxf_n_signal                             => FTDI_RXF_N, --       --                                      .umft_rxf_n_signal
			umft601a_pins_umft_clock_signal                             => '0', --              --                                      .umft_clock_signal
			umft601a_pins_umft_wakeup_n_signal                          => FTDI_WAKEUP_N, --    --                                      .umft_wakeup_n_signal
			umft601a_pins_umft_be_signal                                => FTDI_BE, --          --                                      .umft_be_signal
			umft601a_pins_umft_txe_n_signal                             => FTDI_TXE_N, --       --                                      .umft_txe_n_signal
			umft601a_pins_umft_gpio_bus_signal                          => FTDI_GPIO, --        --                                      .umft_gpio_bus_signal
			umft601a_pins_umft_wr_n_signal                              => FTDI_WR_N, --        --                                      .umft_wr_n_signal
			umft601a_pins_umft_rd_n_signal                              => FTDI_RD_N, --        --                                      .umft_rd_n_signal
			umft601a_pins_umft_oe_n_signal                              => FTDI_OE_N, --        --                                      .umft_oe_n_signal
			umft601a_pins_umft_siwu_n_signal                            => FTDI_SIWU_N --       --                                      .umft_siwu_n_signal
		);

	--==========--
	-- rst
	--==========--

	rst_ctrl_input <= not (CPU_RESET_n and RESET_PAINEL_n);
	rst_n          <= not (simucam_rst);
	FTDI_RESET_N   <= rst_n;

	--==========--
	-- I/Os
	--==========--    
	-- Routing sync i/o´s - test
	SYNC_OUT  <= s_sync_out;
	-- Observe that SYNC_IN is at high level state when there is no excitation input
	-- For test purposes, don´t use isolator board.
	s_sync_in <= SYNC_IN;

	-- Ativa ventoinha
	FAN_CTRL <= '1';

	-- LEDs assumem estado diferente no rst.

	LED_DE4(0) <= ('1') when (rst_n = '0') else (leds_b(0));
	LED_DE4(1) <= ('1') when (rst_n = '0') else (leds_b(1));
	LED_DE4(2) <= ('1') when (rst_n = '0') else (leds_b(2));
	LED_DE4(3) <= ('1') when (rst_n = '0') else (leds_b(3));
	LED_DE4(4) <= ('1') when (rst_n = '0') else (leds_b(4));
	LED_DE4(5) <= ('1') when (rst_n = '0') else (leds_b(5));
	LED_DE4(6) <= ('1') when (rst_n = '0') else (leds_b(6));
	LED_DE4(7) <= ('1') when (rst_n = '0') else (leds_b(7));

	LED_PAINEL_LED_1G    <= ('1') when (rst_n = '0') else (leds_p(0) or spw_a_green_led);
	LED_PAINEL_LED_1R    <= ('1') when (rst_n = '0') else (leds_p(1) or spw_a_red_led);
	LED_PAINEL_LED_2G    <= ('1') when (rst_n = '0') else (leds_p(2) or spw_b_green_led);
	LED_PAINEL_LED_2R    <= ('1') when (rst_n = '0') else (leds_p(3) or spw_b_red_led);
	LED_PAINEL_LED_3G    <= ('1') when (rst_n = '0') else (leds_p(4) or spw_c_green_led);
	LED_PAINEL_LED_3R    <= ('1') when (rst_n = '0') else (leds_p(5) or spw_c_red_led);
	LED_PAINEL_LED_4G    <= ('1') when (rst_n = '0') else (leds_p(6) or spw_d_green_led);
	LED_PAINEL_LED_4R    <= ('1') when (rst_n = '0') else (leds_p(7) or spw_d_red_led);
	LED_PAINEL_LED_5G    <= ('1') when (rst_n = '0') else (leds_p(8) or spw_e_green_led);
	LED_PAINEL_LED_5R    <= ('1') when (rst_n = '0') else (leds_p(9) or spw_e_red_led);
	LED_PAINEL_LED_6G    <= ('1') when (rst_n = '0') else (leds_p(10) or spw_f_green_led);
	LED_PAINEL_LED_6R    <= ('1') when (rst_n = '0') else (leds_p(11) or spw_f_red_led);
	LED_PAINEL_LED_7G    <= ('1') when (rst_n = '0') else (leds_p(12) or spw_g_green_led);
	LED_PAINEL_LED_7R    <= ('1') when (rst_n = '0') else (leds_p(13) or spw_g_red_led);
	LED_PAINEL_LED_8G    <= ('1') when (rst_n = '0') else (leds_p(14) or spw_h_green_led);
	LED_PAINEL_LED_8R    <= ('1') when (rst_n = '0') else (leds_p(15) or spw_h_red_led);
	LED_PAINEL_LED_POWER <= ('1') when (rst_n = '0') else (leds_p(16));
	LED_PAINEL_LED_ST1   <= ('1') when (rst_n = '0') else (leds_p(17));
	LED_PAINEL_LED_ST2   <= ('1') when (rst_n = '0') else (leds_p(18));
	LED_PAINEL_LED_ST3   <= ('1') when (rst_n = '0') else (leds_p(19));
	LED_PAINEL_LED_ST4   <= ('1') when (rst_n = '0') else (leds_p(20));

	-- SpW Channel Measurements
	JP3_GPIO0_D22_IO <= spw_a_measure(4); -- measurement 4 : right fee busy signal
	JP3_GPIO0_D23_IO <= spw_b_measure(4); -- measurement 4 : right fee busy signal
	JP3_GPIO0_D18_IO <= spw_c_measure(4); -- measurement 4 : right fee busy signal
	JP3_GPIO0_D19_IO <= spw_d_measure(4); -- measurement 4 : right fee busy signal
	JP3_GPIO0_D14_IO <= spw_e_measure(4); -- measurement 4 : right fee busy signal
	JP3_GPIO0_D15_IO <= spw_f_measure(4); -- measurement 4 : right fee busy signal
	
	JP3_GPIO0_D24_IO <= spw_a_measure(5); -- measurement 5 : left fee busy signal
	JP3_GPIO0_D25_IO <= spw_b_measure(5); -- measurement 5 : left fee busy signal
	JP3_GPIO0_D20_IO <= spw_c_measure(5); -- measurement 5 : left fee busy signal
	JP3_GPIO0_D21_IO <= spw_d_measure(5); -- measurement 5 : left fee busy signal
	JP3_GPIO0_D16_IO <= spw_e_measure(5); -- measurement 5 : left fee busy signal
	JP3_GPIO0_D17_IO <= spw_f_measure(5); -- measurement 5 : left fee busy signal
	
	JP3_GPIO0_D34_IO <= spw_a_measure(6); -- measurement 6 : fee busy signal
	JP3_GPIO0_D35_IO <= spw_b_measure(6); -- measurement 6 : fee busy signal
	JP3_GPIO0_D32_IO <= spw_c_measure(6); -- measurement 6 : fee busy signal
	JP3_GPIO0_D33_IO <= spw_d_measure(6); -- measurement 6 : fee busy signal
	JP3_GPIO0_D30_IO <= spw_e_measure(6); -- measurement 6 : fee busy signal
	JP3_GPIO0_D31_IO <= spw_f_measure(6); -- measurement 6 : fee busy signal
	
	-- Sync Debug
	JP3_GPIO0_D10_IO <= s_sync_in;
	JP3_GPIO0_D11_IO <= s_sync_out;
	
	--==========--
	-- eth
	--==========--

	--ETH_RST_n <= (rst) and (rst_eth);

	-- ETH0
	-- lvds_rxp     <= ETH_RX_p(0);
	-- ETH_TX_p(0)  <= lvds_txp;
	-- enet_mdio_in <= ETH_MDIO(0);
	-- ETH_MDIO(0)  <= (enet_mdio_out) when (enet_mdio_oen = '0') else ('Z');
	-- ETH_MDC(0)   <= enet_mdc;

	-- ETH1
	-- lvds_rxp     <= ETH_RX_p(1);
	-- ETH_TX_p(1)  <= lvds_txp;
	-- enet_mdio_in <= ETH_MDIO(1);
	-- ETH_MDIO(1)  <= (enet_mdio_out) when (enet_mdio_oen = '0') else ('Z');
	-- ETH_MDC(1)   <= enet_mdc;

	-- ETH2
	-- lvds_rxp     <= ETH_RX_p(2);
	-- ETH_TX_p(2)  <= lvds_txp;
	-- enet_mdio_in <= ETH_MDIO(2);
	-- ETH_MDIO(2)  <= (enet_mdio_out) when (enet_mdio_oen = '0') else ('Z');
	-- ETH_MDC(2)   <= enet_mdc;

	-- ETH3
	--lvds_rxp     <= ETH_RX_p(3);
	--ETH_TX_p(3)  <= lvds_txp;
	--enet_mdio_in <= ETH_MDIO(3);
	--ETH_MDIO(3)  <= (enet_mdio_out) when (enet_mdio_oen = '0') else ('Z');
	--ETH_MDC(3)   <= enet_mdc;

	--==========--
	-- Flash
	--==========--

	FLASH_RESET_n <= rst_n;
	FLASH_CLK     <= '0';
	FLASH_ADV_n   <= '0';

	--==========--
	-- LVDS Drivers control
	--==========--

	-- Comando foi passado para modulo ctrl_io_lvds, via Qsys/Nios
	--	HSMB_BUFFER_PWDN_N	<= '1';
	--	HSMB_BUFFER_PEM0	<= '0';
	--	HSMB_BUFFER_PEM1	<= '0';
	--	EN_ISO_DRIVERS		<= '0';

	EN_ISO_DRIVERS     <= ctrl_io_lvds(3);
	HSMB_BUFFER_PWDN_N <= ctrl_io_lvds(2);
	HSMB_BUFFER_PEM1   <= ctrl_io_lvds(1);
	HSMB_BUFFER_PEM0   <= ctrl_io_lvds(0);

	--==========--
	-- LVDS
	--==========--

	--SpW A
	TX_DO_A : TX_LVDS
		port map(
			tx_in  => spw_a_do(0 downto 0),
			tx_out => HSMB_LVDS_TX_SPWA_DO_P(0 downto 0)
		);
	TX_DI_A : RX_LVDS
		port map(
			rx_out => spw_a_di(0 downto 0),
			rx_in  => HSMB_LVDS_RX_SPWA_DI_P(0 downto 0)
		);
	TX_SO_A : TX_LVDS
		port map(
			tx_in  => spw_a_so(0 downto 0),
			tx_out => HSMB_LVDS_TX_SPWA_SO_P(0 downto 0)
		);
	TX_SI_A : RX_LVDS
		port map(
			rx_out => spw_a_si(0 downto 0),
			rx_in  => HSMB_LVDS_RX_SPWA_SI_P(0 downto 0)
		);

	--SpW B
	TX_DO_B : TX_LVDS
		port map(
			tx_in  => spw_b_do(0 downto 0),
			tx_out => HSMB_LVDS_TX_SPWB_DO_P(0 downto 0)
		);
	TX_DI_B : RX_LVDS
		port map(
			rx_out => spw_b_di(0 downto 0),
			rx_in  => HSMB_LVDS_RX_SPWB_DI_P(0 downto 0)
		);
	TX_SO_B : TX_LVDS
		port map(
			tx_in  => spw_b_so(0 downto 0),
			tx_out => HSMB_LVDS_TX_SPWB_SO_P(0 downto 0)
		);
	TX_SI_B : RX_LVDS
		port map(
			rx_out => spw_b_si(0 downto 0),
			rx_in  => HSMB_LVDS_RX_SPWB_SI_P(0 downto 0)
		);

	--SpW C
	TX_DO_C : TX_LVDS
		port map(
			tx_in  => spw_c_do(0 downto 0),
			tx_out => HSMB_LVDS_TX_SPWC_DO_P(0 downto 0)
		);
	TX_DI_C : RX_LVDS
		port map(
			rx_out => spw_c_di(0 downto 0),
			rx_in  => HSMB_LVDS_RX_SPWC_DI_P(0 downto 0)
		);
	TX_SO_C : TX_LVDS
		port map(
			tx_in  => spw_c_so(0 downto 0),
			tx_out => HSMB_LVDS_TX_SPWC_SO_P(0 downto 0)
		);
	TX_SI_C : RX_LVDS
		port map(
			rx_out => spw_c_si(0 downto 0),
			rx_in  => HSMB_LVDS_RX_SPWC_SI_P(0 downto 0)
		);

	--SpW D
	TX_DO_D : TX_LVDS
		port map(
			tx_in  => spw_d_do(0 downto 0),
			tx_out => HSMB_LVDS_TX_SPWD_DO_P(0 downto 0)
		);
	TX_DI_D : RX_LVDS
		port map(
			rx_out => spw_d_di(0 downto 0),
			rx_in  => HSMB_LVDS_RX_SPWD_DI_P(0 downto 0)
		);
	TX_SO_D : TX_LVDS
		port map(
			tx_in  => spw_d_so(0 downto 0),
			tx_out => HSMB_LVDS_TX_SPWD_SO_P(0 downto 0)
		);
	TX_SI_D : RX_LVDS
		port map(
			rx_out => spw_d_si(0 downto 0),
			rx_in  => HSMB_LVDS_RX_SPWD_SI_P(0 downto 0)
		);

	--SpW E
	TX_DO_E : TX_LVDS
		port map(
			tx_in  => spw_e_do(0 downto 0),
			tx_out => HSMB_LVDS_TX_SPWE_DO_P(0 downto 0)
		);
	TX_DI_E : RX_LVDS
		port map(
			rx_out => spw_e_di(0 downto 0),
			rx_in  => HSMB_LVDS_RX_SPWE_DI_P(0 downto 0)
		);
	TX_SO_E : TX_LVDS
		port map(
			tx_in  => spw_e_so(0 downto 0),
			tx_out => HSMB_LVDS_TX_SPWE_SO_P(0 downto 0)
		);
	TX_SI_E : RX_LVDS
		port map(
			rx_out => spw_e_si(0 downto 0),
			rx_in  => HSMB_LVDS_RX_SPWE_SI_P(0 downto 0)
		);

	--SpW F
	TX_DO_F : TX_LVDS
		port map(
			tx_in  => spw_f_do(0 downto 0),
			tx_out => HSMB_LVDS_TX_SPWF_DO_P(0 downto 0)
		);
	TX_DI_F : RX_LVDS
		port map(
			rx_out => spw_f_di(0 downto 0),
			rx_in  => HSMB_LVDS_RX_SPWF_DI_P(0 downto 0)
		);
	TX_SO_F : TX_LVDS
		port map(
			tx_in  => spw_f_so(0 downto 0),
			tx_out => HSMB_LVDS_TX_SPWF_SO_P(0 downto 0)
		);
	TX_SI_F : RX_LVDS
		port map(
			rx_out => spw_f_si(0 downto 0),
			rx_in  => HSMB_LVDS_RX_SPWF_SI_P(0 downto 0)
		);

	--SpW G
	TX_DO_G : TX_LVDS
		port map(
			tx_in  => spw_g_do(0 downto 0),
			tx_out => HSMB_LVDS_TX_SPWG_DO_P(0 downto 0)
		);
	TX_DI_G : RX_LVDS
		port map(
			rx_out => spw_g_di(0 downto 0),
			rx_in  => HSMB_LVDS_RX_SPWG_DI_P(0 downto 0)
		);
	TX_SO_G : TX_LVDS
		port map(
			tx_in  => spw_g_so(0 downto 0),
			tx_out => HSMB_LVDS_TX_SPWG_SO_P(0 downto 0)
		);
	TX_SI_G : RX_LVDS
		port map(
			rx_out => spw_g_si(0 downto 0),
			rx_in  => HSMB_LVDS_RX_SPWG_SI_P(0 downto 0)
		);

	--SpW H
	TX_DO_H : TX_LVDS
		port map(
			tx_in  => spw_h_do(0 downto 0),
			tx_out => HSMB_LVDS_TX_SPWH_DO_P(0 downto 0)
		);
	TX_DI_H : RX_LVDS
		port map(
			rx_out => spw_h_di(0 downto 0),
			rx_in  => HSMB_LVDS_RX_SPWH_DI_P(0 downto 0)
		);
	TX_SO_H : TX_LVDS
		port map(
			tx_in  => spw_h_so(0 downto 0),
			tx_out => HSMB_LVDS_TX_SPWH_SO_P(0 downto 0)
		);
	TX_SI_H : RX_LVDS
		port map(
			rx_out => spw_h_si(0 downto 0),
			rx_in  => HSMB_LVDS_RX_SPWH_SI_P(0 downto 0)
		);

end bhv;
