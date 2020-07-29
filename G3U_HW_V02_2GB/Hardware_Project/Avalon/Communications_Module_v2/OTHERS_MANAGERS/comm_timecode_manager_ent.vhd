library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity comm_timecode_manager_ent is
	port(
		clk_i                               : in  std_logic;
		rst_i                               : in  std_logic;
		ch_sync_trigger_i                   : in  std_logic;
		tx_timecode_clear_i                 : in  std_logic;
		tx_timecode_trans_en_i              : in  std_logic;
		tx_timecode_sync_trigger_en_i       : in  std_logic;
		tx_timecode_time_offset_i           : in  std_logic_vector(6 downto 0);
		tx_timecode_sync_delay_trigger_en_i : in  std_logic;
		tx_timecode_sync_delay_value_i      : in  std_logic_vector(31 downto 0);
		rx_timecode_tick_i                  : in  std_logic;
		rx_timecode_control_i               : in  std_logic_vector(1 downto 0);
		rx_timecode_counter_i               : in  std_logic_vector(5 downto 0);
		tx_timecode_tick_o                  : out std_logic;
		tx_timecode_control_o               : out std_logic_vector(1 downto 0);
		tx_timecode_counter_o               : out std_logic_vector(5 downto 0)
	);
end entity comm_timecode_manager_ent;

architecture RTL of comm_timecode_manager_ent is

	signal s_tx_timecode_cleared   : std_logic;
	signal s_tx_timecode_trigger   : std_logic;
	signal s_tx_timecode_delay_cnt : unsigned(31 downto 0);

	signal s_tx_timecode_control     : std_logic_vector(1 downto 0);
	signal s_tx_timecode_ext_counter : unsigned(6 downto 0);
	signal s_tx_timecode_ofs_counter : unsigned(6 downto 0);

	alias a_tx_timecode_cnt_ext_carry is s_tx_timecode_ext_counter(6);
	alias a_tx_timecode_cnt_ofs_carry is s_tx_timecode_ofs_counter(6);
	alias a_tx_timecode_counter is s_tx_timecode_ofs_counter(5 downto 0);

	constant c_COMM_TX_TIMECODE_ZERO_DELAY     : std_logic_vector(31 downto 0) := (others => '0');
	constant c_COMM_TX_TIMECODE_DELAY_FINISHED : unsigned(31 downto 0)         := x"00000001";

begin

	p_comm_timecode_manager : process(clk_i, rst_i) is
	begin
		if (rst_i) = '1' then

			s_tx_timecode_cleared   <= '1';
			s_tx_timecode_trigger   <= '0';
			s_tx_timecode_delay_cnt <= (others => '0');

			s_tx_timecode_control     <= (others => '0');
			s_tx_timecode_ext_counter <= (others => '0');
			s_tx_timecode_ofs_counter <= (others => '0');

			tx_timecode_tick_o <= '0';

		elsif rising_edge(clk_i) then

			-- check if a tx timecode clear was issued
			if (tx_timecode_clear_i = '1') then
				-- tx timecode clear issued, clear tx timecode counters
				s_tx_timecode_delay_cnt   <= (others => '0');
				s_tx_timecode_control     <= (others => '0');
				s_tx_timecode_ext_counter <= (others => '0');
				s_tx_timecode_ofs_counter <= (others => '0');
				-- set the tx timecode cleared flag
				s_tx_timecode_cleared     <= '1';
			end if;

			-- trigger tx timecode signals
			s_tx_timecode_trigger <= '0';
			tx_timecode_tick_o    <= '0';

			-- keep the timecode counters carries cleared
			a_tx_timecode_cnt_ext_carry <= '0';
			a_tx_timecode_cnt_ofs_carry <= '0';

			-- check if a sync signal was issued
			if (ch_sync_trigger_i = '1') then
				-- sync issued
				-- check if the timecode sync trigger is enabled
				if (tx_timecode_sync_trigger_en_i = '1') then
					-- the timecode sync trigger is enabled
					-- issue a tx timecode trigger
					s_tx_timecode_trigger <= '1';
				end if;
				-- check the sync delay trigger is enabled
				if (tx_timecode_sync_delay_trigger_en_i = '1') then
					-- the sync delay trigger is enabled
					-- check if the tx timecode delay is zero (no delay) 
					if (tx_timecode_sync_delay_value_i = c_COMM_TX_TIMECODE_ZERO_DELAY) then
						-- the tx timecode delay is zero (no delay)
						-- clear the tx timecode delay counter
						s_tx_timecode_delay_cnt <= (others => '0');
						-- issue a tx timecode trigger
						s_tx_timecode_trigger   <= '1';
					else
						-- the tx timecode delay is not zero
						-- update the tx timecode delay counter
						s_tx_timecode_delay_cnt <= unsigned(tx_timecode_sync_delay_value_i);
					end if;
				end if;
			end if;

			-- check if the tx timecode delay counter is not zero
			if (s_tx_timecode_delay_cnt /= 0) then
				-- the tx timecode delay counter is not zero
				-- decrement tx timecode delay counter
				s_tx_timecode_delay_cnt <= s_tx_timecode_delay_cnt - 1;
				-- check if the tx timecode delay ended
				if (s_tx_timecode_delay_cnt = c_COMM_TX_TIMECODE_DELAY_FINISHED) then
					-- the tx timecode delay ended
					-- clear the tx timecode delay counter
					s_tx_timecode_delay_cnt <= (others => '0');
					-- issue a tx timecode trigger
					s_tx_timecode_trigger   <= '1';
				end if;
			end if;

			-- check if a tx timecode trigger was issued
			if (s_tx_timecode_trigger = '1') then
				-- tx timecode trigger issued, increment tx timecode and send by spw
				-- check if the tx timecode transmission is enabled
				if (tx_timecode_trans_en_i = '1') then
					-- send the tx timecode
					tx_timecode_tick_o <= '1';
				end if;
				-- keep tx timecode control cleared
				s_tx_timecode_control <= (others => '0');
				-- clear the tx timecode cleared flag
				s_tx_timecode_cleared <= '0';
				-- check if the tx timecode was not cleared
				if (s_tx_timecode_cleared = '1') then
					-- the tx timecode was cleared, no need to increment
					s_tx_timecode_ofs_counter <= s_tx_timecode_ext_counter + unsigned(tx_timecode_time_offset_i);
				else
					-- the tx timecode was not cleared, need to increment
					-- increment the tx timecode extended counter
					s_tx_timecode_ext_counter <= s_tx_timecode_ext_counter + 1;
					s_tx_timecode_ofs_counter <= s_tx_timecode_ext_counter + 1 + unsigned(tx_timecode_time_offset_i);
				end if;
			end if;

		end if;
	end process p_comm_timecode_manager;

	-- outputs generation
	tx_timecode_control_o <= s_tx_timecode_control;
	tx_timecode_counter_o <= std_logic_vector(a_tx_timecode_counter);

end architecture RTL;
