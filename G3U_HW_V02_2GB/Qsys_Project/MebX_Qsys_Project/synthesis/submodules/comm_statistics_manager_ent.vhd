library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.avalon_mm_spacewire_registers_pkg.all;

entity comm_statistics_manager_ent is
	port(
		clk_i                     : in  std_logic;
		rst_i                     : in  std_logic;
		statistics_clear_i        : in  std_logic;
		spw_rx_channel_rxread_i   : in  std_logic;
		spw_rx_channel_rxflag_i   : in  std_logic;
		spw_rx_channel_rxdata_i   : in  std_logic_vector(7 downto 0);
		spw_tx_channel_txwrite_i  : in  std_logic;
		spw_tx_channel_txflag_i   : in  std_logic;
		spw_tx_channel_txdata_i   : in  std_logic_vector(7 downto 0);
		spw_err_escape_i          : in  std_logic;
		spw_err_credit_i          : in  std_logic;
		spw_err_parity_i          : in  std_logic;
		spw_err_disconnect_i      : in  std_logic;
		incoming_pkts_cnt_o       : out std_logic_vector(31 downto 0);
		incoming_bytes_cnt_o      : out std_logic_vector(31 downto 0);
		outgoing_pkts_cnt_o       : out std_logic_vector(31 downto 0);
		outgoing_bytes_cnt_o      : out std_logic_vector(31 downto 0);
		spw_link_escape_err_cnt_o : out std_logic_vector(31 downto 0);
		spw_link_credit_err_cnt_o : out std_logic_vector(31 downto 0);
		spw_link_parity_err_cnt_o : out std_logic_vector(31 downto 0);
		spw_link_disconnect_cnt_o : out std_logic_vector(31 downto 0);
		spw_eep_cnt_o             : out std_logic_vector(31 downto 0)
	);
end entity comm_statistics_manager_ent;

architecture RTL of comm_statistics_manager_ent is

	signal s_spw_link_escape_err_dly : std_logic;
	signal s_spw_link_credit_err_dly : std_logic;
	signal s_spw_link_parity_err_dly : std_logic;
	signal s_spw_link_disconnect_dly : std_logic;

	signal s_incoming_pkts_cnt       : std_logic_vector(31 downto 0);
	signal s_incoming_bytes_cnt      : std_logic_vector(31 downto 0);
	signal s_outgoing_pkts_cnt       : std_logic_vector(31 downto 0);
	signal s_outgoing_bytes_cnt      : std_logic_vector(31 downto 0);
	signal s_spw_link_escape_err_cnt : std_logic_vector(31 downto 0);
	signal s_spw_link_credit_err_cnt : std_logic_vector(31 downto 0);
	signal s_spw_link_parity_err_cnt : std_logic_vector(31 downto 0);
	signal s_spw_link_disconnect_cnt : std_logic_vector(31 downto 0);
	signal s_spw_eep_cnt             : std_logic_vector(31 downto 0);

begin

	p_comm_fee_statistics : process(clk_i, rst_i) is
	begin
		if (rst_i = '1') then

			s_spw_link_escape_err_dly <= '0';
			s_spw_link_credit_err_dly <= '0';
			s_spw_link_parity_err_dly <= '0';
			s_spw_link_disconnect_dly <= '0';

			s_incoming_pkts_cnt       <= (others => '0');
			s_incoming_bytes_cnt      <= (others => '0');
			s_outgoing_pkts_cnt       <= (others => '0');
			s_outgoing_bytes_cnt      <= (others => '0');
			s_spw_link_escape_err_cnt <= (others => '0');
			s_spw_link_credit_err_cnt <= (others => '0');
			s_spw_link_parity_err_cnt <= (others => '0');
			s_spw_link_disconnect_cnt <= (others => '0');
			s_spw_eep_cnt             <= (others => '0');

		elsif rising_edge(clk_i) then

			-- make statistics

			-- check if a incoming packet occurred (high level)
			if ((spw_rx_channel_rxread_i = '1') and (spw_rx_channel_rxflag_i = '1')) then
				if (s_incoming_pkts_cnt = x"FFFFFFFF") then
					s_incoming_pkts_cnt <= (others => '0');
				else
					s_incoming_pkts_cnt <= std_logic_vector(unsigned(s_incoming_pkts_cnt) + 1);
				end if;
			end if;

			-- check if a incoming byte occurred (high level)
			if ((spw_rx_channel_rxread_i = '1') and (spw_rx_channel_rxflag_i = '0')) then
				if (s_incoming_bytes_cnt = x"FFFFFFFF") then
					s_incoming_bytes_cnt <= (others => '0');
				else
					s_incoming_bytes_cnt <= std_logic_vector(unsigned(s_incoming_bytes_cnt) + 1);
				end if;
			end if;

			-- check if a outgoing packet occurred (high level)
			if ((spw_tx_channel_txwrite_i = '1') and (spw_tx_channel_txflag_i = '1')) then
				if (s_outgoing_pkts_cnt = x"FFFFFFFF") then
					s_outgoing_pkts_cnt <= (others => '0');
				else
					s_outgoing_pkts_cnt <= std_logic_vector(unsigned(s_outgoing_pkts_cnt) + 1);
				end if;
			end if;

			-- check if a outgoing byte occurred (high level)
			if ((spw_tx_channel_txwrite_i = '1') and (spw_tx_channel_txflag_i = '0')) then
				if (s_outgoing_bytes_cnt = x"FFFFFFFF") then
					s_outgoing_bytes_cnt <= (others => '0');
				else
					s_outgoing_bytes_cnt <= std_logic_vector(unsigned(s_outgoing_bytes_cnt) + 1);
				end if;
			end if;

			-- check if a spw link escape error occurred (rising edge)
			if ((s_spw_link_escape_err_dly = '0') and (spw_err_escape_i = '1')) then
				if (s_spw_link_escape_err_cnt = x"FFFFFFFF") then
					s_spw_link_escape_err_cnt <= (others => '0');
				else
					s_spw_link_escape_err_cnt <= std_logic_vector(unsigned(s_spw_link_escape_err_cnt) + 1);
				end if;
			end if;
			s_spw_link_escape_err_dly <= spw_err_escape_i;

			-- check if a spw link credit error occurred (rising edge)
			if ((s_spw_link_credit_err_dly = '0') and (spw_err_credit_i = '1')) then
				if (s_spw_link_credit_err_cnt = x"FFFFFFFF") then
					s_spw_link_credit_err_cnt <= (others => '0');
				else
					s_spw_link_credit_err_cnt <= std_logic_vector(unsigned(s_spw_link_credit_err_cnt) + 1);
				end if;
			end if;
			s_spw_link_credit_err_dly <= spw_err_credit_i;

			-- check if a spw link parity error occurred (rising edge)
			if ((s_spw_link_parity_err_dly = '0') and (spw_err_parity_i = '1')) then
				if (s_spw_link_parity_err_cnt = x"FFFFFFFF") then
					s_spw_link_parity_err_cnt <= (others => '0');
				else
					s_spw_link_parity_err_cnt <= std_logic_vector(unsigned(s_spw_link_parity_err_cnt) + 1);
				end if;
			end if;
			s_spw_link_parity_err_dly <= spw_err_parity_i;

			-- check if a spw link disconnect occurred (rising edge)
			if ((s_spw_link_disconnect_dly = '0') and (spw_err_disconnect_i = '1')) then
				if (s_spw_link_disconnect_cnt = x"FFFFFFFF") then
					s_spw_link_disconnect_cnt <= (others => '0');
				else
					s_spw_link_disconnect_cnt <= std_logic_vector(unsigned(s_spw_link_disconnect_cnt) + 1);
				end if;
			end if;
			s_spw_link_disconnect_dly <= spw_err_disconnect_i;

			-- check if a eep occurred (high level), at rx or tx
			if (((spw_rx_channel_rxread_i = '1') and (spw_rx_channel_rxflag_i = '1') and (spw_rx_channel_rxdata_i = x"01")) or ((spw_tx_channel_txwrite_i = '1') and (spw_tx_channel_txflag_i = '1') and (spw_tx_channel_txdata_i = x"01"))) then
				if (s_spw_eep_cnt = x"FFFFFFFF") then
					s_spw_eep_cnt <= (others => '0');
				else
					s_spw_eep_cnt <= std_logic_vector(unsigned(s_spw_eep_cnt) + 1);
				end if;
			end if;

			-- check if a fee statistics clear was issued
			if (statistics_clear_i = '1') then
				s_incoming_pkts_cnt       <= (others => '0');
				s_incoming_bytes_cnt      <= (others => '0');
				s_outgoing_pkts_cnt       <= (others => '0');
				s_outgoing_bytes_cnt      <= (others => '0');
				s_spw_link_escape_err_cnt <= (others => '0');
				s_spw_link_credit_err_cnt <= (others => '0');
				s_spw_link_parity_err_cnt <= (others => '0');
				s_spw_link_disconnect_cnt <= (others => '0');
				s_spw_eep_cnt             <= (others => '0');
			end if;

		end if;
	end process p_comm_fee_statistics;

	-- outputs generation
	incoming_pkts_cnt_o       <= s_incoming_pkts_cnt;
	incoming_bytes_cnt_o      <= s_incoming_bytes_cnt;
	outgoing_pkts_cnt_o       <= s_outgoing_pkts_cnt;
	outgoing_bytes_cnt_o      <= s_outgoing_bytes_cnt;
	spw_link_escape_err_cnt_o <= s_spw_link_escape_err_cnt;
	spw_link_credit_err_cnt_o <= s_spw_link_credit_err_cnt;
	spw_link_parity_err_cnt_o <= s_spw_link_parity_err_cnt;
	spw_link_disconnect_cnt_o <= s_spw_link_disconnect_cnt;
	spw_eep_cnt_o             <= s_spw_eep_cnt;

end architecture RTL;
