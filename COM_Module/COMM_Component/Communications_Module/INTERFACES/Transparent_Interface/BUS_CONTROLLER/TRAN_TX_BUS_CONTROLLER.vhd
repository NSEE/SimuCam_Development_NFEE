library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.tran_bus_controller_pkg.all;
use work.tran_bus_sc_fifo_pkg.all;

entity tran_tx_bus_controller_ent is
	port(
		clk                              : in  std_logic;
		rst                              : in  std_logic;
		tran_tx_bc_control_inputs        : in  tran_bc_control_inputs_type;
		tran_tx_bc_write_bus_inputs      : in  tran_bc_write_bus_inputs_type;
		tran_tx_bc_write_bus_outputs     : out tran_bc_write_bus_outputs_type;
		tran_tx_read_inputs_bus_sc_fifo  : in  tran_read_outputs_bus_sc_fifo_type;
		tran_tx_read_outputs_bus_sc_fifo : out tran_read_inputs_bus_sc_fifo_type
	);
end entity tran_tx_bus_controller_ent;

-- TX : avs  --> fifo (Simucam --> SpW);

architecture tran_tx_bus_controller_arc of tran_tx_bus_controller_ent is

	type bus_write_state_machine_type is (
		standby_state,
		delay_state,
		running_state
	);

	signal bc_tx_fifo_read_enabled_sig : std_logic := '0';
	signal bc_tx_fifo_read_sig         : std_logic := '0';
	signal bc_tx_bus_dataused_sig      : std_logic := '0';

	signal tran_tx_bus_datavalid_enabled : std_logic := '0';
	signal tran_tx_bus_datavalid : std_logic := '0';

	signal bc_tx_fifo_data_sig : tran_bus_sc_fifo_data_type;
	signal bc_rx_bus_data_sig  : tran_bc_bus_data_type;
	
	signal bc_standby_flag    : std_logic := '1';
	signal bc_data_ready_flag : std_logic := '0';

begin

	tran_tx_bus_controller_proc : process(clk, rst) is
		variable bus_write_state_machine   : bus_write_state_machine_type := standby_state;
		variable bc_tx_fifo_dataready_flag : std_logic                    := '0';
	begin
		if (rst = '1') then
			tran_tx_bc_write_bus_outputs.enabled  <= '0';
			tran_tx_bus_datavalid                 <= '0';
			tran_tx_read_outputs_bus_sc_fifo.sclr <= '1';
			bc_tx_fifo_read_sig                   <= '0';
			bc_standby_flag                       <= '1';
			bc_data_ready_flag <= '0';
			bc_tx_fifo_dataready_flag             := '0';
		elsif rising_edge(clk) then
			tran_tx_read_outputs_bus_sc_fifo.sclr <= '0';
--			bc_tx_fifo_read_sig                   <= '0';
--			tran_tx_bus_datavalid                 <= '0';
--			bc_standby_flag                       <= '1';
--
--			-- Operação Bus Write (escreve dados da fifo no bus)
--			if ((tran_tx_bc_control_inputs.bc_enable = '1') and (tran_tx_bc_control_inputs.bc_write_enable = '1')) then
--				case (bus_write_state_machine) is
--
--					when standby_state => -- aguarda ter dados na tx fifo, não possui dados válidos no bus
--						bc_standby_flag <= '1';
--						if (tran_tx_read_inputs_bus_sc_fifo.empty = '0') then -- existe dado disponível na tx fifo
--							bc_tx_fifo_read_sig     <= '1';
--							bus_write_state_machine := delay_state;
--						else            -- não existe dado disponível na tx fifo
--							bc_tx_fifo_read_sig     <= '0';
--							bus_write_state_machine := standby_state;
--						end if;
--
--					when delay_state => -- delay para carregar dados da tx fifo no bus
--						bc_tx_fifo_read_sig     <= '0';
--						tran_tx_bus_datavalid   <= '1';
--						bc_data_ready_flag 		<= '0';
--						bus_write_state_machine := running_state;
--
--					when running_state => -- existem dados válidos no bus, espera eles serem consumidos
--						bc_standby_flag <= '0';
--						if (bc_tx_bus_dataused_sig = '1') then -- foi consumido o bc_rx_bus_data
--							if (bc_tx_fifo_read_enabled_sig = '1') then
--								tran_tx_bus_datavalid <= '1';
--								bus_write_state_machine := running_state;
--							else
--								tran_tx_bus_datavalid <= '0';
--								bus_write_state_machine := running_state;
--							end if;
--							
--							
--							if (tran_tx_read_inputs_bus_sc_fifo.empty = '0') then -- existe dado disponível na tx fifo, nesse caso o controle de burst já requisitou dado novo
--								
--								
--							else        -- não existe dado disponível na tx fifo
--								bc_tx_fifo_read_sig     <= '0';
--								bc_standby_flag         <= '1';
--								bus_write_state_machine := standby_state;
--							end if;
--						else            -- não foi consumido o bc_rx_bus_data
--							tran_tx_bus_datavalid   <= '1';
--							bus_write_state_machine := running_state;
--						end if;
--
--				end case;
--				tran_tx_bc_write_bus_outputs.enabled <= '1';
--			else
--				tran_tx_bc_write_bus_outputs.enabled <= '0';
--				tran_tx_bus_datavalid                <= '0';
--			end if;

			--			-- Operação Bus Write (escreve dados da fifo no bus)
						if ((tran_tx_bc_control_inputs.bc_enable = '1') and (tran_tx_bc_control_inputs.bc_write_enable = '1')) then
			--
			--				-- disponibiliza dados do tx fifo no tx bus
			--				if (tran_tx_bus_datavalid = '1') then -- já existe dado válido no bc_rx_bus_data
			--					if (bc_tx_bus_dataused_sig = '1') then -- foi consumido o bc_rx_bus_data
			--						if (bc_tx_fifo_dataready_flag = '1') then -- bc_tx_fifo_data tem dados válidos 
			--							bc_rx_bus_data_sig.spacewire_flag <= bc_tx_fifo_data_sig.spacewire_flag;
			--							bc_rx_bus_data_sig.spacewire_data <= bc_tx_fifo_data_sig.spacewire_data;
			--							bc_tx_fifo_dataready_flag         := '0';
			--							tran_tx_bus_datavalid             <= '1';
			--						else            -- bc_tx_fifo_data não tem dados válidos
			--							tran_tx_bus_datavalid <= '0';
			--						end if;
			--					else                -- não foi consumido o bc_rx_bus_data
			--						tran_tx_bus_datavalid <= '1';
			--					end if;
			--				else                    -- não existe dado válido no bc_rx_bus_data
			--					if (bc_tx_fifo_dataready_flag = '1') then -- bc_tx_fifo_data tem dados válidos
			--						bc_rx_bus_data_sig.spacewire_flag <= bc_tx_fifo_data_sig.spacewire_flag;
			--						bc_rx_bus_data_sig.spacewire_data <= bc_tx_fifo_data_sig.spacewire_data;
			--						bc_tx_fifo_dataready_flag         := '0';
			--						tran_tx_bus_datavalid             <= '1';
			--					else
			--						tran_tx_bus_datavalid <= '0';
			--					end if;
			--				end if;
			--
			--				-- carrega bc_tx_fifo_data com dados válidos, se disponível
			--				if (tran_tx_read_inputs_bus_sc_fifo.empty = '0') then -- existe dado disponível na tx fifo
			--					if (bc_tx_fifo_dataready_flag = '0') then -- bc_tx_fifo_data não tem dados válidos 
			--						bc_tx_fifo_read_sig       <= '1';
			--						bc_tx_fifo_dataready_flag := '1';
			--					end if;
			--				else                    -- não existe dado disponível na tx fifo
			--					bc_tx_fifo_dataready_flag := '0';
			--				end if;
			--
							tran_tx_bc_write_bus_outputs.enabled <= '1';
						else
							tran_tx_bc_write_bus_outputs.enabled <= '0';
						end if;

		end if;
	end process tran_tx_bus_controller_proc;

	-- Enabled management
	bc_tx_bus_dataused_sig                 <= (tran_tx_bc_write_bus_inputs.dataused) when ((tran_tx_bc_control_inputs.bc_enable = '1') and (tran_tx_bc_control_inputs.bc_write_enable = '1')) else ('0');
	tran_tx_bc_write_bus_outputs.datavalid <= (tran_tx_bus_datavalid_enabled) when ((tran_tx_bc_control_inputs.bc_enable = '1') and (tran_tx_bc_control_inputs.bc_write_enable = '1')) else ('0');

	--tran_tx_bus_datavalid_enabled <= (tran_tx_bus_datavalid) when not ((bc_tx_fifo_read_enabled_sig = '0') and (bc_tx_bus_dataused_sig = '1')) else ('0');
	tran_tx_bus_datavalid_enabled <= not (tran_tx_read_inputs_bus_sc_fifo.empty);

	-- rdreq management for burst mode
	--bc_tx_fifo_read_enabled_sig            <= (bc_tx_fifo_read_sig) when not ((bc_standby_flag = '0') and (bc_tx_bus_dataused_sig = '1') and (tran_tx_read_inputs_bus_sc_fifo.empty = '0')) else ('1');
	bc_tx_fifo_read_enabled_sig            <= bc_tx_bus_dataused_sig;
	--bc_tx_fifo_read_enabled_sig            <= (bc_tx_fifo_read_sig) when not ((bc_tx_bus_dataused_sig = '1') and (tran_tx_read_inputs_bus_sc_fifo.empty = '0')) else ('1');
	-- Fifo Underflow/Overflow protection
	tran_tx_read_outputs_bus_sc_fifo.rdreq <= (bc_tx_fifo_read_enabled_sig) when (tran_tx_read_inputs_bus_sc_fifo.empty = '0') else ('0');

	-- Data assignment
	bc_tx_fifo_data_sig.spacewire_flag            <= tran_tx_read_inputs_bus_sc_fifo.q(8);
	bc_tx_fifo_data_sig.spacewire_data            <= tran_tx_read_inputs_bus_sc_fifo.q(7 downto 0);
	tran_tx_bc_write_bus_outputs.data(8)          <= bc_rx_bus_data_sig.spacewire_flag;
	tran_tx_bc_write_bus_outputs.data(7 downto 0) <= bc_rx_bus_data_sig.spacewire_data;

	bc_rx_bus_data_sig.spacewire_flag <= bc_tx_fifo_data_sig.spacewire_flag;
	bc_rx_bus_data_sig.spacewire_data <= bc_tx_fifo_data_sig.spacewire_data;

	-- Others

end architecture tran_tx_bus_controller_arc;
