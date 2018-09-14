library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.pgen_avalon_burst_pkg.all;
use work.pgen_burst_registers_pkg.all;
use work.pgen_pipeline_fifo_pkg.all;
use work.pgen_controller_pkg.all;

entity pgen_avalon_burst_read_ent is
	port(
		clk_i                       : in  std_logic;
		rst_i                       : in  std_logic;
		burst_read_registers_i      : in  t_pgen_burst_read_registers;
		avalon_burst_read_inputs_i  : in  t_pgen_avalon_burst_read_inputs;
		pgen_controller_outputs_i   : in  t_pgen_controller_outputs;
		avalon_burst_read_outputs_o : out t_pgen_avalon_burst_read_outputs;
		pgen_controller_inputs_o    : out t_pgen_controller_inputs
	);
end entity pgen_avalon_burst_read_ent;

architecture rtl of pgen_avalon_burst_read_ent is

	type t_read_state_machine is (
		NORMAL,
		BURST,
		FETCHING
	);

	type t_pipeline_state_machine is (
		STANDBY,
		WAITING,
		RECORDING
	);

	signal s_pipeline_fifo_inputs      : t_pipeline_fifo_inputs;
	signal s_pipeline_fifo_outputs     : t_pipeline_fifo_outputs;
	signal s_pipeline_fifo_data_input  : t_pipeline_fifo_data;
	signal s_pipeline_fifo_data_output : t_pipeline_fifo_data;

	signal s_rdreq : std_logic;
	signal s_wrreq : std_logic;

	signal s_fifo_data_used : std_logic;

begin

	pgen_pipeline_sc_fifo_inst : entity work.pipeline_sc_fifo
		port map(
			aclr  => rst_i,
			clock => clk_i,
			data  => s_pipeline_fifo_inputs.data,
			rdreq => s_pipeline_fifo_inputs.rdreq,
			wrreq => s_pipeline_fifo_inputs.wrreq,
			empty => s_pipeline_fifo_outputs.empty,
			full  => s_pipeline_fifo_outputs.full,
			q     => s_pipeline_fifo_outputs.q
		);

	p_pgen_avalon_burst_read : process(clk_i, rst_i) is
		procedure p_burst_readdata(burst_read_address_i : t_pgen_avalon_burst_address; burst_bytes_enabled_i : t_pgen_bytes_enabled) is
			variable v_burst_readdata : std_logic_vector((avalon_burst_read_outputs_o.readdata'length - 1) downto 0);
		begin
			-- Considering valid data available
			avalon_burst_read_outputs_o.readdatavalid <= '1';

			-- Registers Data Read
			case (burst_read_address_i) is
				-- Case for access to all registers address

				-- Generator Burst Register                 (64 bits):
				when (PGEN_GENERATOR_BURST_REG_ADDRESS + PGEN_BURST_REGISTERS_ADDRESS_OFFSET) =>
					--   63-57 : Reserved                       [-]
					v_burst_readdata(63 downto 57) := (others => '0');
					--   56-56 : SpaceWire Flag 1 for Pattern 1 [R]
					v_burst_readdata(56)           := burst_read_registers_i.GENERATOR_BURST_REGISTER.PATTERN_1_SPW_FLAG_1;
					--   55-48 : SpaceWire Data 1 for Pattern 1 [R]
					v_burst_readdata(55 downto 48) := burst_read_registers_i.GENERATOR_BURST_REGISTER.PATTERN_1_SPW_DATA_1;
					--   47-41 : Reserved                       [-]
					v_burst_readdata(47 downto 41) := (others => '0');
					--   40-40 : SpaceWire Flag 0 for Pattern 1 [R]
					v_burst_readdata(40)           := burst_read_registers_i.GENERATOR_BURST_REGISTER.PATTERN_1_SPW_FLAG_0;
					--   39-32 : SpaceWire Data 0 for Pattern 1 [R]
					v_burst_readdata(39 downto 32) := burst_read_registers_i.GENERATOR_BURST_REGISTER.PATTERN_1_SPW_DATA_0;
					--   31-25 : Reserved                       [-]
					v_burst_readdata(31 downto 25) := (others => '0');
					--   24-24 : SpaceWire Flag 1 for Pattern 0 [R]
					v_burst_readdata(24)           := burst_read_registers_i.GENERATOR_BURST_REGISTER.PATTERN_0_SPW_FLAG_1;
					--   23-16 : SpaceWire Data 1 for Pattern 0 [R]
					v_burst_readdata(23 downto 16) := burst_read_registers_i.GENERATOR_BURST_REGISTER.PATTERN_0_SPW_DATA_1;
					--   15- 9 : Reserved                       [-]
					v_burst_readdata(15 downto 9)  := (others => '0');
					--    8- 8 : SpaceWire Flag 0 for Pattern 0 [R]
					v_burst_readdata(8)            := burst_read_registers_i.GENERATOR_BURST_REGISTER.PATTERN_0_SPW_FLAG_0;
					--    7- 0 : SpaceWire Data 0 for Pattern 0 [R]
					v_burst_readdata(7 downto 0)   := burst_read_registers_i.GENERATOR_BURST_REGISTER.PATTERN_0_SPW_DATA_0;

				when others =>
					v_burst_readdata := (others => '0');

			end case;

			-- Byte enable operation
			if (burst_bytes_enabled_i(7) = '1') then
				avalon_burst_read_outputs_o.readdata(63 downto 56) <= v_burst_readdata(63 downto 56);
			end if;
			if (burst_bytes_enabled_i(6) = '1') then
				avalon_burst_read_outputs_o.readdata(55 downto 48) <= v_burst_readdata(55 downto 48);
			end if;
			if (burst_bytes_enabled_i(5) = '1') then
				avalon_burst_read_outputs_o.readdata(47 downto 40) <= v_burst_readdata(47 downto 40);
			end if;
			if (burst_bytes_enabled_i(4) = '1') then
				avalon_burst_read_outputs_o.readdata(39 downto 32) <= v_burst_readdata(39 downto 32);
			end if;
			if (burst_bytes_enabled_i(3) = '1') then
				avalon_burst_read_outputs_o.readdata(31 downto 24) <= v_burst_readdata(31 downto 24);
			end if;
			if (burst_bytes_enabled_i(2) = '1') then
				avalon_burst_read_outputs_o.readdata(23 downto 16) <= v_burst_readdata(23 downto 16);
			end if;
			if (burst_bytes_enabled_i(1) = '1') then
				avalon_burst_read_outputs_o.readdata(15 downto 8) <= v_burst_readdata(15 downto 8);
			end if;
			if (burst_bytes_enabled_i(0) = '1') then
				avalon_burst_read_outputs_o.readdata(7 downto 0) <= v_burst_readdata(7 downto 0);
			end if;

		end procedure p_burst_readdata;

		variable v_read_state_machine     : t_read_state_machine        := NORMAL;
		variable v_pipeline_state_machine : t_pipeline_state_machine    := WAITING;
		variable v_burst_read_address     : t_pgen_avalon_burst_address := 0;
		variable v_burst_burst_counter    : t_pgen_burst_counter        := 0;
		variable v_burst_bytes_enabled    : t_pgen_bytes_enabled        := (others => '0');
		variable v_burst_reading_started  : std_logic                   := '0';
	begin
		if (rst_i = '1') then
			avalon_burst_read_outputs_o.waitrequest   <= '1';
			avalon_burst_read_outputs_o.readdatavalid <= '0';
			avalon_burst_read_outputs_o.readdata      <= (others => '0');
			v_read_state_machine                      := NORMAL;
			v_pipeline_state_machine                  := STANDBY;
			v_burst_read_address                      := 0;
			v_burst_burst_counter                     := 0;
			v_burst_bytes_enabled                     := (others => '0');
			v_burst_reading_started                   := '0';
			s_rdreq                                   <= '0';
			s_wrreq                                   <= '0';
			s_fifo_data_used                          <= '0';
		elsif (rising_edge(clk_i)) then
			s_wrreq                                   <= '0';
			s_rdreq                                   <= '0';
			s_fifo_data_used                          <= '0';
			avalon_burst_read_outputs_o.readdatavalid <= '0';
			avalon_burst_read_outputs_o.waitrequest   <= '1';

			-- Commands Pipelining
			if (avalon_burst_read_inputs_i.read = '1') then
				case (v_pipeline_state_machine) is

					when STANDBY =>
						if (v_burst_reading_started = '1') then
							if (s_pipeline_fifo_outputs.full = '1') then
								avalon_burst_read_outputs_o.waitrequest <= '1';
								s_wrreq                                 <= '0';
								v_pipeline_state_machine                := STANDBY;
							else
								avalon_burst_read_outputs_o.waitrequest <= '0';
								s_wrreq                                 <= '1';
								v_pipeline_state_machine                := RECORDING;
							end if;
						else
							--							v_burst_read_address               := to_integer(unsigned(avalon_burst_read_inputs_i.address));
							v_burst_read_address                    := PGEN_GENERATOR_BURST_REG_ADDRESS + PGEN_BURST_REGISTERS_ADDRESS_OFFSET;
							v_burst_burst_counter                   := to_integer(unsigned(avalon_burst_read_inputs_i.burstcount));
							v_burst_bytes_enabled                   := avalon_burst_read_inputs_i.byteenable;
							v_burst_reading_started                 := '1';
							avalon_burst_read_outputs_o.waitrequest <= '0';
							s_wrreq                                 <= '0';
							v_pipeline_state_machine                := WAITING;
						end if;

					when WAITING =>
						v_pipeline_state_machine := STANDBY;

					when RECORDING =>
						s_wrreq                  <= '0';
						v_pipeline_state_machine := STANDBY;

				end case;
			end if;

			-- Data Reading
			if (v_burst_reading_started = '1') then
				case (v_read_state_machine) is

					when NORMAL =>
						if (pgen_controller_outputs_i.fifo_data_valid = '1') then
							if (s_fifo_data_used = '1') then --Dado preparado para o proximo estágio
								p_burst_readdata(v_burst_read_address, v_burst_bytes_enabled);
								if (v_burst_burst_counter > 1) then
									v_burst_burst_counter := v_burst_burst_counter - 1;
									--v_burst_read_address  := v_burst_read_address + 1;
									s_fifo_data_used      <= '1';
									v_read_state_machine  := BURST;
								else
									if (s_pipeline_fifo_outputs.empty = '0') then
										s_rdreq                 <= '1';
										v_burst_reading_started := '1';
										v_read_state_machine    := FETCHING;
									else
										v_burst_reading_started := '0';
										v_read_state_machine    := NORMAL;
									end if;
								end if;
							else        --Dado não preparado para o proximo estágio
								s_fifo_data_used <= '1';
							end if;
						else
							v_read_state_machine := NORMAL;
						end if;

					when BURST =>
						if (pgen_controller_outputs_i.fifo_data_valid = '1') then
							if (s_fifo_data_used = '1') then --Dado preparado para o proximo estágio
								p_burst_readdata(v_burst_read_address, v_burst_bytes_enabled);
								v_burst_burst_counter := v_burst_burst_counter - 1;
							--v_burst_read_address  := v_burst_read_address + 1;
							else        --Dado não preparado para o proximo estágio
								s_fifo_data_used <= '1';
							end if;
						end if;
						if (v_burst_burst_counter > 0) then
							s_fifo_data_used     <= '1';
							v_read_state_machine := BURST;
						else
							if (s_pipeline_fifo_outputs.empty = '0') then
								s_rdreq                 <= '1';
								v_burst_reading_started := '1';
								v_read_state_machine    := FETCHING;
							else
								v_burst_reading_started := '0';
								v_read_state_machine    := NORMAL;
							end if;
						end if;

					when FETCHING =>
						if (s_rdreq = '1') then
							s_rdreq                 <= '0';
							v_burst_reading_started := '1';
							v_read_state_machine    := FETCHING;
						else
							--							v_burst_read_address    := to_integer(unsigned(avalon_burst_read_inputs_i.address));
							v_burst_read_address    := PGEN_GENERATOR_BURST_REG_ADDRESS + PGEN_BURST_REGISTERS_ADDRESS_OFFSET;
							v_burst_burst_counter   := to_integer(unsigned(s_pipeline_fifo_data_output.burstcount));
							v_burst_bytes_enabled   := s_pipeline_fifo_data_output.byteenable;
							v_burst_reading_started := '1';

							v_read_state_machine := NORMAL;
						end if;

				end case;
			end if;

		end if;
	end process p_pgen_avalon_burst_read;

	-- Signals assingments
	s_pipeline_fifo_inputs.wrreq <= (s_wrreq) when (s_pipeline_fifo_outputs.full = '0') else ('0');
	s_pipeline_fifo_inputs.rdreq <= (s_rdreq) when (s_pipeline_fifo_outputs.empty = '0') else ('0');

	pgen_controller_inputs_o.fifo_data_used <= (s_fifo_data_used) when (pgen_controller_outputs_i.fifo_data_valid = '1') else ('0');

	s_pipeline_fifo_data_input.address    <= avalon_burst_read_inputs_i.address(7 downto 0);
	s_pipeline_fifo_data_input.byteenable <= avalon_burst_read_inputs_i.byteenable;
	s_pipeline_fifo_data_input.burstcount <= avalon_burst_read_inputs_i.burstcount;

	s_pipeline_fifo_inputs.data(23 downto 16) <= s_pipeline_fifo_data_input.address;
	s_pipeline_fifo_inputs.data(15 downto 8)  <= s_pipeline_fifo_data_input.byteenable;
	s_pipeline_fifo_inputs.data(7 downto 0)   <= s_pipeline_fifo_data_input.burstcount;

	s_pipeline_fifo_data_output.address    <= s_pipeline_fifo_outputs.q(23 downto 16);
	s_pipeline_fifo_data_output.byteenable <= s_pipeline_fifo_outputs.q(15 downto 8);
	s_pipeline_fifo_data_output.burstcount <= s_pipeline_fifo_outputs.q(7 downto 0);

end architecture rtl;

