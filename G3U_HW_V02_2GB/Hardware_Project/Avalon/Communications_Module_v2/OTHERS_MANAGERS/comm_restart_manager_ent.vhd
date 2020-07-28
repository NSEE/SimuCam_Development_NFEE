library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity comm_restart_manager_ent is
	port(
		clk_i             : in  std_logic;
		rst_i             : in  std_logic;
		ch_sync_restart_i : in  std_logic;
		comm_stop_i       : in  std_logic;
		comm_clear_i      : in  std_logic;
		comm_start_i      : in  std_logic;
		machine_stop_o    : out std_logic;
		machine_clear_o   : out std_logic;
		machine_start_o   : out std_logic
	);
end entity comm_restart_manager_ent;

architecture RTL of comm_restart_manager_ent is

	signal s_clrman_clear : std_logic;
	signal s_clrman_stop  : std_logic;
	signal s_clrman_start : std_logic;

	constant c_CLEAR_CNT_VALUE : natural := 89;
	constant c_START_CNT_VALUE : natural := 9;

	signal s_clrman_clear_cnt : natural range 0 to c_CLEAR_CNT_VALUE;
	signal s_clrman_start_cnt : natural range 0 to c_START_CNT_VALUE;

	signal s_clrman_clear_counting : std_logic;
	signal s_clrman_start_counting : std_logic;

begin

	p_comm_restart_manager : process(clk_i, rst_i) is
	begin
		if (rst_i) = '1' then

			s_clrman_clear          <= '0';
			s_clrman_stop           <= '0';
			s_clrman_start          <= '0';
			s_clrman_clear_cnt      <= 0;
			s_clrman_start_cnt      <= 0;
			s_clrman_clear_counting <= '0';
			s_clrman_start_counting <= '0';

		elsif rising_edge(clk_i) then

			-- triggers the control signals
			s_clrman_clear <= '0';
			s_clrman_stop  <= '0';
			s_clrman_start <= '0';

			-- check if a sync restar command arrived
			if (ch_sync_restart_i = '1') then
				-- a sync restar command arrived
				-- issue a stop command 
				s_clrman_stop           <= '1';
				-- set the clear counter and the counting flag
				s_clrman_clear_cnt      <= c_CLEAR_CNT_VALUE;
				s_clrman_clear_counting <= '1';
			end if;

			-- check if the clear is couting
			if (s_clrman_clear_counting = '1') then
				-- check if the clear counter is finished
				if (s_clrman_clear_cnt = 0) then
					-- the clear counter is finished
					-- issue a clear command
					s_clrman_clear          <= '1';
					-- clear the clear counting flag
					s_clrman_clear_counting <= '0';
					-- set the start counter and the counting flag
					s_clrman_start_cnt      <= c_START_CNT_VALUE;
					s_clrman_start_counting <= '1';
				else
					-- the clear counter is not finished
					-- decrement the clear counter
					s_clrman_clear_cnt <= s_clrman_clear_cnt - 1;
				end if;
			end if;

			-- check if the start is couting
			if (s_clrman_start_counting = '1') then
				-- check if the start counter is finished
				if (s_clrman_start_cnt = 0) then
					-- the start counter is finished
					-- clear the start counting flag
					s_clrman_start_counting <= '0';
					-- issue a start command
					s_clrman_start          <= '1';
				else
					-- the start counter is not finished
					-- decrement the start counter
					s_clrman_start_cnt <= s_clrman_start_cnt - 1;
				end if;
			end if;

			-- check if the user issued any command
			if ((comm_stop_i = '1') or (comm_clear_i = '1') or (comm_start_i = '1')) then
				-- the user issued any command
				-- clear all commands and conters
				s_clrman_clear          <= '0';
				s_clrman_stop           <= '0';
				s_clrman_start          <= '0';
				s_clrman_clear_cnt      <= 0;
				s_clrman_start_cnt      <= 0;
				s_clrman_clear_counting <= '0';
				s_clrman_start_counting <= '0';
			end if;

		end if;
	end process p_comm_restart_manager;

	-- outputs generation
	machine_clear_o <= (comm_clear_i) or (s_clrman_clear);
	machine_stop_o  <= (comm_stop_i) or (s_clrman_stop);
	machine_start_o <= (comm_start_i) or (s_clrman_start);

end architecture RTL;
