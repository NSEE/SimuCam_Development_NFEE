-- new_component.vhd

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

entity new_component is
	generic (
		Clock_Frequency_MHz : integer := 200
	);
	port (
		reset_sink_reset            : in  std_logic                     := '0';             --          reset_sink.reset
		clock_sink_clk              : in  std_logic                     := '0';             --          clock_sink.clk
		avalon_slave_address        : in  std_logic_vector(7 downto 0)  := (others => '0'); --        avalon_slave.address
		avalon_slave_read           : in  std_logic                     := '0';             --                    .read
		avalon_slave_write          : in  std_logic                     := '0';             --                    .write
		avalon_slave_writedata      : in  std_logic_vector(31 downto 0) := (others => '0'); --                    .writedata
		avalon_slave_readdata       : out std_logic_vector(31 downto 0);                    --                    .readdata
		avalon_slave_waitrequest    : out std_logic;                                        --                    .waitrequest
		conduit_sync_signal_spwa    : out std_logic_vector(1 downto 0);                     -- conduit_sync_signal.conduit_sync_signal_spwa_signal
		conduit_sync_signal_spwb    : out std_logic_vector(1 downto 0);                     --                    .conduit_sync_signal_spwb_signal
		conduit_sync_signal_spwc    : out std_logic_vector(1 downto 0);                     --                    .conduit_sync_signal_spwc_signal
		conduit_sync_signal_spwd    : out std_logic_vector(1 downto 0);                     --                    .conduit_sync_signal_spwd_signal
		conduit_sync_signal_spwe    : out std_logic_vector(1 downto 0);                     --                    .conduit_sync_signal_spwe_signal
		conduit_sync_signal_spwf    : out std_logic_vector(1 downto 0);                     --                    .conduit_sync_signal_spwf_signal
		conduit_sync_signal_spwg    : out std_logic_vector(1 downto 0);                     --                    .conduit_sync_signal_spwg_signal
		conduit_sync_signal_spwh    : out std_logic_vector(1 downto 0);                     --                    .conduit_sync_signal_spwh_signal
		conduit_sync_signal_syncout : out std_logic_vector(1 downto 0);                     --                    .conduit_sync_signal_syncout_signal
		interrupt_sender_irq        : out std_logic                                         --    interrupt_sender.irq
	);
end entity new_component;

architecture rtl of new_component is
begin

	-- TODO: Auto-generated HDL template

	avalon_slave_readdata <= "00000000000000000000000000000000";

	avalon_slave_waitrequest <= '0';

	conduit_sync_signal_spwb <= "00";

	conduit_sync_signal_spwd <= "00";

	conduit_sync_signal_spwa <= "00";

	conduit_sync_signal_spwc <= "00";

	conduit_sync_signal_spwe <= "00";

	conduit_sync_signal_spwf <= "00";

	conduit_sync_signal_spwg <= "00";

	conduit_sync_signal_spwh <= "00";

	conduit_sync_signal_syncout <= "00";

	interrupt_sender_irq <= '0';

end architecture rtl; -- of new_component
