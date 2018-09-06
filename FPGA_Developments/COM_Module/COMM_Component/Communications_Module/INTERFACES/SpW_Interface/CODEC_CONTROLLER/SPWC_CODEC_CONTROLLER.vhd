library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;

use work.spwpkg.all;
use work.spwc_codec_pkg.all;
use work.spwc_mm_registers_pkg.all;
use work.spwc_rx_data_dc_fifo_pkg.all;
use work.spwc_tx_data_dc_fifo_pkg.all;

entity spwc_codec_controller_ent is
	port(
		clk100                              : in  std_logic;
		clk200                              : in  std_logic;
		rst                                 : in  std_logic;
		spwc_mm_write_registers             : in  spwc_mm_write_registers_type;
		spwc_mm_read_registers              : out spwc_mm_read_registers_type;
		spwc_rx_data_dc_fifo_clk200_outputs : in  spwc_rx_data_dc_fifo_clk200_outputs_type;
		spwc_rx_data_dc_fifo_clk200_inputs  : out spwc_rx_data_dc_fifo_clk200_inputs_type;
		spwc_tx_data_dc_fifo_clk200_outputs : in  spwc_tx_data_dc_fifo_clk200_outputs_type;
		spwc_tx_data_dc_fifo_clk200_inputs  : out spwc_tx_data_dc_fifo_clk200_inputs_type;
		spwc_codec_ds_encoding_rx_in        : in  spwc_codec_ds_encoding_rx_in_type;
		spwc_codec_ds_encoding_tx_out       : out spwc_codec_ds_encoding_tx_out_type
	);
end entity spwc_codec_controller_ent;

architecture spwc_codec_controller_arc of spwc_codec_controller_ent is

	-- Signals for Codec Controller configuration
	signal codec_enable_sig    : std_logic := '0';
	signal codec_rx_enable_sig : std_logic := '0';
	signal codec_tx_enable_sig : std_logic := '0';
	signal loopback_mode_sig   : std_logic := '0';

	-- Signals for Codec Controller Interrupts operation
	signal interrupts_flags_sig           : spwc_interrupt_register_type;
	signal interrupts_drivers_current_sig : spwc_interrupt_register_type;
	signal interrupts_drivers_past_sig    : spwc_interrupt_register_type;

	-- Signals for Codec Controller Data management
	signal rx_data : spwc_rx_data_dc_fifo_data_type;
	signal tx_data : spwc_tx_data_dc_fifo_data_type;

	-- Signals for RX DATA DC FIFO control
	signal rx_dc_fifo_wreq_sig : std_logic := '0';

	-- Signals for TX DATA DC FIFO control
	signal tx_dc_fifo_rdeq_sig : std_logic := '0';

	-- Type for CLK100 Commands DC FIFO operation
	type clk100_codec_command_dc_fifo_type is record
		data_in     : std_logic_vector(11 downto 0);
		write       : std_logic;
		write_empty : std_logic;
		write_full  : std_logic;
		data_out    : std_logic_vector(11 downto 0);
		read        : std_logic;
		read_empty  : std_logic;
		read_full   : std_logic;
	end record clk100_codec_command_dc_fifo_type;

	-- Signals for CLK100 Commands DC FIFO operation
	signal clk100_codec_commands_dc_fifo_sig : clk100_codec_command_dc_fifo_type;

	-- Signals for CLK100 Commands DC FIFO initialization
	signal clk100_codec_commands_valid : std_logic := '0';

	-- Signals for CLK100 Commands DC FIFO control
	signal clk100_codec_commands_dc_fifo_write_sig : std_logic := '0';

	-- Signals for CLK100 Commands DC FIFO update 
	signal clk100_current_commands_sig : std_logic_vector(11 downto 0);
	signal clk100_last_commands_sig    : std_logic_vector(11 downto 0);
	signal clk100_data_changed         : std_logic;

	-- Type for CLK200 Commands DC FIFO operation
	type clk200_codec_command_dc_fifo_type is record
		data_in     : std_logic_vector(15 downto 0);
		write       : std_logic;
		write_empty : std_logic;
		write_full  : std_logic;
		data_out    : std_logic_vector(15 downto 0);
		read        : std_logic;
		read_empty  : std_logic;
		read_full   : std_logic;
	end record clk200_codec_command_dc_fifo_type;

	-- Signals for CLK200 Commands DC FIFO operation
	signal clk200_codec_commands_dc_fifo_sig : clk200_codec_command_dc_fifo_type;

	-- Signals for CLK200 Commands DC FIFO initialization
	signal clk200_codec_commands_valid : std_logic := '0';

	-- Signals for CLK200 Commands DC FIFO control
	signal clk200_codec_commands_dc_fifo_write_sig : std_logic := '0';

	-- Signals for CLK200 Commands DC FIFO update
	signal clk200_current_commands_sig : std_logic_vector(15 downto 0);
	signal clk200_last_commands_sig    : std_logic_vector(15 downto 0);
	signal clk200_data_changed         : std_logic;

	-- Signals for CLK200 Commands FIFO MM Registers
	signal spw_link_status_register_started_bit_sig         : std_logic;
	signal spw_link_status_register_connecting_bit_sig      : std_logic;
	signal spw_link_status_register_running_bit_sig         : std_logic;
	signal rx_timecode_register_timecode_control_bits_sig   : std_logic_vector(1 downto 0);
	signal rx_timecode_register_timecode_counter_value_sig  : std_logic_vector(5 downto 0);
	signal spw_link_error_register_disconnect_error_bit_sig : std_logic;
	signal spw_link_error_register_parity_error_bit_sig     : std_logic;
	signal spw_link_error_register_escape_error_bit_sig     : std_logic;
	signal spw_link_error_register_credit_error_bit_sig     : std_logic;

	-- Signals for SpaceWire Light Codec communication
	-- Codec Link Control Signals
	signal spwc_codec_link_command_in_sig    : spwc_codec_link_command_in_type;
	-- Codec Link Status Signals
	signal spwc_codec_link_status_out_sig    : spwc_codec_link_status_out_type;
	-- Codec Receiver Data-Strobe Encoding Signals
	signal spwc_codec_ds_encoding_rx_in_sig  : spwc_codec_ds_encoding_rx_in_type;
	-- Codec Transmitter Data-Strobe Encoding Signals
	signal spwc_codec_ds_encoding_tx_out_sig : spwc_codec_ds_encoding_tx_out_type;
	-- Codec Link Error Signals
	signal spwc_codec_link_error_out_sig     : spwc_codec_link_error_out_type;
	-- Codec Receiver Timecode Signals
	signal spwc_codec_timecode_rx_out_sig    : spwc_codec_timecode_rx_out_type;
	-- Codec Transmitter Timecode Signals
	signal spwc_codec_timecode_tx_in_sig     : spwc_codec_timecode_tx_in_type;
	-- Codec Receiver Data Control Signals
	signal spwc_codec_data_rx_in_sig         : spwc_codec_data_rx_in_type;
	-- Codec Receiver Data Status Signals
	signal spwc_codec_data_rx_out_sig        : spwc_codec_data_rx_out_type;
	-- Codec Transmitter Data Control Signals
	signal spwc_codec_data_tx_in_sig         : spwc_codec_data_tx_in_type;
	-- Codec Transmitter Data Status Signals
	signal spwc_codec_data_tx_out_sig        : spwc_codec_data_tx_out_type;
	-- Codec Reset Signals
	signal spwc_codec_reset_in_sig           : std_logic;

	-- Signal for Codec Reset operation
	signal codec_reset_sig : std_logic := '1';

	-- Signals for RX Codec Receiver rxRead control
	signal codec_rxread_sig : std_logic := '0';

	-- Signals for RX Codec Receiver Timecode status
	signal timecode_tick_out_sig          : std_logic := '0';
	signal codec_timecode_rx_tick_out_sig : std_logic := '0';

	-- Signals for TX Codec Transmitter txWrite control
	signal codec_txwrite_sig : std_logic := '0';

	-- Signals for TX Codec Transmitter Timecode control
	signal timecode_tick_in_sig          : std_logic := '0';
	signal timecode_tick_in_trigger_sig  : std_logic := '0';
	signal codec_timecode_tx_tick_in_sig : std_logic := '0';

	-- Signals for Backdoor Mode control
	signal backdoor_read_registers : spwc_mm_read_registers_type;

begin

	-- SpaceWire Light Codec Encapsulation Component (Loopback Version)
	spwc_codec_loopback_ent_inst : entity work.spwc_codec_loopback_ent
		port map(
			clk_100                       => clk100,
			clk_200                       => clk200,
			rst                           => rst,
			spwc_codec_reset              => spwc_codec_reset_in_sig,
			spwc_mm_write_registers       => spwc_mm_write_registers,
			spwc_mm_read_registers        => backdoor_read_registers,
			spwc_codec_link_command_in    => spwc_codec_link_command_in_sig,
			spwc_codec_link_status_out    => spwc_codec_link_status_out_sig,
			spwc_codec_ds_encoding_rx_in  => spwc_codec_ds_encoding_rx_in_sig,
			spwc_codec_ds_encoding_tx_out => spwc_codec_ds_encoding_tx_out_sig,
			spwc_codec_link_error_out     => spwc_codec_link_error_out_sig,
			spwc_codec_timecode_rx_out    => spwc_codec_timecode_rx_out_sig,
			spwc_codec_timecode_tx_in     => spwc_codec_timecode_tx_in_sig,
			spwc_codec_data_rx_in         => spwc_codec_data_rx_in_sig,
			spwc_codec_data_rx_out        => spwc_codec_data_rx_out_sig,
			spwc_codec_data_tx_in         => spwc_codec_data_tx_in_sig,
			spwc_codec_data_tx_out        => spwc_codec_data_tx_out_sig
		);

	-- CLK100 Commands DC FIFO Component
	-- Sends Commands from CLK100 (write) to CLK200 (read) 
	clk100_codec_commands_dc_fifo_inst : entity work.spwc_clk100_codec_commands_dc_fifo -- Convert from clk100 to clk200
		port map(
			aclr    => rst,
			data    => clk100_codec_commands_dc_fifo_sig.data_in,
			rdclk   => clk200,          -- CLK200 (read)
			rdreq   => clk100_codec_commands_dc_fifo_sig.read,
			wrclk   => clk100,          -- CLK100 (write)
			wrreq   => clk100_codec_commands_dc_fifo_sig.write,
			q       => clk100_codec_commands_dc_fifo_sig.data_out,
			rdempty => clk100_codec_commands_dc_fifo_sig.read_empty,
			rdfull  => clk100_codec_commands_dc_fifo_sig.read_full,
			wrempty => clk100_codec_commands_dc_fifo_sig.write_empty,
			wrfull  => clk100_codec_commands_dc_fifo_sig.write_full
		);

	-- CLK200 Commands DC FIFO Component
	-- Sends Commands from CLK200 (write) to CLK100 (read) 
	clk200_codec_commands_dc_fifo_inst : entity work.spwc_clk200_codec_commands_dc_fifo -- Convert from clk200 to clk100
		port map(
			aclr    => rst,
			data    => clk200_codec_commands_dc_fifo_sig.data_in,
			rdclk   => clk100,          -- CLK100 (write)
			rdreq   => clk200_codec_commands_dc_fifo_sig.read,
			wrclk   => clk200,          -- CLK200 (read)
			wrreq   => clk200_codec_commands_dc_fifo_sig.write,
			q       => clk200_codec_commands_dc_fifo_sig.data_out,
			rdempty => clk200_codec_commands_dc_fifo_sig.read_empty,
			rdfull  => clk200_codec_commands_dc_fifo_sig.read_full,
			wrempty => clk200_codec_commands_dc_fifo_sig.write_empty,
			wrfull  => clk200_codec_commands_dc_fifo_sig.write_full
		);

	-- CLK100 Codec Controller Process (Avalon Clock)
	spwc_codec_controller_clk100_proc : process(clk100, rst) is
	begin
		-- CLK100 Reset Procedures
		if (rst = '1') then
			-- Clear Codec Controller Enable signal
			codec_enable_sig                                                 <= '0';
			-- Clear Codec Controller RX Enable signal
			codec_rx_enable_sig                                              <= '0';
			-- Clear Codec Controller TX Enable signal
			codec_tx_enable_sig                                              <= '0';
			-- Clear Codec Controller Loopback Mode control signal
			loopback_mode_sig                                                <= '0';
			-- Clear the Link Error Interrupt Flag
			spwc_mm_read_registers.INTERRUPT_FLAG_REGISTER.LINK_ERROR        <= '0';
			-- Clear the Link Running Interrupt Flag
			spwc_mm_read_registers.INTERRUPT_FLAG_REGISTER.LINK_RUNNING      <= '0';
			-- Clear the Timecode Received Interrupt Flag
			spwc_mm_read_registers.INTERRUPT_FLAG_REGISTER.TIMECODE_RECEIVED <= '0';
			-- Clear CLK100 Commands Valid Flag
			clk100_codec_commands_valid                                      <= '0';
			-- Clear the Control/Status Bit in the TX Timecode Register
			spwc_mm_read_registers.RX_TIMECODE_REGISTER.CONTROL_STATUS_BIT   <= '0';
			-- Set the SpaceWire Light Codec Reset signal
			codec_reset_sig                                                  <= '1';
			-- Set the RX DATA DC FIFO aClear control
			spwc_rx_data_dc_fifo_clk200_inputs.aclr                          <= '1';
			-- Set the TX DATA DC FIFO aClear control
			spwc_tx_data_dc_fifo_clk200_inputs.aclr                          <= '1';

		-- CLK100 Clocked Process
		elsif rising_edge(clk100) then

			-- Codec Controller Force Reset operation
			-- Verifies if the Force Reset Control Bit of the Intercafe Control Register is set
			if (spwc_mm_write_registers.INTERFACE_CONTROL_REGISTER.FORCE_RESET_BIT = '1') then
				-- Set the SpaceWire Light Codec Reset signal
				codec_reset_sig                         <= '1';
				-- Set the RX DATA DC FIFO aClear control
				spwc_rx_data_dc_fifo_clk200_inputs.aclr <= '1';
				-- Set the TX DATA DC FIFO aClear control
				spwc_tx_data_dc_fifo_clk200_inputs.aclr <= '1';
			else
				-- Clear the SpaceWire Light Codec Reset signal
				codec_reset_sig                         <= '0';
				-- Clear the RX DATA DC FIFO aClear control
				spwc_rx_data_dc_fifo_clk200_inputs.aclr <= '0';
				-- Clear the TX DATA DC FIFO aClear control
				spwc_tx_data_dc_fifo_clk200_inputs.aclr <= '0';
			end if;

			-- Codec Controller Configuration Registers Reading
			-- Read Codec Controller Enable Enable value from the Interface Control Register 
			codec_enable_sig    <= spwc_mm_write_registers.INTERFACE_CONTROL_REGISTER.CODEC_ENABLE_BIT;
			-- Read Codec Controller RX Enable value from the Interface Control Register
			codec_rx_enable_sig <= spwc_mm_write_registers.INTERFACE_CONTROL_REGISTER.CODEC_RX_ENABLE_BIT;
			-- Read Codec Controller TX Enable value from the Interface Control Register
			codec_tx_enable_sig <= spwc_mm_write_registers.INTERFACE_CONTROL_REGISTER.CODEC_TX_ENABLE_BIT;
			-- Read Codec Controller Loopback Mode Enable value from the Interface Control Register
			loopback_mode_sig   <= spwc_mm_write_registers.INTERFACE_CONTROL_REGISTER.LOOPBACK_MODE_BIT;

			-- CLK100 Commands DC FIFO write operation
			-- Update delayed CLK100 Commands Signal, to check if a command has changed
			clk100_last_commands_sig <= clk100_current_commands_sig;

			-- CLK200 Commands DC FIFO read operation
			-- To avoid assigning Undefined ('U') values to the CLK200 Commands DC FIFO output signals, it is necessary to wait for a first CLK200 command to be available at the CLK200 Commands DC FIFO output before considering the CLK200 Commands DC FIFO output signals valids
			-- Verifies if (the CLK100 Commands Valid Flag is cleared) and (there is CLK200 Commands available to be used) 
			if ((clk100_codec_commands_valid = '0') and (clk200_codec_commands_dc_fifo_sig.read_empty = '0')) then
				-- Indicates there is a CLK200 Commands avaliable to be used in the CLK100 Clocked Process
				-- Set CLK100 Commands Valid Flag for the first time
				clk100_codec_commands_valid <= '1';
			end if;

			-- Receiver Timecode operation
			-- Verifies if the Codec sent a Timecode Tick Out (Timecode Received)
			if (timecode_tick_out_sig = '1') then
				-- Set the Control/Status Bit of the RX Timecode Register, indicating a new Timecode arrived 
				spwc_mm_read_registers.RX_TIMECODE_REGISTER.CONTROL_STATUS_BIT <= '1';
			end if;
			-- Verifies if a command to clear the Control/Status Bit of the RX Timecode Register was received
			if (spwc_mm_write_registers.RX_TIMECODE_CLEAR_REGISTER.CONTROL_STATUS_BIT = '1') then
				-- Clear the Control/Status Bit of the RX Timecode Register
				spwc_mm_read_registers.RX_TIMECODE_REGISTER.CONTROL_STATUS_BIT <= '0';
			end if;

			-- Codec Controller Interrupts operation

			-- Update delayed Interrupts Signals, to check if a interrupt happened
			interrupts_drivers_past_sig <= interrupts_drivers_current_sig;

			-- Link Error Interrupt
			-- Verifies if (the Link Error Interrupt is enabled) and (a Codec Link Error occured)
			if ((spwc_mm_write_registers.INTERRUPT_ENABLE_REGISTER.LINK_ERROR = '1') and (interrupts_flags_sig.LINK_ERROR = '1')) then
				-- Set the Link Error Interrupt Flag
				spwc_mm_read_registers.INTERRUPT_FLAG_REGISTER.LINK_ERROR <= '1';
			end if;
			-- Verifies if a command to clear the Link Error Interrupt Flag was received 
			if (spwc_mm_write_registers.INTERRUPT_FLAG_CLEAR_REGISTER.LINK_ERROR = '1') then
				-- Clear the Link Error Interrupt Flag
				spwc_mm_read_registers.INTERRUPT_FLAG_REGISTER.LINK_ERROR <= '0';
			end if;

			-- Link Running Interrupt
			-- Verifies if (the Link Running Interrupt is enabled) and (the Codec entered in a Link Running state)
			if ((spwc_mm_write_registers.INTERRUPT_ENABLE_REGISTER.LINK_RUNNING = '1') and (interrupts_flags_sig.LINK_RUNNING = '1')) then
				-- Set the Link Running Interrupt Flag
				spwc_mm_read_registers.INTERRUPT_FLAG_REGISTER.LINK_RUNNING <= '1';
			end if;
			-- Verifies if a command to clear the Link Running Interrupt Flag was received
			if (spwc_mm_write_registers.INTERRUPT_FLAG_CLEAR_REGISTER.LINK_RUNNING = '1') then
				-- Clear the Link Running Interrupt Flag
				spwc_mm_read_registers.INTERRUPT_FLAG_REGISTER.LINK_RUNNING <= '0';
			end if;

			-- Timecode Received Interrupt
			-- Verifies if (the Timecode Received Interrupt is enabled) and (a Timecode was received by the Codec occured)
			if ((spwc_mm_write_registers.INTERRUPT_ENABLE_REGISTER.TIMECODE_RECEIVED = '1') and (interrupts_flags_sig.TIMECODE_RECEIVED = '1')) then
				-- Set the Timecode Received Interrupt Flag
				spwc_mm_read_registers.INTERRUPT_FLAG_REGISTER.TIMECODE_RECEIVED <= '1';
			end if;
			-- Verifies if a command to clear the Timecode Received Interrupt Flag was received
			if (spwc_mm_write_registers.INTERRUPT_FLAG_CLEAR_REGISTER.TIMECODE_RECEIVED = '1') then
				-- Clear the Timecode Received Interrupt Flag
				spwc_mm_read_registers.INTERRUPT_FLAG_REGISTER.TIMECODE_RECEIVED <= '0';
			end if;

		end if;                         -- End of CLK100 Clocked Process
	end process spwc_codec_controller_clk100_proc; -- End of CLK100 Codec Controller Process (Avalon Clock)

	-- CLK200 Codec Controller Process (Codec Clock)
	spwc_codec_controller_clk200_proc : process(clk200, rst) is
	begin
		-- CLK200 Reset Procedures
		-- TODO review clk200 reset procedures
		if (rst = '1') then
			-- Clear CLK200 Commands Valid Flag
			clk200_codec_commands_valid  <= '0';
			-- Clear the Timecode Tick In Trigger signal
			timecode_tick_in_trigger_sig <= '0';

		-- CLK200 Clocked Process
		elsif rising_edge(clk200) then

			-- CLK200 Commands DC FIFO write operation
			-- Update delayed CLK200 Commands Signal, to check if a command has changed
			clk200_last_commands_sig <= clk200_current_commands_sig;

			-- CLK100 Commands DC FIFO read operation
			-- To avoid assigning Undefined ('U') values to the CLK100 Commands DC FIFO output signals, it is necessary to wait for a first CLK100 command to be available at the CLK100 Commands DC FIFO output before considering the CLK100 Commands DC FIFO output signals valids
			-- Verifies if (the CLK200 Commands Valid Flag is cleared) and (there is CLK100 Commands available to be used)			
			if ((clk200_codec_commands_valid = '0') and (clk100_codec_commands_dc_fifo_sig.read_empty = '0')) then
				-- Indicates there is a CLK100 Commands avaliable to be used in the CLK200 Clocked Process
				-- Set CLK200 Commands Valid Flag for the first time
				clk200_codec_commands_valid <= '1';
			end if;

			-- Transmitter Timecode operation
			-- Clear the Codec Timecode Tick In signal
			codec_timecode_tx_tick_in_sig <= '0';
			-- Verifies if the Control/Status Bit of the TX Timecode Register is set, indicating that a new Timecode must be sent
			if (timecode_tick_in_sig = '1') then
				-- Verifies if the Timecode Tick In Trigger signal is cleared
				-- Necessary to ensure that the Codec Timecode Tick In signal will be set for only one CLK200 clock cicle
				if (timecode_tick_in_trigger_sig = '0') then
					-- Set the Codec Timecode Tick In signal
					codec_timecode_tx_tick_in_sig <= '1';
					-- Set the Timecode Tick In Trigger signal
					timecode_tick_in_trigger_sig  <= '1';
				end if;
			else
				-- Clear the Timecode Tick In Trigger signal
				timecode_tick_in_trigger_sig <= '0';
			end if;

		end if;                         -- End of CLK200 Clocked Process
	end process spwc_codec_controller_clk200_proc; -- End of CLK200 Codec Controller Process (Codec Clock)

	-- Loopback/Normal Mode Signal assignment
	-- In Loopback Mode, the Codec inputs signals (di and si) are conected to the Codec outputs signals (do and so), allowing the Codec to communicate with itself 
	spwc_codec_ds_encoding_rx_in_sig.spw_di <= (spwc_codec_ds_encoding_rx_in.spw_di) when (loopback_mode_sig = '0') else (spwc_codec_ds_encoding_tx_out_sig.spw_do);
	spwc_codec_ds_encoding_rx_in_sig.spw_si <= (spwc_codec_ds_encoding_rx_in.spw_si) when (loopback_mode_sig = '0') else (spwc_codec_ds_encoding_tx_out_sig.spw_so);
	spwc_codec_ds_encoding_tx_out.spw_do    <= (spwc_codec_ds_encoding_tx_out_sig.spw_do) when (loopback_mode_sig = '0') else ('0');
	spwc_codec_ds_encoding_tx_out.spw_so    <= (spwc_codec_ds_encoding_tx_out_sig.spw_so) when (loopback_mode_sig = '0') else ('0');

	-- RX Codec Reset Signal assingment
	spwc_codec_reset_in_sig <= (codec_reset_sig) when (rst = '0') else ('1');

	-- RX Codec Receiver rxRead Control Signal assingment
	-- '1' when ((Codec Receiver has valid data) and (RX DATA DC FIFO has space available)), else '0'
	codec_rxread_sig <= ('1') when ((spwc_codec_data_rx_out_sig.rxvalid = '1') and (spwc_rx_data_dc_fifo_clk200_outputs.wrfull = '0')) else ('0');

	-- RX Enable Management (Codec Data Receiver)
	spwc_codec_data_rx_in_sig.rxread <= (codec_rxread_sig) when ((codec_enable_sig = '1') and (codec_rx_enable_sig = '1')) else ('0');

	-- RX DATA DC FIFO Write Signal assingment and Enable management 
	rx_dc_fifo_wreq_sig <= (codec_rxread_sig) when ((codec_enable_sig = '1') and (codec_rx_enable_sig = '1')) else ('0');

	-- RX DATA DC FIFO Underflow/Overflow protection management
	spwc_rx_data_dc_fifo_clk200_inputs.wrreq <= (rx_dc_fifo_wreq_sig) when (spwc_rx_data_dc_fifo_clk200_outputs.wrfull = '0') else ('0');

	-- RX Enable Management (Codec Timecode Receiver)
	timecode_tick_out_sig <= (codec_timecode_rx_tick_out_sig) when ((codec_enable_sig = '1') and (codec_rx_enable_sig = '1')) else ('0');

	-- RX Codec Receiver Data Signal assignment
	rx_data.spacewire_flag <= spwc_codec_data_rx_out_sig.rxflag;
	rx_data.spacewire_data <= spwc_codec_data_rx_out_sig.rxdata;

	-- RX DATA DC FIFO Data Signal assignment
	spwc_rx_data_dc_fifo_clk200_inputs.data(8)          <= rx_data.spacewire_flag;
	spwc_rx_data_dc_fifo_clk200_inputs.data(7 downto 0) <= rx_data.spacewire_data;

	-- TX Codec Transmitter txWrite Control Signal assingment
	-- '1' when ((Codec Transmitter is ready) and (TX DATA DC FIFO has data available)), else '0'
	codec_txwrite_sig <= ('1') when ((spwc_codec_data_tx_out_sig.txrdy = '1') and (spwc_tx_data_dc_fifo_clk200_outputs.rdempty = '0')) else ('0');

	-- TX Enable Management (Codec Data Transmitter)
	spwc_codec_data_tx_in_sig.txwrite <= (codec_txwrite_sig) when ((codec_enable_sig = '1') and (codec_tx_enable_sig = '1')) else ('0');

	-- TX DATA DC FIFO Write Signal assingment and Enable management
	tx_dc_fifo_rdeq_sig <= (codec_txwrite_sig) when ((codec_enable_sig = '1') and (codec_tx_enable_sig = '1')) else ('0');

	-- TX DATA DC FIFO Underflow/Overflow protection management
	spwc_tx_data_dc_fifo_clk200_inputs.rdreq <= (tx_dc_fifo_rdeq_sig) when (spwc_tx_data_dc_fifo_clk200_outputs.rdempty = '0') else ('0');

	-- TX Enable Management (Codec Timecode Transmitter)
	spwc_codec_timecode_tx_in_sig.tick_in <= (codec_timecode_tx_tick_in_sig) when ((codec_enable_sig = '1') and (codec_tx_enable_sig = '1')) else ('0');

	-- TX Codec Transmitter Data Signal assignment
	spwc_codec_data_tx_in_sig.txflag <= tx_data.spacewire_flag;
	spwc_codec_data_tx_in_sig.txdata <= tx_data.spacewire_data;

	-- TX DATA DC FIFO Data Signal assignment
	tx_data.spacewire_flag <= spwc_tx_data_dc_fifo_clk200_outputs.q(8);
	tx_data.spacewire_data <= spwc_tx_data_dc_fifo_clk200_outputs.q(7 downto 0);

	-- CLK100 Current Commands Signal assingment
	clk100_current_commands_sig <= clk100_codec_commands_dc_fifo_sig.data_in;

	-- CLK100 Data Changed Signal assingment
	-- Indicates a new CLK100 Command was received and need to be sent to CLK200
	-- '1' if the CLK100 Commands Signal is different from the last clock cicle CLK100 Commands Signal, else '0'
	clk100_data_changed <= or_reduce(clk100_current_commands_sig xor clk100_last_commands_sig);

	-- CLK100 Commands DC FIFO Write Signal assingment (data write in CLK100)
	-- To avoid losing commands because of a CLK100 Commands DC FIFO Overflow, the CLK100 Commands DC FIFO is only updated when there is a change in the current CLK100 commands
	clk100_codec_commands_dc_fifo_write_sig <= clk100_data_changed;

	-- CLK100 Commands DC FIFO Underflow/Overflow protection (data write in CLK100)
	clk100_codec_commands_dc_fifo_sig.write <= (clk100_codec_commands_dc_fifo_write_sig) when (clk100_codec_commands_dc_fifo_sig.write_full = '0') else ('0');

	-- CLK100 Commands DC FIFO Write Data Signal assingment (data write in CLK100)
	clk100_codec_commands_dc_fifo_sig.data_in(0)           <= spwc_mm_write_registers.SPW_LINK_MODE_REGISTER.AUTOSTART_BIT;
	clk100_codec_commands_dc_fifo_sig.data_in(1)           <= spwc_mm_write_registers.SPW_LINK_MODE_REGISTER.LINK_START_BIT;
	clk100_codec_commands_dc_fifo_sig.data_in(2)           <= spwc_mm_write_registers.SPW_LINK_MODE_REGISTER.LINK_DISCONNECT_BIT;
	clk100_codec_commands_dc_fifo_sig.data_in(3)           <= spwc_mm_write_registers.TX_TIMECODE_REGISTER.CONTROL_STATUS_BIT;
	clk100_codec_commands_dc_fifo_sig.data_in(5 downto 4)  <= spwc_mm_write_registers.TX_TIMECODE_REGISTER.TIMECODE_CONTROL_BITS(1 downto 0);
	clk100_codec_commands_dc_fifo_sig.data_in(11 downto 6) <= spwc_mm_write_registers.TX_TIMECODE_REGISTER.TIMECODE_COUNTER_VALUE(5 downto 0);

	-- CLK100 Commands DC FIFO Read Signal assingment (data read in CLK200) 
	-- '1' when there is CLK100 Commands ready to be used in CLK200, else '0'
	clk100_codec_commands_dc_fifo_sig.read <= ('1') when (clk100_codec_commands_dc_fifo_sig.read_empty = '0') else ('0');

	-- CLK100 Commands DC FIFO Read Data Signal assingment (data read in CLK200)
	spwc_codec_link_command_in_sig.autostart <= (clk100_codec_commands_dc_fifo_sig.data_out(0)) when (clk200_codec_commands_valid = '1') else ('0');
	spwc_codec_link_command_in_sig.linkstart <= (clk100_codec_commands_dc_fifo_sig.data_out(1)) when (clk200_codec_commands_valid = '1') else ('0');
	spwc_codec_link_command_in_sig.linkdis   <= (clk100_codec_commands_dc_fifo_sig.data_out(2)) when (clk200_codec_commands_valid = '1') else ('0');
	timecode_tick_in_sig                     <= (clk100_codec_commands_dc_fifo_sig.data_out(3)) when (clk200_codec_commands_valid = '1') else ('0');
	spwc_codec_timecode_tx_in_sig.ctrl_in    <= (clk100_codec_commands_dc_fifo_sig.data_out(5 downto 4)) when (clk200_codec_commands_valid = '1') else ((others => '0'));
	spwc_codec_timecode_tx_in_sig.time_in    <= (clk100_codec_commands_dc_fifo_sig.data_out(11 downto 6)) when (clk200_codec_commands_valid = '1') else ((others => '0'));

	-- CLK200 Current Commands Signal assingment 
	clk200_current_commands_sig <= clk200_codec_commands_dc_fifo_sig.data_in;

	-- CLK200 Data Changed Signal assingment
	-- Indicates a new CLK200 Command was received and need to be sent to CLK100
	-- '1' if the CLK200 Commands Signal is different from the last clock cicle CLK200 Commands Signal, else '0'
	clk200_data_changed <= or_reduce(clk200_current_commands_sig xor clk200_last_commands_sig);

	-- CLK200 Commands DC FIFO Write Signal assingment (data write in CLK200)
	-- To avoid losing commands because of a CLK200 Commands DC FIFO Overflow, the CLK200 Commands DC FIFO is only updated when there is a change in the current CLK200 commands
	clk200_codec_commands_dc_fifo_write_sig <= clk200_data_changed;

	-- CLK200 Commands DC FIFO Underflow/Overflow protection (data write in CLK200)
	clk200_codec_commands_dc_fifo_sig.write <= (clk200_codec_commands_dc_fifo_write_sig) when (clk200_codec_commands_dc_fifo_sig.write_full = '0') else ('0');

	-- CLK200 Commands DC FIFO Write Data Signal assingment (data write in CLK200)
	clk200_codec_commands_dc_fifo_sig.data_in(0)           <= spwc_codec_link_status_out_sig.started;
	clk200_codec_commands_dc_fifo_sig.data_in(1)           <= spwc_codec_link_status_out_sig.connecting;
	clk200_codec_commands_dc_fifo_sig.data_in(2)           <= spwc_codec_link_status_out_sig.running;
	clk200_codec_commands_dc_fifo_sig.data_in(3)           <= spwc_codec_timecode_rx_out_sig.tick_out;
	clk200_codec_commands_dc_fifo_sig.data_in(5 downto 4)  <= spwc_codec_timecode_rx_out_sig.ctrl_out(1 downto 0);
	clk200_codec_commands_dc_fifo_sig.data_in(11 downto 6) <= spwc_codec_timecode_rx_out_sig.time_out(5 downto 0);
	clk200_codec_commands_dc_fifo_sig.data_in(12)          <= spwc_codec_link_error_out_sig.errdisc;
	clk200_codec_commands_dc_fifo_sig.data_in(13)          <= spwc_codec_link_error_out_sig.errpar;
	clk200_codec_commands_dc_fifo_sig.data_in(14)          <= spwc_codec_link_error_out_sig.erresc;
	clk200_codec_commands_dc_fifo_sig.data_in(15)          <= spwc_codec_link_error_out_sig.errcred;

	-- CLK200 Commands DC FIFO Read Signal assingment (data read in CLK100)
	-- '1' when there is CLK200 Commands ready to be used in CLK100, else '0'
	clk200_codec_commands_dc_fifo_sig.read <= ('1') when (clk200_codec_commands_dc_fifo_sig.read_empty = '0') else ('0');

	-- CLK200 Commands DC FIFO Read Data Signal assingment (data read in CLK100)
	spw_link_status_register_started_bit_sig         <= (clk200_codec_commands_dc_fifo_sig.data_out(0)) when (clk100_codec_commands_valid = '1') else ('0');
	spw_link_status_register_connecting_bit_sig      <= (clk200_codec_commands_dc_fifo_sig.data_out(1)) when (clk100_codec_commands_valid = '1') else ('0');
	spw_link_status_register_running_bit_sig         <= (clk200_codec_commands_dc_fifo_sig.data_out(2)) when (clk100_codec_commands_valid = '1') else ('0');
	codec_timecode_rx_tick_out_sig                   <= (clk200_codec_commands_dc_fifo_sig.data_out(3)) when (clk100_codec_commands_valid = '1') else ('0');
	rx_timecode_register_timecode_control_bits_sig   <= (clk200_codec_commands_dc_fifo_sig.data_out(5 downto 4)) when (clk100_codec_commands_valid = '1') else ((others => '0'));
	rx_timecode_register_timecode_counter_value_sig  <= (clk200_codec_commands_dc_fifo_sig.data_out(11 downto 6)) when (clk100_codec_commands_valid = '1') else ((others => '0'));
	spw_link_error_register_disconnect_error_bit_sig <= (clk200_codec_commands_dc_fifo_sig.data_out(12)) when (clk100_codec_commands_valid = '1') else ('0');
	spw_link_error_register_parity_error_bit_sig     <= (clk200_codec_commands_dc_fifo_sig.data_out(13)) when (clk100_codec_commands_valid = '1') else ('0');
	spw_link_error_register_escape_error_bit_sig     <= (clk200_codec_commands_dc_fifo_sig.data_out(14)) when (clk100_codec_commands_valid = '1') else ('0');
	spw_link_error_register_credit_error_bit_sig     <= (clk200_codec_commands_dc_fifo_sig.data_out(15)) when (clk100_codec_commands_valid = '1') else ('0');

	-- CLK200 Commands FIFO MM Registers Signals assingments
	spwc_mm_read_registers.SPW_LINK_STATUS_REGISTER.STARTED             <= spw_link_status_register_started_bit_sig;
	spwc_mm_read_registers.SPW_LINK_STATUS_REGISTER.CONNECTING          <= spw_link_status_register_connecting_bit_sig;
	spwc_mm_read_registers.SPW_LINK_STATUS_REGISTER.RUNNING             <= spw_link_status_register_running_bit_sig;
	spwc_mm_read_registers.RX_TIMECODE_REGISTER.TIMECODE_CONTROL_BITS   <= rx_timecode_register_timecode_control_bits_sig;
	spwc_mm_read_registers.RX_TIMECODE_REGISTER.TIMECODE_COUNTER_VALUE  <= rx_timecode_register_timecode_counter_value_sig;
	spwc_mm_read_registers.SPW_LINK_ERROR_REGISTER.DISCONNECT_ERROR_BIT <= spw_link_error_register_disconnect_error_bit_sig;
	spwc_mm_read_registers.SPW_LINK_ERROR_REGISTER.PARITY_ERROR_BIT     <= spw_link_error_register_parity_error_bit_sig;
	spwc_mm_read_registers.SPW_LINK_ERROR_REGISTER.ESCAPE_ERROR_BIT     <= spw_link_error_register_escape_error_bit_sig;
	spwc_mm_read_registers.SPW_LINK_ERROR_REGISTER.CREDIT_ERROR_BIT     <= spw_link_error_register_credit_error_bit_sig;

	-- Interrupts Signal management

	-- Link Error Current Signal assingment
	interrupts_drivers_current_sig.LINK_ERROR <= (spw_link_error_register_disconnect_error_bit_sig) or (spw_link_error_register_parity_error_bit_sig) or (spw_link_error_register_escape_error_bit_sig) or (spw_link_error_register_credit_error_bit_sig);
	-- Link Error Rising Edge Signal assingment
	interrupts_flags_sig.LINK_ERROR           <= ('1') when ((interrupts_drivers_current_sig.LINK_ERROR = '1') and (interrupts_drivers_past_sig.LINK_ERROR = '0')) else ('0');

	-- Link Running Current Signal assingment
	interrupts_drivers_current_sig.LINK_RUNNING <= spw_link_status_register_running_bit_sig;
	-- Link Running Rising Edge Signal assingment
	interrupts_flags_sig.LINK_RUNNING           <= ('1') when ((interrupts_drivers_current_sig.LINK_RUNNING = '1') and (interrupts_drivers_past_sig.LINK_RUNNING = '0')) else ('0');

	-- Timecode Received Current Signal assingment
	interrupts_drivers_current_sig.TIMECODE_RECEIVED <= timecode_tick_out_sig;
	-- Timecode Received Rising Edge Signal assingment
	interrupts_flags_sig.TIMECODE_RECEIVED           <= ('1') when ((interrupts_drivers_current_sig.TIMECODE_RECEIVED = '1') and (interrupts_drivers_past_sig.TIMECODE_RECEIVED = '0')) else ('0');

	-- Backdoor Mode Signals 
	spwc_mm_read_registers.RX_BACKDOOR_STATUS_REGISTER <= backdoor_read_registers.RX_BACKDOOR_STATUS_REGISTER;
	spwc_mm_read_registers.RX_BACKDOOR_DATA_REGISTER   <= backdoor_read_registers.RX_BACKDOOR_DATA_REGISTER;
	spwc_mm_read_registers.TX_BACKDOOR_STATUS_REGISTER <= backdoor_read_registers.TX_BACKDOOR_STATUS_REGISTER;

end architecture spwc_codec_controller_arc;
