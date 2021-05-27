library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity comm_content_errinj_manager_ent is
    port(
        clk_i                               : in  std_logic;
        rst_i                               : in  std_logic;
        ch_sync_trigger_i                   : in  std_logic;
        config_content_errinj_open_i        : in  std_logic;
        config_content_errinj_close_i       : in  std_logic;
        config_content_errinj_clear_i       : in  std_logic;
        config_content_errinj_write_i       : in  std_logic;
        config_content_errinj_start_i       : in  std_logic;
        config_content_errinj_stop_i        : in  std_logic;
        config_content_errinj_start_frame_i : in  std_logic_vector(15 downto 0);
        config_content_errinj_stop_frame_i  : in  std_logic_vector(15 downto 0);
        config_content_errinj_pixel_col_i   : in  std_logic_vector(15 downto 0);
        config_content_errinj_pixel_row_i   : in  std_logic_vector(15 downto 0);
        config_content_errinj_pixel_value_i : in  std_logic_vector(15 downto 0);
        inject_content_errinj_done_i        : in  std_logic;
        config_content_errinj_idle_o        : out std_logic;
        config_content_errinj_recording_o   : out std_logic;
        config_content_errinj_injecting_o   : out std_logic;
        config_content_errinj_errors_cnt_o  : out std_logic_vector(6 downto 0);
        inject_content_errinj_enable_o      : out std_logic;
        inject_content_errinj_px_col_o      : out std_logic_vector(15 downto 0);
        inject_content_errinj_px_row_o      : out std_logic_vector(15 downto 0);
        inject_content_errinj_px_val_o      : out std_logic_vector(15 downto 0)
    );
end entity comm_content_errinj_manager_ent;

architecture RTL of comm_content_errinj_manager_ent is

    type t_comm_content_errinj_manager_fsm is (
        IDLE,                           -- error injection manager is idle
        RECORDING,                      -- error injection manager is recording
        WRITE_RAM,                      -- error injection manager is writing to ram memory
        WAITING_SYNC,                   -- error injection manager is waiting a sync
        FETCH_RAM,                      -- error injection manager is fetching from ram memory
        INJECTING,                      -- error injection manager is injecting
        UNEXPECTED_SYNC,                -- error injection manager received a unexpected sync
        FINISHED                        -- error injection manager is finished
    );

    signal s_comm_content_errinj_manager_state : t_comm_content_errinj_manager_fsm;

    constant c_CONTENT_ERRINJ_RAM_LAST_ADDRESS : std_logic_vector(6 downto 0) := (others => '1');

    type t_comm_content_errinj_ram_data is record
        reserved    : std_logic_vector(27 downto 0);
        start_frame : std_logic_vector(15 downto 0);
        stop_frame  : std_logic_vector(15 downto 0);
        pixel_col   : std_logic_vector(15 downto 0);
        pixel_row   : std_logic_vector(15 downto 0);
        pixel_value : std_logic_vector(15 downto 0);
    end record t_comm_content_errinj_ram_data;

    constant c_COMM_CONTENT_ERRINJ_RAM_DATA_RST : t_comm_content_errinj_ram_data := (
        reserved    => (others => '0'),
        start_frame => (others => '0'),
        stop_frame  => (others => '0'),
        pixel_col   => (others => '0'),
        pixel_row   => (others => '0'),
        pixel_value => (others => '0')
    );

    signal s_content_errinj_ram_address : std_logic_vector(6 downto 0);
    signal s_content_errinj_ram_wrdata  : t_comm_content_errinj_ram_data;
    signal s_content_errinj_ram_wren    : std_logic;
    signal s_content_errinj_ram_rddata  : t_comm_content_errinj_ram_data;

    signal s_content_errinj_errors_cnt : unsigned(6 downto 0);

    constant c_RAM_FETCH_TIME : unsigned(1 downto 0) := "11";
    signal s_ram_fetch_cnt    : unsigned(1 downto 0);

    signal s_injected_errors_cnt : unsigned(6 downto 0);

    signal s_first_frame : std_logic;
    signal s_frame_cnt   : unsigned(15 downto 0);
    signal s_last_frame  : unsigned(15 downto 0);

begin

    comm_content_errinj_altsyncram_inst : entity work.comm_content_errinj_altsyncram
        port map(
            aclr                => rst_i,
            address             => s_content_errinj_ram_address,
            clock               => clk_i,
            data(107 downto 80) => s_content_errinj_ram_wrdata.reserved,
            data(79 downto 64)  => s_content_errinj_ram_wrdata.start_frame,
            data(63 downto 48)  => s_content_errinj_ram_wrdata.stop_frame,
            data(47 downto 32)  => s_content_errinj_ram_wrdata.pixel_col,
            data(31 downto 16)  => s_content_errinj_ram_wrdata.pixel_row,
            data(15 downto 0)   => s_content_errinj_ram_wrdata.pixel_value,
            wren                => s_content_errinj_ram_wren,
            q(107 downto 80)    => s_content_errinj_ram_rddata.reserved,
            q(79 downto 64)     => s_content_errinj_ram_rddata.start_frame,
            q(63 downto 48)     => s_content_errinj_ram_rddata.stop_frame,
            q(47 downto 32)     => s_content_errinj_ram_rddata.pixel_col,
            q(31 downto 16)     => s_content_errinj_ram_rddata.pixel_row,
            q(15 downto 0)      => s_content_errinj_ram_rddata.pixel_value
        );

    p_comm_content_errinj_manager : process(clk_i, rst_i) is
        variable v_comm_content_errinj_manager_state : t_comm_content_errinj_manager_fsm := IDLE;
        variable v_fetched_rddata                    : t_comm_content_errinj_ram_data    := c_COMM_CONTENT_ERRINJ_RAM_DATA_RST;
        variable v_skip_error                        : std_logic                         := '0';
    begin
        if (rst_i = '1') then
            -- fsm state reset
            s_comm_content_errinj_manager_state <= IDLE;
            v_comm_content_errinj_manager_state := IDLE;
            -- internal signals reset
            s_content_errinj_ram_address        <= (others => '0');
            s_content_errinj_ram_wrdata         <= c_COMM_CONTENT_ERRINJ_RAM_DATA_RST;
            s_content_errinj_ram_wren           <= '0';
            s_content_errinj_errors_cnt         <= (others => '0');
            s_ram_fetch_cnt                     <= (others => '0');
            s_injected_errors_cnt               <= (others => '0');
            s_first_frame                       <= '0';
            s_frame_cnt                         <= (others => '0');
            s_last_frame                        <= (others => '0');
            v_fetched_rddata                    := c_COMM_CONTENT_ERRINJ_RAM_DATA_RST;
            v_skip_error                        := '0';
            -- outputs reset
            config_content_errinj_idle_o        <= '0';
            config_content_errinj_recording_o   <= '0';
            config_content_errinj_injecting_o   <= '0';
            config_content_errinj_errors_cnt_o  <= (others => '0');
            inject_content_errinj_enable_o      <= '0';
            inject_content_errinj_px_col_o      <= (others => '0');
            inject_content_errinj_px_row_o      <= (others => '0');
            inject_content_errinj_px_val_o      <= (others => '0');
        elsif rising_edge(clk_i) then

            -- States Transition --
            -- States transitions FSM
            case (s_comm_content_errinj_manager_state) is

                -- state "IDLE"
                when IDLE =>
                    -- error injection manager is idle
                    -- default state transition
                    s_comm_content_errinj_manager_state <= IDLE;
                    v_comm_content_errinj_manager_state := IDLE;
                    -- default internal signal values
                    s_content_errinj_ram_address        <= (others => '0');
                    s_content_errinj_ram_wrdata         <= c_COMM_CONTENT_ERRINJ_RAM_DATA_RST;
                    s_content_errinj_ram_wren           <= '0';
                    s_ram_fetch_cnt                     <= (others => '0');
                    s_injected_errors_cnt               <= (others => '0');
                    s_first_frame                       <= '0';
                    s_frame_cnt                         <= (others => '0');
                    v_fetched_rddata                    := c_COMM_CONTENT_ERRINJ_RAM_DATA_RST;
                    v_skip_error                        := '0';
                    -- conditional state transition
                    -- check if a content error injection clear was requested
                    if (config_content_errinj_clear_i = '1') then
                        -- a content error injection clear was requested					
                        -- clear the errors counter
                        s_content_errinj_errors_cnt <= (others => '0');
                        -- clear the last frame
                        s_last_frame                <= (others => '0');
                    end if;
                    -- check if a ram open was requested
                    if (config_content_errinj_open_i = '1') then
                        -- a ram open was requested
                        -- go to recording
                        s_comm_content_errinj_manager_state <= RECORDING;
                        v_comm_content_errinj_manager_state := RECORDING;
                    -- check if a content error injection start was requested and there is at least one error to be injected
                    elsif ((config_content_errinj_start_i = '1') and (s_content_errinj_errors_cnt /= 0)) then
                        -- a content error injection start was requested and there is at least one error to be injected
                        -- set ram fetch counter
                        s_ram_fetch_cnt                     <= c_RAM_FETCH_TIME;
                        -- set first frame flag
                        s_first_frame                       <= '1';
                        -- go to wating sync
                        s_comm_content_errinj_manager_state <= WAITING_SYNC;
                        v_comm_content_errinj_manager_state := WAITING_SYNC;
                    end if;

                -- state "RECORDING"
                when RECORDING =>
                    -- error injection manager is recording
                    -- default state transition
                    s_comm_content_errinj_manager_state <= RECORDING;
                    v_comm_content_errinj_manager_state := RECORDING;
                    -- default internal signal values
                    s_content_errinj_ram_wrdata         <= c_COMM_CONTENT_ERRINJ_RAM_DATA_RST;
                    s_content_errinj_ram_wren           <= '0';
                    s_injected_errors_cnt               <= (others => '0');
                    s_first_frame                       <= '0';
                    s_frame_cnt                         <= (others => '0');
                    v_fetched_rddata                    := c_COMM_CONTENT_ERRINJ_RAM_DATA_RST;
                    v_skip_error                        := '0';
                    -- conditional state transition
                    -- check if ram close was requested
                    if (config_content_errinj_close_i = '1') then
                        -- ram close was requested
                        -- close the ram and go back to idle
                        s_comm_content_errinj_manager_state <= IDLE;
                        v_comm_content_errinj_manager_state := IDLE;
                    else
                        -- ram close was not requested
                        -- check if a write to the ram was requested
                        if (config_content_errinj_write_i = '1') then
                            -- a write to the ram was requested
                            -- write input data to ram memory
                            s_content_errinj_ram_wrdata.start_frame <= config_content_errinj_start_frame_i;
                            s_content_errinj_ram_wrdata.stop_frame  <= config_content_errinj_stop_frame_i;
                            s_content_errinj_ram_wrdata.pixel_col   <= config_content_errinj_pixel_col_i;
                            s_content_errinj_ram_wrdata.pixel_row   <= config_content_errinj_pixel_row_i;
                            s_content_errinj_ram_wrdata.pixel_value <= config_content_errinj_pixel_value_i;
                            s_content_errinj_ram_wren               <= '1';
                            -- increment the errors counter
                            s_content_errinj_errors_cnt             <= s_content_errinj_errors_cnt + 1;
                            -- check if the last frame need to be updated 
                            if (s_last_frame < unsigned(config_content_errinj_stop_frame_i)) then
                                -- the last frame need to be updated
                                -- update last frame
                                s_last_frame <= unsigned(config_content_errinj_stop_frame_i);
                            end if;
                            -- go to write ram
                            s_comm_content_errinj_manager_state <= WRITE_RAM;
                            v_comm_content_errinj_manager_state := WRITE_RAM;
                        end if;
                    end if;

                -- state "WRITE_RAM"
                when WRITE_RAM =>
                    -- error injection manager is writing to ram memory
                    -- default state transition
                    s_comm_content_errinj_manager_state <= RECORDING;
                    v_comm_content_errinj_manager_state := RECORDING;
                    -- default internal signal values
                    s_content_errinj_ram_wren           <= '0';
                    s_injected_errors_cnt               <= (others => '0');
                    s_first_frame                       <= '0';
                    s_frame_cnt                         <= (others => '0');
                    v_fetched_rddata                    := c_COMM_CONTENT_ERRINJ_RAM_DATA_RST;
                    v_skip_error                        := '0';
                    -- conditional state transition
                    -- check if ram close was requested
                    if (config_content_errinj_close_i = '1') then
                        -- ram close was requested
                        -- close the ram and go back to idle
                        s_comm_content_errinj_manager_state <= IDLE;
                        v_comm_content_errinj_manager_state := IDLE;
                    else
                        -- ram close was not requested
                        -- check if all the ram was used
                        if (s_content_errinj_ram_address = c_CONTENT_ERRINJ_RAM_LAST_ADDRESS) then
                            -- all the ram was used
                            -- close the ram and go back to idle
                            s_comm_content_errinj_manager_state <= IDLE;
                            v_comm_content_errinj_manager_state := IDLE;
                        else
                            -- there still space in the ram
                            -- increment the ram addr
                            s_content_errinj_ram_address <= std_logic_vector(unsigned(s_content_errinj_ram_address) + 1);
                        end if;
                    end if;

                -- state "WAITING_SYNC"
                when WAITING_SYNC =>
                    -- error injection manager is waiting a sync
                    -- default state transition
                    s_comm_content_errinj_manager_state <= WAITING_SYNC;
                    v_comm_content_errinj_manager_state := WAITING_SYNC;
                    -- default internal signal values
                    s_content_errinj_ram_wrdata         <= c_COMM_CONTENT_ERRINJ_RAM_DATA_RST;
                    s_content_errinj_ram_wren           <= '0';
                    -- conditional state transition
                    -- check if a stop was requested
                    if (config_content_errinj_stop_i = '1') then
                        -- a stop was requested
                        -- stop the content error injection and go back to idle
                        s_comm_content_errinj_manager_state <= IDLE;
                        v_comm_content_errinj_manager_state := IDLE;
                    else
                        -- a stop was not requested
                        -- check if a channel sync trigger arrived
                        if (ch_sync_trigger_i = '1') then
                            -- a channel sync trigger arrived
                            -- check if it is the first frame
                            if (s_first_frame = '1') then
                                -- it is the first frame
                                -- clear first frame flag
                                s_first_frame <= '0';
                            else
                                -- not the first frame
                                -- increment the frame counter
                                s_frame_cnt <= s_frame_cnt + 1;
                            end if;
                            -- go to fetch ram
                            s_comm_content_errinj_manager_state <= FETCH_RAM;
                            v_comm_content_errinj_manager_state := FETCH_RAM;
                        end if;
                        -- check if ram fetch ongoing
                        if (s_ram_fetch_cnt /= 0) then
                            -- ram fetch ongoing
                            -- decrement ram fetch counter
                            s_ram_fetch_cnt <= s_ram_fetch_cnt - 1;
                        end if;
                    end if;

                -- state "FETCH_RAM"
                when FETCH_RAM =>
                    -- error injection manager is fetching from ram memory
                    -- default state transition
                    s_comm_content_errinj_manager_state <= FETCH_RAM;
                    v_comm_content_errinj_manager_state := FETCH_RAM;
                    -- default internal signal values
                    s_content_errinj_ram_wrdata         <= c_COMM_CONTENT_ERRINJ_RAM_DATA_RST;
                    s_content_errinj_ram_wren           <= '0';
                    -- conditional state transition
                    -- check if a stop was requested
                    if (config_content_errinj_stop_i = '1') then
                        -- a stop was requested
                        -- stop the content error injection and go back to idle
                        s_comm_content_errinj_manager_state <= IDLE;
                        v_comm_content_errinj_manager_state := IDLE;
                    -- check if a sync arrived in the wrong moment (unexpected sync)
                    elsif (ch_sync_trigger_i = '1') then
                        -- a sync arrived in the wrong moment (unexpected sync)
                        -- go to unexpected sync
                        s_comm_content_errinj_manager_state <= UNEXPECTED_SYNC;
                        v_comm_content_errinj_manager_state := UNEXPECTED_SYNC;
                    else
                        -- a stop was not requested and a sync did not arrived in the wrong moment (error ocurred)
                        -- check if ram fetch ended
                        if (s_ram_fetch_cnt = 0) then
                            -- ram fetch ended
                            -- register the fetched data
                            v_fetched_rddata             := s_content_errinj_ram_rddata;
                            -- set next ram addr (pre-fetch data)
                            s_content_errinj_ram_address <= std_logic_vector(unsigned(s_content_errinj_ram_address) + 1);
                            -- set ram fetch counter
                            s_ram_fetch_cnt              <= c_RAM_FETCH_TIME;
                            -- increment the injected errors counter
                            s_injected_errors_cnt        <= s_injected_errors_cnt + 1;
                            -- check if the fetched error should be applied in the current frame (frame is between start and stop frames) 
                            if ((s_frame_cnt >= unsigned(s_content_errinj_ram_rddata.start_frame)) and (s_frame_cnt <= unsigned(s_content_errinj_ram_rddata.stop_frame))) then
                                -- the fetched error should be applied in the current frame (frame is between start and stop frames)
                                v_skip_error := '0';
                            else
                                -- the fetched error should not be applied in the current frame (frame is not between start and stop frames)
                                v_skip_error := '1';
                            end if;
                            -- go to injecting
                            s_comm_content_errinj_manager_state <= INJECTING;
                            v_comm_content_errinj_manager_state := INJECTING;
                        else
                            -- ram fetch ongoing
                            -- decrement ram fetch counter
                            s_ram_fetch_cnt <= s_ram_fetch_cnt - 1;
                        end if;
                    end if;

                -- state "INJECTING"
                when INJECTING =>
                    -- error injection manager is injecting
                    -- default state transition
                    s_comm_content_errinj_manager_state <= INJECTING;
                    v_comm_content_errinj_manager_state := INJECTING;
                    -- default internal signal values
                    s_content_errinj_ram_wrdata         <= c_COMM_CONTENT_ERRINJ_RAM_DATA_RST;
                    s_content_errinj_ram_wren           <= '0';
                    -- conditional state transition
                    -- check if a stop was requested
                    if (config_content_errinj_stop_i = '1') then
                        -- a stop was requested
                        -- stop the content error injection and go back to idle
                        s_comm_content_errinj_manager_state <= IDLE;
                        v_comm_content_errinj_manager_state := IDLE;
                    -- check if a sync arrived in the wrong moment (unexpected sync)
                    elsif (ch_sync_trigger_i = '1') then
                        -- a sync arrived in the wrong moment (unexpected sync)
                        -- go to unexpected sync
                        s_comm_content_errinj_manager_state <= UNEXPECTED_SYNC;
                        v_comm_content_errinj_manager_state := UNEXPECTED_SYNC;
                    else
                        -- a stop was not requested and a sync did not arrived in the wrong moment (error ocurred)
                        -- check if a content error injection done was received or if the error was skiped
                        if ((inject_content_errinj_done_i = '1') or (v_skip_error = '1')) then
                            -- a content error injection done was received
                            -- check if there are no more errors to be injected
                            if (s_injected_errors_cnt = s_content_errinj_errors_cnt) then
                                -- there are no more errors to be injected
                                -- check if the last frame was processed
                                if (s_frame_cnt >= s_last_frame) then
                                    -- the last frame was processed
                                    -- go to finished
                                    s_comm_content_errinj_manager_state <= FINISHED;
                                    v_comm_content_errinj_manager_state := FINISHED;
                                else
                                    -- the last frame was not processed yet
                                    -- clear the injected errors counter
                                    s_injected_errors_cnt               <= (others => '0');
                                    -- clear the content error injection ram address (return to first error)
                                    s_content_errinj_ram_address        <= (others => '0');
                                    -- set ram fetch counter
                                    s_ram_fetch_cnt                     <= c_RAM_FETCH_TIME;
                                    -- go to waiting sync
                                    s_comm_content_errinj_manager_state <= WAITING_SYNC;
                                    v_comm_content_errinj_manager_state := WAITING_SYNC;
                                end if;
                            else
                                -- there are more errors to be injected
                                -- go to fetch ram
                                s_comm_content_errinj_manager_state <= FETCH_RAM;
                                v_comm_content_errinj_manager_state := FETCH_RAM;
                            end if;
                        end if;
                        -- check if ram fetch ongoing
                        if (s_ram_fetch_cnt /= 0) then
                            -- ram fetch ongoing
                            -- decrement ram fetch counter
                            s_ram_fetch_cnt <= s_ram_fetch_cnt - 1;
                        end if;
                    end if;

                -- state "UNEXPECTED_SYNC"
                when UNEXPECTED_SYNC =>
                    -- error injection manager received a unexpected sync
                    -- default state transition
                    s_comm_content_errinj_manager_state <= FETCH_RAM;
                    v_comm_content_errinj_manager_state := FETCH_RAM;
                    -- default internal signal values
                    s_content_errinj_ram_wrdata         <= c_COMM_CONTENT_ERRINJ_RAM_DATA_RST;
                    s_content_errinj_ram_wren           <= '0';
                    if (config_content_errinj_stop_i = '1') then
                        -- a stop was requested
                        -- stop the content error injection and go back to idle
                        s_comm_content_errinj_manager_state <= IDLE;
                        v_comm_content_errinj_manager_state := IDLE;
                    else
                        -- a stop was not requested, process next frame
                        -- check if the last frame was processed
                        if (s_frame_cnt >= s_last_frame) then
                            -- the last frame was processed
                            -- go to finished
                            s_comm_content_errinj_manager_state <= FINISHED;
                            v_comm_content_errinj_manager_state := FINISHED;
                        else
                            -- the last frame was not processed yet
                            -- check if it is the first frame
                            if (s_first_frame = '1') then
                                -- it is the first frame
                                -- clear first frame flag
                                s_first_frame <= '0';
                            else
                                -- not the first frame
                                -- increment the frame counter
                                s_frame_cnt <= s_frame_cnt + 1;
                            end if;
                            -- clear the injected errors counter
                            s_injected_errors_cnt        <= (others => '0');
                            -- clear the content error injection ram address (return to first error)
                            s_content_errinj_ram_address <= (others => '0');
                            -- set ram fetch counter
                            s_ram_fetch_cnt              <= c_RAM_FETCH_TIME;
                        end if;
                        -- check if ram fetch ongoing
                        if (s_ram_fetch_cnt /= 0) then
                            -- ram fetch ongoing
                            -- decrement ram fetch counter
                            s_ram_fetch_cnt <= s_ram_fetch_cnt - 1;
                        end if;
                    end if;

                -- state "FINISHED"
                when FINISHED =>
                    -- error injection manager is finished
                    -- default state transition
                    s_comm_content_errinj_manager_state <= IDLE;
                    v_comm_content_errinj_manager_state := IDLE;
                    -- default internal signal values
                    s_content_errinj_ram_address        <= (others => '0');
                    s_content_errinj_ram_wrdata         <= c_COMM_CONTENT_ERRINJ_RAM_DATA_RST;
                    s_content_errinj_ram_wren           <= '0';
                    s_ram_fetch_cnt                     <= (others => '0');
                    s_injected_errors_cnt               <= (others => '0');
                    s_frame_cnt                         <= (others => '0');
                    v_fetched_rddata                    := c_COMM_CONTENT_ERRINJ_RAM_DATA_RST;
                -- conditional state transition

                -- all the other states (not defined)
                when others =>
                    s_comm_content_errinj_manager_state <= IDLE;
                    v_comm_content_errinj_manager_state := IDLE;

            end case;

            -- Output Generation --
            -- Default output generation
            config_content_errinj_idle_o       <= '0';
            config_content_errinj_recording_o  <= '0';
            config_content_errinj_injecting_o  <= '0';
            config_content_errinj_errors_cnt_o <= std_logic_vector(s_content_errinj_errors_cnt);
            inject_content_errinj_enable_o     <= '0';
            inject_content_errinj_px_col_o     <= (others => '0');
            inject_content_errinj_px_row_o     <= (others => '0');
            inject_content_errinj_px_val_o     <= (others => '0');
            -- Output generation FSM
            case (v_comm_content_errinj_manager_state) is

                -- state "IDLE"
                when IDLE =>
                    -- error injection manager is idle
                    -- default output signals
                    config_content_errinj_idle_o <= '1';
                -- conditional output signals

                -- state "RECORDING"
                when RECORDING =>
                    -- error injection manager is recording
                    -- default output signals
                    config_content_errinj_recording_o <= '1';
                -- conditional output signals

                -- state "WRITE_RAM"
                when WRITE_RAM =>
                    -- error injection manager is writing to ram memory
                    -- default output signals
                    config_content_errinj_recording_o <= '1';
                -- conditional output signals

                -- state "WAITING_SYNC"
                when WAITING_SYNC =>
                    -- error injection manager is waiting a sync
                    -- default output signals
                    config_content_errinj_injecting_o <= '1';
                -- conditional output signals

                -- state "FETCH_RAM"
                when FETCH_RAM =>
                    -- error injection manager is fetching from ram memory
                    -- default output signals
                    config_content_errinj_injecting_o <= '1';
                -- conditional output signals

                -- state "INJECTING"
                when INJECTING =>
                    -- error injection manager is injecting
                    -- default output signals
                    config_content_errinj_injecting_o <= '1';
                    inject_content_errinj_px_col_o    <= v_fetched_rddata.pixel_col;
                    inject_content_errinj_px_row_o    <= v_fetched_rddata.pixel_row;
                    inject_content_errinj_px_val_o    <= v_fetched_rddata.pixel_value;
                    -- conditional output signals
                    -- check if the error is to be skipped
                    if (v_skip_error = '1') then
                        -- the error is to be skipped
                        inject_content_errinj_enable_o <= '0';
                    else
                        -- the error is to be injected
                        inject_content_errinj_enable_o <= '1';
                    end if;

                -- state "UNEXPECTED_SYNC"
                when UNEXPECTED_SYNC =>
                    -- error injection manager received a unexpected sync
                    -- default output signals
                    config_content_errinj_injecting_o <= '1';
                -- conditional output signals

                -- state "FINISHED"
                when FINISHED =>
                    -- error injection manager is finished
                    -- default output signals
                    config_content_errinj_injecting_o <= '1';
                    -- conditional output signals

            end case;

        end if;
    end process p_comm_content_errinj_manager;

end architecture RTL;
