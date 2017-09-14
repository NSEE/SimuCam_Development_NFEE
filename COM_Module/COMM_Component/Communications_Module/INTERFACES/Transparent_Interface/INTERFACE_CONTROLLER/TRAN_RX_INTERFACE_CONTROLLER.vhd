library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.tran_bus_sc_fifo_pkg.all;
use work.tran_avs_sc_fifo_pkg.all;

entity tran_rx_interface_controller_ent is
	port(
		clk                               : in  std_logic;
		rst                               : in  std_logic;
		tran_rx_read_outputs_bus_sc_fifo  : in  tran_read_outputs_bus_sc_fifo_type;
		tran_rx_read_inputs_bus_sc_fifo   : out tran_read_inputs_bus_sc_fifo_type;
		tran_rx_write_outputs_avs_sc_fifo : in  tran_write_outputs_avs_sc_fifo_type;
		tran_rx_write_inputs_avs_sc_fifo  : out tran_write_inputs_avs_sc_fifo_type
	);
end entity tran_rx_interface_controller_ent;

-- RX : bus --> avs (SpW --> Simucam);

architecture tran_rx_interface_controller_arc of tran_rx_interface_controller_ent is

	type rx_interface_state_machine_type is (
		spacewire_packet_0_state,
		spacewire_packet_1_state,
		spacewire_packet_2_state,
		spacewire_packet_3_state
	);

	constant IC_RX_TIMEOUT_VALUE : natural := 100;

	signal ic_rx_bus_read_sig  : std_logic;
	signal ic_rx_avs_write_sig : std_logic;

	signal ic_rx_bus_data_sig : tran_bus_sc_fifo_data_type;
	signal ic_rx_avs_data_sig : tran_avs_sc_fifo_data_type;

begin

	tran_rx_interface_controller_proc : process(clk, rst) is
		variable rx_interface_state_machine : rx_interface_state_machine_type := spacewire_packet_0_state;
		variable rx_interface_timeout       : natural                         := 0;
	begin
		if (rst = '1') then
			ic_rx_avs_write_sig                   <= '0';
			ic_rx_avs_data_sig.spacewire_flag_3   <= '0';
			ic_rx_avs_data_sig.spacewire_data_3   <= (others => '0');
			ic_rx_avs_data_sig.spacewire_flag_2   <= '0';
			ic_rx_avs_data_sig.spacewire_data_2   <= (others => '0');
			ic_rx_avs_data_sig.spacewire_flag_1   <= '0';
			ic_rx_avs_data_sig.spacewire_data_1   <= (others => '0');
			ic_rx_avs_data_sig.spacewire_flag_0   <= '0';
			ic_rx_avs_data_sig.spacewire_data_0   <= (others => '0');
			tran_rx_read_inputs_bus_sc_fifo.sclr  <= '1';
			tran_rx_write_inputs_avs_sc_fifo.sclr <= '1';
			rx_interface_timeout                  := 0;
			rx_interface_state_machine            := spacewire_packet_0_state;
		elsif rising_edge(clk) then
			tran_rx_read_inputs_bus_sc_fifo.sclr  <= '0';
			tran_rx_write_inputs_avs_sc_fifo.sclr <= '0';
			ic_rx_avs_write_sig                   <= '0';

			rx_interface_timeout := rx_interface_timeout + 1;

			case (rx_interface_state_machine) is

				when spacewire_packet_0_state =>
					if ((tran_rx_read_outputs_bus_sc_fifo.empty = '0') and (tran_rx_write_outputs_avs_sc_fifo.full = '0')) then -- existe dado disponível no rx bus e espaço disponível

						ic_rx_avs_data_sig.spacewire_flag_0 <= ic_rx_bus_data_sig.spacewire_flag;
						ic_rx_avs_data_sig.spacewire_data_0 <= ic_rx_bus_data_sig.spacewire_data;
						ic_rx_avs_data_sig.spacewire_flag_1 <= '1';
						ic_rx_avs_data_sig.spacewire_data_1 <= (others => '1');
						ic_rx_avs_data_sig.spacewire_flag_2 <= '1';
						ic_rx_avs_data_sig.spacewire_data_2 <= (others => '1');
						ic_rx_avs_data_sig.spacewire_flag_3 <= '1';
						ic_rx_avs_data_sig.spacewire_data_3 <= (others => '1');

						rx_interface_timeout       := 0;
						rx_interface_state_machine := spacewire_packet_1_state;
					else
						rx_interface_state_machine := spacewire_packet_0_state;
					end if;

				when spacewire_packet_1_state =>
					if ((tran_rx_read_outputs_bus_sc_fifo.empty = '0') and (tran_rx_write_outputs_avs_sc_fifo.full = '0')) then -- existe dado disponível no rx bus e espaço disponível

						ic_rx_avs_data_sig.spacewire_flag_1 <= ic_rx_bus_data_sig.spacewire_flag;
						ic_rx_avs_data_sig.spacewire_data_1 <= ic_rx_bus_data_sig.spacewire_data;

						rx_interface_timeout       := 0;
						rx_interface_state_machine := spacewire_packet_2_state;
					else
						rx_interface_state_machine := spacewire_packet_1_state;
					end if;
					if (rx_interface_timeout >= IC_RX_TIMEOUT_VALUE) then -- timeout
						ic_rx_avs_write_sig        <= '1';
						rx_interface_timeout       := 0;
						rx_interface_state_machine := spacewire_packet_0_state;
					end if;

				when spacewire_packet_2_state =>
					if ((tran_rx_read_outputs_bus_sc_fifo.empty = '0') and (tran_rx_write_outputs_avs_sc_fifo.full = '0')) then -- existe dado disponível no rx bus e espaço disponível

						ic_rx_avs_data_sig.spacewire_flag_2 <= ic_rx_bus_data_sig.spacewire_flag;
						ic_rx_avs_data_sig.spacewire_data_2 <= ic_rx_bus_data_sig.spacewire_data;

						rx_interface_timeout       := 0;
						rx_interface_state_machine := spacewire_packet_3_state;
					else
						rx_interface_state_machine := spacewire_packet_2_state;
					end if;
					if (rx_interface_timeout >= IC_RX_TIMEOUT_VALUE) then -- timeout
						ic_rx_avs_write_sig <= '1';

						rx_interface_timeout       := 0;
						rx_interface_state_machine := spacewire_packet_0_state;
					end if;

				when spacewire_packet_3_state =>
					if ((tran_rx_read_outputs_bus_sc_fifo.empty = '0') and (tran_rx_write_outputs_avs_sc_fifo.full = '0')) then -- existe dado disponível no rx bus e espaço disponível

						ic_rx_avs_data_sig.spacewire_flag_3 <= ic_rx_bus_data_sig.spacewire_flag;
						ic_rx_avs_data_sig.spacewire_data_3 <= ic_rx_bus_data_sig.spacewire_data;
						ic_rx_avs_write_sig                 <= '1';

						rx_interface_timeout := 0;

						rx_interface_state_machine := spacewire_packet_0_state;
					else
						rx_interface_state_machine := spacewire_packet_3_state;
					end if;
					if (rx_interface_timeout >= IC_RX_TIMEOUT_VALUE) then -- timeout
						ic_rx_avs_write_sig <= '1';

						rx_interface_timeout       := 0;
						rx_interface_state_machine := spacewire_packet_0_state;
					end if;

			end case;

		end if;
	end process tran_rx_interface_controller_proc;

	ic_rx_bus_read_sig <= ('1') when ((tran_rx_read_outputs_bus_sc_fifo.empty = '0') and (tran_rx_write_outputs_avs_sc_fifo.full = '0')) else ('0');

	-- Fifo Underflow/Overflow protection
	tran_rx_read_inputs_bus_sc_fifo.rdreq  <= (ic_rx_bus_read_sig) when (tran_rx_read_outputs_bus_sc_fifo.empty = '0') else ('0');
	tran_rx_write_inputs_avs_sc_fifo.wrreq <= (ic_rx_avs_write_sig) when (tran_rx_write_outputs_avs_sc_fifo.full = '0') else ('0');

	-- Data assignment
	ic_rx_bus_data_sig.spacewire_flag <= tran_rx_read_outputs_bus_sc_fifo.q(8);
	ic_rx_bus_data_sig.spacewire_data <= tran_rx_read_outputs_bus_sc_fifo.q(7 downto 0);

	tran_rx_write_inputs_avs_sc_fifo.data(35)           <= ic_rx_avs_data_sig.spacewire_flag_3;
	tran_rx_write_inputs_avs_sc_fifo.data(34 downto 27) <= ic_rx_avs_data_sig.spacewire_data_3;
	tran_rx_write_inputs_avs_sc_fifo.data(26)           <= ic_rx_avs_data_sig.spacewire_flag_2;
	tran_rx_write_inputs_avs_sc_fifo.data(25 downto 18) <= ic_rx_avs_data_sig.spacewire_data_2;
	tran_rx_write_inputs_avs_sc_fifo.data(17)           <= ic_rx_avs_data_sig.spacewire_flag_1;
	tran_rx_write_inputs_avs_sc_fifo.data(16 downto 9)  <= ic_rx_avs_data_sig.spacewire_data_1;
	tran_rx_write_inputs_avs_sc_fifo.data(8)            <= ic_rx_avs_data_sig.spacewire_flag_0;
	tran_rx_write_inputs_avs_sc_fifo.data(7 downto 0)   <= ic_rx_avs_data_sig.spacewire_data_0;

end architecture tran_rx_interface_controller_arc;
