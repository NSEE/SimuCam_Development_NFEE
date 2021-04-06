library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity scom_frame_manager_ent is
	port(
		clk_i             : in  std_logic;
		rst_i             : in  std_logic;
		ch_sync_trigger_i : in  std_logic;
		frame_clear_i     : in  std_logic;
		frame_counter_o   : out std_logic_vector(15 downto 0);
		frame_number_o    : out std_logic_vector(1 downto 0)
	);
end entity scom_frame_manager_ent;

architecture RTL of scom_frame_manager_ent is

	signal s_frame_cleared  : std_logic;
	signal s_frame_full_cnt : std_logic_vector(17 downto 0);

	constant c_FRAME_FULL_CNT_MAX_VAL : std_logic_vector((s_frame_full_cnt'length - 1) downto 0) := (others => '1');

begin

	p_scom_frame_manager : process(clk_i, rst_i) is
	begin
		if (rst_i = '1') then
			s_frame_full_cnt <= (others => '0');
			s_frame_cleared  <= '1';
		elsif rising_edge(clk_i) then

			--
			-- Definitions:
			--
			-- frame counter : full read-out cycle counter
			--   |  frame counter |
			--   |  15 downto  0  |
			--
			-- frame number : current frame inside a full read-out cycle
			--   |   frame number |
			--   |   1 downto  0  |
			--
			-- full frame counter:
			--   |  frame counter |   frame number |
			--   |  17 downto  2  |   1 downto  0  |
			--

			-- check if a frame clear was issued
			if (frame_clear_i = '1') then
				-- frame clear issued, clear frame
				s_frame_full_cnt <= (others => '0');
				-- set the frame cleared flag
				s_frame_cleared  <= '1';
			end if;

			-- check if a sync signal was issued
			if (ch_sync_trigger_i = '1') then
				-- sync issued, increment frame
				-- check if the frame was cleared
				if (s_frame_cleared = '1') then
					-- the frame was cleared, no need to increment
					-- clear the frame cleared flag
					s_frame_cleared <= '0';
				else
					-- the frame was not cleared, need to increment
					-- check if the frame counter will overflow
					if (s_frame_full_cnt = c_FRAME_FULL_CNT_MAX_VAL) then
						-- the frame counter will overflow
						-- clear the frame counter
						s_frame_full_cnt <= (others => '0');
					else
						-- the frame counter will not overflow
						-- increment the frame counter
						s_frame_full_cnt <= std_logic_vector(unsigned(s_frame_full_cnt) + 1);
					end if;
				end if;
			end if;

		end if;
	end process p_scom_frame_manager;

	-- outputs generation
	frame_counter_o <= s_frame_full_cnt(17 downto 2);
	frame_number_o  <= s_frame_full_cnt(1 downto 0);

end architecture RTL;
