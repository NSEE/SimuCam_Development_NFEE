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
-- output_name:                  altera_conduit_bfm_0009
-- role:width:direction:         local_init_done:1:input,local_cal_success:1:input,local_cal_fail:1:input
-- clocked                       0
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.all;




package altera_conduit_bfm_0009_vhdl_pkg is


   -- input signal register
   signal sig_local_init_done_in        : std_logic_vector(0 downto 0);
   signal sig_local_cal_success_in      : std_logic_vector(0 downto 0);
   signal sig_local_cal_fail_in         : std_logic_vector(0 downto 0);

   -- VHDL Procedure API
   
   -- get local_init_done value
   procedure get_local_init_done               (signal_value : out std_logic_vector(0 downto 0));
   
   -- get local_cal_success value
   procedure get_local_cal_success             (signal_value : out std_logic_vector(0 downto 0));
   
   -- get local_cal_fail value
   procedure get_local_cal_fail                (signal_value : out std_logic_vector(0 downto 0));
   
   -- VHDL Event API

   procedure event_local_init_done_change;   

   procedure event_local_cal_success_change;   

   procedure event_local_cal_fail_change;   

end altera_conduit_bfm_0009_vhdl_pkg;

package body altera_conduit_bfm_0009_vhdl_pkg is
   
   procedure get_local_init_done               (signal_value : out std_logic_vector(0 downto 0)) is
   begin

      signal_value := sig_local_init_done_in;
   
   end procedure get_local_init_done;
   
   procedure get_local_cal_success             (signal_value : out std_logic_vector(0 downto 0)) is
   begin

      signal_value := sig_local_cal_success_in;
   
   end procedure get_local_cal_success;
   
   procedure get_local_cal_fail                (signal_value : out std_logic_vector(0 downto 0)) is
   begin

      signal_value := sig_local_cal_fail_in;
   
   end procedure get_local_cal_fail;
   
   procedure event_local_init_done_change is
   begin

      wait until (sig_local_init_done_in'event);

   end event_local_init_done_change;
   procedure event_local_cal_success_change is
   begin

      wait until (sig_local_cal_success_in'event);

   end event_local_cal_success_change;
   procedure event_local_cal_fail_change is
   begin

      wait until (sig_local_cal_fail_in'event);

   end event_local_cal_fail_change;

end altera_conduit_bfm_0009_vhdl_pkg;

