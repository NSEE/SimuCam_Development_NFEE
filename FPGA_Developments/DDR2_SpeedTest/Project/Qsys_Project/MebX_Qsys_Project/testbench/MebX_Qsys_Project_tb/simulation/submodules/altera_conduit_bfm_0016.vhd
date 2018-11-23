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
-- output_name:                  altera_conduit_bfm_0016
-- role:width:direction:         xon_gen:1:output,xoff_gen:1:output,magic_wakeup:1:input,magic_sleep_n:1:output,ff_tx_crc_fwd:1:output,ff_tx_septy:1:input,tx_ff_uflow:1:input,ff_tx_a_full:1:input,ff_tx_a_empty:1:input,rx_err_stat:18:input,rx_frm_type:4:input,ff_rx_dsav:1:input,ff_rx_a_full:1:input,ff_rx_a_empty:1:input
-- clocked                       0
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.all;
use work.altera_conduit_bfm_0016_vhdl_pkg.all;

entity altera_conduit_bfm_0016 is
   port (
      sig_xon_gen         : out   std_logic_vector(0 downto 0);
      sig_xoff_gen        : out   std_logic_vector(0 downto 0);
      sig_magic_wakeup    : in    std_logic_vector(0 downto 0);
      sig_magic_sleep_n   : out   std_logic_vector(0 downto 0);
      sig_ff_tx_crc_fwd   : out   std_logic_vector(0 downto 0);
      sig_ff_tx_septy     : in    std_logic_vector(0 downto 0);
      sig_tx_ff_uflow     : in    std_logic_vector(0 downto 0);
      sig_ff_tx_a_full    : in    std_logic_vector(0 downto 0);
      sig_ff_tx_a_empty   : in    std_logic_vector(0 downto 0);
      sig_rx_err_stat     : in    std_logic_vector(17 downto 0);
      sig_rx_frm_type     : in    std_logic_vector(3 downto 0);
      sig_ff_rx_dsav      : in    std_logic_vector(0 downto 0);
      sig_ff_rx_a_full    : in    std_logic_vector(0 downto 0);
      sig_ff_rx_a_empty   : in    std_logic_vector(0 downto 0)
   );
end altera_conduit_bfm_0016;

architecture altera_conduit_bfm_0016_arch of altera_conduit_bfm_0016 is 

      signal update : std_logic := '0';

   begin
      process begin
         wait for 1 ps;
         update <= not update;
      end process;

      process (update) begin
         sig_xon_gen         <= out_trans.sig_xon_gen_out after 1 ps;
         sig_xoff_gen        <= out_trans.sig_xoff_gen_out after 1 ps;
         sig_magic_wakeup_in <= sig_magic_wakeup;
         sig_magic_sleep_n   <= out_trans.sig_magic_sleep_n_out after 1 ps;
         sig_ff_tx_crc_fwd   <= out_trans.sig_ff_tx_crc_fwd_out after 1 ps;
         sig_ff_tx_septy_in  <= sig_ff_tx_septy;
         sig_tx_ff_uflow_in  <= sig_tx_ff_uflow;
         sig_ff_tx_a_full_in <= sig_ff_tx_a_full;
         sig_ff_tx_a_empty_in <= sig_ff_tx_a_empty;
         sig_rx_err_stat_in  <= sig_rx_err_stat;
         sig_rx_frm_type_in  <= sig_rx_frm_type;
         sig_ff_rx_dsav_in   <= sig_ff_rx_dsav;
         sig_ff_rx_a_full_in <= sig_ff_rx_a_full;
         sig_ff_rx_a_empty_in <= sig_ff_rx_a_empty;
      end process;

end altera_conduit_bfm_0016_arch;

