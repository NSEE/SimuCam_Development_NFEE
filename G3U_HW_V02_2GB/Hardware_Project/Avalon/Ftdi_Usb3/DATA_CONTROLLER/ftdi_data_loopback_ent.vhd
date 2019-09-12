library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ftdi_data_loopback_ent is
	port(
		clk_i                         : in  std_logic;
		rst_i                         : in  std_logic;
		-- tx dc data fifo input pins (fpga --> umft601a)
		tx_dc_data_fifo_wrempty_i     : in  std_logic;
		tx_dc_data_fifo_wrfull_i      : in  std_logic;
		tx_dc_data_fifo_wrusedw_i     : in  std_logic_vector(11 downto 0);
		-- rx dc data fifo input pins (fpga <-- umft601a)
		rx_dc_data_fifo_rddata_data_i : in  std_logic_vector(31 downto 0);
		rx_dc_data_fifo_rddata_be_i   : in  std_logic_vector(3 downto 0);
		rx_dc_data_fifo_rdempty_i     : in  std_logic;
		rx_dc_data_fifo_rdfull_i      : in  std_logic;
		rx_dc_data_fifo_rdusedw_i     : in  std_logic_vector(11 downto 0);
		-- tx dc data fifo output pins (fpga --> umft601a)
		tx_dc_data_fifo_wrdata_data_o : out std_logic_vector(31 downto 0);
		tx_dc_data_fifo_wrdata_be_o   : out std_logic_vector(3 downto 0);
		tx_dc_data_fifo_wrreq_o       : out std_logic;
		-- rx dc data fifo output pins (fpga <-- umft601a)
		rx_dc_data_fifo_rdreq_o       : out std_logic
	);
end entity ftdi_data_loopback_ent;

architecture RTL of ftdi_data_loopback_ent is

	-- loopback mode fsm type
	type t_loopback_mode_fsm is (
		WAITING_TX_SPACE,
		WRITE_TX_DATA
	);

	-- loopback mode fsm state
	signal s_loopback_mode_state : t_loopback_mode_fsm;

begin

	-- loopback mode process
	p_loopback_mode : process(clk_i, rst_i) is
	begin
		if (rst_i = '1') then
			--			s_loopback_mode_state         <= WAITING_RX_DATA;
			s_loopback_mode_state         <= WAITING_TX_SPACE;
			tx_dc_data_fifo_wrdata_data_o <= (others => '0');
			tx_dc_data_fifo_wrdata_be_o   <= (others => '0');
			tx_dc_data_fifo_wrreq_o       <= '0';
			rx_dc_data_fifo_rdreq_o       <= '0';
		elsif rising_edge(clk_i) then

			case (s_loopback_mode_state) is

				when WAITING_TX_SPACE =>
					s_loopback_mode_state         <= WAITING_TX_SPACE;
					tx_dc_data_fifo_wrdata_data_o <= (others => '0');
					tx_dc_data_fifo_wrdata_be_o   <= (others => '0');
					tx_dc_data_fifo_wrreq_o       <= '0';
					rx_dc_data_fifo_rdreq_o       <= '0';
					if ((rx_dc_data_fifo_rdempty_i = '0') and (tx_dc_data_fifo_wrfull_i = '0')) then
						s_loopback_mode_state         <= WRITE_TX_DATA;
						tx_dc_data_fifo_wrdata_data_o <= rx_dc_data_fifo_rddata_data_i;
						tx_dc_data_fifo_wrdata_be_o   <= rx_dc_data_fifo_rddata_be_i;
						rx_dc_data_fifo_rdreq_o       <= '1';
						tx_dc_data_fifo_wrreq_o       <= '1';
					end if;

				when WRITE_TX_DATA =>
					s_loopback_mode_state         <= WAITING_TX_SPACE;
					tx_dc_data_fifo_wrdata_data_o <= (others => '0');
					tx_dc_data_fifo_wrdata_be_o   <= (others => '0');
					tx_dc_data_fifo_wrreq_o       <= '0';
					rx_dc_data_fifo_rdreq_o       <= '0';

				when others =>
					s_loopback_mode_state         <= WAITING_TX_SPACE;
					tx_dc_data_fifo_wrdata_data_o <= (others => '0');
					tx_dc_data_fifo_wrdata_be_o   <= (others => '0');
					tx_dc_data_fifo_wrreq_o       <= '0';
					rx_dc_data_fifo_rdreq_o       <= '0';

			end case;

		end if;
	end process p_loopback_mode;

end architecture RTL;
