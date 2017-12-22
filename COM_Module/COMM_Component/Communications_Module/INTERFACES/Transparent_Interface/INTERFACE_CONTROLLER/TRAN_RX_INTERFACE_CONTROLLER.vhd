library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.tran_mm_registers_pkg.all;
use work.tran_bus_sc_fifo_pkg.all;
use work.tran_avs_sc_fifo_pkg.all;

entity tran_rx_interface_controller_ent is
	port(
		clk                               : in  std_logic;
		rst                               : in  std_logic;
		tran_mm_write_registers           : in  tran_mm_write_registers_type;
		tran_rx_interrupt_registers       : out tran_interrupt_register_type;
		tran_rx_read_outputs_bus_sc_fifo  : in  tran_read_outputs_bus_sc_fifo_type;
		tran_rx_read_inputs_bus_sc_fifo   : out tran_read_inputs_bus_sc_fifo_type;
		tran_rx_write_outputs_avs_sc_fifo : in  tran_write_outputs_avs_sc_fifo_type;
		tran_rx_write_inputs_avs_sc_fifo  : out tran_write_inputs_avs_sc_fifo_type
	);
end entity tran_rx_interface_controller_ent;

-- RX : bus --> avs (SpW --> Simucam);

architecture tran_rx_interface_controller_arc of tran_rx_interface_controller_ent is

	-- Constant for Timeout before new data arrives
	-- A Timeout happens when no new SpaceWire Packet data arrived before IC_RX_TIMEOUT_VALUE clock cicles passed since the last rx_interface_timeout_counter restart
	constant IC_RX_TIMEOUT_VALUE : natural := 100;

	-- Type for RX Interface State Machine
	type rx_interface_state_machine_type is (
		spacewire_packet_0_state,
		spacewire_packet_1_state,
		spacewire_packet_2_state,
		spacewire_packet_3_state
	);

	-- Signals for RX Interface Controller Interrupts operation
	signal interrupts_flags_sig           : tran_interrupt_register_type;
	signal interrupts_drivers_current_sig : tran_interrupt_register_type;
	signal interrupts_drivers_past_sig    : tran_interrupt_register_type;

	-- Signals for BUS SC FIFO control
	signal ic_rx_bus_read_sig : std_logic;

	-- Signals for AVS SC FIFO control
	signal ic_rx_avs_write_sig : std_logic;

	-- Signals for RX Interface Controller Data
	signal ic_rx_bus_data_sig : tran_bus_sc_fifo_data_type; -- BUS SC FIFO data
	signal ic_rx_avs_data_sig : tran_avs_sc_fifo_data_type; -- AVS SC FIFO data

begin

	-- RX Interface Controller Proccess
	tran_rx_interface_controller_proc : process(clk, rst) is
		-- Process Variables
		-- Variable for RX Interface Controller State Machine
		variable rx_interface_state_machine   : rx_interface_state_machine_type := spacewire_packet_0_state;
		-- Variable for RX Interface Timeout counter
		variable rx_interface_timeout_counter : natural                         := 0;
	begin
		-- Reset Procedures
		if (rst = '1') then
			-- Clear the Data Received Interrupt Flag
			tran_rx_interrupt_registers.DATA_RECEIVED <= '0';
			-- Clear the RX FIFO Full Interrupt Flag
			tran_rx_interrupt_registers.RX_FIFO_FULL  <= '0';
			-- Clear AVS SC FIFO Write signal
			ic_rx_avs_write_sig                       <= '0';
			-- Clear all Clocked Data signals
			ic_rx_avs_data_sig.spacewire_flag_3       <= '0';
			ic_rx_avs_data_sig.spacewire_data_3       <= (others => '0');
			ic_rx_avs_data_sig.spacewire_flag_2       <= '0';
			ic_rx_avs_data_sig.spacewire_data_2       <= (others => '0');
			ic_rx_avs_data_sig.spacewire_flag_1       <= '0';
			ic_rx_avs_data_sig.spacewire_data_1       <= (others => '0');
			ic_rx_avs_data_sig.spacewire_flag_0       <= '0';
			ic_rx_avs_data_sig.spacewire_data_0       <= (others => '0');
			-- Set sClear for BUS SC FIFO and AVS SC FIFO
			tran_rx_read_inputs_bus_sc_fifo.sclr      <= '1';
			tran_rx_write_inputs_avs_sc_fifo.sclr     <= '1';
			-- Initiate RX Interface Controller State Machine
			rx_interface_state_machine                := spacewire_packet_0_state;
			-- Zero RX Interface Timeout counter
			rx_interface_timeout_counter              := 0;
			-- Clocked Process
		elsif rising_edge(clk) then
			-- Clear AVS SC FIFO Write signal
			ic_rx_avs_write_sig <= '0';

			-- RX Interface Controller Fifo Reset operation
			-- Verifies if the Fifo Reset Control Bit of the RX Fifo Control Register is set
			if (tran_mm_write_registers.RX_FIFO_CONTROL_REGISTER.FIFO_RESET_BIT = '1') then
				-- Set the RX BUS SC FIFO sClear control
				tran_rx_read_inputs_bus_sc_fifo.sclr  <= '1';
				-- Set the RX AVS SC FIFO sClear control
				tran_rx_write_inputs_avs_sc_fifo.sclr <= '1';
			else
				-- Clear the RX BUS SC FIFO sClear control
				tran_rx_read_inputs_bus_sc_fifo.sclr  <= '0';
				-- Clear the RX AVS SC FIFO sClear control
				tran_rx_write_inputs_avs_sc_fifo.sclr <= '0';
			end if;

			-- Increment RX Interface Timeout counter
			rx_interface_timeout_counter := rx_interface_timeout_counter + 1;

			-- RX Interface Controller State Machine operation
			case (rx_interface_state_machine) is

				-- State for SpaceWire Packet 0 treatment 
				when spacewire_packet_0_state =>
					-- Verifies if there is/Wait for data available in the BUS SC FIFO and space available in the AVS SC FIFO 
					if ((tran_rx_read_outputs_bus_sc_fifo.empty = '0') and (tran_rx_write_outputs_avs_sc_fifo.full = '0')) then

						-- Fill SpaceWire Packet 0 with BUS SC FIFO data
						ic_rx_avs_data_sig.spacewire_flag_0 <= ic_rx_bus_data_sig.spacewire_flag;
						ic_rx_avs_data_sig.spacewire_data_0 <= ic_rx_bus_data_sig.spacewire_data;
						-- Fill SpaceWire Packet 1 to 3 with Invalid Packet data
						ic_rx_avs_data_sig.spacewire_flag_1 <= '1';
						ic_rx_avs_data_sig.spacewire_data_1 <= (others => '1');
						ic_rx_avs_data_sig.spacewire_flag_2 <= '1';
						ic_rx_avs_data_sig.spacewire_data_2 <= (others => '1');
						ic_rx_avs_data_sig.spacewire_flag_3 <= '1';
						ic_rx_avs_data_sig.spacewire_data_3 <= (others => '1');

						-- Restart RX Interface Timeout counter
						rx_interface_timeout_counter := 0;
						-- Go to SpaceWire Packet 1 treatment state
						rx_interface_state_machine   := spacewire_packet_1_state;
					else
						-- Remain in SpaceWire Packet 0 treatment state
						rx_interface_state_machine := spacewire_packet_0_state;
					end if;

				-- State for SpaceWire Packet 1 treatment
				when spacewire_packet_1_state =>
					-- Verifies if there is/Wait for data available in the BUS SC FIFO and space available in the AVS SC FIFO
					if ((tran_rx_read_outputs_bus_sc_fifo.empty = '0') and (tran_rx_write_outputs_avs_sc_fifo.full = '0')) then

						-- Fill SpaceWire Packet 1 with BUS SC FIFO data
						ic_rx_avs_data_sig.spacewire_flag_1 <= ic_rx_bus_data_sig.spacewire_flag;
						ic_rx_avs_data_sig.spacewire_data_1 <= ic_rx_bus_data_sig.spacewire_data;

						-- Restart RX Interface Timeout counter
						rx_interface_timeout_counter := 0;
						-- Go to SpaceWire Packet 2 treatment state
						rx_interface_state_machine   := spacewire_packet_2_state;
					else
						-- Remain in SpaceWire Packet 1 treatment state
						rx_interface_state_machine := spacewire_packet_1_state;
					end if;
					-- Verifies if a RX Interface Timeout occured
					if (rx_interface_timeout_counter >= IC_RX_TIMEOUT_VALUE) then
						-- Write current SpaceWire Packet 0 to 3 data to AVS SC FIFO
						ic_rx_avs_write_sig <= '1';
						-- SpaceWire Packet 1 to 3 filled with Invalid Packet data

						-- Restart RX Interface Timeout counter
						rx_interface_timeout_counter := 0;
						-- Return to SpaceWire Packet 0 treatment state
						rx_interface_state_machine   := spacewire_packet_0_state;
					end if;

				-- State for SpaceWire Packet 2 treatment
				when spacewire_packet_2_state =>
					-- Verifies if there is/Wait for data available in the BUS SC FIFO and space available in the AVS SC FIFO
					if ((tran_rx_read_outputs_bus_sc_fifo.empty = '0') and (tran_rx_write_outputs_avs_sc_fifo.full = '0')) then

						-- Fill SpaceWire Packet 2 with BUS SC FIFO data
						ic_rx_avs_data_sig.spacewire_flag_2 <= ic_rx_bus_data_sig.spacewire_flag;
						ic_rx_avs_data_sig.spacewire_data_2 <= ic_rx_bus_data_sig.spacewire_data;

						-- Restart RX Interface Timeout counter
						rx_interface_timeout_counter := 0;
						-- Go to SpaceWire Packet 3 treatment state
						rx_interface_state_machine   := spacewire_packet_3_state;
					else
						-- Remain in SpaceWire Packet 2 treatment state
						rx_interface_state_machine := spacewire_packet_2_state;
					end if;
					-- Verifies if a RX Interface Timeout occured
					if (rx_interface_timeout_counter >= IC_RX_TIMEOUT_VALUE) then -- timeout
						-- Write current SpaceWire Packet 0 to 3 data to AVS SC FIFO
						ic_rx_avs_write_sig <= '1';
						-- SpaceWire Packet 2 to 3 filled with Invalid Packet data

						-- Restart RX Interface Timeout counter
						rx_interface_timeout_counter := 0;
						-- Return to SpaceWire Packet 0 treatment state
						rx_interface_state_machine   := spacewire_packet_0_state;
					end if;

				-- State for SpaceWire Packet 3 treatment
				when spacewire_packet_3_state =>
					-- Verifies if there is/Wait for data available in the BUS SC FIFO and space available in the AVS SC FIFO
					if ((tran_rx_read_outputs_bus_sc_fifo.empty = '0') and (tran_rx_write_outputs_avs_sc_fifo.full = '0')) then

						-- Fill SpaceWire Packet 3 with BUS SC FIFO data
						ic_rx_avs_data_sig.spacewire_flag_3 <= ic_rx_bus_data_sig.spacewire_flag;
						ic_rx_avs_data_sig.spacewire_data_3 <= ic_rx_bus_data_sig.spacewire_data;
						-- Write current SpaceWire Packet 0 to 3 data to AVS SC FIFO
						ic_rx_avs_write_sig                 <= '1';

						-- Restart RX Interface Timeout counter
						rx_interface_timeout_counter := 0;

						-- Return to SpaceWire Packet 0 treatment state
						rx_interface_state_machine := spacewire_packet_0_state;
					else
						-- Remain in SpaceWire Packet 3 treatment state
						rx_interface_state_machine := spacewire_packet_3_state;
					end if;
					-- Verifies if a RX Interface Timeout occured
					if (rx_interface_timeout_counter >= IC_RX_TIMEOUT_VALUE) then
						-- Write current SpaceWire Packet 0 to 3 data to AVS SC FIFO
						ic_rx_avs_write_sig <= '1';
						-- SpaceWire Packet 3 filled with Invalid Packet data

						-- Restart RX Interface Timeout counter
						rx_interface_timeout_counter := 0;
						-- Return to SpaceWire Packet 0 treatment state
						rx_interface_state_machine   := spacewire_packet_0_state;
					end if;

			end case;                   -- End of RX Interface Controller State Machine operation

			-- RX Interface Controller Interrupts operation

			-- Update delayed Interrupts Signals, to check if a interrupt happened
			interrupts_drivers_past_sig.DATA_RECEIVED <= interrupts_drivers_current_sig.DATA_RECEIVED;
			interrupts_drivers_past_sig.RX_FIFO_FULL  <= interrupts_drivers_current_sig.RX_FIFO_FULL;

			-- Data Received Interrupt
			-- Verifies if (the Data Received Interrupt is enabled) and (a new data arrived)
			if ((tran_mm_write_registers.INTERRUPT_ENABLE_REGISTER.DATA_RECEIVED = '1') and (interrupts_flags_sig.DATA_RECEIVED = '1')) then
				-- Set the Data Received Interrupt Flag
				tran_rx_interrupt_registers.DATA_RECEIVED <= '1';
			end if;
			-- Verifies if a command to clear the Data Received Interrupt Flag was received 
			if (tran_mm_write_registers.INTERRUPT_FLAG_CLEAR_REGISTER.DATA_RECEIVED = '1') then
				-- Clear the Data Received Interrupt Flag
				tran_rx_interrupt_registers.DATA_RECEIVED <= '0';
			end if;

			-- RX FIFO Full Interrupt
			-- Verifies if (the LRX FIFO Full is enabled) and (the RX AVS SC FIFO is full)
			if ((tran_mm_write_registers.INTERRUPT_ENABLE_REGISTER.RX_FIFO_FULL = '1') and (interrupts_flags_sig.RX_FIFO_FULL = '1')) then
				-- Set the RX FIFO Full Interrupt Flag
				tran_rx_interrupt_registers.RX_FIFO_FULL <= '1';
			end if;
			-- Verifies if a command to clear the RX FIFO Full Interrupt Flag was received 
			if (tran_mm_write_registers.INTERRUPT_FLAG_CLEAR_REGISTER.RX_FIFO_FULL = '1') then
				-- Clear the RX FIFO Full Interrupt Flag
				tran_rx_interrupt_registers.RX_FIFO_FULL <= '0';
			end if;

		end if;                         -- End of Clocked Process
	end process tran_rx_interface_controller_proc; -- End of RX Interface Controller Proccess

	-- TX BUS SC FIFO Read Signal assignment
	-- Set when ((there is data available in BUS SC FIFO) and (there is space available in AVS SC FIFO)) else Clear
	ic_rx_bus_read_sig <= ('1') when ((tran_rx_read_outputs_bus_sc_fifo.empty = '0') and (tran_rx_write_outputs_avs_sc_fifo.full = '0')) else ('0');

	-- BUS SC FIFO Underflow/Overflow protection
	tran_rx_read_inputs_bus_sc_fifo.rdreq  <= (ic_rx_bus_read_sig) when (tran_rx_read_outputs_bus_sc_fifo.empty = '0') else ('0');
	-- AVS SC FIFO Underflow/Overflow protection
	tran_rx_write_inputs_avs_sc_fifo.wrreq <= (ic_rx_avs_write_sig) when (tran_rx_write_outputs_avs_sc_fifo.full = '0') else ('0');

	-- BUS SC FIFO Data Signal assignment
	ic_rx_bus_data_sig.spacewire_flag <= tran_rx_read_outputs_bus_sc_fifo.q(8);
	ic_rx_bus_data_sig.spacewire_data <= tran_rx_read_outputs_bus_sc_fifo.q(7 downto 0);

	-- AVS SC FIFO Data Signal assignment
	tran_rx_write_inputs_avs_sc_fifo.data(35)           <= ic_rx_avs_data_sig.spacewire_flag_3;
	tran_rx_write_inputs_avs_sc_fifo.data(34 downto 27) <= ic_rx_avs_data_sig.spacewire_data_3;
	tran_rx_write_inputs_avs_sc_fifo.data(26)           <= ic_rx_avs_data_sig.spacewire_flag_2;
	tran_rx_write_inputs_avs_sc_fifo.data(25 downto 18) <= ic_rx_avs_data_sig.spacewire_data_2;
	tran_rx_write_inputs_avs_sc_fifo.data(17)           <= ic_rx_avs_data_sig.spacewire_flag_1;
	tran_rx_write_inputs_avs_sc_fifo.data(16 downto 9)  <= ic_rx_avs_data_sig.spacewire_data_1;
	tran_rx_write_inputs_avs_sc_fifo.data(8)            <= ic_rx_avs_data_sig.spacewire_flag_0;
	tran_rx_write_inputs_avs_sc_fifo.data(7 downto 0)   <= ic_rx_avs_data_sig.spacewire_data_0;

	-- Interrupts Signal management

	-- Data Received Current Signal assingment
	interrupts_drivers_current_sig.DATA_RECEIVED <= not (tran_rx_read_outputs_bus_sc_fifo.empty);
	-- Data Received Rising Edge Signal assingment
	interrupts_flags_sig.DATA_RECEIVED           <= ('1') when ((interrupts_drivers_current_sig.DATA_RECEIVED = '1') and (interrupts_drivers_past_sig.DATA_RECEIVED = '0')) else ('0');

	-- RX FIFO Full Current Signal assingment
	interrupts_drivers_current_sig.RX_FIFO_FULL <= tran_rx_write_outputs_avs_sc_fifo.full;
	-- RX FIFO Full Rising Edge Signal assingment
	interrupts_flags_sig.RX_FIFO_FULL           <= ('1') when ((interrupts_drivers_current_sig.RX_FIFO_FULL = '1') and (interrupts_drivers_past_sig.RX_FIFO_FULL = '0')) else ('0');

end architecture tran_rx_interface_controller_arc;
