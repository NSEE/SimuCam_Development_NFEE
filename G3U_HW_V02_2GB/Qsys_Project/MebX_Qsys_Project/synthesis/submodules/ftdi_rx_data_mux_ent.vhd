library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ftdi_rx_data_mux_ent is
	port(
		-- mux control 
		mux_scr_select_i               : in  std_logic_vector(1 downto 0);
		-- ftdi rx dc data fifo mux input pins (fpga <-- umft601a)
		mux_ftdi_rx_data_rddata_data_i : in  std_logic_vector(31 downto 0);
		mux_ftdi_rx_data_rddata_be_i   : in  std_logic_vector(3 downto 0);
		mux_ftdi_rx_data_rdempty_i     : in  std_logic;
		mux_ftdi_rx_data_rdfull_i      : in  std_logic;
		mux_ftdi_rx_data_rdusedw_i     : in  std_logic_vector(11 downto 0);
		-- source 0 rx dc data fifo mux input pins (fpga <-- umft601a)
		mux_scr0_rx_data_rdreq_i       : in  std_logic;
		-- source 1 rx dc data fifo mux input pins (fpga <-- umft601a)
		mux_scr1_rx_data_rdreq_i       : in  std_logic;
		-- ftdi rx dc data fifo mux output pins (fpga <-- umft601a)
		mux_ftdi_rx_data_rdreq_o       : out std_logic;
		-- source 0 rx dc data fifo mux output pins (fpga <-- umft601a)
		mux_scr0_rx_data_rddata_data_o : out std_logic_vector(31 downto 0);
		mux_scr0_rx_data_rddata_be_o   : out std_logic_vector(3 downto 0);
		mux_scr0_rx_data_rdempty_o     : out std_logic;
		mux_scr0_rx_data_rdfull_o      : out std_logic;
		mux_scr0_rx_data_rdusedw_o     : out std_logic_vector(11 downto 0);
		-- source 1 rx dc data fifo mux output pins (fpga <-- umft601a)
		mux_scr1_rx_data_rddata_data_o : out std_logic_vector(31 downto 0);
		mux_scr1_rx_data_rddata_be_o   : out std_logic_vector(3 downto 0);
		mux_scr1_rx_data_rdempty_o     : out std_logic;
		mux_scr1_rx_data_rdfull_o      : out std_logic;
		mux_scr1_rx_data_rdusedw_o     : out std_logic_vector(11 downto 0)
	);
end entity ftdi_rx_data_mux_ent;

architecture RTL of ftdi_rx_data_mux_ent is

	constant c_RESET_RX_DATA_RDDATA_DATA : std_logic_vector(31 downto 0) := x"00000000";
	constant c_RESET_RX_DATA_RDDATA_BE   : std_logic_vector(3 downto 0)  := x"0";
	constant c_RESET_RX_DATA_RDEMPTY     : std_logic                     := '1';
	constant c_RESET_RX_DATA_RDFULL      : std_logic                     := '0';
	constant c_RESET_RX_DATA_RDUSEDW     : std_logic_vector(11 downto 0) := std_logic_vector(to_unsigned(0, 12));
	constant c_RESET_RX_DATA_RDREQ       : std_logic                     := '0';

begin

	-- inputs mux
	mux_scr0_rx_data_rddata_data_o <= (mux_ftdi_rx_data_rddata_data_i) when (mux_scr_select_i = "00") else (c_RESET_RX_DATA_RDDATA_DATA);
	mux_scr0_rx_data_rddata_be_o   <= (mux_ftdi_rx_data_rddata_be_i) when (mux_scr_select_i = "00") else (c_RESET_RX_DATA_RDDATA_BE);
	mux_scr0_rx_data_rdempty_o     <= (mux_ftdi_rx_data_rdempty_i) when (mux_scr_select_i = "00") else (c_RESET_RX_DATA_RDEMPTY);
	mux_scr0_rx_data_rdfull_o      <= (mux_ftdi_rx_data_rdfull_i) when (mux_scr_select_i = "00") else (c_RESET_RX_DATA_RDFULL);
	mux_scr0_rx_data_rdusedw_o     <= (mux_ftdi_rx_data_rdusedw_i) when (mux_scr_select_i = "00") else (c_RESET_RX_DATA_RDUSEDW);
	mux_scr1_rx_data_rddata_data_o <= (mux_ftdi_rx_data_rddata_data_i) when (mux_scr_select_i = "01") else (c_RESET_RX_DATA_RDDATA_DATA);
	mux_scr1_rx_data_rddata_be_o   <= (mux_ftdi_rx_data_rddata_be_i) when (mux_scr_select_i = "01") else (c_RESET_RX_DATA_RDDATA_BE);
	mux_scr1_rx_data_rdempty_o     <= (mux_ftdi_rx_data_rdempty_i) when (mux_scr_select_i = "01") else (c_RESET_RX_DATA_RDEMPTY);
	mux_scr1_rx_data_rdfull_o      <= (mux_ftdi_rx_data_rdfull_i) when (mux_scr_select_i = "01") else (c_RESET_RX_DATA_RDFULL);
	mux_scr1_rx_data_rdusedw_o     <= (mux_ftdi_rx_data_rdusedw_i) when (mux_scr_select_i = "01") else (c_RESET_RX_DATA_RDUSEDW);

	-- outputs mux
	mux_ftdi_rx_data_rdreq_o <= (mux_scr0_rx_data_rdreq_i) when (mux_scr_select_i = "00")
		else (mux_scr1_rx_data_rdreq_i) when (mux_scr_select_i = "01")
		else (c_RESET_RX_DATA_RDREQ);

end architecture RTL;
