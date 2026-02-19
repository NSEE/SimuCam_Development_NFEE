library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.comm_avalon_burst_pkg.all;
use work.comm_burst_registers_pkg.all;
use work.comm_avs_controller_pkg.all;
use work.tran_burst_registers_pkg.all;

entity comm_avalon_burst_write_ent is
	port(
		clk                         : in  std_logic;
		rst                         : in  std_logic;
		avalon_burst_inputs         : in  comm_avalon_burst_write_inputs_type;
		avalon_burst_outputs        : out comm_avalon_burst_write_outputs_type;
		burst_write_registers       : out comm_burst_write_registers_type;
		comm_avs_controller_inputs  : in  comm_avsdc_tx_avs_outputs_type;
		comm_avs_controller_outputs : out comm_avsdc_tx_avs_inputs_type
	);
end entity comm_avalon_burst_write_ent;

-- TX : avs  --> fifo (Simucam --> SpW)

architecture comm_avalon_burst_write_arc of comm_avalon_burst_write_ent is

	type write_state_machine_type is (
		waiting_state,
		normal_state,
		burst_state
	);

	signal burst_waitrequest_sig    : std_logic := '1';
	signal avs_controller_write_sig : std_logic;

begin

	comm_avalon_burst_write_proc : process(clk, rst) is
		procedure burst_reset_registers_procedure is
		begin
			-- SPWC Module Reset procedure

			-- TRAN Module Reset procedure
			burst_write_registers.TRAN.TX_DATA_BURST_REGISTER.SPACEWIRE_FLAG_3 <= '0';
			burst_write_registers.TRAN.TX_DATA_BURST_REGISTER.SPACEWIRE_DATA_3 <= (others => '0');
			burst_write_registers.TRAN.TX_DATA_BURST_REGISTER.SPACEWIRE_FLAG_2 <= '0';
			burst_write_registers.TRAN.TX_DATA_BURST_REGISTER.SPACEWIRE_DATA_2 <= (others => '0');
			burst_write_registers.TRAN.TX_DATA_BURST_REGISTER.SPACEWIRE_FLAG_1 <= '0';
			burst_write_registers.TRAN.TX_DATA_BURST_REGISTER.SPACEWIRE_DATA_1 <= (others => '0');
			burst_write_registers.TRAN.TX_DATA_BURST_REGISTER.SPACEWIRE_FLAG_0 <= '0';
			burst_write_registers.TRAN.TX_DATA_BURST_REGISTER.SPACEWIRE_DATA_0 <= (others => '0');

		end procedure burst_reset_registers_procedure;

		procedure burst_writedata_procedure(burst_write_address_in : comm_avalon_burst_address_type; burst_bytes_enabled_in : comm_bytes_enabled_type) is
		begin

			case (burst_write_address_in) is
				-- Case for access to all registers address

				-- SPWC Module WriteData procedure

				-- TRAN Module WriteData procedure

				--  Transparent TX Burst Data Register (64 bits):
				when (TRAN_TX_DATA_BURST_REG_ADDRESS + TRAN_BURST_REGISTERS_ADDRESS_OFFSET) =>
					if (burst_bytes_enabled_in(7) = '1') then
						--    63-57 : Reserved                   [-/-]
						--    56-56 : SpaceWire TX Flag 3        [-/W]
						burst_write_registers.TRAN.TX_DATA_BURST_REGISTER.SPACEWIRE_FLAG_3 <= avalon_burst_inputs.writedata(56);
					end if;
					if (burst_bytes_enabled_in(6) = '1') then
						--    55-48 : SpaceWire TX Data 3        [-/W]
						burst_write_registers.TRAN.TX_DATA_BURST_REGISTER.SPACEWIRE_DATA_3 <= avalon_burst_inputs.writedata(55 downto 48);
					end if;
					if (burst_bytes_enabled_in(5) = '1') then
						--    47-41 : Reserved                   [-/-]
						--    40-40 : SpaceWire TX Flag 2        [-/W]
						burst_write_registers.TRAN.TX_DATA_BURST_REGISTER.SPACEWIRE_FLAG_2 <= avalon_burst_inputs.writedata(40);
					end if;
					if (burst_bytes_enabled_in(4) = '1') then
						--    39-32 : SpaceWire TX Data 2        [-/W]
						burst_write_registers.TRAN.TX_DATA_BURST_REGISTER.SPACEWIRE_DATA_2 <= avalon_burst_inputs.writedata(39 downto 32);
					end if;
					if (burst_bytes_enabled_in(3) = '1') then
						--    31-25 : Reserved                   [-/-]
						--    24-24 : SpaceWire TX Flag 1        [-/W]
						burst_write_registers.TRAN.TX_DATA_BURST_REGISTER.SPACEWIRE_FLAG_1 <= avalon_burst_inputs.writedata(24);
					end if;
					if (burst_bytes_enabled_in(2) = '1') then
						--    23-16 : SpaceWire TX Data 1        [-/W]
						burst_write_registers.TRAN.TX_DATA_BURST_REGISTER.SPACEWIRE_DATA_1 <= avalon_burst_inputs.writedata(23 downto 16);
					end if;
					if (burst_bytes_enabled_in(1) = '1') then
						--    15- 9 : Reserved                   [-/-]
						--     8- 8 : SpaceWire TX Flag 0        [-/W]
						burst_write_registers.TRAN.TX_DATA_BURST_REGISTER.SPACEWIRE_FLAG_0 <= avalon_burst_inputs.writedata(8);
					end if;
					if (burst_bytes_enabled_in(0) = '1') then
						--     7- 0 : SpaceWire TX Data 0        [-/W]
						burst_write_registers.TRAN.TX_DATA_BURST_REGISTER.SPACEWIRE_DATA_0 <= avalon_burst_inputs.writedata(7 downto 0);
					end if;

				when others =>
					null;

			end case;

		end procedure burst_writedata_procedure;

		variable write_state_machine_var : write_state_machine_type       := waiting_state;
		variable burst_write_address_var : comm_avalon_burst_address_type := 0;
		variable burst_burst_counter_var : comm_burst_counter_type        := 0;
		variable burst_bytes_enabled_var : comm_bytes_enabled_type        := (others => '0');
	begin
		if (rst = '1') then
			burst_waitrequest_sig    <= '1';
			avs_controller_write_sig <= '0';
			write_state_machine_var  := waiting_state;
			burst_write_address_var  := 0;
			burst_burst_counter_var  := 0;
			burst_bytes_enabled_var  := (others => '0');
			burst_reset_registers_procedure;
		elsif rising_edge(clk) then
			avs_controller_write_sig <= '0';

			-- Command Treatment and Data Writing
			case (write_state_machine_var) is

				when waiting_state =>   -- espera comando de escrita chegar e gerencia o primeiro waitrequest
					burst_waitrequest_sig <= '1';
					if (avalon_burst_inputs.write = '1') then -- chegou comando de escrita
						if (comm_avs_controller_inputs.TRAN.full = '0') then -- existe espaço disponível para o dado
							burst_waitrequest_sig   <= '0';
							write_state_machine_var := normal_state;
						else            -- não existe espaço disponível para o dado
							burst_waitrequest_sig   <= '1'; -- espera ter espaço disponível para o dado
							write_state_machine_var := waiting_state;
						end if;
					end if;

				when normal_state =>    -- primeira escrita de um burst ou escrita única
					burst_waitrequest_sig <= '1';
					if (avalon_burst_inputs.write = '1') then -- chegou comando de escrita
--						burst_write_address_var := to_integer(unsigned(avalon_burst_inputs.address));
						burst_write_address_var := TRAN_TX_DATA_BURST_REG_ADDRESS + TRAN_BURST_REGISTERS_ADDRESS_OFFSET;
						burst_burst_counter_var := to_integer(unsigned(avalon_burst_inputs.burstcount));
						burst_bytes_enabled_var := avalon_burst_inputs.byteenable;
						if (comm_avs_controller_inputs.TRAN.full = '0') then -- existe espaço disponível para o dado
							burst_writedata_procedure(burst_write_address_var, burst_bytes_enabled_var);
							avs_controller_write_sig <= '1';
							burst_waitrequest_sig    <= '0';
							if (burst_burst_counter_var > 1) then -- é o inicio de um burst
								burst_burst_counter_var := burst_burst_counter_var - 1;
								--burst_read_address_var  := burst_read_address_var + 1;
								write_state_machine_var := burst_state;
							else        -- não é o inicio de um burst
								burst_waitrequest_sig   <= '1';
								write_state_machine_var := waiting_state;
							end if;
						else            -- não existe espaço disponível para o dado
							burst_waitrequest_sig   <= '1'; -- espera ter espaço disponível para o dado
							write_state_machine_var := normal_state;
						end if;
					end if;

				when burst_state =>     -- continuação de escrita em modo burst
					burst_waitrequest_sig <= '0';
					if (avalon_burst_inputs.write = '1') then
						burst_bytes_enabled_var  := avalon_burst_inputs.byteenable;
						avs_controller_write_sig <= '1';
						burst_waitrequest_sig    <= '0';
						if (comm_avs_controller_inputs.TRAN.full = '0') then -- existe espaço disponível para o dado
							burst_writedata_procedure(burst_write_address_var, burst_bytes_enabled_var);
							burst_burst_counter_var := burst_burst_counter_var - 1;
							--burst_read_address_var  := burst_read_address_var + 1;
							if (burst_burst_counter_var > 0) then -- burst ainda não acabou
								write_state_machine_var := burst_state;
							else        -- burst acabou
								burst_waitrequest_sig   <= '1';
								write_state_machine_var := waiting_state;
							end if;
						else            -- não existe espaço disponível para o dado
							write_state_machine_var := burst_state;
						end if;
					end if;

			end case;

		end if;
	end process comm_avalon_burst_write_proc;

	-- waitrequest recebe '1' quando estou em uma escrita e fico sem espaço na fifo
	avalon_burst_outputs.waitrequest       <= (burst_waitrequest_sig) when not ((avalon_burst_inputs.write = '1') and (comm_avs_controller_inputs.TRAN.full = '1')) else ('1');
	-- fifo overflow protection e gerenciamento do fifo write
	comm_avs_controller_outputs.TRAN.write <= (avs_controller_write_sig) when (comm_avs_controller_inputs.TRAN.full = '0') else ('0');

end architecture comm_avalon_burst_write_arc;
