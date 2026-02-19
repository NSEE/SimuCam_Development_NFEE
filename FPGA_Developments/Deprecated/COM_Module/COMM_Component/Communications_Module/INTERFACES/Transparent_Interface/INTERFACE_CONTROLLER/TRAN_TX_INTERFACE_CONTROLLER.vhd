library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.tran_mm_registers_pkg.all;
use work.tran_bus_sc_fifo_pkg.all;
use work.tran_avs_sc_fifo_pkg.all;

entity tran_tx_interface_controller_ent is
	port(
		clk                               : in  std_logic;
		rst                               : in  std_logic;
		tran_mm_write_registers           : in  tran_mm_write_registers_type;
		tran_tx_interrupt_registers       : out tran_interrupt_register_type;
		tran_tx_read_outputs_avs_sc_fifo  : in  tran_read_outputs_avs_sc_fifo_type;
		tran_tx_read_inputs_avs_sc_fifo   : out tran_read_inputs_avs_sc_fifo_type;
		tran_tx_write_outputs_bus_sc_fifo : in  tran_write_outputs_bus_sc_fifo_type;
		tran_tx_write_inputs_bus_sc_fifo  : out tran_write_inputs_bus_sc_fifo_type
	);
end entity tran_tx_interface_controller_ent;

-- TX : avs --> bus (Simucam --> SpW);

architecture tran_tx_interface_controller_arc of tran_tx_interface_controller_ent is

	-- Constant for Invalid Packet data
	-- Invalid Packets are to be ignored
	constant SPW_INVALID_PACKET : std_logic_vector(8 downto 0) := "111111111";

	-- Type for TX Interface State Machine
	type tx_interface_state_machine_type is (
		spacewire_packet_0_state,
		spacewire_packet_1_state,
		spacewire_packet_2_state,
		spacewire_packet_3_state
	);

	-- Signals for TX Interface Controller Interrupts operation
	signal interrupts_flags_sig           : tran_interrupt_register_type;
	signal interrupts_drivers_current_sig : tran_interrupt_register_type;
	signal interrupts_drivers_past_sig    : tran_interrupt_register_type;

	-- Signals for AVS SC FIFO control
	signal ic_tx_avs_read_sig : std_logic;

	-- Signals for BUS SC FIFO control
	signal ic_tx_bus_write_sig : std_logic;

	-- Signals for TX Interface Controller Data
	signal ic_tx_avs_data_sig : tran_avs_sc_fifo_data_type; -- AVS SC FIFO data
	signal ic_tx_bus_data_sig : tran_bus_sc_fifo_data_type; -- BUS SC FIFO data

begin

	-- TX Interface Controller Proccess
	tran_tx_interface_controller_proc : process(clk, rst) is
		-- Process Variables
		-- Variable for TX Interface Controller State Machine
		variable tx_interface_state_machine : tx_interface_state_machine_type := spacewire_packet_0_state;
	begin
		-- Reset Procedures
		if (rst = '1') then
			-- Clear the TX FIFO Empty Interrupt Flag
			tran_tx_interrupt_registers.TX_FIFO_EMPTY <= '0';
			-- Clear AVS SC FIFO Read signal
			ic_tx_avs_read_sig                        <= '0';
			-- Clear BUS SC FIFO Write signal
			ic_tx_bus_write_sig                       <= '0';
			-- Clear all Clocked Data signals
			ic_tx_bus_data_sig.spacewire_flag         <= '0';
			ic_tx_bus_data_sig.spacewire_data         <= (others => '0');
			-- Set sClear for AVS SC FIFO and BUS SC FIFO
			tran_tx_read_inputs_avs_sc_fifo.sclr      <= '1';
			tran_tx_write_inputs_bus_sc_fifo.sclr     <= '1';
			-- Initiate TX Interface Controller State Machine
			tx_interface_state_machine                := spacewire_packet_0_state;
			-- Clocked Process
		elsif rising_edge(clk) then
			-- Clear AVS SC FIFO Read signal
			ic_tx_avs_read_sig  <= '0';
			-- Clear BUS SC FIFO Write signal
			ic_tx_bus_write_sig <= '0';

			-- TX Interface Controller Fifo Reset operation
			-- Verifies if the Fifo Reset Control Bit of the RX Fifo Control Register is set
			if (tran_mm_write_registers.TX_FIFO_CONTROL_REGISTER.FIFO_RESET_BIT = '1') then
				-- Set the TX AVS SC FIFO sClear control
				tran_tx_read_inputs_avs_sc_fifo.sclr  <= '1';
				-- Set the TX BUS SC FIFO sClear control
				tran_tx_write_inputs_bus_sc_fifo.sclr <= '1';
			else
				-- Clear the TX AVS SC FIFO sClear control
				tran_tx_read_inputs_avs_sc_fifo.sclr  <= '0';
				-- Clear the TX BUS SC FIFO sClear control
				tran_tx_write_inputs_bus_sc_fifo.sclr <= '0';
			end if;

			-- TX Interface Controller State Machine operation
			case (tx_interface_state_machine) is

				-- State for SpaceWire Packet 0 treatment 
				when spacewire_packet_0_state =>
					-- Verifies if there is/Wait for data available in the AVS SC FIFO
					if (tran_tx_read_outputs_avs_sc_fifo.empty = '0') then
						-- Verifies if the SpaceWire Packet 0 is valid
						-- SpaceWire Packet 0 already read from AVS SC FIFO in unclocked assingment
						if (((ic_tx_avs_data_sig.spacewire_flag_0) & (ic_tx_avs_data_sig.spacewire_data_0)) /= SPW_INVALID_PACKET) then
							-- Verifies if there is/Wait for space available in the BUS SC FIFO 
							if (tran_tx_write_outputs_bus_sc_fifo.full = '0') then
								-- Fill BUS SC FIFO data with SpaceWire Packet 0
								ic_tx_bus_data_sig.spacewire_flag   <= ic_tx_avs_data_sig.spacewire_flag_0;
								ic_tx_bus_data_sig.spacewire_data   <= ic_tx_avs_data_sig.spacewire_data_0;
								-- Write SpaceWire Packet 0 to BUS SC FIFO
								ic_tx_bus_write_sig                 <= '1';
								-- Read SpaceWire Packet 1 to 3 from AVS SC FIFO
								ic_tx_avs_data_sig.spacewire_flag_3 <= tran_tx_read_outputs_avs_sc_fifo.q(35);
								ic_tx_avs_data_sig.spacewire_data_3 <= tran_tx_read_outputs_avs_sc_fifo.q(34 downto 27);
								ic_tx_avs_data_sig.spacewire_flag_2 <= tran_tx_read_outputs_avs_sc_fifo.q(26);
								ic_tx_avs_data_sig.spacewire_data_2 <= tran_tx_read_outputs_avs_sc_fifo.q(25 downto 18);
								ic_tx_avs_data_sig.spacewire_flag_1 <= tran_tx_read_outputs_avs_sc_fifo.q(17);
								ic_tx_avs_data_sig.spacewire_data_1 <= tran_tx_read_outputs_avs_sc_fifo.q(16 downto 9);
								-- Signal AVS SC FIFO that current data was used
								ic_tx_avs_read_sig                  <= '1';
								-- Go to SpaceWire Packet 1 treatment state
								tx_interface_state_machine          := spacewire_packet_1_state;
							else
								-- Remain in SpaceWire Packet 0 treatment state
								tx_interface_state_machine := spacewire_packet_0_state;
							end if;
						else
							-- SpaceWire Packet 0 is ignored because it contains invalid data
							-- Read SpaceWire Packet 1 to 3 from AVS SC FIFO
							ic_tx_avs_data_sig.spacewire_flag_3 <= tran_tx_read_outputs_avs_sc_fifo.q(35);
							ic_tx_avs_data_sig.spacewire_data_3 <= tran_tx_read_outputs_avs_sc_fifo.q(34 downto 27);
							ic_tx_avs_data_sig.spacewire_flag_2 <= tran_tx_read_outputs_avs_sc_fifo.q(26);
							ic_tx_avs_data_sig.spacewire_data_2 <= tran_tx_read_outputs_avs_sc_fifo.q(25 downto 18);
							ic_tx_avs_data_sig.spacewire_flag_1 <= tran_tx_read_outputs_avs_sc_fifo.q(17);
							ic_tx_avs_data_sig.spacewire_data_1 <= tran_tx_read_outputs_avs_sc_fifo.q(16 downto 9);
							-- Signal AVS SC FIFO that current data was used
							ic_tx_avs_read_sig                  <= '1';
							-- Go to SpaceWire Packet 1 treatment state
							tx_interface_state_machine          := spacewire_packet_1_state;
						end if;
					end if;

				-- State for SpaceWire Packet 1 treatment
				when spacewire_packet_1_state =>
					-- Verifies if the SpaceWire Packet 1 is valid
					if (((ic_tx_avs_data_sig.spacewire_flag_1) & (ic_tx_avs_data_sig.spacewire_data_1)) /= SPW_INVALID_PACKET) then
						-- Verifies if there is/Wait for space available in the BUS SC FIFO 
						if (tran_tx_write_outputs_bus_sc_fifo.full = '0') then
							-- Fill BUS SC FIFO data with SpaceWire Packet 1
							ic_tx_bus_data_sig.spacewire_flag <= ic_tx_avs_data_sig.spacewire_flag_1;
							ic_tx_bus_data_sig.spacewire_data <= ic_tx_avs_data_sig.spacewire_data_1;
							-- Write SpaceWire Packet 1 to BUS SC FIFO
							ic_tx_bus_write_sig               <= '1';
							-- Go to SpaceWire Packet 2 treatment state
							tx_interface_state_machine        := spacewire_packet_2_state;
						else
							-- Remain in SpaceWire Packet 1 treatment state
							tx_interface_state_machine := spacewire_packet_1_state;
						end if;
					else
						-- SpaceWire Packet 1 is ignored because it contains invalid data
						-- Go to SpaceWire Packet 2 treatment state
						tx_interface_state_machine := spacewire_packet_2_state;
					end if;

				-- State for SpaceWire Packet 2 treatment
				when spacewire_packet_2_state =>
					-- Verifies if the SpaceWire Packet 2 is valid
					if (((ic_tx_avs_data_sig.spacewire_flag_2) & (ic_tx_avs_data_sig.spacewire_data_2)) /= SPW_INVALID_PACKET) then
						-- Verifies if there is/Wait for space available in the BUS SC FIFO 
						if (tran_tx_write_outputs_bus_sc_fifo.full = '0') then
							-- Fill BUS SC FIFO data with SpaceWire Packet 2
							ic_tx_bus_data_sig.spacewire_flag <= ic_tx_avs_data_sig.spacewire_flag_2;
							ic_tx_bus_data_sig.spacewire_data <= ic_tx_avs_data_sig.spacewire_data_2;
							-- Write SpaceWire Packet 2 to BUS SC FIFO
							ic_tx_bus_write_sig               <= '1';
							-- Go to SpaceWire Packet 3 treatment state
							tx_interface_state_machine        := spacewire_packet_3_state;
						else
							-- Remain in SpaceWire Packet 2 treatment state
							tx_interface_state_machine := spacewire_packet_2_state;
						end if;
					else
						-- SpaceWire Packet 2 is ignored because it contains invalid data
						-- Go to SpaceWire Packet 3 treatment state
						tx_interface_state_machine := spacewire_packet_3_state;
					end if;

				-- State for SpaceWire Packet 3 treatment
				when spacewire_packet_3_state =>
					-- Verifies if the SpaceWire Packet 3 is valid
					if (((ic_tx_avs_data_sig.spacewire_flag_3) & (ic_tx_avs_data_sig.spacewire_data_3)) /= SPW_INVALID_PACKET) then
						-- Verifies if there is/Wait for space available in the BUS SC FIFO 
						if (tran_tx_write_outputs_bus_sc_fifo.full = '0') then
							-- Fill BUS SC FIFO data with SpaceWire Packet 3
							ic_tx_bus_data_sig.spacewire_flag <= ic_tx_avs_data_sig.spacewire_flag_3;
							ic_tx_bus_data_sig.spacewire_data <= ic_tx_avs_data_sig.spacewire_data_3;
							-- Write SpaceWire Packet 3 to BUS SC FIFO
							ic_tx_bus_write_sig               <= '1';
							-- Return to SpaceWire Packet 0 treatment state
							tx_interface_state_machine        := spacewire_packet_0_state;
						else
							-- Remain in SpaceWire Packet 2 treatment state
							tx_interface_state_machine := spacewire_packet_3_state;
						end if;
					else
						-- SpaceWire Packet 3 is ignored because it contains invalid data
						-- Return to SpaceWire Packet 0 treatment state
						tx_interface_state_machine := spacewire_packet_0_state;
					end if;

			end case;                   -- End of TX Interface Controller State Machine operation

			-- TX Interface Controller Interrupts operation

			-- Update delayed Interrupts Signals, to check if a interrupt happened
			interrupts_drivers_past_sig.TX_FIFO_EMPTY <= interrupts_drivers_current_sig.TX_FIFO_EMPTY;

			--  TX FIFO Empty Interrupt
			-- Verifies if (the TX FIFO Empty Interrupt is enabled) and (the TX AVS SC FIFO is empty)
			if ((tran_mm_write_registers.INTERRUPT_ENABLE_REGISTER.TX_FIFO_EMPTY = '1') and (interrupts_flags_sig.TX_FIFO_EMPTY = '1')) then
				-- Set the TX FIFO Empty Interrupt Flag
				tran_tx_interrupt_registers.TX_FIFO_EMPTY <= '1';
			end if;
			-- Verifies if a command to clear the TX FIFO Empty Interrupt Flag was received 
			if (tran_mm_write_registers.INTERRUPT_FLAG_CLEAR_REGISTER.TX_FIFO_EMPTY = '1') then
				-- Clear the TX FIFO Empty Interrupt Flag
				tran_tx_interrupt_registers.TX_FIFO_EMPTY <= '0';
			end if;

		end if;                         -- End of Clocked Process
	end process tran_tx_interface_controller_proc; -- End of TX Interface Controller Proccess

	-- BUS SC FIFO Underflow/Overflow protection
	tran_tx_write_inputs_bus_sc_fifo.wrreq <= (ic_tx_bus_write_sig) when (tran_tx_write_outputs_bus_sc_fifo.full = '0') else ('0');
	-- AVS SC FIFO Underflow/Overflow protection
	tran_tx_read_inputs_avs_sc_fifo.rdreq  <= (ic_tx_avs_read_sig) when (tran_tx_read_outputs_avs_sc_fifo.empty = '0') else ('0');

	-- AVS SC FIFO Data Signal assignment
	-- Only SpaceWire Packet 0 is assigned outside TX Interface Controller Proccess
	ic_tx_avs_data_sig.spacewire_flag_0 <= tran_tx_read_outputs_avs_sc_fifo.q(8);
	ic_tx_avs_data_sig.spacewire_data_0 <= tran_tx_read_outputs_avs_sc_fifo.q(7 downto 0);

	-- BUS SC FIFO Data Signal assignment
	tran_tx_write_inputs_bus_sc_fifo.data(8)          <= ic_tx_bus_data_sig.spacewire_flag;
	tran_tx_write_inputs_bus_sc_fifo.data(7 downto 0) <= ic_tx_bus_data_sig.spacewire_data;

	-- Interrupts Signal management

	-- TX FIFO Empty Current Signal assingment
	interrupts_drivers_current_sig.TX_FIFO_EMPTY <= tran_tx_read_outputs_avs_sc_fifo.empty;
	-- TX FIFO Empty Rising Edge Signal assingment
	interrupts_flags_sig.TX_FIFO_EMPTY           <= ('1') when ((interrupts_drivers_current_sig.TX_FIFO_EMPTY = '1') and (interrupts_drivers_past_sig.TX_FIFO_EMPTY = '0')) else ('0');

end architecture tran_tx_interface_controller_arc;
