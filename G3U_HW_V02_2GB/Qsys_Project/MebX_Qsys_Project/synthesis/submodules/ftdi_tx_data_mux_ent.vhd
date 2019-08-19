library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ftdi_tx_data_mux_ent is
	port(
		-- mux control 
		mux_scr_select_i               : in  std_logic_vector(1 downto 0);
		-- ftdi tx dc data fifo mux input pins (fpga --> umft601a)
		mux_ftdi_tx_data_wrempty_i     : in  std_logic;
		mux_ftdi_tx_data_wrfull_i      : in  std_logic;
		mux_ftdi_tx_data_wrusedw_i     : in  std_logic_vector(11 downto 0);
		-- source 0 tx dc data fifo mux input pins (fpga --> umft601a)
		mux_scr0_tx_data_wrdata_data_i : in  std_logic_vector(31 downto 0);
		mux_scr0_tx_data_wrdata_be_i   : in  std_logic_vector(3 downto 0);
		mux_scr0_tx_data_wrreq_i       : in  std_logic;
		-- source 1 tx dc data fifo mux input pins (fpga --> umft601a)
		mux_scr1_tx_data_wrdata_data_i : in  std_logic_vector(31 downto 0);
		mux_scr1_tx_data_wrdata_be_i   : in  std_logic_vector(3 downto 0);
		mux_scr1_tx_data_wrreq_i       : in  std_logic;
		-- ftdi tx dc data fifo mux output pins (fpga --> umft601a)
		mux_ftdi_tx_data_wrdata_data_o : out std_logic_vector(31 downto 0);
		mux_ftdi_tx_data_wrdata_be_o   : out std_logic_vector(3 downto 0);
		mux_ftdi_tx_data_wrreq_o       : out std_logic;
		-- source 0 tx dc data fifo mux output pins (fpga --> umft601a)
		mux_scr0_tx_data_wrempty_o     : out std_logic;
		mux_scr0_tx_data_wrfull_o      : out std_logic;
		mux_scr0_tx_data_wrusedw_o     : out std_logic_vector(11 downto 0);
		-- source 1 tx dc data fifo mux output pins (fpga --> umft601a)
		mux_scr1_tx_data_wrempty_o     : out std_logic;
		mux_scr1_tx_data_wrfull_o      : out std_logic;
		mux_scr1_tx_data_wrusedw_o     : out std_logic_vector(11 downto 0)
	);
end entity ftdi_tx_data_mux_ent;

architecture RTL of ftdi_tx_data_mux_ent is

	constant c_RESET_TX_DATA_WRDATA_DATA : std_logic_vector(31 downto 0) := x"00000000";
	constant c_RESET_TX_DATA_WRDATA_BE   : std_logic_vector(3 downto 0)  := x"0";
	constant c_RESET_TX_DATA_WRREQ       : std_logic                     := '0';
	constant c_RESET_TX_DATA_WREMPTY     : std_logic                     := '1';
	constant c_RESET_TX_DATA_WRFULL      : std_logic                     := '0';
	constant c_RESET_TX_DATA_WRUSEDW     : std_logic_vector(11 downto 0) := std_logic_vector(to_unsigned(0, 12));

begin

	-- inputs mux
	mux_scr0_tx_data_wrempty_o <= (mux_ftdi_tx_data_wrempty_i) when (mux_scr_select_i = "00") else (c_RESET_TX_DATA_WREMPTY);
	mux_scr0_tx_data_wrfull_o  <= (mux_ftdi_tx_data_wrfull_i) when (mux_scr_select_i = "00") else (c_RESET_TX_DATA_WRFULL);
	mux_scr0_tx_data_wrusedw_o <= (mux_ftdi_tx_data_wrusedw_i) when (mux_scr_select_i = "00") else (c_RESET_TX_DATA_WRUSEDW);
	mux_scr1_tx_data_wrempty_o <= (mux_ftdi_tx_data_wrempty_i) when (mux_scr_select_i = "01") else (c_RESET_TX_DATA_WREMPTY);
	mux_scr1_tx_data_wrfull_o  <= (mux_ftdi_tx_data_wrfull_i) when (mux_scr_select_i = "01") else (c_RESET_TX_DATA_WRFULL);
	mux_scr1_tx_data_wrusedw_o <= (mux_ftdi_tx_data_wrusedw_i) when (mux_scr_select_i = "01") else (c_RESET_TX_DATA_WRUSEDW);

	-- outputs mux
	mux_ftdi_tx_data_wrdata_data_o <= (mux_scr0_tx_data_wrdata_data_i) when (mux_scr_select_i = "00")
		else (mux_scr1_tx_data_wrdata_data_i) when (mux_scr_select_i = "01")
		else (c_RESET_TX_DATA_WRDATA_DATA);
	mux_ftdi_tx_data_wrdata_be_o   <= (mux_scr0_tx_data_wrdata_be_i) when (mux_scr_select_i = "00")
		else (mux_scr1_tx_data_wrdata_be_i) when (mux_scr_select_i = "01")
		else (c_RESET_TX_DATA_WRDATA_BE);
	mux_ftdi_tx_data_wrreq_o       <= (mux_scr0_tx_data_wrreq_i) when (mux_scr_select_i = "00")
		else (mux_scr1_tx_data_wrreq_i) when (mux_scr_select_i = "01")
		else (c_RESET_TX_DATA_WRREQ);

end architecture RTL;
