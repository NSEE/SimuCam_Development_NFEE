-- COMM_TOPFILE.vhd

-- This file was auto-generated as a prototype implementation of a module
-- created in component editor.  It ties off all outputs to ground and
-- ignores all inputs.  It needs to be edited to make it do something
-- useful.
-- 
-- This file will not be automatically regenerated.  You should check it in
-- to your version control system if you want to keep it.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.comm_avalon_mm_pkg.all;
use work.comm_mm_registers_pkg.all;
use work.comm_avalon_burst_pkg.all;
use work.comm_burst_registers_pkg.all;
use work.comm_avs_controller_pkg.all;
use work.comm_bus_controller_pkg.all;
use work.spwc_codec_pkg.all;

entity comm_component_ent is
	port(
		conduit_end_spw_si                    : in  std_logic                     := '0'; --          --               conduit_end.spw_si_signal
		conduit_end_spw_di                    : in  std_logic                     := '0'; --          --                          .spw_di_signal
		conduit_end_spw_do                    : out std_logic; --                                     --                          .spw_do_signal
		conduit_end_spw_so                    : out std_logic; --                                     --                          .spw_so_signal
		reset_sink_reset                      : in  std_logic                     := '0'; --          --                reset_sink.reset
		interrupt_sender_irq                  : out std_logic; --                                     --          interrupt_sender.irq
--		avalon_mm_data_slave_address          : in  std_logic_vector(7 downto 0)  := (others => '0'); --      avalon_mm_data_slave.address
		avalon_mm_data_slave_address          : in  std_logic_vector(25 downto 0)  := (others => '0'); --     avalon_mm_data_slave.address
		avalon_mm_data_slave_read             : in  std_logic                     := '0'; --          --                          .read
		avalon_mm_data_slave_readdata         : out std_logic_vector(63 downto 0); --                 --                          .readdata
		avalon_mm_data_slave_waitrequest      : out std_logic; --                                     --                          .waitrequest
		avalon_mm_data_slave_burstcount       : in  std_logic_vector(7 downto 0)  := (others => '0'); --                          .burstcount
		avalon_mm_data_slave_byteenable       : in  std_logic_vector(7 downto 0)  := (others => '0'); --                          .byteenable
		avalon_mm_data_slave_readdatavalid    : out std_logic; --                                     --                          .readdatavalid
		avalon_mm_data_slave_write            : in  std_logic                     := '0'; --          --                          .write
		avalon_mm_data_slave_writedata        : in  std_logic_vector(63 downto 0) := (others => '0'); --                          .writedata
		avalon_mm_registers_slave_address     : in  std_logic_vector(7 downto 0)  := (others => '0'); -- avalon_mm_registers_slave.address
		avalon_mm_registers_slave_write       : in  std_logic                     := '0'; --          --                          .write
		avalon_mm_registers_slave_writedata   : in  std_logic_vector(31 downto 0) := (others => '0'); --                          .writedata
		avalon_mm_registers_slave_read        : in  std_logic                     := '0'; --          --                          .read
		avalon_mm_registers_slave_readdata    : out std_logic_vector(31 downto 0); --                 --                          .readdata
		avalon_mm_registers_slave_waitrequest : out std_logic; --                                     --                          .waitrequest
		clock_sink_100_clk100                 : in  std_logic                     := '0'; --          --            clock_sink_100.clk100
		clock_sink_200_clk200                 : in  std_logic                     := '0' --           --            clock_sink_200.clk200
	);
end entity comm_component_ent;

architecture comm_component_arc of comm_component_ent is

	-- Clocks and Reset alias
	alias avalon_clock is clock_sink_100_clk100;
	alias codec_clock is clock_sink_200_clk200;
	alias reset is reset_sink_reset;

	-- Signals for Modules Interrupts
	signal spwc_interrupt_sig : std_logic := '0';
	signal tran_interrupt_sig : std_logic := '0';

	-- Signals for Avalon MM for Modules Registers
	signal comm_avalon_mm_write_inputs_sig  : comm_avalon_mm_write_inputs_type;
	signal comm_avalon_mm_write_outputs_sig : comm_avalon_mm_write_outputs_type;
	signal comm_mm_write_registers_sig      : comm_mm_write_registers_type;
	signal comm_avalon_mm_read_inputs_sig   : comm_avalon_mm_read_inputs_type;
	signal comm_avalon_mm_read_outputs_sig  : comm_avalon_mm_read_outputs_type;
	signal comm_mm_read_registers_sig       : comm_mm_read_registers_type;

	-- Signals for Avalon MM for Modules Data
	signal comm_avalon_burst_write_inputs_sig  : comm_avalon_burst_write_inputs_type;
	signal comm_avalon_burst_write_outputs_sig : comm_avalon_burst_write_outputs_type;
	signal comm_burst_write_registers_sig      : comm_burst_write_registers_type;
	signal comm_avalon_burst_read_inputs_sig   : comm_avalon_burst_read_inputs_type;
	signal comm_avalon_burst_read_outputs_sig  : comm_avalon_burst_read_outputs_type;
	signal comm_burst_read_registers_sig       : comm_burst_read_registers_type;
	signal comm_avsdc_avs_inputs_sig           : comm_avsdc_avs_inputs_type;
	signal comm_avsdc_avs_outputs_sig          : comm_avsdc_avs_outputs_type;

	-- Signals for RX Data Bus for Modules
	signal comm_rx_bc_bus_inputs_sig  : comm_rx_bc_bus_inputs_type;
	signal comm_rx_bc_bus_outputs_sig : comm_rx_bc_bus_outputs_type;

	-- Signals for TX Data Bus for Modules
	signal comm_tx_bc_bus_inputs_sig  : comm_tx_bc_bus_inputs_type;
	signal comm_tx_bc_bus_outputs_sig : comm_tx_bc_bus_outputs_type;

	-- Signals for SpaceWire DS Encoding
	signal spwc_codec_ds_encoding_rx_in_sig  : spwc_codec_ds_encoding_rx_in_type;
	signal spwc_codec_ds_encoding_tx_out_sig : spwc_codec_ds_encoding_tx_out_type;

begin

	-- Avalon MM Registers Write Component
	comm_avalon_mm_write_ent_inst : entity work.comm_avalon_mm_write_ent
		port map(
			clk                => avalon_clock,
			rst                => reset,
			avalon_mm_inputs   => comm_avalon_mm_write_inputs_sig,
			avalon_mm_outputs  => comm_avalon_mm_write_outputs_sig,
			mm_write_registers => comm_mm_write_registers_sig
		);

		-- Avalon MM Registers Read Component
	comm_avalon_mm_read_ent_inst : entity work.comm_avalon_mm_read_ent
		port map(
			clk                => avalon_clock,
			rst                => reset,
			avalon_mm_inputs   => comm_avalon_mm_read_inputs_sig,
			avalon_mm_outputs  => comm_avalon_mm_read_outputs_sig,
			mm_write_registers => comm_mm_write_registers_sig,
			mm_read_registers  => comm_mm_read_registers_sig
		);

		-- Avalon MM Data Write Component
	comm_avalon_burst_write_ent_inst : entity work.comm_avalon_burst_write_ent
		port map(
			clk                         => avalon_clock,
			rst                         => reset,
			avalon_burst_inputs         => comm_avalon_burst_write_inputs_sig,
			avalon_burst_outputs        => comm_avalon_burst_write_outputs_sig,
			burst_write_registers       => comm_burst_write_registers_sig,
			comm_avs_controller_inputs  => comm_avsdc_avs_outputs_sig.TX,
			comm_avs_controller_outputs => comm_avsdc_avs_inputs_sig.TX
		);

		-- Avalon MM Data Read Component
	comm_avalon_burst_read_ent_inst : entity work.comm_avalon_burst_read_ent
		port map(
			clk                         => avalon_clock,
			rst                         => reset,
			avalon_burst_inputs         => comm_avalon_burst_read_inputs_sig,
			avalon_burst_outputs        => comm_avalon_burst_read_outputs_sig,
			burst_read_registers        => comm_burst_read_registers_sig,
			comm_avs_controller_inputs  => comm_avsdc_avs_outputs_sig.RX,
			comm_avs_controller_outputs => comm_avsdc_avs_inputs_sig.RX
		);

		-- SPWC (SpaceWire Communication) Interface Module
	spwc_topfile_ent_inst : entity work.spwc_topfile_ent
		port map(
			clk100                            => avalon_clock,
			clk200                            => codec_clock,
			rst                               => reset,
			spwc_interrupt_outputs            => spwc_interrupt_sig,
			spwc_mm_write_registers_inputs    => comm_mm_write_registers_sig.SPWC,
			spwc_mm_read_registers_outputs    => comm_mm_read_registers_sig.SPWC,
			spwc_rx_bc_bus_inputs             => comm_rx_bc_bus_outputs_sig.SPWC_IN,
			spwc_rx_bc_bus_outputs            => comm_rx_bc_bus_inputs_sig.SPWC_OUT,
			spwc_tx_bc_bus_inputs             => comm_tx_bc_bus_outputs_sig.SPWC_IN,
			spwc_tx_bc_bus_outputs            => comm_tx_bc_bus_inputs_sig.SPWC_OUT,
			spwc_codec_ds_encoding_rx_inputs  => spwc_codec_ds_encoding_rx_in_sig,
			spwc_codec_ds_encoding_tx_outputs => spwc_codec_ds_encoding_tx_out_sig
		);

		-- TRAN (Transparent) Interface Module
	tran_topfile_ent_inst : entity work.tran_topfile_ent
		port map(
			clk                               => avalon_clock,
			rst                               => reset,
			tran_interrupt_outputs            => tran_interrupt_sig,
			tran_mm_write_registers_inputs    => comm_mm_write_registers_sig.TRAN,
			tran_mm_read_registers_outputs    => comm_mm_read_registers_sig.TRAN,
			tran_burst_write_registers_inputs => comm_burst_write_registers_sig.TRAN,
			tran_burst_read_registers_outputs => comm_burst_read_registers_sig.TRAN,
			tran_avsdc_rx_avs_inputs          => comm_avsdc_avs_inputs_sig.RX.TRAN,
			tran_avsdc_rx_avs_outputs         => comm_avsdc_avs_outputs_sig.RX.TRAN,
			tran_avsdc_tx_avs_inputs          => comm_avsdc_avs_inputs_sig.TX.TRAN,
			tran_avsdc_tx_avs_outputs         => comm_avsdc_avs_outputs_sig.TX.TRAN,
			tran_rx_bc_bus_inputs             => comm_rx_bc_bus_outputs_sig.TRAN_IN,
			tran_rx_bc_bus_outputs            => comm_rx_bc_bus_inputs_sig.TRAN_OUT,
			tran_tx_bc_bus_inputs             => comm_tx_bc_bus_outputs_sig.TRAN_IN,
			tran_tx_bc_bus_outputs            => comm_tx_bc_bus_inputs_sig.TRAN_OUT
		);

		-- RX (SpaceWire --> Simucam) Data Bus Controller
	comm_rx_bus_controller_ent_inst : entity work.comm_rx_bus_controller_ent
		port map(
			comm_rx_bc_bus_inputs  => comm_rx_bc_bus_inputs_sig,
			comm_rx_bc_bus_outputs => comm_rx_bc_bus_outputs_sig
		);

		-- TX (Simucam --> SpaceWire) Data Bus Controller
	comm_tx_bus_controller_ent_inst : entity work.comm_tx_bus_controller_ent
		port map(
			comm_tx_bc_bus_inputs  => comm_tx_bc_bus_inputs_sig,
			comm_tx_bc_bus_outputs => comm_tx_bc_bus_outputs_sig
		);

		--	reset_procedure_proc : process(reset) is
		--	begin
		--		if (reset = '1') then
		--		else
		--		end if;
		--	end process reset_procedure_proc;

		-- Modules Registers Avalon MM Write input Signals assignments and port mapping
	comm_avalon_mm_write_inputs_sig.address   <= avalon_mm_registers_slave_address;
	comm_avalon_mm_write_inputs_sig.write     <= avalon_mm_registers_slave_write;
	comm_avalon_mm_write_inputs_sig.writedata <= avalon_mm_registers_slave_writedata;

	-- Modules Registers Avalon MM Read input Signals assignments and port mapping
	comm_avalon_mm_read_inputs_sig.address <= avalon_mm_registers_slave_address;
	comm_avalon_mm_read_inputs_sig.read    <= avalon_mm_registers_slave_read;

	-- Modules Registers Avalon MM Read output Signals assignments and port mapping
	avalon_mm_registers_slave_readdata <= comm_avalon_mm_read_outputs_sig.readdata;

	-- Modules Registers Avalon MM output Signals assignments and port mapping
	avalon_mm_registers_slave_waitrequest <= ((comm_avalon_mm_write_outputs_sig.waitrequest) and (comm_avalon_mm_read_outputs_sig.waitrequest)) when (reset = '0') else ('1');

	-- Modules Data Avalon MM Write input Signals assignments and port mapping
	comm_avalon_burst_write_inputs_sig.address    <= avalon_mm_data_slave_address;
	comm_avalon_burst_write_inputs_sig.burstcount <= avalon_mm_data_slave_burstcount;
	comm_avalon_burst_write_inputs_sig.byteenable <= avalon_mm_data_slave_byteenable;
	comm_avalon_burst_write_inputs_sig.write      <= avalon_mm_data_slave_write;
	comm_avalon_burst_write_inputs_sig.writedata  <= avalon_mm_data_slave_writedata;

	-- Modules Data Avalon MM Read input Signals assignments and port mapping
	comm_avalon_burst_read_inputs_sig.address    <= avalon_mm_data_slave_address;
	comm_avalon_burst_read_inputs_sig.burstcount <= avalon_mm_data_slave_burstcount;
	comm_avalon_burst_read_inputs_sig.byteenable <= avalon_mm_data_slave_byteenable;
	comm_avalon_burst_read_inputs_sig.read       <= avalon_mm_data_slave_read;

	-- Modules Data Avalon MM Read output Signals assignments and port mapping
	avalon_mm_data_slave_readdata      <= comm_avalon_burst_read_outputs_sig.readdata;
	avalon_mm_data_slave_readdatavalid <= comm_avalon_burst_read_outputs_sig.readdatavalid;

	-- Modules Data Avalon MM output Signals assignments and port mapping
	avalon_mm_data_slave_waitrequest <= ((comm_avalon_burst_write_outputs_sig.waitrequest) and (comm_avalon_burst_read_outputs_sig.waitrequest)) when (reset = '0') else ('1');

	-- SpaceWire DS enconding input Signals assignments and port mapping
	spwc_codec_ds_encoding_rx_in_sig.spw_di <= conduit_end_spw_di;
	spwc_codec_ds_encoding_rx_in_sig.spw_si <= conduit_end_spw_si;

	-- SpaceWire DS enconding output Signals assignments and port mapping
	conduit_end_spw_do <= spwc_codec_ds_encoding_tx_out_sig.spw_do;
	conduit_end_spw_so <= spwc_codec_ds_encoding_tx_out_sig.spw_so;

	-- Modules Interrupts Signals assignments and port mapping
	interrupt_sender_irq <= (spwc_interrupt_sig) or (tran_interrupt_sig);

end architecture comm_component_arc;    -- of comm_component_ent
