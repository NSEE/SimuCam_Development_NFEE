library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity nrme_mem_area_altsyncram_controller is
    port(
        clk_i                  : in  std_logic;
        rst_i                  : in  std_logic;
        memarea_wraddress_i    : in  std_logic_vector(5 downto 0);
        memarea_wrbyteenable_i : in  std_logic_vector(3 downto 0);
        memarea_wrbitmask_i    : in  std_logic_vector(31 downto 0);
        memarea_wrdata_i       : in  std_logic_vector(31 downto 0);
        memarea_write_i        : in  std_logic;
        memarea_rdaddress_i    : in  std_logic_vector(5 downto 0);
        memarea_read_i         : in  std_logic;
        memarea_idle_o         : out std_logic;
        memarea_wrdone_o       : out std_logic;
        memarea_rdvalid_o      : out std_logic;
        memarea_rddata_o       : out std_logic_vector(31 downto 0)
    );
end entity nrme_mem_area_altsyncram_controller;

architecture RTL of nrme_mem_area_altsyncram_controller is

    -- alias --

    -- signals --

    -- altsyncram signals
    signal s_altsyncram_address    : std_logic_vector(5 downto 0);
    signal s_altsyncram_byteenable : std_logic_vector(3 downto 0);
    signal s_altsyncram_bitmask    : std_logic_vector(31 downto 0);
    signal s_altsyncram_wrdata     : std_logic_vector(31 downto 0);
    signal s_altsyncram_write      : std_logic;
    signal s_altsyncram_rddata     : std_logic_vector(31 downto 0);

    type t_nrme_mem_area_altsyncram_controller_fsm is (
        IDLE,                           -- altsyncram controller is idle
        WRITE_DATA,                     -- write data to altsyncram
        WRITE_DELAY,                    -- write delay for altsyncram
        WRITE_FINISHED,                 -- write finished on altsyncram
        READ_DELAY,                     -- read delay altsyncram
        READ_DATA,                      -- read data from altsyncram
        READ_FINISHED,                  -- read finished on altsyncram
        MODIFY_READ_DELAY,              -- modify read delay altsyncram
        MODIFY_DATA,                    -- modify data from altsyncram
        MODIFY_WRITE_DELAY,             -- modify write delay for altsyncram
        MODIFY_FINISHED                 -- modify finished on altsyncram
    );
    signal s_nrme_mem_area_altsyncram_controller_state : t_nrme_mem_area_altsyncram_controller_fsm;

    constant c_WRITE_DELAY : unsigned(3 downto 0) := x"1";
    constant c_READ_DELAY  : unsigned(3 downto 0) := x"1";
    constant c_ZERO_DELAY  : unsigned(3 downto 0) := (others => '0');
    signal s_delay_cnt     : unsigned(3 downto 0);

    constant c_SET_BIT_MASK : std_logic_vector(31 downto 0) := (others => '1');
    constant c_CLR_BIT_MASK : std_logic_vector(31 downto 0) := (others => '0');

begin

    -- nrme mem area altsyncram instantiation
    nrme_mem_area_altsyncram_inst : entity work.nrme_mem_area_altsyncram
        port map(
            aclr    => rst_i,
            address => s_altsyncram_address,
            byteena => s_altsyncram_byteenable,
            clock   => clk_i,
            data    => s_altsyncram_wrdata,
            wren    => s_altsyncram_write,
            q       => s_altsyncram_rddata
        );

    -- nrme mem area altsynctam controller process
    p_nrme_mem_area_altsyncram_controller : process(clk_i, rst_i) is
        variable v_nrme_mem_area_altsyncram_controller_state : t_nrme_mem_area_altsyncram_controller_fsm := IDLE;
    begin
        if (rst_i = '1') then
            -- fsm state reset
            s_nrme_mem_area_altsyncram_controller_state <= IDLE;
            v_nrme_mem_area_altsyncram_controller_state := IDLE;
            -- internal signals reset
            s_altsyncram_address                        <= (others => '0');
            s_altsyncram_byteenable                     <= (others => '1');
            s_altsyncram_bitmask                        <= (others => '1');
            s_altsyncram_wrdata                         <= (others => '0');
            s_altsyncram_write                          <= '0';
            s_delay_cnt                                 <= c_ZERO_DELAY;
            -- outputs reset
            memarea_idle_o                              <= '0';
            memarea_wrdone_o                            <= '0';
            memarea_rdvalid_o                           <= '0';
            memarea_rddata_o                            <= (others => '0');
        elsif rising_edge(clk_i) then

            -- states transitions fsm
            case (s_nrme_mem_area_altsyncram_controller_state) is

                -- state "IDLE"
                when IDLE =>
                    -- altsyncram controller is idle
                    -- default state transition
                    s_nrme_mem_area_altsyncram_controller_state <= IDLE;
                    v_nrme_mem_area_altsyncram_controller_state := IDLE;
                    -- default internal signal values
                    --                    s_altsyncram_address                        <= (others => '0');
                    --                    s_altsyncram_byteenable                     <= (others => '1');
                    --                    s_altsyncram_bitmask                        <= (others => '1');
                    --                    s_altsyncram_wrdata                         <= (others => '0');
                    s_altsyncram_write                          <= '0';
                    s_delay_cnt                                 <= c_ZERO_DELAY;
                    -- conditional state transition
                    -- check if a memory area write was issued
                    if (memarea_write_i = '1') then
                        -- a memory area write was issued
                        -- check if a modify is not necessary (normal write)
                        if (memarea_wrbitmask_i = c_SET_BIT_MASK) then
                            -- a modify is not necessary (normal write)
                            -- set the ram parameters
                            s_altsyncram_address                        <= memarea_wraddress_i;
                            s_altsyncram_byteenable                     <= memarea_wrbyteenable_i;
                            s_altsyncram_bitmask                        <= (others => '1');
                            s_altsyncram_wrdata                         <= memarea_wrdata_i;
                            s_altsyncram_write                          <= '1';
                            -- set the delay counter
                            s_delay_cnt                                 <= c_WRITE_DELAY;
                            -- go to write data
                            s_nrme_mem_area_altsyncram_controller_state <= WRITE_DATA;
                            v_nrme_mem_area_altsyncram_controller_state := WRITE_DATA;
                        else
                            -- a modify is necessary (read-modify write)
                            -- set the ram parameters
                            s_altsyncram_address                        <= memarea_wraddress_i;
                            s_altsyncram_byteenable                     <= memarea_wrbyteenable_i;
                            s_altsyncram_bitmask                        <= memarea_wrbitmask_i;
                            s_altsyncram_wrdata                         <= memarea_wrdata_i;
                            s_altsyncram_write                          <= '0';
                            -- set the delay counter
                            s_delay_cnt                                 <= c_READ_DELAY;
                            -- go to write data
                            s_nrme_mem_area_altsyncram_controller_state <= MODIFY_READ_DELAY;
                            v_nrme_mem_area_altsyncram_controller_state := MODIFY_READ_DELAY;
                        end if;
                    -- check if a memory area read was issued
                    elsif (memarea_read_i = '1') then
                        -- a memory area read was issued
                        -- set the ram parameters
                        s_altsyncram_address                        <= memarea_rdaddress_i;
                        s_altsyncram_byteenable                     <= (others => '1');
                        s_altsyncram_bitmask                        <= (others => '1');
                        s_altsyncram_wrdata                         <= (others => '0');
                        s_altsyncram_write                          <= '0';
                        -- set the delay counter
                        s_delay_cnt                                 <= c_READ_DELAY;
                        -- go to read delay
                        s_nrme_mem_area_altsyncram_controller_state <= READ_DELAY;
                        v_nrme_mem_area_altsyncram_controller_state := READ_DELAY;
                    end if;

                -- state "WRITE_DATA"
                when WRITE_DATA =>
                    -- write data to altsyncram
                    -- default state transition
                    s_nrme_mem_area_altsyncram_controller_state <= WRITE_DELAY;
                    v_nrme_mem_area_altsyncram_controller_state := WRITE_DELAY;
                    -- default internal signal values
                    s_altsyncram_write                          <= '0';
                -- conditional state transition

                -- state "WRITE_DELAY"
                when WRITE_DELAY =>
                    -- write delay for altsyncram
                    -- default state transition
                    s_nrme_mem_area_altsyncram_controller_state <= WRITE_DELAY;
                    v_nrme_mem_area_altsyncram_controller_state := WRITE_DELAY;
                    -- default internal signal values
                    -- conditional state transition
                    -- check if the delay has ended
                    if (s_delay_cnt = c_ZERO_DELAY) then
                        -- the delay has ended
                        -- go to write finished
                        s_nrme_mem_area_altsyncram_controller_state <= WRITE_FINISHED;
                        v_nrme_mem_area_altsyncram_controller_state := WRITE_FINISHED;
                    else
                        -- the delay has not ended
                        -- decrement the delay counter
                        s_delay_cnt <= s_delay_cnt - 1;
                    end if;

                -- state "WRITE_FINISHED"
                when WRITE_FINISHED =>
                    -- write finished on altsyncram
                    -- default state transition
                    s_nrme_mem_area_altsyncram_controller_state <= IDLE;
                    v_nrme_mem_area_altsyncram_controller_state := IDLE;
                -- default internal signal values
                -- conditional state transition

                -- state "READ_DELAY"
                when READ_DELAY =>
                    -- read delay altsyncram
                    -- default state transition
                    s_nrme_mem_area_altsyncram_controller_state <= READ_DELAY;
                    v_nrme_mem_area_altsyncram_controller_state := READ_DELAY;
                    -- default internal signal values
                    -- conditional state transition
                    -- check if the delay has ended
                    if (s_delay_cnt = c_ZERO_DELAY) then
                        -- the delay has ended
                        -- go to read data
                        s_nrme_mem_area_altsyncram_controller_state <= READ_DATA;
                        v_nrme_mem_area_altsyncram_controller_state := READ_DATA;
                    else
                        -- the delay has not ended
                        -- decrement the delay counter
                        s_delay_cnt <= s_delay_cnt - 1;
                    end if;

                -- state "READ_DATA"
                when READ_DATA =>
                    -- read data from altsyncram
                    -- default state transition
                    s_nrme_mem_area_altsyncram_controller_state <= READ_FINISHED;
                    v_nrme_mem_area_altsyncram_controller_state := READ_FINISHED;
                -- default internal signal values
                -- conditional state transition

                -- state "READ_FINISHED"
                when READ_FINISHED =>
                    -- read finished altsyncram
                    -- default state transition
                    s_nrme_mem_area_altsyncram_controller_state <= IDLE;
                    v_nrme_mem_area_altsyncram_controller_state := IDLE;
                -- default internal signal values
                -- conditional state transition

                -- state "MODIFY_READ_DELAY"
                when MODIFY_READ_DELAY =>
                    -- modify read delay altsyncram
                    -- default state transition
                    s_nrme_mem_area_altsyncram_controller_state <= MODIFY_READ_DELAY;
                    v_nrme_mem_area_altsyncram_controller_state := MODIFY_READ_DELAY;
                    -- default internal signal values
                    -- conditional state transition
                    -- check if the delay has ended
                    if (s_delay_cnt = c_ZERO_DELAY) then
                        -- the delay has ended
                        -- go to read data
                        s_nrme_mem_area_altsyncram_controller_state <= MODIFY_DATA;
                        v_nrme_mem_area_altsyncram_controller_state := MODIFY_DATA;
                    else
                        -- the delay has not ended
                        -- decrement the delay counter
                        s_delay_cnt <= s_delay_cnt - 1;
                    end if;

                -- state "MODIFY_DATA"
                when MODIFY_DATA =>
                    -- modify data from altsyncram
                    -- default state transition
                    s_nrme_mem_area_altsyncram_controller_state <= MODIFY_WRITE_DELAY;
                    v_nrme_mem_area_altsyncram_controller_state := MODIFY_WRITE_DELAY;
                    -- default internal signal values
                    -- set the masked write data
                    s_altsyncram_wrdata                         <= ((s_altsyncram_bitmask) and (s_altsyncram_wrdata)) or ((not (s_altsyncram_bitmask)) and (s_altsyncram_rddata));
                    s_altsyncram_write                          <= '1';
                    -- set the delay counter
                    s_delay_cnt                                 <= c_WRITE_DELAY;
                -- conditional state transition

                -- state "MODIFY_WRITE_DELAY"
                when MODIFY_WRITE_DELAY =>
                    -- modify write delay for altsyncram
                    -- default state transition
                    s_nrme_mem_area_altsyncram_controller_state <= MODIFY_WRITE_DELAY;
                    v_nrme_mem_area_altsyncram_controller_state := MODIFY_WRITE_DELAY;
                    -- default internal signal values
                    s_altsyncram_write                          <= '0';
                    -- conditional state transition
                    -- check if the delay has ended
                    if (s_delay_cnt = c_ZERO_DELAY) then
                        -- the delay has ended
                        -- go to write finished
                        s_nrme_mem_area_altsyncram_controller_state <= MODIFY_FINISHED;
                        v_nrme_mem_area_altsyncram_controller_state := MODIFY_FINISHED;
                    else
                        -- the delay has not ended
                        -- decrement the delay counter
                        s_delay_cnt <= s_delay_cnt - 1;
                    end if;

                -- state "MODIFY_FINISHED"
                when MODIFY_FINISHED =>
                    -- modify finished on altsyncram
                    -- default state transition
                    s_nrme_mem_area_altsyncram_controller_state <= IDLE;
                    v_nrme_mem_area_altsyncram_controller_state := IDLE;
                -- default internal signal values
                -- conditional state transition

                -- all the other states (not defined)
                when others =>
                    s_nrme_mem_area_altsyncram_controller_state <= IDLE;
                    v_nrme_mem_area_altsyncram_controller_state := IDLE;

            end case;

            -- default outputs
            memarea_idle_o    <= '0';
            memarea_wrdone_o  <= '0';
            memarea_rdvalid_o <= '0';
            --            memarea_rddata_o  <= (others => '0');

            -- output generation fsm
            case (v_nrme_mem_area_altsyncram_controller_state) is

                -- state "IDLE"
                when IDLE =>
                    -- altsyncram controller is idle
                    -- default output signals
                    memarea_idle_o <= '1';
                -- conditional output signals

                -- state "WRITE_DATA"
                when WRITE_DATA =>
                    -- write data to altsyncram
                    -- default output signals
                    -- conditional output signals

                    -- state "WRITE_DELAY"
                when WRITE_DELAY =>
                    -- write delay for altsyncram
                    -- default output signals
                    -- conditional output signals

                    -- state "WRITE_FINISHED"
                when WRITE_FINISHED =>
                    -- write finished on altsyncram
                    -- default output signals
                    memarea_wrdone_o <= '1';
                -- conditional output signals

                -- state "READ_DATA"
                when READ_DATA =>
                    -- read data from altsyncram
                    -- default output signals
                    -- conditional output signals

                    -- state "READ_DELAY"
                when READ_DELAY =>
                    -- read delay altsyncram
                    -- default output signals
                    -- conditional output signals

                    -- state "READ_FINISHED"
                when READ_FINISHED =>
                    -- read finished altsyncram
                    -- default output signals
                    memarea_rdvalid_o <= '1';
                    memarea_rddata_o  <= s_altsyncram_rddata;
                -- conditional output signals

                -- state "MODIFY_READ_DELAY"
                when MODIFY_READ_DELAY =>
                    -- modify read delay altsyncram
                    -- default output signals
                    -- conditional output signals

                    -- state "MODIFY_DATA"
                when MODIFY_DATA =>
                    -- modify read data from altsyncram
                    -- default output signals
                    -- conditional output signals

                    -- state "MODIFY_WRITE_DELAY"
                when MODIFY_WRITE_DELAY =>
                    -- modify write delay for altsyncram
                    -- default output signals
                    -- conditional output signals

                    -- state "MODIFY_FINISHED"
                when MODIFY_FINISHED =>
                    -- modify finished on altsyncram
                    -- default output signals
                    memarea_wrdone_o <= '1';
                    -- conditional output signals

            end case;

        end if;
    end process p_nrme_mem_area_altsyncram_controller;

end architecture RTL;
