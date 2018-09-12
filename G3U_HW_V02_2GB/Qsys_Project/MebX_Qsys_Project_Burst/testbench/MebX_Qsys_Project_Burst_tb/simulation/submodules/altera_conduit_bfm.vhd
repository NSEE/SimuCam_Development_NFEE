-- (C) 2001-2016 Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions and other 
-- software and tools, and its AMPP partner logic functions, and any output 
-- files any of the foregoing (including device programming or simulation 
-- files), and any associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License Subscription 
-- Agreement, Intel MegaCore Function License Agreement, or other applicable 
-- license agreement, including, without limitation, that your use is for the 
-- sole purpose of programming logic devices manufactured by Intel and sold by 
-- Intel or its authorized distributors.  Please refer to the applicable 
-- agreement for further details.


-- $Id: //acds/main/ip/sopc/components/verification/altera_tristate_conduit_bfm/altera_tristate_conduit_bfm.sv.terp#7 $
-- $Revision: #7 $
-- $Date: 2010/08/05 $
-- $Author: klong $
-------------------------------------------------------------------------------
-- =head1 NAME
-- altera_conduit_bfm
-- =head1 SYNOPSIS
-- Bus Functional Model (BFM) for a Standard Conduit BFM
-------------------------------------------------------------------------------
-- =head1 DESCRIPTION
-- This is a Bus Functional Model (BFM) for a Standard Conduit Master.
-- This BFM sampled the input/bidirection port value or driving user's value to 
-- output ports when user call the API.  
-- This BFM's HDL is been generated through terp file in Qsys/SOPC Builder.
-- Generation parameters:
-- output_name:                  altera_conduit_bfm
-- role:width:direction:         spw_si_signal:1:output,spw_di_signal:1:output,spw_do_signal:1:input,spw_so_signal:1:input
-- clocked                       1
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.all;
use work.altera_conduit_bfm_vhdl_pkg.all;

entity altera_conduit_bfm is
   port (
      clk                 : in    std_logic;
      reset               : in    std_logic;
      sig_spw_si_signal   : out   std_logic_vector(0 downto 0);
      sig_spw_di_signal   : out   std_logic_vector(0 downto 0);
      sig_spw_do_signal   : in    std_logic_vector(0 downto 0);
      sig_spw_so_signal   : in    std_logic_vector(0 downto 0)
   );
end altera_conduit_bfm;

architecture altera_conduit_bfm_arch of altera_conduit_bfm is 

   begin

      process (clk) begin
      if (clk'event and clk = '1') then
         sig_spw_si_signal   <= out_trans.sig_spw_si_signal_out after 1 ps;
         sig_spw_di_signal   <= out_trans.sig_spw_di_signal_out after 1 ps;
         sig_spw_do_signal_in <= sig_spw_do_signal;
         sig_spw_so_signal_in <= sig_spw_so_signal;
         reset_in            <= reset;
      end if;
      end process;

end altera_conduit_bfm_arch;

