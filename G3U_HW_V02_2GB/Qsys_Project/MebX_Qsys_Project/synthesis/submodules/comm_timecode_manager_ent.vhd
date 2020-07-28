library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity comm_timecode_manager_ent is
	port(
		clk_i                 : in  std_logic;
		rst_i                 : in  std_logic;
		ch_sync_trigger_i     : in  std_logic;
		tx_timecode_clear_i   : in  std_logic;
		tx_timecode_en_i      : in  std_logic;
		rx_timecode_tick_i    : in  std_logic;
		rx_timecode_control_i : in  std_logic_vector(1 downto 0);
		rx_timecode_counter_i : in  std_logic_vector(5 downto 0);
		tx_timecode_tick_o    : out std_logic;
		tx_timecode_control_o : out std_logic_vector(1 downto 0);
		tx_timecode_counter_o : out std_logic_vector(5 downto 0)
	);
end entity comm_timecode_manager_ent;

architecture RTL of comm_timecode_manager_ent is

	signal s_tx_timecode_cleared : std_logic;
	signal s_tx_timecode_control : std_logic_vector(1 downto 0);
	signal s_tx_timecode_counter : std_logic_vector(5 downto 0);

begin

	p_comm_timecode_manager : process(clk_i, rst_i) is
	begin
		if (rst_i) = '1' then

			s_tx_timecode_control <= (others => '0');
			s_tx_timecode_counter <= (others => '0');
			s_tx_timecode_cleared <= '1';

			tx_timecode_tick_o <= '0';

		elsif rising_edge(clk_i) then

			-- check if a tx timecode clear was issued
			if (tx_timecode_clear_i = '1') then
				-- tx timecode clear issued, clear timecode
				s_tx_timecode_control <= (others => '0');
				s_tx_timecode_counter <= (others => '0');
				-- set the tx timecode cleared flag
				s_tx_timecode_cleared <= '1';
			end if;

			-- trigger tx timecode signals
			tx_timecode_tick_o <= '0';

			-- check if a sync signal was issued
			if (ch_sync_trigger_i = '1') then
				-- sync issued, increment tx timecode and send by spw
				-- check if the tx timecode transmission is enabled
				if (tx_timecode_en_i = '1') then
					-- send the tx timecode
					tx_timecode_tick_o <= '1';
				end if;
				-- keep tx timecode control cleared
				s_tx_timecode_control <= (others => '0');
				-- check if the tx timecode was cleared
				if (s_tx_timecode_cleared = '1') then
					-- the tx timecode was cleared, no need to increment
					-- clear the tx timecode cleared flag
					s_tx_timecode_cleared <= '0';
				else
					-- the tx timecode was not cleared, need to increment
					-- check if the tx timecode counter will overflow
					if (s_tx_timecode_counter = "111111") then
						-- the tx timecode counter will overflow
						-- clear the tx timecode counter
						s_tx_timecode_counter <= (others => '0');
					else
						-- the tx timecode counter will not overflow
						-- increment the tx timecode counter
						s_tx_timecode_counter <= std_logic_vector(unsigned(s_tx_timecode_counter) + 1);
					end if;
				end if;
			end if;

		end if;
	end process p_comm_timecode_manager;

	-- outputs generation
	tx_timecode_control_o <= s_tx_timecode_control;
	tx_timecode_counter_o <= s_tx_timecode_counter;

end architecture RTL;
