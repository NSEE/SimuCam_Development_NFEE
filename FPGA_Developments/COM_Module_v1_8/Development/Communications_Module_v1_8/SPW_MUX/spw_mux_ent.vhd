library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.spw_codec_pkg.all;

entity spw_mux_ent is
	port(
		clk_i                  : in  std_logic;
		rst_i                  : in  std_logic;
		fee_clear_signal_i     : in  std_logic;
		fee_stop_signal_i      : in  std_logic;
		fee_start_signal_i     : in  std_logic;
		spw_codec_rx_status_i  : in  t_spw_codec_data_rx_status;
		spw_codec_tx_status_i  : in  t_spw_codec_data_tx_status;
		spw_mux_rx_0_command_i : in  t_spw_codec_data_rx_command;
		spw_mux_tx_0_command_i : in  t_spw_codec_data_tx_command;
		spw_mux_tx_1_command_i : in  t_spw_codec_data_tx_command;
		spw_mux_tx_2_command_i : in  t_spw_codec_data_tx_command;
		spw_codec_rx_command_o : out t_spw_codec_data_rx_command;
		spw_codec_tx_command_o : out t_spw_codec_data_tx_command;
		spw_mux_rx_0_status_o  : out t_spw_codec_data_rx_status;
		spw_mux_tx_0_status_o  : out t_spw_codec_data_tx_status;
		spw_mux_tx_1_status_o  : out t_spw_codec_data_tx_status;
		spw_mux_tx_2_status_o  : out t_spw_codec_data_tx_status
	);
end entity spw_mux_ent;

architecture RTL of spw_mux_ent is

	constant c_SPW_RESET_RX_COMMAND : t_spw_codec_data_rx_command := (
		rxread => '0'
	);
	constant c_SPW_RESET_TX_COMMAND : t_spw_codec_data_tx_command := (
		txwrite => '0',
		txflag  => '0',
		txdata  => (others => '0')
	);
	constant c_SPW_RESET_RX_STATUS  : t_spw_codec_data_rx_status  := (
		rxvalid => '0',
		rxhalff => '0',
		rxflag  => '0',
		rxdata  => (others => '0')
	);
	constant c_SPW_RESET_TX_STATUS  : t_spw_codec_data_tx_status  := (
		txrdy   => '0',
		txhalff => '0'
	);

	signal s_mux_rx_selection : natural range 0 to 7 := 0;
	signal s_mux_tx_selection : natural range 0 to 7 := 7;

	type t_spw_mux_fsm is (
		STOPPED,
		IDLE,
		SPW_TX_0_NOT_READY,
		SPW_TX_0_WAITING_EOP,
		SPW_TX_1_NOT_READY,
		SPW_TX_1_WAITING_EOP,
		SPW_TX_2_NOT_READY,
		SPW_TX_2_WAITING_EOP
	);

	signal s_spw_mux_state : t_spw_mux_fsm;

	type t_tx_flag_buffer is array (0 to 2) of std_logic;
	type t_tx_data_buffer is array (0 to 2) of std_logic_vector(7 downto 0);
	type t_tx_pending_write is array (0 to 2) of std_logic;
	type t_tx_channel_lock is array (0 to 2) of std_logic;

	type t_tx_channel_queue is array (0 to 2) of natural range 0 to 7;

	signal s_tx_flag_buffer   : t_tx_flag_buffer;
	signal s_tx_data_buffer   : t_tx_data_buffer;
	signal s_tx_pending_write : t_tx_pending_write;
	signal s_tx_channel_lock  : t_tx_channel_lock;

	signal s_spw_tx_fsm_command : t_spw_codec_data_tx_command;

begin

	p_spw_mux : process(clk_i, rst_i) is
		variable v_tx_channel_queue : t_tx_channel_queue := (others => 7);
	begin
		if (rst_i = '1') then
			s_mux_rx_selection   <= 0;
			s_mux_tx_selection   <= 7;
			s_spw_tx_fsm_command <= c_SPW_RESET_TX_COMMAND;

			s_spw_mux_state <= STOPPED;

			s_tx_flag_buffer   <= (others => '0');
			s_tx_data_buffer   <= (others => x"00");
			s_tx_pending_write <= (others => '0');
			s_tx_channel_lock  <= (others => '0');

			v_tx_channel_queue(0) := 7;
			v_tx_channel_queue(1) := 7;
			v_tx_channel_queue(2) := 7;

		elsif rising_edge(clk_i) then

			s_mux_rx_selection <= 0;

			if ((spw_mux_tx_0_command_i.txwrite = '1') and (s_mux_tx_selection /= 0) and (s_tx_channel_lock(0) = '0')) then
				s_tx_flag_buffer(0)   <= spw_mux_tx_0_command_i.txflag;
				s_tx_data_buffer(0)   <= spw_mux_tx_0_command_i.txdata;
				s_tx_pending_write(0) <= '1';
				s_tx_channel_lock(0)  <= '1';
				if not ((v_tx_channel_queue(1) = 0) or (v_tx_channel_queue(2) = 0)) then
					v_tx_channel_queue(0) := 0;
				elsif not ((v_tx_channel_queue(1) = 1) or (v_tx_channel_queue(2) = 1)) then
					v_tx_channel_queue(0) := 1;
				else
					v_tx_channel_queue(0) := 2;
				end if;
			end if;

			if ((spw_mux_tx_1_command_i.txwrite = '1') and (s_mux_tx_selection /= 1) and (s_tx_channel_lock(1) = '0')) then
				s_tx_flag_buffer(1)   <= spw_mux_tx_1_command_i.txflag;
				s_tx_data_buffer(1)   <= spw_mux_tx_1_command_i.txdata;
				s_tx_pending_write(1) <= '1';
				s_tx_channel_lock(1)  <= '1';
				if not ((v_tx_channel_queue(0) = 0) or (v_tx_channel_queue(2) = 0)) then
					v_tx_channel_queue(1) := 0;
				elsif not ((v_tx_channel_queue(0) = 1) or (v_tx_channel_queue(2) = 1)) then
					v_tx_channel_queue(1) := 1;
				else
					v_tx_channel_queue(1) := 2;
				end if;
			end if;

			if ((spw_mux_tx_2_command_i.txwrite = '1') and (s_mux_tx_selection /= 2) and (s_tx_channel_lock(2) = '0')) then
				s_tx_flag_buffer(2)   <= spw_mux_tx_2_command_i.txflag;
				s_tx_data_buffer(2)   <= spw_mux_tx_2_command_i.txdata;
				s_tx_pending_write(2) <= '1';
				s_tx_channel_lock(2)  <= '1';
				if not ((v_tx_channel_queue(0) = 0) or (v_tx_channel_queue(1) = 0)) then
					v_tx_channel_queue(2) := 0;
				elsif not ((v_tx_channel_queue(0) = 1) or (v_tx_channel_queue(1) = 1)) then
					v_tx_channel_queue(2) := 1;
				else
					v_tx_channel_queue(2) := 2;
				end if;
			end if;

			case (s_spw_mux_state) is

				when STOPPED =>
					-- stopped state. do nothing and reset
					s_mux_rx_selection   <= 0;
					s_mux_tx_selection   <= 7;
					s_spw_tx_fsm_command <= c_SPW_RESET_TX_COMMAND;

					s_spw_mux_state <= STOPPED;

					s_tx_flag_buffer   <= (others => '0');
					s_tx_data_buffer   <= (others => x"00");
					s_tx_pending_write <= (others => '0');
					s_tx_channel_lock  <= (others => '0');

					v_tx_channel_queue(0) := 7;
					v_tx_channel_queue(1) := 7;
					v_tx_channel_queue(2) := 7;
					-- check if a start was issued
					if (fee_start_signal_i = '1') then
						-- start issued, go to idle
						s_spw_mux_state <= IDLE;
					end if;

				when IDLE =>
					-- availabe to all spw tx channels
					-- check if the spw tx ch 0 requested a write and is first in queue
					if ((s_tx_pending_write(0) = '1') and (v_tx_channel_queue(0) = 0)) then
						s_tx_channel_lock(0) <= '1';
						s_mux_tx_selection   <= 7;
						if (spw_codec_tx_status_i.txrdy = '1') then
							s_spw_tx_fsm_command.txwrite <= '1';
							s_spw_tx_fsm_command.txflag  <= s_tx_flag_buffer(0);
							s_spw_tx_fsm_command.txdata  <= s_tx_data_buffer(0);
							s_spw_mux_state              <= SPW_TX_0_WAITING_EOP;
						else
							s_spw_tx_fsm_command.txwrite <= '0';
							s_spw_tx_fsm_command.txflag  <= '0';
							s_spw_tx_fsm_command.txdata  <= x"00";
							s_spw_mux_state              <= SPW_TX_0_NOT_READY;
						end if;
					-- check if the spw tx ch 1 requested a write and is first in queue
					elsif ((s_tx_pending_write(1) = '1') and (v_tx_channel_queue(1) = 0)) then
						s_tx_channel_lock(1) <= '1';
						s_mux_tx_selection   <= 7;
						if (spw_codec_tx_status_i.txrdy = '1') then
							s_spw_tx_fsm_command.txwrite <= '1';
							s_spw_tx_fsm_command.txflag  <= s_tx_flag_buffer(1);
							s_spw_tx_fsm_command.txdata  <= s_tx_data_buffer(1);
							s_spw_mux_state              <= SPW_TX_1_WAITING_EOP;
						else
							s_spw_tx_fsm_command.txwrite <= '0';
							s_spw_tx_fsm_command.txflag  <= '0';
							s_spw_tx_fsm_command.txdata  <= x"00";
							s_spw_mux_state              <= SPW_TX_1_NOT_READY;
						end if;
					-- check if the spw tx ch 2 requested a write and is first in queue
					elsif ((s_tx_pending_write(2) = '1') and (v_tx_channel_queue(2) = 0)) then
						s_tx_channel_lock(2) <= '1';
						s_mux_tx_selection   <= 7;
						if (spw_codec_tx_status_i.txrdy = '1') then
							s_spw_tx_fsm_command.txwrite <= '1';
							s_spw_tx_fsm_command.txflag  <= s_tx_flag_buffer(2);
							s_spw_tx_fsm_command.txdata  <= s_tx_data_buffer(2);
							s_spw_mux_state              <= SPW_TX_2_WAITING_EOP;
						else
							s_spw_tx_fsm_command.txwrite <= '0';
							s_spw_tx_fsm_command.txflag  <= '0';
							s_spw_tx_fsm_command.txdata  <= x"00";
							s_spw_mux_state              <= SPW_TX_2_NOT_READY;
						end if;
					end if;

				when SPW_TX_0_NOT_READY =>
					s_tx_channel_lock(0) <= '1';
					s_mux_tx_selection   <= 7;
					if (spw_codec_tx_status_i.txrdy = '1') then
						s_spw_tx_fsm_command.txwrite <= '1';
						s_spw_tx_fsm_command.txflag  <= s_tx_flag_buffer(0);
						s_spw_tx_fsm_command.txdata  <= s_tx_data_buffer(0);
						s_spw_mux_state              <= SPW_TX_0_WAITING_EOP;
					else
						s_spw_tx_fsm_command.txwrite <= '0';
						s_spw_tx_fsm_command.txflag  <= '0';
						s_spw_tx_fsm_command.txdata  <= x"00";
						s_spw_mux_state              <= SPW_TX_0_NOT_READY;
					end if;

				when SPW_TX_0_WAITING_EOP =>
					-- lock spw tx ch 0 until an end of package
					s_spw_mux_state              <= SPW_TX_0_WAITING_EOP;
					s_tx_channel_lock(0)         <= '0';
					s_tx_pending_write(0)        <= '0';
					s_spw_tx_fsm_command.txwrite <= '0';
					s_spw_tx_fsm_command.txflag  <= '0';
					s_spw_tx_fsm_command.txdata  <= x"00";
					s_mux_tx_selection           <= 0;
					if (v_tx_channel_queue(0) < 7) then
						v_tx_channel_queue(0) := 7;
						if (v_tx_channel_queue(1) < 7) then
							v_tx_channel_queue(1) := v_tx_channel_queue(1) - 1;
						end if;
						if (v_tx_channel_queue(2) < 7) then
							v_tx_channel_queue(2) := v_tx_channel_queue(2) - 1;
						end if;
					end if;
					-- check if a end of package ocurred
					if ((spw_mux_tx_0_command_i.txflag = '1') and ((spw_mux_tx_0_command_i.txdata = x"00") or (spw_mux_tx_0_command_i.txdata = x"01"))) then
						-- end of package ocurred
						-- check if a request to use the spw tx ch 1 was issued and it is first in the queue
						if ((s_tx_pending_write(1) = '1') and (v_tx_channel_queue(1) = 0)) then
							-- request to use the spw tx ch 1 was issued
							s_tx_channel_lock(1) <= '1';
							s_mux_tx_selection   <= 7;
							if (spw_codec_tx_status_i.txrdy = '1') then
								s_spw_tx_fsm_command.txwrite <= '1';
								s_spw_tx_fsm_command.txflag  <= s_tx_flag_buffer(1);
								s_spw_tx_fsm_command.txdata  <= s_tx_data_buffer(1);
								s_spw_mux_state              <= SPW_TX_1_WAITING_EOP;
							else
								s_spw_tx_fsm_command.txwrite <= '0';
								s_spw_tx_fsm_command.txflag  <= '0';
								s_spw_tx_fsm_command.txdata  <= x"00";
								s_spw_mux_state              <= SPW_TX_1_NOT_READY;
							end if;
						-- check if a request to use the spw tx ch 2 was issued and it is first in the queue
						elsif ((s_tx_pending_write(2) = '1') and (v_tx_channel_queue(2) = 0)) then
							-- request to use the spw tx ch 2 was issued
							s_tx_channel_lock(2) <= '1';
							s_mux_tx_selection   <= 7;
							if (spw_codec_tx_status_i.txrdy = '1') then
								s_spw_tx_fsm_command.txwrite <= '1';
								s_spw_tx_fsm_command.txflag  <= s_tx_flag_buffer(2);
								s_spw_tx_fsm_command.txdata  <= s_tx_data_buffer(2);
								s_spw_mux_state              <= SPW_TX_2_WAITING_EOP;
							else
								s_spw_tx_fsm_command.txwrite <= '0';
								s_spw_tx_fsm_command.txflag  <= '0';
								s_spw_tx_fsm_command.txdata  <= x"00";
								s_spw_mux_state              <= SPW_TX_2_NOT_READY;
							end if;
						else
							-- no pending requests
							-- return to idle state
							s_spw_tx_fsm_command.txwrite <= '0';
							s_spw_tx_fsm_command.txflag  <= '0';
							s_spw_tx_fsm_command.txdata  <= x"00";
							s_mux_tx_selection           <= 7;
							s_spw_mux_state              <= IDLE;
						end if;
					end if;

				when SPW_TX_1_NOT_READY =>
					s_tx_channel_lock(1) <= '1';
					s_mux_tx_selection   <= 7;
					if (spw_codec_tx_status_i.txrdy = '1') then
						s_spw_tx_fsm_command.txwrite <= '1';
						s_spw_tx_fsm_command.txflag  <= s_tx_flag_buffer(1);
						s_spw_tx_fsm_command.txdata  <= s_tx_data_buffer(1);
						s_spw_mux_state              <= SPW_TX_1_WAITING_EOP;
					else
						s_spw_tx_fsm_command.txwrite <= '0';
						s_spw_tx_fsm_command.txflag  <= '0';
						s_spw_tx_fsm_command.txdata  <= x"00";
						s_spw_mux_state              <= SPW_TX_1_NOT_READY;
					end if;

				when SPW_TX_1_WAITING_EOP =>
					-- lock spw tx ch 1 until an end of package
					s_spw_mux_state              <= SPW_TX_1_WAITING_EOP;
					s_tx_channel_lock(1)         <= '0';
					s_tx_pending_write(1)        <= '0';
					s_spw_tx_fsm_command.txwrite <= '0';
					s_spw_tx_fsm_command.txflag  <= '0';
					s_spw_tx_fsm_command.txdata  <= x"00";
					s_mux_tx_selection           <= 1;
					if (v_tx_channel_queue(1) < 7) then
						v_tx_channel_queue(1) := 7;
						if (v_tx_channel_queue(0) < 7) then
							v_tx_channel_queue(0) := v_tx_channel_queue(0) - 1;
						end if;
						if (v_tx_channel_queue(2) < 7) then
							v_tx_channel_queue(2) := v_tx_channel_queue(2) - 1;
						end if;
					end if;
					-- check if a end of package ocurred
					if ((spw_mux_tx_1_command_i.txflag = '1') and ((spw_mux_tx_1_command_i.txdata = x"00") or (spw_mux_tx_1_command_i.txdata = x"01"))) then
						-- end of package ocurred
						-- check if a request to use the spw tx ch 0 was issued and it is first in the queue
						if ((s_tx_pending_write(0) = '1') and (v_tx_channel_queue(0) = 0)) then
							-- request to use the spw tx ch 0 was issued
							s_tx_channel_lock(0) <= '1';
							s_mux_tx_selection   <= 7;
							if (spw_codec_tx_status_i.txrdy = '1') then
								s_spw_tx_fsm_command.txwrite <= '1';
								s_spw_tx_fsm_command.txflag  <= s_tx_flag_buffer(0);
								s_spw_tx_fsm_command.txdata  <= s_tx_data_buffer(0);
								s_spw_mux_state              <= SPW_TX_0_WAITING_EOP;
							else
								s_spw_tx_fsm_command.txwrite <= '0';
								s_spw_tx_fsm_command.txflag  <= '0';
								s_spw_tx_fsm_command.txdata  <= x"00";
								s_spw_mux_state              <= SPW_TX_0_NOT_READY;
							end if;
						-- check if a request to use the spw tx ch 2 was issued and it is first in the queue
						elsif ((s_tx_pending_write(2) = '1') and (v_tx_channel_queue(2) = 0)) then
							-- request to use the spw tx ch 2 was issued
							s_tx_channel_lock(2) <= '1';
							s_mux_tx_selection   <= 7;
							if (spw_codec_tx_status_i.txrdy = '1') then
								s_spw_tx_fsm_command.txwrite <= '1';
								s_spw_tx_fsm_command.txflag  <= s_tx_flag_buffer(2);
								s_spw_tx_fsm_command.txdata  <= s_tx_data_buffer(2);
								s_spw_mux_state              <= SPW_TX_2_WAITING_EOP;
							else
								s_spw_tx_fsm_command.txwrite <= '0';
								s_spw_tx_fsm_command.txflag  <= '0';
								s_spw_tx_fsm_command.txdata  <= x"00";
								s_spw_mux_state              <= SPW_TX_2_NOT_READY;
							end if;
						else
							-- no pending requests
							-- return to idle state
							s_spw_tx_fsm_command.txwrite <= '0';
							s_spw_tx_fsm_command.txflag  <= '0';
							s_spw_tx_fsm_command.txdata  <= x"00";
							s_mux_tx_selection           <= 7;
							s_spw_mux_state              <= IDLE;
						end if;
					end if;

				when SPW_TX_2_NOT_READY =>
					s_tx_channel_lock(2) <= '1';
					s_mux_tx_selection   <= 7;
					if (spw_codec_tx_status_i.txrdy = '1') then
						s_spw_tx_fsm_command.txwrite <= '1';
						s_spw_tx_fsm_command.txflag  <= s_tx_flag_buffer(2);
						s_spw_tx_fsm_command.txdata  <= s_tx_data_buffer(2);
						s_spw_mux_state              <= SPW_TX_2_WAITING_EOP;
					else
						s_spw_tx_fsm_command.txwrite <= '0';
						s_spw_tx_fsm_command.txflag  <= '0';
						s_spw_tx_fsm_command.txdata  <= x"00";
						s_spw_mux_state              <= SPW_TX_2_NOT_READY;
					end if;

				when SPW_TX_2_WAITING_EOP =>
					-- lock spw tx ch 2 until an end of package
					s_spw_mux_state              <= SPW_TX_2_WAITING_EOP;
					s_tx_channel_lock(2)         <= '0';
					s_tx_pending_write(2)        <= '0';
					s_spw_tx_fsm_command.txwrite <= '0';
					s_spw_tx_fsm_command.txflag  <= '0';
					s_spw_tx_fsm_command.txdata  <= x"00";
					s_mux_tx_selection           <= 2;
					if (v_tx_channel_queue(2) < 7) then
						v_tx_channel_queue(2) := 7;
						if (v_tx_channel_queue(0) < 7) then
							v_tx_channel_queue(0) := v_tx_channel_queue(0) - 1;
						end if;
						if (v_tx_channel_queue(1) < 7) then
							v_tx_channel_queue(1) := v_tx_channel_queue(1) - 1;
						end if;
					end if;
					-- check if a end of package ocurred
					if ((spw_mux_tx_2_command_i.txflag = '1') and ((spw_mux_tx_2_command_i.txdata = x"00") or (spw_mux_tx_2_command_i.txdata = x"01"))) then
						-- end of package ocurred
						-- check if a request to use the spw tx ch 0 was issued and it is first in the queue
						if ((s_tx_pending_write(0) = '1') and (v_tx_channel_queue(0) = 0)) then
							-- request to use the spw tx ch 0 was issued
							s_tx_channel_lock(0) <= '1';
							s_mux_tx_selection   <= 7;
							if (spw_codec_tx_status_i.txrdy = '1') then
								s_spw_tx_fsm_command.txwrite <= '1';
								s_spw_tx_fsm_command.txflag  <= s_tx_flag_buffer(0);
								s_spw_tx_fsm_command.txdata  <= s_tx_data_buffer(0);
								s_spw_mux_state              <= SPW_TX_0_WAITING_EOP;
							else
								s_spw_tx_fsm_command.txwrite <= '0';
								s_spw_tx_fsm_command.txflag  <= '0';
								s_spw_tx_fsm_command.txdata  <= x"00";
								s_spw_mux_state              <= SPW_TX_0_NOT_READY;
							end if;
						-- check if a request to use the spw tx ch 1 was issued and it is first in the queue
						elsif ((s_tx_pending_write(1) = '1') and (v_tx_channel_queue(1) = 0)) then
							-- request to use the spw tx ch 1 was issued
							s_tx_channel_lock(1) <= '1';
							s_mux_tx_selection   <= 7;
							if (spw_codec_tx_status_i.txrdy = '1') then
								s_spw_tx_fsm_command.txwrite <= '1';
								s_spw_tx_fsm_command.txflag  <= s_tx_flag_buffer(1);
								s_spw_tx_fsm_command.txdata  <= s_tx_data_buffer(1);
								s_spw_mux_state              <= SPW_TX_1_WAITING_EOP;
							else
								s_spw_tx_fsm_command.txwrite <= '0';
								s_spw_tx_fsm_command.txflag  <= '0';
								s_spw_tx_fsm_command.txdata  <= x"00";
								s_spw_mux_state              <= SPW_TX_1_NOT_READY;
							end if;
						else
							-- no pending requests
							-- return to idle state
							s_spw_tx_fsm_command.txwrite <= '0';
							s_spw_tx_fsm_command.txflag  <= '0';
							s_spw_tx_fsm_command.txdata  <= x"00";
							s_mux_tx_selection           <= 7;
							s_spw_mux_state              <= IDLE;
						end if;
					end if;

			end case;

			-- check if a stop was issued
--			if (fee_stop_signal_i = '1') then
			if (fee_clear_signal_i = '1') then
				-- stop issued, go to stopped
				s_spw_mux_state <= STOPPED;
			end if;

		end if;
	end process p_spw_mux;

	-- spw codec rx 
	spw_codec_rx_command_o <= (spw_mux_rx_0_command_i) when (s_mux_rx_selection = 0) else (c_SPW_RESET_RX_COMMAND);

	-- spw codec tx
	spw_codec_tx_command_o <= (spw_mux_tx_0_command_i) when (s_mux_tx_selection = 0)
		else (spw_mux_tx_1_command_i) when (s_mux_tx_selection = 1)
		else (spw_mux_tx_2_command_i) when (s_mux_tx_selection = 2)
		else (s_spw_tx_fsm_command) when (s_mux_tx_selection = 7)
		else (c_SPW_RESET_TX_COMMAND);

	-- spw mux port 0 rx
	spw_mux_rx_0_status_o <= (spw_codec_rx_status_i) when (s_mux_rx_selection = 0) else (c_SPW_RESET_RX_STATUS);

	-- spw mux port 0 tx
	spw_mux_tx_0_status_o.txhalff <= (c_SPW_RESET_TX_STATUS.txhalff) when (rst_i = '1')
		else (spw_codec_tx_status_i.txhalff) when ((s_mux_tx_selection = 0) or (s_mux_tx_selection = 7))
		else (c_SPW_RESET_TX_STATUS.txhalff);
	spw_mux_tx_0_status_o.txrdy   <= (c_SPW_RESET_TX_STATUS.txrdy) when (rst_i = '1')
		else ('0') when ((s_tx_channel_lock(0) = '1') or (((s_spw_mux_state = IDLE) or (s_spw_mux_state = SPW_TX_1_WAITING_EOP) or (s_spw_mux_state = SPW_TX_2_WAITING_EOP)) and (spw_mux_tx_0_command_i.txwrite = '1')) or (spw_mux_tx_0_command_i.txflag = '1'))
		else (spw_codec_tx_status_i.txrdy);

	-- spw mux port 1 tx
	spw_mux_tx_1_status_o.txhalff <= (c_SPW_RESET_TX_STATUS.txhalff) when (rst_i = '1')
		else (spw_codec_tx_status_i.txhalff) when ((s_mux_tx_selection = 1) or (s_mux_tx_selection = 7))
		else (c_SPW_RESET_TX_STATUS.txhalff);
	spw_mux_tx_1_status_o.txrdy   <= (c_SPW_RESET_TX_STATUS.txrdy) when (rst_i = '1')
		else ('0') when ((s_tx_channel_lock(1) = '1') or (((s_spw_mux_state = IDLE) or (s_spw_mux_state = SPW_TX_0_WAITING_EOP) or (s_spw_mux_state = SPW_TX_2_WAITING_EOP)) and (spw_mux_tx_1_command_i.txwrite = '1')) or (spw_mux_tx_1_command_i.txflag = '1'))
		else (spw_codec_tx_status_i.txrdy);

	-- spw mux port 2 tx
	spw_mux_tx_2_status_o.txhalff <= (c_SPW_RESET_TX_STATUS.txhalff) when (rst_i = '1')
		else (spw_codec_tx_status_i.txhalff) when ((s_mux_tx_selection = 2) or (s_mux_tx_selection = 7))
		else (c_SPW_RESET_TX_STATUS.txhalff);
	spw_mux_tx_2_status_o.txrdy   <= (c_SPW_RESET_TX_STATUS.txrdy) when (rst_i = '1')
		else ('0') when ((s_tx_channel_lock(2) = '1') or (((s_spw_mux_state = IDLE) or (s_spw_mux_state = SPW_TX_0_WAITING_EOP) or (s_spw_mux_state = SPW_TX_1_WAITING_EOP)) and (spw_mux_tx_2_command_i.txwrite = '1')) or (spw_mux_tx_2_command_i.txflag = '1'))
		else (spw_codec_tx_status_i.txrdy);

end architecture RTL;
