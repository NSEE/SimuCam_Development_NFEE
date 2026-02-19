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

	signal cnt : natural := 0;

begin

	spw_config_stimuli_clk100_proc : process(clk_100, rst) is
	begin
		if (rst = '1') then

			spwc_mm_write_registers.INTERFACE_CONTROL_REGISTER.CODEC_ENABLE_BIT           <= '1';
			spwc_mm_write_registers.INTERFACE_CONTROL_REGISTER.CODEC_RX_ENABLE_BIT        <= '1';
			spwc_mm_write_registers.INTERFACE_CONTROL_REGISTER.CODEC_TX_ENABLE_BIT        <= '1';
			spwc_mm_write_registers.INTERFACE_CONTROL_REGISTER.LOOPBACK_MODE_BIT          <= '0';
			spwc_mm_write_registers.INTERFACE_CONTROL_REGISTER.EXTERNAL_LOOPBACK_MODE_BIT <= '0';
			spwc_mm_write_registers.INTERFACE_CONTROL_REGISTER.BACKDOOR_MODE_BIT          <= '0';
			spwc_mm_write_registers.INTERFACE_CONTROL_REGISTER.FORCE_RESET_BIT            <= '0';

			spwc_mm_write_registers.INTERRUPT_ENABLE_REGISTER.LINK_ERROR            <= '0';
			spwc_mm_write_registers.INTERRUPT_ENABLE_REGISTER.TIMECODE_RECEIVED     <= '0';
			spwc_mm_write_registers.INTERRUPT_ENABLE_REGISTER.LINK_RUNNING          <= '0';
			spwc_mm_write_registers.INTERRUPT_FLAG_CLEAR_REGISTER.LINK_ERROR        <= '0';
			spwc_mm_write_registers.INTERRUPT_FLAG_CLEAR_REGISTER.TIMECODE_RECEIVED <= '0';
			spwc_mm_write_registers.INTERRUPT_FLAG_CLEAR_REGISTER.LINK_RUNNING      <= '0';

			spwc_mm_write_registers.SPW_LINK_MODE_REGISTER.AUTOSTART_BIT       <= '0';
			spwc_mm_write_registers.SPW_LINK_MODE_REGISTER.LINK_START_BIT      <= '0';
			spwc_mm_write_registers.SPW_LINK_MODE_REGISTER.LINK_DISCONNECT_BIT <= '0';
			spwc_mm_write_registers.SPW_LINK_MODE_REGISTER.TX_CLOCK_DIV        <= x"01";

			spwc_mm_write_registers.RX_TIMECODE_CLEAR_REGISTER.CONTROL_STATUS_BIT <= '0';
			spwc_mm_write_registers.TX_TIMECODE_REGISTER.TIMECODE_CONTROL_BITS    <= (others => '0');
			spwc_mm_write_registers.TX_TIMECODE_REGISTER.TIMECODE_COUNTER_VALUE   <= (others => '0');
			spwc_mm_write_registers.TX_TIMECODE_REGISTER.CONTROL_STATUS_BIT       <= '0';

			spwc_mm_write_registers.RX_BACKDOOR_CONTROL_REGISTER.CODEC_READ_WRITE <= '0';
			spwc_mm_write_registers.TX_BACKDOOR_CONTROL_REGISTER.CODEC_READ_WRITE <= '0';
			spwc_mm_write_registers.TX_BACKDOOR_DATA_REGISTER.CODEC_SPW_FLAG      <= '0';
			spwc_mm_write_registers.TX_BACKDOOR_DATA_REGISTER.CODEC_SPW_DATA      <= (others => '0');

			cnt <= 0;

		elsif rising_edge(clk_100) then

			spwc_mm_write_registers.INTERFACE_CONTROL_REGISTER.BACKDOOR_MODE_BIT <= '1' after 5 us;

			spwc_mm_write_registers.SPW_LINK_MODE_REGISTER.AUTOSTART_BIT  <= '1' after 10 us;
			spwc_mm_write_registers.SPW_LINK_MODE_REGISTER.LINK_START_BIT <= '1' after 15 us;

			cnt <= cnt + 1;

			spwc_mm_write_registers.RX_BACKDOOR_CONTROL_REGISTER.CODEC_READ_WRITE <= '0';
			spwc_mm_write_registers.TX_BACKDOOR_CONTROL_REGISTER.CODEC_READ_WRITE <= '0';
			spwc_mm_write_registers.TX_BACKDOOR_DATA_REGISTER.CODEC_SPW_FLAG      <= '0';
			spwc_mm_write_registers.TX_BACKDOOR_DATA_REGISTER.CODEC_SPW_DATA      <= (others => '0');

			case (cnt) is

				when 10000 to 10001 =>
					if (spwc_mm_read_registers.TX_BACKDOOR_STATUS_REGISTER.CODEC_DATAVALID_READY = '1') then
						spwc_mm_write_registers.TX_BACKDOOR_CONTROL_REGISTER.CODEC_READ_WRITE <= '1';
						spwc_mm_write_registers.TX_BACKDOOR_DATA_REGISTER.CODEC_SPW_FLAG      <= '0';
						spwc_mm_write_registers.TX_BACKDOOR_DATA_REGISTER.CODEC_SPW_DATA      <= x"54";
					end if;
					if (spwc_mm_read_registers.RX_BACKDOOR_STATUS_REGISTER.CODEC_DATAVALID_READY = '1') then
						spwc_mm_write_registers.RX_BACKDOOR_CONTROL_REGISTER.CODEC_READ_WRITE <= '1';
					end if;

				when 10005 to 10006 =>
					if (spwc_mm_read_registers.TX_BACKDOOR_STATUS_REGISTER.CODEC_DATAVALID_READY = '1') then
						spwc_mm_write_registers.TX_BACKDOOR_CONTROL_REGISTER.CODEC_READ_WRITE <= '1';
						spwc_mm_write_registers.TX_BACKDOOR_DATA_REGISTER.CODEC_SPW_FLAG      <= '0';
						spwc_mm_write_registers.TX_BACKDOOR_DATA_REGISTER.CODEC_SPW_DATA      <= x"84";
					end if;
					if (spwc_mm_read_registers.RX_BACKDOOR_STATUS_REGISTER.CODEC_DATAVALID_READY = '1') then
						spwc_mm_write_registers.RX_BACKDOOR_CONTROL_REGISTER.CODEC_READ_WRITE <= '1';
					end if;

				when 10010 to 10011 =>
					if (spwc_mm_read_registers.TX_BACKDOOR_STATUS_REGISTER.CODEC_DATAVALID_READY = '1') then
						spwc_mm_write_registers.TX_BACKDOOR_CONTROL_REGISTER.CODEC_READ_WRITE <= '1';
						spwc_mm_write_registers.TX_BACKDOOR_DATA_REGISTER.CODEC_SPW_FLAG      <= '0';
						spwc_mm_write_registers.TX_BACKDOOR_DATA_REGISTER.CODEC_SPW_DATA      <= x"EF";
					end if;
					if (spwc_mm_read_registers.RX_BACKDOOR_STATUS_REGISTER.CODEC_DATAVALID_READY = '1') then
						spwc_mm_write_registers.RX_BACKDOOR_CONTROL_REGISTER.CODEC_READ_WRITE <= '1';
					end if;

				when 10015 to 10016 =>
					if (spwc_mm_read_registers.TX_BACKDOOR_STATUS_REGISTER.CODEC_DATAVALID_READY = '1') then
						spwc_mm_write_registers.TX_BACKDOOR_CONTROL_REGISTER.CODEC_READ_WRITE <= '1';
						spwc_mm_write_registers.TX_BACKDOOR_DATA_REGISTER.CODEC_SPW_FLAG      <= '0';
						spwc_mm_write_registers.TX_BACKDOOR_DATA_REGISTER.CODEC_SPW_DATA      <= x"03";
					end if;
					if (spwc_mm_read_registers.RX_BACKDOOR_STATUS_REGISTER.CODEC_DATAVALID_READY = '1') then
						spwc_mm_write_registers.RX_BACKDOOR_CONTROL_REGISTER.CODEC_READ_WRITE <= '1';
					end if;

				when 10020 to 10021 =>
					if (spwc_mm_read_registers.TX_BACKDOOR_STATUS_REGISTER.CODEC_DATAVALID_READY = '1') then
						spwc_mm_write_registers.TX_BACKDOOR_CONTROL_REGISTER.CODEC_READ_WRITE <= '1';
						spwc_mm_write_registers.TX_BACKDOOR_DATA_REGISTER.CODEC_SPW_FLAG      <= '0';
						spwc_mm_write_registers.TX_BACKDOOR_DATA_REGISTER.CODEC_SPW_DATA      <= x"01";
					end if;
					if (spwc_mm_read_registers.RX_BACKDOOR_STATUS_REGISTER.CODEC_DATAVALID_READY = '1') then
						spwc_mm_write_registers.RX_BACKDOOR_CONTROL_REGISTER.CODEC_READ_WRITE <= '1';
					end if;

				when 10025 to 10026 =>
					if (spwc_mm_read_registers.TX_BACKDOOR_STATUS_REGISTER.CODEC_DATAVALID_READY = '1') then
						spwc_mm_write_registers.TX_BACKDOOR_CONTROL_REGISTER.CODEC_READ_WRITE <= '1';
						spwc_mm_write_registers.TX_BACKDOOR_DATA_REGISTER.CODEC_SPW_FLAG      <= '0';
						spwc_mm_write_registers.TX_BACKDOOR_DATA_REGISTER.CODEC_SPW_DATA      <= x"75";
					end if;
					if (spwc_mm_read_registers.RX_BACKDOOR_STATUS_REGISTER.CODEC_DATAVALID_READY = '1') then
						spwc_mm_write_registers.RX_BACKDOOR_CONTROL_REGISTER.CODEC_READ_WRITE <= '1';
					end if;

				when 10030 to 10031 =>
					if (spwc_mm_read_registers.TX_BACKDOOR_STATUS_REGISTER.CODEC_DATAVALID_READY = '1') then
						spwc_mm_write_registers.TX_BACKDOOR_CONTROL_REGISTER.CODEC_READ_WRITE <= '1';
						spwc_mm_write_registers.TX_BACKDOOR_DATA_REGISTER.CODEC_SPW_FLAG      <= '0';
						spwc_mm_write_registers.TX_BACKDOOR_DATA_REGISTER.CODEC_SPW_DATA      <= x"5E";
					end if;
					if (spwc_mm_read_registers.RX_BACKDOOR_STATUS_REGISTER.CODEC_DATAVALID_READY = '1') then
						spwc_mm_write_registers.RX_BACKDOOR_CONTROL_REGISTER.CODEC_READ_WRITE <= '1';
					end if;

				when 10035 to 10036 =>
					if (spwc_mm_read_registers.TX_BACKDOOR_STATUS_REGISTER.CODEC_DATAVALID_READY = '1') then
						spwc_mm_write_registers.TX_BACKDOOR_CONTROL_REGISTER.CODEC_READ_WRITE <= '1';
						spwc_mm_write_registers.TX_BACKDOOR_DATA_REGISTER.CODEC_SPW_FLAG      <= '0';
						spwc_mm_write_registers.TX_BACKDOOR_DATA_REGISTER.CODEC_SPW_DATA      <= x"01";
					end if;
					if (spwc_mm_read_registers.RX_BACKDOOR_STATUS_REGISTER.CODEC_DATAVALID_READY = '1') then
						spwc_mm_write_registers.RX_BACKDOOR_CONTROL_REGISTER.CODEC_READ_WRITE <= '1';
					end if;

				when 10040 to 10041 =>
					if (spwc_mm_read_registers.TX_BACKDOOR_STATUS_REGISTER.CODEC_DATAVALID_READY = '1') then
						spwc_mm_write_registers.TX_BACKDOOR_CONTROL_REGISTER.CODEC_READ_WRITE <= '1';
						spwc_mm_write_registers.TX_BACKDOOR_DATA_REGISTER.CODEC_SPW_FLAG      <= '0';
						spwc_mm_write_registers.TX_BACKDOOR_DATA_REGISTER.CODEC_SPW_DATA      <= x"45";
					end if;
					if (spwc_mm_read_registers.RX_BACKDOOR_STATUS_REGISTER.CODEC_DATAVALID_READY = '1') then
						spwc_mm_write_registers.RX_BACKDOOR_CONTROL_REGISTER.CODEC_READ_WRITE <= '1';
					end if;

				when 10045 to 10046 =>
					if (spwc_mm_read_registers.TX_BACKDOOR_STATUS_REGISTER.CODEC_DATAVALID_READY = '1') then
						spwc_mm_write_registers.TX_BACKDOOR_CONTROL_REGISTER.CODEC_READ_WRITE <= '1';
						spwc_mm_write_registers.TX_BACKDOOR_DATA_REGISTER.CODEC_SPW_FLAG      <= '0';
						spwc_mm_write_registers.TX_BACKDOOR_DATA_REGISTER.CODEC_SPW_DATA      <= x"25";
					end if;
					if (spwc_mm_read_registers.RX_BACKDOOR_STATUS_REGISTER.CODEC_DATAVALID_READY = '1') then
						spwc_mm_write_registers.RX_BACKDOOR_CONTROL_REGISTER.CODEC_READ_WRITE <= '1';
					end if;

				when 10050 to 10051 =>
					if (spwc_mm_read_registers.TX_BACKDOOR_STATUS_REGISTER.CODEC_DATAVALID_READY = '1') then
						spwc_mm_write_registers.TX_BACKDOOR_CONTROL_REGISTER.CODEC_READ_WRITE <= '1';
						spwc_mm_write_registers.TX_BACKDOOR_DATA_REGISTER.CODEC_SPW_FLAG      <= '0';
						spwc_mm_write_registers.TX_BACKDOOR_DATA_REGISTER.CODEC_SPW_DATA      <= x"76";
					end if;
					if (spwc_mm_read_registers.RX_BACKDOOR_STATUS_REGISTER.CODEC_DATAVALID_READY = '1') then
						spwc_mm_write_registers.RX_BACKDOOR_CONTROL_REGISTER.CODEC_READ_WRITE <= '1';
					end if;

				when others => null;

			end case;

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
