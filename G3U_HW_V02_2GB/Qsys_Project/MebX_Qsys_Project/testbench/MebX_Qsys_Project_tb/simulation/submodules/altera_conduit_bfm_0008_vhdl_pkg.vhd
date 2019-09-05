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
-- output_name:                  altera_conduit_bfm_0008
-- role:width:direction:         export:1:bidir
-- clocked                       0
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.all;


package altera_conduit_bfm_0008_vhdl_pkg is

   -- output signal register
   type altera_conduit_bfm_0008_out_trans_t is record
      sig_export_out     : std_logic_vector(0 downto 0);
      sig_export_oe      : std_logic;
   end record;
   
   shared variable out_trans        : altera_conduit_bfm_0008_out_trans_t;

   -- input signal register
   signal sig_export_in      : std_logic_vector(0 downto 0);

   -- VHDL Procedure API
   
   -- get export value
   procedure get_export             (signal_value : out std_logic_vector(0 downto 0));
   
   -- set export value
   procedure set_export             (signal_value : in std_logic_vector(0 downto 0));
   
   -- set export input / output direction
   procedure set_export_oe          (signal_value : in std_logic);
   
   -- VHDL Event API

   procedure event_export_change;   

end altera_conduit_bfm_0008_vhdl_pkg;

package body altera_conduit_bfm_0008_vhdl_pkg is
   
   procedure get_export             (signal_value : out std_logic_vector(0 downto 0)) is
   begin

      signal_value := sig_export_in;
   
   end procedure get_export;
   
   procedure set_export             (signal_value : in std_logic_vector(0 downto 0)) is
   begin
      
      out_trans.sig_export_out := signal_value;
      
   end procedure set_export;
   
   procedure set_export_oe          (signal_value : in std_logic) is
   begin
   
      out_trans.sig_export_oe := signal_value;
   
   end procedure set_export_oe;
   
   procedure event_export_change is
   begin

      wait until (sig_export_in'event and out_trans.sig_export_oe = '0');

   end event_export_change;

end altera_conduit_bfm_0008_vhdl_pkg;

