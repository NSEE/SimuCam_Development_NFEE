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
-- output_name:                  altera_conduit_bfm
-- role:width:direction:         spw_si_signal:1:output,spw_di_signal:1:output,spw_do_signal:1:input,spw_so_signal:1:input
-- clocked                       1
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.all;





package altera_conduit_bfm_vhdl_pkg is

   -- output signal register
   type altera_conduit_bfm_out_trans_t is record
      sig_spw_si_signal_out     : std_logic_vector(0 downto 0);
      sig_spw_di_signal_out     : std_logic_vector(0 downto 0);
   end record;
   
   shared variable out_trans        : altera_conduit_bfm_out_trans_t;

   -- input signal register
   signal reset_in                  : std_logic;
   signal sig_spw_do_signal_in      : std_logic_vector(0 downto 0);
   signal sig_spw_so_signal_in      : std_logic_vector(0 downto 0);

   -- VHDL Procedure API
   
   -- set spw_si_signal value
   procedure set_spw_si_signal             (signal_value : in std_logic_vector(0 downto 0));
   
   -- set spw_di_signal value
   procedure set_spw_di_signal             (signal_value : in std_logic_vector(0 downto 0));
   
   -- get spw_do_signal value
   procedure get_spw_do_signal             (signal_value : out std_logic_vector(0 downto 0));
   
   -- get spw_so_signal value
   procedure get_spw_so_signal             (signal_value : out std_logic_vector(0 downto 0));
   
   -- VHDL Event API
   procedure event_reset_asserted;

   procedure event_spw_do_signal_change;   

   procedure event_spw_so_signal_change;   

end altera_conduit_bfm_vhdl_pkg;

package body altera_conduit_bfm_vhdl_pkg is
   
   procedure set_spw_si_signal             (signal_value : in std_logic_vector(0 downto 0)) is
   begin
      
      out_trans.sig_spw_si_signal_out := signal_value;
      
   end procedure set_spw_si_signal;
   
   procedure set_spw_di_signal             (signal_value : in std_logic_vector(0 downto 0)) is
   begin
      
      out_trans.sig_spw_di_signal_out := signal_value;
      
   end procedure set_spw_di_signal;
   
   procedure get_spw_do_signal             (signal_value : out std_logic_vector(0 downto 0)) is
   begin

      signal_value := sig_spw_do_signal_in;
   
   end procedure get_spw_do_signal;
   
   procedure get_spw_so_signal             (signal_value : out std_logic_vector(0 downto 0)) is
   begin

      signal_value := sig_spw_so_signal_in;
   
   end procedure get_spw_so_signal;
   
   procedure event_reset_asserted is
   begin
   
      wait until (reset_in'event and reset_in = '1');
      
   end event_reset_asserted;
   procedure event_spw_do_signal_change is
   begin

      wait until (sig_spw_do_signal_in'event);

   end event_spw_do_signal_change;
   procedure event_spw_so_signal_change is
   begin

      wait until (sig_spw_so_signal_in'event);

   end event_spw_so_signal_change;

end altera_conduit_bfm_vhdl_pkg;

