-------------------------------------------------------------------------------
-- Title      : RMAP WRITE PROTOCOL
-- Project    : N-FEE
-------------------------------------------------------------------------------
-- File       : rmap_head_write.vhd
-- Author     : Rafael Corsi Ferrao - corsiferrao@gmail.com
-- Company    : Instituto Mauá de Tecnologia - NSEE
-- Created    : 2011-07-08
-- Last update: 2011-10-21
-- Platform   : Independet 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
--                           RMAP WRITE PROTOCOL                             --
-------------------------------------------------------------------------------
-- | Target Spw Address | Target SpW Address | Target Logical Address         |
-- | Protocol Identifier | Instructions | Key                                 |
-- | Repley address  | Repley address  | Repley address  | Repley address     |
-- | Repley address | Repley address | Repley address | Repley address        |
-- | Repley address  | Repley address  | Repley address  | Repley address     |
-- | Repley address | Repley address | Repley address | Repley address        |
-- | Initiator logical address | Transaction field(MS) | Transaction field(LS)|
-- | Extended Adress | Adress | Adress | Adress | Adress                      |
-- | Data Length | Data Length| Data Length                                   |
-------------------------------------------------------------------------------

-- Description: This Block implements the RMAP write protocol with the ability
-- of auto increment the transaction field, auto increment the address field,
-- and variable fisical address (0 to 2) 
-- 
-- Operations mode: 01 - transmission mode
--                  10 - incremental mode
--                  11 - random mode
--
-------------------------------------------------------------------------------
-- Copyright (c) 2011 Instituto Mauá de Tecnologia - NSEE - Brasil
------------------------------------------------------------------------------
-- Revisions  : Adicionado spw physical address 
-- Date        Version  Author  Description
-- 2015-4-16  2.0      corsi  modify
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Revisions  : O address step é duas vezes o valor estipulado quando usado o
-- modo automatico 
-- Date        Version  Author  Description
-- 2011-10-19  1.01      corsi  modify
-------------------------------------------------------------------------------
-- Revisions  : Corrigido o problema com o eof na hora de gravar em modo aleatório
-- Date        Version  Author  Description
-- 2011-07-08  1.01      corsi  modify
-------------------------------------------------------------------------------
-- Revisions  : 
-- Date        Version  Author  Description
-- 2011-07-08  1.0      corsi   Created
-------------------------------------------------------------------------------

-- Title      : RMAP WRITE PROTOCOL 



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity head_write is
  port (
    clk   : in std_logic;
    reset : in std_logic;               -- reset actives high

    sync_reset : in std_logic;

    ------------------------------------------------------------------------------
    -- Parametros do cabeçalho
    ------------------------------------------------------------------------------

    -- Step for address update if 0 use data length       
    config_address_step_in : in std_logic_vector(31 downto 0);

    config_fisical_length_in : in std_logic_vector(1 downto 0);  -- fisical addres length
                                                                 -- 00=0,
                                                                 -- 01=1,
                                                                 -- 10=11= 2

    -- Fisical Target address, used when fisical_length_in /= 00
    config_target_fisical_addr_in : in std_logic_vector(15 downto 0);

    -- Target Logical Address
    config_target_logical_in : in std_logic_vector(7 downto 0);

    -- Key 
    config_key_in : in std_logic_vector(7 downto 0);

    -- Used when the SpW networ has fisical address
    config_reply_addr_in : in std_logic_vector(15 downto 0);

    -- Initiator logical addr
    config_initiator_logical_addr_in : in std_logic_vector(7 downto 0);

    -- Extended Address
    config_addr_extend_in : in std_logic_vector(7 downto 0);

    -- Address MS
    config_addr3_in : in std_logic_vector(7 downto 0);

    -- Address MSLS
    config_addr2_in : in std_logic_vector(7 downto 0);

    -- Address LSMS
    config_addr1_in : in std_logic_vector(7 downto 0);

    -- Address LS
    config_addr0_in : in std_logic_vector(7 downto 0);

    -- Data Length MS
    config_length2_in : in std_logic_vector(7 downto 0);

    -- Data Length MSLS
    config_length1_in : in std_logic_vector(7 downto 0);

    -- Data Length LS
    config_length0_in : in std_logic_vector(7 downto 0);

    ---------------------------------------------------------------------------

    -- enable data (transmission and recording)
    enable_to_transmit_Byte : in std_logic;

    -- Reset address to default value (new CCD information)
    reset_address_in : in std_logic;

    -- Head data out
    head_data_out : out std_logic_vector(7 downto 0);

    -- Indicates block active
    head_idle_out : out std_logic;

    -- Indicates if the crc must be calculated (Pysical Address)
    head_crc_en  : out std_logic;

    -- high for one clock cycle to  indicate end of packet
    head_eof_out : out std_logic;

    -- high for one clock cycle to indicate valid data at head_data_out
    head_data_ready_out : out std_logic


    );
end entity head_write;


architecture bhv of head_write is

-------------------------------------------------------------------------------
-- Aux
-------------------------------------------------------------------------------
  
  signal transaction_counter : unsigned(15 downto 0) := (others => '0');
  signal enable_to_transmit  : std_logic;

  signal address_step       : unsigned(31 downto 0) := (others => '0');
  signal reset_address_flag : std_logic;

  signal addr_tmp : unsigned(39 downto 0);


-------------------------------------------------------------------------------
-- Head registers
-------------------------------------------------------------------------------
  -- Rmap identifier
  constant head_rmap_identifier : std_logic_vector(7 downto 0) := X"01";

  -- Instruction field: 01(packet type) 1001(write non ack non
  -- verify increment) 00(no reply field)
  constant head_instruction : std_logic_vector(7 downto 0) := "01100100";

-------------------------------------------------------------------------------
-- States
-------------------------------------------------------------------------------
  type state_tr is (trans_wait,
                    trans_target_physical_addr_1,
                    trans_target_physical_addr_2,
                    trans_target_logical_addr,
                    trans_delay,
                    trans_protocol_identifier,
                    trans_instruction,
                    trans_key,
                    trans_initiator_logical_addr,
                    trans_transaction_ms, trans_transaction_ls,
                    trans_extended_addr,
                    trans_addr3,
                    trans_addr2,
                    trans_addr1,
                    trans_addr0,
                    trans_length2,
                    trans_length1,
                    trans_length0,
                    trans_reconfig
                    );
  signal state_trans : state_tr;        -- states

  
  
begin  -- architecture bhv

-------------------------------------------------------------------------------
-- purpose: Make/send RMAP head
-------------------------------------------------------------------------------    

  set_trans : process (clk, reset) is
  begin  -- process set_enables
    if (reset = '1') then               -- asynchronous reset (active high)

      transaction_counter <= (others => '0');
      head_idle_out       <= '1';
      head_data_ready_out <= '0';
      head_eof_out        <= '0';
      head_crc_en         <= '0';
      addr_tmp            <= (others => '0');
	  head_data_out		  <= (others => '0');
      
    elsif (rising_edge(clk)) then      -- rising clock edge

      if (sync_reset = '1') then
        state_trans  <= trans_wait;
        head_crc_en  <= '0';
        addr_tmp     <= (others => '0');
      else
        
        case state_trans is
          
          when trans_wait =>
            head_idle_out       <= '1';
            head_data_ready_out <= '0';
            head_eof_out        <= '0';
            head_crc_en         <= '0';

            if (enable_to_transmit = '1') then
              state_trans <= trans_delay;
            else
              state_trans <= trans_wait;
            end if;
            
          when trans_delay =>
            if (reset_address_flag = '1') then
              head_data_ready_out <= '1';
              addr_tmp <= unsigned(config_addr_extend_in) & unsigned(config_addr3_in) & unsigned(config_addr2_in) & unsigned(config_addr1_in) & unsigned(config_addr0_in);
            else
              addr_tmp <= addr_tmp + address_step;
            end if;
            if(to_integer(unsigned(config_fisical_length_in)) > 0) then
                state_trans <= trans_target_physical_addr_1;
                head_crc_en <= '0';                             -- phy address nao tem crc

            else
                state_trans <= trans_target_logical_addr;
                head_crc_en <= '1';                             -- logical address possui crc
            end if;

          when trans_target_physical_addr_1 =>
            if (enable_to_transmit = '1') then
                head_data_ready_out <= '1';
                head_data_out       <= config_target_fisical_addr_in(15 downto 8);
                head_data_ready_out <= '1';
                
                if(config_fisical_length_in(1) = '1') then
                    state_trans         <= trans_target_physical_addr_2;
                    head_crc_en         <= '0';
                else
                    state_trans          <= trans_target_logical_addr;
                    head_crc_en          <= '1'; -- habilita crc
                end if;
             else
                state_trans         <= trans_target_physical_addr_1;
                head_data_ready_out <= '0';
             end if;

          when trans_target_physical_addr_2 =>
            if (enable_to_transmit = '1') then
                head_data_ready_out <= '1';
                state_trans         <= trans_target_logical_addr;
                head_data_out       <= config_target_fisical_addr_in(7 downto 0);
            else
                state_trans         <= trans_target_physical_addr_2;
                head_data_ready_out <= '0';
            end if;
         
          when trans_target_logical_addr =>
            if (enable_to_transmit = '1') then
                head_data_ready_out <= '1';
                state_trans         <= trans_protocol_identifier;
                head_data_out       <= config_target_logical_in;
            else
                state_trans         <= trans_target_logical_addr;
                head_data_ready_out <= '0';
            end if;

          when trans_protocol_identifier =>
            if (enable_to_transmit = '1') then
              head_data_ready_out <= '1';
              state_trans         <= trans_instruction;
              head_data_out       <= head_rmap_identifier;
            else
              state_trans         <= trans_protocol_identifier;
              head_data_ready_out <= '0';
            end if;

          when trans_instruction =>
            if (enable_to_transmit = '1') then
              head_data_ready_out <= '1';
              state_trans         <= trans_key;
              head_data_out       <= head_instruction;
            else
              state_trans         <= trans_instruction;
              head_data_ready_out <= '0';
            end if;

          when trans_key =>
            if (enable_to_transmit = '1') then
              head_data_ready_out <= '1';
              state_trans         <= trans_initiator_logical_addr;
              head_data_out       <= config_key_in;
            else
              state_trans         <= trans_key;
              head_data_ready_out <= '0';
            end if;

          when trans_initiator_logical_addr =>
            if (enable_to_transmit = '1') then
              head_data_ready_out <= '1';
              state_trans         <= trans_transaction_ms;
              head_data_out       <= config_initiator_logical_addr_in;
            else
              state_trans         <= trans_initiator_logical_addr;
              head_data_ready_out <= '0';
            end if;

          when trans_transaction_ms =>
            if (enable_to_transmit = '1') then
              head_data_ready_out <= '1';
              state_trans         <= trans_transaction_ls;
              head_data_out       <= std_logic_vector(transaction_counter(15 downto 8));
            else
              state_trans         <= trans_transaction_ms;
              head_data_ready_out <= '0';
            end if;

          when trans_transaction_ls =>
            if (enable_to_transmit = '1') then
              head_data_ready_out <= '1';
              state_trans         <= trans_extended_addr;
              head_data_out       <= std_logic_vector(transaction_counter(7 downto 0));
            else
              state_trans         <= trans_transaction_ls;
              head_data_ready_out <= '0';
            end if;

          when trans_extended_addr =>
            if (enable_to_transmit = '1') then
              head_data_ready_out <= '1';
              state_trans         <= trans_addr3;
              head_data_out       <= std_logic_vector(addr_tmp(39 downto 32));
            else
              state_trans         <= trans_extended_addr;
              head_data_ready_out <= '0';
            end if;

          when trans_addr3 =>
            if (enable_to_transmit = '1') then
              head_data_ready_out <= '1';
              state_trans         <= trans_addr2;
              head_data_out       <= std_logic_vector(addr_tmp(31 downto 24));
            else
              state_trans         <= trans_addr3;
              head_data_ready_out <= '0';
            end if;

          when trans_addr2 =>
            if (enable_to_transmit = '1') then
              head_data_ready_out <= '1';
              state_trans         <= trans_addr1;
              head_data_out       <= std_logic_vector(addr_tmp(23 downto 16));
            else
              state_trans         <= trans_addr2;
              head_data_ready_out <= '0';
            end if;

          when trans_addr1 =>
            if (enable_to_transmit = '1') then
              head_data_ready_out <= '1';
              state_trans         <= trans_addr0;
              head_data_out       <= std_logic_vector(addr_tmp(15 downto 8));
            else
              state_trans         <= trans_addr1;
              head_data_ready_out <= '0';
            end if;

          when trans_addr0 =>
            if (enable_to_transmit = '1') then
              head_data_ready_out <= '1';
              state_trans         <= trans_length2;
              head_data_out       <= std_logic_vector(addr_tmp(7 downto 0));
            else
              state_trans         <= trans_addr0;
              head_data_ready_out <= '0';
            end if;

          when trans_length2 =>
            if (enable_to_transmit = '1') then
              head_data_ready_out <= '1';
              state_trans         <= trans_length1;
              head_data_out       <= config_length2_in;
            else
              state_trans         <= trans_length2;
              head_data_ready_out <= '0';
            end if;

          when trans_length1 =>
            if (enable_to_transmit = '1') then
              head_data_ready_out <= '1';
              state_trans         <= trans_length0;
              head_data_out       <= config_length1_in;
            else
              state_trans         <= trans_length1;
              head_data_ready_out <= '0';
            end if;

          when trans_length0 =>
            if (enable_to_transmit = '1') then
              head_data_ready_out <= '1';
              head_eof_out        <= '1';
              head_idle_out       <= '0';
              state_trans         <= trans_reconfig;
              head_data_out       <= config_length0_in;
            else
              state_trans         <= trans_length0;
              head_data_ready_out <= '0';
            end if;

          when trans_reconfig =>
            head_eof_out        <= '0';
            head_data_ready_out <= '0';
            state_trans         <= trans_wait;
            transaction_counter <= transaction_counter + to_unsigned(1, 1);
        end case;
      end if;
    end if;
  end process set_trans;

  -----------------------------------------------------------------------------
  -- Reset address to default value ?
  -----------------------------------------------------------------------------
  process (clk, reset) is
  begin
    if (reset = '1') then               -- asynchronous reset (active high)
      reset_address_flag <= '0';
    elsif (rising_edge(clk)) then       -- rising clock edge
      if (state_trans = trans_target_logical_addr) then
        reset_address_flag <= '0';
      elsif (reset_address_in = '1') then
        reset_address_flag <= '1';
      else
        reset_address_flag <= reset_address_flag;
      end if;
    end if;
  end process;


-------------------------------------------------------------------------------
--  sample of outputs at rising edge
-------------------------------------------------------------------------------
  sample : process (clk, reset) is
  begin  -- process sample
    if(reset = '1') then
      
      address_step       <= (others => '0');
      enable_to_transmit <= '0';
      
    elsif(rising_edge(clk)) then

      enable_to_transmit <= enable_to_transmit_Byte;

      -- check the address step for  ccd transmission
      if (config_address_step_in /= X"00000000") then
        address_step <= unsigned(config_address_step_in(31 downto 0));
      else
        address_step <= "0000000" & unsigned(config_length2_in) & unsigned(config_length1_in) & unsigned(config_length0_in) & '0';
      end if;
      
    end if;
  end process sample;

end architecture bhv;
