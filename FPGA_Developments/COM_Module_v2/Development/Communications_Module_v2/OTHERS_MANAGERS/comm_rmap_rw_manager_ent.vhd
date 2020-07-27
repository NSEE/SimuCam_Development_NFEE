library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity comm_rmap_rw_manager_ent is
	generic(
		g_RMAP_WIN_OFFSET_WIDTH : natural                       := 0; -- number of non-masking bits in the offset mask
		g_RMAP_WIN_OFFSET_MASK  : std_logic_vector(31 downto 0) := (others => '0')
	);
	port(
		clk_i                      : in  std_logic;
		rst_i                      : in  std_logic;
		rmap_write_authorized_i    : in  std_logic;
		rmap_write_i               : in  std_logic;
		rmap_write_address_i       : in  std_logic_vector(31 downto 0);
		rmap_read_authorized_i     : in  std_logic;
		rmap_read_i                : in  std_logic;
		rmap_read_address_i        : in  std_logic_vector(31 downto 0);
		rmap_last_write_addr_o     : out std_logic_vector(31 downto 0);
		rmap_last_write_length_o   : out std_logic_vector(31 downto 0);
		rmap_last_write_win_area_o : out std_logic;
		rmap_last_read_addr_o      : out std_logic_vector(31 downto 0);
		rmap_last_read_length_o    : out std_logic_vector(31 downto 0);
		rmap_last_read_win_area_o  : out std_logic
	);
end entity comm_rmap_rw_manager_ent;

architecture RTL of comm_rmap_rw_manager_ent is

	signal s_rmap_write_delayed : std_logic;
	signal s_rmap_read_delayed  : std_logic;

	signal s_write_recorded : std_logic;
	signal s_read_recorded  : std_logic;

	signal s_rmap_last_write_length : std_logic_vector(31 downto 0);
	signal s_rmap_last_read_length  : std_logic_vector(31 downto 0);

begin

	p_comm_rmap_rw_manager : process(clk_i, rst_i) is
	begin
		if (rst_i) = '1' then

			s_rmap_write_delayed <= '0';
			s_rmap_read_delayed  <= '0';

			s_write_recorded <= '0';
			s_read_recorded  <= '0';

			s_rmap_last_write_length <= (others => '0');
			s_rmap_last_read_length  <= (others => '0');

			rmap_last_write_win_area_o <= '0';
			rmap_last_read_win_area_o  <= '0';
			rmap_last_write_addr_o     <= (others => '0');
			rmap_last_read_addr_o      <= (others => '0');

		elsif rising_edge(clk_i) then

			-- check if a write was authorized
			if (rmap_write_authorized_i = '1') then
				-- write authorized
				-- check if the write signal had a rising edge
				if ((rmap_write_i = '1') and (s_rmap_write_delayed = '0')) then
					-- the write signal had a rising edge
					-- check if the write parameters were not recorded yet (first write)
					if (s_write_recorded = '0') then
						-- the write parameters were not recorded yet (first write)
						-- record write addr and set win area flag
						rmap_last_write_addr_o   <= rmap_write_address_i;
						-- check if the write was to a windowing area (address upper bits matches the masking bits of the offset mask)
						if (rmap_write_address_i(31 downto g_RMAP_WIN_OFFSET_WIDTH) = g_RMAP_WIN_OFFSET_MASK(31 downto g_RMAP_WIN_OFFSET_WIDTH)) then
							-- the write was to a windowing area
							-- set the windowing area flag
							rmap_last_write_win_area_o <= '1';
						else
							-- the write was not to a windowing area
							-- clear the windowing area flag
							rmap_last_write_win_area_o <= '0';
						end if;
						-- set the write length to one
						s_rmap_last_write_length <= std_logic_vector(to_unsigned(1, s_rmap_last_write_length'length));
						-- set the write parameters recorded flag
						s_write_recorded         <= '1';
					else
						-- the write parameters were already recorded (not first write)
						-- increment the write length
						s_rmap_last_write_length <= std_logic_vector(unsigned(s_rmap_last_write_length) + 1);
					end if;
				end if;
			else
				-- write not authorized
				-- clear the write parameters recorded flag 
				s_write_recorded <= '0';
			end if;
			-- delay write signal
			s_rmap_write_delayed <= rmap_write_i;

			-- check if a read was authorized
			if (rmap_read_authorized_i = '1') then
				-- read authorized
				-- check if the read signal had a rising edge
				if ((rmap_read_i = '1') and (s_rmap_read_delayed = '0')) then
					-- the read signal had a rising edge
					-- check if the read parameters were not recorded yet (first read)
					if (s_read_recorded = '0') then
						-- the read parameters were not recorded yet (first read)
						-- record read addr and set win area flag
						rmap_last_read_addr_o   <= rmap_read_address_i;
						-- check if the read was to a windowing area (address upper bits matches the masking bits of the offset mask)
						if (rmap_read_address_i(31 downto g_RMAP_WIN_OFFSET_WIDTH) = g_RMAP_WIN_OFFSET_MASK(31 downto g_RMAP_WIN_OFFSET_WIDTH)) then
							-- the read was to a windowing area
							-- set the windowing area flag
							rmap_last_read_win_area_o <= '1';
						else
							-- the read was not to a windowing area
							-- clear the windowing area flag
							rmap_last_read_win_area_o <= '0';
						end if;
						-- set the read length to one
						s_rmap_last_read_length <= std_logic_vector(to_unsigned(1, s_rmap_last_read_length'length));
						-- set the read parameters recorded flag
						s_read_recorded         <= '1';
					else
						-- the read parameters were already recorded (not first read)
						-- increment the read length
						s_rmap_last_read_length <= std_logic_vector(unsigned(s_rmap_last_read_length) + 1);
					end if;
				end if;
			else
				-- read not authorized
				-- clear the read parameters recorded flag 
				s_read_recorded <= '0';
			end if;
			-- delay read signal
			s_rmap_read_delayed <= rmap_read_i;

		end if;
	end process p_comm_rmap_rw_manager;

	-- outputs generation
	rmap_last_write_length_o <= s_rmap_last_write_length;
	rmap_last_read_length_o  <= s_rmap_last_read_length;

end architecture RTL;
