library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.spwc_errinj_pkg.all;
use work.spwc_codec_pkg.all;
use work.spwpkg.all;

entity spwc_errinj_controller_ent is
	port(
		clk_i                       : in  std_logic;
		rst_i                       : in  std_logic;
		errinj_controller_control_i : in  t_spwc_errinj_controller_control;
		spw_codec_link_status_i     : in  t_spwc_codec_link_status;
		spw_codec_err_inj_status_i  : in  t_spwc_codec_err_inj_status;
		errinj_controller_status_o  : out t_spwc_errinj_controller_status;
		spw_codec_err_inj_command_o : out t_spwc_codec_err_inj_command
	);
end entity spwc_errinj_controller_ent;

architecture RTL of spwc_errinj_controller_ent is

	type t_spwc_errinj_controller_fsm is (
		IDLE,                           -- error injection controller is in idle
		WAITING_INJECTION,              -- wating to be able to inject the error
		INJECTING,                      -- error injection
		WAITING_FINISH,                 -- wating error to finish
		FINISHED                        -- error injection controller is finished
	);

	signal s_spwc_errinj_controller_state : t_spwc_errinj_controller_fsm;

	-- registered signals
	signal s_registered_error_code : std_logic_vector(3 downto 0);

begin

	p_spwc_errinj_controller : process(clk_i, rst_i) is
		variable v_spwc_errinj_controller_state : t_spwc_errinj_controller_fsm;
	begin
		if (rst_i = '1') then

			-- fsm state reset
			s_spwc_errinj_controller_state <= IDLE;
			v_spwc_errinj_controller_state := IDLE;

			-- internal signals reset
			s_registered_error_code <= c_SPWC_ERRINJ_CODE_NONE;

			-- outputs reset
			errinj_controller_status_o         <= c_SPWC_ERRINJ_CONTROLLER_STATUS_RST;
			spw_codec_err_inj_command_o.errinj <= '0';
			spw_codec_err_inj_command_o.errsel <= reserved;

		elsif rising_edge(clk_i) then

			-- States Transition --
			-- States transitions FSM
			case (s_spwc_errinj_controller_state) is

				-- state "IDLE"
				when IDLE =>
					-- error injection controller is in idle
					-- default state transition
					s_spwc_errinj_controller_state <= IDLE;
					v_spwc_errinj_controller_state := IDLE;
					-- default internal signal values
					s_registered_error_code        <= c_SPWC_ERRINJ_CODE_NONE;
					-- conditional state transition
					-- check if a start error injection was received
					if (errinj_controller_control_i.start_errinj = '1') then
						-- a start error injection was received
						-- check if the error code is valid
						if ((errinj_controller_control_i.errinj_code = c_SPWC_ERRINJ_CODE_DISCONNECTION) or (errinj_controller_control_i.errinj_code = c_SPWC_ERRINJ_CODE_PARITY) or (errinj_controller_control_i.errinj_code = c_SPWC_ERRINJ_CODE_ESCAPE) or (errinj_controller_control_i.errinj_code = c_SPWC_ERRINJ_CODE_CREDIT) or (errinj_controller_control_i.errinj_code = c_SPWC_ERRINJ_CODE_CHAR)) then
							-- register the error code
							s_registered_error_code        <= errinj_controller_control_i.errinj_code;
							-- go to waiting injection
							s_spwc_errinj_controller_state <= WAITING_INJECTION;
							v_spwc_errinj_controller_state := WAITING_INJECTION;
						end if;
					end if;

				-- state "WAITING_INJECTION"
				when WAITING_INJECTION =>
					-- wating to be able to inject the error
					-- default state transition
					s_spwc_errinj_controller_state <= WAITING_INJECTION;
					v_spwc_errinj_controller_state := WAITING_INJECTION;
					-- default internal signal values
					-- conditional state transition
					-- check if the errinj is in standby (ready to receive a new error)
					if (spw_codec_err_inj_status_i.errstat = stby) then
						-- the errinj is in standby (ready to receive a new error)

						-- check if the selected error can be injected
						case (s_registered_error_code) is

							when (c_SPWC_ERRINJ_CODE_DISCONNECTION) =>
								-- disconnection error, link need to be in running
								-- check if the codec link is in running
								if (spw_codec_link_status_i.running = '1') then
									-- the codec link is in running
									-- go to injecting
									s_spwc_errinj_controller_state <= INJECTING;
									v_spwc_errinj_controller_state := INJECTING;
								end if;

							when (c_SPWC_ERRINJ_CODE_PARITY) =>
								-- parity error, link need to be in running
								-- check if the codec link is in running
								if (spw_codec_link_status_i.running = '1') then
									-- the codec link is in running
									-- go to injecting
									s_spwc_errinj_controller_state <= INJECTING;
									v_spwc_errinj_controller_state := INJECTING;
								end if;

							when (c_SPWC_ERRINJ_CODE_ESCAPE) =>
								-- escape error, link need to be in running
								-- check if the codec link is in running
								if (spw_codec_link_status_i.running = '1') then
									-- the codec link is in running
									-- go to injecting
									s_spwc_errinj_controller_state <= INJECTING;
									v_spwc_errinj_controller_state := INJECTING;
								end if;

							when (c_SPWC_ERRINJ_CODE_CREDIT) =>
								-- credit error, link need to be in running
								-- check if the codec link is in running
								if (spw_codec_link_status_i.running = '1') then
									-- the codec link is in running
									-- go to injecting
									s_spwc_errinj_controller_state <= INJECTING;
									v_spwc_errinj_controller_state := INJECTING;
								end if;

							when (c_SPWC_ERRINJ_CODE_CHAR) =>
								-- char error, link need to be in started or connecting
								-- check if the codec link is in started or connecting
								if ((spw_codec_link_status_i.started = '1') or (spw_codec_link_status_i.connecting = '1')) then
									-- the codec link is in started or connecting
									-- go to injecting
									s_spwc_errinj_controller_state <= INJECTING;
									v_spwc_errinj_controller_state := INJECTING;
								end if;

							when others =>
								-- invalid selection, return to idle
								s_spwc_errinj_controller_state <= IDLE;
								v_spwc_errinj_controller_state := IDLE;

						end case;

					end if;

				-- state "INJECTING"
				when INJECTING =>
					-- error injection
					-- default state transition
					s_spwc_errinj_controller_state <= WAITING_FINISH;
					v_spwc_errinj_controller_state := WAITING_FINISH;
				-- default internal signal values
				-- conditional state transition

				-- state "WAITING_FINISH"
				when WAITING_FINISH =>
					-- wating error to finish
					-- default state transition
					s_spwc_errinj_controller_state <= WAITING_FINISH;
					v_spwc_errinj_controller_state := WAITING_FINISH;
					-- default internal signal values
					-- conditional state transition
					-- check if there was a problem with the error (invalid or inconsistent error)
					if ((spw_codec_err_inj_status_i.errstat = invalid) or (spw_codec_err_inj_status_i.errstat = inconsistent)) then
						-- there was a problem with the error (invalid or inconsistent error)
						-- abort error operation and return to idle
						s_spwc_errinj_controller_state <= IDLE;
						v_spwc_errinj_controller_state := IDLE;
					-- check if the error is finished (error ended ok or errinj in standby)
					elsif ((spw_codec_err_inj_status_i.errstat = ended_ok) or (spw_codec_err_inj_status_i.errstat = stby)) then
						-- the error is finished (error ended ok or errinj in standby)
						-- go to finished
						s_spwc_errinj_controller_state <= FINISHED;
						v_spwc_errinj_controller_state := FINISHED;
					end if;

				-- state "FINISHED"
				when FINISHED =>
					-- error injection controller is finished
					-- default state transition
					s_spwc_errinj_controller_state <= IDLE;
					v_spwc_errinj_controller_state := IDLE;
					-- default internal signal values
					s_registered_error_code        <= c_SPWC_ERRINJ_CODE_NONE;
				-- conditional state transition

				-- all the other states (not defined)
				when others =>
					s_spwc_errinj_controller_state <= IDLE;
					v_spwc_errinj_controller_state := IDLE;

			end case;

			-- check if a reset was issued
			if (errinj_controller_control_i.reset_errinj = '1') then
				-- a reset was issued
				-- go to idle
				s_spwc_errinj_controller_state <= IDLE;
				v_spwc_errinj_controller_state := IDLE;
			end if;

			-- Output Generation --
			-- Default output generation
			errinj_controller_status_o         <= c_SPWC_ERRINJ_CONTROLLER_STATUS_RST;
			spw_codec_err_inj_command_o.errinj <= '0';
			spw_codec_err_inj_command_o.errsel <= reserved;
			-- Output generation FSM
			case (v_spwc_errinj_controller_state) is

				-- state "IDLE"
				when IDLE =>
					-- error injection controller is in idle
					-- default output signals
					errinj_controller_status_o.errinj_ready <= '1';
				-- conditional output signals

				-- state "WAITING_INJECTION"
				when WAITING_INJECTION =>
					-- wating to be able to inject the error
					-- default output signals
					errinj_controller_status_o.errinj_busy <= '1';
				-- conditional output signals

				-- state "INJECTING"
				when INJECTING =>
					-- error injection
					-- default output signals
					errinj_controller_status_o.errinj_busy <= '1';
					spw_codec_err_inj_command_o.errinj     <= '1';
					-- conditional output signals

					-- inject the selected error
					case (s_registered_error_code) is

						when (c_SPWC_ERRINJ_CODE_DISCONNECTION) =>
							-- disconnection error
							spw_codec_err_inj_command_o.errsel <= disconnection;

						when (c_SPWC_ERRINJ_CODE_PARITY) =>
							-- parity error
							spw_codec_err_inj_command_o.errsel <= parity;

						when (c_SPWC_ERRINJ_CODE_ESCAPE) =>
							-- escape error
							spw_codec_err_inj_command_o.errsel <= esc_esc;

						when (c_SPWC_ERRINJ_CODE_CREDIT) =>
							-- credit error
							spw_codec_err_inj_command_o.errsel <= credit;

						when (c_SPWC_ERRINJ_CODE_CHAR) =>
							-- char error
							spw_codec_err_inj_command_o.errsel <= ch_seq;

						when others =>
							-- invalid selection
							spw_codec_err_inj_command_o.errinj <= '0';
							spw_codec_err_inj_command_o.errsel <= reserved;

					end case;

				-- state "WAITING_FINISH"
				when WAITING_FINISH =>
					-- wating error to finish
					-- default output signals
					errinj_controller_status_o.errinj_busy <= '1';
				-- conditional output signals

				-- state "FINISHED"
				when FINISHED =>
					-- error injection controller is finished
					-- default output signals
					errinj_controller_status_o.errinj_busy <= '1';
					-- conditional output signals

			end case;

		end if;
	end process p_spwc_errinj_controller;

end architecture RTL;
