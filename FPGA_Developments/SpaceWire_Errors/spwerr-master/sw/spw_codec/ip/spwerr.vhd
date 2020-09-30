--
--  SpaceWire Error injection Controller.
--
--  This entity implements error injection at exchange level of the SpaceWire protocol.
--  It handles disconnect, parity, escape, credit and char sequence errors.
--  It´s a subcomponent, instantiated by spwlink.
--  Implementation restrictions:
--  	- Disconnection, parity, escape, and credit errors: only injected in run state.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.spwpkg.all;

entity spwerr is

	port(
		-- System clock.
		clk        : in  std_logic;
		-- Asynchronous reset (active-high).
		rst        : in  std_logic;
		-- Inputs from spwlink
		err_link_i : in  spwerr_from_link_type;
		-- Outputs to spwlink 
		err_link_o : out spwerr_to_link_type;
		-- Inputs from toplevel
		err_usr_i  : in  spwerr_from_usr_type;
		-- Outputs to toplevel
		err_usr_o  : out spwerr_to_usr_type
	);

end entity spwerr;

architecture spwerr_arch of spwerr is

	-- Convert boolean to std_logic.
	type bool_to_logic_type is array (boolean) of std_ulogic;
	constant bool_to_logic : bool_to_logic_type := (false => '0', true => '1');

	-- Max timer value (for timed state transitions), in clk cycles
	constant MAX_TMR : integer := 1000;

	-- Outputs to link pulse duration, in clk cycles (err inj. accepted -> err inj. ended)
	-- The calibration of this times is important. Note that (a + b) values below
	-- are refered to: a = actual tx char time, and b = worst case previous tx time.
	-- The 2x factor is for RUN state errors: clk = 200 MHz, tx_clk = 100 MHz.
	-- The 20x factor is for initialization states: clk = 200 MHz; tx_clk = 10 MHz.
	constant DISC_PULS_TIME        : integer := 1;				-- Works fine for 1 clk.
	constant PAR_PULS_TIME         : integer := 2 *  (8 + 14);	-- null with wrong parity + possible time code
	constant ESC_PULS_TIME         : integer := 2 *  (8  + 14);	-- (esc+esc) + possible time code
	constant CREDIT_PULS_TIME      : integer := 2 *  (32 + 14);	-- (8 x fct) + possible time code
	constant CH_SEQ_PULS_TIME      : integer := 20 * (4  +  8);	-- eop + possible null (fct is only 4 bits)
	-- Specific transition state duration, in clk cycles (for invalid err_sel and inconsistent request)
	constant INVALID_SEL_TIME      : integer := 1;
	constant INCONSISTENT_REQ_TIME : integer := 1;

	-- State machine.
	type state_type is (S_reset, S_sel_check, S_inj_err, S_inj_ok);

	-- Registers
	type regs_type is record
		-- state machine
		state	: state_type;
		sel		: t_spw_err_sel;
		link_st : spwerr_from_link_type;
	end record;

	-- Initial state
	constant regs_reset : regs_type := (
		state	=> S_reset,
		sel		=> reserved,
		link_st => ('0', '0')  
	);

	-- Actual and future regs
	signal r     : regs_type                  := regs_reset;
	signal rin   : regs_type;
	-- Timer for state transitions
	signal timer : integer range 0 to MAX_TMR := 0;

begin

	-- Combinatorial process
	process(r, err_usr_i, err_link_i) is
		variable v : regs_type;
	begin
		v := r;

		-- State machine.
		case r.state is

			when S_reset =>
				-- Status = stby
				err_usr_o.err_stat_o    <= stby;
				-- Reset outputs do link
				err_link_o.err_disc_o   <= '0';
				err_link_o.err_par_o    <= '0';
				err_link_o.err_esc_o    <= '0';
				err_link_o.err_credit_o <= '0';
				err_link_o.err_ch_seq_o <= '0';
				-- Reset timer
				timer                   <= 0;
				-- Check error injection user request
				if (err_usr_i.err_inj_i = '1') then
					-- Snapshot of user error injection type
					v.sel	:= err_usr_i.err_sel_i;
					-- Snapshot of actual link state
					v.link_st := err_link_i;
					-- Next state 
					v.state := S_sel_check;
				end if;

			when S_sel_check =>
				case v.sel is
					when esc_eop | esc_eep | reserved =>
						err_usr_o.err_stat_o <= invalid;
						timer                <= INVALID_SEL_TIME;
						v.state              := S_inj_err;

					when disconnection =>
						-- If link is in run state, accept err inj. request
						if (v.link_st.run_state = '1') then
							err_usr_o.err_stat_o  <= accepted;
							err_link_o.err_disc_o <= '1';
							timer                 <= DISC_PULS_TIME;
							v.state := S_inj_ok;
						-- Link machine not in run state
						else
							err_usr_o.err_stat_o <= inconsistent;
							timer                <= INCONSISTENT_REQ_TIME;
							v.state := S_inj_err;
						end if;
						

					when parity =>
						-- If link is in run state, accept err inj. request
						if (v.link_st.run_state = '1') then
							err_usr_o.err_stat_o <= accepted;
							err_link_o.err_par_o <= '1';
							timer                <= PAR_PULS_TIME;
							v.state := S_inj_ok;
						-- Link machine not in run state
						else
							err_usr_o.err_stat_o <= inconsistent;
							timer                <= INCONSISTENT_REQ_TIME;
							v.state := S_inj_err;
						end if;

					when esc_esc =>
						-- If link is in run state, accept err inj. request
						if (v.link_st.run_state = '1') then
							err_usr_o.err_stat_o <= accepted;
							err_link_o.err_esc_o <= '1';
							timer                <= ESC_PULS_TIME;
							v.state := S_inj_ok;
						-- Link machine not in run state
						else
							err_usr_o.err_stat_o <= inconsistent;
							timer                <= INCONSISTENT_REQ_TIME;
							v.state := S_inj_err;
						end if;

					when credit =>
						-- If link is in run state, accept err inj. request
						if (v.link_st.run_state = '1') then
							err_usr_o.err_stat_o    <= accepted;
							err_link_o.err_credit_o <= '1';
							timer                   <= CREDIT_PULS_TIME;
							v.state := S_inj_ok;
						-- Link machine not in run state
						else
							err_usr_o.err_stat_o <= inconsistent;
							timer                <= INCONSISTENT_REQ_TIME;
							v.state := S_inj_err;
						end if;

					when ch_seq =>
						-- If link is in started or connecting state, accept err inj. request
						if (v.link_st.start_or_conn_state = '1') then
							err_usr_o.err_stat_o    <= accepted;
							err_link_o.err_ch_seq_o <= '1';
							timer                   <= CH_SEQ_PULS_TIME;
							v.state := S_inj_ok;
						-- Link machine in run state
						else
							err_usr_o.err_stat_o <= inconsistent;
							timer                <= INCONSISTENT_REQ_TIME;
							v.state := S_inj_err;
						end if;
				end case;

			when S_inj_ok =>
				-- Update status for user
				err_usr_o.err_stat_o  <= ended_ok;
				-- Reset outputs do link
				err_link_o.err_disc_o   <= '0';
				err_link_o.err_par_o    <= '0';
				err_link_o.err_esc_o    <= '0';
				err_link_o.err_credit_o <= '0';
				err_link_o.err_ch_seq_o <= '0';
				-- Reset timer
				timer                   <= 0;
				-- Wait for user reset err_inj_i
				if (err_usr_i.err_inj_i = '0') then
					v.state := S_reset;
				end if;

			when S_inj_err =>
				-- Reset outputs do link (redundant)
				err_link_o.err_disc_o   <= '0';
				err_link_o.err_par_o    <= '0';
				err_link_o.err_esc_o    <= '0';
				err_link_o.err_credit_o <= '0';
				err_link_o.err_ch_seq_o <= '0';
				-- Reset timer
				timer                   <= 0;
				-- Wait for user reset err_inj_i
				if (err_usr_i.err_inj_i = '0') then
					v.state := S_reset;
				end if;

		end case;

		-- Other eventual tasks.

		-- Update future state regs.
		rin <= v;
	end process;

	-- Sequential process - rst, update regs.
	process(clk, rst) is
		variable count : integer range 0 to MAX_TMR := 0;
	begin
		if (rst = '1') then
			r     <= regs_reset;
			count := 0;
		elsif rising_edge(clk) then
			count := count + 1;
			if (count >= timer) then
				r     <= rin;
				count := 0;
			end if;
		end if;
	end process;

end architecture spwerr_arch;
