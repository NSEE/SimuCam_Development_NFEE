library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ftdi_umft601a_controller_ent is
	port(
		clk_i                         : in    std_logic;
		rst_i                         : in    std_logic;
		-- umft601a input pins
		umft_rxf_n_pin_i              : in    std_logic                     := '0';
		umft_clock_pin_i              : in    std_logic                     := '0';
		umft_txe_n_pin_i              : in    std_logic                     := '0';
		-- tx dc data fifo input pins (fpga --> umft601a)
		tx_dc_data_fifo_wrdata_data_i : in    std_logic_vector(31 downto 0);
		tx_dc_data_fifo_wrdata_be_i   : in    std_logic_vector(3 downto 0);
		tx_dc_data_fifo_wrreq_i       : in    std_logic;
		-- rx dc data fifo input pins (fpga <-- umft601a)
		rx_dc_data_fifo_rdreq_i       : in    std_logic;
		-- umft601a bidir pins
		umft_data_bus_io              : inout std_logic_vector(31 downto 0) := (others => 'Z');
		umft_wakeup_n_pin_io          : inout std_logic                     := 'Z';
		umft_be_bus_io                : inout std_logic_vector(3 downto 0)  := (others => 'Z');
		umft_gpio_bus_io              : inout std_logic_vector(1 downto 0)  := (others => 'Z');
		-- umft601a output pins
		umft_reset_n_pin_o            : out   std_logic;
		umft_wr_n_pin_o               : out   std_logic;
		umft_rd_n_pin_o               : out   std_logic;
		umft_oe_n_pin_o               : out   std_logic;
		umft_siwu_n_pin_o             : out   std_logic;
		-- tx dc data fifo output pins (fpga --> umft601a)
		tx_dc_data_fifo_wrempty_o     : out   std_logic;
		tx_dc_data_fifo_wrfull_o      : out   std_logic;
		tx_dc_data_fifo_wrusedw_o     : out   std_logic_vector(8 downto 0);
		-- rx dc data fifo output pins (fpga <-- umft601a)
		rx_dc_data_fifo_rddata_data_o : out   std_logic_vector(31 downto 0);
		rx_dc_data_fifo_rddata_be_o   : out   std_logic_vector(3 downto 0);
		rx_dc_data_fifo_rdempty_o     : out   std_logic;
		rx_dc_data_fifo_rdfull_o      : out   std_logic;
		rx_dc_data_fifo_rdusedw_o     : out   std_logic_vector(8 downto 0)
	);
end entity ftdi_umft601a_controller_ent;

architecture RTL of ftdi_umft601a_controller_ent is

	-- ftdi umft601a pins record type
	type t_umft601a_pins is record
		rxf_n        : std_logic;
		clock        : std_logic;
		txe_n        : std_logic;
		data_in      : std_logic_vector(31 downto 0);
		wakeup_n_in  : std_logic;
		be_in        : std_logic_vector(3 downto 0);
		gpio_in      : std_logic_vector(1 downto 0);
		data_out     : std_logic_vector(31 downto 0);
		wakeup_n_out : std_logic;
		be_out       : std_logic_vector(3 downto 0);
		gpio_out     : std_logic_vector(1 downto 0);
		reset_n      : std_logic;
		wr_n         : std_logic;
		rd_n         : std_logic;
		oe_n         : std_logic;
		siwu_n       : std_logic;
	end record t_umft601a_pins;

	-- ftdi umft601a pins signals
	signal s_umft601a_buffered_pins : t_umft601a_pins;

	-- tx dc data fifo record type
	type t_tx_dc_data_fifo is record
		rdreq       : std_logic;
		rddata_data : std_logic_vector(31 downto 0);
		rddata_be   : std_logic_vector(3 downto 0);
		rdempty     : std_logic;
		rdfull      : std_logic;
		rdusedw     : std_logic_vector(8 downto 0);
	end record t_tx_dc_data_fifo;

	-- tx dc data fifo signals
	signal s_tx_dc_data_fifo : t_tx_dc_data_fifo;

	-- rx dc data fifo record type
	type t_rx_dc_data_fifo is record
		wrdata_data : std_logic_vector(31 downto 0);
		wrdata_be   : std_logic_vector(3 downto 0);
		wrreq       : std_logic;
		wrempty     : std_logic;
		wrfull      : std_logic;
		wrusedw     : std_logic_vector(8 downto 0);
	end record t_rx_dc_data_fifo;

	-- rx dc data fifo signals
	signal s_rx_dc_data_fifo : t_rx_dc_data_fifo;

	-- ftdi umft601a controller fsm type
	type t_ftdi_umft601a_controller_fsm is (
		IDLE,
		DELAY_RX,
		ACTIVATE_UMFT_OE,
		FETCH_RX_DATA,
		RECEIVING,
		DELAY_TX,
		ACTIVATE_FPGA_OE,
		FETCH_TX_DATA,
		TRANSMITTING
	);

	-- ftdi umft601a controller fsm state
	signal s_ftdi_umft601a_controller_state : t_ftdi_umft601a_controller_fsm;

	-- io buffers signals
	signal s_io_inout_buffer_output_enable : std_logic;

	signal s_delay_cnt : natural range 0 to 2 := 0;

begin

	-- tx dc data fifo instantiation, for data synchronization (fpga --> umft601a)
	ftdi_tx_data_dc_fifo_inst : entity work.ftdi_data_dc_fifo
		port map(
			aclr              => rst_i,
			data(35 downto 4) => tx_dc_data_fifo_wrdata_data_i,
			data(3 downto 0)  => tx_dc_data_fifo_wrdata_be_i,
			rdclk             => s_umft601a_buffered_pins.clock,
			rdreq             => s_tx_dc_data_fifo.rdreq,
			wrclk             => clk_i,
			wrreq             => tx_dc_data_fifo_wrreq_i,
			q(35 downto 4)    => s_tx_dc_data_fifo.rddata_data,
			q(3 downto 0)     => s_tx_dc_data_fifo.rddata_be,
			rdempty           => s_tx_dc_data_fifo.rdempty,
			rdfull            => s_tx_dc_data_fifo.rdfull,
			rdusedw           => s_tx_dc_data_fifo.rdusedw,
			wrempty           => tx_dc_data_fifo_wrempty_o,
			wrfull            => tx_dc_data_fifo_wrfull_o,
			wrusedw           => tx_dc_data_fifo_wrusedw_o
		);

	-- rx dc data fifo instantiation, for data synchronization (fpga <-- umft601a)
	ftdi_rx_data_dc_fifo_inst : entity work.ftdi_data_dc_fifo
		port map(
			aclr              => rst_i,
			data(35 downto 4) => s_rx_dc_data_fifo.wrdata_data,
			data(3 downto 0)  => s_rx_dc_data_fifo.wrdata_be,
			rdclk             => clk_i,
			rdreq             => rx_dc_data_fifo_rdreq_i,
			wrclk             => s_umft601a_buffered_pins.clock,
			wrreq             => s_rx_dc_data_fifo.wrreq,
			q(35 downto 4)    => rx_dc_data_fifo_rddata_data_o,
			q(3 downto 0)     => rx_dc_data_fifo_rddata_be_o,
			rdempty           => rx_dc_data_fifo_rdempty_o,
			rdfull            => rx_dc_data_fifo_rdfull_o,
			rdusedw           => rx_dc_data_fifo_rdusedw_o,
			wrempty           => s_rx_dc_data_fifo.wrempty,
			wrfull            => s_rx_dc_data_fifo.wrfull,
			wrusedw           => s_rx_dc_data_fifo.wrusedw
		);

	-- input io buffer instantiation, for the umft601a module pins (fpga <-- umft601a)
	ftdi_in_io_buffer_3b_inst : entity work.ftdi_in_io_buffer_3b
		port map(
			datain(2)  => umft_rxf_n_pin_i,
			datain(1)  => umft_clock_pin_i,
			datain(0)  => umft_txe_n_pin_i,
			dataout(2) => s_umft601a_buffered_pins.rxf_n,
			dataout(1) => s_umft601a_buffered_pins.clock,
			dataout(0) => s_umft601a_buffered_pins.txe_n
		);

	-- bidir io buffer instantiation, for the umft601a module pins (fpga <--> umft601a)
	ftdi_inout_io_buffer_39b_inst : entity work.ftdi_inout_io_buffer_39b
		port map(
			datain(38 downto 7)  => s_umft601a_buffered_pins.data_in,
			datain(6)            => s_umft601a_buffered_pins.wakeup_n_in,
			datain(5 downto 2)   => s_umft601a_buffered_pins.be_in,
			datain(1 downto 0)   => s_umft601a_buffered_pins.gpio_in,
			oe                   => s_io_inout_buffer_output_enable,
			dataio(38 downto 7)  => umft_data_bus_io,
			dataio(6)            => umft_wakeup_n_pin_io,
			dataio(5 downto 2)   => umft_be_bus_io,
			dataio(1 downto 0)   => umft_gpio_bus_io,
			dataout(38 downto 7) => s_umft601a_buffered_pins.data_out,
			dataout(6)           => s_umft601a_buffered_pins.wakeup_n_out,
			dataout(5 downto 2)  => s_umft601a_buffered_pins.be_out,
			dataout(1 downto 0)  => s_umft601a_buffered_pins.gpio_out
		);

	-- output io buffer instantiation, for the umft601a module pins (fpga --> umft601a)
	ftdi_out_io_buffer_5b_inst : entity work.ftdi_out_io_buffer_5b
		port map(
			datain(4)  => s_umft601a_buffered_pins.reset_n,
			datain(3)  => s_umft601a_buffered_pins.wr_n,
			datain(2)  => s_umft601a_buffered_pins.rd_n,
			datain(1)  => s_umft601a_buffered_pins.oe_n,
			datain(0)  => s_umft601a_buffered_pins.siwu_n,
			dataout(4) => umft_reset_n_pin_o,
			dataout(3) => umft_wr_n_pin_o,
			dataout(2) => umft_rd_n_pin_o,
			dataout(1) => umft_oe_n_pin_o,
			dataout(0) => umft_siwu_n_pin_o
		);

	-- ftdi umft601a controller fsm process (245 Synchronous FIFO mode Protocols)
	p_ftdi_umft601a_controller : process(clk_i, rst_i)
		variable v_ftdi_umft601a_controller_state : t_ftdi_umft601a_controller_fsm; -- current state
	begin
		-- on asynchronous reset in any state we jump to the idle state
		if (rst_i = '1') then
			-- states
			-- internal signals
			-- outputs
			s_ftdi_umft601a_controller_state <= IDLE;
			s_delay_cnt                      <= 0;
			-- state transitions are always synchronous to the clock
			fpga_output_enable_o             <= '0';
			umft601a_control_o.reset_n       <= '0';
			umft601a_control_o.wr_n          <= '1';
			umft601a_control_o.rd_n          <= '1';
			umft601a_control_o.oe_n          <= '1';
			umft601a_control_o.siwu_n        <= '1';
			umft601a_control_o.wakeup_n      <= '1';
			umft601a_control_o.gpio          <= (others => '1');
			umft601a_tx_data_o.data          <= (others => '0');
			umft601a_tx_data_o.be            <= (others => '0');
			data_fifo_wr_control_o.wrreq     <= '0';
			data_fifo_wr_data_o.data         <= (others => '0');
			data_fifo_wr_data_o.be           <= (others => '0');
			data_fifo_rd_control_o.rdreq     <= '0';
		-- output generation when s_ftdi_umft601a_controller_state changes
		elsif (rising_edge(clk_i)) then

			-- States transitions FSM
			case (s_ftdi_umft601a_controller_state) is

				-- state "IDLE"
				when IDLE =>
					-- does nothing until there is data and space available for a transaction
					-- default state transition
					s_ftdi_umft601a_controller_state <= IDLE;
					-- default internal signal values
					s_delay_cnt                      <= 0;
					-- conditional state transition and internal signal values
					-- check if the UMFT601A module have tx data and the data fifo can receive
					if ((umft601a_status_i.rxf_n = '0') and (data_fifo_wr_status_i.wrfull = '0')) then
						-- UMFT601A module have tx data and the data fifo can receive
						s_ftdi_umft601a_controller_state <= DELAY_RX;
						s_delay_cnt                      <= 2;
					else
						-- UMFT601A module does not have tx data or the data fifo can not receive
						-- check if the UMFT601A module can transmit and the data fifo have data
						if ((umft601a_status_i.txe_n = '0') and (data_fifo_rd_status_i.rdempty = '0')) then
							-- UMFT601A module can transmit and the data fifo have data
							s_ftdi_umft601a_controller_state <= DELAY_TX;
							s_delay_cnt                      <= 2;
						else
							-- UMFT601A module can not transmit or the data fifo does not have data
							s_ftdi_umft601a_controller_state <= IDLE;
						end if;
					end if;

				-- state "DELAY_RX"
				when DELAY_RX =>
					-- 3 clock cicle delay for UMFT601A module (for rx)
					-- default state transition
					s_ftdi_umft601a_controller_state <= DELAY_RX;
					-- default internal signal values
					s_delay_cnt                      <= 0;
					-- conditional state transition and internal signal values
					-- check if the delay is finished
					if (s_delay_cnt > 0) then
						-- delay has not finished yet
						s_delay_cnt <= s_delay_cnt - 1;
					else
						-- delay finished, go to output enable
						s_ftdi_umft601a_controller_state <= ACTIVATE_UMFT_OE;
					end if;

				-- state "ACTIVATE_UMFT_OE"
				when ACTIVATE_UMFT_OE =>
					-- activate output enable for the UMFT601A module (for receiving)
					-- default state transition
					s_ftdi_umft601a_controller_state <= FETCH_RX_DATA;
					-- default internal signal values
					s_delay_cnt                      <= 0;
				-- conditional state transition and internal signal values

				-- state "FETCH_RX_DATA"
				when FETCH_RX_DATA =>
					-- fetch the rx data from the UMFT601A module
					-- default state transition
					s_ftdi_umft601a_controller_state <= RECEIVING;
					-- default internal signal values
					s_delay_cnt                      <= 0;
				-- conditional state transition and internal signal values

				-- state "RECEIVING"
				when RECEIVING =>
					-- receive rx data and write in the data fifo
					-- default state transition
					s_ftdi_umft601a_controller_state <= RECEIVING;
					-- default internal signal values
					s_delay_cnt                      <= 0;
					-- conditional state transition and internal signal values
					-- check if the UMFT601A module still have tx data and the data fifo can still receive
					if ((umft601a_status_i.rxf_n = '0') and (data_fifo_wr_status_i.wrfull = '0')) then
						-- UMFT601A module still have tx data and the data fifo can still receive
						s_ftdi_umft601a_controller_state <= RECEIVING;
					else
						-- UMFT601A module does not have tx data or the data fifo can not receive
						-- check if the UMFT601A module can transmit and the data fifo have data
						if ((umft601a_status_i.txe_n = '0') and (data_fifo_rd_status_i.rdempty = '0')) then
							-- UMFT601A module can transmit and the data fifo have data
							s_ftdi_umft601a_controller_state <= DELAY_TX;
							s_delay_cnt                      <= 2;
						else
							-- UMFT601A module can not transmit or the data fifo does not have data
							s_ftdi_umft601a_controller_state <= IDLE;
						end if;
					end if;

				-- state "DELAY_TX"
				when DELAY_TX =>
					-- 3 clock cicle delay for UMFT601A module (for tx)
					-- default state transition
					s_ftdi_umft601a_controller_state <= DELAY_TX;
					-- default internal signal values
					s_delay_cnt                      <= 0;
					-- conditional state transition and internal signal values
					-- check if the delay is finished
					if (s_delay_cnt > 0) then
						-- delay has not finished yet
						s_delay_cnt <= s_delay_cnt - 1;
					else
						-- delay finished, go to output enable
						s_ftdi_umft601a_controller_state <= ACTIVATE_FPGA_OE;
					end if;

				-- state "ACTIVATE_FPGA_OE"
				when ACTIVATE_FPGA_OE =>
					-- activate the output enable for the FPGA (for transmitting)
					-- default state transition
					s_ftdi_umft601a_controller_state <= FETCH_TX_DATA;
					-- default internal signal values
					s_delay_cnt                      <= 0;
				-- conditional state transition and internal signal values

				-- state "FETCH_TX_DATA"
				when FETCH_TX_DATA =>
					-- fetch the tx data from the DC DATA FIFO
					-- default state transition
					s_ftdi_umft601a_controller_state <= TRANSMITTING;
					-- default internal signal values
					s_delay_cnt                      <= 0;
				-- conditional state transition and internal signal values

				-- state "TRANSMITTING"
				when TRANSMITTING =>
					-- read from data fifo and write tx data
					-- default state transition
					s_ftdi_umft601a_controller_state <= TRANSMITTING;
					-- default internal signal values
					s_delay_cnt                      <= 0;
					-- conditional state transition and internal signal values
					-- check if the UMFT601A module can still transmit and the data fifo still have data
					if ((umft601a_status_i.txe_n = '0') and (data_fifo_rd_status_i.rdempty = '0')) then
						-- UMFT601A module can transmit and the data fifo have data
						s_ftdi_umft601a_controller_state <= TRANSMITTING;
					else
						-- UMFT601A module can not transmit or the data fifo does not have data
						-- check if the UMFT601A module have tx data and the data fifo can receive
						if ((umft601a_status_i.rxf_n = '0') and (data_fifo_wr_status_i.wrfull = '0')) then
							-- UMFT601A module have tx data and the data fifo can receive
							s_ftdi_umft601a_controller_state <= DELAY_RX;
							s_delay_cnt                      <= 2;
						else
							-- UMFT601A module does not have tx data or the data fifo can not receive
							s_ftdi_umft601a_controller_state <= IDLE;
						end if;
					end if;

				-- all the other states (not defined)
				when others =>
					-- jump to save state (ERROR?!)
					s_ftdi_umft601a_controller_state <= IDLE;

			end case;

			-- Output generation FSM
			case (v_umft601a_controller_state) is

				-- state "IDLE"
				when IDLE =>
					-- does nothing until there is data and space available for a transaction
					-- default output signals
					fpga_output_enable_o         <= '0';
					umft601a_control_o.reset_n   <= '1';
					umft601a_control_o.wr_n      <= '1';
					umft601a_control_o.rd_n      <= '1';
					umft601a_control_o.oe_n      <= '1';
					umft601a_control_o.siwu_n    <= '1';
					umft601a_control_o.wakeup_n  <= '1';
					umft601a_control_o.gpio      <= (others => '1');
					umft601a_tx_data_o.data      <= (others => '0');
					umft601a_tx_data_o.be        <= (others => '0');
					data_fifo_wr_control_o.wrreq <= '0';
					data_fifo_wr_data_o.data     <= (others => '0');
					data_fifo_wr_data_o.be       <= (others => '0');
					data_fifo_rd_control_o.rdreq <= '0';
				-- conditional output signals

				-- state "DELAY_RX"
				when DELAY_RX =>
					-- 3 clock cicle delay for UMFT601A module (for rx)
					-- default output signals
					fpga_output_enable_o         <= '0';
					umft601a_control_o.reset_n   <= '1';
					umft601a_control_o.wr_n      <= '1';
					umft601a_control_o.rd_n      <= '1';
					umft601a_control_o.oe_n      <= '1';
					umft601a_control_o.siwu_n    <= '1';
					umft601a_control_o.wakeup_n  <= '1';
					umft601a_control_o.gpio      <= (others => '1');
					umft601a_tx_data_o.data      <= (others => '0');
					umft601a_tx_data_o.be        <= (others => '0');
					data_fifo_wr_control_o.wrreq <= '0';
					data_fifo_wr_data_o.data     <= (others => '0');
					data_fifo_wr_data_o.be       <= (others => '0');
					data_fifo_rd_control_o.rdreq <= '0';
				-- conditional output signals

				-- state "ACTIVATE_UMFT_OE"
				when ACTIVATE_UMFT_OE =>
					-- activate output enable for the UMFT601A module (for receiving)
					-- default output signals
					fpga_output_enable_o         <= '0';
					umft601a_control_o.reset_n   <= '1';
					umft601a_control_o.wr_n      <= '1';
					umft601a_control_o.rd_n      <= '1';
					umft601a_control_o.oe_n      <= '0';
					umft601a_control_o.siwu_n    <= '1';
					umft601a_control_o.wakeup_n  <= '1';
					umft601a_control_o.gpio      <= (others => '1');
					umft601a_tx_data_o.data      <= (others => '0');
					umft601a_tx_data_o.be        <= (others => '0');
					data_fifo_wr_control_o.wrreq <= '0';
					data_fifo_wr_data_o.data     <= (others => '0');
					data_fifo_wr_data_o.be       <= (others => '0');
					data_fifo_rd_control_o.rdreq <= '0';
				-- conditional output signals

				-- state "FETCH_RX_DATA"
				when FETCH_RX_DATA =>
					-- fetch the rx data from the UMFT601A module
					-- default output signals
					fpga_output_enable_o         <= '0';
					umft601a_control_o.reset_n   <= '1';
					umft601a_control_o.wr_n      <= '1';
					umft601a_control_o.rd_n      <= '1';
					umft601a_control_o.oe_n      <= '0';
					umft601a_control_o.siwu_n    <= '1';
					umft601a_control_o.wakeup_n  <= '1';
					umft601a_control_o.gpio      <= (others => '1');
					umft601a_tx_data_o.data      <= (others => '0');
					umft601a_tx_data_o.be        <= (others => '0');
					data_fifo_wr_control_o.wrreq <= '0';
					data_fifo_wr_data_o.data     <= (others => '0');
					data_fifo_wr_data_o.be       <= (others => '0');
					data_fifo_rd_control_o.rdreq <= '0';
				-- conditional output signals

				-- state "RECEIVING"
				when RECEIVING =>
					-- receive rx data and write in the data fifo
					-- default output signals
					fpga_output_enable_o         <= '0';
					umft601a_control_o.reset_n   <= '1';
					umft601a_control_o.wr_n      <= '1';
					umft601a_control_o.rd_n      <= '0';
					umft601a_control_o.oe_n      <= '0';
					umft601a_control_o.siwu_n    <= '1';
					umft601a_control_o.wakeup_n  <= '1';
					umft601a_control_o.gpio      <= (others => '1');
					umft601a_tx_data_o.data      <= (others => '0');
					umft601a_tx_data_o.be        <= (others => '0');
					data_fifo_wr_control_o.wrreq <= '0';
					data_fifo_wr_data_o.data     <= (others => '0');
					data_fifo_wr_data_o.be       <= (others => '0');
					data_fifo_rd_control_o.rdreq <= '0';
					-- conditional output signals
					-- check if the UMFT601A module have rx data and the data fifo can receive
					if ((umft601a_status_i.rxf_n = '0') and (data_fifo_wr_status_i.wrfull = '0')) then
						-- UMFT601A module have rx data and the data fifo can receive
						umft601a_control_o.rd_n      <= '0';
						umft601a_control_o.oe_n      <= '0';
						data_fifo_wr_control_o.wrreq <= '1';
						data_fifo_wr_data_o.data     <= umft601a_rx_data_i.data;
						data_fifo_wr_data_o.be       <= umft601a_rx_data_i.be;
					end if;

				-- state "DELAY_TX"
				when DELAY_TX =>
					-- 3 clock cicle delay for UMFT601A module (for tx)
					-- default output signals
					fpga_output_enable_o         <= '0';
					umft601a_control_o.reset_n   <= '1';
					umft601a_control_o.wr_n      <= '1';
					umft601a_control_o.rd_n      <= '1';
					umft601a_control_o.oe_n      <= '1';
					umft601a_control_o.siwu_n    <= '1';
					umft601a_control_o.wakeup_n  <= '1';
					umft601a_control_o.gpio      <= (others => '1');
					umft601a_tx_data_o.data      <= (others => '0');
					umft601a_tx_data_o.be        <= (others => '0');
					data_fifo_wr_control_o.wrreq <= '0';
					data_fifo_wr_data_o.data     <= (others => '0');
					data_fifo_wr_data_o.be       <= (others => '0');
					data_fifo_rd_control_o.rdreq <= '0';
				-- conditional output signals

				-- state "ACTIVATE_FPGA_OE"
				when ACTIVATE_FPGA_OE =>
					-- activate the output enable for the FPGA (for transmitting)
					-- default output signals
					fpga_output_enable_o         <= '1';
					umft601a_control_o.reset_n   <= '1';
					umft601a_control_o.wr_n      <= '1';
					umft601a_control_o.rd_n      <= '1';
					umft601a_control_o.oe_n      <= '1';
					umft601a_control_o.siwu_n    <= '1';
					umft601a_control_o.wakeup_n  <= '1';
					umft601a_control_o.gpio      <= (others => '1');
					umft601a_tx_data_o.data      <= (others => '0');
					umft601a_tx_data_o.be        <= (others => '0');
					data_fifo_wr_control_o.wrreq <= '0';
					data_fifo_wr_data_o.data     <= (others => '0');
					data_fifo_wr_data_o.be       <= (others => '0');
					data_fifo_rd_control_o.rdreq <= '0';
				-- conditional output signals

				-- state "FETCH_TX_DATA"
				when FETCH_TX_DATA =>
					-- fetch the tx data from the DC DATA FIFO
					-- default output signals
					fpga_output_enable_o         <= '1';
					umft601a_control_o.reset_n   <= '1';
					umft601a_control_o.wr_n      <= '1';
					umft601a_control_o.rd_n      <= '1';
					umft601a_control_o.oe_n      <= '1';
					umft601a_control_o.siwu_n    <= '1';
					umft601a_control_o.wakeup_n  <= '1';
					umft601a_control_o.gpio      <= (others => '1');
					umft601a_tx_data_o.data      <= (others => '0');
					umft601a_tx_data_o.be        <= (others => '0');
					data_fifo_wr_control_o.wrreq <= '0';
					data_fifo_wr_data_o.data     <= (others => '0');
					data_fifo_wr_data_o.be       <= (others => '0');
					data_fifo_rd_control_o.rdreq <= '0';
				-- conditional output signals

				-- state "TRANSMITTING"
				when TRANSMITTING =>
					-- read from data fifo and write tx data
					-- default output signals
					fpga_output_enable_o         <= '1';
					umft601a_control_o.reset_n   <= '1';
					umft601a_control_o.wr_n      <= '1';
					umft601a_control_o.rd_n      <= '1';
					umft601a_control_o.oe_n      <= '1';
					umft601a_control_o.siwu_n    <= '1';
					umft601a_control_o.wakeup_n  <= '1';
					umft601a_control_o.gpio      <= (others => '1');
					umft601a_tx_data_o.data      <= (others => '0');
					umft601a_tx_data_o.be        <= (others => '0');
					data_fifo_wr_control_o.wrreq <= '0';
					data_fifo_wr_data_o.data     <= (others => '0');
					data_fifo_wr_data_o.be       <= (others => '0');
					data_fifo_rd_control_o.rdreq <= '0';
					-- conditional output signals
					-- check if the UMFT601A module can transmit and the data fifo have data
					--if ((umft601a_status_i.txe_n = '0') and (data_fifo_rd_status_i.rdempty = '0')) then
					if (data_fifo_rd_status_i.rdempty = '0') then
						-- UMFT601A module can transmit and the data fifo have data
						data_fifo_rd_control_o.rdreq <= '1';
						umft601a_control_o.wr_n      <= '0';
						umft601a_tx_data_o.data      <= data_fifo_rd_data_i.data;
						umft601a_tx_data_o.be        <= data_fifo_rd_data_i.be;
					end if;

				-- all the other states (not defined)
				when others =>
					null;

			end case;

		end if;

	end process p_ftdi_umft601a_controller;

	-- signals assingments

end architecture RTL;
