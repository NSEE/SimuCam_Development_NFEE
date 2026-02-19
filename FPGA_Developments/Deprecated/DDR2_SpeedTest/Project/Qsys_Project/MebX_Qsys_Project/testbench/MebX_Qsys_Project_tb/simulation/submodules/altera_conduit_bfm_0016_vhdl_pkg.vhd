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
-- output_name:                  altera_conduit_bfm_0016
-- role:width:direction:         xon_gen:1:output,xoff_gen:1:output,magic_wakeup:1:input,magic_sleep_n:1:output,ff_tx_crc_fwd:1:output,ff_tx_septy:1:input,tx_ff_uflow:1:input,ff_tx_a_full:1:input,ff_tx_a_empty:1:input,rx_err_stat:18:input,rx_frm_type:4:input,ff_rx_dsav:1:input,ff_rx_a_full:1:input,ff_rx_a_empty:1:input
-- clocked                       0
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.all;















package altera_conduit_bfm_0016_vhdl_pkg is

   -- output signal register
   type altera_conduit_bfm_0016_out_trans_t is record
      sig_xon_gen_out           : std_logic_vector(0 downto 0);
      sig_xoff_gen_out          : std_logic_vector(0 downto 0);
      sig_magic_sleep_n_out     : std_logic_vector(0 downto 0);
      sig_ff_tx_crc_fwd_out     : std_logic_vector(0 downto 0);
   end record;
   
   shared variable out_trans        : altera_conduit_bfm_0016_out_trans_t;

   -- input signal register
   signal sig_magic_wakeup_in       : std_logic_vector(0 downto 0);
   signal sig_ff_tx_septy_in        : std_logic_vector(0 downto 0);
   signal sig_tx_ff_uflow_in        : std_logic_vector(0 downto 0);
   signal sig_ff_tx_a_full_in       : std_logic_vector(0 downto 0);
   signal sig_ff_tx_a_empty_in      : std_logic_vector(0 downto 0);
   signal sig_rx_err_stat_in        : std_logic_vector(17 downto 0);
   signal sig_rx_frm_type_in        : std_logic_vector(3 downto 0);
   signal sig_ff_rx_dsav_in         : std_logic_vector(0 downto 0);
   signal sig_ff_rx_a_full_in       : std_logic_vector(0 downto 0);
   signal sig_ff_rx_a_empty_in      : std_logic_vector(0 downto 0);

   -- VHDL Procedure API
   
   -- set xon_gen value
   procedure set_xon_gen                   (signal_value : in std_logic_vector(0 downto 0));
   
   -- set xoff_gen value
   procedure set_xoff_gen                  (signal_value : in std_logic_vector(0 downto 0));
   
   -- get magic_wakeup value
   procedure get_magic_wakeup              (signal_value : out std_logic_vector(0 downto 0));
   
   -- set magic_sleep_n value
   procedure set_magic_sleep_n             (signal_value : in std_logic_vector(0 downto 0));
   
   -- set ff_tx_crc_fwd value
   procedure set_ff_tx_crc_fwd             (signal_value : in std_logic_vector(0 downto 0));
   
   -- get ff_tx_septy value
   procedure get_ff_tx_septy               (signal_value : out std_logic_vector(0 downto 0));
   
   -- get tx_ff_uflow value
   procedure get_tx_ff_uflow               (signal_value : out std_logic_vector(0 downto 0));
   
   -- get ff_tx_a_full value
   procedure get_ff_tx_a_full              (signal_value : out std_logic_vector(0 downto 0));
   
   -- get ff_tx_a_empty value
   procedure get_ff_tx_a_empty             (signal_value : out std_logic_vector(0 downto 0));
   
   -- get rx_err_stat value
   procedure get_rx_err_stat               (signal_value : out std_logic_vector(17 downto 0));
   
   -- get rx_frm_type value
   procedure get_rx_frm_type               (signal_value : out std_logic_vector(3 downto 0));
   
   -- get ff_rx_dsav value
   procedure get_ff_rx_dsav                (signal_value : out std_logic_vector(0 downto 0));
   
   -- get ff_rx_a_full value
   procedure get_ff_rx_a_full              (signal_value : out std_logic_vector(0 downto 0));
   
   -- get ff_rx_a_empty value
   procedure get_ff_rx_a_empty             (signal_value : out std_logic_vector(0 downto 0));
   
   -- VHDL Event API

   procedure event_magic_wakeup_change;   

   procedure event_ff_tx_septy_change;   

   procedure event_tx_ff_uflow_change;   

   procedure event_ff_tx_a_full_change;   

   procedure event_ff_tx_a_empty_change;   

   procedure event_rx_err_stat_change;   

   procedure event_rx_frm_type_change;   

   procedure event_ff_rx_dsav_change;   

   procedure event_ff_rx_a_full_change;   

   procedure event_ff_rx_a_empty_change;   

end altera_conduit_bfm_0016_vhdl_pkg;

package body altera_conduit_bfm_0016_vhdl_pkg is
   
   procedure set_xon_gen                   (signal_value : in std_logic_vector(0 downto 0)) is
   begin
      
      out_trans.sig_xon_gen_out := signal_value;
      
   end procedure set_xon_gen;
   
   procedure set_xoff_gen                  (signal_value : in std_logic_vector(0 downto 0)) is
   begin
      
      out_trans.sig_xoff_gen_out := signal_value;
      
   end procedure set_xoff_gen;
   
   procedure get_magic_wakeup              (signal_value : out std_logic_vector(0 downto 0)) is
   begin

      signal_value := sig_magic_wakeup_in;
   
   end procedure get_magic_wakeup;
   
   procedure set_magic_sleep_n             (signal_value : in std_logic_vector(0 downto 0)) is
   begin
      
      out_trans.sig_magic_sleep_n_out := signal_value;
      
   end procedure set_magic_sleep_n;
   
   procedure set_ff_tx_crc_fwd             (signal_value : in std_logic_vector(0 downto 0)) is
   begin
      
      out_trans.sig_ff_tx_crc_fwd_out := signal_value;
      
   end procedure set_ff_tx_crc_fwd;
   
   procedure get_ff_tx_septy               (signal_value : out std_logic_vector(0 downto 0)) is
   begin

      signal_value := sig_ff_tx_septy_in;
   
   end procedure get_ff_tx_septy;
   
   procedure get_tx_ff_uflow               (signal_value : out std_logic_vector(0 downto 0)) is
   begin

      signal_value := sig_tx_ff_uflow_in;
   
   end procedure get_tx_ff_uflow;
   
   procedure get_ff_tx_a_full              (signal_value : out std_logic_vector(0 downto 0)) is
   begin

      signal_value := sig_ff_tx_a_full_in;
   
   end procedure get_ff_tx_a_full;
   
   procedure get_ff_tx_a_empty             (signal_value : out std_logic_vector(0 downto 0)) is
   begin

      signal_value := sig_ff_tx_a_empty_in;
   
   end procedure get_ff_tx_a_empty;
   
   procedure get_rx_err_stat               (signal_value : out std_logic_vector(17 downto 0)) is
   begin

      signal_value := sig_rx_err_stat_in;
   
   end procedure get_rx_err_stat;
   
   procedure get_rx_frm_type               (signal_value : out std_logic_vector(3 downto 0)) is
   begin

      signal_value := sig_rx_frm_type_in;
   
   end procedure get_rx_frm_type;
   
   procedure get_ff_rx_dsav                (signal_value : out std_logic_vector(0 downto 0)) is
   begin

      signal_value := sig_ff_rx_dsav_in;
   
   end procedure get_ff_rx_dsav;
   
   procedure get_ff_rx_a_full              (signal_value : out std_logic_vector(0 downto 0)) is
   begin

      signal_value := sig_ff_rx_a_full_in;
   
   end procedure get_ff_rx_a_full;
   
   procedure get_ff_rx_a_empty             (signal_value : out std_logic_vector(0 downto 0)) is
   begin

      signal_value := sig_ff_rx_a_empty_in;
   
   end procedure get_ff_rx_a_empty;
   
   procedure event_magic_wakeup_change is
   begin

      wait until (sig_magic_wakeup_in'event);

   end event_magic_wakeup_change;
   procedure event_ff_tx_septy_change is
   begin

      wait until (sig_ff_tx_septy_in'event);

   end event_ff_tx_septy_change;
   procedure event_tx_ff_uflow_change is
   begin

      wait until (sig_tx_ff_uflow_in'event);

   end event_tx_ff_uflow_change;
   procedure event_ff_tx_a_full_change is
   begin

      wait until (sig_ff_tx_a_full_in'event);

   end event_ff_tx_a_full_change;
   procedure event_ff_tx_a_empty_change is
   begin

      wait until (sig_ff_tx_a_empty_in'event);

   end event_ff_tx_a_empty_change;
   procedure event_rx_err_stat_change is
   begin

      wait until (sig_rx_err_stat_in'event);

   end event_rx_err_stat_change;
   procedure event_rx_frm_type_change is
   begin

      wait until (sig_rx_frm_type_in'event);

   end event_rx_frm_type_change;
   procedure event_ff_rx_dsav_change is
   begin

      wait until (sig_ff_rx_dsav_in'event);

   end event_ff_rx_dsav_change;
   procedure event_ff_rx_a_full_change is
   begin

      wait until (sig_ff_rx_a_full_in'event);

   end event_ff_rx_a_full_change;
   procedure event_ff_rx_a_empty_change is
   begin

      wait until (sig_ff_rx_a_empty_in'event);

   end event_ff_rx_a_empty_change;

end altera_conduit_bfm_0016_vhdl_pkg;

