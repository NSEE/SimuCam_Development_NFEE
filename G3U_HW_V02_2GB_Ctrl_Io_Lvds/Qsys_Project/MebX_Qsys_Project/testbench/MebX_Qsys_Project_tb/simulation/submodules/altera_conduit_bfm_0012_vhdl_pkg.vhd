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
-- output_name:                  altera_conduit_bfm_0012
-- role:width:direction:         pll_mem_clk:1:input,pll_write_clk:1:input,pll_locked:1:input,pll_write_clk_pre_phy_clk:1:input,pll_addr_cmd_clk:1:input,pll_avl_clk:1:input,pll_config_clk:1:input
-- clocked                       0
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.all;








package altera_conduit_bfm_0012_vhdl_pkg is


   -- input signal register
   signal sig_pll_mem_clk_in                    : std_logic_vector(0 downto 0);
   signal sig_pll_write_clk_in                  : std_logic_vector(0 downto 0);
   signal sig_pll_locked_in                     : std_logic_vector(0 downto 0);
   signal sig_pll_write_clk_pre_phy_clk_in      : std_logic_vector(0 downto 0);
   signal sig_pll_addr_cmd_clk_in               : std_logic_vector(0 downto 0);
   signal sig_pll_avl_clk_in                    : std_logic_vector(0 downto 0);
   signal sig_pll_config_clk_in                 : std_logic_vector(0 downto 0);

   -- VHDL Procedure API
   
   -- get pll_mem_clk value
   procedure get_pll_mem_clk                           (signal_value : out std_logic_vector(0 downto 0));
   
   -- get pll_write_clk value
   procedure get_pll_write_clk                         (signal_value : out std_logic_vector(0 downto 0));
   
   -- get pll_locked value
   procedure get_pll_locked                            (signal_value : out std_logic_vector(0 downto 0));
   
   -- get pll_write_clk_pre_phy_clk value
   procedure get_pll_write_clk_pre_phy_clk             (signal_value : out std_logic_vector(0 downto 0));
   
   -- get pll_addr_cmd_clk value
   procedure get_pll_addr_cmd_clk                      (signal_value : out std_logic_vector(0 downto 0));
   
   -- get pll_avl_clk value
   procedure get_pll_avl_clk                           (signal_value : out std_logic_vector(0 downto 0));
   
   -- get pll_config_clk value
   procedure get_pll_config_clk                        (signal_value : out std_logic_vector(0 downto 0));
   
   -- VHDL Event API

   procedure event_pll_mem_clk_change;   

   procedure event_pll_write_clk_change;   

   procedure event_pll_locked_change;   

   procedure event_pll_write_clk_pre_phy_clk_change;   

   procedure event_pll_addr_cmd_clk_change;   

   procedure event_pll_avl_clk_change;   

   procedure event_pll_config_clk_change;   

end altera_conduit_bfm_0012_vhdl_pkg;

package body altera_conduit_bfm_0012_vhdl_pkg is
   
   procedure get_pll_mem_clk                           (signal_value : out std_logic_vector(0 downto 0)) is
   begin

      signal_value := sig_pll_mem_clk_in;
   
   end procedure get_pll_mem_clk;
   
   procedure get_pll_write_clk                         (signal_value : out std_logic_vector(0 downto 0)) is
   begin

      signal_value := sig_pll_write_clk_in;
   
   end procedure get_pll_write_clk;
   
   procedure get_pll_locked                            (signal_value : out std_logic_vector(0 downto 0)) is
   begin

      signal_value := sig_pll_locked_in;
   
   end procedure get_pll_locked;
   
   procedure get_pll_write_clk_pre_phy_clk             (signal_value : out std_logic_vector(0 downto 0)) is
   begin

      signal_value := sig_pll_write_clk_pre_phy_clk_in;
   
   end procedure get_pll_write_clk_pre_phy_clk;
   
   procedure get_pll_addr_cmd_clk                      (signal_value : out std_logic_vector(0 downto 0)) is
   begin

      signal_value := sig_pll_addr_cmd_clk_in;
   
   end procedure get_pll_addr_cmd_clk;
   
   procedure get_pll_avl_clk                           (signal_value : out std_logic_vector(0 downto 0)) is
   begin

      signal_value := sig_pll_avl_clk_in;
   
   end procedure get_pll_avl_clk;
   
   procedure get_pll_config_clk                        (signal_value : out std_logic_vector(0 downto 0)) is
   begin

      signal_value := sig_pll_config_clk_in;
   
   end procedure get_pll_config_clk;
   
   procedure event_pll_mem_clk_change is
   begin

      wait until (sig_pll_mem_clk_in'event);

   end event_pll_mem_clk_change;
   procedure event_pll_write_clk_change is
   begin

      wait until (sig_pll_write_clk_in'event);

   end event_pll_write_clk_change;
   procedure event_pll_locked_change is
   begin

      wait until (sig_pll_locked_in'event);

   end event_pll_locked_change;
   procedure event_pll_write_clk_pre_phy_clk_change is
   begin

      wait until (sig_pll_write_clk_pre_phy_clk_in'event);

   end event_pll_write_clk_pre_phy_clk_change;
   procedure event_pll_addr_cmd_clk_change is
   begin

      wait until (sig_pll_addr_cmd_clk_in'event);

   end event_pll_addr_cmd_clk_change;
   procedure event_pll_avl_clk_change is
   begin

      wait until (sig_pll_avl_clk_in'event);

   end event_pll_avl_clk_change;
   procedure event_pll_config_clk_change is
   begin

      wait until (sig_pll_config_clk_in'event);

   end event_pll_config_clk_change;

end altera_conduit_bfm_0012_vhdl_pkg;

