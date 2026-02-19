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
-- This is a Bus Functional Model (BFM) VHDL package for a Standard Conduit Master.
-- This package provides the API that will be used to get the value of the sampled
-- input/bidirection port or set the value to be driven to the output ports.
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



package altera_conduit_bfm_0014_vhdl_pkg is


   -- input signal register
   signal reset_in          : std_logic;
   signal sig_ssdp0_in      : std_logic_vector(7 downto 0);
   signal sig_ssdp1_in      : std_logic_vector(7 downto 0);

   -- VHDL Procedure API
   
   -- get ssdp0 value
   procedure get_ssdp0             (signal_value : out std_logic_vector(7 downto 0));
   
   -- get ssdp1 value
   procedure get_ssdp1             (signal_value : out std_logic_vector(7 downto 0));
   
   -- VHDL Event API
   procedure event_reset_asserted;

   procedure event_ssdp0_change;   

   procedure event_ssdp1_change;   

end altera_conduit_bfm_0014_vhdl_pkg;

package body altera_conduit_bfm_0014_vhdl_pkg is
   
   procedure get_ssdp0             (signal_value : out std_logic_vector(7 downto 0)) is
   begin

      signal_value := sig_ssdp0_in;
   
   end procedure get_ssdp0;
   
   procedure get_ssdp1             (signal_value : out std_logic_vector(7 downto 0)) is
   begin

      signal_value := sig_ssdp1_in;
   
   end procedure get_ssdp1;
   
   procedure event_reset_asserted is
   begin
   
      wait until (reset_in'event and reset_in = '1');
      
   end event_reset_asserted;
   procedure event_ssdp0_change is
   begin

      wait until (sig_ssdp0_in'event);

   end event_ssdp0_change;
   procedure event_ssdp1_change is
   begin

      wait until (sig_ssdp1_in'event);

   end event_ssdp1_change;

end altera_conduit_bfm_0014_vhdl_pkg;

