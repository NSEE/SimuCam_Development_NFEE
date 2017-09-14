library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.tran_avs_controller_pkg.all;
use work.tran_avs_sc_fifo_pkg.all;
use work.tran_burst_registers_pkg.all;

entity tran_rx_avs_controller_ent is
	port(
		clk                              : in  std_logic;
		rst                              : in  std_logic;
		tran_rx_avsdc_rx_avs_inputs      : in  tran_avsdc_rx_avs_inputs_type;
		tran_rx_avsdc_rx_avs_outputs     : out tran_avsdc_rx_avs_outputs_type;
		burst_read_registers             : out tran_burst_read_registers_type;
		tran_rx_read_inputs_avs_sc_fifo  : in  tran_read_outputs_avs_sc_fifo_type;
		tran_rx_read_outputs_avs_sc_fifo : out tran_read_inputs_avs_sc_fifo_type
	);
end entity tran_rx_avs_controller_ent;

-- RX : fifo --> avs  (SpW --> Simucam)

architecture tran_rx_avs_controller_arc of tran_rx_avs_controller_ent is

	signal avsdc_rx_fifo_read_sig : std_logic := '0';

	signal tran_rx_avs_datavalid_sig : std_logic := '0';

	signal avsdc_rx_fifo_data_sig : tran_avs_sc_fifo_data_type;
	signal avsdc_rx_avs_data_sig  : tran_avsdc_data_type;

begin

	tran_rx_avs_controller_proc : process(clk, rst) is
		variable avsdc_rx_fifo_dataready_flag : std_logic := '0';
	begin
		if (rst = '1') then
			--			tran_rx_avs_datavalid_sig              <= '0';
			tran_rx_read_outputs_avs_sc_fifo.sclr <= '1';
			--			avsdc_rx_fifo_read_sig                 <= '0';
			--			avsdc_rx_avs_data_sig.spacewire_flag_3 <= '0';
			--			avsdc_rx_avs_data_sig.spacewire_data_3 <= (others => '0');
			--			avsdc_rx_avs_data_sig.spacewire_flag_2 <= '0';
			--			avsdc_rx_avs_data_sig.spacewire_data_2 <= (others => '0');
			--			avsdc_rx_avs_data_sig.spacewire_flag_1 <= '0';
			--			avsdc_rx_avs_data_sig.spacewire_data_1 <= (others => '0');
			--			avsdc_rx_avs_data_sig.spacewire_flag_0 <= '0';
			--			avsdc_rx_avs_data_sig.spacewire_data_0 <= (others => '0');
			avsdc_rx_fifo_dataready_flag          := '0';
		elsif rising_edge(clk) then
			tran_rx_read_outputs_avs_sc_fifo.sclr <= '0';
			--			avsdc_rx_fifo_read_sig                <= '0';

			-- disponibiliza dados do rx fifo no rx avs
			--			if (tran_rx_avs_datavalid_sig = '1') then -- já existe dado válido no avsdc_rx_avs_data
			--				if (tran_rx_avsdc_rx_avs_inputs.dataused = '1') then -- foi consumido o avsdc_rx_avs_data
			--					if (avsdc_rx_fifo_dataready_flag = '1') then -- avsdc_rx_fifo_data tem dados válidos
			--						avsdc_rx_avs_data_sig.spacewire_flag_3 <= avsdc_rx_fifo_data_sig.spacewire_flag_3;
			--						avsdc_rx_avs_data_sig.spacewire_data_3 <= avsdc_rx_fifo_data_sig.spacewire_data_3;
			--						avsdc_rx_avs_data_sig.spacewire_flag_2 <= avsdc_rx_fifo_data_sig.spacewire_flag_2;
			--						avsdc_rx_avs_data_sig.spacewire_data_2 <= avsdc_rx_fifo_data_sig.spacewire_data_2;
			--						avsdc_rx_avs_data_sig.spacewire_flag_1 <= avsdc_rx_fifo_data_sig.spacewire_flag_1;
			--						avsdc_rx_avs_data_sig.spacewire_data_1 <= avsdc_rx_fifo_data_sig.spacewire_data_1;
			--						avsdc_rx_avs_data_sig.spacewire_flag_0 <= avsdc_rx_fifo_data_sig.spacewire_flag_0;
			--						avsdc_rx_avs_data_sig.spacewire_data_0 <= avsdc_rx_fifo_data_sig.spacewire_data_0;
			--						avsdc_rx_fifo_dataready_flag           := '0';
			--						tran_rx_avs_datavalid_sig              <= '1';
			--					else                -- avsdc_rx_fifo_data não tem dados válidos
			--						tran_rx_avs_datavalid_sig <= '0';
			--					end if;
			--				else                    -- não foi consumido o avsdc_rx_avs_data
			--					tran_rx_avs_datavalid_sig <= '1';
			--				end if;
			--			else                        -- não existe dado válido no avsdc_rx_avs_data
			--				if (avsdc_rx_fifo_dataready_flag = '1') then -- avsdc_rx_fifo_data tem dados válidos
			--					avsdc_rx_avs_data_sig.spacewire_flag_3 <= avsdc_rx_fifo_data_sig.spacewire_flag_3;
			--					avsdc_rx_avs_data_sig.spacewire_data_3 <= avsdc_rx_fifo_data_sig.spacewire_data_3;
			--					avsdc_rx_avs_data_sig.spacewire_flag_2 <= avsdc_rx_fifo_data_sig.spacewire_flag_2;
			--					avsdc_rx_avs_data_sig.spacewire_data_2 <= avsdc_rx_fifo_data_sig.spacewire_data_2;
			--					avsdc_rx_avs_data_sig.spacewire_flag_1 <= avsdc_rx_fifo_data_sig.spacewire_flag_1;
			--					avsdc_rx_avs_data_sig.spacewire_data_1 <= avsdc_rx_fifo_data_sig.spacewire_data_1;
			--					avsdc_rx_avs_data_sig.spacewire_flag_0 <= avsdc_rx_fifo_data_sig.spacewire_flag_0;
			--					avsdc_rx_avs_data_sig.spacewire_data_0 <= avsdc_rx_fifo_data_sig.spacewire_data_0;
			--					avsdc_rx_fifo_dataready_flag           := '0';
			--					tran_rx_avs_datavalid_sig              <= '1';
			--				else                    -- avsdc_rx_fifo_data não tem dados válidos
			--					tran_rx_avs_datavalid_sig <= '0';
			--				end if;
			--			end if;
			--
			--			-- carrega avsdc_rx_fifo_data com dados válidos, se disponível
			--			if (tran_rx_read_inputs_avs_sc_fifo.empty = '0') then -- existe dado disponível na rx fifo
			--				if (avsdc_rx_fifo_dataready_flag = '0') then -- avsdc_rx_fifo_data não tem dados válidos 
			--					avsdc_rx_fifo_read_sig       <= '1';
			--					avsdc_rx_fifo_dataready_flag := '1';
			--				end if;
			--			else                        -- não existe dado disponível na rx fifo
			--				avsdc_rx_fifo_dataready_flag := '0';
			--			end if;

		end if;

	end process tran_rx_avs_controller_proc;

	avsdc_rx_fifo_read_sig    <= (tran_rx_avsdc_rx_avs_inputs.dataused);
	tran_rx_avs_datavalid_sig <= not (tran_rx_read_inputs_avs_sc_fifo.empty);

	avsdc_rx_avs_data_sig.spacewire_flag_3 <= avsdc_rx_fifo_data_sig.spacewire_flag_3;
	avsdc_rx_avs_data_sig.spacewire_data_3 <= avsdc_rx_fifo_data_sig.spacewire_data_3;
	avsdc_rx_avs_data_sig.spacewire_flag_2 <= avsdc_rx_fifo_data_sig.spacewire_flag_2;
	avsdc_rx_avs_data_sig.spacewire_data_2 <= avsdc_rx_fifo_data_sig.spacewire_data_2;
	avsdc_rx_avs_data_sig.spacewire_flag_1 <= avsdc_rx_fifo_data_sig.spacewire_flag_1;
	avsdc_rx_avs_data_sig.spacewire_data_1 <= avsdc_rx_fifo_data_sig.spacewire_data_1;
	avsdc_rx_avs_data_sig.spacewire_flag_0 <= avsdc_rx_fifo_data_sig.spacewire_flag_0;
	avsdc_rx_avs_data_sig.spacewire_data_0 <= avsdc_rx_fifo_data_sig.spacewire_data_0;

	-- Fifo Underflow/Overflow protection
	tran_rx_read_outputs_avs_sc_fifo.rdreq <= (avsdc_rx_fifo_read_sig) when (tran_rx_read_inputs_avs_sc_fifo.empty = '0') else ('0');

	-- Data assignment
	avsdc_rx_fifo_data_sig.spacewire_flag_3 <= tran_rx_read_inputs_avs_sc_fifo.q(35);
	avsdc_rx_fifo_data_sig.spacewire_data_3 <= tran_rx_read_inputs_avs_sc_fifo.q(34 downto 27);
	avsdc_rx_fifo_data_sig.spacewire_flag_2 <= tran_rx_read_inputs_avs_sc_fifo.q(26);
	avsdc_rx_fifo_data_sig.spacewire_data_2 <= tran_rx_read_inputs_avs_sc_fifo.q(25 downto 18);
	avsdc_rx_fifo_data_sig.spacewire_flag_1 <= tran_rx_read_inputs_avs_sc_fifo.q(17);
	avsdc_rx_fifo_data_sig.spacewire_data_1 <= tran_rx_read_inputs_avs_sc_fifo.q(16 downto 9);
	avsdc_rx_fifo_data_sig.spacewire_flag_0 <= tran_rx_read_inputs_avs_sc_fifo.q(8);
	avsdc_rx_fifo_data_sig.spacewire_data_0 <= tran_rx_read_inputs_avs_sc_fifo.q(7 downto 0);

	burst_read_registers.RX_DATA_BURST_REGISTER.SPACEWIRE_FLAG_3 <= avsdc_rx_avs_data_sig.spacewire_flag_3;
	burst_read_registers.RX_DATA_BURST_REGISTER.SPACEWIRE_DATA_3 <= avsdc_rx_avs_data_sig.spacewire_data_3;
	burst_read_registers.RX_DATA_BURST_REGISTER.SPACEWIRE_FLAG_2 <= avsdc_rx_avs_data_sig.spacewire_flag_2;
	burst_read_registers.RX_DATA_BURST_REGISTER.SPACEWIRE_DATA_2 <= avsdc_rx_avs_data_sig.spacewire_data_2;
	burst_read_registers.RX_DATA_BURST_REGISTER.SPACEWIRE_FLAG_1 <= avsdc_rx_avs_data_sig.spacewire_flag_1;
	burst_read_registers.RX_DATA_BURST_REGISTER.SPACEWIRE_DATA_1 <= avsdc_rx_avs_data_sig.spacewire_data_1;
	burst_read_registers.RX_DATA_BURST_REGISTER.SPACEWIRE_FLAG_0 <= avsdc_rx_avs_data_sig.spacewire_flag_0;
	burst_read_registers.RX_DATA_BURST_REGISTER.SPACEWIRE_DATA_0 <= avsdc_rx_avs_data_sig.spacewire_data_0;

	-- Others
	tran_rx_avsdc_rx_avs_outputs.datavalid <= tran_rx_avs_datavalid_sig;

end architecture tran_rx_avs_controller_arc;

