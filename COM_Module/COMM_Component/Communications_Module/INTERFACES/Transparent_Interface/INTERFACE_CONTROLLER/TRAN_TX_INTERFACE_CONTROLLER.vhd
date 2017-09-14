library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.tran_bus_sc_fifo_pkg.all;
use work.tran_avs_sc_fifo_pkg.all;

entity tran_tx_interface_controller_ent is
	port(
		clk                               : in  std_logic;
		rst                               : in  std_logic;
		tran_tx_read_outputs_avs_sc_fifo  : in  tran_read_outputs_avs_sc_fifo_type;
		tran_tx_read_inputs_avs_sc_fifo   : out tran_read_inputs_avs_sc_fifo_type;
		tran_tx_write_outputs_bus_sc_fifo : in  tran_write_outputs_bus_sc_fifo_type;
		tran_tx_write_inputs_bus_sc_fifo  : out tran_write_inputs_bus_sc_fifo_type
	);
end entity tran_tx_interface_controller_ent;

-- TX : avs --> bus (Simucam --> SpW);

architecture tran_tx_interface_controller_arc of tran_tx_interface_controller_ent is

	constant SPW_INVALID_PACKET : std_logic_vector(8 downto 0) := "111111111";

	type tx_interface_state_machine_type is (
		spacewire_packet_0_state,
		spacewire_packet_1_state,
		spacewire_packet_2_state,
		spacewire_packet_3_state
	);

	signal ic_tx_avs_read_sig  : std_logic;
	signal ic_tx_bus_write_sig : std_logic;

	signal ic_tx_avs_data_sig : tran_avs_sc_fifo_data_type;
	signal ic_tx_bus_data_sig : tran_bus_sc_fifo_data_type;

begin

	tran_tx_interface_controller_proc : process(clk, rst) is
		variable tx_interface_state_machine : tx_interface_state_machine_type := spacewire_packet_0_state;
	begin
		if (rst = '1') then
			ic_tx_avs_read_sig                    <= '0';
			ic_tx_bus_write_sig                   <= '0';
			ic_tx_bus_data_sig.spacewire_flag     <= '0';
			ic_tx_bus_data_sig.spacewire_data     <= (others => '0');
			tran_tx_read_inputs_avs_sc_fifo.sclr  <= '1';
			tran_tx_write_inputs_bus_sc_fifo.sclr <= '1';
			tx_interface_state_machine            := spacewire_packet_0_state;
		elsif rising_edge(clk) then
			tran_tx_read_inputs_avs_sc_fifo.sclr  <= '0';
			tran_tx_write_inputs_bus_sc_fifo.sclr <= '0';
			ic_tx_bus_write_sig                   <= '0';
			ic_tx_avs_read_sig                    <= '0';

			case (tx_interface_state_machine) is

				when spacewire_packet_0_state =>
					if (tran_tx_read_outputs_avs_sc_fifo.empty = '0') then -- existe dado disponível no tx avs
						-- analiza se o pacote 0 é válido
						if (((ic_tx_avs_data_sig.spacewire_flag_0) & (ic_tx_avs_data_sig.spacewire_data_0)) /= SPW_INVALID_PACKET) then -- pacote válido
							if (tran_tx_write_outputs_bus_sc_fifo.full = '0') then -- existe espaço disponível no tx bus
								-- preenche os dados do pacote
								ic_tx_bus_data_sig.spacewire_flag   <= ic_tx_avs_data_sig.spacewire_flag_0;
								ic_tx_bus_data_sig.spacewire_data   <= ic_tx_avs_data_sig.spacewire_data_0;
								-- realiza a gravação do pacote
								ic_tx_bus_write_sig                 <= '1';
								-- captura os dados da fifo
								ic_tx_avs_read_sig                  <= '1';
								ic_tx_avs_data_sig.spacewire_flag_3 <= tran_tx_read_outputs_avs_sc_fifo.q(35);
								ic_tx_avs_data_sig.spacewire_data_3 <= tran_tx_read_outputs_avs_sc_fifo.q(34 downto 27);
								ic_tx_avs_data_sig.spacewire_flag_2 <= tran_tx_read_outputs_avs_sc_fifo.q(26);
								ic_tx_avs_data_sig.spacewire_data_2 <= tran_tx_read_outputs_avs_sc_fifo.q(25 downto 18);
								ic_tx_avs_data_sig.spacewire_flag_1 <= tran_tx_read_outputs_avs_sc_fifo.q(17);
								ic_tx_avs_data_sig.spacewire_data_1 <= tran_tx_read_outputs_avs_sc_fifo.q(16 downto 9);
								-- passa para o tratamento do próximo pacote
								tx_interface_state_machine          := spacewire_packet_1_state;
							else        -- espera ter espaço no tx bus
								tx_interface_state_machine := spacewire_packet_0_state;
							end if;
						else            -- pacote inválido
						-- captura os dados da fifo
							ic_tx_avs_read_sig                  <= '1';
							ic_tx_avs_data_sig.spacewire_flag_3 <= tran_tx_read_outputs_avs_sc_fifo.q(35);
							ic_tx_avs_data_sig.spacewire_data_3 <= tran_tx_read_outputs_avs_sc_fifo.q(34 downto 27);
							ic_tx_avs_data_sig.spacewire_flag_2 <= tran_tx_read_outputs_avs_sc_fifo.q(26);
							ic_tx_avs_data_sig.spacewire_data_2 <= tran_tx_read_outputs_avs_sc_fifo.q(25 downto 18);
							ic_tx_avs_data_sig.spacewire_flag_1 <= tran_tx_read_outputs_avs_sc_fifo.q(17);
							ic_tx_avs_data_sig.spacewire_data_1 <= tran_tx_read_outputs_avs_sc_fifo.q(16 downto 9);
							-- passa para o tratamento do próximo pacote
							tx_interface_state_machine          := spacewire_packet_1_state;
						end if;
					end if;

				when spacewire_packet_1_state =>
					-- analiza se o pacote 1 é válido
					if (((ic_tx_avs_data_sig.spacewire_flag_1) & (ic_tx_avs_data_sig.spacewire_data_1)) /= SPW_INVALID_PACKET) then -- pacote válido
						if (tran_tx_write_outputs_bus_sc_fifo.full = '0') then -- existe espaço disponível no tx bus
							-- preenche os dados do pacote
							ic_tx_bus_data_sig.spacewire_flag <= ic_tx_avs_data_sig.spacewire_flag_1;
							ic_tx_bus_data_sig.spacewire_data <= ic_tx_avs_data_sig.spacewire_data_1;
							-- realiza a gravação do pacote
							ic_tx_bus_write_sig               <= '1';
							-- passa para o tratamento do próximo pacote
							tx_interface_state_machine        := spacewire_packet_2_state;
						else            -- espera ter espaço no tx bus
							tx_interface_state_machine := spacewire_packet_1_state;
						end if;
					else                -- pacote inválido
					-- passa para o tratamento do próximo pacote
						tx_interface_state_machine := spacewire_packet_2_state;
					end if;

				when spacewire_packet_2_state =>
					-- analiza se o pacote 2 é válido
					if (((ic_tx_avs_data_sig.spacewire_flag_2) & (ic_tx_avs_data_sig.spacewire_data_2)) /= SPW_INVALID_PACKET) then -- pacote válido
						if (tran_tx_write_outputs_bus_sc_fifo.full = '0') then -- existe espaço disponível no tx bus
							-- preenche os dados do pacote
							ic_tx_bus_data_sig.spacewire_flag <= ic_tx_avs_data_sig.spacewire_flag_2;
							ic_tx_bus_data_sig.spacewire_data <= ic_tx_avs_data_sig.spacewire_data_2;
							-- realiza a gravação do pacote
							ic_tx_bus_write_sig               <= '1';
							-- passa para o tratamento do próximo pacote
							tx_interface_state_machine        := spacewire_packet_3_state;
						else            -- espera ter espaço no tx bus
							tx_interface_state_machine := spacewire_packet_2_state;
						end if;
					else                -- pacote inválido
					-- passa para o tratamento do próximo pacote
						tx_interface_state_machine := spacewire_packet_3_state;
					end if;

				when spacewire_packet_3_state =>
					-- analiza se o pacote 3 é válido
					if (((ic_tx_avs_data_sig.spacewire_flag_3) & (ic_tx_avs_data_sig.spacewire_data_3)) /= SPW_INVALID_PACKET) then -- pacote válido
						if (tran_tx_write_outputs_bus_sc_fifo.full = '0') then -- existe espaço disponível no tx bus
							-- preenche os dados do pacote
							ic_tx_bus_data_sig.spacewire_flag <= ic_tx_avs_data_sig.spacewire_flag_3;
							ic_tx_bus_data_sig.spacewire_data <= ic_tx_avs_data_sig.spacewire_data_3;
							-- realiza a gravação do pacote
							ic_tx_bus_write_sig               <= '1';
							-- volta para o tratamento do primeiro pacote
							tx_interface_state_machine        := spacewire_packet_0_state;
						else            -- espera ter espaço no tx bus
							tx_interface_state_machine := spacewire_packet_3_state;
						end if;
					else                -- pacote inválido
					-- volta para o tratamento do primeiro pacote
						tx_interface_state_machine := spacewire_packet_0_state;
					end if;

			end case;

		end if;
	end process tran_tx_interface_controller_proc;

	-- Fifo Underflow/Overflow protection
	tran_tx_write_inputs_bus_sc_fifo.wrreq <= (ic_tx_bus_write_sig) when (tran_tx_write_outputs_bus_sc_fifo.full = '0') else ('0');
	tran_tx_read_inputs_avs_sc_fifo.rdreq  <= (ic_tx_avs_read_sig) when (tran_tx_read_outputs_avs_sc_fifo.empty = '0') else ('0');

	-- Data assignment
	--	ic_tx_avs_data_sig.spacewire_flag_3 <= tran_tx_read_outputs_avs_sc_fifo.q(35);
	--	ic_tx_avs_data_sig.spacewire_data_3 <= tran_tx_read_outputs_avs_sc_fifo.q(34 downto 27);
	--	ic_tx_avs_data_sig.spacewire_flag_2 <= tran_tx_read_outputs_avs_sc_fifo.q(26);
	--	ic_tx_avs_data_sig.spacewire_data_2 <= tran_tx_read_outputs_avs_sc_fifo.q(25 downto 18);
	--	ic_tx_avs_data_sig.spacewire_flag_1 <= tran_tx_read_outputs_avs_sc_fifo.q(17);
	--	ic_tx_avs_data_sig.spacewire_data_1 <= tran_tx_read_outputs_avs_sc_fifo.q(16 downto 9);
	ic_tx_avs_data_sig.spacewire_flag_0 <= tran_tx_read_outputs_avs_sc_fifo.q(8);
	ic_tx_avs_data_sig.spacewire_data_0 <= tran_tx_read_outputs_avs_sc_fifo.q(7 downto 0);

	tran_tx_write_inputs_bus_sc_fifo.data(8)          <= ic_tx_bus_data_sig.spacewire_flag;
	tran_tx_write_inputs_bus_sc_fifo.data(7 downto 0) <= ic_tx_bus_data_sig.spacewire_data;

end architecture tran_tx_interface_controller_arc;
