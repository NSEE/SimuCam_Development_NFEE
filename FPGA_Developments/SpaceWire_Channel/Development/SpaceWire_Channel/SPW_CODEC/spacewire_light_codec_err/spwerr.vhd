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
use ieee.math_real.all;
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
    constant MAX_TMR   : natural := 2000;
    constant TMR_WIDTH : natural := integer(ceil(log2(real(MAX_TMR))));

    -- Outputs to link pulse duration, in clk cycles (err inj. accepted -> err inj. ended)
    -- The calibration of this times is important. Note that (a + b) values below
    -- are refered to: a = actual tx char time, and b = worst case previous tx time.
    -- The 2x factor is for RUN state errors: clk = 200 MHz, tx_clk = 100 MHz.
    -- The 20x factor is for initialization states: clk = 200 MHz; tx_clk = 10 MHz.
    constant DISC_PULS_TIME        : unsigned((TMR_WIDTH - 1) downto 0) := to_unsigned(1, TMR_WIDTH); -- Works fine for 1 clk.
    constant PAR_PULS_TIME         : unsigned((TMR_WIDTH - 1) downto 0) := to_unsigned(2 * (8 + 14), TMR_WIDTH); -- null with wrong parity + possible time code
    constant ESC_PULS_TIME         : unsigned((TMR_WIDTH - 1) downto 0) := to_unsigned(2 * (8 + 14), TMR_WIDTH); -- (esc+esc) + possible time code
    constant CREDIT_PULS_TIME      : unsigned((TMR_WIDTH - 1) downto 0) := to_unsigned(2 * (32 + 14), TMR_WIDTH); -- (8 x fct) + possible time code
    constant CH_SEQ_PULS_TIME      : unsigned((TMR_WIDTH - 1) downto 0) := to_unsigned(6 * 20 * (4 + 8), TMR_WIDTH); -- eop + possible null (fct is only 4 bits)
    -- Specific transition state duration, in clk cycles (for invalid err_sel and inconsistent request)
    constant INVALID_SEL_TIME      : unsigned((TMR_WIDTH - 1) downto 0) := to_unsigned(1, TMR_WIDTH);
    constant INCONSISTENT_REQ_TIME : unsigned((TMR_WIDTH - 1) downto 0) := to_unsigned(1, TMR_WIDTH);

    -- State machine.
    type state_type is (S_reset, S_sel_check, S_inj_err, S_inj_ok);

    -- Registers
    type regs_type is record
        -- state machine
        state        : state_type;
        sel          : t_spw_err_sel;
        link_st      : spwerr_from_link_type;
        -- timer
        timercnt     : unsigned((TMR_WIDTH - 1) downto 0);
        timerrunning : std_ulogic;
        timerdone    : std_ulogic;
    end record;

    -- Initial state
    constant regs_reset : regs_type := (
        state        => S_reset,
        sel          => reserved,
        link_st      => ('0', '0'),
        timercnt     => to_unsigned(0, 11),
        timerrunning => '0',
        timerdone    => '0'
    );

    -- Actual and future regs
    signal r   : regs_type := regs_reset;
    signal rin : regs_type;

begin

    -- Combinatorial process
    process(r, rst, err_usr_i, err_link_i) is
        variable v : regs_type;
    begin
        v := r;

        -- Defaults outputs
        err_usr_o.err_stat_o    <= stby;
        err_link_o.err_disc_o   <= '0';
        err_link_o.err_par_o    <= '0';
        err_link_o.err_esc_o    <= '0';
        err_link_o.err_credit_o <= '0';
        err_link_o.err_ch_seq_o <= '0';

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
                v.timercnt              := regs_reset.timercnt;
                v.timerrunning          := regs_reset.timerrunning;
                v.timerdone             := regs_reset.timerdone;
                -- Check error injection user request
                if (err_usr_i.err_inj_i = '1') then
                    -- Snapshot of user error injection type
                    v.sel     := err_usr_i.err_sel_i;
                    -- Snapshot of actual link state
                    v.link_st := err_link_i;
                    -- Next state 
                    v.state   := S_sel_check;
                end if;

            when S_sel_check =>
                case r.sel is
                    when esc_eop | esc_eep | reserved =>
                        err_usr_o.err_stat_o <= invalid;
                        if (r.timerrunning = '0') then
                            v.timercnt     := INVALID_SEL_TIME;
                            v.timerrunning := '1';
                        end if;
                        if (r.timerdone = '1') then
                            v.state := S_inj_err;
                        end if;

                    when disconnection =>
                        -- If link is in run state, accept err inj. request
                        if (r.link_st.run_state = '1') then
                            err_usr_o.err_stat_o  <= accepted;
                            err_link_o.err_disc_o <= '1';
                            if (r.timerrunning = '0') then
                                v.timercnt     := DISC_PULS_TIME;
                                v.timerrunning := '1';
                            end if;
                            if (r.timerdone = '1') then
                                v.state := S_inj_ok;
                            end if;
                        -- Link machine not in run state
                        else
                            err_usr_o.err_stat_o <= inconsistent;
                            if (r.timerrunning = '0') then
                                v.timercnt     := INCONSISTENT_REQ_TIME;
                                v.timerrunning := '1';
                            end if;
                            if (r.timerdone = '1') then
                                v.state := S_inj_err;
                            end if;
                        end if;

                    when parity =>
                        -- If link is in run state, accept err inj. request
                        if (r.link_st.run_state = '1') then
                            err_usr_o.err_stat_o <= accepted;
                            err_link_o.err_par_o <= '1';
                            if (r.timerrunning = '0') then
                                v.timercnt     := PAR_PULS_TIME;
                                v.timerrunning := '1';
                            end if;
                            if (r.timerdone = '1') then
                                v.state := S_inj_ok;
                            end if;
                        -- Link machine not in run state
                        else
                            err_usr_o.err_stat_o <= inconsistent;
                            if (r.timerrunning = '0') then
                                v.timercnt     := INCONSISTENT_REQ_TIME;
                                v.timerrunning := '1';
                            end if;
                            if (r.timerdone = '1') then
                                v.state := S_inj_err;
                            end if;
                        end if;

                    when esc_esc =>
                        -- If link is in run state, accept err inj. request
                        if (r.link_st.run_state = '1') then
                            err_usr_o.err_stat_o <= accepted;
                            err_link_o.err_esc_o <= '1';
                            if (r.timerrunning = '0') then
                                v.timercnt     := ESC_PULS_TIME;
                                v.timerrunning := '1';
                            end if;
                            if (r.timerdone = '1') then
                                v.state := S_inj_ok;
                            end if;
                        -- Link machine not in run state
                        else
                            err_usr_o.err_stat_o <= inconsistent;
                            if (r.timerrunning = '0') then
                                v.timercnt     := INCONSISTENT_REQ_TIME;
                                v.timerrunning := '1';
                            end if;
                            if (r.timerdone = '1') then
                                v.state := S_inj_err;
                            end if;
                        end if;

                    when credit =>
                        -- If link is in run state, accept err inj. request
                        if (r.link_st.run_state = '1') then
                            err_usr_o.err_stat_o    <= accepted;
                            err_link_o.err_credit_o <= '1';
                            if (r.timerrunning = '0') then
                                v.timercnt     := CREDIT_PULS_TIME;
                                v.timerrunning := '1';
                            end if;
                            if (r.timerdone = '1') then
                                v.state := S_inj_ok;
                            end if;
                        -- Link machine not in run state
                        else
                            err_usr_o.err_stat_o <= inconsistent;
                            if (r.timerrunning = '0') then
                                v.timercnt     := INCONSISTENT_REQ_TIME;
                                v.timerrunning := '1';
                            end if;
                            if (r.timerdone = '1') then
                                v.state := S_inj_err;
                            end if;
                        end if;

                    when ch_seq =>
                        -- If link is in started or connecting state, accept err inj. request
                        if (r.link_st.start_or_conn_state = '1') then
                            err_usr_o.err_stat_o    <= accepted;
                            err_link_o.err_ch_seq_o <= '1';
                            if (r.timerrunning = '0') then
                                v.timercnt     := CH_SEQ_PULS_TIME;
                                v.timerrunning := '1';
                            end if;
                            if (r.timerdone = '1') then
                                v.state := S_inj_ok;
                            end if;
                        -- Link machine in run state
                        else
                            err_usr_o.err_stat_o <= inconsistent;
                            if (r.timerrunning = '0') then
                                v.timercnt     := INCONSISTENT_REQ_TIME;
                                v.timerrunning := '1';
                            end if;
                            if (r.timerdone = '1') then
                                v.state := S_inj_err;
                            end if;
                        end if;

                    when others =>
                        err_usr_o.err_stat_o <= invalid;
                        if (r.timerrunning = '0') then
                            v.timercnt     := INVALID_SEL_TIME;
                            v.timerrunning := '1';
                        end if;
                        if (r.timerdone = '1') then
                            v.state := S_inj_err;
                        end if;
                end case;

            when S_inj_ok =>
                -- Update status for user
                err_usr_o.err_stat_o    <= ended_ok;
                -- Reset outputs do link
                err_link_o.err_disc_o   <= '0';
                err_link_o.err_par_o    <= '0';
                err_link_o.err_esc_o    <= '0';
                err_link_o.err_credit_o <= '0';
                err_link_o.err_ch_seq_o <= '0';
                -- Reset timer
                v.timercnt              := regs_reset.timercnt;
                v.timerrunning          := regs_reset.timerrunning;
                v.timerdone             := regs_reset.timerdone;
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
                v.timercnt              := regs_reset.timercnt;
                v.timerrunning          := regs_reset.timerrunning;
                v.timerdone             := regs_reset.timerdone;
                -- Wait for user reset err_inj_i
                if (err_usr_i.err_inj_i = '0') then
                    v.state := S_reset;
                end if;

        end case;

        -- Other eventual tasks.

        -- Update the error injection timer.
        if (r.timerrunning = '1') then
            if (r.timercnt <= 3) then
                v.timercnt  := regs_reset.timercnt;
                v.timerdone := '1';
            else
                v.timercnt := r.timercnt - 1;
            end if;
        end if;

        -- Reset
        if rst = '1' then
            v                       := regs_reset;
            err_usr_o.err_stat_o    <= stby;
            err_link_o.err_disc_o   <= '0';
            err_link_o.err_par_o    <= '0';
            err_link_o.err_esc_o    <= '0';
            err_link_o.err_credit_o <= '0';
            err_link_o.err_ch_seq_o <= '0';
        end if;

        -- Update future state regs.
        rin <= v;
    end process;

    -- Sequential process - update regs.
    process(clk) is
    begin
        if rising_edge(clk) then
            r <= rin;
        end if;
    end process;

end architecture spwerr_arch;
