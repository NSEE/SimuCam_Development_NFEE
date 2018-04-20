-------------------------------------------------------------------------------
-- Title      : RMAP READER
-- Project    : 
-------------------------------------------------------------------------------
-- File       : rmap_read6.vhd
-- Author     : Rafael Corsi Ferrao  <corsiferrao@gmail.com>
-- Company    : Instituto Maua de Tecnologia - NSEE - Brasil
-- Created    : 2011-07-13
-- Last update: 2011-09-23
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2011
-- 
-------------------------------------------------------------------------------
-- Revisions  :
-------------------------------------------------------------------------------
-- Date        Versio   Author  Description
-- 2011-08-29  1.01     corsi   Modificao no nome da porta de fifo de gravacao
-------------------------------------------------------------------------------
-- Date        Version  Author  Description
-- 2011-07-13  1.0      corsi   Created
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity rmap_reply is
  generic(
    hk_start_address : natural := 64;
    hk_end_address   : natural := 127;
    memory_length    : natural := 9
    );

  port (
-------------------------------------------------------------------------------
-- Global
-------------------------------------------------------------------------------    
    clk      : in std_logic;
    clk_slow : in std_logic;
    rst      : in std_logic;

-------------------------------------------------------------------------------
--  Read
-------------------------------------------------------------------------------
    -- Gives the reply block status, read block will only operate on idle=1
    reply_idle_out : out std_logic;

    -- Data lenght
    data_length_in : in std_logic_vector(23 downto 0);

    -- Provides the begin address
    data_address_in : in std_logic_vector(memory_length-1 downto 0);

    -- Read block detected read or write op
    read_op_in  : in std_logic;         -- Operacao de leitura 
    write_op_in : in std_logic;         -- Operação de escrita 

    -- Data recovered from readed head
    reply_size_in                : in std_logic_vector(1 downto 0);
    reply_addr_in                : in std_logic_vector(95 downto 0);
    transaction_counter_in       : in std_logic_vector(15 downto 0);
    initiator_logical_address_in : in std_logic_vector(7 downto 0);
    verify_data_in               : in std_logic;
    increment_data_in            : in std_logic;
    reply_en_in                  : in std_logic;

    -- ERROR flags
    eep_data_in                   : in std_logic;
    unsed_rmap_type_in            : in std_logic;
    rmap_not_autrorized_in        : in std_logic;
    invalid_key_in                : in std_logic;
    invalid_target_logical_add_in : in std_logic;
    invalid_data_crc_in           : in std_logic;
    verify_buffer_overrun_in      : in std_logic;
    too_much_data_in              : in std_logic;
    insufficient_data_in          : in std_logic;
    address_out_of_range_in       : in std_logic;

-------------------------------------------------------------------------------
-- Spw Autonomous FIFO
-------------------------------------------------------------------------------

    fifo_dout_out   : out std_logic_vector(8 downto 0);
    fifo_nwrite_out : out std_logic;
    fifo_full_in    : in  std_logic;

-------------------------------------------------------------------------------
-- Configurations 
-------------------------------------------------------------------------------

    logical_address_in      : in  std_logic_vector(7 downto 0);
    enable_hk_transmit_in   : in  std_logic;
    free_to_transmit_in     : in  std_logic;
    request_to_transmit_out : out std_logic;

-------------------------------------------------------------------------------
-- Memory address
-------------------------------------------------------------------------------

    memory_enable_out : out std_logic;
    memory_addr_out   : out std_logic_vector(memory_length-1 downto 0) := (others => '0');

    memory_data_ready_in : in std_logic;
    memory_data_in       : in std_logic_vector(7 downto 0);

-------------------------------------------------------------------------------
-- HouseKeep information
-------------------------------------------------------------------------------
    hk_accepted_out : out std_logic;
    hk_rejected_out : out std_logic
    );

end entity rmap_reply;

architecture bhv of rmap_reply is

-------------------------------------------------------------------------------
-- Signals
-------------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  -- CRC
  -----------------------------------------------------------------------------

  signal crc_rst, crc_enable, crc_get, crc_idle, crc_ready, crc_sclr : std_logic := '0';

  signal crc_dout, crc_din : std_logic_vector(7 downto 0);

  -----------------------------------------------------------------------------
  -- FIFO
  -----------------------------------------------------------------------------

  signal fifo_din, fifo_dout_int          : std_logic_vector(8 downto 0);
  signal fifo_wrreq, fifo_full, fifo_sclr : std_logic := '1';
  signal fifo_empty_spw                   : std_logic;

  -----------------------------------------------------------------------------
  --REPLY
  -----------------------------------------------------------------------------

  type reply_v is array (0 to 12) of std_logic_vector(7 downto 0);
  signal reply : reply_v;

  signal reply_real_size : natural range 0 to 12 := 0;

  -----------------------------------------------------------------------------
  -- Memory addressing
  -----------------------------------------------------------------------------

  signal memory_addr       : unsigned(memory_length-1 downto 0) := (others => '0');
  signal memory_counter    : unsigned(23 downto 0)              := (others => '0');
  signal memory_data_ready : std_logic                          := '0';

  -----------------------------------------------------------------------------
  -- Hk
  -----------------------------------------------------------------------------

  signal hk_accepted, hk_rejected : std_logic := '0';

  -----------------------------------------------------------------------------
  -- Status
  -----------------------------------------------------------------------------

  signal status, status_sampled : std_logic_vector(7 downto 0);

  signal write_read, write_read_sampled : std_logic := '0';  -- 0 = write
                                                             -- 1 = read

-------------------------------------------------------------------------------
-- Constants
-------------------------------------------------------------------------------

  constant eop             : std_logic_vector(8 downto 0) := "100000000";  -- EOP
  constant eep             : std_logic_vector(8 downto 0) := "100000001";  -- EEP
  constant rmap_identifier : std_logic_vector(7 downto 0) := X"01";

-- states -------------------------------------------------------------------

  type state_reply is (re_wait,
                       re_preset,
                       re_addr11,
                       re_addr10,
                       re_addr9,
                       re_addr8,
                       re_addr7,
                       re_addr6,
                       re_addr5,
                       re_addr4,
                       re_addr3,
                       re_addr2,
                       re_addr1,
                       re_initiator,
                       re_identifier,
                       re_instruction,
                       re_status,
                       re_target_logical,
                       re_transaction_ms,
                       re_transaction_ls,
                       re_reserved,
                       re_get_head_crc,
                       re_calculate_head_crc,
                       re_head_eop,
                       re_data_length_ms,
                       re_data_length,
                       re_data_length_ls,
                       re_get_head_crc_read,
                       re_calculate_head_crc_read,
                       re_preset_data,
                       re_addressing,
                       re_request_data,
                       re_send_data,
                       re_send_data0,
                       re_send_data_A0,
                       re_send_data_B0,
                       re_get_data_crc,
                       re_calculate_data_crc,
                       re_data_eop,
                       re_teste
                       );

  signal state_re : state_reply;


--constant reply_addr_in                :  std_logic_vector(95 downto 0) := X";

-------------------------------------------------------------------------------
-- Begin
-------------------------------------------------------------------------------

begin  -- architecture bhv

-------------------------------------------------------------------------------
-- Maps
-------------------------------------------------------------------------------
  
  Re0 : entity Modulo_crc_top
    port map (
      clock           => clk,
      clear           => crc_rst,
      enable_ler_data => crc_enable,
      get_crc         => crc_get,
      data_in         => crc_din,
      crc_out         => crc_dout,
      idle            => crc_idle,
      CRC_ready       => crc_ready
      );

  Re1 : entity reply_autonomus
    port map (
      clk    => clk,
      rst    => fifo_sclr,
      din    => fifo_din,
      nread  => fifo_full_in,           -- From application
      nwrite => fifo_wrreq,
      empty  => fifo_empty_spw,
      full   => fifo_full,
      dout   => fifo_dout_int           -- To Sync FIFO
      );

-------------------------------------------------------------------------------
-- State machine, falling edge
-------------------------------------------------------------------------------

  reply_state : process (clk, rst) is
  begin  -- process reply
    if (rst = '1') then                 -- asynchronous reset (active high)
      state_re          <= re_wait;
      crc_enable        <= '0';
      crc_sclr          <= '1';
      fifo_sclr         <= '1';
      fifo_wrreq        <= '1';
      reply_idle_out    <= '1';
      memory_enable_out <= '0';
    elsif (rising_edge(clk)) then      -- rising clock edge
      case state_re is
        when re_wait =>
          crc_enable         <= '0';
          crc_sclr           <= '0';
          fifo_sclr          <= '0';
          fifo_wrreq         <= '1';
          memory_enable_out  <= '0';
          write_read_sampled <= write_read;
          status_sampled     <= status;
          if (status /= X"FF") then
            reply_idle_out <= '0';
            state_re       <= re_preset;
          else
            reply_idle_out <= '1';
            state_re       <= re_wait;
          end if;

          ---------------------------------------------------------------------
          -- Read and write reply head
          ---------------------------------------------------------------------

        when re_preset =>
          if (crc_idle = '1' and fifo_full = '0') then
            fifo_wrreq <= '0';
            if (reply_size_in = "00") then  -- No reply addr
              state_re   <= re_identifier;
              crc_din    <= initiator_logical_address_in;
              fifo_din   <= '0' & initiator_logical_address_in;
              crc_enable <= '1';
            else
              case reply_real_size is       -- Check for reply addr size
                when 12 =>
                  state_re   <= re_addr11;
                  crc_din    <= reply(12);
                  fifo_din   <= '0' & reply(12);
                  crc_enable <= '0';
                when 11 =>
                  state_re   <= re_addr10;
                  crc_din    <= reply(11);
                  fifo_din   <= '0' & reply(11);
                  crc_enable <= '0';
                when 10 =>
                  state_re   <= re_addr9;
                  crc_din    <= reply(10);
                  fifo_din   <= '0' & reply(10);
                  crc_enable <= '0';
                when 9 =>
                  state_re   <= re_addr8;
                  crc_din    <= reply(9);
                  fifo_din   <= '0' & reply(9);
                  crc_enable <= '0';
                when 8 =>
                  state_re   <= re_addr7;
                  crc_din    <= reply(8);
                  fifo_din   <= '0' & reply(8);
                  crc_enable <= '0';
                when 7 =>
                  state_re   <= re_addr6;
                  crc_din    <= reply(7);
                  fifo_din   <= '0' & reply(7);
                  crc_enable <= '0';
                when 6 =>
                  state_re   <= re_addr5;
                  crc_din    <= reply(6);
                  fifo_din   <= '0' & reply(6);
                  crc_enable <= '0';
                when 5 =>
                  state_re   <= re_addr4;
                  crc_din    <= reply(5);
                  fifo_din   <= '0' & reply(5);
                  crc_enable <= '0';
                when 4 =>
                  state_re   <= re_addr3;
                  crc_din    <= reply(4);
                  fifo_din   <= '0' & reply(4);
                  crc_enable <= '0';
                when 3 =>
                  state_re   <= re_addr2;
                  crc_din    <= reply(3);
                  fifo_din   <= '0' & reply(3);
                  crc_enable <= '0';
                when 2 =>
                  state_re   <= re_addr1;
                  crc_din    <= reply(2);
                  fifo_din   <= '0' & reply(2);
                  crc_enable <= '0';
                when 1 =>
                  state_re   <= re_initiator;
                  crc_din    <= reply(1);
                  fifo_din   <= '0' & reply(1);
                  crc_enable <= '0';
                when others =>
                  state_re   <= re_initiator;
                  crc_din    <= (others => '0');
                  fifo_din   <= (others => '0');
                  crc_enable <= '0';
              end case;
            end if;
          else
            state_re <= re_preset;
          end if;

        -- Initiator Addr field
        when re_initiator =>
          crc_din  <= logical_address_in;
          fifo_din <= '0' & logical_address_in;
          if (crc_idle = '1' and fifo_full = '0') then
            state_re   <= re_identifier;
            fifo_wrreq <= '0';
            crc_enable <= '1';
          else
            state_re   <= re_initiator;
            fifo_wrreq <= '1';
            crc_enable <= '0';
          end if;

        -- Identifier field
        when re_identifier =>
          crc_din  <= rmap_identifier;
          fifo_din <= '0' & rmap_identifier;
          if (crc_idle = '1' and fifo_full = '0') then
            state_re   <= re_instruction;
            fifo_wrreq <= '0';
            crc_enable <= '1';
          else
            state_re   <= re_identifier;
            fifo_wrreq <= '1';
            crc_enable <= '0';
          end if;

        --Instruction fiels
        when re_instruction =>
          if (write_read_sampled = '0') then  -- Write op
            crc_din  <= '0' & '0' & '1' & verify_data_in & reply_en_in & increment_data_in & reply_size_in;
            fifo_din <= '0' & '0' & '0' & '1' & verify_data_in & reply_en_in & increment_data_in & reply_size_in;
          else                                -- Read op
            crc_din  <= '0' & '0' & '0' & '0' & '1' & increment_data_in & reply_size_in;
            fifo_din <= '0' & '0' & '0' & '0' & '0' & '1' & increment_data_in & reply_size_in;
          end if;
          if (crc_idle = '1' and fifo_full = '0') then
            state_re   <= re_status;
            fifo_wrreq <= '0';
            crc_enable <= '1';
          else
            state_re   <= re_instruction;
            fifo_wrreq <= '1';
            crc_enable <= '0';
          end if;

        --Status field
        when re_status =>
          crc_din  <= status_sampled;
          fifo_din <= '0' & status_sampled;
          if (crc_idle = '1' and fifo_full = '0') then
            state_re   <= re_target_logical;
            fifo_wrreq <= '0';
            crc_enable <= '1';
          else
            state_re   <= re_status;
            fifo_wrreq <= '1';
            crc_enable <= '0';
          end if;

        --Sampled Logical Address
        when re_target_logical =>
          crc_din  <= logical_address_in;
          fifo_din <= '0' & logical_address_in;
          if (crc_idle = '1' and fifo_full = '0') then
            state_re   <= re_transaction_ms;
            fifo_wrreq <= '0';
            crc_enable <= '1';
          else
            state_re   <= re_target_logical;
            fifo_wrreq <= '1';
            crc_enable <= '0';
          end if;

        --Transaction counter MS field
        when re_transaction_ms =>
          crc_din  <= transaction_counter_in(15 downto 8);
          fifo_din <= '0' & transaction_counter_in(15 downto 8);
          if (crc_idle = '1' and fifo_full = '0') then
            state_re   <= re_transaction_ls;
            fifo_wrreq <= '0';
            crc_enable <= '1';
          else
            state_re   <= re_transaction_ms;
            fifo_wrreq <= '1';
            crc_enable <= '0';
          end if;

        --Transaction counter LS fiels
        when re_transaction_ls =>
          crc_din  <= transaction_counter_in(7 downto 0);
          fifo_din <= '0' & transaction_counter_in(7 downto 0);
          if (crc_idle = '1' and fifo_full = '0') then
            if (write_read_sampled = '0') then
              -- If reply to write, get head crc
              state_re <= re_get_head_crc;
            else
              -- If reply to read, keep sending head
              state_re <= re_reserved;
            end if;
          else
            state_re   <= re_transaction_ls;
            fifo_wrreq <= '1';
            crc_enable <= '0';
          end if;

          -------------------------------------------------------------------
          -- Head CRC (write reply crc)
          -------------------------------------------------------------------

        when re_get_head_crc =>
          fifo_wrreq <= '1';
          crc_enable <= '0';
          if (crc_idle = '1' and fifo_full = '0') then
            state_re <= re_calculate_head_crc;
            crc_get  <= '1';
          else
            state_re <= re_get_head_crc;
          end if;

        when re_calculate_head_crc =>
          crc_get    <= '0';
          crc_enable <= '0';
          fifo_din   <= '0' & crc_dout;
          if (crc_idle = '1' or crc_ready = '1') then
            state_re   <= re_head_eop;
            fifo_wrreq <= '0';
          else
            state_re   <= re_calculate_head_crc;
            fifo_wrreq <= '1';
          end if;

          -------------------------------------------------------------------
          -- Head EOP (write reply eop)
          -------------------------------------------------------------------

        when re_head_eop =>
          crc_enable <= '0';
          fifo_din   <= eop;
          if (crc_idle = '1' and fifo_full = '0') then
            state_re   <= re_wait;
            fifo_wrreq <= '0';
            crc_sclr   <= '1';
          else
            state_re   <= re_head_eop;
            fifo_wrreq <= '1';
          end if;

          ---------------------------------------------------------------------
          -- Head complement for read reply
          ---------------------------------------------------------------------

        -- Reserved field
        when re_reserved =>
          crc_din  <= X"00";
          fifo_din <= '0' & X"00";
          if (crc_idle = '1' and fifo_full = '0') then
            state_re   <= re_data_length_ms;
            fifo_wrreq <= '0';
            crc_enable <= '1';
          else
            state_re   <= re_reserved;
            fifo_wrreq <= '1';
            crc_enable <= '0';
          end if;

        -- Data length ms field
        when re_data_length_ms =>
          crc_din  <= data_length_in(23 downto 16);
          fifo_din <= '0' & data_length_in(23 downto 16);
          if (crc_idle = '1' and fifo_full = '0') then
            state_re   <= re_data_length;
            fifo_wrreq <= '0';
            crc_enable <= '1';
          else
            state_re   <= re_data_length_ms;
            fifo_wrreq <= '1';
            crc_enable <= '0';
          end if;

        -- Data length field
        when re_data_length =>
          crc_din  <= data_length_in(15 downto 8);
          fifo_din <= '0' & data_length_in(15 downto 8);
          if (crc_idle = '1' and fifo_full = '0') then
            state_re   <= re_data_length_ls;
            fifo_wrreq <= '0';
            crc_enable <= '1';
          else
            state_re   <= re_data_length;
            fifo_wrreq <= '1';
            crc_enable <= '0';
          end if;


        -- Data length LS field
        when re_data_length_ls =>
          crc_din  <= data_length_in(7 downto 0);
          fifo_din <= '0' & data_length_in(7 downto 0);
          if (crc_idle = '1' and fifo_full = '0') then
            state_re   <= re_get_head_crc_read;
            fifo_wrreq <= '0';
            crc_enable <= '1';
          else
            state_re   <= re_data_length_ls;
            fifo_wrreq <= '1';
            crc_enable <= '0';
          end if;

          -------------------------------------------------------------------
          -- Head CRC (read reply)
          -------------------------------------------------------------------

        when re_get_head_crc_read =>
          fifo_wrreq <= '1';
          crc_enable <= '0';
          if (crc_idle = '1' and fifo_full = '0') then
            if (status_sampled = X"00") then
              state_re <= re_calculate_head_crc_read;
            else
              state_re <= re_calculate_head_crc;
            end if;
            crc_get <= '1';
          else
            state_re <= re_get_head_crc_read;
          end if;

        when re_calculate_head_crc_read =>
          crc_get    <= '0';
          crc_enable <= '0';
          fifo_din   <= '0' & crc_dout;
          if (crc_idle = '1' or crc_ready = '1') then
            state_re   <= re_preset_data;
            fifo_wrreq <= '0';
          else
            state_re   <= re_calculate_head_crc_read;
            fifo_wrreq <= '1';
          end if;

          ---------------------------------------------------------------------
          -- Data
          ---------------------------------------------------------------------

        -- Preset variables
        when re_preset_data =>
          fifo_wrreq     <= '1';
          crc_sclr       <= '1';
          crc_enable     <= '0';
          memory_addr    <= unsigned(data_address_in);
          memory_counter <= to_unsigned(1, 24);  --1
          state_re       <= re_addressing;

        -- Address the memory
        when re_addressing =>
          crc_sclr        <= '0';
          crc_enable      <= '0';
          fifo_wrreq      <= '1';
          memory_addr_out <= std_logic_vector(memory_addr);
          state_re        <= re_request_data;

        when re_request_data =>
          if (crc_idle = '1' and fifo_full = '0') then
            state_re          <= re_send_data;
            memory_enable_out <= '1';
          else
            state_re          <= re_request_data;
            memory_enable_out <= '0';
          end if;

        --Enable read and update address pointer
        when re_send_data =>
          memory_enable_out <= '0';
          crc_din           <= memory_data_in;
          fifo_din          <= '0' & memory_data_in;
          if (memory_data_ready = '1') then
            state_re <= re_send_data0;
          else
            state_re <= re_send_data;
          end if;
          
        when re_send_data0 =>
          -- Keep sending data
          if (memory_counter < unsigned(data_length_in)) then
            state_re <= re_send_data_A0;
          else
            state_re <= re_send_data_B0;
          end if;

        when re_send_data_A0 =>
          if (increment_data_in = '1') then
            memory_addr <= memory_addr + to_unsigned(1, 1);
          else
            memory_addr <= unsigned(data_address_in);
          end if;
          crc_enable     <= '1';
          fifo_wrreq     <= '0';
          memory_counter <= memory_counter + to_unsigned(1, 1);
          state_re       <= re_addressing;
          
        when re_send_data_B0 =>
          if (memory_counter = unsigned(data_length_in)) then
            crc_enable <= '1';
            fifo_wrreq <= '0';
            --  state_re   <= re_get_data_crc;
            state_re   <= re_teste;
          else
            -- No more data to send 
            crc_enable <= '0';
            fifo_wrreq <= '1';
            state_re   <= re_get_data_crc;
          end if;
        -------------------------------------------------------------------
        -- Data CRC (read reply)
        -------------------------------------------------------------------
        when re_teste =>
          state_re   <= re_get_data_crc;
          crc_enable <= '0';
          fifo_wrreq <= '1';
          crc_din    <= memory_data_in;
          fifo_din   <= '0' & memory_data_in;
          
        when re_get_data_crc =>
          fifo_wrreq <= '1';
          crc_enable <= '0';
          crc_din    <= memory_data_in;
          fifo_din   <= '0' & memory_data_in;
          if (crc_idle = '1' and fifo_full = '0') then
            state_re <= re_calculate_data_crc;
            crc_get  <= '1';
          else
            state_re <= re_get_data_crc;
          end if;

        when re_calculate_data_crc =>
          crc_get    <= '0';
          crc_enable <= '0';
          fifo_din   <= '0' & crc_dout;
          crc_din    <= memory_data_in;
          fifo_din   <= '0' & memory_data_in;
          if (crc_idle = '1' or crc_ready = '1') then
            state_re   <= re_data_eop;
            fifo_wrreq <= '0';
          else
            state_re   <= re_calculate_data_crc;
            fifo_wrreq <= '1';
          end if;

          -------------------------------------------------------------------
          -- Data EOP (read reply)
          -------------------------------------------------------------------

        when re_data_eop =>
          crc_enable <= '0';
          fifo_din   <= eop;
          if (crc_idle = '1' and fifo_full = '0') then
            state_re   <= re_wait;
            fifo_wrreq <= '0';
            crc_sclr   <= '1';
          else
            state_re   <= re_data_eop;
            fifo_wrreq <= '1';
          end if;

        when others =>
          state_re <= re_preset;
          
      end case;
    end if;
  end process reply_state;

-------------------------------------------------------------------------------
-- Update Status information
-------------------------------------------------------------------------------
  status_up : process (clk, rst, reply_en_in) is
  begin  -- process status
    if (rst = '1') then
      status      <= X"FF";
      hk_accepted <= '0';
      hk_rejected <= '0';
    elsif (rising_edge(clk) and reply_en_in = '1') then
      
      hk_accepted <= '0';
      hk_rejected <= '0';

      -- Define STATUS field, if =/ than FF send an package
      if (unsed_rmap_type_in = '1') then
        status <= X"02";                -- 2 (Unused RMAP Packet Type/Code)
      elsif (rmap_not_autrorized_in = '1') then
        status <= X"0A";              -- 10 (Rmap Command not implemented/auto)
      elsif (address_out_of_range_in = '1') then
        status <= X"0A";              -- 10 (Rmap Write command out of range)  
      elsif (invalid_data_crc_in = '1') then
        status <= X"04";                -- 4 (Invalid data CRC)
      elsif (invalid_key_in = '1') then
        status <= X"03";                -- 3 (Invalid Key)
      elsif (invalid_target_logical_add_in = '1') then
        status <= X"0C";                -- 12 (Invalidd Target Logical Address)
      elsif (verify_buffer_overrun_in = '1') then
        status <= X"09";                -- 9 (Verify buffer overrun)
      elsif (too_much_data_in = '1') then
        status <= X"06";                -- 6 (Too much data)
      elsif (insufficient_data_in = '1') then
        status <= X"05";                -- 5 (Early EOP)
      elsif (eep_data_in = '1') then
        status <= X"07";                -- 7 (EEP)
      elsif (write_op_in = '1') then    -- Write op
        status     <= X"00";            -- 0 (No erro)
        write_read <= '0';
      elsif (read_op_in = '1') then     -- Read op
        
        if ((unsigned(data_address_in) >= to_unsigned(hk_start_address, data_address_in'length)) and (unsigned(data_address_in) <= to_unsigned(hk_end_address, data_address_in'length))) then
          if (enable_hk_transmit_in = '1') then
            status      <= X"00";
            write_read  <= '1';
            hk_accepted <= '1';
            hk_rejected <= '0';
          else
            status      <= X"0A";  -- 10 (Rmap Command not implemented/auto)
            write_read  <= '1';
            hk_accepted <= '0';
            hk_rejected <= '1';
          end if;
        else
          status      <= X"00";
          write_read  <= '1';
          hk_accepted <= '0';
          hk_rejected <= '0';
        end if;
      else
        status <= X"FF";                --inside use indicates no op
      end if;
    end if;
  end process status_up;

  ------------------------------------------------------------------------------
  -- internal rising to falling
  -- PLATO 2.0 : removido falling
  -----------------------------------------------------------------------------
      hk_rejected_out <= hk_rejected;
      hk_accepted_out <= hk_accepted;

  -----------------------------------------------------------------------------
  -- Outside rising to falling
  -- PLATO 2.0 : removido falling
  -----------------------------------------------------------------------------
      memory_data_ready <= memory_data_ready_in;


-------------------------------------------------------------------------------
-- Check the real reply address'length
-------------------------------------------------------------------------------  

  reply_real_size <=
    12 when ((reply_addr_in(95) or reply_addr_in(94) or reply_addr_in(93) or reply_addr_in(92) or
              reply_addr_in(91) or reply_addr_in(90) or reply_addr_in(89) or reply_addr_in(88)) = '1') else

    11 when ((reply_addr_in(87) or reply_addr_in(86) or reply_addr_in(85) or reply_addr_in(84) or
              reply_addr_in(83) or reply_addr_in(82) or reply_addr_in(81) or reply_addr_in(80)) = '1') else

    10 when ((reply_addr_in(79) or reply_addr_in(78) or reply_addr_in(77) or reply_addr_in(76) or
              reply_addr_in(75) or reply_addr_in(74) or reply_addr_in(73) or reply_addr_in(72)) = '1') else

    9 when ((reply_addr_in(71) or reply_addr_in(70) or reply_addr_in(69) or reply_addr_in(68) or
             reply_addr_in(67) or reply_addr_in(65) or reply_addr_in(64) or reply_addr_in(63)) = '1') else

    8 when ((reply_addr_in(63) or reply_addr_in(62) or reply_addr_in(61) or reply_addr_in(60) or
             reply_addr_in(59) or reply_addr_in(58) or reply_addr_in(57) or reply_addr_in(56)) = '1') else

    7 when ((reply_addr_in(55) or reply_addr_in(54) or reply_addr_in(53) or reply_addr_in(52) or
             reply_addr_in(51) or reply_addr_in(50) or reply_addr_in(49) or reply_addr_in(48)) ='1')  else

    6 when ((reply_addr_in(47) or reply_addr_in(46) or reply_addr_in(45) or reply_addr_in(44) or
             reply_addr_in(43) or reply_addr_in(42) or reply_addr_in(41) or reply_addr_in(40)) ='1') else

    5 when ((reply_addr_in(39) or reply_addr_in(38) or reply_addr_in(37) or reply_addr_in(36) or
             reply_addr_in(35) or reply_addr_in(34) or reply_addr_in(33) or reply_addr_in(32)) = '1') else

    4 when ((reply_addr_in(31) or reply_addr_in(30) or reply_addr_in(29) or reply_addr_in(28) or
             reply_addr_in(27) or reply_addr_in(26) or reply_addr_in(25) or reply_addr_in(24)) = '1') else

    3 when ((reply_addr_in(23) or reply_addr_in(22) or reply_addr_in(21) or reply_addr_in(20) or
             reply_addr_in(19) or reply_addr_in(18) or reply_addr_in(17) or reply_addr_in(16)) = '1') else

    2 when ((reply_addr_in(15) or reply_addr_in(14) or reply_addr_in(13) or reply_addr_in(12) or
             reply_addr_in(11) or reply_addr_in(10) or reply_addr_in(9) or reply_addr_in(8)) = '1') else

    1 when ((reply_addr_in(7) or reply_addr_in(6) or reply_addr_in(5) or reply_addr_in(4) or
             reply_addr_in(3) or reply_addr_in(2) or reply_addr_in(1) or reply_addr_in(0)) = '1') else

    0;

-------------------------------------------------------------------------------
-- reply discreto
-------------------------------------------------------------------------------

  reply(12) <= reply_addr_in(95 downto 88);
  reply(11) <= reply_addr_in(87 downto 80);
  reply(10) <= reply_addr_in(79 downto 72);
  reply(9)  <= reply_addr_in(71 downto 64);
  reply(8)  <= reply_addr_in(63 downto 56);
  reply(7)  <= reply_addr_in(55 downto 48);
  reply(6)  <= reply_addr_in(47 downto 40);
  reply(5)  <= reply_addr_in(39 downto 32);
  reply(4)  <= reply_addr_in(31 downto 24);
  reply(3)  <= reply_addr_in(23 downto 16);
  reply(2)  <= reply_addr_in(15 downto 8);
  reply(1)  <= reply_addr_in(7 downto 0);

-------------------------------------------------------------------------------
-- CRC
-------------------------------------------------------------------------------  
  crc_rst <= rst or crc_sclr;

------------------------------------------------------------------------------
-- Out
-------------------------------------------------------------------------------

  process (clk, rst)
  begin
    if (rst = '1') then
      fifo_nwrite_out <= '1';
    elsif (rising_edge(clk)) then
      fifo_dout_out <= fifo_dout_int;
      if (free_to_transmit_in = '1') then
        fifo_nwrite_out <= fifo_empty_spw;
      else
        fifo_nwrite_out <= '1';
      end if;
    end if;
  end process;

  --fifo_nwrite_out <= fifo_empty_spw when (free_to_transmit_in = '1') else
  --                   '1';

  request_to_transmit_out <= '1' when (fifo_empty_spw = '0') or (state_re /= re_wait) else
                             '0';

  
end bhv;
