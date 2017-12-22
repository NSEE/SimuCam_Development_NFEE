library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.pgen_avalon_burst_pkg.all;
use work.pgen_burst_registers_pkg.all;
use work.pgen_pipeline_fifo_pkg.all;
use work.pgen_controller_pkg.all;

entity pgen_avalon_burst_read_ent is
	port(
		clk                     : in  std_logic;
		rst                     : in  std_logic;
		avalon_burst_inputs     : in  pgen_avalon_burst_read_inputs_type;
		avalon_burst_outputs    : out pgen_avalon_burst_read_outputs_type;
		burst_read_registers    : in  pgen_burst_read_registers_type;
		pgen_controller_outputs : in  pgen_controller_outputs_type;
		pgen_controller_inputs  : out pgen_controller_inputs_type
	);
end entity pgen_avalon_burst_read_ent;

architecture pgen_avalon_burst_read_arc of pgen_avalon_burst_read_ent is

	type read_state_machine_type is (
		normal_state,
		burst_state,
		fetching_state
	);

	type pipeline_state_machine_type is (
		standby_state,
		waiting_state,
		recording_state
	);

	signal pipeline_fifo_inputs_sig      : pipeline_fifo_inputs_type;
	signal pipeline_fifo_outputs_sig     : pipeline_fifo_outputs_type;
	signal pipeline_fifo_data_input_sig  : pipeline_fifo_data_type;
	signal pipeline_fifo_data_output_sig : pipeline_fifo_data_type;

	signal rdreq_sig : std_logic;
	signal wrreq_sig : std_logic;

	signal fifo_data_used_sig : std_logic;

begin

	pgen_pipeline_sc_fifo_inst : entity work.pipeline_sc_fifo
		port map(
			aclr  => rst,
			clock => clk,
			data  => pipeline_fifo_inputs_sig.data,
			rdreq => pipeline_fifo_inputs_sig.rdreq,
			wrreq => pipeline_fifo_inputs_sig.wrreq,
			empty => pipeline_fifo_outputs_sig.empty,
			full  => pipeline_fifo_outputs_sig.full,
			q     => pipeline_fifo_outputs_sig.q
		);

	pgen_avalon_burst_read_proc : process(clk, rst) is
		procedure burst_readdata_procedure(burst_read_address : pgen_avalon_burst_address_type; burst_bytes_enabled : pgen_bytes_enabled_type) is
			variable burst_readdata : std_logic_vector((avalon_burst_outputs.readdata'length - 1) downto 0);
		begin
			-- Considering valid data available
			avalon_burst_outputs.readdatavalid <= '1';

			-- Registers Data Read
			case (burst_read_address) is
				-- Case for access to all registers address

				-- Generator Burst Register                 (64 bits):
				when (PGEN_GENERATOR_BURST_REG_ADDRESS + PGEN_BURST_REGISTERS_ADDRESS_OFFSET) =>
					--   63-57 : Reserved                       [-]
					burst_readdata(63 downto 57) := (others => '0');
					--   56-56 : SpaceWire Flag 1 for Pattern 1 [R]
					burst_readdata(56)           := burst_read_registers.GENERATOR_BURST_REGISTER.PATTERN_1_SPW_FLAG_1;
					--   55-48 : SpaceWire Data 1 for Pattern 1 [R]
					burst_readdata(55 downto 48) := burst_read_registers.GENERATOR_BURST_REGISTER.PATTERN_1_SPW_DATA_1;
					--   47-41 : Reserved                       [-]
					burst_readdata(47 downto 41) := (others => '0');
					--   40-40 : SpaceWire Flag 0 for Pattern 1 [R]
					burst_readdata(40)           := burst_read_registers.GENERATOR_BURST_REGISTER.PATTERN_1_SPW_FLAG_0;
					--   39-32 : SpaceWire Data 0 for Pattern 1 [R]
					burst_readdata(39 downto 32) := burst_read_registers.GENERATOR_BURST_REGISTER.PATTERN_1_SPW_DATA_0;
					--   31-25 : Reserved                       [-]
					burst_readdata(31 downto 25) := (others => '0');
					--   24-24 : SpaceWire Flag 1 for Pattern 0 [R]
					burst_readdata(24)           := burst_read_registers.GENERATOR_BURST_REGISTER.PATTERN_0_SPW_FLAG_1;
					--   23-16 : SpaceWire Data 1 for Pattern 0 [R]
					burst_readdata(23 downto 16) := burst_read_registers.GENERATOR_BURST_REGISTER.PATTERN_0_SPW_DATA_1;
					--   15- 9 : Reserved                       [-]
					burst_readdata(15 downto 9)  := (others => '0');
					--    8- 8 : SpaceWire Flag 0 for Pattern 0 [R]
					burst_readdata(8)            := burst_read_registers.GENERATOR_BURST_REGISTER.PATTERN_0_SPW_FLAG_0;
					--    7- 0 : SpaceWire Data 0 for Pattern 0 [R]
					burst_readdata(7 downto 0)   := burst_read_registers.GENERATOR_BURST_REGISTER.PATTERN_0_SPW_DATA_0;

				when others =>
					burst_readdata := (others => '0');

			end case;

			-- Byte enable operation
			if (burst_bytes_enabled(7) = '1') then
				avalon_burst_outputs.readdata(63 downto 56) <= burst_readdata(63 downto 56);
			end if;
			if (burst_bytes_enabled(6) = '1') then
				avalon_burst_outputs.readdata(55 downto 48) <= burst_readdata(55 downto 48);
			end if;
			if (burst_bytes_enabled(5) = '1') then
				avalon_burst_outputs.readdata(47 downto 40) <= burst_readdata(47 downto 40);
			end if;
			if (burst_bytes_enabled(4) = '1') then
				avalon_burst_outputs.readdata(39 downto 32) <= burst_readdata(39 downto 32);
			end if;
			if (burst_bytes_enabled(3) = '1') then
				avalon_burst_outputs.readdata(31 downto 24) <= burst_readdata(31 downto 24);
			end if;
			if (burst_bytes_enabled(2) = '1') then
				avalon_burst_outputs.readdata(23 downto 16) <= burst_readdata(23 downto 16);
			end if;
			if (burst_bytes_enabled(1) = '1') then
				avalon_burst_outputs.readdata(15 downto 8) <= burst_readdata(15 downto 8);
			end if;
			if (burst_bytes_enabled(0) = '1') then
				avalon_burst_outputs.readdata(7 downto 0) <= burst_readdata(7 downto 0);
			end if;

		end procedure burst_readdata_procedure;

		variable read_state_machine     : read_state_machine_type        := normal_state;
		variable pipeline_state_machine : pipeline_state_machine_type    := waiting_state;
		variable burst_read_address     : pgen_avalon_burst_address_type := 0;
		variable burst_burst_counter    : pgen_burst_counter_type        := 0;
		variable burst_bytes_enabled    : pgen_bytes_enabled_type        := (others => '0');
		variable burst_reading_started  : std_logic                      := '0';
	begin
		if (rst = '1') then
			avalon_burst_outputs.waitrequest   <= '1';
			avalon_burst_outputs.readdatavalid <= '0';
			avalon_burst_outputs.readdata      <= (others => '0');
			read_state_machine                 := normal_state;
			pipeline_state_machine             := standby_state;
			burst_read_address                 := 0;
			burst_burst_counter                := 0;
			burst_bytes_enabled                := (others => '0');
			burst_reading_started              := '0';
			rdreq_sig                          <= '0';
			wrreq_sig                          <= '0';
			fifo_data_used_sig                 <= '0';
		elsif (rising_edge(clk)) then
			wrreq_sig                          <= '0';
			rdreq_sig                          <= '0';
			fifo_data_used_sig                 <= '0';
			avalon_burst_outputs.readdatavalid <= '0';
			avalon_burst_outputs.waitrequest   <= '1';

			-- Commands Pipelining
			if (avalon_burst_inputs.read = '1') then
				case (pipeline_state_machine) is

					when standby_state =>
						if (burst_reading_started = '1') then
							if (pipeline_fifo_outputs_sig.full = '1') then
								avalon_burst_outputs.waitrequest <= '1';
								wrreq_sig                        <= '0';
								pipeline_state_machine           := standby_state;
							else
								avalon_burst_outputs.waitrequest <= '0';
								wrreq_sig                        <= '1';
								pipeline_state_machine           := recording_state;
							end if;
						else
--							burst_read_address               := to_integer(unsigned(avalon_burst_inputs.address));
							burst_read_address               := PGEN_GENERATOR_BURST_REG_ADDRESS + PGEN_BURST_REGISTERS_ADDRESS_OFFSET;
							burst_burst_counter              := to_integer(unsigned(avalon_burst_inputs.burstcount));
							burst_bytes_enabled              := avalon_burst_inputs.byteenable;
							burst_reading_started            := '1';
							avalon_burst_outputs.waitrequest <= '0';
							wrreq_sig                        <= '0';
							pipeline_state_machine           := waiting_state;
						end if;

					when waiting_state =>
						pipeline_state_machine := standby_state;

					when recording_state =>
						wrreq_sig              <= '0';
						pipeline_state_machine := standby_state;

				end case;
			end if;

			-- Data Reading
			if (burst_reading_started = '1') then
				case (read_state_machine) is

					when normal_state =>
						if (pgen_controller_outputs.fifo_data_valid = '1') then
							if (fifo_data_used_sig = '1') then --Dado preparado para o proximo estágio
								burst_readdata_procedure(burst_read_address, burst_bytes_enabled);
								if (burst_burst_counter > 1) then
									burst_burst_counter := burst_burst_counter - 1;
									--burst_read_address  := burst_read_address + 1;
									fifo_data_used_sig  <= '1';
									read_state_machine  := burst_state;
								else
									if (pipeline_fifo_outputs_sig.empty = '0') then
										rdreq_sig             <= '1';
										burst_reading_started := '1';
										read_state_machine    := fetching_state;
									else
										burst_reading_started := '0';
										read_state_machine    := normal_state;
									end if;
								end if;
							else        --Dado não preparado para o proximo estágio
								fifo_data_used_sig <= '1';
							end if;
						else
							read_state_machine := normal_state;
						end if;

					when burst_state =>
						if (pgen_controller_outputs.fifo_data_valid = '1') then
							if (fifo_data_used_sig = '1') then --Dado preparado para o proximo estágio
								burst_readdata_procedure(burst_read_address, burst_bytes_enabled);
								burst_burst_counter := burst_burst_counter - 1;
								--burst_read_address  := burst_read_address + 1;
							else        --Dado não preparado para o proximo estágio
								fifo_data_used_sig <= '1';
							end if;
						end if;
						if (burst_burst_counter > 0) then
							fifo_data_used_sig <= '1';
							read_state_machine := burst_state;
						else
							if (pipeline_fifo_outputs_sig.empty = '0') then
								rdreq_sig             <= '1';
								burst_reading_started := '1';
								read_state_machine    := fetching_state;
							else
								burst_reading_started := '0';
								read_state_machine    := normal_state;
							end if;
						end if;

					when fetching_state =>
						if (rdreq_sig = '1') then
							rdreq_sig             <= '0';
							burst_reading_started := '1';
							read_state_machine    := fetching_state;
						else
--							burst_read_address    := to_integer(unsigned(avalon_burst_inputs.address));
							burst_read_address    := PGEN_GENERATOR_BURST_REG_ADDRESS + PGEN_BURST_REGISTERS_ADDRESS_OFFSET;
							burst_burst_counter   := to_integer(unsigned(pipeline_fifo_data_output_sig.burstcount));
							burst_bytes_enabled   := pipeline_fifo_data_output_sig.byteenable;
							burst_reading_started := '1';

							read_state_machine := normal_state;
						end if;

				end case;
			end if;

		end if;
	end process pgen_avalon_burst_read_proc;

	-- Signals assingments
	pipeline_fifo_inputs_sig.wrreq <= (wrreq_sig) when (pipeline_fifo_outputs_sig.full = '0') else ('0');
	pipeline_fifo_inputs_sig.rdreq <= (rdreq_sig) when (pipeline_fifo_outputs_sig.empty = '0') else ('0');

	pgen_controller_inputs.fifo_data_used <= (fifo_data_used_sig) when (pgen_controller_outputs.fifo_data_valid = '1') else ('0');

	pipeline_fifo_data_input_sig.address    <= avalon_burst_inputs.address(7 downto 0);
	pipeline_fifo_data_input_sig.byteenable <= avalon_burst_inputs.byteenable;
	pipeline_fifo_data_input_sig.burstcount <= avalon_burst_inputs.burstcount;

	pipeline_fifo_inputs_sig.data(23 downto 16) <= pipeline_fifo_data_input_sig.address;
	pipeline_fifo_inputs_sig.data(15 downto 8)  <= pipeline_fifo_data_input_sig.byteenable;
	pipeline_fifo_inputs_sig.data(7 downto 0)   <= pipeline_fifo_data_input_sig.burstcount;

	pipeline_fifo_data_output_sig.address    <= pipeline_fifo_outputs_sig.q(23 downto 16);
	pipeline_fifo_data_output_sig.byteenable <= pipeline_fifo_outputs_sig.q(15 downto 8);
	pipeline_fifo_data_output_sig.burstcount <= pipeline_fifo_outputs_sig.q(7 downto 0);

end architecture pgen_avalon_burst_read_arc;

