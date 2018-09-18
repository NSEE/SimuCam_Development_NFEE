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
		clk_i                       : in  std_logic;
		rst_i                       : in  std_logic;
		pgen_mm_write_registers_i   : in  t_pgen_mm_write_registers;
		pgen_controller_inputs_i    : in  t_pgen_controller_inputs;
		pgen_mm_read_registers_o    : out t_pgen_mm_read_registers;
		pgen_burst_read_registers_o : out t_pgen_burst_read_registers;
		pgen_controller_outputs_o   : out t_pgen_controller_outputs
	);
end entity pgen_controller_ent;

architecture rtl of pgen_controller_ent is

	signal s_pgen_data_fifo_inputs  : t_pgen_data_fifo_inputs;
	signal s_pgen_data_fifo_outputs : t_pgen_data_fifo_outputs;

	signal s_pgen_data_fifo_data_input  : t_pgen_data_fifo_data;
	signal s_pgen_data_fifo_data_output : t_pgen_data_fifo_data;

	signal s_wrreq : std_logic;

	type t_controller_state_machine is (
		STOPPED,
		RUNNING
	);

	function f_pattern_algorithm(algorithm_inputs_i : t_pgen_pattern_algorithm_inputs) return t_pgen_pattern_algorithm_outputs is
		variable v_algorithm_outputs : t_pgen_pattern_algorithm_outputs;
		variable v_tc                : std_logic_vector(7 downto 0)  := (others => '0');
		variable v_ccdid             : std_logic_vector(1 downto 0)  := (others => '0');
		variable v_ccdside           : std_logic_vector(0 downto 0)  := (others => '0');
		variable v_rownb             : std_logic_vector(15 downto 0) := (others => '0');
		variable v_colnb             : std_logic_vector(15 downto 0) := (others => '0');
	begin
		--Conversion to std_logic_vector
		v_tc      := std_logic_vector(to_unsigned(algorithm_inputs_i.tico, 8));
		v_ccdid   := std_logic_vector(to_unsigned(algorithm_inputs_i.ccdid, 2));
		v_ccdside := std_logic_vector(to_unsigned(algorithm_inputs_i.ccdside, 1));
		v_rownb   := std_logic_vector(to_unsigned(algorithm_inputs_i.y, 16));
		v_colnb   := std_logic_vector(to_unsigned(algorithm_inputs_i.x, 16));

		-- TC: value of the time code in [0..7]
		-- TC = TiCo % 8
		v_algorithm_outputs.tc      := v_tc(2 downto 0);
		-- CCDID: ID of the CCD in [0..3]
		v_algorithm_outputs.ccdid   := v_ccdid(1 downto 0);
		-- CCDSIDE: 0 for left, 1 for right
		v_algorithm_outputs.ccdside := v_ccdside(0);
		-- ROWNB: row number in [0..31]
		-- ROWNB = Y % 32
		v_algorithm_outputs.rownb   := v_rownb(4 downto 0);
		-- COLNB: column number in [0..31]
		-- COLNB = X % 32
		v_algorithm_outputs.colnb   := v_colnb(4 downto 0);

		return v_algorithm_outputs;
	end function f_pattern_algorithm;

	function f_generate_next_state(current_state_i : t_pgen_pattern_algorithm_inputs) return t_pgen_pattern_algorithm_inputs is
		variable v_next_state : t_pgen_pattern_algorithm_inputs;
	begin

		v_next_state := current_state_i;

		if (current_state_i.ccdside = c_LEFT_CCD_NUMBER) then --left side
			if (current_state_i.x < c_LEFT_CCD_END_POSITION_X) then --check if current column in not the last one
				v_next_state.x := current_state_i.x + 1;
			else                        --end of current row reached, pass to next row
				v_next_state.x := c_LEFT_CCD_START_POSITION_X;
				if (current_state_i.y < c_LEFT_CCD_END_POSITION_Y) then --check if is the current row is not the last row
					v_next_state.y := current_state_i.y + 1;
				else                    --last row ended, pass to right side of the same CCD
					if (current_state_i.tico < (c_TICO_SIZE - 1)) then
						v_next_state.tico := current_state_i.tico + 1;
					else
						v_next_state.tico := 0;
					end if;
					v_next_state.x       := c_RIGHT_CCD_START_POSITION_X;
					v_next_state.y       := c_RIGHT_CCD_START_POSITION_Y;
					v_next_state.ccdside := c_RIGHT_CCD_NUMBER;
					v_next_state.ccdid   := current_state_i.ccdid;
				end if;
			end if;
		else                            --right side
			if (current_state_i.x > c_RIGHT_CCD_END_POSITION_X) then --check if current column in not the last one
				v_next_state.x := current_state_i.x - 1;
			else                        --end of current row reached, pass to next row
				v_next_state.x := c_RIGHT_CCD_START_POSITION_X;
				if (current_state_i.y < c_RIGHT_CCD_END_POSITION_Y) then --check if is the current row is not the last row
					v_next_state.y := current_state_i.y + 1;
				else                    --last row ended, pass to left side of the next CCD
					if (current_state_i.tico < (c_TICO_SIZE - 1)) then
						v_next_state.tico := current_state_i.tico + 1;
					else
						v_next_state.tico := 0;
					end if;
					v_next_state.x       := c_LEFT_CCD_START_POSITION_X;
					v_next_state.y       := c_LEFT_CCD_START_POSITION_Y;
					v_next_state.ccdside := c_LEFT_CCD_NUMBER;
					if (current_state_i.ccdid < (c_CCDID_SIZE - 1)) then
						v_next_state.ccdid := current_state_i.ccdid + 1;
					else
						v_next_state.ccdid := 0;
					end if;
				end if;
			end if;
		end if;

		return v_next_state;
	end function f_generate_next_state;

begin

	pgen_data_sc_fifo_inst : entity work.data_sc_fifo
		port map(
			aclr  => rst_i,
			clock => clk_i,
			data  => s_pgen_data_fifo_inputs.data,
			rdreq => s_pgen_data_fifo_inputs.rdreq,
			sclr  => s_pgen_data_fifo_inputs.sclr,
			wrreq => s_pgen_data_fifo_inputs.wrreq,
			empty => s_pgen_data_fifo_outputs.empty,
			full  => s_pgen_data_fifo_outputs.full,
			q     => s_pgen_data_fifo_outputs.q
		);

	p_pgen_controller : process(clk_i, rst_i) is
		variable v_controller_state_machine : t_controller_state_machine := STOPPED;
		variable v_current_algorithm_state  : t_pgen_pattern_algorithm_inputs;
		variable v_last_ccdside             : std_logic                  := '0';

		variable v_pattern_1_inputs  : t_pgen_pattern_algorithm_inputs;
		variable v_pattern_1_outputs : t_pgen_pattern_algorithm_outputs;
		variable v_pattern_0_inputs  : t_pgen_pattern_algorithm_inputs;
		variable v_pattern_0_outputs : t_pgen_pattern_algorithm_outputs;
	begin
		if (rst_i = '1') then
			v_controller_state_machine                                     := STOPPED;
			v_current_algorithm_state.tico                                 := 0;
			v_current_algorithm_state.ccdid                                := 0;
			v_current_algorithm_state.ccdside                              := c_LEFT_CCD_NUMBER;
			v_current_algorithm_state.x                                    := c_LEFT_CCD_START_POSITION_X;
			v_current_algorithm_state.y                                    := c_LEFT_CCD_START_POSITION_Y;
			v_last_ccdside                                                 := '0';
			pgen_mm_read_registers_o.generator_status_register.stopped_bit <= '0';
			pgen_mm_read_registers_o.generator_status_register.reseted_bit <= '0';
			s_pgen_data_fifo_inputs.sclr                                   <= '1';
			s_wrreq                                                        <= '0';
			s_pgen_data_fifo_data_input.flag_1                             <= '0';
			s_pgen_data_fifo_data_input.pattern_1                          <= (others => '0');
			s_pgen_data_fifo_data_input.flag_0                             <= '0';
			s_pgen_data_fifo_data_input.pattern_0                          <= (others => '0');
			v_pattern_1_outputs.tc                                         := (others => '0');
			v_pattern_1_outputs.ccdid                                      := (others => '0');
			v_pattern_1_outputs.ccdside                                    := '0';
			v_pattern_1_outputs.rownb                                      := (others => '0');
			v_pattern_1_outputs.colnb                                      := (others => '0');
			v_pattern_0_outputs.tc                                         := (others => '0');
			v_pattern_0_outputs.ccdid                                      := (others => '0');
			v_pattern_0_outputs.ccdside                                    := '0';
			v_pattern_0_outputs.rownb                                      := (others => '0');
			v_pattern_0_outputs.colnb                                      := (others => '0');
		elsif (rising_edge(clk_i)) then
			s_pgen_data_fifo_inputs.sclr <= '0';

			case v_controller_state_machine is

				when STOPPED =>
					v_controller_state_machine                                     := STOPPED;
					pgen_mm_read_registers_o.generator_status_register.stopped_bit <= '1';
					s_wrreq                                                        <= '0';

					if (pgen_mm_write_registers_i.generator_control_register.reset_bit = '1') then
						-- reset procedure
						s_pgen_data_fifo_inputs.sclr      <= '1';
						v_current_algorithm_state.tico    := to_integer(unsigned(pgen_mm_write_registers_i.initial_transmission_state_register.initial_timecode));
						v_current_algorithm_state.ccdid   := to_integer(unsigned(pgen_mm_write_registers_i.initial_transmission_state_register.initial_ccd_id));
						v_current_algorithm_state.ccdside := to_integer(unsigned(pgen_mm_write_registers_i.initial_transmission_state_register.initial_ccd_side));
						v_last_ccdside                    := pgen_mm_write_registers_i.initial_transmission_state_register.initial_ccd_side(0);
						if (v_current_algorithm_state.ccdside = c_LEFT_CCD_NUMBER) then
							v_current_algorithm_state.x := c_LEFT_CCD_START_POSITION_X;
							v_current_algorithm_state.y := c_LEFT_CCD_START_POSITION_Y;
						else
							v_current_algorithm_state.x := c_RIGHT_CCD_START_POSITION_X;
							v_current_algorithm_state.y := c_RIGHT_CCD_START_POSITION_Y;
						end if;

						v_pattern_1_inputs        := v_current_algorithm_state;
						v_pattern_1_outputs       := f_pattern_algorithm(v_pattern_1_inputs);
						v_current_algorithm_state := f_generate_next_state(v_current_algorithm_state);

						v_pattern_0_inputs        := v_current_algorithm_state;
						v_pattern_0_outputs       := f_pattern_algorithm(v_pattern_0_inputs);
						v_current_algorithm_state := f_generate_next_state(v_current_algorithm_state);

						if (pgen_mm_write_registers_i.generator_control_register.start_bit = '1') then
							pgen_mm_read_registers_o.generator_status_register.stopped_bit <= '0';
							pgen_mm_read_registers_o.generator_status_register.reseted_bit <= '0';
							v_controller_state_machine                                     := RUNNING;
						else
							pgen_mm_read_registers_o.generator_status_register.stopped_bit <= '1';
							pgen_mm_read_registers_o.generator_status_register.reseted_bit <= '1';
							v_controller_state_machine                                     := STOPPED;
						end if;
					else
						if (pgen_mm_write_registers_i.generator_control_register.start_bit = '1') then
							pgen_mm_read_registers_o.generator_status_register.stopped_bit <= '0';
							pgen_mm_read_registers_o.generator_status_register.reseted_bit <= '0';
							v_controller_state_machine                                     := RUNNING;
						end if;
					end if;

				when RUNNING =>
					v_controller_state_machine                                     := RUNNING;
					pgen_mm_read_registers_o.generator_status_register.stopped_bit <= '0';
					pgen_mm_read_registers_o.generator_status_register.reseted_bit <= '0';
					s_wrreq                                                        <= '0';

					if (s_pgen_data_fifo_outputs.full = '0') then
						if not (v_pattern_1_outputs.ccdside = v_last_ccdside) then -- Pacote virou no pattern 1
							-- Envia um pacote completo com EOP
							s_pgen_data_fifo_data_input.flag_1                 <= '1';
							s_pgen_data_fifo_data_input.pattern_1(15 downto 8) <= x"FF"; --Descartado
							s_pgen_data_fifo_data_input.pattern_1(7 downto 0)  <= x"FF"; --Descartado
							s_pgen_data_fifo_data_input.flag_0                 <= '1';
							s_pgen_data_fifo_data_input.pattern_0(15 downto 8) <= x"FF"; --Descartado
							s_pgen_data_fifo_data_input.pattern_0(7 downto 0)  <= x"01"; --EOP
							-- Atualiza v_last_ccdside com o novo CCD SIDE
							v_last_ccdside                                     := v_pattern_1_outputs.ccdside;
						elsif not (v_pattern_0_outputs.ccdside = v_last_ccdside) then -- Pacote virou no pattern 0
							-- Envia pattern 1 mais um EOP
							s_pgen_data_fifo_data_input.flag_1                 <= '0';
							s_pgen_data_fifo_data_input.pattern_1              <= (v_pattern_1_outputs.tc) & (v_pattern_1_outputs.ccdid) & (v_pattern_1_outputs.ccdside) & (v_pattern_1_outputs.rownb) & (v_pattern_1_outputs.colnb);
							s_pgen_data_fifo_data_input.flag_0                 <= '1';
							s_pgen_data_fifo_data_input.pattern_0(15 downto 8) <= x"FF"; --Descartado
							s_pgen_data_fifo_data_input.pattern_0(7 downto 0)  <= x"01"; --EOP
							-- Atualiza v_last_ccdside com o novo CCD SIDE
							v_last_ccdside                                     := v_pattern_0_outputs.ccdside;
							-- Coloca pattern 0 como futuro pattern 1
							v_pattern_1_inputs                                 := v_pattern_0_inputs;
							v_pattern_1_outputs                                := f_pattern_algorithm(v_pattern_1_inputs);
							-- Coloca current pattern no pattern 0
							v_pattern_0_inputs                                 := v_current_algorithm_state;
							v_pattern_0_outputs                                := f_pattern_algorithm(v_pattern_0_inputs);
							v_current_algorithm_state                          := f_generate_next_state(v_current_algorithm_state);
						else            --Pacote não chegou ao fim nem no pattern 1 nem no pattern 0
						-- Envia dados atuais
							s_pgen_data_fifo_data_input.flag_1    <= '0';
							s_pgen_data_fifo_data_input.pattern_1 <= (v_pattern_1_outputs.tc) & (v_pattern_1_outputs.ccdid) & (v_pattern_1_outputs.ccdside) & (v_pattern_1_outputs.rownb) & (v_pattern_1_outputs.colnb);
							s_pgen_data_fifo_data_input.flag_0    <= '0';
							s_pgen_data_fifo_data_input.pattern_0 <= (v_pattern_0_outputs.tc) & (v_pattern_0_outputs.ccdid) & (v_pattern_0_outputs.ccdside) & (v_pattern_0_outputs.rownb) & (v_pattern_0_outputs.colnb);
							-- Mantém v_last_ccdside com o CCD SIDE atual
							v_last_ccdside                        := v_pattern_1_outputs.ccdside;
							-- Coloca current pattern no pattern 1
							v_pattern_1_inputs                    := v_current_algorithm_state;
							v_pattern_1_outputs                   := f_pattern_algorithm(v_pattern_1_inputs);
							v_current_algorithm_state             := f_generate_next_state(v_current_algorithm_state);
							-- Coloca current pattern no pattern 0
							v_pattern_0_inputs                    := v_current_algorithm_state;
							v_pattern_0_outputs                   := f_pattern_algorithm(v_pattern_0_inputs);
							v_current_algorithm_state             := f_generate_next_state(v_current_algorithm_state);
						end if;
						s_wrreq <= '1';
					end if;

					if (pgen_mm_write_registers_i.generator_control_register.stop_bit = '1') then
						v_controller_state_machine := STOPPED;
					end if;

			end case;

		end if;
	end process p_pgen_controller;

	-- Signals Assingments
	s_pgen_data_fifo_inputs.rdreq             <= (pgen_controller_inputs_i.fifo_data_used) when (s_pgen_data_fifo_outputs.empty = '0') else ('0');
	pgen_controller_outputs_o.fifo_data_valid <= not (s_pgen_data_fifo_outputs.empty);

	s_pgen_data_fifo_inputs.wrreq <= (s_wrreq) when (s_pgen_data_fifo_outputs.full = '0') else ('0');

	s_pgen_data_fifo_inputs.data(33)           <= s_pgen_data_fifo_data_input.flag_1;
	s_pgen_data_fifo_inputs.data(32 downto 17) <= s_pgen_data_fifo_data_input.pattern_1;
	s_pgen_data_fifo_inputs.data(16)           <= s_pgen_data_fifo_data_input.flag_0;
	s_pgen_data_fifo_inputs.data(15 downto 0)  <= s_pgen_data_fifo_data_input.pattern_0;

	s_pgen_data_fifo_data_output.flag_1    <= s_pgen_data_fifo_outputs.q(33);
	s_pgen_data_fifo_data_output.pattern_1 <= s_pgen_data_fifo_outputs.q(32 downto 17);
	s_pgen_data_fifo_data_output.flag_0    <= s_pgen_data_fifo_outputs.q(16);
	s_pgen_data_fifo_data_output.pattern_0 <= s_pgen_data_fifo_outputs.q(15 downto 0);

	pgen_burst_read_registers_o.generator_burst_register.pattern_1_spw_flag_1 <= s_pgen_data_fifo_data_output.flag_1;
	pgen_burst_read_registers_o.generator_burst_register.pattern_1_spw_data_1 <= s_pgen_data_fifo_data_output.pattern_1(15 downto 8);
	pgen_burst_read_registers_o.generator_burst_register.pattern_1_spw_flag_0 <= s_pgen_data_fifo_data_output.flag_1;
	pgen_burst_read_registers_o.generator_burst_register.pattern_1_spw_data_0 <= s_pgen_data_fifo_data_output.pattern_1(7 downto 0);
	pgen_burst_read_registers_o.generator_burst_register.pattern_0_spw_flag_1 <= s_pgen_data_fifo_data_output.flag_0;
	pgen_burst_read_registers_o.generator_burst_register.pattern_0_spw_data_1 <= s_pgen_data_fifo_data_output.pattern_0(15 downto 8);
	pgen_burst_read_registers_o.generator_burst_register.pattern_0_spw_flag_0 <= s_pgen_data_fifo_data_output.flag_0;
	pgen_burst_read_registers_o.generator_burst_register.pattern_0_spw_data_0 <= s_pgen_data_fifo_data_output.pattern_0(7 downto 0);

end architecture rtl;
