library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.tran_avs_controller_pkg.all;
use work.tran_avs_sc_fifo_pkg.all;
use work.tran_burst_registers_pkg.all;

entity tran_tx_avs_controller_ent is
	port(
		clk                               : in  std_logic;
		rst                               : in  std_logic;
		tran_tx_avsdc_tx_avs_inputs       : in  tran_avsdc_tx_avs_inputs_type;
		tran_tx_avsdc_tx_avs_outputs      : out tran_avsdc_tx_avs_outputs_type;
		burst_write_registers             : in  tran_burst_write_registers_type;
		tran_tx_write_inputs_avs_sc_fifo  : in  tran_write_outputs_avs_sc_fifo_type;
		tran_tx_write_outputs_avs_sc_fifo : out tran_write_inputs_avs_sc_fifo_type
	);
end entity tran_tx_avs_controller_ent;

architecture tran_tx_avs_controller_arc of tran_tx_avs_controller_ent is

	signal avsdc_tx_avs_data_sig  : tran_avsdc_data_type;
	signal avsdc_tx_fifo_data_sig : tran_avs_sc_fifo_data_type;

begin

	tran_tx_avs_controller_proc : process(clk, rst) is
	begin
		if (rst = '1') then
			tran_tx_write_outputs_avs_sc_fifo.sclr  <= '1';
		elsif rising_edge(clk) then
			tran_tx_write_outputs_avs_sc_fifo.sclr <= '0';
		end if;
	end process tran_tx_avs_controller_proc;

	-- Fifo Underflow/Overflow protection
	tran_tx_avsdc_tx_avs_outputs.full       <= tran_tx_write_inputs_avs_sc_fifo.full;
	tran_tx_write_outputs_avs_sc_fifo.wrreq <= (tran_tx_avsdc_tx_avs_inputs.write) when (tran_tx_write_inputs_avs_sc_fifo.full = '0') else ('0');

	-- Data assignment
	avsdc_tx_avs_data_sig.spacewire_flag_3               <= burst_write_registers.TX_DATA_BURST_REGISTER.SPACEWIRE_FLAG_3;
	avsdc_tx_avs_data_sig.spacewire_data_3               <= burst_write_registers.TX_DATA_BURST_REGISTER.SPACEWIRE_DATA_3;
	avsdc_tx_avs_data_sig.spacewire_flag_2               <= burst_write_registers.TX_DATA_BURST_REGISTER.SPACEWIRE_FLAG_2;
	avsdc_tx_avs_data_sig.spacewire_data_2               <= burst_write_registers.TX_DATA_BURST_REGISTER.SPACEWIRE_DATA_2;
	avsdc_tx_avs_data_sig.spacewire_flag_1               <= burst_write_registers.TX_DATA_BURST_REGISTER.SPACEWIRE_FLAG_1;
	avsdc_tx_avs_data_sig.spacewire_data_1               <= burst_write_registers.TX_DATA_BURST_REGISTER.SPACEWIRE_DATA_1;
	avsdc_tx_avs_data_sig.spacewire_flag_0               <= burst_write_registers.TX_DATA_BURST_REGISTER.SPACEWIRE_FLAG_0;
	avsdc_tx_avs_data_sig.spacewire_data_0               <= burst_write_registers.TX_DATA_BURST_REGISTER.SPACEWIRE_DATA_0;
	
	avsdc_tx_fifo_data_sig.spacewire_flag_3 <= (avsdc_tx_avs_data_sig.spacewire_flag_3) when (rst = '0') else ('0');
	avsdc_tx_fifo_data_sig.spacewire_data_3 <= (avsdc_tx_avs_data_sig.spacewire_data_3) when (rst = '0') else ((others => '0'));
	avsdc_tx_fifo_data_sig.spacewire_flag_2 <= (avsdc_tx_avs_data_sig.spacewire_flag_2) when (rst = '0') else ('0');
	avsdc_tx_fifo_data_sig.spacewire_data_2 <= (avsdc_tx_avs_data_sig.spacewire_data_2) when (rst = '0') else ((others => '0'));
	avsdc_tx_fifo_data_sig.spacewire_flag_1 <= (avsdc_tx_avs_data_sig.spacewire_flag_1) when (rst = '0') else ('0');
	avsdc_tx_fifo_data_sig.spacewire_data_1 <= (avsdc_tx_avs_data_sig.spacewire_data_1) when (rst = '0') else ((others => '0'));
	avsdc_tx_fifo_data_sig.spacewire_flag_0 <= (avsdc_tx_avs_data_sig.spacewire_flag_0) when (rst = '0') else ('0');
	avsdc_tx_fifo_data_sig.spacewire_data_0 <= (avsdc_tx_avs_data_sig.spacewire_data_0) when (rst = '0') else ((others => '0'));
	
	tran_tx_write_outputs_avs_sc_fifo.data(35)           <= avsdc_tx_fifo_data_sig.spacewire_flag_3;
	tran_tx_write_outputs_avs_sc_fifo.data(34 downto 27) <= avsdc_tx_fifo_data_sig.spacewire_data_3;
	tran_tx_write_outputs_avs_sc_fifo.data(26)           <= avsdc_tx_fifo_data_sig.spacewire_flag_2;
	tran_tx_write_outputs_avs_sc_fifo.data(25 downto 18) <= avsdc_tx_fifo_data_sig.spacewire_data_2;
	tran_tx_write_outputs_avs_sc_fifo.data(17)           <= avsdc_tx_fifo_data_sig.spacewire_flag_1;
	tran_tx_write_outputs_avs_sc_fifo.data(16 downto 9)  <= avsdc_tx_fifo_data_sig.spacewire_data_1;
	tran_tx_write_outputs_avs_sc_fifo.data(8)            <= avsdc_tx_fifo_data_sig.spacewire_flag_0;
	tran_tx_write_outputs_avs_sc_fifo.data(7 downto 0)   <= avsdc_tx_fifo_data_sig.spacewire_data_0;

end architecture tran_tx_avs_controller_arc;

