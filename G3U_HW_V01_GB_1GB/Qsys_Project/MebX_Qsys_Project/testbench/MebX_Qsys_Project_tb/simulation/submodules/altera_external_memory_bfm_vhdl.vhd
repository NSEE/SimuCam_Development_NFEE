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


library ieee;
use ieee.std_logic_1164.all;

library work;
use work.all;
use work.altera_external_memory_bfm_vhdl_pkg.all;

entity altera_external_memory_bfm_vhdl is
   generic (
      CDT_ADDRESS_W             : integer := 8;
      CDT_NUMSYMBOLS            : integer := 4;
      CDT_SYMBOL_W              : integer := 8;
      CDT_READ_LATENCY          : integer := 0;
      INIT_FILE                 : string  := "altera_external_memory_bfm.hex";
      USE_CHIPSELECT            : integer := 1;
      USE_READ                  : integer := 1;
      USE_WRITE                 : integer := 1;
      USE_OUTPUTENABLE          : integer := 1;
      USE_BEGINTRANSFER         : integer := 1;
      ACTIVE_LOW_CHIPSELECT     : integer := 0;
      ACTIVE_LOW_READ           : integer := 0;
      ACTIVE_LOW_WRITE          : integer := 0;
      ACTIVE_LOW_BYTEENABLE     : integer := 0;
      ACTIVE_LOW_OUTPUTENABLE   : integer := 0;
      ACTIVE_LOW_BEGINTRANSFER  : integer := 0;
      ACTIVE_LOW_RESET          : integer := 0;
      VHDL_ID                   : integer := 0
   );
   port (
      clk                       : in std_logic;
      cdt_address               : in std_logic_vector (CDT_ADDRESS_W - 1 downto 0);   
      cdt_data_io               : inout std_logic_vector ((CDT_SYMBOL_W * CDT_NUMSYMBOLS) - 1 downto 0);
      cdt_write                 : in std_logic;
      cdt_byteenable            : in std_logic_vector (CDT_NUMSYMBOLS - 1 downto 0);
      cdt_chipselect            : in std_logic;
      cdt_read                  : in std_logic;
      cdt_outputenable          : in std_logic;
      cdt_begintransfer         : in std_logic;
      cdt_reset                 : in std_logic
   );

end altera_external_memory_bfm_vhdl;

architecture ext_memory_bfm_vhdl_a of altera_external_memory_bfm_vhdl is 

   component altera_external_memory_bfm_vhdl_wrapper
      generic (
         CDT_ADDRESS_W             : integer := 8;
         CDT_NUMSYMBOLS            : integer := 4;
         CDT_SYMBOL_W              : integer := 8;
         CDT_READ_LATENCY          : integer := 0;
         INIT_FILE                 : string  := "altera_external_memory_bfm.hex";
         USE_CHIPSELECT            : integer := 1;
         USE_READ                  : integer := 1;
         USE_WRITE                 : integer := 1;
         USE_OUTPUTENABLE          : integer := 1;
         USE_BEGINTRANSFER         : integer := 1;
         ACTIVE_LOW_CHIPSELECT     : integer := 0;
         ACTIVE_LOW_READ           : integer := 0;
         ACTIVE_LOW_WRITE          : integer := 0;
         ACTIVE_LOW_BYTEENABLE     : integer := 0;
         ACTIVE_LOW_OUTPUTENABLE   : integer := 0;
         ACTIVE_LOW_BEGINTRANSFER  : integer := 0;
         ACTIVE_LOW_RESET          : integer := 0;
         EXT_MAX_BIT_W             : integer := 0
      );
      port (
         clk                       : in std_logic;
         cdt_address               : in std_logic_vector (CDT_ADDRESS_W - 1 downto 0);   
         cdt_data_io               : inout std_logic_vector ((CDT_SYMBOL_W * CDT_NUMSYMBOLS) - 1 downto 0);
         cdt_write                 : in std_logic;
         cdt_byteenable            : in std_logic_vector (CDT_NUMSYMBOLS - 1 downto 0);
         cdt_chipselect            : in std_logic;
         cdt_read                  : in std_logic;
         cdt_outputenable          : in std_logic;
         cdt_begintransfer         : in std_logic;
         cdt_reset                 : in std_logic;
      
         -- VHDL request interface
         req               : in std_logic_vector (EXT_MEM_FILL downto 0);
         ack               : out std_logic_vector (EXT_MEM_FILL downto 0);
         data_in0          : in integer;
         data_in1          : in std_logic_vector (EXT_MAX_BIT_W - 1 downto 0);
         data_in2          : in std_logic_vector (EXT_MAX_BIT_W - 1 downto 0);
         data_in3          : in std_logic_vector (EXT_MAX_BIT_W - 1 downto 0);
         data_out0         : out integer;
         data_out1         : out std_logic_vector (EXT_MAX_BIT_W - 1 downto 0);
         data_out2         : out std_logic_vector (EXT_MAX_BIT_W - 1 downto 0);
         data_out3         : out std_logic_vector (EXT_MAX_BIT_W - 1 downto 0);
         events            : out std_logic_vector (EXT_MEM_EVENT_API_CALL downto 0)
   );
   end component;
   
   -- VHDL request interface
   signal req               : std_logic_vector (EXT_MEM_FILL downto 0);
   signal ack               : std_logic_vector (EXT_MEM_FILL downto 0);
   signal data_in0          : integer;
   signal data_in1          : std_logic_vector (EXT_MAX_BIT_W - 1 downto 0);
   signal data_in2          : std_logic_vector (EXT_MAX_BIT_W - 1 downto 0);
   signal data_in3          : std_logic_vector (EXT_MAX_BIT_W - 1 downto 0);
   signal data_out0         : integer;
   signal data_out1         : std_logic_vector (EXT_MAX_BIT_W - 1 downto 0);
   signal data_out2         : std_logic_vector (EXT_MAX_BIT_W - 1 downto 0);
   signal data_out3         : std_logic_vector (EXT_MAX_BIT_W - 1 downto 0);
   signal events            : std_logic_vector (EXT_MEM_EVENT_API_CALL downto 0);
   
   begin
   
   req                                 <= req_if(VHDL_ID).req;
   data_in0                            <= req_if(VHDL_ID).data_in0;
   data_in1                            <= req_if(VHDL_ID).data_in1;
   data_in2                            <= req_if(VHDL_ID).data_in2;
   data_in3                            <= req_if(VHDL_ID).data_in3;
   ack_if(VHDL_ID).ack                 <= ack;
   ack_if(VHDL_ID).data_out0           <= data_out0;
   ack_if(VHDL_ID).data_out1           <= data_out1;
   ack_if(VHDL_ID).data_out2           <= data_out2;
   ack_if(VHDL_ID).data_out3           <= data_out3;
   ack_if(VHDL_ID).events              <= events;
   
   ext_memory_vhdl_wrapper : altera_external_memory_bfm_vhdl_wrapper
      generic map (
         CDT_ADDRESS_W                 => CDT_ADDRESS_W,
         CDT_NUMSYMBOLS                => CDT_NUMSYMBOLS,
         CDT_SYMBOL_W                  => CDT_SYMBOL_W,
         CDT_READ_LATENCY              => CDT_READ_LATENCY,
         INIT_FILE                     => INIT_FILE,
         USE_CHIPSELECT                => USE_CHIPSELECT,
         USE_READ                      => USE_READ,
         USE_WRITE                     => USE_WRITE,
         USE_OUTPUTENABLE              => USE_OUTPUTENABLE,
         USE_BEGINTRANSFER             => USE_BEGINTRANSFER,
         ACTIVE_LOW_CHIPSELECT         => ACTIVE_LOW_CHIPSELECT,
         ACTIVE_LOW_READ               => ACTIVE_LOW_READ,
         ACTIVE_LOW_WRITE              => ACTIVE_LOW_WRITE,
         ACTIVE_LOW_BYTEENABLE         => ACTIVE_LOW_BYTEENABLE,
         ACTIVE_LOW_OUTPUTENABLE       => ACTIVE_LOW_OUTPUTENABLE,
         ACTIVE_LOW_BEGINTRANSFER      => ACTIVE_LOW_BEGINTRANSFER,
         ACTIVE_LOW_RESET              => ACTIVE_LOW_RESET,
         EXT_MAX_BIT_W                 => EXT_MAX_BIT_W
      )
      port map (
         clk                           => clk,
         cdt_address                   => cdt_address,
         cdt_data_io                   => cdt_data_io,
         cdt_write                     => cdt_write,
         cdt_byteenable                => cdt_byteenable,
         cdt_chipselect                => cdt_chipselect,
         cdt_read                      => cdt_read,
         cdt_outputenable              => cdt_outputenable,
         cdt_begintransfer             => cdt_begintransfer,
         cdt_reset                     => cdt_reset,
         req                           => req,
         ack                           => ack,
         data_in0                      => data_in0,
         data_in1                      => data_in1,
         data_in2                      => data_in2,
         data_in3                      => data_in3,
         data_out0                     => data_out0,
         data_out1                     => data_out1,
         data_out2                     => data_out2,
         data_out3                     => data_out3,
         events                        => events
      );
   
end ext_memory_bfm_vhdl_a;