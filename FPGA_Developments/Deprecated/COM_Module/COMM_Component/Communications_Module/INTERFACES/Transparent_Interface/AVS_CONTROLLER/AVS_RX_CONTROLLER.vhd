library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.tran_mm_registers_pkg.all;
use work.tran_avs_controller_pkg.all;
use work.tran_avs_sc_fifo_pkg.all;
use work.tran_burst_registers_pkg.all;

entity tran_rx_avs_controller_ent is
	port(
		clk                              : in  std_logic;
		rst                              : in  std_logic;
		tran_burst_read_registers        : out tran_burst_read_registers_type;
		tran_rx_avsdc_rx_avs_inputs      : in  tran_avsdc_rx_avs_inputs_type;
		tran_rx_avsdc_rx_avs_outputs     : out tran_avsdc_rx_avs_outputs_type;
		tran_rx_read_inputs_avs_sc_fifo  : in  tran_read_outputs_avs_sc_fifo_type;
		tran_rx_read_outputs_avs_sc_fifo : out tran_read_inputs_avs_sc_fifo_type
	);
end entity tran_rx_avs_controller_ent;

-- RX : fifo --> avs  (SpW --> Simucam)

architecture tran_rx_avs_controller_arc of tran_rx_avs_controller_ent is

	-- Signals for AVS SC FIFO Control
	signal avsdc_rx_fifo_read_sig : std_logic := '0';

	-- Signals for AVS Controller Data
	signal avsdc_rx_fifo_data_sig : tran_avs_sc_fifo_data_type;
	signal avsdc_rx_avs_data_sig  : tran_avsdc_data_type;

begin

	-- RX AVS Controller Proccess
	tran_rx_avs_controller_proc : process(clk, rst) is
	begin
		-- Reset Procedures
		if (rst = '1') then
			tran_rx_read_outputs_avs_sc_fifo.sclr <= '1';
			-- Clocked Process
		elsif rising_edge(clk) then
			tran_rx_read_outputs_avs_sc_fifo.sclr <= '0';
		end if;
	end process tran_rx_avs_controller_proc;

	-- AVS SC FIFO Read Signal assignment
	avsdc_rx_fifo_read_sig <= tran_rx_avsdc_rx_avs_inputs.dataused;

	-- AVS SC FIFO Underflow/Overflow protection
	tran_rx_read_outputs_avs_sc_fifo.rdreq <= (avsdc_rx_fifo_read_sig) when (tran_rx_read_inputs_avs_sc_fifo.empty = '0') else ('0');

	-- AVS Controller DataValid Signal assignment
	tran_rx_avsdc_rx_avs_outputs.datavalid <= not (tran_rx_read_inputs_avs_sc_fifo.empty);

	-- AVS SC FIFO Data Signal assignment
	avsdc_rx_fifo_data_sig.spacewire_flag_3 <= tran_rx_read_inputs_avs_sc_fifo.q(35);
	avsdc_rx_fifo_data_sig.spacewire_data_3 <= tran_rx_read_inputs_avs_sc_fifo.q(34 downto 27);
	avsdc_rx_fifo_data_sig.spacewire_flag_2 <= tran_rx_read_inputs_avs_sc_fifo.q(26);
	avsdc_rx_fifo_data_sig.spacewire_data_2 <= tran_rx_read_inputs_avs_sc_fifo.q(25 downto 18);
	avsdc_rx_fifo_data_sig.spacewire_flag_1 <= tran_rx_read_inputs_avs_sc_fifo.q(17);
	avsdc_rx_fifo_data_sig.spacewire_data_1 <= tran_rx_read_inputs_avs_sc_fifo.q(16 downto 9);
	avsdc_rx_fifo_data_sig.spacewire_flag_0 <= tran_rx_read_inputs_avs_sc_fifo.q(8);
	avsdc_rx_fifo_data_sig.spacewire_data_0 <= tran_rx_read_inputs_avs_sc_fifo.q(7 downto 0);

	-- Internal Data Signal assignment
	avsdc_rx_avs_data_sig.spacewire_flag_3 <= avsdc_rx_fifo_data_sig.spacewire_flag_3;
	avsdc_rx_avs_data_sig.spacewire_data_3 <= avsdc_rx_fifo_data_sig.spacewire_data_3;
	avsdc_rx_avs_data_sig.spacewire_flag_2 <= avsdc_rx_fifo_data_sig.spacewire_flag_2;
	avsdc_rx_avs_data_sig.spacewire_data_2 <= avsdc_rx_fifo_data_sig.spacewire_data_2;
	avsdc_rx_avs_data_sig.spacewire_flag_1 <= avsdc_rx_fifo_data_sig.spacewire_flag_1;
	avsdc_rx_avs_data_sig.spacewire_data_1 <= avsdc_rx_fifo_data_sig.spacewire_data_1;
	avsdc_rx_avs_data_sig.spacewire_flag_0 <= avsdc_rx_fifo_data_sig.spacewire_flag_0;
	avsdc_rx_avs_data_sig.spacewire_data_0 <= avsdc_rx_fifo_data_sig.spacewire_data_0;

	-- Avalon Burst Registers Data Signal assignment
	tran_burst_read_registers.RX_DATA_BURST_REGISTER.SPACEWIRE_FLAG_3 <= avsdc_rx_avs_data_sig.spacewire_flag_3;
	tran_burst_read_registers.RX_DATA_BURST_REGISTER.SPACEWIRE_DATA_3 <= avsdc_rx_avs_data_sig.spacewire_data_3;
	tran_burst_read_registers.RX_DATA_BURST_REGISTER.SPACEWIRE_FLAG_2 <= avsdc_rx_avs_data_sig.spacewire_flag_2;
	tran_burst_read_registers.RX_DATA_BURST_REGISTER.SPACEWIRE_DATA_2 <= avsdc_rx_avs_data_sig.spacewire_data_2;
	tran_burst_read_registers.RX_DATA_BURST_REGISTER.SPACEWIRE_FLAG_1 <= avsdc_rx_avs_data_sig.spacewire_flag_1;
	tran_burst_read_registers.RX_DATA_BURST_REGISTER.SPACEWIRE_DATA_1 <= avsdc_rx_avs_data_sig.spacewire_data_1;
	tran_burst_read_registers.RX_DATA_BURST_REGISTER.SPACEWIRE_FLAG_0 <= avsdc_rx_avs_data_sig.spacewire_flag_0;
	tran_burst_read_registers.RX_DATA_BURST_REGISTER.SPACEWIRE_DATA_0 <= avsdc_rx_avs_data_sig.spacewire_data_0;

end architecture tran_rx_avs_controller_arc;

