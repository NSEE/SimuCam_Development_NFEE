-- USB_3_FTDI_top.vhd

-- This file was auto-generated as a prototype implementation of a module
-- created in component editor.  It ties off all outputs to ground and
-- ignores all inputs.  It needs to be edited to make it do something
-- useful.
-- 
-- This file will not be automatically regenerated.  You should check it in
-- to your version control system if you want to keep it.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity USB_3_FTDI_top is
	port(
		clock_sink_clk                   : in    std_logic                     := '0'; --          --         clock_sink.clk
		reset_sink_reset                 : in    std_logic                     := '0'; --          --         reset_sink.reset
		umft_data_bus                    : inout std_logic_vector(31 downto 0) := (others => 'Z'); --  conduit_umft_pins.umft_data_signal
		umft_reset_n_pin                 : out   std_logic; --                                     --                   .umft_reset_n_signal
		umft_rxf_n_pin                   : in    std_logic                     := '1'; --          --                   .umft_rxf_n_signal
		umft_clock_pin                   : in    std_logic                     := '1'; --          --                   .umft_clock_signal
		umft_wakeup_n_pin                : inout std_logic                     := 'Z'; --          --                   .umft_wakeup_n_signal
		umft_be_bus                      : inout std_logic_vector(3 downto 0)  := (others => 'Z'); --                   .umft_be_signal
		umft_txe_n_pin                   : in    std_logic                     := '1'; --          --                   .umft_txe_n_signal
		umft_gpio_bus                    : inout std_logic_vector(1 downto 0)  := (others => 'Z'); --                   .umft_gpio_bus_signal
		umft_wr_n_pin                    : out   std_logic; --                                     --                   .umft_wr_n_signal
		umft_rd_n_pin                    : out   std_logic; --                                     --                   .umft_rd_n_signal
		umft_oe_n_pin                    : out   std_logic; --                                     --                   .umft_oe_n_signal
		umft_siwu_n_pin                  : out   std_logic; --                                     --                   .umft_siwu_n_signal
		avalon_burst_slave_address       : in    std_logic_vector(15 downto 0) := (others => '0'); -- avalon_burst_slave.address
		avalon_burst_slave_read          : in    std_logic                     := '0'; --          --                   .read
		avalon_burst_slave_readdata      : out   std_logic_vector(31 downto 0); --                 --                   .readdata
		avalon_burst_slave_waitrequest   : out   std_logic; --                                     --                   .waitrequest
		avalon_burst_slave_burstcount    : in    std_logic_vector(7 downto 0)  := (others => '0'); --                   .burstcount
		avalon_burst_slave_byteenable    : in    std_logic_vector(3 downto 0)  := (others => '0'); --                   .byteenable
		avalon_burst_slave_readdatavalid : out   std_logic; --                                     --                   .readdatavalid
		avalon_burst_slave_write         : in    std_logic                     := '0'; --          --                   .write
		avalon_burst_slave_writedata     : in    std_logic_vector(31 downto 0) := (others => '0') ---                   .writedata
	);
end entity USB_3_FTDI_top;

architecture rtl of USB_3_FTDI_top is

	-- basic alias
	alias a_avs_clock is clock_sink_clk;
	alias a_reset is reset_sink_reset;

	-- tx dc fifo signals
	signal s_tx_dc_data_fifo_wrdata_data : std_logic_vector(31 downto 0);
	signal s_tx_dc_data_fifo_wrdata_be   : std_logic_vector(3 downto 0);
	signal s_tx_dc_data_fifo_wrreq       : std_logic;
	signal s_tx_dc_data_fifo_wrempty     : std_logic;
	signal s_tx_dc_data_fifo_wrfull      : std_logic;
	signal s_tx_dc_data_fifo_wrusedw     : std_logic_vector(11 downto 0);

	-- rx dc fifo signals
	signal s_rx_dc_data_fifo_rdreq       : std_logic;
	signal s_rx_dc_data_fifo_rddata_data : std_logic_vector(31 downto 0);
	signal s_rx_dc_data_fifo_rddata_be   : std_logic_vector(3 downto 0);
	signal s_rx_dc_data_fifo_rdempty     : std_logic;
	signal s_rx_dc_data_fifo_rdfull      : std_logic;
	signal s_rx_dc_data_fifo_rdusedw     : std_logic_vector(11 downto 0);

	-- loopback mode fsm type
	type t_loopback_mode_fsm is (
--		WAITING_RX_DATA,
--		FETCH_RX_DATA,
		WAITING_TX_SPACE,
		WRITE_TX_DATA
	);

	-- loopback mode fsm state
	signal t_loopback_mode_state : t_loopback_mode_fsm;

begin

	-- ftdi umft601a controller instantiation
	ftdi_umft601a_controller_ent_inst : entity work.ftdi_umft601a_controller_ent
		port map(
			clk_i                         => a_avs_clock,
			rst_i                         => a_reset,
			umft_rxf_n_pin_i              => umft_rxf_n_pin,
			umft_clock_pin_i              => umft_clock_pin,
			umft_txe_n_pin_i              => umft_txe_n_pin,
			tx_dc_data_fifo_wrdata_data_i => s_tx_dc_data_fifo_wrdata_data,
			tx_dc_data_fifo_wrdata_be_i   => s_tx_dc_data_fifo_wrdata_be,
			tx_dc_data_fifo_wrreq_i       => s_tx_dc_data_fifo_wrreq,
			rx_dc_data_fifo_rdreq_i       => s_rx_dc_data_fifo_rdreq,
			umft_data_bus_io              => umft_data_bus,
			umft_wakeup_n_pin_io          => umft_wakeup_n_pin,
			umft_be_bus_io                => umft_be_bus,
			umft_gpio_bus_io              => umft_gpio_bus,
			umft_reset_n_pin_o            => umft_reset_n_pin,
			umft_wr_n_pin_o               => umft_wr_n_pin,
			umft_rd_n_pin_o               => umft_rd_n_pin,
			umft_oe_n_pin_o               => umft_oe_n_pin,
			umft_siwu_n_pin_o             => umft_siwu_n_pin,
			tx_dc_data_fifo_wrempty_o     => s_tx_dc_data_fifo_wrempty,
			tx_dc_data_fifo_wrfull_o      => s_tx_dc_data_fifo_wrfull,
			tx_dc_data_fifo_wrusedw_o     => s_tx_dc_data_fifo_wrusedw,
			rx_dc_data_fifo_rddata_data_o => s_rx_dc_data_fifo_rddata_data,
			rx_dc_data_fifo_rddata_be_o   => s_rx_dc_data_fifo_rddata_be,
			rx_dc_data_fifo_rdempty_o     => s_rx_dc_data_fifo_rdempty,
			rx_dc_data_fifo_rdfull_o      => s_rx_dc_data_fifo_rdfull,
			rx_dc_data_fifo_rdusedw_o     => s_rx_dc_data_fifo_rdusedw
		);

	-- loopback mode process
	p_loopback_mode : process(a_avs_clock, a_reset) is
	begin
		if (a_reset = '1') then
			--			t_loopback_mode_state         <= WAITING_RX_DATA;
			t_loopback_mode_state         <= WAITING_TX_SPACE;
			s_tx_dc_data_fifo_wrdata_data <= (others => '0');
			s_tx_dc_data_fifo_wrdata_be   <= (others => '0');
			s_tx_dc_data_fifo_wrreq       <= '0';
			s_rx_dc_data_fifo_rdreq       <= '0';
		elsif rising_edge(a_avs_clock) then

			case (t_loopback_mode_state) is

--				when WAITING_RX_DATA =>
--					t_loopback_mode_state         <= WAITING_RX_DATA;
--					s_tx_dc_data_fifo_wrdata_data <= (others => '0');
--					s_tx_dc_data_fifo_wrdata_be   <= (others => '0');
--					s_tx_dc_data_fifo_wrreq       <= '0';
--					s_rx_dc_data_fifo_rdreq       <= '0';
--					if (s_rx_dc_data_fifo_rdempty = '0') then
--						--						t_loopback_mode_state   <= FETCH_RX_DATA;
--						t_loopback_mode_state <= WAITING_TX_SPACE;
--					end if;
--
--				when FETCH_RX_DATA =>
--					t_loopback_mode_state         <= WAITING_TX_SPACE;
--					s_tx_dc_data_fifo_wrdata_data <= (others => '0');
--					s_tx_dc_data_fifo_wrdata_be   <= (others => '0');
--					s_tx_dc_data_fifo_wrreq       <= '0';
--					s_rx_dc_data_fifo_rdreq       <= '0';

				when WAITING_TX_SPACE =>
					t_loopback_mode_state         <= WAITING_TX_SPACE;
					s_tx_dc_data_fifo_wrdata_data <= (others => '0');
					s_tx_dc_data_fifo_wrdata_be   <= (others => '0');
					s_tx_dc_data_fifo_wrreq       <= '0';
					s_rx_dc_data_fifo_rdreq       <= '0';
					--					if (s_tx_dc_data_fifo_wrfull = '0') then
					if ((s_rx_dc_data_fifo_rdempty = '0') and (s_tx_dc_data_fifo_wrfull = '0')) then
						t_loopback_mode_state         <= WRITE_TX_DATA;
						s_tx_dc_data_fifo_wrdata_data <= s_rx_dc_data_fifo_rddata_data;
						s_tx_dc_data_fifo_wrdata_be   <= s_rx_dc_data_fifo_rddata_be;
						s_rx_dc_data_fifo_rdreq       <= '1';
						s_tx_dc_data_fifo_wrreq       <= '1';
					end if;

				when WRITE_TX_DATA =>
					--					t_loopback_mode_state         <= WAITING_RX_DATA;
					t_loopback_mode_state         <= WAITING_TX_SPACE;
					s_tx_dc_data_fifo_wrdata_data <= (others => '0');
					s_tx_dc_data_fifo_wrdata_be   <= (others => '0');
					s_tx_dc_data_fifo_wrreq       <= '0';
					s_rx_dc_data_fifo_rdreq       <= '0';

				when others =>
					t_loopback_mode_state         <= WAITING_TX_SPACE;
					s_tx_dc_data_fifo_wrdata_data <= (others => '0');
					s_tx_dc_data_fifo_wrdata_be   <= (others => '0');
					s_tx_dc_data_fifo_wrreq       <= '0';
					s_rx_dc_data_fifo_rdreq       <= '0';

			end case;

		end if;
	end process p_loopback_mode;

end architecture rtl;                   -- of USB_3_FTDI_top
