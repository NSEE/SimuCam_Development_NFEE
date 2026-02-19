library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity comm_rmap_addr_fifo_manager_ent is
	port(
		clk_i                       : in  std_logic;
		rst_i                       : in  std_logic;
		rmap_write_data_finished_i  : in  std_logic;
		rmap_stat_write_authorized_i : in  std_logic;
		rmap_win_area_write_flag_i  : in  std_logic;
		rmap_last_write_addr_i      : in  std_logic_vector(31 downto 0);
		fifo_rdreq_i                : in  std_logic;
		fifo_empty_o                : out std_logic;
		fifo_rddata_o               : out std_logic_vector(7 downto 0)
	);
end entity comm_rmap_addr_fifo_manager_ent;

architecture RTL of comm_rmap_addr_fifo_manager_ent is

	type t_fifo_write_state is (
		IDLE,
		WR_PULSE,
		WR_GAP
	);

	signal s_write_state               : t_fifo_write_state;
	signal s_write_finished_delayed    : std_logic;
	signal s_fifo_wrreq                : std_logic;
	signal s_fifo_wrdata               : std_logic_vector(7 downto 0);
	signal s_fifo_full                 : std_logic;
	signal s_fifo_empty                : std_logic;
	signal s_fifo_q                    : std_logic_vector(7 downto 0);

begin

	comm_rmap_addr_sc_fifo_inst : entity work.comm_rmap_addr_sc_fifo
		port map(
			aclr  => rst_i,
			clock => clk_i,
			data  => s_fifo_wrdata,
			rdreq => fifo_rdreq_i,
			sclr  => '0',
			wrreq => s_fifo_wrreq,
			empty => s_fifo_empty,
			full  => s_fifo_full,
			q     => s_fifo_q,
			usedw => open
		);

	p_rmap_addr_fifo_manager : process(clk_i, rst_i) is
	begin
		if (rst_i = '1') then

			s_write_state            <= IDLE;
			s_write_finished_delayed <= '0';
			s_fifo_wrreq             <= '0';
			s_fifo_wrdata            <= (others => '0');

		elsif (rising_edge(clk_i)) then

			-- default
			s_fifo_wrreq <= '0';

			case (s_write_state) is
				when IDLE =>
					if ((s_write_finished_delayed = '0') and (rmap_write_data_finished_i = '1')) then
						if ((rmap_stat_write_authorized_i = '1') and (rmap_win_area_write_flag_i = '0')) then
							if (s_fifo_full = '0') then
								s_fifo_wrdata <= rmap_last_write_addr_i(7 downto 0);
								s_fifo_wrreq  <= '1';
								s_write_state <= WR_PULSE;
							end if;
						end if;
					end if;

				when WR_PULSE =>
					-- keep one cycle gap after the write pulse
					s_write_state <= WR_GAP;

				when WR_GAP =>
					s_write_state <= IDLE;
			end case;

			s_write_finished_delayed <= rmap_write_data_finished_i;

		end if;
	end process p_rmap_addr_fifo_manager;

	fifo_empty_o <= s_fifo_empty;
	fifo_rddata_o <= s_fifo_q;

end architecture RTL;
