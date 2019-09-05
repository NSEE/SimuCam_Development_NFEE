-- new_component.vhd

-- This file was auto-generated as a prototype implementation of a module
-- created in component editor.  It ties off all outputs to ground and
-- ignores all inputs.  It needs to be edited to make it do something
-- useful.
-- 
-- This file will not be automatically regenerated.  You should check it in
-- to your version control system if you want to keep it.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.pgen_avalon_burst_pkg.all;
use work.pgen_avalon_mm_pkg.all;
use work.pgen_burst_registers_pkg.all;
use work.pgen_controller_pkg.all;
use work.pgen_data_fifo_pkg.all;
use work.pgen_mm_registers_pkg.all;
use work.pgen_pattern_pkg.all;
use work.pgen_pipeline_fifo_pkg.all;

entity pgen_component_ent is
	port(
		clock_sink_clk100                     : in  std_logic                     := '0'; --           -- clock_sink.clk
		reset_sink_reset                      : in  std_logic                     := '0'; --           -- reset_sink.reset
--		avalon_mm_data_slave_address          : in  std_logic_vector(7 downto 0)  := (others => '0');  -- avalon_mm_data_slave.address
		avalon_mm_data_slave_address          : in  std_logic_vector(25 downto 0)  := (others => '0'); -- avalon_mm_data_slave.address
		avalon_mm_data_slave_read             : in  std_logic                     := '0'; --           --                     .read
		avalon_mm_data_slave_readdata         : out std_logic_vector(63 downto 0); --                  --                     .readdata
		avalon_mm_data_slave_waitrequest      : out std_logic; --                                      --                     .waitrequest
		avalon_mm_data_slave_burstcount       : in  std_logic_vector(7 downto 0)  := (others => '0');  --                     .burstcount
		avalon_mm_data_slave_byteenable       : in  std_logic_vector(7 downto 0)  := (others => '0');  --                     .byteenable
		avalon_mm_data_slave_readdatavalid    : out std_logic; --                                      --                     .readdatavalid
		avalon_mm_registers_slave_address     : in  std_logic_vector(7 downto 0)  := (others => '0');  -- avalon_mm_registers_slave.address
		avalon_mm_registers_slave_write       : in  std_logic                     := '0'; --           --                          .write
		avalon_mm_registers_slave_writedata   : in  std_logic_vector(31 downto 0) := (others => '0');  --                          .writedata
		avalon_mm_registers_slave_read        : in  std_logic                     := '0'; --           --                          .read
		avalon_mm_registers_slave_readdata    : out std_logic_vector(31 downto 0); --                  --                          .readdata
		avalon_mm_registers_slave_waitrequest : out std_logic --                                       --                          .waitrequest
	);
end entity pgen_component_ent;

architecture pgen_component_arc of pgen_component_ent is

	alias avalon_clock is clock_sink_clk100;
	alias reset is reset_sink_reset;

	signal waitrequest_reset_signal : std_logic;

	signal pgen_avalon_mm_write_inputs_sig  : pgen_avalon_mm_write_inputs_type;
	signal pgen_avalon_mm_write_outputs_sig : pgen_avalon_mm_write_outputs_type;

	signal pgen_avalon_mm_read_inputs_sig  : pgen_avalon_mm_read_inputs_type;
	signal pgen_avalon_mm_read_outputs_sig : pgen_avalon_mm_read_outputs_type;

	signal pgen_mm_write_registers_sig : pgen_mm_write_registers_type;
	signal pgen_mm_read_registers_sig  : pgen_mm_read_registers_type;

	signal pgen_avalon_burst_read_inputs_sig  : pgen_avalon_burst_read_inputs_type;
	signal pgen_avalon_burst_read_outputs_sig : pgen_avalon_burst_read_outputs_type;

	signal pgen_burst_read_registers_sig : pgen_burst_read_registers_type;

	signal pgen_controller_inputs_sig  : pgen_controller_inputs_type;
	signal pgen_controller_outputs_sig : pgen_controller_outputs_type;

begin

	pgen_avalon_mm_write_ent_inst : entity work.pgen_avalon_mm_write_ent
		port map(
			clk                => avalon_clock,
			rst                => reset,
			avalon_mm_inputs   => pgen_avalon_mm_write_inputs_sig,
			avalon_mm_outputs  => pgen_avalon_mm_write_outputs_sig,
			mm_write_registers => pgen_mm_write_registers_sig
		);

	pgen_avalon_mm_read_ent_inst : entity work.pgen_avalon_mm_read_ent
		port map(
			clk                => avalon_clock,
			rst                => reset,
			avalon_mm_inputs   => pgen_avalon_mm_read_inputs_sig,
			avalon_mm_outputs  => pgen_avalon_mm_read_outputs_sig,
			mm_write_registers => pgen_mm_write_registers_sig,
			mm_read_registers  => pgen_mm_read_registers_sig
		);

	pgen_avalon_burst_read_ent_inst : entity work.pgen_avalon_burst_read_ent
		port map(
			clk                     => avalon_clock,
			rst                     => reset,
			avalon_burst_inputs     => pgen_avalon_burst_read_inputs_sig,
			avalon_burst_outputs    => pgen_avalon_burst_read_outputs_sig,
			burst_read_registers    => pgen_burst_read_registers_sig,
			pgen_controller_outputs => pgen_controller_outputs_sig,
			pgen_controller_inputs  => pgen_controller_inputs_sig
		);

	pgen_controller_ent_inst : entity work.pgen_controller_ent
		port map(
			clk                       => avalon_clock,
			rst                       => reset,
			pgen_mm_write_registers   => pgen_mm_write_registers_sig,
			pgen_mm_read_registers    => pgen_mm_read_registers_sig,
			pgen_burst_read_registers => pgen_burst_read_registers_sig,
			pgen_controller_inputs    => pgen_controller_inputs_sig,
			pgen_controller_outputs   => pgen_controller_outputs_sig
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
	pgen_avalon_mm_write_inputs_sig.address   <= avalon_mm_registers_slave_address;
	pgen_avalon_mm_write_inputs_sig.write     <= avalon_mm_registers_slave_write;
	pgen_avalon_mm_write_inputs_sig.writedata <= avalon_mm_registers_slave_writedata;
	pgen_avalon_mm_read_inputs_sig.address    <= avalon_mm_registers_slave_address;
	pgen_avalon_mm_read_inputs_sig.read       <= avalon_mm_registers_slave_read;
	avalon_mm_registers_slave_readdata        <= pgen_avalon_mm_read_outputs_sig.readdata;
	avalon_mm_registers_slave_waitrequest     <= (waitrequest_reset_signal) or ((pgen_avalon_mm_write_outputs_sig.waitrequest) and (pgen_avalon_mm_read_outputs_sig.waitrequest));

	pgen_avalon_burst_read_inputs_sig.address    <= avalon_mm_data_slave_address;
	pgen_avalon_burst_read_inputs_sig.read       <= avalon_mm_data_slave_read;
	pgen_avalon_burst_read_inputs_sig.byteenable <= avalon_mm_data_slave_byteenable;
	pgen_avalon_burst_read_inputs_sig.burstcount <= avalon_mm_data_slave_burstcount;
	avalon_mm_data_slave_readdata                <= pgen_avalon_burst_read_outputs_sig.readdata;
	avalon_mm_data_slave_waitrequest             <= (waitrequest_reset_signal) or (pgen_avalon_burst_read_outputs_sig.waitrequest);
	avalon_mm_data_slave_readdatavalid           <= pgen_avalon_burst_read_outputs_sig.readdatavalid;

end architecture pgen_component_arc;    -- of pgen_component_ent
