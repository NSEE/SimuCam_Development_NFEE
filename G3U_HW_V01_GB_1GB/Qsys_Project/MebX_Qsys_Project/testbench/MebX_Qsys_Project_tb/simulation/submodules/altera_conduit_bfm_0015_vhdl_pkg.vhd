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
-- output_name:                  altera_conduit_bfm_0015
-- role:width:direction:         crs:1:input,link:1:input,panel_link:1:input,col:1:input,an:1:input,char_err:1:input,disp_err:1:input
-- clocked                       0
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.all;








package altera_conduit_bfm_0015_vhdl_pkg is


   -- input signal register
   signal sig_crs_in             : std_logic_vector(0 downto 0);
   signal sig_link_in            : std_logic_vector(0 downto 0);
   signal sig_panel_link_in      : std_logic_vector(0 downto 0);
   signal sig_col_in             : std_logic_vector(0 downto 0);
   signal sig_an_in              : std_logic_vector(0 downto 0);
   signal sig_char_err_in        : std_logic_vector(0 downto 0);
   signal sig_disp_err_in        : std_logic_vector(0 downto 0);

   -- VHDL Procedure API
   
   -- get crs value
   procedure get_crs                    (signal_value : out std_logic_vector(0 downto 0));
   
   -- get link value
   procedure get_link                   (signal_value : out std_logic_vector(0 downto 0));
   
   -- get panel_link value
   procedure get_panel_link             (signal_value : out std_logic_vector(0 downto 0));
   
   -- get col value
   procedure get_col                    (signal_value : out std_logic_vector(0 downto 0));
   
   -- get an value
   procedure get_an                     (signal_value : out std_logic_vector(0 downto 0));
   
   -- get char_err value
   procedure get_char_err               (signal_value : out std_logic_vector(0 downto 0));
   
   -- get disp_err value
   procedure get_disp_err               (signal_value : out std_logic_vector(0 downto 0));
   
   -- VHDL Event API

   procedure event_crs_change;   

   procedure event_link_change;   

   procedure event_panel_link_change;   

   procedure event_col_change;   

   procedure event_an_change;   

   procedure event_char_err_change;   

   procedure event_disp_err_change;   

end altera_conduit_bfm_0015_vhdl_pkg;

package body altera_conduit_bfm_0015_vhdl_pkg is
   
   procedure get_crs                    (signal_value : out std_logic_vector(0 downto 0)) is
   begin

      signal_value := sig_crs_in;
   
   end procedure get_crs;
   
   procedure get_link                   (signal_value : out std_logic_vector(0 downto 0)) is
   begin

      signal_value := sig_link_in;
   
   end procedure get_link;
   
   procedure get_panel_link             (signal_value : out std_logic_vector(0 downto 0)) is
   begin

      signal_value := sig_panel_link_in;
   
   end procedure get_panel_link;
   
   procedure get_col                    (signal_value : out std_logic_vector(0 downto 0)) is
   begin

      signal_value := sig_col_in;
   
   end procedure get_col;
   
   procedure get_an                     (signal_value : out std_logic_vector(0 downto 0)) is
   begin

      signal_value := sig_an_in;
   
   end procedure get_an;
   
   procedure get_char_err               (signal_value : out std_logic_vector(0 downto 0)) is
   begin

      signal_value := sig_char_err_in;
   
   end procedure get_char_err;
   
   procedure get_disp_err               (signal_value : out std_logic_vector(0 downto 0)) is
   begin

      signal_value := sig_disp_err_in;
   
   end procedure get_disp_err;
   
   procedure event_crs_change is
   begin

      wait until (sig_crs_in'event);

   end event_crs_change;
   procedure event_link_change is
   begin

      wait until (sig_link_in'event);

   end event_link_change;
   procedure event_panel_link_change is
   begin

      wait until (sig_panel_link_in'event);

   end event_panel_link_change;
   procedure event_col_change is
   begin

      wait until (sig_col_in'event);

   end event_col_change;
   procedure event_an_change is
   begin

      wait until (sig_an_in'event);

   end event_an_change;
   procedure event_char_err_change is
   begin

      wait until (sig_char_err_in'event);

   end event_char_err_change;
   procedure event_disp_err_change is
   begin

      wait until (sig_disp_err_in'event);

   end event_disp_err_change;

end altera_conduit_bfm_0015_vhdl_pkg;

