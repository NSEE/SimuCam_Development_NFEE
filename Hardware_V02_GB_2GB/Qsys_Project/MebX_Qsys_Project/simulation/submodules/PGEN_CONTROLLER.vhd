library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.pgen_controller_pkg.all;
use work.pgen_pattern_pkg.all;
use work.pgen_data_fifo_pkg.all;
use work.pgen_mm_registers_pkg.all;
use work.pgen_burst_registers_pkg.all;

entity pgen_controller_ent is
	port(
		clk                       : in  std_logic;
		rst                       : in  std_logic;
		pgen_mm_write_registers   : in  pgen_mm_write_registers_type;
		pgen_mm_read_registers    : out pgen_mm_read_registers_type;
		pgen_burst_read_registers : out pgen_burst_read_registers_type;
		pgen_controller_inputs    : in  pgen_controller_inputs_type;
		pgen_controller_outputs   : out pgen_controller_outputs_type
	);
end entity pgen_controller_ent;

architecture pgen_controller_arc of pgen_controller_ent is

	signal pgen_data_fifo_inputs_sig  : pgen_data_fifo_inputs_type;
	signal pgen_data_fifo_outputs_sig : pgen_data_fifo_outputs_type;

	signal pgen_data_fifo_data_input_sig  : pgen_data_fifo_data_type;
	signal pgen_data_fifo_data_output_sig : pgen_data_fifo_data_type;

	signal wrreq_sig : std_logic;

	type controller_state_machine_type is (
		stopped_state,
		running_state
	);

	function pattern_algorithm(algorithm_inputs : pgen_pattern_algorithm_inputs_type) return pgen_pattern_algorithm_outputs_type is
		variable algorithm_outputs : pgen_pattern_algorithm_outputs_type;
		variable TC_var            : std_logic_vector(7 downto 0)  := (others => '0');
		variable CCDID_var         : std_logic_vector(1 downto 0)  := (others => '0');
		variable CCDSIDE_var       : std_logic_vector(0 downto 0)  := (others => '0');
		variable ROWNB_var         : std_logic_vector(15 downto 0) := (others => '0');
		variable COLNB_var         : std_logic_vector(15 downto 0) := (others => '0');
	begin
		--Conversion to std_logic_vector
		TC_var      := std_logic_vector(to_unsigned(algorithm_inputs.TiCo, 8));
		CCDID_var   := std_logic_vector(to_unsigned(algorithm_inputs.CCDID, 2));
		CCDSIDE_var := std_logic_vector(to_unsigned(algorithm_inputs.CCDSIDE, 1));
		ROWNB_var   := std_logic_vector(to_unsigned(algorithm_inputs.Y, 16));
		COLNB_var   := std_logic_vector(to_unsigned(algorithm_inputs.X, 16));

		-- TC: value of the time code in [0..7]
		-- TC = TiCo % 8
		algorithm_outputs.TC      := TC_var(2 downto 0);
		-- CCDID: ID of the CCD in [0..3]
		algorithm_outputs.CCDID   := CCDID_var(1 downto 0);
		-- CCDSIDE: 0 for left, 1 for right
		algorithm_outputs.CCDSIDE := CCDSIDE_var(0);
		-- ROWNB: row number in [0..31]
		-- ROWNB = Y % 32
		algorithm_outputs.ROWNB   := ROWNB_var(4 downto 0);
		-- COLNB: column number in [0..31]
		-- COLNB = X % 32
		algorithm_outputs.COLNB   := COLNB_var(4 downto 0);

		return algorithm_outputs;
	end function pattern_algorithm;

	function generate_next_state(current_state : pgen_pattern_algorithm_inputs_type) return pgen_pattern_algorithm_inputs_type is
		variable next_state : pgen_pattern_algorithm_inputs_type;
	begin

		next_state := current_state;

		if (current_state.CCDSIDE = LEFT_CCD_NUMBER) then --left side
			if (current_state.X < LEFT_CCD_END_POSITION_X) then --check if current column in not the last one
				next_state.X := current_state.X + 1;
			else                        --end of current row reached, pass to next row
				next_state.X := LEFT_CCD_START_POSITION_X;
				if (current_state.Y < LEFT_CCD_END_POSITION_Y) then --check if is the current row is not the last row
					next_state.Y := current_state.Y + 1;
				else                    --last row ended, pass to right side of the same CCD
					if (current_state.TiCo < (TiCo_SIZE - 1)) then
						next_state.TiCo := current_state.TiCo + 1;
					else
						next_state.TiCo := 0;
					end if;
					next_state.X       := RIGHT_CCD_START_POSITION_X;
					next_state.Y       := RIGHT_CCD_START_POSITION_Y;
					next_state.CCDSIDE := RIGHT_CCD_NUMBER;
					next_state.CCDID   := current_state.CCDID;
				end if;
			end if;
		else                            --right side
			if (current_state.X > RIGHT_CCD_END_POSITION_X) then --check if current column in not the last one
				next_state.X := current_state.X - 1;
			else                        --end of current row reached, pass to next row
				next_state.X := RIGHT_CCD_START_POSITION_X;
				if (current_state.Y < RIGHT_CCD_END_POSITION_Y) then --check if is the current row is not the last row
					next_state.Y := current_state.Y + 1;
				else                    --last row ended, pass to left side of the next CCD
					if (current_state.TiCo < (TiCo_SIZE - 1)) then
						next_state.TiCo := current_state.TiCo + 1;
					else
						next_state.TiCo := 0;
					end if;
					next_state.X       := LEFT_CCD_START_POSITION_X;
					next_state.Y       := LEFT_CCD_START_POSITION_Y;
					next_state.CCDSIDE := LEFT_CCD_NUMBER;
					if (current_state.CCDID < (CCDID_SIZE - 1)) then
						next_state.CCDID := current_state.CCDID + 1;
					else
						next_state.CCDID := 0;
					end if;
				end if;
			end if;
		end if;

		return next_state;
	end function generate_next_state;

begin

	pgen_data_sc_fifo_inst : entity work.data_sc_fifo
		port map(
			aclr  => rst,
			clock => clk,
			data  => pgen_data_fifo_inputs_sig.data,
			rdreq => pgen_data_fifo_inputs_sig.rdreq,
			sclr  => pgen_data_fifo_inputs_sig.sclr,
			wrreq => pgen_data_fifo_inputs_sig.wrreq,
			empty => pgen_data_fifo_outputs_sig.empty,
			full  => pgen_data_fifo_outputs_sig.full,
			q     => pgen_data_fifo_outputs_sig.q
		);

	pgen_controller_proc : process(clk, rst) is
		variable controller_state_machine : controller_state_machine_type := stopped_state;
		variable current_algorithm_state  : pgen_pattern_algorithm_inputs_type;
		variable last_ccdside_var         : std_logic                     := '0';

		variable pattern_1_inputs_var  : pgen_pattern_algorithm_inputs_type;
		variable pattern_1_outputs_var : pgen_pattern_algorithm_outputs_type;
		variable pattern_0_inputs_var  : pgen_pattern_algorithm_inputs_type;
		variable pattern_0_outputs_var : pgen_pattern_algorithm_outputs_type;
	begin
		if (rst = '1') then
			controller_state_machine                                     := stopped_state;
			current_algorithm_state.TiCo                                 := 0;
			current_algorithm_state.CCDID                                := 0;
			current_algorithm_state.CCDSIDE                              := LEFT_CCD_NUMBER;
			current_algorithm_state.X                                    := LEFT_CCD_START_POSITION_X;
			current_algorithm_state.Y                                    := LEFT_CCD_START_POSITION_Y;
			last_ccdside_var                                             := '0';
			pgen_mm_read_registers.GENERATOR_STATUS_REGISTER.STOPPED_BIT <= '0';
			pgen_mm_read_registers.GENERATOR_STATUS_REGISTER.RESETED_BIT <= '0';
			pgen_data_fifo_inputs_sig.sclr                               <= '1';
			wrreq_sig                                                    <= '0';
			pgen_data_fifo_data_input_sig.flag_1                         <= '0';
			pgen_data_fifo_data_input_sig.pattern_1                      <= (others => '0');
			pgen_data_fifo_data_input_sig.flag_0                         <= '0';
			pgen_data_fifo_data_input_sig.pattern_0                      <= (others => '0');
			pattern_1_outputs_var.TC                                     := (others => '0');
			pattern_1_outputs_var.CCDID                                  := (others => '0');
			pattern_1_outputs_var.CCDSIDE                                := '0';
			pattern_1_outputs_var.ROWNB                                  := (others => '0');
			pattern_1_outputs_var.COLNB                                  := (others => '0');
			pattern_0_outputs_var.TC                                     := (others => '0');
			pattern_0_outputs_var.CCDID                                  := (others => '0');
			pattern_0_outputs_var.CCDSIDE                                := '0';
			pattern_0_outputs_var.ROWNB                                  := (others => '0');
			pattern_0_outputs_var.COLNB                                  := (others => '0');
		elsif (rising_edge(clk)) then
			pgen_data_fifo_inputs_sig.sclr <= '0';

			case controller_state_machine is

				when stopped_state =>
					controller_state_machine                                     := stopped_state;
					pgen_mm_read_registers.GENERATOR_STATUS_REGISTER.STOPPED_BIT <= '1';
					wrreq_sig <= '0';

					if (pgen_mm_write_registers.GENERATOR_CONTROL_REGISTER.RESET_BIT = '1') then
						-- reset procedure
						pgen_data_fifo_inputs_sig.sclr  <= '1';
						current_algorithm_state.TiCo    := to_integer(unsigned(pgen_mm_write_registers.INITIAL_TRANSMISSION_STATE_REGISTER.INITIAL_TIMECODE));
						current_algorithm_state.CCDID   := to_integer(unsigned(pgen_mm_write_registers.INITIAL_TRANSMISSION_STATE_REGISTER.INITIAL_CCD_ID));
						current_algorithm_state.CCDSIDE := to_integer(unsigned(pgen_mm_write_registers.INITIAL_TRANSMISSION_STATE_REGISTER.INITIAL_CCD_SIDE));
						last_ccdside_var                := pgen_mm_write_registers.INITIAL_TRANSMISSION_STATE_REGISTER.INITIAL_CCD_SIDE(0);
						if (current_algorithm_state.CCDSIDE = LEFT_CCD_NUMBER) then
							current_algorithm_state.X := LEFT_CCD_START_POSITION_X;
							current_algorithm_state.Y := LEFT_CCD_START_POSITION_Y;
						else
							current_algorithm_state.X := RIGHT_CCD_START_POSITION_X;
							current_algorithm_state.Y := RIGHT_CCD_START_POSITION_Y;
						end if;

						pattern_1_inputs_var    := current_algorithm_state;
						pattern_1_outputs_var   := pattern_algorithm(pattern_1_inputs_var);
						current_algorithm_state := generate_next_state(current_algorithm_state);

						pattern_0_inputs_var    := current_algorithm_state;
						pattern_0_outputs_var   := pattern_algorithm(pattern_0_inputs_var);
						current_algorithm_state := generate_next_state(current_algorithm_state);

						if (pgen_mm_write_registers.GENERATOR_CONTROL_REGISTER.START_BIT = '1') then
							pgen_mm_read_registers.GENERATOR_STATUS_REGISTER.STOPPED_BIT <= '0';
							pgen_mm_read_registers.GENERATOR_STATUS_REGISTER.RESETED_BIT <= '0';
							controller_state_machine                                     := running_state;
						else
							pgen_mm_read_registers.GENERATOR_STATUS_REGISTER.STOPPED_BIT <= '1';
							pgen_mm_read_registers.GENERATOR_STATUS_REGISTER.RESETED_BIT <= '1';
							controller_state_machine                                     := stopped_state;
						end if;
					else
						if (pgen_mm_write_registers.GENERATOR_CONTROL_REGISTER.START_BIT = '1') then
							pgen_mm_read_registers.GENERATOR_STATUS_REGISTER.STOPPED_BIT <= '0';
							pgen_mm_read_registers.GENERATOR_STATUS_REGISTER.RESETED_BIT <= '0';
							controller_state_machine                                     := running_state;
						end if;
					end if;

				when running_state =>
					controller_state_machine                                     := running_state;
					pgen_mm_read_registers.GENERATOR_STATUS_REGISTER.STOPPED_BIT <= '0';
					pgen_mm_read_registers.GENERATOR_STATUS_REGISTER.RESETED_BIT <= '0';
					wrreq_sig                                                    <= '0';

					if (pgen_data_fifo_outputs_sig.full = '0') then
						if not (pattern_1_outputs_var.CCDSIDE = last_ccdside_var) then -- Pacote virou no pattern 1
							-- Envia um pacote completo com EOP
							pgen_data_fifo_data_input_sig.flag_1                 <= '1';
							pgen_data_fifo_data_input_sig.pattern_1(15 downto 8) <= x"FF"; --Descartado
							pgen_data_fifo_data_input_sig.pattern_1(7 downto 0)  <= x"FF"; --Descartado
							pgen_data_fifo_data_input_sig.flag_0                 <= '1';
							pgen_data_fifo_data_input_sig.pattern_0(15 downto 8) <= x"FF"; --Descartado
							pgen_data_fifo_data_input_sig.pattern_0(7 downto 0)  <= x"01"; --EOP
							-- Atualiza last_ccdside_var com o novo CCD SIDE
							last_ccdside_var                                     := pattern_1_outputs_var.CCDSIDE;
						elsif not (pattern_0_outputs_var.CCDSIDE = last_ccdside_var) then -- Pacote virou no pattern 0
							-- Envia pattern 1 mais um EOP
							pgen_data_fifo_data_input_sig.flag_1                 <= '0';
							pgen_data_fifo_data_input_sig.pattern_1              <= (pattern_1_outputs_var.TC) & (pattern_1_outputs_var.CCDID) & (pattern_1_outputs_var.CCDSIDE) & (pattern_1_outputs_var.ROWNB) & (pattern_1_outputs_var.COLNB);
							pgen_data_fifo_data_input_sig.flag_0                 <= '1';
							pgen_data_fifo_data_input_sig.pattern_0(15 downto 8) <= x"FF"; --Descartado
							pgen_data_fifo_data_input_sig.pattern_0(7 downto 0)  <= x"01"; --EOP
							-- Atualiza last_ccdside_var com o novo CCD SIDE
							last_ccdside_var                                     := pattern_0_outputs_var.CCDSIDE;
							-- Coloca pattern 0 como futuro pattern 1
							pattern_1_inputs_var                                 := pattern_0_inputs_var;
							pattern_1_outputs_var                                := pattern_algorithm(pattern_1_inputs_var);
							-- Coloca current pattern no pattern 0
							pattern_0_inputs_var                                 := current_algorithm_state;
							pattern_0_outputs_var                                := pattern_algorithm(pattern_0_inputs_var);
							current_algorithm_state                              := generate_next_state(current_algorithm_state);
						else            --Pacote não chegou ao fim nem no pattern 1 nem no pattern 0
						-- Envia dados atuais
							pgen_data_fifo_data_input_sig.flag_1    <= '0';
							pgen_data_fifo_data_input_sig.pattern_1 <= (pattern_1_outputs_var.TC) & (pattern_1_outputs_var.CCDID) & (pattern_1_outputs_var.CCDSIDE) & (pattern_1_outputs_var.ROWNB) & (pattern_1_outputs_var.COLNB);
							pgen_data_fifo_data_input_sig.flag_0    <= '0';
							pgen_data_fifo_data_input_sig.pattern_0 <= (pattern_0_outputs_var.TC) & (pattern_0_outputs_var.CCDID) & (pattern_0_outputs_var.CCDSIDE) & (pattern_0_outputs_var.ROWNB) & (pattern_0_outputs_var.COLNB);
							-- Mantém last_ccdside_var com o CCD SIDE atual
							last_ccdside_var                        := pattern_1_outputs_var.CCDSIDE;
							-- Coloca current pattern no pattern 1
							pattern_1_inputs_var                    := current_algorithm_state;
							pattern_1_outputs_var                   := pattern_algorithm(pattern_1_inputs_var);
							current_algorithm_state                 := generate_next_state(current_algorithm_state);
							-- Coloca current pattern no pattern 0
							pattern_0_inputs_var                    := current_algorithm_state;
							pattern_0_outputs_var                   := pattern_algorithm(pattern_0_inputs_var);
							current_algorithm_state                 := generate_next_state(current_algorithm_state);
						end if;
						wrreq_sig <= '1';
					end if;

					if (pgen_mm_write_registers.GENERATOR_CONTROL_REGISTER.STOP_BIT = '1') then
						controller_state_machine := stopped_state;
					end if;

			end case;

		end if;
	end process pgen_controller_proc;

	-- Signals Assingments
	pgen_data_fifo_inputs_sig.rdreq         <= (pgen_controller_inputs.fifo_data_used) when (pgen_data_fifo_outputs_sig.empty = '0') else ('0');
	pgen_controller_outputs.fifo_data_valid <= not (pgen_data_fifo_outputs_sig.empty);

	pgen_data_fifo_inputs_sig.wrreq <= (wrreq_sig) when (pgen_data_fifo_outputs_sig.full = '0') else ('0');

	pgen_data_fifo_inputs_sig.data(33)           <= pgen_data_fifo_data_input_sig.flag_1;
	pgen_data_fifo_inputs_sig.data(32 downto 17) <= pgen_data_fifo_data_input_sig.pattern_1;
	pgen_data_fifo_inputs_sig.data(16)           <= pgen_data_fifo_data_input_sig.flag_0;
	pgen_data_fifo_inputs_sig.data(15 downto 0)  <= pgen_data_fifo_data_input_sig.pattern_0;

	pgen_data_fifo_data_output_sig.flag_1    <= pgen_data_fifo_outputs_sig.q(33);
	pgen_data_fifo_data_output_sig.pattern_1 <= pgen_data_fifo_outputs_sig.q(32 downto 17);
	pgen_data_fifo_data_output_sig.flag_0    <= pgen_data_fifo_outputs_sig.q(16);
	pgen_data_fifo_data_output_sig.pattern_0 <= pgen_data_fifo_outputs_sig.q(15 downto 0);

	pgen_burst_read_registers.GENERATOR_BURST_REGISTER.PATTERN_1_SPW_FLAG_1 <= pgen_data_fifo_data_output_sig.flag_1;
	pgen_burst_read_registers.GENERATOR_BURST_REGISTER.PATTERN_1_SPW_DATA_1 <= pgen_data_fifo_data_output_sig.pattern_1(15 downto 8);
	pgen_burst_read_registers.GENERATOR_BURST_REGISTER.PATTERN_1_SPW_FLAG_0 <= pgen_data_fifo_data_output_sig.flag_1;
	pgen_burst_read_registers.GENERATOR_BURST_REGISTER.PATTERN_1_SPW_DATA_0 <= pgen_data_fifo_data_output_sig.pattern_1(7 downto 0);
	pgen_burst_read_registers.GENERATOR_BURST_REGISTER.PATTERN_0_SPW_FLAG_1 <= pgen_data_fifo_data_output_sig.flag_0;
	pgen_burst_read_registers.GENERATOR_BURST_REGISTER.PATTERN_0_SPW_DATA_1 <= pgen_data_fifo_data_output_sig.pattern_0(15 downto 8);
	pgen_burst_read_registers.GENERATOR_BURST_REGISTER.PATTERN_0_SPW_FLAG_0 <= pgen_data_fifo_data_output_sig.flag_0;
	pgen_burst_read_registers.GENERATOR_BURST_REGISTER.PATTERN_0_SPW_DATA_0 <= pgen_data_fifo_data_output_sig.pattern_0(7 downto 0);

end architecture pgen_controller_arc;
