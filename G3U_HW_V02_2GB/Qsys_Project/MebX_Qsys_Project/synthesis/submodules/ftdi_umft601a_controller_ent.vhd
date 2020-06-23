library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ftdi_umft601a_controller_ent is
	port(
		clk_i                         : in    std_logic;
		ftdi_clk_i                    : in    std_logic;
		rst_i                         : in    std_logic;
		-- ftdi module control inputs
		ftdi_module_clear_i           : in    std_logic;
		ftdi_module_stop_i            : in    std_logic;
		ftdi_module_start_i           : in    std_logic;
		-- umft601a input pins
		umft_rxf_n_pin_i              : in    std_logic                     := '1';
		umft_clock_pin_i              : in    std_logic                     := '1';
		umft_txe_n_pin_i              : in    std_logic                     := '1';
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
		tx_dc_data_fifo_wrusedw_o     : out   std_logic_vector(11 downto 0);
		-- rx dc data fifo output pins (fpga <-- umft601a)
		rx_dc_data_fifo_rddata_data_o : out   std_logic_vector(31 downto 0);
		rx_dc_data_fifo_rddata_be_o   : out   std_logic_vector(3 downto 0);
		rx_dc_data_fifo_rdempty_o     : out   std_logic;
		rx_dc_data_fifo_rdfull_o      : out   std_logic;
		rx_dc_data_fifo_rdusedw_o     : out   std_logic_vector(11 downto 0)
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
		aclr        : std_logic;
		rdreq       : std_logic;
		rddata_data : std_logic_vector(31 downto 0);
		rddata_be   : std_logic_vector(3 downto 0);
		rdempty     : std_logic;
		rdfull      : std_logic;
		rdusedw     : std_logic_vector(11 downto 0);
	end record t_tx_dc_data_fifo;

	-- tx dc data fifo signals
	signal s_tx_dc_data_fifo : t_tx_dc_data_fifo;

	-- rx dc data fifo record type
	type t_rx_dc_data_fifo is record
		aclr        : std_logic;
		wrdata_data : std_logic_vector(31 downto 0);
		wrdata_be   : std_logic_vector(3 downto 0);
		wrreq       : std_logic;
		wrempty     : std_logic;
		wrfull      : std_logic;
		wrusedw     : std_logic_vector(11 downto 0);
	end record t_rx_dc_data_fifo;

	-- rx dc data fifo signals
	signal s_rx_dc_data_fifo : t_rx_dc_data_fifo;

	-- ftdi umft601a controller fsm type
	type t_ftdi_umft601a_controller_fsm is (
		STOPPED,
		IDLE,
		RX_DELAY,
		RX_ACTIVATE_UMFT_OE,
		RX_FETCH,
		RX_WRITING,
		TX_DELAY,
		TX_ACTIVATE_FPGA_OE,
		TX_FETCH,
		TX_INTERRUPTED,
		TX_TRANSMITTING,
		TX_FILLING
	);

	-- ftdi umft601a controller fsm state
	signal s_ftdi_umft601a_controller_state : t_ftdi_umft601a_controller_fsm;

	-- io buffers signals
	signal s_io_inout_buffer_output_enable : std_logic;

	signal s_delay_cnt : natural range 0 to 2 := 0;

	--	signal s_umft601a_clock : std_logic;

	signal s_rx_wrreq_protected : std_logic;
	signal s_tx_rdreq_protected : std_logic;

	signal s_rx_rd_n_protected : std_logic;
	signal s_tx_wr_n_protected : std_logic;

	signal s_tx_be_protected   : std_logic_vector(3 downto 0);
	signal s_tx_data_protected : std_logic_vector(31 downto 0);

	signal s_tx_priority         : std_logic; -- '0': bus priority is with the Rx / '1': bus priority is with the Tx
	signal s_tx_interrupted      : std_logic;
	signal s_tx_interrupted_be   : std_logic_vector(3 downto 0);
	signal s_tx_interrupted_data : std_logic_vector(31 downto 0);

	signal s_rx_dc_be_little_endian   : std_logic_vector(3 downto 0);
	signal s_rx_dc_data_little_endian : std_logic_vector(31 downto 0);
	signal s_tx_dc_be_little_endian   : std_logic_vector(3 downto 0);
	signal s_tx_dc_data_little_endian : std_logic_vector(31 downto 0);

	signal s_tx_dc_extended_wrusedw : std_logic_vector((s_tx_dc_data_fifo.rdusedw'length) downto 0);
	signal s_rx_dc_extended_wrusedw : std_logic_vector((s_rx_dc_data_fifo.wrusedw'length) downto 0);

	signal s_synchronized_clear : std_logic;
	signal s_synchronized_start : std_logic;
	signal s_synchronized_stop  : std_logic;

	signal s_tx_words_cnt : natural range 0 to 1024;

begin

	-- tx dc data fifo instantiation, for data synchronization (fpga --> umft601a)
	ftdi_tx_data_dc_fifo_inst : entity work.ftdi_data_dc_fifo
		port map(
			aclr              => s_tx_dc_data_fifo.aclr,
			data(35 downto 4) => tx_dc_data_fifo_wrdata_data_i,
			data(3 downto 0)  => tx_dc_data_fifo_wrdata_be_i,
			rdclk             => ftdi_clk_i,
			rdreq             => s_tx_rdreq_protected,
			wrclk             => clk_i,
			wrreq             => tx_dc_data_fifo_wrreq_i,
			q(35 downto 4)    => s_tx_dc_data_fifo.rddata_data,
			q(3 downto 0)     => s_tx_dc_data_fifo.rddata_be,
			--			q(35 downto 4)    => s_umft601a_buffered_pins.data_out,
			--			q(3 downto 0)     => s_umft601a_buffered_pins.be_out,
			--			q(35 downto 4)    => s_tx_dc_data_little_endian,
			--			q(3 downto 0)     => s_tx_dc_be_little_endian,
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
			aclr              => s_rx_dc_data_fifo.aclr,
			data(35 downto 4) => s_rx_dc_data_fifo.wrdata_data,
			data(3 downto 0)  => s_rx_dc_data_fifo.wrdata_be,
			--			data(35 downto 4) => s_umft601a_buffered_pins.data_in,
			--			data(3 downto 0)  => s_umft601a_buffered_pins.be_in,
			--			data(35 downto 4) => s_rx_dc_data_little_endian,
			--			data(3 downto 0)  => s_rx_dc_be_little_endian,
			rdclk             => clk_i,
			rdreq             => rx_dc_data_fifo_rdreq_i,
			wrclk             => ftdi_clk_i,
			wrreq             => s_rx_wrreq_protected,
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
			datain(38 downto 7)  => s_tx_data_protected,
			datain(6)            => s_umft601a_buffered_pins.wakeup_n_out,
			datain(5 downto 2)   => s_tx_be_protected,
			datain(1 downto 0)   => s_umft601a_buffered_pins.gpio_out,
			oe(38)               => s_io_inout_buffer_output_enable,
			oe(37)               => s_io_inout_buffer_output_enable,
			oe(36)               => s_io_inout_buffer_output_enable,
			oe(35)               => s_io_inout_buffer_output_enable,
			oe(34)               => s_io_inout_buffer_output_enable,
			oe(33)               => s_io_inout_buffer_output_enable,
			oe(32)               => s_io_inout_buffer_output_enable,
			oe(31)               => s_io_inout_buffer_output_enable,
			oe(30)               => s_io_inout_buffer_output_enable,
			oe(29)               => s_io_inout_buffer_output_enable,
			oe(28)               => s_io_inout_buffer_output_enable,
			oe(27)               => s_io_inout_buffer_output_enable,
			oe(26)               => s_io_inout_buffer_output_enable,
			oe(25)               => s_io_inout_buffer_output_enable,
			oe(24)               => s_io_inout_buffer_output_enable,
			oe(23)               => s_io_inout_buffer_output_enable,
			oe(22)               => s_io_inout_buffer_output_enable,
			oe(21)               => s_io_inout_buffer_output_enable,
			oe(20)               => s_io_inout_buffer_output_enable,
			oe(19)               => s_io_inout_buffer_output_enable,
			oe(18)               => s_io_inout_buffer_output_enable,
			oe(17)               => s_io_inout_buffer_output_enable,
			oe(16)               => s_io_inout_buffer_output_enable,
			oe(15)               => s_io_inout_buffer_output_enable,
			oe(14)               => s_io_inout_buffer_output_enable,
			oe(13)               => s_io_inout_buffer_output_enable,
			oe(12)               => s_io_inout_buffer_output_enable,
			oe(11)               => s_io_inout_buffer_output_enable,
			oe(10)               => s_io_inout_buffer_output_enable,
			oe(9)                => s_io_inout_buffer_output_enable,
			oe(8)                => s_io_inout_buffer_output_enable,
			oe(7)                => s_io_inout_buffer_output_enable,
			oe(6)                => s_io_inout_buffer_output_enable,
			oe(5)                => s_io_inout_buffer_output_enable,
			oe(4)                => s_io_inout_buffer_output_enable,
			oe(3)                => s_io_inout_buffer_output_enable,
			oe(2)                => s_io_inout_buffer_output_enable,
			oe(1)                => s_io_inout_buffer_output_enable,
			oe(0)                => s_io_inout_buffer_output_enable,
			dataio(38 downto 7)  => umft_data_bus_io,
			dataio(6)            => umft_wakeup_n_pin_io,
			dataio(5 downto 2)   => umft_be_bus_io,
			dataio(1 downto 0)   => umft_gpio_bus_io,
			dataout(38 downto 7) => s_umft601a_buffered_pins.data_in,
			dataout(6)           => s_umft601a_buffered_pins.wakeup_n_in,
			dataout(5 downto 2)  => s_umft601a_buffered_pins.be_in,
			dataout(1 downto 0)  => s_umft601a_buffered_pins.gpio_in
		);

	-- output io buffer instantiation, for the umft601a module pins (fpga --> umft601a)
	ftdi_out_io_buffer_5b_inst : entity work.ftdi_out_io_buffer_5b
		port map(
			datain(4)  => s_umft601a_buffered_pins.reset_n,
			datain(3)  => s_tx_wr_n_protected,
			datain(2)  => s_rx_rd_n_protected,
			datain(1)  => s_umft601a_buffered_pins.oe_n,
			datain(0)  => s_umft601a_buffered_pins.siwu_n,
			dataout(4) => umft_reset_n_pin_o,
			dataout(3) => umft_wr_n_pin_o,
			dataout(2) => umft_rd_n_pin_o,
			dataout(1) => umft_oe_n_pin_o,
			dataout(0) => umft_siwu_n_pin_o
		);

	-- flip-flop_synchronizer instantiation, for the ftdi module control inputs (fpga --> umft601a)
	flipflop_synchronizer_inst : entity work.flipflop_synchronizer_ent

		generic map(
			g_SYNCHRONIZED_SIGNAL_WIDTH => 3,
			g_SYNCHRONIZATION_STAGES    => 3
		)
		port map(
			wrclk_i     => clk_i,
			rdclk_i     => ftdi_clk_i,
			rst_i       => rst_i,
			rstsig_i(0) => '0',
			rstsig_i(1) => '0',
			rstsig_i(2) => '0',
			wrsig_i(0)  => ftdi_module_clear_i,
			wrsig_i(1)  => ftdi_module_stop_i,
			wrsig_i(2)  => ftdi_module_start_i,
			rdsig_o(0)  => s_synchronized_clear,
			rdsig_o(1)  => s_synchronized_stop,
			rdsig_o(2)  => s_synchronized_start
		);

	-- ftdi umft601a controller fsm process (245 Synchronous FIFO mode Protocols)
	p_ftdi_umft601a_controller : process(ftdi_clk_i, rst_i)
		variable v_ftdi_umft601a_controller_state : t_ftdi_umft601a_controller_fsm; -- current state
	begin
		-- on asynchronous reset in any state we jump to the idle state
		if (rst_i = '1') then
			-- states
			s_ftdi_umft601a_controller_state      <= IDLE;
			v_ftdi_umft601a_controller_state      := IDLE;
			-- internal signals
			s_delay_cnt                           <= 0;
			s_tx_priority                         <= '0';
			s_tx_interrupted                      <= '0';
			s_tx_interrupted_data                 <= (others => '0');
			s_tx_interrupted_be                   <= (others => '0');
			s_tx_words_cnt                        <= 0;
			-- outputs
			s_io_inout_buffer_output_enable       <= '0';
			s_umft601a_buffered_pins.wakeup_n_out <= '1';
			s_umft601a_buffered_pins.gpio_out     <= (others => '1');
			s_umft601a_buffered_pins.wr_n         <= '1';
			s_umft601a_buffered_pins.rd_n         <= '1';
			s_umft601a_buffered_pins.oe_n         <= '1';
			s_umft601a_buffered_pins.siwu_n       <= '1';
			s_tx_dc_data_fifo.rdreq               <= '0';
			s_rx_dc_data_fifo.wrreq               <= '0';
		elsif (rising_edge(ftdi_clk_i)) then

			-- States transitions FSM
			case (s_ftdi_umft601a_controller_state) is

				-- state "STOPPED"
				when STOPPED =>
					-- umft601a controller stopped
					-- default state transition
					s_ftdi_umft601a_controller_state <= STOPPED;
					v_ftdi_umft601a_controller_state := STOPPED;
					-- default internal signal values
					s_delay_cnt                      <= 0;
					s_tx_priority                    <= '0';
					s_tx_interrupted                 <= '0';
					s_tx_interrupted_data            <= (others => '0');
					s_tx_interrupted_be              <= (others => '0');
					s_tx_words_cnt                   <= 0;
					-- conditional state transition and internal signal values
					-- check if a start was issued
					if (s_synchronized_start = '1') then
						s_ftdi_umft601a_controller_state <= IDLE;
						v_ftdi_umft601a_controller_state := IDLE;
					end if;

				-- state "IDLE"
				when IDLE =>
					-- wait until a transaction can happen
					-- default state transition
					s_ftdi_umft601a_controller_state <= IDLE;
					v_ftdi_umft601a_controller_state := IDLE;
					-- default internal signal values
					s_delay_cnt                      <= 0;
					s_tx_words_cnt                   <= 0;
					-- conditional state transition and internal signal values
					if (s_tx_priority = '0') then
						-- check if the UMFT601A module have rx data and the rx dc fifo can receive
						if ((s_umft601a_buffered_pins.rxf_n = '0')) then
							-- UMFT601A module have rx data and the rx dc fifo can receive
							s_ftdi_umft601a_controller_state <= RX_DELAY;
							v_ftdi_umft601a_controller_state := RX_DELAY;
							s_delay_cnt                      <= 1;
						-- check if the UMFT601A module can receive tx data and the tx dc fifo have data
						elsif ((s_umft601a_buffered_pins.txe_n = '0')) then
							-- UMFT601A module can receive tx data and the tx dc fifo have data
							s_ftdi_umft601a_controller_state <= TX_DELAY;
							v_ftdi_umft601a_controller_state := TX_DELAY;
							s_delay_cnt                      <= 1;
						end if;
					else
						-- check if the UMFT601A module can receive tx data and the tx dc fifo have data
						if ((s_umft601a_buffered_pins.txe_n = '0')) then
							-- UMFT601A module can receive tx data and the tx dc fifo have data
							s_ftdi_umft601a_controller_state <= TX_DELAY;
							v_ftdi_umft601a_controller_state := TX_DELAY;
							s_delay_cnt                      <= 1;
						-- check if the UMFT601A module have rx data and the rx dc fifo can receive
						elsif ((s_umft601a_buffered_pins.rxf_n = '0')) then
							-- UMFT601A module have rx data and the rx dc fifo can receive
							s_ftdi_umft601a_controller_state <= RX_DELAY;
							v_ftdi_umft601a_controller_state := RX_DELAY;
							s_delay_cnt                      <= 1;
						end if;
					end if;

				-- state "RX_DELAY"
				when RX_DELAY =>
					-- 2 clock cicle delay for UMFT601A module (for rx)
					-- default state transition
					s_ftdi_umft601a_controller_state <= RX_DELAY;
					v_ftdi_umft601a_controller_state := RX_DELAY;
					-- default internal signal values
					s_delay_cnt                      <= 0;
					s_tx_priority                    <= '1';
					s_tx_words_cnt                   <= 0;
					-- conditional state transition and internal signal values
					-- check if the delay is finished
					if (s_delay_cnt > 0) then
						-- delay has not finished yet
						s_delay_cnt <= s_delay_cnt - 1;
					else
						-- delay finished, go to output enable
						s_ftdi_umft601a_controller_state <= RX_ACTIVATE_UMFT_OE;
						v_ftdi_umft601a_controller_state := RX_ACTIVATE_UMFT_OE;
						-- check if there is space in the rx fifo to receive a full transfer (4kiB)
						if (unsigned(s_rx_dc_extended_wrusedw) > ((2 ** s_rx_dc_data_fifo.wrusedw'length) - 1024 - 1)) then
							s_ftdi_umft601a_controller_state <= IDLE;
							v_ftdi_umft601a_controller_state := IDLE;
						end if;
					end if;

				-- state "RX_ACTIVATE_UMFT_OE"
				when RX_ACTIVATE_UMFT_OE =>
					-- activate output enable for the UMFT601A module (for receiving)
					-- default state transition
					s_ftdi_umft601a_controller_state <= RX_FETCH;
					v_ftdi_umft601a_controller_state := RX_FETCH;
					-- default internal signal values
					s_delay_cnt                      <= 0;
					s_tx_priority                    <= '1';
					s_tx_words_cnt                   <= 0;
				-- conditional state transition and internal signal values

				-- state "RX_FETCH"
				when RX_FETCH =>
					-- fethc rx data from the UMFT601A module
					-- default state transition
					s_ftdi_umft601a_controller_state <= RX_WRITING;
					v_ftdi_umft601a_controller_state := RX_WRITING;
					-- default internal signal values
					s_delay_cnt                      <= 0;
					s_tx_priority                    <= '1';
					s_tx_words_cnt                   <= 0;

				-- state "RX_WRITING"
				when RX_WRITING =>
					-- write rx data in the rx dc fifo
					-- default state transition
					s_ftdi_umft601a_controller_state <= IDLE;
					v_ftdi_umft601a_controller_state := IDLE;
					-- default internal signal values
					s_delay_cnt                      <= 0;
					s_tx_priority                    <= '1';
					s_tx_words_cnt                   <= 0;
					-- conditional state transition and internal signal values
					-- check if the UMFT601A module still have rx data and the rx dc fifo can still receive
					if ((s_umft601a_buffered_pins.rxf_n = '0')) then
						-- UMFT601A module still have rx data and the rx dc fifo still can receive
						s_ftdi_umft601a_controller_state <= RX_WRITING;
						v_ftdi_umft601a_controller_state := RX_WRITING;
					end if;

				-- state "TX_DELAY"
				when TX_DELAY =>
					-- 2 clock cicle delay for UMFT601A module (for tx)
					-- default state transition
					s_ftdi_umft601a_controller_state <= TX_DELAY;
					v_ftdi_umft601a_controller_state := TX_DELAY;
					-- default internal signal values
					s_delay_cnt                      <= 0;
					s_tx_priority                    <= '0';
					s_tx_words_cnt                   <= 0;
					-- conditional state transition and internal signal values
					-- check if the delay is finished
					if (s_delay_cnt > 0) then
						-- delay has not finished yet
						s_delay_cnt <= s_delay_cnt - 1;
					else
						-- delay finished, go to output enable
						s_ftdi_umft601a_controller_state <= TX_ACTIVATE_FPGA_OE;
						v_ftdi_umft601a_controller_state := TX_ACTIVATE_FPGA_OE;
						-- check if the tx dc fifo is empty
						if (s_tx_dc_data_fifo.rdempty = '1') then
							-- tx dc fifo is empty, return to idle
							s_ftdi_umft601a_controller_state <= IDLE;
							v_ftdi_umft601a_controller_state := IDLE;
						end if;
					end if;

				-- state "TX_ACTIVATE_FPGA_OE"
				when TX_ACTIVATE_FPGA_OE =>
					-- activate the output enable for the FPGA (for transmitting)
					-- default state transition
					s_ftdi_umft601a_controller_state <= TX_FETCH;
					v_ftdi_umft601a_controller_state := TX_FETCH;
					-- default internal signal values
					s_delay_cnt                      <= 0;
					s_tx_priority                    <= '0';
					s_tx_words_cnt                   <= 0;
					-- conditional state transition and internal signal values
					-- check if the transmission was previously interrupted
					if (s_tx_interrupted = '1') then
						-- transmission was previously interrupted
						s_ftdi_umft601a_controller_state <= TX_INTERRUPTED;
						v_ftdi_umft601a_controller_state := TX_INTERRUPTED;
					end if;

				-- state "TX_FETCH"
				when TX_FETCH =>
					-- fetch tx data
					-- default state transition
					s_ftdi_umft601a_controller_state <= TX_TRANSMITTING;
					v_ftdi_umft601a_controller_state := TX_TRANSMITTING;
					-- default internal signal values
					s_delay_cnt                      <= 0;
					s_tx_priority                    <= '0';
					--					s_tx_words_cnt                   <= 1023;
					--					s_tx_words_cnt                   <= 511;
					s_tx_words_cnt                   <= 1019;
				-- conditional state transition and internal signal values

				-- state "TX_INTERRUPTED"
				when TX_INTERRUPTED =>
					-- transmit previously tx data
					-- default state transition
					s_ftdi_umft601a_controller_state <= TX_TRANSMITTING;
					v_ftdi_umft601a_controller_state := TX_TRANSMITTING;
					-- default internal signal values
					s_delay_cnt                      <= 0;
					s_tx_priority                    <= '0';
					s_tx_interrupted                 <= '0';
					s_tx_interrupted_data            <= (others => '0');
					s_tx_interrupted_be              <= (others => '0');
					--					s_tx_words_cnt                   <= 1022;
					--					s_tx_words_cnt                   <= 510;
					s_tx_words_cnt                   <= 1018;
				-- conditional state transition and internal signal values

				-- state "TX_TRANSMITTING"
				when TX_TRANSMITTING =>
					-- transmit tx data
					-- default state transition
					s_ftdi_umft601a_controller_state <= IDLE;
					v_ftdi_umft601a_controller_state := IDLE;
					-- default internal signal values
					s_delay_cnt                      <= 0;
					s_tx_priority                    <= '0';
					s_tx_interrupted                 <= '0';
					s_tx_words_cnt                   <= 0;
					-- conditional state transition and internal signal values
					-- check if there is still data in the tx dc fifo
					if (s_tx_dc_data_fifo.rdempty = '1') then
						-- tx dc fifo still have no more data
						s_ftdi_umft601a_controller_state <= TX_FILLING;
						v_ftdi_umft601a_controller_state := TX_FILLING;
					--						s_tx_words_cnt                   <= s_tx_words_cnt - 1;
					else
						-- check if the umft601a module can still receive data and if the tx words are not over (force each write to have a maximum of 4096 Bytes)
						if ((s_umft601a_buffered_pins.txe_n = '0') and (s_tx_words_cnt > 0)) then
							--						if ((s_umft601a_buffered_pins.txe_n = '0')) then
							-- umft601a module can still receive data
							s_ftdi_umft601a_controller_state <= TX_TRANSMITTING;
							v_ftdi_umft601a_controller_state := TX_TRANSMITTING;
							s_tx_words_cnt                   <= s_tx_words_cnt - 1;
						--						-- check if the umft601a module can still receive data and if the tx words are over (force each write to have a maximum of 4096 Bytes)
						--						elsif ((s_umft601a_buffered_pins.txe_n = '0') and (s_tx_words_cnt = 0)) then
						--							s_ftdi_umft601a_controller_state <= IDLE;
						--							v_ftdi_umft601a_controller_state := IDLE;
						else
							s_tx_interrupted      <= '1';
							s_tx_interrupted_data <= s_tx_dc_data_fifo.rddata_data;
							s_tx_interrupted_be   <= s_tx_dc_data_fifo.rddata_be;
							if (s_tx_words_cnt = 0) then
								s_ftdi_umft601a_controller_state <= TX_FILLING;
								v_ftdi_umft601a_controller_state := TX_FILLING;
							end if;
						end if;
					end if;

				-- state "TX_FILLING"
				when TX_FILLING =>
					-- fill tx data
					-- default state transition
					s_ftdi_umft601a_controller_state <= IDLE;
					v_ftdi_umft601a_controller_state := IDLE;
					-- default internal signal values
					s_delay_cnt                      <= 0;
					s_tx_priority                    <= '0';
					s_tx_words_cnt                   <= 0;
					-- conditional state transition and internal signal values
					-- check if the umft601a module can still receive data and if the tx words are not over (force each write to have a maximum of 4096 Bytes)
					--					if ((s_umft601a_buffered_pins.txe_n = '0') and (s_tx_words_cnt > 0)) then
					if ((s_umft601a_buffered_pins.txe_n = '0')) then
						--					if ((s_umft601a_buffered_pins.txe_n = '0')) then
						-- umft601a module can still receive data
						s_ftdi_umft601a_controller_state <= TX_FILLING;
						v_ftdi_umft601a_controller_state := TX_FILLING;
						--						s_tx_words_cnt                   <= s_tx_words_cnt - 1;
					end if;

				-- all the other states (not defined)
				when others =>
					-- jump to save state (ERROR?!)
					s_ftdi_umft601a_controller_state <= IDLE;
					v_ftdi_umft601a_controller_state := IDLE;

			end case;

			-- check if a stop command was issued
			if (s_synchronized_stop = '1') then
				--				s_ftdi_umft601a_controller_state <= STOPPED;
				--				v_ftdi_umft601a_controller_state := STOPPED;
				null;
			-- check if a clear command was issued
			elsif (s_synchronized_clear = '1') then
				s_ftdi_umft601a_controller_state <= IDLE;
				v_ftdi_umft601a_controller_state := IDLE;
			end if;

			-- Output generation FSM
			case (v_ftdi_umft601a_controller_state) is

				-- state "STOPPED"
				when STOPPED =>
					-- umft601a controller stopped
					-- default output signals
					s_io_inout_buffer_output_enable       <= '0';
					s_umft601a_buffered_pins.wakeup_n_out <= '1';
					s_umft601a_buffered_pins.gpio_out     <= (others => '1');
					s_umft601a_buffered_pins.wr_n         <= '1';
					s_umft601a_buffered_pins.rd_n         <= '1';
					s_umft601a_buffered_pins.oe_n         <= '1';
					s_umft601a_buffered_pins.siwu_n       <= '1';
					s_tx_dc_data_fifo.rdreq               <= '0';
					s_tx_dc_data_little_endian            <= (others => '0');
					s_tx_dc_be_little_endian              <= (others => '0');
					s_rx_dc_data_fifo.wrreq               <= '0';
					s_rx_dc_data_fifo.wrdata_data         <= (others => '0');
					s_rx_dc_data_fifo.wrdata_be           <= (others => '0');
				-- conditional output signals

				-- state "IDLE"
				when IDLE =>
					-- wait until a transaction can happen
					-- default output signals
					s_io_inout_buffer_output_enable       <= '0';
					s_umft601a_buffered_pins.wakeup_n_out <= '1';
					s_umft601a_buffered_pins.gpio_out     <= (others => '1');
					s_umft601a_buffered_pins.wr_n         <= '1';
					s_umft601a_buffered_pins.rd_n         <= '1';
					s_umft601a_buffered_pins.oe_n         <= '1';
					s_umft601a_buffered_pins.siwu_n       <= '1';
					s_tx_dc_data_fifo.rdreq               <= '0';
					s_tx_dc_data_little_endian            <= (others => '0');
					s_tx_dc_be_little_endian              <= (others => '0');
					s_rx_dc_data_fifo.wrreq               <= '0';
					s_rx_dc_data_fifo.wrdata_data         <= (others => '0');
					s_rx_dc_data_fifo.wrdata_be           <= (others => '0');
				-- conditional output signals

				-- state "RX_DELAY"
				when RX_DELAY =>
					-- 2 clock cicle delay for UMFT601A module (for rx)
					-- default output signals
					s_io_inout_buffer_output_enable       <= '0';
					s_umft601a_buffered_pins.wakeup_n_out <= '1';
					s_umft601a_buffered_pins.gpio_out     <= (others => '1');
					s_umft601a_buffered_pins.wr_n         <= '1';
					s_umft601a_buffered_pins.rd_n         <= '1';
					s_umft601a_buffered_pins.oe_n         <= '1';
					s_umft601a_buffered_pins.siwu_n       <= '1';
					s_tx_dc_data_fifo.rdreq               <= '0';
					s_tx_dc_data_little_endian            <= (others => '0');
					s_tx_dc_be_little_endian              <= (others => '0');
					s_rx_dc_data_fifo.wrreq               <= '0';
					s_rx_dc_data_fifo.wrdata_data         <= (others => '0');
					s_rx_dc_data_fifo.wrdata_be           <= (others => '0');
				-- conditional output signals

				-- state "RX_ACTIVATE_UMFT_OE"
				when RX_ACTIVATE_UMFT_OE =>
					-- activate output enable for the UMFT601A module (for receiving)
					-- default output signals
					s_io_inout_buffer_output_enable       <= '0';
					s_umft601a_buffered_pins.wakeup_n_out <= '1';
					s_umft601a_buffered_pins.gpio_out     <= (others => '1');
					s_umft601a_buffered_pins.wr_n         <= '1';
					s_umft601a_buffered_pins.rd_n         <= '1';
					s_umft601a_buffered_pins.oe_n         <= '0';
					s_umft601a_buffered_pins.siwu_n       <= '1';
					s_tx_dc_data_fifo.rdreq               <= '0';
					s_tx_dc_data_little_endian            <= (others => '0');
					s_tx_dc_be_little_endian              <= (others => '0');
					s_rx_dc_data_fifo.wrreq               <= '0';
					s_rx_dc_data_fifo.wrdata_data         <= (others => '0');
					s_rx_dc_data_fifo.wrdata_be           <= (others => '0');
				-- conditional output signals

				-- state "RX_FETCH"
				when RX_FETCH =>
					-- fetch rx data in the rx dc fifo
					-- default output signals
					s_io_inout_buffer_output_enable       <= '0';
					s_umft601a_buffered_pins.wakeup_n_out <= '1';
					s_umft601a_buffered_pins.gpio_out     <= (others => '1');
					s_umft601a_buffered_pins.wr_n         <= '1';
					s_umft601a_buffered_pins.rd_n         <= '0';
					s_umft601a_buffered_pins.oe_n         <= '0';
					s_umft601a_buffered_pins.siwu_n       <= '1';
					s_tx_dc_data_fifo.rdreq               <= '0';
					s_tx_dc_data_little_endian            <= (others => '0');
					s_tx_dc_be_little_endian              <= (others => '0');
					s_rx_dc_data_fifo.wrreq               <= '0';
					s_rx_dc_data_fifo.wrdata_data         <= s_rx_dc_data_little_endian;
					s_rx_dc_data_fifo.wrdata_be           <= s_rx_dc_be_little_endian;
				-- conditional output signals

				-- state "RX_WRITING"
				when RX_WRITING =>
					-- write rx data in the rx dc fifo
					-- default output signals
					s_io_inout_buffer_output_enable       <= '0';
					s_umft601a_buffered_pins.wakeup_n_out <= '1';
					s_umft601a_buffered_pins.gpio_out     <= (others => '1');
					s_umft601a_buffered_pins.wr_n         <= '1';
					s_umft601a_buffered_pins.rd_n         <= '0';
					s_umft601a_buffered_pins.oe_n         <= '0';
					s_umft601a_buffered_pins.siwu_n       <= '1';
					s_tx_dc_data_fifo.rdreq               <= '0';
					s_tx_dc_data_little_endian            <= (others => '0');
					s_tx_dc_be_little_endian              <= (others => '0');
					s_rx_dc_data_fifo.wrreq               <= '1';
					s_rx_dc_data_fifo.wrdata_data         <= s_rx_dc_data_little_endian;
					s_rx_dc_data_fifo.wrdata_be           <= s_rx_dc_be_little_endian;
				-- conditional output signals

				-- state "TX_DELAY"
				when TX_DELAY =>
					-- 2 clock cicle delay for UMFT601A module (for tx)
					-- default output signals
					s_io_inout_buffer_output_enable       <= '0';
					s_umft601a_buffered_pins.wakeup_n_out <= '1';
					s_umft601a_buffered_pins.gpio_out     <= (others => '1');
					s_umft601a_buffered_pins.wr_n         <= '1';
					s_umft601a_buffered_pins.rd_n         <= '1';
					s_umft601a_buffered_pins.oe_n         <= '1';
					s_umft601a_buffered_pins.siwu_n       <= '1';
					s_tx_dc_data_fifo.rdreq               <= '0';
					s_tx_dc_data_little_endian            <= (others => '0');
					s_tx_dc_be_little_endian              <= (others => '0');
					s_rx_dc_data_fifo.wrreq               <= '0';
					s_rx_dc_data_fifo.wrdata_data         <= (others => '0');
					s_rx_dc_data_fifo.wrdata_be           <= (others => '0');
				-- conditional output signals

				-- state "TX_ACTIVATE_FPGA_OE"
				when TX_ACTIVATE_FPGA_OE =>
					-- activate the output enable for the FPGA (for transmitting)
					-- default output signals
					s_io_inout_buffer_output_enable       <= '1';
					s_umft601a_buffered_pins.wakeup_n_out <= '1';
					s_umft601a_buffered_pins.gpio_out     <= (others => '1');
					s_umft601a_buffered_pins.wr_n         <= '1';
					s_umft601a_buffered_pins.rd_n         <= '1';
					s_umft601a_buffered_pins.oe_n         <= '1';
					s_umft601a_buffered_pins.siwu_n       <= '1';
					s_tx_dc_data_fifo.rdreq               <= '0';
					s_tx_dc_data_little_endian            <= (others => '0');
					s_tx_dc_be_little_endian              <= (others => '0');
					s_rx_dc_data_fifo.wrreq               <= '0';
					s_rx_dc_data_fifo.wrdata_data         <= (others => '0');
					s_rx_dc_data_fifo.wrdata_be           <= (others => '0');
				-- conditional output signals

				-- state "TX_FETCH"
				when TX_FETCH =>
					-- fetch tx data
					-- default state dependent internal signals
					-- default output signals
					s_io_inout_buffer_output_enable       <= '1';
					s_umft601a_buffered_pins.wakeup_n_out <= '1';
					s_umft601a_buffered_pins.gpio_out     <= (others => '1');
					s_umft601a_buffered_pins.wr_n         <= '1';
					s_umft601a_buffered_pins.rd_n         <= '1';
					s_umft601a_buffered_pins.oe_n         <= '1';
					s_umft601a_buffered_pins.siwu_n       <= '1';
					s_tx_dc_data_fifo.rdreq               <= '1';
					s_tx_dc_data_little_endian            <= s_tx_dc_data_fifo.rddata_data;
					s_tx_dc_be_little_endian              <= s_tx_dc_data_fifo.rddata_be;
					s_rx_dc_data_fifo.wrreq               <= '0';
					s_rx_dc_data_fifo.wrdata_data         <= (others => '0');
					s_rx_dc_data_fifo.wrdata_be           <= (others => '0');

				-- state "TX_INTERRUPTED"
				when TX_INTERRUPTED =>
					-- transmit previously tx data
					-- default state dependent internal signals
					-- default output signals
					s_io_inout_buffer_output_enable       <= '1';
					s_umft601a_buffered_pins.wakeup_n_out <= '1';
					s_umft601a_buffered_pins.gpio_out     <= (others => '1');
					s_umft601a_buffered_pins.wr_n         <= '0';
					s_umft601a_buffered_pins.rd_n         <= '1';
					s_umft601a_buffered_pins.oe_n         <= '1';
					s_umft601a_buffered_pins.siwu_n       <= '1';
					s_tx_dc_data_fifo.rdreq               <= '1';
					s_tx_dc_data_little_endian            <= s_tx_interrupted_data;
					s_tx_dc_be_little_endian              <= s_tx_interrupted_be;
					s_rx_dc_data_fifo.wrreq               <= '0';
					s_rx_dc_data_fifo.wrdata_data         <= (others => '0');
					s_rx_dc_data_fifo.wrdata_be           <= (others => '0');

				-- state "TX_TRANSMITTING"
				when TX_TRANSMITTING =>
					-- transmit tx data
					-- default state dependent internal signals
					-- default output signals
					s_io_inout_buffer_output_enable       <= '1';
					s_umft601a_buffered_pins.wakeup_n_out <= '1';
					s_umft601a_buffered_pins.gpio_out     <= (others => '1');
					s_umft601a_buffered_pins.wr_n         <= '0';
					s_umft601a_buffered_pins.rd_n         <= '1';
					s_umft601a_buffered_pins.oe_n         <= '1';
					s_umft601a_buffered_pins.siwu_n       <= '1';
					s_tx_dc_data_fifo.rdreq               <= '1';
					s_tx_dc_data_little_endian            <= s_tx_dc_data_fifo.rddata_data;
					s_tx_dc_be_little_endian              <= s_tx_dc_data_fifo.rddata_be;
					s_rx_dc_data_fifo.wrreq               <= '0';
					s_rx_dc_data_fifo.wrdata_data         <= (others => '0');
					s_rx_dc_data_fifo.wrdata_be           <= (others => '0');

				-- state "TX_TRANSMITTING"
				when TX_FILLING =>
					-- fill tx data
					-- default state dependent internal signals
					-- default output signals
					s_io_inout_buffer_output_enable       <= '1';
					s_umft601a_buffered_pins.wakeup_n_out <= '1';
					s_umft601a_buffered_pins.gpio_out     <= (others => '1');
					s_umft601a_buffered_pins.wr_n         <= '0';
					s_umft601a_buffered_pins.rd_n         <= '1';
					s_umft601a_buffered_pins.oe_n         <= '1';
					s_umft601a_buffered_pins.siwu_n       <= '1';
					s_tx_dc_data_fifo.rdreq               <= '0';
					s_tx_dc_data_little_endian            <= (others => '0');
					s_tx_dc_be_little_endian              <= (others => '0');
					s_rx_dc_data_fifo.wrreq               <= '0';
					s_rx_dc_data_fifo.wrdata_data         <= (others => '0');
					s_rx_dc_data_fifo.wrdata_be           <= (others => '0');

			end case;

		end if;

	end process p_ftdi_umft601a_controller;

	-- signals assingments
	-- clock and reset assingments
	--	s_umft601a_clock                 <= (s_umft601a_buffered_pins.clock);
	s_umft601a_buffered_pins.reset_n <= not (rst_i);

	s_tx_dc_extended_wrusedw(s_tx_dc_data_fifo.rdusedw'length)                <= s_tx_dc_data_fifo.rdfull;
	s_tx_dc_extended_wrusedw((s_tx_dc_data_fifo.rdusedw'length - 1) downto 0) <= s_tx_dc_data_fifo.rdusedw;

	s_rx_dc_extended_wrusedw(s_rx_dc_data_fifo.wrusedw'length)                <= s_rx_dc_data_fifo.wrfull;
	s_rx_dc_extended_wrusedw((s_rx_dc_data_fifo.wrusedw'length - 1) downto 0) <= s_rx_dc_data_fifo.wrusedw;

	--	s_rx_wrreq_protected <= (s_rx_dc_data_fifo.wrreq) when (s_umft601a_buffered_pins.rxf_n = '0') else ('0');
	s_rx_wrreq_protected <= (s_rx_dc_data_fifo.wrreq);
	--	s_tx_rdreq_protected <= (s_tx_dc_data_fifo.rdreq) when ((s_umft601a_buffered_pins.txe_n = '0') and (s_tx_dc_data_fifo.rdempty = '0')) else ('0');
	s_tx_rdreq_protected <= (s_tx_dc_data_fifo.rdreq);

	--	s_rx_rd_n_protected <= (s_umft601a_buffered_pins.rd_n) when (s_umft601a_buffered_pins.rxf_n = '0') else ('1');
	s_rx_rd_n_protected <= (s_umft601a_buffered_pins.rd_n);
	--	s_tx_wr_n_protected <= (s_umft601a_buffered_pins.wr_n) when (s_umft601a_buffered_pins.txe_n = '0') else ('1');
	s_tx_wr_n_protected <= (s_umft601a_buffered_pins.wr_n);

	--	s_tx_be_protected   <= (s_umft601a_buffered_pins.be_out) when (s_tx_dc_data_fifo.rdempty = '0') else ("0000");
	s_tx_be_protected   <= (s_umft601a_buffered_pins.be_out);
	--	s_tx_data_protected <= (s_umft601a_buffered_pins.data_out) when (s_tx_dc_data_fifo.rdempty = '0') else (x"00000000");
	s_tx_data_protected <= (s_umft601a_buffered_pins.data_out);

	s_tx_dc_data_fifo.aclr <= (rst_i) or (s_synchronized_clear);
	s_rx_dc_data_fifo.aclr <= (rst_i) or (s_synchronized_clear);

	-- endianess correction
	s_umft601a_buffered_pins.data_out(31 downto 24) <= s_tx_dc_data_little_endian(7 downto 0);
	s_umft601a_buffered_pins.data_out(23 downto 16) <= s_tx_dc_data_little_endian(15 downto 8);
	s_umft601a_buffered_pins.data_out(15 downto 8)  <= s_tx_dc_data_little_endian(23 downto 16);
	s_umft601a_buffered_pins.data_out(7 downto 0)   <= s_tx_dc_data_little_endian(31 downto 24);
	s_umft601a_buffered_pins.be_out(3)              <= s_tx_dc_be_little_endian(0);
	s_umft601a_buffered_pins.be_out(2)              <= s_tx_dc_be_little_endian(1);
	s_umft601a_buffered_pins.be_out(1)              <= s_tx_dc_be_little_endian(2);
	s_umft601a_buffered_pins.be_out(0)              <= s_tx_dc_be_little_endian(3);
	s_rx_dc_data_little_endian(7 downto 0)          <= s_umft601a_buffered_pins.data_in(31 downto 24);
	s_rx_dc_data_little_endian(15 downto 8)         <= s_umft601a_buffered_pins.data_in(23 downto 16);
	s_rx_dc_data_little_endian(23 downto 16)        <= s_umft601a_buffered_pins.data_in(15 downto 8);
	s_rx_dc_data_little_endian(31 downto 24)        <= s_umft601a_buffered_pins.data_in(7 downto 0);
	s_rx_dc_be_little_endian(0)                     <= s_umft601a_buffered_pins.be_in(3);
	s_rx_dc_be_little_endian(1)                     <= s_umft601a_buffered_pins.be_in(2);
	s_rx_dc_be_little_endian(2)                     <= s_umft601a_buffered_pins.be_in(1);
	s_rx_dc_be_little_endian(3)                     <= s_umft601a_buffered_pins.be_in(0);

end architecture RTL;
