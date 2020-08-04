library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity comm_header_errinj_manager_ent is
	port(
		clk_i                               : in  std_logic;
		rst_i                               : in  std_logic;
		config_header_errinj_open_i         : in  std_logic;
		config_header_errinj_close_i        : in  std_logic;
		config_header_errinj_clear_i        : in  std_logic;
		config_header_errinj_write_i        : in  std_logic;
		config_header_errinj_start_i        : in  std_logic;
		config_header_errinj_stop_i         : in  std_logic;
		config_header_errinj_frame_num_i    : in  std_logic_vector(1 downto 0);
		config_header_errinj_sequence_cnt_i : in  std_logic_vector(15 downto 0);
		config_header_errinj_field_id_i     : in  std_logic_vector(3 downto 0);
		config_header_errinj_value_i        : in  std_logic_vector(15 downto 0);
		inject_header_errinj_done_i         : in  std_logic;
		config_header_errinj_idle_o         : out std_logic;
		config_header_errinj_recording_o    : out std_logic;
		config_header_errinj_injecting_o    : out std_logic;
		config_header_errinj_errors_cnt_o   : out std_logic_vector(4 downto 0);
		inject_header_errinj_enable_o       : out std_logic;
		inject_header_errinj_frame_num_o    : out std_logic_vector(1 downto 0);
		inject_header_errinj_sequence_cnt_o : out std_logic_vector(15 downto 0);
		inject_header_errinj_field_id_o     : out std_logic_vector(3 downto 0);
		inject_header_errinj_value_o        : out std_logic_vector(15 downto 0)
	);
end entity comm_header_errinj_manager_ent;

architecture RTL of comm_header_errinj_manager_ent is

	type t_comm_header_errinj_manager_fsm is (
		IDLE,                           -- error injection manager is idle
		RECORDING,                      -- error injection manager is recording
		WRITE_RAM,                      -- error injection manager is writing to ram memory
		FETCH_RAM,                      -- error injection manager is fetching from ram memory
		INJECTING,                      -- error injection manager is injecting
		FINISHED                        -- error injection manager is finished
	);

	signal s_comm_header_errinj_manager_state : t_comm_header_errinj_manager_fsm;

	constant c_HEADER_ERRINJ_RAM_LAST_ADDRESS : std_logic_vector(4 downto 0) := (others => '1');

	type t_comm_header_errinj_ram_data is record
		reserved     : std_logic_vector(1 downto 0);
		frame_num    : std_logic_vector(1 downto 0);
		sequence_cnt : std_logic_vector(15 downto 0);
		field_id     : std_logic_vector(3 downto 0);
		value        : std_logic_vector(15 downto 0);
	end record t_comm_header_errinj_ram_data;

	constant c_COMM_HEADER_ERRINJ_RAM_DATA_RST : t_comm_header_errinj_ram_data := (
		reserved     => (others => '0'),
		frame_num    => (others => '0'),
		sequence_cnt => (others => '0'),
		field_id     => (others => '0'),
		value        => (others => '0')
	);

	signal s_header_errinj_ram_address : std_logic_vector(4 downto 0);
	signal s_header_errinj_ram_wrdata  : t_comm_header_errinj_ram_data;
	signal s_header_errinj_ram_wren    : std_logic;
	signal s_header_errinj_ram_rddata  : t_comm_header_errinj_ram_data;

	signal s_header_errinj_errors_cnt : unsigned(4 downto 0);

	constant c_RAM_FETCH_TIME : unsigned(1 downto 0) := "11";
	signal s_ram_fetch_cnt    : unsigned(1 downto 0);

	signal s_injected_errors_cnt : unsigned(4 downto 0);

begin

	comm_header_errinj_altsyncram_inst : entity work.comm_header_errinj_altsyncram
		port map(
			aclr               => rst_i,
			address            => s_header_errinj_ram_address,
			clock              => clk_i,
			data(39 downto 38) => s_header_errinj_ram_wrdata.reserved,
			data(37 downto 36) => s_header_errinj_ram_wrdata.frame_num,
			data(35 downto 20) => s_header_errinj_ram_wrdata.sequence_cnt,
			data(19 downto 16) => s_header_errinj_ram_wrdata.field_id,
			data(15 downto 0)  => s_header_errinj_ram_wrdata.value,
			wren               => s_header_errinj_ram_wren,
			q(39 downto 38)    => s_header_errinj_ram_rddata.reserved,
			q(37 downto 36)    => s_header_errinj_ram_rddata.frame_num,
			q(35 downto 20)    => s_header_errinj_ram_rddata.sequence_cnt,
			q(19 downto 16)    => s_header_errinj_ram_rddata.field_id,
			q(15 downto 0)     => s_header_errinj_ram_rddata.value
		);

	p_comm_header_errinj_manager : process(clk_i, rst_i) is
		variable v_comm_header_errinj_manager_state : t_comm_header_errinj_manager_fsm := IDLE;
		variable v_fetched_rddata                   : t_comm_header_errinj_ram_data    := c_COMM_HEADER_ERRINJ_RAM_DATA_RST;
	begin
		if (rst_i = '1') then
			-- fsm state reset
			s_comm_header_errinj_manager_state  <= IDLE;
			v_comm_header_errinj_manager_state  := IDLE;
			-- internal signals reset
			s_header_errinj_ram_address         <= (others => '0');
			s_header_errinj_ram_wrdata          <= c_COMM_HEADER_ERRINJ_RAM_DATA_RST;
			s_header_errinj_ram_wren            <= '0';
			s_header_errinj_errors_cnt          <= (others => '0');
			s_ram_fetch_cnt                     <= (others => '0');
			s_injected_errors_cnt               <= (others => '0');
			v_fetched_rddata                    := c_COMM_HEADER_ERRINJ_RAM_DATA_RST;
			-- outputs reset
			config_header_errinj_idle_o         <= '0';
			config_header_errinj_recording_o    <= '0';
			config_header_errinj_injecting_o    <= '0';
			config_header_errinj_errors_cnt_o   <= (others => '0');
			inject_header_errinj_enable_o       <= '0';
			inject_header_errinj_frame_num_o    <= (others => '0');
			inject_header_errinj_sequence_cnt_o <= (others => '0');
			inject_header_errinj_field_id_o     <= (others => '0');
			inject_header_errinj_value_o        <= (others => '0');
		elsif rising_edge(clk_i) then

			-- States Transition --
			-- States transitions FSM
			case (s_comm_header_errinj_manager_state) is

				-- state "IDLE"
				when IDLE =>
					-- error injection manager is idle
					-- default state transition
					s_comm_header_errinj_manager_state <= IDLE;
					v_comm_header_errinj_manager_state := IDLE;
					-- default internal signal values
					s_header_errinj_ram_address        <= (others => '0');
					s_header_errinj_ram_wrdata         <= c_COMM_HEADER_ERRINJ_RAM_DATA_RST;
					s_header_errinj_ram_wren           <= '0';
					s_ram_fetch_cnt                    <= (others => '0');
					s_injected_errors_cnt              <= (others => '0');
					v_fetched_rddata                   := c_COMM_HEADER_ERRINJ_RAM_DATA_RST;
					-- conditional state transition
					-- check if a header error injection clear was requested
					if (config_header_errinj_clear_i = '1') then
						-- a header error injection clear was requested					
						-- clear the errors counter
						s_header_errinj_errors_cnt <= (others => '0');
					end if;
					-- check if a ram open was requested
					if (config_header_errinj_open_i = '1') then
						-- a ram open was requested
						-- go to recording
						s_comm_header_errinj_manager_state <= RECORDING;
						v_comm_header_errinj_manager_state := RECORDING;
					-- check if a header error injection start was requested and there is at least one error to be injected
					elsif ((config_header_errinj_start_i = '1') and (s_header_errinj_errors_cnt /= 0)) then
						-- a header error injection start was requested and there is at least one error to be injected
						-- set ram fetch counter
						s_ram_fetch_cnt                    <= c_RAM_FETCH_TIME;
						-- go to fetch ram
						s_comm_header_errinj_manager_state <= FETCH_RAM;
						v_comm_header_errinj_manager_state := FETCH_RAM;
					end if;

				-- state "RECORDING"
				when RECORDING =>
					-- error injection manager is recording
					-- default state transition
					s_comm_header_errinj_manager_state <= RECORDING;
					v_comm_header_errinj_manager_state := RECORDING;
					-- default internal signal values
					s_header_errinj_ram_wrdata         <= c_COMM_HEADER_ERRINJ_RAM_DATA_RST;
					s_header_errinj_ram_wren           <= '0';
					s_injected_errors_cnt              <= (others => '0');
					v_fetched_rddata                   := c_COMM_HEADER_ERRINJ_RAM_DATA_RST;
					-- conditional state transition
					-- check if ram close was requested
					if (config_header_errinj_close_i = '1') then
						-- ram close was requested
						-- close the ram and go back to idle
						s_comm_header_errinj_manager_state <= IDLE;
						v_comm_header_errinj_manager_state := IDLE;
					else
						-- ram close was not requested
						-- check if a write to the ram was requested
						if (config_header_errinj_write_i = '1') then
							-- a write to the ram was requested
							-- write input data to ram memory
							s_header_errinj_ram_wrdata.frame_num    <= config_header_errinj_frame_num_i;
							s_header_errinj_ram_wrdata.sequence_cnt <= config_header_errinj_sequence_cnt_i;
							s_header_errinj_ram_wrdata.field_id     <= config_header_errinj_field_id_i;
							s_header_errinj_ram_wrdata.value        <= config_header_errinj_value_i;
							s_header_errinj_ram_wren                <= '1';
							-- increment the errors counter
							s_header_errinj_errors_cnt              <= s_header_errinj_errors_cnt + 1;
							-- go to write ram
							s_comm_header_errinj_manager_state      <= WRITE_RAM;
							v_comm_header_errinj_manager_state      := WRITE_RAM;
						end if;
					end if;

				-- state "WRITE_RAM"
				when WRITE_RAM =>
					-- error injection manager is writing to ram memory
					-- default state transition
					s_comm_header_errinj_manager_state <= RECORDING;
					v_comm_header_errinj_manager_state := RECORDING;
					-- default internal signal values
					s_header_errinj_ram_wren           <= '0';
					s_injected_errors_cnt              <= (others => '0');
					v_fetched_rddata                   := c_COMM_HEADER_ERRINJ_RAM_DATA_RST;
					-- conditional state transition
					-- check if ram close was requested
					if (config_header_errinj_close_i = '1') then
						-- ram close was requested
						-- close the ram and go back to idle
						s_comm_header_errinj_manager_state <= IDLE;
						v_comm_header_errinj_manager_state := IDLE;
					else
						-- ram close was not requested
						-- check if all the ram was used
						if (s_header_errinj_ram_address = c_HEADER_ERRINJ_RAM_LAST_ADDRESS) then
							-- all the ram was used
							-- close the ram and go back to idle
							s_comm_header_errinj_manager_state <= IDLE;
							v_comm_header_errinj_manager_state := IDLE;
						else
							-- there still space in the ram
							-- increment the ram addr
							s_header_errinj_ram_address <= std_logic_vector(unsigned(s_header_errinj_ram_address) + 1);
						end if;
					end if;

				-- state "FETCH_RAM"
				when FETCH_RAM =>
					-- error injection manager is fetching from ram memory
					-- default state transition
					s_comm_header_errinj_manager_state <= FETCH_RAM;
					v_comm_header_errinj_manager_state := FETCH_RAM;
					-- default internal signal values
					s_header_errinj_ram_wrdata         <= c_COMM_HEADER_ERRINJ_RAM_DATA_RST;
					s_header_errinj_ram_wren           <= '0';
					-- conditional state transition
					-- check if a stop was requested
					if (config_header_errinj_stop_i = '1') then
						-- a stop was requested
						-- stop the header error injection and go back to idle
						s_comm_header_errinj_manager_state <= IDLE;
						v_comm_header_errinj_manager_state := IDLE;
					else
						-- a stop was not requested
						-- check if ram fetch ended
						if (s_ram_fetch_cnt = 0) then
							-- ram fetch ended
							-- register the fetched data
							v_fetched_rddata.reserved          := s_header_errinj_ram_rddata.reserved;
							v_fetched_rddata.frame_num         := s_header_errinj_ram_rddata.frame_num;
							v_fetched_rddata.sequence_cnt      := s_header_errinj_ram_rddata.sequence_cnt;
							v_fetched_rddata.field_id          := s_header_errinj_ram_rddata.field_id;
							v_fetched_rddata.value             := s_header_errinj_ram_rddata.value;
							-- set next ram addr (pre-fetch data)
							s_header_errinj_ram_address        <= std_logic_vector(unsigned(s_header_errinj_ram_address) + 1);
							-- set ram fetch counter
							s_ram_fetch_cnt                    <= c_RAM_FETCH_TIME;
							-- increment the injected errors counter
							s_injected_errors_cnt              <= s_injected_errors_cnt + 1;
							-- go to injecting
							s_comm_header_errinj_manager_state <= INJECTING;
							v_comm_header_errinj_manager_state := INJECTING;
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
					s_comm_header_errinj_manager_state <= INJECTING;
					v_comm_header_errinj_manager_state := INJECTING;
					-- default internal signal values
					s_header_errinj_ram_wrdata         <= c_COMM_HEADER_ERRINJ_RAM_DATA_RST;
					s_header_errinj_ram_wren           <= '0';
					-- conditional state transition
					-- check if a stop was requested
					if (config_header_errinj_stop_i = '1') then
						-- a stop was requested
						-- stop the header error injection and go back to idle
						s_comm_header_errinj_manager_state <= IDLE;
						v_comm_header_errinj_manager_state := IDLE;
					else
						-- a stop was not requested
						-- check if a header error injection done was received
						if (inject_header_errinj_done_i = '1') then
							-- a header error injection done was received
							-- check if there are no more errors to be injected
							if (s_injected_errors_cnt = s_header_errinj_errors_cnt) then
								-- there are no more errors to be injected
								-- go to finished
								s_comm_header_errinj_manager_state <= FINISHED;
								v_comm_header_errinj_manager_state := FINISHED;
							else
								-- there are more errors to be injected
								-- go to fetch ram
								s_comm_header_errinj_manager_state <= FETCH_RAM;
								v_comm_header_errinj_manager_state := FETCH_RAM;
							end if;
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
					s_comm_header_errinj_manager_state <= IDLE;
					v_comm_header_errinj_manager_state := IDLE;
					-- default internal signal values
					s_header_errinj_ram_address        <= (others => '0');
					s_header_errinj_ram_wrdata         <= c_COMM_HEADER_ERRINJ_RAM_DATA_RST;
					s_header_errinj_ram_wren           <= '0';
					s_ram_fetch_cnt                    <= (others => '0');
					s_injected_errors_cnt              <= (others => '0');
					v_fetched_rddata                   := c_COMM_HEADER_ERRINJ_RAM_DATA_RST;
				-- conditional state transition

				-- all the other states (not defined)
				when others =>
					s_comm_header_errinj_manager_state <= IDLE;
					v_comm_header_errinj_manager_state := IDLE;

			end case;

			-- Output Generation --
			-- Default output generation
			config_header_errinj_idle_o         <= '0';
			config_header_errinj_recording_o    <= '0';
			config_header_errinj_injecting_o    <= '0';
			config_header_errinj_errors_cnt_o   <= std_logic_vector(s_header_errinj_errors_cnt);
			inject_header_errinj_enable_o       <= '0';
			inject_header_errinj_frame_num_o    <= (others => '0');
			inject_header_errinj_sequence_cnt_o <= (others => '0');
			inject_header_errinj_field_id_o     <= (others => '0');
			inject_header_errinj_value_o        <= (others => '0');
			-- Output generation FSM
			case (v_comm_header_errinj_manager_state) is

				-- state "IDLE"
				when IDLE =>
					-- error injection manager is idle
					-- default output signals
					config_header_errinj_idle_o <= '1';
				-- conditional output signals

				-- state "RECORDING"
				when RECORDING =>
					-- error injection manager is recording
					-- default output signals
					config_header_errinj_recording_o <= '1';
				-- conditional output signals

				-- state "WRITE_RAM"
				when WRITE_RAM =>
					-- error injection manager is writing to ram memory
					-- default output signals
					config_header_errinj_recording_o <= '1';
				-- conditional output signals

				-- state "FETCH_RAM"
				when FETCH_RAM =>
					-- error injection manager is fetching from ram memory
					-- default output signals
					config_header_errinj_injecting_o <= '1';
				-- conditional output signals

				-- state "INJECTING"
				when INJECTING =>
					-- error injection manager is injecting
					-- default output signals
					config_header_errinj_injecting_o    <= '1';
					inject_header_errinj_enable_o       <= '1';
					inject_header_errinj_frame_num_o    <= v_fetched_rddata.frame_num;
					inject_header_errinj_sequence_cnt_o <= v_fetched_rddata.sequence_cnt;
					inject_header_errinj_field_id_o     <= v_fetched_rddata.field_id;
					inject_header_errinj_value_o        <= v_fetched_rddata.value;
				-- conditional output signals

				-- state "FINISHED"
				when FINISHED =>
					-- error injection manager is finished
					-- default output signals
					config_header_errinj_injecting_o <= '1';
					-- conditional output signals

			end case;

		end if;
	end process p_comm_header_errinj_manager;

end architecture RTL;
