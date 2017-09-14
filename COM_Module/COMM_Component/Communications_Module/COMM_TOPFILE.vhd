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

use work.spwc_avalon_mm_pkg.all;
use work.tran_avalon_mm_pkg.all;
use work.tran_avalon_burst_pkg.all;
use work.spwc_bus_controller_pkg.all;
use work.tran_bus_controller_pkg.all;
use work.spwc_codec_pkg.all;

entity comm_component_ent is
	port(
		conduit_end_spw_si                    : in  std_logic                     := '0'; --          --               conduit_end.spw_si_signal
		conduit_end_spw_di                    : in  std_logic                     := '0'; --          --                          .spw_di_signal
		conduit_end_spw_do                    : out std_logic; --                                     --                          .spw_do_signal
		conduit_end_spw_so                    : out std_logic; --                                     --                          .spw_so_signal
		reset_sink_reset                      : in  std_logic                     := '0'; --          --                reset_sink.reset
		interrupt_sender_irq                  : out std_logic; --                                     --          interrupt_sender.irq
		avalon_mm_data_slave_address          : in  std_logic_vector(7 downto 0)  := (others => '0'); --      avalon_mm_data_slave.address
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

	alias avalon_clock is clock_sink_100_clk100;
	alias codec_clock is clock_sink_200_clk200;
	alias reset is reset_sink_reset;

	signal waitrequest_reset_signal : std_logic;

	signal spwc_interrupt_sig : std_logic := '0';
	signal tran_interrupt_sig : std_logic := '0';

	signal spwc_avalon_mm_write_inputs_sig  : spwc_avalon_mm_write_inputs_type;
	signal spwc_avalon_mm_write_outputs_sig : spwc_avalon_mm_write_outputs_type;
	signal spwc_avalon_mm_read_inputs_sig   : spwc_avalon_mm_read_inputs_type;
	signal spwc_avalon_mm_read_outputs_sig  : spwc_avalon_mm_read_outputs_type;

	signal tran_avalon_mm_write_inputs_sig  : tran_avalon_mm_write_inputs_type;
	signal tran_avalon_mm_write_outputs_sig : tran_avalon_mm_write_outputs_type;
	signal tran_avalon_mm_read_inputs_sig   : tran_avalon_mm_read_inputs_type;
	signal tran_avalon_mm_read_outputs_sig  : tran_avalon_mm_read_outputs_type;

	signal tran_avalon_burst_write_inputs_sig  : tran_avalon_burst_write_inputs_type;
	signal tran_avalon_burst_write_outputs_sig : tran_avalon_burst_write_outputs_type;
	signal tran_avalon_burst_read_inputs_sig   : tran_avalon_burst_read_inputs_type;
	signal tran_avalon_burst_read_outputs_sig  : tran_avalon_burst_read_outputs_type;

	signal spwc_rx_bc_read_bus_outputs_sig : spwc_bc_read_bus_outputs_type;
	signal spwc_rx_bc_read_bus_inputs_sig  : spwc_bc_read_bus_inputs_type;
	signal tran_rx_bc_read_bus_outputs_sig : tran_bc_read_bus_outputs_type;
	signal tran_rx_bc_read_bus_inputs_sig  : tran_bc_read_bus_inputs_type;

	signal spwc_tx_bc_write_bus_outputs_sig : spwc_bc_write_bus_outputs_type;
	signal spwc_tx_bc_write_bus_inputs_sig  : spwc_bc_write_bus_inputs_type;
	signal tran_tx_bc_write_bus_outputs_sig : tran_bc_write_bus_outputs_type;
	signal tran_tx_bc_write_bus_inputs_sig  : tran_bc_write_bus_inputs_type;

	signal spwc_codec_ds_encoding_rx_in_sig  : spwc_codec_ds_encoding_rx_in_type;
	signal spwc_codec_ds_encoding_tx_out_sig : spwc_codec_ds_encoding_tx_out_type;

begin

	spwc_topfile_ent_inst : entity work.spwc_topfile_ent
		port map(
			clk100                        => avalon_clock,
			clk200                        => codec_clock,
			rst                           => reset,
			spwc_interrupt_outputs        => spwc_interrupt_sig,
			spwc_avalon_mm_write_inputs   => spwc_avalon_mm_write_inputs_sig,
			spwc_avalon_mm_write_outputs  => spwc_avalon_mm_write_outputs_sig,
			spwc_avalon_mm_read_inputs    => spwc_avalon_mm_read_inputs_sig,
			spwc_avalon_mm_read_outputs   => spwc_avalon_mm_read_outputs_sig,
			spwc_tx_bc_write_bus_inputs   => spwc_tx_bc_write_bus_inputs_sig,
			spwc_tx_bc_write_bus_outputs  => spwc_tx_bc_write_bus_outputs_sig,
			spwc_rx_bc_read_bus_inputs    => spwc_rx_bc_read_bus_inputs_sig,
			spwc_rx_bc_read_bus_outputs   => spwc_rx_bc_read_bus_outputs_sig,
			spwc_codec_ds_encoding_rx_in  => spwc_codec_ds_encoding_rx_in_sig,
			spwc_codec_ds_encoding_tx_out => spwc_codec_ds_encoding_tx_out_sig
		);

	tran_topfile_ent_inst : entity work.tran_topfile_ent
		port map(
			clk                             => avalon_clock,
			rst                             => reset,
			tran_interrupt_outputs          => tran_interrupt_sig,
			tran_avalon_mm_write_inputs     => tran_avalon_mm_write_inputs_sig,
			tran_avalon_mm_write_outputs    => tran_avalon_mm_write_outputs_sig,
			tran_avalon_mm_read_inputs      => tran_avalon_mm_read_inputs_sig,
			tran_avalon_mm_read_outputs     => tran_avalon_mm_read_outputs_sig,
			tran_avalon_burst_write_inputs  => tran_avalon_burst_write_inputs_sig,
			tran_avalon_burst_write_outputs => tran_avalon_burst_write_outputs_sig,
			tran_avalon_burst_read_inputs   => tran_avalon_burst_read_inputs_sig,
			tran_avalon_burst_read_outputs  => tran_avalon_burst_read_outputs_sig,
			tran_rx_bc_read_bus_inputs      => tran_rx_bc_read_bus_inputs_sig,
			tran_rx_bc_read_bus_outputs     => tran_rx_bc_read_bus_outputs_sig,
			tran_tx_bc_write_bus_inputs     => tran_tx_bc_write_bus_inputs_sig,
			tran_tx_bc_write_bus_outputs    => tran_tx_bc_write_bus_outputs_sig
		);

	comm_rx_bus_controller_ent_inst : entity work.comm_rx_bus_controller_ent
		port map(
			spwc_rx_bc_bus_outputs => spwc_rx_bc_read_bus_outputs_sig,
			spwc_rx_bc_bus_inputs  => spwc_rx_bc_read_bus_inputs_sig,
			tran_rx_bc_bus_outputs => tran_rx_bc_read_bus_outputs_sig,
			tran_rx_bc_bus_inputs  => tran_rx_bc_read_bus_inputs_sig
		);

	comm_tx_bus_controller_ent_inst : entity work.comm_tx_bus_controller_ent
		port map(
			spwc_tx_bc_bus_outputs => spwc_tx_bc_write_bus_outputs_sig,
			spwc_tx_bc_bus_inputs  => spwc_tx_bc_write_bus_inputs_sig,
			tran_tx_bc_bus_outputs => tran_tx_bc_write_bus_outputs_sig,
			tran_tx_bc_bus_inputs  => tran_tx_bc_write_bus_inputs_sig
		);

	reset_procedure_proc : process(reset) is
	begin
		if (reset = '1') then
			waitrequest_reset_signal <= '1';
		else
			waitrequest_reset_signal <= '0';
		end if;
	end process reset_procedure_proc;

	--Signals assignments and port mapping
	spwc_avalon_mm_write_inputs_sig.address   <= avalon_mm_registers_slave_address;
	spwc_avalon_mm_write_inputs_sig.write     <= avalon_mm_registers_slave_write;
	spwc_avalon_mm_write_inputs_sig.writedata <= avalon_mm_registers_slave_writedata;

	spwc_avalon_mm_read_inputs_sig.address <= avalon_mm_registers_slave_address;
	spwc_avalon_mm_read_inputs_sig.read    <= avalon_mm_registers_slave_read;

	tran_avalon_mm_write_inputs_sig.address   <= avalon_mm_registers_slave_address;
	tran_avalon_mm_write_inputs_sig.write     <= avalon_mm_registers_slave_write;
	tran_avalon_mm_write_inputs_sig.writedata <= avalon_mm_registers_slave_writedata;

	tran_avalon_mm_read_inputs_sig.address <= avalon_mm_registers_slave_address;
	tran_avalon_mm_read_inputs_sig.read    <= avalon_mm_registers_slave_read;

	avalon_mm_registers_slave_waitrequest <= (waitrequest_reset_signal) or ((spwc_avalon_mm_write_outputs_sig.waitrequest) and (spwc_avalon_mm_read_outputs_sig.waitrequest) and (tran_avalon_mm_write_outputs_sig.waitrequest) and (tran_avalon_mm_read_outputs_sig.waitrequest));

	avalon_mm_registers_slave_readdata <= ((spwc_avalon_mm_read_outputs_sig.readdata) or (tran_avalon_mm_read_outputs_sig.readdata));

	tran_avalon_burst_write_inputs_sig.address    <= avalon_mm_data_slave_address;
	tran_avalon_burst_write_inputs_sig.burstcount <= avalon_mm_data_slave_burstcount;
	tran_avalon_burst_write_inputs_sig.byteenable <= avalon_mm_data_slave_byteenable;
	tran_avalon_burst_write_inputs_sig.write      <= avalon_mm_data_slave_write;
	tran_avalon_burst_write_inputs_sig.writedata  <= avalon_mm_data_slave_writedata;

	tran_avalon_burst_read_inputs_sig.address    <= avalon_mm_data_slave_address;
	tran_avalon_burst_read_inputs_sig.burstcount <= avalon_mm_data_slave_burstcount;
	tran_avalon_burst_read_inputs_sig.byteenable <= avalon_mm_data_slave_byteenable;
	tran_avalon_burst_read_inputs_sig.read       <= avalon_mm_data_slave_read;
	avalon_mm_data_slave_readdata                <= tran_avalon_burst_read_outputs_sig.readdata;
	avalon_mm_data_slave_readdatavalid           <= tran_avalon_burst_read_outputs_sig.readdatavalid;

	avalon_mm_data_slave_waitrequest <= (waitrequest_reset_signal) or ((tran_avalon_burst_write_outputs_sig.waitrequest) and (tran_avalon_burst_read_outputs_sig.waitrequest));

	spwc_codec_ds_encoding_rx_in_sig.spw_di <= conduit_end_spw_di;
	spwc_codec_ds_encoding_rx_in_sig.spw_si <= conduit_end_spw_si;
	conduit_end_spw_do                      <= spwc_codec_ds_encoding_tx_out_sig.spw_do;
	conduit_end_spw_so                      <= spwc_codec_ds_encoding_tx_out_sig.spw_so;

	--Interrupt assingment
	interrupt_sender_irq <= (spwc_interrupt_sig) or (tran_interrupt_sig);

end architecture comm_component_arc;    -- of comm_component_ent
