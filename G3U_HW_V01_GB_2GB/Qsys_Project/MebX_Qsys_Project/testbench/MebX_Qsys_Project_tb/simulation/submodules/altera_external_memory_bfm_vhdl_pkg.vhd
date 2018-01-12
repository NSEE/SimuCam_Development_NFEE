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
use ieee.std_logic_arith.all;

library work;
use work.all;

-- VHDL procedure declarations
package altera_external_memory_bfm_vhdl_pkg is

   -- maximum number of external memory vhdl bfm
   constant MAX_VHDL_BFM : integer := 1024;
   
   -- maximu number of bits in external memory bfm
   constant EXT_MAX_BIT_W : integer := 1024;
   
   -- ext_mem_vhdl_api_e
   constant EXT_MEM_WRITE                                : integer := 0;
   constant EXT_MEM_READ                                 : integer := 1;
   constant EXT_MEM_FILL                                 : integer := 2;

   -- ext_mem_vhdl_event_e
   constant EXT_MEM_EVENT_API_CALL                       : integer := 0;
   
   -- VHDL API request interface type
   type ext_mem_vhdl_if_base_t is record
      req         : std_logic_vector (EXT_MEM_FILL downto 0);
      ack         : std_logic_vector (EXT_MEM_FILL downto 0);
      data_in0    : integer;
      data_in1    : std_logic_vector (EXT_MAX_BIT_W - 1 downto 0);
      data_in2    : std_logic_vector (EXT_MAX_BIT_W - 1 downto 0);
      data_in3    : std_logic_vector (EXT_MAX_BIT_W - 1 downto 0);
      data_out0   : integer;
      data_out1   : std_logic_vector (EXT_MAX_BIT_W - 1 downto 0);
      data_out2   : std_logic_vector (EXT_MAX_BIT_W - 1 downto 0);
      data_out3   : std_logic_vector (EXT_MAX_BIT_W - 1 downto 0);
      events      : std_logic_vector (EXT_MEM_EVENT_API_CALL downto 0);
   end record;
   
   type ext_mem_vhdl_if_t is array(MAX_VHDL_BFM - 1 downto 0) of ext_mem_vhdl_if_base_t;
   
   signal req_if           : ext_mem_vhdl_if_t;
   signal ack_if           : ext_mem_vhdl_if_t;
   
   -- convert signal to integer
   function to_integer (OP: STD_LOGIC_VECTOR) return INTEGER;

   -- VHDL procedures
   procedure write                             (data          : in std_logic_vector (EXT_MAX_BIT_W - 1 downto 0);
                                                address       : in std_logic_vector (EXT_MAX_BIT_W - 1 downto 0);
                                                bfm_id        : in integer;
                                                signal api_if : inout ext_mem_vhdl_if_t);
   
   procedure write                             (data          : in integer;
                                                address       : in integer;
                                                bfm_id        : in integer;
                                                signal api_if : inout ext_mem_vhdl_if_t);

   procedure read                              (data          : out std_logic_vector (EXT_MAX_BIT_W - 1 downto 0);
                                                address       : in std_logic_vector (EXT_MAX_BIT_W - 1 downto 0);
                                                bfm_id        : in integer;
                                                signal api_if : inout ext_mem_vhdl_if_t);
   
   procedure read                              (data          : out integer;
                                                address       : in integer;
                                                bfm_id        : in integer;
                                                signal api_if : inout ext_mem_vhdl_if_t);

   procedure fill                              (data          : in std_logic_vector (EXT_MAX_BIT_W - 1 downto 0);
                                                increment     : in integer;
                                                address_low   : in std_logic_vector (EXT_MAX_BIT_W - 1 downto 0);
                                                address_high  : in std_logic_vector (EXT_MAX_BIT_W - 1 downto 0);
                                                bfm_id        : in integer;
                                                signal api_if : inout ext_mem_vhdl_if_t);
   
   procedure fill                              (data          : in integer;
                                                increment     : in integer;
                                                address_low   : in integer;
                                                address_high  : in integer;
                                                bfm_id        : in integer;
                                                signal api_if : inout ext_mem_vhdl_if_t);
   
   procedure write                             (data          : in std_logic_vector (EXT_MAX_BIT_W - 1 downto 0);
                                                address       : in std_logic_vector (EXT_MAX_BIT_W - 1 downto 0);
                                                bfm_id        : in integer;
                                                signal api_if : inout ext_mem_vhdl_if_base_t);
   
   procedure write                             (data          : in integer;
                                                address       : in integer;
                                                bfm_id        : in integer;
                                                signal api_if : inout ext_mem_vhdl_if_base_t);

   procedure read                              (data          : out std_logic_vector (EXT_MAX_BIT_W - 1 downto 0);
                                                address       : in std_logic_vector (EXT_MAX_BIT_W - 1 downto 0);
                                                bfm_id        : in integer;
                                                signal api_if : inout ext_mem_vhdl_if_base_t);
   
   procedure read                              (data          : out integer;
                                                address       : in integer;
                                                bfm_id        : in integer;
                                                signal api_if : inout ext_mem_vhdl_if_base_t);

   procedure fill                              (data          : in std_logic_vector (EXT_MAX_BIT_W - 1 downto 0);
                                                increment     : in integer;
                                                address_low   : in std_logic_vector (EXT_MAX_BIT_W - 1 downto 0);
                                                address_high  : in std_logic_vector (EXT_MAX_BIT_W - 1 downto 0);
                                                bfm_id        : in integer;
                                                signal api_if : inout ext_mem_vhdl_if_base_t);
   
   procedure fill                              (data          : in integer;
                                                increment     : in integer;
                                                address_low   : in integer;
                                                address_high  : in integer;
                                                bfm_id        : in integer;
                                                signal api_if : inout ext_mem_vhdl_if_base_t);
   
   -- VHDL events
   procedure event_api_call                    (bfm_id        : in integer);
   
end altera_external_memory_bfm_vhdl_pkg;

-- VHDL procedures implementation
package body altera_external_memory_bfm_vhdl_pkg is

   -- convert to integer
   function to_integer (OP: STD_LOGIC_VECTOR) return INTEGER is
      variable result : INTEGER := 0;
      variable tmp_op : STD_LOGIC_VECTOR (OP'range) := OP;
   begin
      if not (Is_X(OP)) then
         for i in OP'range loop
            if OP(i) = '1' then
               result := result + 2**i;
            end if;
         end loop; 
         return result;
      else
         return 0;
      end if;
   end to_integer;
   
   procedure write                             (data          : in std_logic_vector (EXT_MAX_BIT_W - 1 downto 0);
                                                address       : in std_logic_vector (EXT_MAX_BIT_W - 1 downto 0);
                                                bfm_id        : in integer;
                                                signal api_if : inout ext_mem_vhdl_if_t) is
   begin
      api_if(bfm_id).data_in1 <= address;
      api_if(bfm_id).data_in3 <= data;
      api_if(bfm_id).req(EXT_MEM_WRITE) <= '1';
      wait until (ack_if(bfm_id).ack(EXT_MEM_WRITE) = '1');
      api_if(bfm_id).req(EXT_MEM_WRITE) <= '0';
      wait until (ack_if(bfm_id).ack(EXT_MEM_WRITE) = '0');
   end write;
   
   procedure write                             (data          : in integer;
                                                address       : in integer;
                                                bfm_id        : in integer;
                                                signal api_if : inout ext_mem_vhdl_if_t) is
   begin
      write(conv_std_logic_vector(data, EXT_MAX_BIT_W), conv_std_logic_vector(address, EXT_MAX_BIT_W), bfm_id, api_if);
   end write;

   procedure read                              (data          : out std_logic_vector (EXT_MAX_BIT_W - 1 downto 0);
                                                address       : in std_logic_vector (EXT_MAX_BIT_W - 1 downto 0);
                                                bfm_id        : in integer;
                                                signal api_if : inout ext_mem_vhdl_if_t) is
   begin
      api_if(bfm_id).data_in1 <= address;
      api_if(bfm_id).req(EXT_MEM_READ) <= '1';
      wait until (ack_if(bfm_id).ack(EXT_MEM_READ) = '1');
      api_if(bfm_id).req(EXT_MEM_READ) <= '0';
      wait until (ack_if(bfm_id).ack(EXT_MEM_READ) = '0');
      data := ack_if(bfm_id).data_out3;
   end read;
   
   procedure read                              (data          : out integer;
                                                address       : in integer;
                                                bfm_id        : in integer;
                                                signal api_if : inout ext_mem_vhdl_if_t) is
   
      variable data_temp      : std_logic_vector (EXT_MAX_BIT_W - 1 downto 0);
   begin
      read(data_temp, conv_std_logic_vector(address, EXT_MAX_BIT_W), bfm_id, api_if);
      data := to_integer(data_temp);
   end read;

   procedure fill                              (data          : in std_logic_vector (EXT_MAX_BIT_W - 1 downto 0);
                                                increment     : in integer;
                                                address_low   : in std_logic_vector (EXT_MAX_BIT_W - 1 downto 0);
                                                address_high  : in std_logic_vector (EXT_MAX_BIT_W - 1 downto 0);
                                                bfm_id        : in integer;
                                                signal api_if : inout ext_mem_vhdl_if_t) is
   begin
      api_if(bfm_id).data_in0 <= increment;
      api_if(bfm_id).data_in1 <= address_low;
      api_if(bfm_id).data_in2 <= address_high;
      api_if(bfm_id).data_in3 <= data;
      api_if(bfm_id).req(EXT_MEM_FILL) <= '1';
      wait until (ack_if(bfm_id).ack(EXT_MEM_FILL) = '1');
      api_if(bfm_id).req(EXT_MEM_FILL) <= '0';
      wait until (ack_if(bfm_id).ack(EXT_MEM_FILL) = '0');
   end fill;
   
   procedure fill                              (data          : in integer;
                                                increment     : in integer;
                                                address_low   : in integer;
                                                address_high  : in integer;
                                                bfm_id        : in integer;
                                                signal api_if : inout ext_mem_vhdl_if_t) is
   begin
      fill(conv_std_logic_vector(data, EXT_MAX_BIT_W), increment, conv_std_logic_vector(address_low, EXT_MAX_BIT_W), conv_std_logic_vector(address_high, EXT_MAX_BIT_W), bfm_id, api_if);
   end fill;
   
   procedure write                             (data          : in std_logic_vector (EXT_MAX_BIT_W - 1 downto 0);
                                                address       : in std_logic_vector (EXT_MAX_BIT_W - 1 downto 0);
                                                bfm_id        : in integer;
                                                signal api_if : inout ext_mem_vhdl_if_base_t) is
   begin
      api_if.data_in1 <= address;
      api_if.data_in3 <= data;
      api_if.req(EXT_MEM_WRITE) <= '1';
      wait until (ack_if(bfm_id).ack(EXT_MEM_WRITE) = '1');
      api_if.req(EXT_MEM_WRITE) <= '0';
      wait until (ack_if(bfm_id).ack(EXT_MEM_WRITE) = '0');
   end write;
   
   procedure write                             (data          : in integer;
                                                address       : in integer;
                                                bfm_id        : in integer;
                                                signal api_if : inout ext_mem_vhdl_if_base_t) is
   begin
      write(conv_std_logic_vector(data, EXT_MAX_BIT_W), conv_std_logic_vector(address, EXT_MAX_BIT_W), bfm_id, api_if);
   end write;

   procedure read                              (data          : out std_logic_vector (EXT_MAX_BIT_W - 1 downto 0);
                                                address       : in std_logic_vector (EXT_MAX_BIT_W - 1 downto 0);
                                                bfm_id        : in integer;
                                                signal api_if : inout ext_mem_vhdl_if_base_t) is
   begin
      api_if.data_in1 <= address;
      api_if.req(EXT_MEM_READ) <= '1';
      wait until (ack_if(bfm_id).ack(EXT_MEM_READ) = '1');
      api_if.req(EXT_MEM_READ) <= '0';
      wait until (ack_if(bfm_id).ack(EXT_MEM_READ) = '0');
      data := ack_if(bfm_id).data_out3;
   end read;
   
   procedure read                              (data          : out integer;
                                                address       : in integer;
                                                bfm_id        : in integer;
                                                signal api_if : inout ext_mem_vhdl_if_base_t) is
   
      variable data_temp      : std_logic_vector (EXT_MAX_BIT_W - 1 downto 0);
   begin
      read(data_temp, conv_std_logic_vector(address, EXT_MAX_BIT_W), bfm_id, api_if);
      data := to_integer(data_temp);
   end read;

   procedure fill                              (data          : in std_logic_vector (EXT_MAX_BIT_W - 1 downto 0);
                                                increment     : in integer;
                                                address_low   : in std_logic_vector (EXT_MAX_BIT_W - 1 downto 0);
                                                address_high  : in std_logic_vector (EXT_MAX_BIT_W - 1 downto 0);
                                                bfm_id        : in integer;
                                                signal api_if : inout ext_mem_vhdl_if_base_t) is
   begin
      api_if.data_in0 <= increment;
      api_if.data_in1 <= address_low;
      api_if.data_in2 <= address_high;
      api_if.data_in3 <= data;
      api_if.req(EXT_MEM_FILL) <= '1';
      wait until (ack_if(bfm_id).ack(EXT_MEM_FILL) = '1');
      api_if.req(EXT_MEM_FILL) <= '0';
      wait until (ack_if(bfm_id).ack(EXT_MEM_FILL) = '0');
   end fill;
   
   procedure fill                              (data          : in integer;
                                                increment     : in integer;
                                                address_low   : in integer;
                                                address_high  : in integer;
                                                bfm_id        : in integer;
                                                signal api_if : inout ext_mem_vhdl_if_base_t) is
   begin
      fill(conv_std_logic_vector(data, EXT_MAX_BIT_W), increment, conv_std_logic_vector(address_low, EXT_MAX_BIT_W), conv_std_logic_vector(address_high, EXT_MAX_BIT_W), bfm_id, api_if);
   end fill;

   -- VHDL events implementation
   procedure event_api_call                    (bfm_id        : in integer) is
   begin
      wait until (ack_if(bfm_id).events(EXT_MEM_EVENT_API_CALL) = '1');
   end event_api_call;

end altera_external_memory_bfm_vhdl_pkg;
