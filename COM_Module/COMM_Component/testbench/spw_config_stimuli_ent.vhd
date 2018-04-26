library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.spwc_mm_registers_pkg.all;
use work.spwc_rx_data_dc_fifo_pkg.all;
use work.spwc_tx_data_dc_fifo_pkg.all;

entity spw_config_stimuli_ent is
	port(
		clk_100                             : in  std_logic;
		clk_200                             : in  std_logic;
		rst                                 : in  std_logic;
		spwc_mm_write_registers             : out spwc_mm_write_registers_type;
		spwc_mm_read_registers              : in  spwc_mm_read_registers_type;
		spwc_rx_data_dc_fifo_clk200_inputs  : out spwc_rx_data_dc_fifo_clk200_outputs_type;
		spwc_rx_data_dc_fifo_clk200_outputs : in  spwc_rx_data_dc_fifo_clk200_inputs_type;
		spwc_tx_data_dc_fifo_clk200_inputs  : out spwc_tx_data_dc_fifo_clk200_outputs_type;
		spwc_tx_data_dc_fifo_clk200_outputs : in  spwc_tx_data_dc_fifo_clk200_inputs_type
	);
end entity spw_config_stimuli_ent;

architecture RTL of spw_config_stimuli_ent is

begin

	spw_config_stimuli_clk100_proc : process(clk_100, rst) is
	begin
		if (rst = '1') then

			spwc_mm_write_registers.INTERFACE_CONTROL_REGISTER.CODEC_ENABLE_BIT           <= '1';
			spwc_mm_write_registers.INTERFACE_CONTROL_REGISTER.CODEC_RX_ENABLE_BIT        <= '1';
			spwc_mm_write_registers.INTERFACE_CONTROL_REGISTER.CODEC_TX_ENABLE_BIT        <= '1';
			spwc_mm_write_registers.INTERFACE_CONTROL_REGISTER.LOOPBACK_MODE_BIT          <= '0';
			spwc_mm_write_registers.INTERFACE_CONTROL_REGISTER.EXTERNAL_LOOPBACK_MODE_BIT <= '1';
			spwc_mm_write_registers.INTERFACE_CONTROL_REGISTER.FORCE_RESET_BIT            <= '0';

			spwc_mm_write_registers.INTERRUPT_ENABLE_REGISTER.LINK_ERROR            <= '0';
			spwc_mm_write_registers.INTERRUPT_ENABLE_REGISTER.TIMECODE_RECEIVED     <= '0';
			spwc_mm_write_registers.INTERRUPT_ENABLE_REGISTER.LINK_RUNNING          <= '0';
			spwc_mm_write_registers.INTERRUPT_FLAG_CLEAR_REGISTER.LINK_ERROR        <= '0';
			spwc_mm_write_registers.INTERRUPT_FLAG_CLEAR_REGISTER.TIMECODE_RECEIVED <= '0';
			spwc_mm_write_registers.INTERRUPT_FLAG_CLEAR_REGISTER.LINK_RUNNING      <= '0';

			spwc_mm_write_registers.SPW_LINK_MODE_REGISTER.AUTOSTART_BIT       <= '1';
			spwc_mm_write_registers.SPW_LINK_MODE_REGISTER.LINK_START_BIT      <= '0';
			spwc_mm_write_registers.SPW_LINK_MODE_REGISTER.LINK_DISCONNECT_BIT <= '0';
			spwc_mm_write_registers.SPW_LINK_MODE_REGISTER.TX_CLOCK_DIV        <= x"01";

			spwc_mm_write_registers.RX_TIMECODE_CLEAR_REGISTER.CONTROL_STATUS_BIT <= '0';
			spwc_mm_write_registers.TX_TIMECODE_REGISTER.TIMECODE_CONTROL_BITS    <= (others => '0');
			spwc_mm_write_registers.TX_TIMECODE_REGISTER.TIMECODE_COUNTER_VALUE   <= (others => '0');
			spwc_mm_write_registers.TX_TIMECODE_REGISTER.CONTROL_STATUS_BIT       <= '0';

		elsif rising_edge(clk_100) then

		end if;
	end process spw_config_stimuli_clk100_proc;

	spw_config_stimuli_clk200_proc : process(clk_200, rst) is
	begin
		if (rst = '1') then

			spwc_rx_data_dc_fifo_clk200_inputs.wrempty <= '1';
			spwc_rx_data_dc_fifo_clk200_inputs.wrfull  <= '0';

			spwc_tx_data_dc_fifo_clk200_inputs.q       <= (others => '0');
			spwc_tx_data_dc_fifo_clk200_inputs.rdempty <= '1';
			spwc_tx_data_dc_fifo_clk200_inputs.rdfull  <= '0';

		elsif rising_edge(clk_200) then

		end if;
	end process spw_config_stimuli_clk200_proc;

end architecture RTL;
