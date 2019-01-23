library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.spw_codec_pkg.all;

entity spw_mux_ent is
	port(
		clk_i                  : in  std_logic;
		rst_i                  : in  std_logic;
		spw_codec_rx_status_i  : in  t_spw_codec_data_rx_status;
		spw_codec_tx_status_i  : in  t_spw_codec_data_tx_status;
		spw_mux_rx_0_command_i : in  t_spw_codec_data_rx_command;
		spw_mux_tx_0_command_i : in  t_spw_codec_data_tx_command;
		spw_mux_tx_1_command_i : in  t_spw_codec_data_tx_command;
		spw_codec_rx_command_o : out t_spw_codec_data_rx_command;
		spw_codec_tx_command_o : out t_spw_codec_data_tx_command;
		spw_mux_rx_0_status_o  : out t_spw_codec_data_rx_status;
		spw_mux_tx_0_status_o  : out t_spw_codec_data_tx_status;
		spw_mux_tx_1_status_o  : out t_spw_codec_data_tx_status
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
	signal s_mux_tx_selection : natural range 0 to 7 := 0;

	type t_spw_mux_fsm is (
		IDLE,
		SPW_TX_0_NOT_READY,
		SPW_TX_0_WAITING_EOP,
		SPW_TX_1_NOT_READY,
		SPW_TX_1_WAITING_EOP
	);

	signal s_spw_mux_state : t_spw_mux_fsm;

	signal s_tx_0_flag_buffer   : std_logic;
	signal s_tx_0_data_buffer   : std_logic_vector(7 downto 0);
	signal s_tx_0_pending_write : std_logic;
	signal s_tx_0_channel_lock  : std_logic;

	signal s_tx_1_flag_buffer   : std_logic;
	signal s_tx_1_data_buffer   : std_logic_vector(7 downto 0);
	signal s_tx_1_pending_write : std_logic;
	signal s_tx_1_channel_lock  : std_logic;

	signal s_spw_tx_fsm_command : t_spw_codec_data_tx_command;

begin

	p_spw_mux : process(clk_i, rst_i) is
	begin
		if (rst_i = '1') then
			s_mux_rx_selection   <= 0;
			s_mux_tx_selection   <= 7;
			s_spw_tx_fsm_command <= c_SPW_RESET_TX_COMMAND;
		elsif rising_edge(clk_i) then

			s_mux_rx_selection <= 0;

			if ((spw_mux_tx_0_command_i.txwrite = '1') and (s_mux_tx_selection /= 0)) then
				s_tx_0_flag_buffer   <= spw_mux_tx_0_command_i.txflag;
				s_tx_0_data_buffer   <= spw_mux_tx_0_command_i.txdata;
				s_tx_0_pending_write <= '1';
				s_tx_0_channel_lock  <= '1';
			end if;

			if ((spw_mux_tx_1_command_i.txwrite = '1') and (s_mux_tx_selection /= 1)) then
				s_tx_1_flag_buffer   <= spw_mux_tx_1_command_i.txflag;
				s_tx_1_data_buffer   <= spw_mux_tx_1_command_i.txdata;
				s_tx_1_pending_write <= '1';
				s_tx_1_channel_lock  <= '1';
			end if;

			case (s_spw_mux_state) is

				when IDLE =>
					-- availabe to both spw tx channels
					if (s_tx_0_pending_write = '1') then
						s_tx_0_channel_lock <= '1';
						s_mux_tx_selection  <= 7;
						if (spw_codec_tx_status_i.txrdy = '1') then
							s_spw_tx_fsm_command.txwrite <= '1';
							s_spw_tx_fsm_command.txflag  <= s_tx_0_flag_buffer;
							s_spw_tx_fsm_command.txdata  <= s_tx_0_data_buffer;
							s_spw_mux_state              <= SPW_TX_0_WAITING_EOP;
						else
							s_spw_tx_fsm_command.txwrite <= '0';
							s_spw_tx_fsm_command.txflag  <= '0';
							s_spw_tx_fsm_command.txdata  <= x"00";
							s_spw_mux_state              <= SPW_TX_0_NOT_READY;
						end if;
					-- check if the spw tx ch 1 requested a write
					elsif (s_tx_1_pending_write = '1') then
						s_tx_1_channel_lock <= '1';
						s_mux_tx_selection  <= 7;
						if (spw_codec_tx_status_i.txrdy = '1') then
							s_spw_tx_fsm_command.txwrite <= '1';
							s_spw_tx_fsm_command.txflag  <= s_tx_1_flag_buffer;
							s_spw_tx_fsm_command.txdata  <= s_tx_1_data_buffer;
							s_spw_mux_state              <= SPW_TX_1_WAITING_EOP;
						else
							s_spw_tx_fsm_command.txwrite <= '0';
							s_spw_tx_fsm_command.txflag  <= '0';
							s_spw_tx_fsm_command.txdata  <= x"00";
							s_spw_mux_state              <= SPW_TX_1_NOT_READY;
						end if;
					end if;

				when SPW_TX_0_NOT_READY =>
					s_tx_0_channel_lock <= '1';
					s_mux_tx_selection  <= 7;
					if (spw_codec_tx_status_i.txrdy = '1') then
						s_spw_tx_fsm_command.txwrite <= '1';
						s_spw_tx_fsm_command.txflag  <= s_tx_0_flag_buffer;
						s_spw_tx_fsm_command.txdata  <= s_tx_0_data_buffer;
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
					s_tx_0_channel_lock          <= '0';
					s_tx_0_pending_write         <= '0';
					s_spw_tx_fsm_command.txwrite <= '0';
					s_spw_tx_fsm_command.txflag  <= '0';
					s_spw_tx_fsm_command.txdata  <= x"00";
					s_mux_tx_selection           <= 0;
					-- check if a end of package ocurred
					if ((spw_mux_tx_0_command_i.txflag = '1') and ((spw_mux_tx_0_command_i.txdata = x"00") or (spw_mux_tx_0_command_i.txdata = x"01"))) then
						-- end of package ocurred
						-- check if a request to use the spw tx ch 1 was issued
						if (s_tx_1_pending_write = '1') then
							-- request to use the spw tx ch 1 was issued
							s_tx_1_channel_lock <= '1';
							s_mux_tx_selection  <= 7;
							if (spw_codec_tx_status_i.txrdy = '1') then
								s_spw_tx_fsm_command.txwrite <= '1';
								s_spw_tx_fsm_command.txflag  <= s_tx_1_flag_buffer;
								s_spw_tx_fsm_command.txdata  <= s_tx_1_data_buffer;
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

				when SPW_TX_1_NOT_READY =>
					s_tx_1_channel_lock <= '1';
					s_mux_tx_selection  <= 7;
					if (spw_codec_tx_status_i.txrdy = '1') then
						s_spw_tx_fsm_command.txwrite <= '1';
						s_spw_tx_fsm_command.txflag  <= s_tx_1_flag_buffer;
						s_spw_tx_fsm_command.txdata  <= s_tx_1_data_buffer;
						s_spw_mux_state              <= SPW_TX_1_WAITING_EOP;
					else
						s_spw_tx_fsm_command.txwrite <= '0';
						s_spw_tx_fsm_command.txflag  <= '0';
						s_spw_tx_fsm_command.txdata  <= x"00";
						s_spw_mux_state              <= SPW_TX_1_NOT_READY;
					end if;

				when SPW_TX_1_WAITING_EOP =>
					-- lock spw tx ch 0 until an end of package
					s_spw_mux_state              <= SPW_TX_1_WAITING_EOP;
					s_tx_1_channel_lock          <= '0';
					s_tx_1_pending_write         <= '0';
					s_spw_tx_fsm_command.txwrite <= '0';
					s_spw_tx_fsm_command.txflag  <= '0';
					s_spw_tx_fsm_command.txdata  <= x"00";
					s_mux_tx_selection           <= 1;
					-- check if a end of package ocurred
					if ((spw_mux_tx_1_command_i.txflag = '1') and ((spw_mux_tx_1_command_i.txdata = x"00") or (spw_mux_tx_1_command_i.txdata = x"01"))) then
						-- end of package ocurred
						-- lock the channel
						s_tx_1_channel_lock <= '1';
						-- check if a request to use the spw tx ch 1 was issued
						if (s_tx_0_pending_write = '1') then
							-- request to use the spw tx ch 1 was issued
							s_mux_tx_selection <= 7;
							if (spw_codec_tx_status_i.txrdy = '1') then
								s_spw_tx_fsm_command.txwrite <= '1';
								s_spw_tx_fsm_command.txflag  <= s_tx_0_flag_buffer;
								s_spw_tx_fsm_command.txdata  <= s_tx_0_data_buffer;
								s_spw_mux_state              <= SPW_TX_0_WAITING_EOP;
							else
								s_spw_tx_fsm_command.txwrite <= '0';
								s_spw_tx_fsm_command.txflag  <= '0';
								s_spw_tx_fsm_command.txdata  <= x"00";
								s_spw_mux_state              <= SPW_TX_0_NOT_READY;
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

		end if;
	end process p_spw_mux;

	-- spw codec rx 
	spw_codec_rx_command_o <= (spw_mux_rx_0_command_i) when (s_mux_rx_selection = 0) else (c_SPW_RESET_RX_COMMAND);

	-- spw codec tx
	spw_codec_tx_command_o <= (spw_mux_tx_0_command_i) when (s_mux_tx_selection = 0)
		else (spw_mux_tx_1_command_i) when (s_mux_tx_selection = 1)
		else (s_spw_tx_fsm_command) when (s_mux_tx_selection = 7)
		else (c_SPW_RESET_TX_COMMAND);

	-- spw mux port 0 rx
	spw_mux_rx_0_status_o <= (spw_codec_rx_status_i) when (s_mux_rx_selection = 0) else (c_SPW_RESET_RX_STATUS);

	-- spw mux port 0 tx
	spw_mux_tx_0_status_o.txhalff <= (spw_codec_tx_status_i.txhalff) when ((s_mux_tx_selection = 0) or (s_mux_tx_selection = 7)) else (c_SPW_RESET_TX_STATUS.txhalff);
	spw_mux_tx_0_status_o.txrdy   <= ('0') when (s_tx_0_channel_lock = '1')
		else (spw_codec_tx_status_i.txrdy) when ((s_mux_tx_selection = 0) or (s_mux_tx_selection = 7))
		else (c_SPW_RESET_TX_STATUS.txrdy);

	-- spw mux port 1 tx
	spw_mux_tx_1_status_o.txhalff <= (spw_codec_tx_status_i.txhalff) when ((s_mux_tx_selection = 1) or (s_mux_tx_selection = 7)) else (c_SPW_RESET_TX_STATUS.txhalff);
	spw_mux_tx_1_status_o.txrdy   <= ('0') when (s_tx_1_channel_lock = '1')
		else (spw_codec_tx_status_i.txrdy) when ((s_mux_tx_selection = 1) or (s_mux_tx_selection = 7))
		else (c_SPW_RESET_TX_STATUS.txrdy);

end architecture RTL;
