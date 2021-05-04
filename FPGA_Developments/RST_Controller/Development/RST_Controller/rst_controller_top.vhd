-- rst_controller_top.vhd

-- This file was auto-generated as a prototype implementation of a module
-- created in component editor.  It ties off all outputs to ground and
-- ignores all inputs.  It needs to be edited to make it do something
-- useful.
-- 
-- This file will not be automatically regenerated.  You should check it in
-- to your version control system if you want to keep it.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.avalon_mm_rst_controller_pkg.all;
use work.avalon_mm_rst_controller_registers_pkg.all;

entity rst_controller_top is
    port(
        avalon_slave_rst_controller_address     : in  std_logic_vector(3 downto 0)  := (others => '0'); -- avalon_slave_rst_controller.address
        avalon_slave_rst_controller_write       : in  std_logic                     := '0'; --          --                            .write
        avalon_slave_rst_controller_read        : in  std_logic                     := '0'; --          --                            .read
        avalon_slave_rst_controller_writedata   : in  std_logic_vector(31 downto 0) := (others => '0'); --                            .writedata
        avalon_slave_rst_controller_readdata    : out std_logic_vector(31 downto 0); --                 --                            .readdata
        avalon_slave_rst_controller_waitrequest : out std_logic; --                                     --                            .waitrequest
        clock_sink_clk                          : in  std_logic                     := '0'; --          --                  clock_sink.clk
        reset_sink_reset                        : in  std_logic                     := '0'; --          --                  reset_sink.reset
        reset_input_signal                      : in  std_logic                     := '0'; --          --         conduit_reset_input.t_reset_input_signal
        simucam_reset_signal                    : out std_logic; --                                     --       conduit_simucam_reset.t_simucam_reset_signal
        reset_source_rs232_reset                : out std_logic ---                                     --          reset_source_rs232.reset
    );
end entity rst_controller_top;

architecture rtl of rst_controller_top is

    alias a_clock is clock_sink_clk;
    alias a_reset is reset_input_signal;

    -- constants

    -- signals

    -- rst controller avalon mm read signals
    signal s_avalon_mm_rst_controller_read_waitrequest : std_logic;

    -- rst controller avalon mm write signals
    signal s_avalon_mm_rst_controller_write_waitrequest : std_logic;

    -- windowing avalon mm registers signals
    signal s_rst_controller_write_registers : t_rst_controller_write_registers;
    signal s_rst_controller_read_registers  : t_rst_controller_read_registers;

    -- simucam reset signals
    signal s_simucam_delay             : std_logic;
    signal s_simucam_reset             : std_logic;
    signal s_simucam_start             : std_logic;
    signal s_simucam_stop              : std_logic;
    signal s_reset_counter             : std_logic_vector(30 downto 0);
    signal s_simucam_reset_cmd_delayed : std_logic;

    -- reset counter
    signal s_reset_cnt : unsigned(31 downto 0) := (others => '0');

begin

    -- rst_controller avalon mm read instantiation
    avalon_mm_rst_controller_read_ent_inst : entity work.avalon_mm_rst_controller_read_ent
        port map(
            clk_i                             => a_clock,
            rst_i                             => a_reset,
            avalon_mm_spacewire_i.address     => avalon_slave_rst_controller_address,
            avalon_mm_spacewire_i.read        => avalon_slave_rst_controller_read,
            avalon_mm_spacewire_o.readdata    => avalon_slave_rst_controller_readdata,
            avalon_mm_spacewire_o.waitrequest => s_avalon_mm_rst_controller_read_waitrequest,
            rst_controller_write_registers_i  => s_rst_controller_write_registers,
            rst_controller_read_registers_i   => s_rst_controller_read_registers
        );

    -- rst_controller avalon mm write instantiation
    avalon_mm_rst_controller_write_ent_inst : entity work.avalon_mm_rst_controller_write_ent
        port map(
            clk_i                             => a_clock,
            rst_i                             => a_reset,
            avalon_mm_spacewire_i.address     => avalon_slave_rst_controller_address,
            avalon_mm_spacewire_i.write       => avalon_slave_rst_controller_write,
            avalon_mm_spacewire_i.writedata   => avalon_slave_rst_controller_writedata,
            avalon_mm_spacewire_o.waitrequest => s_avalon_mm_rst_controller_write_waitrequest,
            rst_controller_write_registers_o  => s_rst_controller_write_registers
        );

    avalon_slave_rst_controller_waitrequest <= ((s_avalon_mm_rst_controller_read_waitrequest) and (s_avalon_mm_rst_controller_write_waitrequest)) when (a_reset = '0') else ('1');

    -- simucam reset
    p_simucam_reset : process(a_clock, a_reset) is
    begin
        if (a_reset = '1') then
            s_simucam_delay             <= '1';
            s_simucam_reset             <= '0';
            s_simucam_start             <= '0';
            s_simucam_stop              <= '0';
            s_reset_counter             <= (others => '0');
            simucam_reset_signal        <= '1';
            s_simucam_reset_cmd_delayed <= '0';
        elsif (rising_edge(a_clock)) then

            -- manage start/stop commands
            if ((s_rst_controller_write_registers.simucam_reset.simucam_reset = '1') and (s_simucam_reset_cmd_delayed = '0')) then
                -- a rising edge ocurred, issue start command
                s_simucam_start <= '1';
            elsif ((s_rst_controller_write_registers.simucam_reset.simucam_reset = '0') and (s_simucam_reset_cmd_delayed = '1')) then
                -- a falling edge ocurred, issue stop command
                s_simucam_stop <= '1';
                s_reset_cnt    <= s_reset_cnt + 1;
            end if;

            -- check if start or stop command was received
            if (s_simucam_start = '1') then
                s_simucam_delay <= '1';
                s_simucam_reset <= '1';
                s_simucam_start <= '0';
                s_simucam_stop  <= '0';
                s_reset_counter <= std_logic_vector(unsigned(s_rst_controller_write_registers.simucam_reset.simucam_timer) - 1);
            elsif (s_simucam_stop = '1') then
                s_simucam_delay <= '0';
                s_simucam_reset <= '0';
                s_simucam_start <= '0';
                s_simucam_stop  <= '0';
                s_reset_counter <= (others => '0');
            end if;

            -- check if a reset is in progress
            if (s_simucam_reset = '1') then
                -- check if the timer is zero
                if (s_reset_counter = std_logic_vector(to_unsigned(0, 31))) then
                    -- timer is zero, change state
                    -- check if the current state is a delay or reset
                    if (s_simucam_delay = '1') then
                        -- current state is a delay
                        -- go to a reset state
                        s_simucam_delay      <= '0';
                        s_reset_counter      <= std_logic_vector(to_unsigned(45000000 - 1, 31)); -- 900 ms of delay
                        simucam_reset_signal <= '0';
                    else
                        -- current state is a reset
                        -- go to a delay state
                        s_simucam_delay      <= '1';
                        s_reset_counter      <= std_logic_vector(unsigned(s_rst_controller_write_registers.simucam_reset.simucam_timer) - 1);
                        simucam_reset_signal <= '1';
                    end if;
                else
                    -- timer is not zero
                    s_reset_counter <= std_logic_vector(unsigned(s_reset_counter) - 1);
                end if;
            end if;

            -- update delayed signals
            s_simucam_reset_cmd_delayed <= s_rst_controller_write_registers.simucam_reset.simucam_reset;

            -- limit reset counter to avoid overflows
            s_reset_cnt((s_reset_cnt'length - 1)) <= '0';

        end if;

    end process p_simucam_reset;

    -- devices reset
    reset_source_rs232_reset <= (s_rst_controller_write_registers.device_reset.rs232_reset) or (a_reset);

    -- reset counter
    s_rst_controller_read_registers.reset_counter.reset_cnt <= std_logic_vector(s_reset_cnt);

end architecture rtl;                   -- of rst_controller_top
