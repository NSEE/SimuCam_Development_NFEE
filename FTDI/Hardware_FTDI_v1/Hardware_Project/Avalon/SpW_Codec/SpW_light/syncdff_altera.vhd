--
--  Double flip-flop synchronizer.
--
--  This entity is used to safely capture asynchronous signals.
--
--  An implementation may assign additional constraints to this entity
--  in order to reduce the probability of meta-stability issues.
--  For example, an extra tight timing constraint could be placed on
--  the data path from syncdff_ff1 to syncdff_ff2 to ensure that
--  meta-stability of ff1 is resolved before ff2 captures the signal.
--

library ieee;
use ieee.std_logic_1164.all;

entity syncdff_altera is

    port (
        clk:        in  std_logic;          -- clock (destination domain)
        rst:        in  std_logic;          -- asynchronous reset, active-high
        di:         in  std_logic;          -- input data
        do:         out std_logic           -- output data
    );

    -- Turn off register replication in XST.
    -- Corsi : Altera
    -- http://quartushelp.altera.com/current/master.htm#mergedProjects/logicops/logicops/def_preserve_fanout_free_node.htm
    attribute noprune : boolean;
    attribute noprune of syncdff_altera : entity is true;

end entity syncdff_altera;

architecture syncdff_arch of syncdff_altera is

    -- flip-flops
    signal syncdff_ff1: std_ulogic := '0';
    signal syncdff_ff2: std_ulogic := '0';

    -- Turn of shift-register extraction in XST.
    -- Corsi : Altera
    -- http://quartushelp.altera.com/13.1/mergedProjects/logicops/logicops/def_auto_shift_register_recognition.htm
    attribute altera_attribute : string;
    attribute altera_attribute of syncdff_ff1 : signal is "-name auto_shift_register_recognition off";
    attribute altera_attribute of syncdff_ff2 : signal is "-name auto_shift_register_recognition off";

    -- Tell XST to place both flip-flops in the same slice.
    -- Corsi : Altera
    -- There is not an equivalent config. on Quartus. We need to set with timming constraints.
    -- http://stackoverflow.com/questions/25389877/how-can-i-achieve-something-similar-to-xilinx-rloc-in-altera-fpgas
    -- http://electronics.stackexchange.com/questions/122509/clock-domain-crossing-timing-constraints-for-altera/123101#123101

    -- Tell XST to keep the flip-flop net names to be used in timing constraints.
    -- Corsi : Altera 
    -- http://quartushelp.altera.com/14.0/mergedProjects/hdl/vhdl/vhdl_file_dir_keep.htm 
    attribute KEEP: boolean;
    attribute KEEP of syncdff_ff1: signal is true;
    attribute KEEP of syncdff_ff2: signal is true;

begin

    -- second flip-flop drives the output signal
    do <= syncdff_ff2;

    process (clk, rst) is
    begin
        if rst = '1' then
            -- asynchronous reset
            syncdff_ff1 <= '0';
            syncdff_ff2 <= '0';
        elsif rising_edge(clk) then
            -- data synchronization
            syncdff_ff1 <= di;
            syncdff_ff2 <= syncdff_ff1;
        end if;
    end process;

end architecture syncdff_arch;
