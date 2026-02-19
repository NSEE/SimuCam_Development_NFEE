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
-- output_name:                  altera_conduit_bfm_0014
-- role:width:direction:         ssdp0:8:input,ssdp1:8:input
-- clocked                       1
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.all;
use work.altera_conduit_bfm_0014_vhdl_pkg.all;

entity altera_conduit_bfm_0014 is
   port (
      clk         : in    std_logic;
      reset       : in    std_logic;
      sig_ssdp0   : in    std_logic_vector(7 downto 0);
      sig_ssdp1   : in    std_logic_vector(7 downto 0)
   );
end altera_conduit_bfm_0014;

architecture altera_conduit_bfm_0014_arch of altera_conduit_bfm_0014 is 

   begin

      process (clk) begin
      if (clk'event and clk = '1') then
         sig_ssdp0_in <= sig_ssdp0;
         sig_ssdp1_in <= sig_ssdp1;
         reset_in    <= reset;
      end if;
      end process;

end altera_conduit_bfm_0014_arch;

