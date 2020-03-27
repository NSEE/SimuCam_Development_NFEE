library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.rmpe_rmap_echoing_pkg.all;

entity rmpe_rmap_echo_controller_ent is
	generic(
		g_RMAP_FIFO_OVERFLOW_EN : std_logic;
		g_FEE_CHANNEL_ID        : std_logic_vector(3 downto 0);
		g_RMAP_PACKAGE_ID       : std_logic_vector(3 downto 0)
	);
	port(
		clk_i               : in  std_logic;
		rst_i               : in  std_logic;
		echo_en_i           : in  std_logic;
		echo_id_en_i        : in  std_logic;
		spw_fifo_control_i  : in  t_rmpe_rmap_echoing_spw_fifo_control;
		rmap_fifo_control_i : in  t_rmpe_rmap_echoing_rmap_fifo_control;
		spw_fifo_status_o   : out t_rmpe_rmap_echoing_spw_fifo_status;
		rmap_fifo_status_o  : out t_rmpe_rmap_echoing_rmap_fifo_status
	);
end entity rmpe_rmap_echo_controller_ent;

architecture RTL of rmpe_rmap_echo_controller_ent is

	-- SpaceWire Data SC FIFO record
	type t_spacewire_data_sc_fifo is record
		rdreq       : std_logic;
		empty       : std_logic;
		rddata_flag : std_logic;
		rddata_data : std_logic_vector(7 downto 0);
		usedw       : std_logic_vector(12 downto 0);
	end record t_spacewire_data_sc_fifo;

	-- SpaceWire Data SC FIFO signals
	signal s_spacewire_data_sc_fifo : t_spacewire_data_sc_fifo;

	-- RMAP Data SC FIFO record
	type t_rmap_data_sc_fifo is record
		wrdata_flag : std_logic;
		wrdata_data : std_logic_vector(7 downto 0);
		wrreq       : std_logic;
		full        : std_logic;
		usedw       : std_logic_vector(4 downto 0);
	end record t_rmap_data_sc_fifo;

	-- RMAP Data SC FIFO signals
	signal s_rmap_data_sc_fifo : t_rmap_data_sc_fifo;

	-- RMAP Echo Controller FSM States enumeration
	type t_rmpe_rmap_echo_controller_fsm is (
		IDLE,                           -- in idle, waiting data in the spw data fifo
		WAITING_SPW_DATA,               -- waiting data in the spw data fifo
		FETCH_SPW_DATA,                 -- fetching data from the spw data fifo
		RMAP_TARGET_ADDR,               -- receive rmap target address
		RMAP_PROTOCOL_ID,               -- receive rmap protocol id
		WRITE_ECHO_ID,                  -- write rmap echo id
		WRITE_TARGET_ADDR,              -- write rmap target address
		WRITE_PROTOCOL_ID,              -- write rmap protocol id
		WRITE_RMAP_DATA,                -- write rmap packet data
		DISCARD_SPW_DATA                -- discard spw packet data
	);

	-- RMAP Echo Controller FSM State signals
	signal s_rmpe_rmap_echo_controller_state        : t_rmpe_rmap_echo_controller_fsm;
	signal s_rmpe_rmap_echo_controller_return_state : t_rmpe_rmap_echo_controller_fsm;

	-- RMAP constants
	constant c_RMAP_PROTOCOL_ID : std_logic_vector(7 downto 0) := x"01";

	-- RMAP data signals
	signal s_rmap_target_addr : std_logic_vector(7 downto 0);
	signal s_rmap_protocol_id : std_logic_vector(7 downto 0);

	-- SpaceWire Data SC FIFO signals
	signal s_spw_fifo_wrdata_flag   : std_logic;
	signal s_spw_fifo_wrdata_data   : std_logic_vector(7 downto 0);
	signal s_spw_fifo_wrreq         : std_logic;
	signal s_spw_fifo_overflow_flag : std_logic;

begin

	-- SpaceWire Data SC FIFO instantiation
	spacewire_data_sc_fifo_inst : entity work.spacewire_data_sc_fifo
		port map(
			aclr             => rst_i,
			clock            => clk_i,
			data(8)          => s_spw_fifo_wrdata_flag,
			data(7 downto 0) => s_spw_fifo_wrdata_data,
			rdreq            => s_spacewire_data_sc_fifo.rdreq,
			sclr             => rst_i,
			wrreq            => s_spw_fifo_wrreq,
			empty            => s_spacewire_data_sc_fifo.empty,
			full             => spw_fifo_status_o.full,
			q(8)             => s_spacewire_data_sc_fifo.rddata_flag,
			q(7 downto 0)    => s_spacewire_data_sc_fifo.rddata_data,
			usedw            => s_spacewire_data_sc_fifo.usedw
		);

	-- RMAP Data SC FIFO instantiation
	rmap_data_sc_fifo_inst : entity work.rmap_data_sc_fifo
		port map(
			aclr             => rst_i,
			clock            => clk_i,
			data(8)          => s_rmap_data_sc_fifo.wrdata_flag,
			data(7 downto 0) => s_rmap_data_sc_fifo.wrdata_data,
			rdreq            => rmap_fifo_control_i.rdreq,
			sclr             => rst_i,
			wrreq            => s_rmap_data_sc_fifo.wrreq,
			empty            => rmap_fifo_status_o.empty,
			full             => s_rmap_data_sc_fifo.full,
			q(8)             => rmap_fifo_status_o.rddata_flag,
			q(7 downto 0)    => rmap_fifo_status_o.rddata_data,
			usedw            => s_rmap_data_sc_fifo.usedw
		);

	-- RMAP Echo Controller process
	p_rmpe_rmap_echo_controller : process(clk_i, rst_i) is
	begin
		if (rst_i = '1') then
			-- fsm state reset
			s_rmpe_rmap_echo_controller_state        <= IDLE;
			s_rmpe_rmap_echo_controller_return_state <= IDLE;
			-- internal signals reset
			s_spacewire_data_sc_fifo.rdreq           <= '0';
			s_rmap_data_sc_fifo.wrdata_flag          <= '0';
			s_rmap_data_sc_fifo.wrdata_data          <= (others => '0');
			s_rmap_data_sc_fifo.wrreq                <= '0';
			s_rmap_target_addr                       <= (others => '0');
			s_rmap_protocol_id                       <= (others => '0');
			s_spw_fifo_wrdata_flag                   <= '0';
			s_spw_fifo_wrdata_data                   <= (others => '0');
			s_spw_fifo_wrreq                         <= '0';
			s_spw_fifo_overflow_flag                 <= '0';
		-- outputs reset
		elsif (rising_edge(clk_i)) then

			-- SpaceWire Data SC FIFO Write Manager
			-- standart signals value
			s_spw_fifo_wrdata_flag <= '0';
			s_spw_fifo_wrdata_data <= (others => '0');
			s_spw_fifo_wrreq       <= '0';
			-- check if a write was requested and the echo is enabled
			if ((spw_fifo_control_i.wrreq = '1') and (echo_en_i = '1')) then
				-- a write was requested and the echo is enabled
				-- check if the data is an end of package
				if (spw_fifo_control_i.wrdata_flag = '1') then
					-- the data is an end of package
					-- check if an overflow occured previously
					if (s_spw_fifo_overflow_flag = '1') then
						-- an overflow occured previously
						-- write an eep in the buffer
						s_spw_fifo_wrdata_flag   <= '1';
						s_spw_fifo_wrdata_data   <= x"01";
						s_spw_fifo_wrreq         <= '1';
						s_spw_fifo_overflow_flag <= '0';
					else
						-- an overflow has not occured
						-- write the original end of package
						s_spw_fifo_wrdata_flag   <= '1';
						s_spw_fifo_wrdata_data   <= spw_fifo_control_i.wrdata_data;
						s_spw_fifo_wrreq         <= '1';
						s_spw_fifo_overflow_flag <= '0';
					end if;
				else
					-- the data is not an end of package
					-- check if there is space in the spw data fifo
					if (unsigned(s_spacewire_data_sc_fifo.usedw) < ((2**s_spacewire_data_sc_fifo.usedw'length - 1) - 2)) then
						-- there is space in the spw data fifo
						-- write data in the fifo
						s_spw_fifo_wrdata_flag <= '0';
						s_spw_fifo_wrdata_data <= spw_fifo_control_i.wrdata_data;
						s_spw_fifo_wrreq       <= '1';
					else
						-- there is no more space in the spw data fifo
						-- set the overflow flag
						s_spw_fifo_overflow_flag <= '1';
					end if;
				end if;
			end if;

			-- States transitions FSM
			case (s_rmpe_rmap_echo_controller_state) is

				-- state "IDLE"
				when IDLE =>
					-- in idle, waiting data in the spw data fifo
					-- default state transition
					s_rmpe_rmap_echo_controller_state        <= IDLE;
					s_rmpe_rmap_echo_controller_return_state <= IDLE;
					-- default internal signal values
					s_spacewire_data_sc_fifo.rdreq           <= '0';
					s_rmap_data_sc_fifo.wrdata_flag          <= '0';
					s_rmap_data_sc_fifo.wrdata_data          <= (others => '0');
					s_rmap_data_sc_fifo.wrreq                <= '0';
					s_rmap_target_addr                       <= (others => '0');
					s_rmap_protocol_id                       <= (others => '0');
					-- conditional state transition
					-- check if there is data in the spw data fifo
					if (s_spacewire_data_sc_fifo.empty = '0') then
						-- there is data in the spw data fifo
						-- fetch data from spw fifo
						s_spacewire_data_sc_fifo.rdreq           <= '1';
						s_rmpe_rmap_echo_controller_state        <= FETCH_SPW_DATA;
						s_rmpe_rmap_echo_controller_return_state <= RMAP_TARGET_ADDR;
					end if;

				-- state "WAITING_SPW_DATA"
				when WAITING_SPW_DATA =>
					-- waiting data in the spw data fifo
					-- default state transition
					s_rmpe_rmap_echo_controller_state <= WAITING_SPW_DATA;
					-- default internal signal values
					s_spacewire_data_sc_fifo.rdreq    <= '0';
					s_rmap_data_sc_fifo.wrdata_flag   <= '0';
					s_rmap_data_sc_fifo.wrdata_data   <= (others => '0');
					s_rmap_data_sc_fifo.wrreq         <= '0';
					-- conditional state transition
					-- check if there is data in the spw data fifo
					if (s_spacewire_data_sc_fifo.empty = '0') then
						-- there is data in the spw data fifo
						-- fetch data from spw fifo
						s_spacewire_data_sc_fifo.rdreq    <= '1';
						s_rmpe_rmap_echo_controller_state <= FETCH_SPW_DATA;
					end if;

				-- state "FETCH_SPW_DATA"
				when FETCH_SPW_DATA =>
					-- fetching data from the spw data fifo
					-- default state transition
					s_rmpe_rmap_echo_controller_state <= s_rmpe_rmap_echo_controller_return_state;
					-- default internal signal values
					s_spacewire_data_sc_fifo.rdreq    <= '0';
					s_rmap_data_sc_fifo.wrdata_flag   <= '0';
					s_rmap_data_sc_fifo.wrdata_data   <= (others => '0');
					s_rmap_data_sc_fifo.wrreq         <= '0';
				-- conditional state transition

				-- state "RMAP_TARGET_ADDR"
				when RMAP_TARGET_ADDR =>
					-- receive rmap target address
					-- default state transition
					s_rmpe_rmap_echo_controller_state <= RMAP_TARGET_ADDR;
					-- default internal signal values
					s_spacewire_data_sc_fifo.rdreq    <= '0';
					s_rmap_data_sc_fifo.wrdata_flag   <= '0';
					s_rmap_data_sc_fifo.wrdata_data   <= (others => '0');
					s_rmap_data_sc_fifo.wrreq         <= '0';
					-- conditional state transition
					-- check if an end of packet was received
					if (s_spacewire_data_sc_fifo.rddata_flag = '1') then
						-- end of packet received, return to idle
						s_rmpe_rmap_echo_controller_state        <= IDLE;
						s_rmpe_rmap_echo_controller_return_state <= IDLE;
					else
						-- data received, go to rmap protocol id
						s_rmap_target_addr                       <= s_spacewire_data_sc_fifo.rddata_data;
						s_rmpe_rmap_echo_controller_state        <= WAITING_SPW_DATA;
						s_rmpe_rmap_echo_controller_return_state <= RMAP_PROTOCOL_ID;
					end if;

				-- state "RMAP_PROTOCOL_ID"
				when RMAP_PROTOCOL_ID =>
					-- receive rmap protocol id
					-- default state transition
					s_rmpe_rmap_echo_controller_state <= RMAP_PROTOCOL_ID;
					-- default internal signal values
					s_spacewire_data_sc_fifo.rdreq    <= '0';
					s_rmap_data_sc_fifo.wrdata_flag   <= '0';
					s_rmap_data_sc_fifo.wrdata_data   <= (others => '0');
					s_rmap_data_sc_fifo.wrreq         <= '0';
					-- conditional state transition
					-- check if an end of packet was received
					if (s_spacewire_data_sc_fifo.rddata_flag = '1') then
						-- end of packet received, return to idle
						s_rmpe_rmap_echo_controller_state        <= IDLE;
						s_rmpe_rmap_echo_controller_return_state <= IDLE;
					else
						-- data received, check if the protocol id is valid
						s_rmap_protocol_id <= s_spacewire_data_sc_fifo.rddata_data;
						if (s_spacewire_data_sc_fifo.rddata_data = c_RMAP_PROTOCOL_ID) then
							-- protocol id is valid,
							-- check if an echo id must be added
							if (echo_id_en_i = '1') then
								-- echo id must be added, go to write echo id
								s_rmpe_rmap_echo_controller_state        <= WRITE_ECHO_ID;
								s_rmpe_rmap_echo_controller_return_state <= WRITE_ECHO_ID;
							else
								-- no need for an echo id, go to write target addr
								s_rmpe_rmap_echo_controller_state        <= WRITE_TARGET_ADDR;
								s_rmpe_rmap_echo_controller_return_state <= WRITE_TARGET_ADDR;
							end if;
						else
							-- protocol id is not valid, go to discard spw data
							s_rmpe_rmap_echo_controller_state        <= WAITING_SPW_DATA;
							s_rmpe_rmap_echo_controller_return_state <= DISCARD_SPW_DATA;
						end if;
					end if;

				-- state "WRITE_ECHO_ID"
				when WRITE_ECHO_ID =>
					-- write rmap echo id
					-- default state transition
					s_rmpe_rmap_echo_controller_state <= WRITE_ECHO_ID;
					-- default internal signal values
					s_spacewire_data_sc_fifo.rdreq    <= '0';
					s_rmap_data_sc_fifo.wrdata_flag   <= '0';
					s_rmap_data_sc_fifo.wrdata_data   <= (others => '0');
					s_rmap_data_sc_fifo.wrreq         <= '0';
					-- conditional state transition
					-- check if the rmap data fifo can receive data or if the overflow is enabled
					if ((s_rmap_data_sc_fifo.full = '0') or (g_RMAP_FIFO_OVERFLOW_EN = '1')) then
						-- rmap data fifo can receive data, write echo id
						s_rmap_data_sc_fifo.wrdata_flag             <= '0';
						s_rmap_data_sc_fifo.wrdata_data(7 downto 4) <= g_RMAP_PACKAGE_ID;
						s_rmap_data_sc_fifo.wrdata_data(3 downto 0) <= g_FEE_CHANNEL_ID;
						s_rmap_data_sc_fifo.wrreq                   <= '1';
						-- go to write target address
						s_rmpe_rmap_echo_controller_state           <= WRITE_TARGET_ADDR;
						s_rmpe_rmap_echo_controller_return_state    <= WRITE_TARGET_ADDR;
					end if;

				-- state "WRITE_TARGET_ADDR"
				when WRITE_TARGET_ADDR =>
					-- write rmap target address
					-- default state transition
					s_rmpe_rmap_echo_controller_state <= WRITE_TARGET_ADDR;
					-- default internal signal values
					s_spacewire_data_sc_fifo.rdreq    <= '0';
					s_rmap_data_sc_fifo.wrdata_flag   <= '0';
					s_rmap_data_sc_fifo.wrdata_data   <= (others => '0');
					s_rmap_data_sc_fifo.wrreq         <= '0';
					-- conditional state transition
					-- check if the rmap data fifo can receive data or if the overflow is enabled
					if ((s_rmap_data_sc_fifo.full = '0') or (g_RMAP_FIFO_OVERFLOW_EN = '1')) then
						-- rmap data fifo can receive data, write target address
						s_rmap_data_sc_fifo.wrdata_flag          <= '0';
						s_rmap_data_sc_fifo.wrdata_data          <= s_rmap_target_addr;
						s_rmap_data_sc_fifo.wrreq                <= '1';
						-- go to write target address
						s_rmpe_rmap_echo_controller_state        <= WRITE_PROTOCOL_ID;
						s_rmpe_rmap_echo_controller_return_state <= WRITE_PROTOCOL_ID;
					end if;

				-- state "WRITE_PROTOCOL_ID"
				when WRITE_PROTOCOL_ID =>
					-- write rmap protocol id
					-- default state transition
					s_rmpe_rmap_echo_controller_state <= WRITE_PROTOCOL_ID;
					-- default internal signal values
					s_spacewire_data_sc_fifo.rdreq    <= '0';
					s_rmap_data_sc_fifo.wrdata_flag   <= '0';
					s_rmap_data_sc_fifo.wrdata_data   <= (others => '0');
					s_rmap_data_sc_fifo.wrreq         <= '0';
					-- conditional state transition
					-- check if the rmap data fifo can receive data or if the overflow is enabled
					if ((s_rmap_data_sc_fifo.full = '0') or (g_RMAP_FIFO_OVERFLOW_EN = '1')) then
						-- rmap data fifo can receive data, write protocol id
						s_rmap_data_sc_fifo.wrdata_flag          <= '0';
						s_rmap_data_sc_fifo.wrdata_data          <= s_rmap_protocol_id;
						s_rmap_data_sc_fifo.wrreq                <= '1';
						-- go to waiting spw data, to return to write rmap data
						s_rmpe_rmap_echo_controller_state        <= WAITING_SPW_DATA;
						s_rmpe_rmap_echo_controller_return_state <= WRITE_RMAP_DATA;
					end if;

				-- state "WRITE_RMAP_DATA"
				when WRITE_RMAP_DATA =>
					-- write rmap packet data
					-- default state transition
					s_rmpe_rmap_echo_controller_state <= WRITE_RMAP_DATA;
					-- default internal signal values
					s_spacewire_data_sc_fifo.rdreq    <= '0';
					s_rmap_data_sc_fifo.wrdata_flag   <= '0';
					s_rmap_data_sc_fifo.wrdata_data   <= (others => '0');
					s_rmap_data_sc_fifo.wrreq         <= '0';
					-- conditional state transition
					-- check if the rmap data fifo can receive data or if the overflow is enabled
					if ((s_rmap_data_sc_fifo.full = '0') or (g_RMAP_FIFO_OVERFLOW_EN = '1')) then
						-- rmap data fifo can receive data, write rmap data
						s_rmap_data_sc_fifo.wrdata_flag <= s_spacewire_data_sc_fifo.rddata_flag;
						s_rmap_data_sc_fifo.wrdata_data <= s_spacewire_data_sc_fifo.rddata_data;
						s_rmap_data_sc_fifo.wrreq       <= '1';
						-- check if a end of package was received
						if (s_spacewire_data_sc_fifo.rddata_flag = '1') then
							-- a end of package was received
							-- return to idle
							s_rmpe_rmap_echo_controller_state        <= IDLE;
							s_rmpe_rmap_echo_controller_return_state <= IDLE;
						else
							-- data was received
							-- go to waiting spw data, to return to write rmap data
							s_rmpe_rmap_echo_controller_state        <= WAITING_SPW_DATA;
							s_rmpe_rmap_echo_controller_return_state <= WRITE_RMAP_DATA;
						end if;
					end if;

				-- state "DISCARD_SPW_DATA"
				when DISCARD_SPW_DATA =>
					-- discard spw packet data
					-- default state transition
					s_rmpe_rmap_echo_controller_state        <= WAITING_SPW_DATA;
					s_rmpe_rmap_echo_controller_return_state <= DISCARD_SPW_DATA;
					-- default internal signal values
					s_spacewire_data_sc_fifo.rdreq           <= '0';
					s_rmap_data_sc_fifo.wrdata_flag          <= '0';
					s_rmap_data_sc_fifo.wrdata_data          <= (others => '0');
					s_rmap_data_sc_fifo.wrreq                <= '0';
					s_rmap_target_addr                       <= (others => '0');
					s_rmap_protocol_id                       <= (others => '0');
					-- conditional state transition
					-- check if a end of package was received
					if (s_spacewire_data_sc_fifo.rddata_flag = '1') then
						-- a end of package was received
						-- return to idle
						s_rmpe_rmap_echo_controller_state        <= IDLE;
						s_rmpe_rmap_echo_controller_return_state <= IDLE;
					end if;

				-- all the other states (not defined)
				when others =>
					s_rmpe_rmap_echo_controller_state        <= IDLE;
					s_rmpe_rmap_echo_controller_return_state <= IDLE;

			end case;

		end if;
	end process p_rmpe_rmap_echo_controller;

end architecture RTL;
