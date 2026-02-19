-------------------------------------------------------------------------------
-- Title      : RMAP READER
-- Project    : 
-------------------------------------------------------------------------------
-- File       : rmap_read6.vhd
-- Author     : Rafael Corsi Ferrao  <corsiferrao@gmail.com>
-- Company    : Instituto Maua de Tecnologia - NSEE - Brasil
-- Created    : 2011-07-13
-- Last update: 2011-10-07
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2011 
-------------------------------------------------------------------------------
-- Revisions  : 
--            :
-- Date        Version  Author  Description
-- 2011-07-13  1.0      corsi   Created
-------------------------------------------------------------------------------
-- Future implementations:
-- a 
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity rmap_reader is
  generic (
    memory_length : natural := 9
    );
  port (
-------------------------------------------------------------------------------
-- Global
-------------------------------------------------------------------------------    
    clk      : in std_logic;
    rst      : in std_logic;

    enable_reader_in : in std_logic;

-------------------------------------------------------------------------------
-- To Application
-------------------------------------------------------------------------------

    read_op_out      : out std_logic;   -- Operacao de leitura ok
    write_op_out     : out std_logic;   -- Operação de escrita ok
    data_length_out  : out std_logic_vector(23 downto 0);  --indicate the new data
                                                           --size
    data_address_out : out std_logic_vector(39 downto 0);  --indicate the new data                                                       
                                                           --address

    -- ERROR flags
    early_eop_out                               : out std_logic;
    eep_out                                     : out std_logic;
    eep_data_out                                : out std_logic;
    unsed_rmap_type_out                         : out std_logic;
    rmap_command_not_implemented_autrorized_out : out std_logic;
    invalid_header_crc_out                      : out std_logic;
    invalid_key_out                             : out std_logic;
    invalid_target_logical_add_out              : out std_logic;
    invalid_data_crc_out                        : out std_logic;
    verify_buffer_overrun_out                   : out std_logic;
    too_much_data_out                           : out std_logic;
    insufficient_data_out                       : out std_logic;
    address_out_of_range_out                    : out std_logic;

-------------------------------------------------------------------------------
-- From Application
-------------------------------------------------------------------------------

    key_in                    : in std_logic_vector(7 downto 0);
    target_fisical_address_in : in std_logic_vector(15 downto 0);
    fisical_adddress_size_in  : in std_logic_vector(1 downto 0);
    target_logical_address_in : in std_logic_vector(7 downto 0);

-------------------------------------------------------------------------------
-- To Register
-------------------------------------------------------------------------------

    waddr_out        : out std_logic_vector(39 downto 0);
    write_data_out   : out std_logic_vector(7 downto 0);
    write_enable_out : out std_logic;

-------------------------------------------------------------------------------
-- To reply block
-------------------------------------------------------------------------------

    reply_size_out                : out std_logic_vector(1 downto 0);
    reply_addr_out                : out std_logic_vector(95 downto 0);
    transaction_counter_out       : out std_logic_vector(15 downto 0);
    initiator_logical_address_out : out std_logic_vector(7 downto 0);

    memory_end_address_out : out std_logic_vector(39 downto 0);
    verify_data_out        : out std_logic;
    increment_data_out     : out std_logic;
    reply_en_out           : out std_logic;

-------------------------------------------------------------------------------
-- From reply block
-------------------------------------------------------------------------------

    reply_idle_in : in std_logic;

-------------------------------------------------------------------------------
-- SpW output FIFO
-------------------------------------------------------------------------------
    fifo_dout  : in  std_logic_vector(8 downto 0);  -- SpW FIFO data output
    fifo_empty : in  std_logic;                     -- SpW FIFO controll output
    fifo_read  : out std_logic                      := '0' -- SpW FIFO read command
    );

end entity rmap_reader;

architecture bhv of rmap_reader is

-------------------------------------------------------------------------------
-- Signals
-------------------------------------------------------------------------------

-- CRC ------------------------------------------------------------------------   
  signal rst_crc, enable_crc, get_crc, crc_idle, CRC_ready : std_logic := '0';
  signal crc_data_out                                      : std_logic_vector(7 downto 0);
  signal clear_crc                                         : std_logic := '0';

-- RMAP VARIABLES ------------------------------------------------------------
  --Fisical address
  signal fisical_addr         : std_logic_vector(15 downto 0) := X"0000";
  --Logical address
  signal logical_addr         : std_logic_vector(7 downto 0)  := X"00";
  -- Instruction
  signal verify_data_en       : std_logic                     := '0';
  signal increment_en         : std_logic                     := '0';
  signal reply_en             : std_logic                     := '0';
  signal reply_size           : std_logic_vector(1 downto 0)  := "00";
  --Identidier
  --Key
  -- Reply
  signal reply_addr           : std_logic_vector(95 downto 0) := (others => '0');
  --Initiator logical address
  signal initiator_addr       : std_logic_vector(7 downto 0)  := (others => '0');
  -- Transaction Counter
  signal transaction_counter  : std_logic_vector(15 downto 0) := (others => '0');
  -- Memmory address
  signal memory_start_address : unsigned(39 downto 0)         := (others => '0');
  -- Data length
  signal data_length          : unsigned(23 downto 0)         := (others => '0');

  signal write_command, read_command : std_logic;

--AUXs ---------------------------------------------------------------------
  signal memory_address : unsigned(39 downto 0) := (others => '0');
  signal memory_counter : unsigned(23 downto 0) := (others => '0');
  signal verify_flag    : std_logic             := '0';

  -- Errors
  signal erro_h : std_logic_vector(7 downto 0) := (others => '0');
  -- 1 = Target fisical address
  -- 2 = Logical Address
  -- 3 = Rmap identifier
  -- 4 = RMAP command not implemented/ autorizated 
  -- 5 = Key  
  -- 6 = Data crc
  -- 7 = Out of memory range

  constant max_memory_addr : unsigned(memory_length-1 downto 0) := (others => '1');

  constant eop             : std_logic_vector(8 downto 0) := "100000000";  -- eop
  constant eep             : std_logic_vector(8 downto 0) := "100000001";  -- eop
  constant rmap_identifier : std_logic_vector(7 downto 0) := X"01";  --RMAP protocol

--BUFFER---------------------------------------------------------------------

  signal buffer_din   : std_logic_vector(8 downto 0);
  signal buffer_dout  : std_logic_vector(8 downto 0);
  signal buffer_write : std_logic := '0';
  signal buffer_read  : std_logic := '0';
  signal buffer_sclr  : std_logic := '1';
  signal buffer_full  : std_logic;
  signal buffer_empty : std_logic;

-- states -------------------------------------------------------------------

  type state_read is (r_early_eop,
                      r_eep,
                      r_eep_data,
                      r_eop_data,
                      r_wait_eop_eep,
                      r_erro_to_much_data,
                      r_erro_buffer_overflow,
                      r_early_eop_data,
                      r_erro_crc_head,
                      r_erro_crc_data,
                      r_endpackage,
                      r_wait,
                      r_fisical1,
                      r_fisical2, r_fisical2_delay,
                      r_logical, r_logical_delay,
                      r_protocol_identifier_delay, r_protocol_identifier,
                      r_instruction_delay, r_instruction,
                      r_key_delay, r_key,
                      r_reply_add1_delay, r_reply_add1,
                      r_reply_add2_delay, r_reply_add2,
                      r_reply_add3_delay, r_reply_add3,
                      r_reply_add4_delay, r_reply_add4,
                      r_reply_add5_delay, r_reply_add5,
                      r_reply_add6_delay, r_reply_add6,
                      r_reply_add7_delay, r_reply_add7,
                      r_reply_add8_delay, r_reply_add8,
                      r_reply_add9_delay, r_reply_add9,
                      r_reply_add10_delay, r_reply_add10,
                      r_reply_add11_delay, r_reply_add11,
                      r_reply_add12_delay, r_reply_add12,
                      r_initiator_delay, r_initiator,
                      r_transaction_ms_delay, r_transaction_ms,
                      r_transaction_ls_delay, r_transaction_ls,
                      r_extend_address_delay, r_extend_address,
                      r_address_4_delay, r_address_4,
                      r_address_3_delay, r_address_3,
                      r_address_2_delay, r_address_2,
                      r_address_1_delay, r_address_1,
                      r_get_head_crc_delay, r_get_head_crc,
                      r_data_length_3_delay, r_data_length_3,
                      r_data_length_2_delay, r_data_length_2,
                      r_data_length_1_delay, r_data_length_1,
                      r_eop_head_delay, r_eop_head,
                      r_data_presset,
                      r_get_data_delay, r_get_data,
                      r_check_head_crc,
                      r_update_address,
                      r_get_data_crc_delay, r_get_data_crc,
                      r_check_data_crc,
                      r_check_eop_data_delay, r_check_eop_data,
                      r_verify_preset,
                      r_update_memory_buffer,
                      r_update_wait
                      );
  signal state_r : state_read;


  component fifo_verify
	PORT
	(
		aclr		: IN STD_LOGIC ;
		clock		: IN STD_LOGIC ;
		data		: IN STD_LOGIC_VECTOR (8 DOWNTO 0);
		rdreq		: IN STD_LOGIC ;
		wrreq		: IN STD_LOGIC ;
		empty		: OUT STD_LOGIC ;
		full		: OUT STD_LOGIC ;
		q			: OUT STD_LOGIC_VECTOR (8 DOWNTO 0);
		usedw		: OUT STD_LOGIC_VECTOR (10 DOWNTO 0)
	);
  end component;


-------------------------------------------------------------------------------
-- Begin
-------------------------------------------------------------------------------
  
begin 

-------------------------------------------------------------------------------
-- Maps
-------------------------------------------------------------------------------
  
  R0 : entity Modulo_crc_top
    port map (
      clock           => clk,
      clear           => rst_crc,
      enable_ler_data => enable_crc,
      get_crc         => get_crc,
      data_in         => fifo_dout(7 downto 0),
      crc_out         => crc_data_out,
      idle            => crc_idle,
      CRC_ready       => CRC_ready
      );

  R2 : fifo_verify
    port map (
      clock => clk,
      aclr  => buffer_sclr,
      data  => buffer_din,
      wrreq => buffer_write,
      rdreq => buffer_read,
      q	    => buffer_dout,
      full  => buffer_full,
      empty => buffer_empty,
	  usedw	=> OPEN
      );

-------------------------------------------------------------------------------
-- Process
-------------------------------------------------------------------------------

global : process (clk, rst) is
begin  -- process global
      
    if (rising_edge(clk)) then      -- rising clock edge
        if (rst = '1') then                 -- asynchronous reset (active high)
            get_crc          <= '0';
            fifo_read        <= '0';
            erro_h           <= (others => '0');
            state_r          <= r_wait;
            write_command    <= '0';
            read_command     <= '0';
            write_enable_out <= '0';
            verify_data_en   <= '0';
            reply_en         <= '0';
            increment_en     <= '0';
            buffer_sclr      <= '1';
            verify_flag      <= '0';
            clear_crc        <= '1';
        else
            case state_r is
                --when r_endpackage =>
                --  state_r          <= r_wait;
                --  clear_crc        <= '1';
                --  write_enable_out <= '0';

                --when r_eop_data =>
                --  state_r   <= r_wait;
                --  clear_crc <= '1';

                --when r_early_eop =>
                --  state_r   <= r_wait;
                --  clear_crc <= '1';

                --when r_eep =>
                --  state_r   <= r_wait;
                --  clear_crc <= '1';

                --when r_eep_data =>
                --  state_r   <= r_wait;
                --  clear_crc <= '1';
                --  
                --when r_erro_to_much_data =>
                --  state_r   <= r_wait_eop_eep;
                --  clear_crc <= '1';
                --  
                --when r_erro_buffer_overflow =>
                --  state_r   <= r_wait_eop_eep;
                --  clear_crc <= '1';

                --when r_erro_crc_head =>
                --  state_r   <= r_wait_eop_eep;
                --  clear_crc <= '1';
                --  
                --when r_wait_eop_eep =>
                --  clear_crc   <= '1';
                --  buffer_sclr <= '1';
                --  if (fifo_empty = '0') then
                --    fifo_read <= '0';
                --  else
                --    fifo_read <= '1';
                --  end if;
                --  if (fifo_dout(8) = '1') then
                --    state_r <= r_wait;
                --  else
                --    state_r <= r_wait_eop_eep;
                --  end if;

            --------------------------------------------
            -- Data Read
            --------------------------------------------

                when r_wait =>
                    get_crc          <= '0';
                    enable_crc       <= '0';
                    fifo_read        <= '0';
                    write_enable_out <= '0';
                    clear_crc        <= '0';
                    buffer_sclr      <= '0';
                    reply_addr       <= (others => '0');
                    erro_h           <= (others => '0');
                    write_command    <= '0';
                    read_command     <= '0';
                    verify_data_en   <= '0';
                    reply_en         <= '0';
                    increment_en     <= '0';
                    verify_flag      <= '0';
                    
                    if (fifo_empty = '0' and crc_idle = '1' and enable_reader_in = '1' and reply_idle_in = '1') then
                        fifo_read      <= '1';
                        case fisical_adddress_size_in is
                            when "00"   => state_r <= r_logical_delay;
                            when "01"   => state_r <= r_fisical2;
                            when others => state_r <= r_fisical1;
                        end case;
                    else
                        fifo_read   <= '0';
                        state_r     <= r_wait;
                    end if;

               -- when r_fisical1 =>
               --     get_crc    <= '0';
               --     enable_crc <= '0';
               --     fifo_read  <= '0';
               --     if (fifo_dout(8) = '1' and fifo_dout(0) = '0') then
               --         state_r <= r_early_eop;
               --     elsif (fifo_dout(8) = '1') then
               --         state_r <= r_eep;
               --     else
               --         state_r <= r_fisical2_delay;
               --         if (target_fisical_address_in(15 downto 8) /= fifo_dout(7 downto 0)) then
               --             erro_h(0) <= '1';
               --         else
               --             erro_h(0) <= '0';
               --         end if;
               --     end if;

               -- when r_fisical2_delay =>
               --     fifo_read  <= '1';
               --     get_crc    <= '0';
               --     enable_crc <= '0';
               --     if (fifo_empty = '0' and crc_idle = '1') then
               --       enable_crc <= '1';
               --       state_r    <= r_fisical2;
               --     else
               --       state_r <= r_fisical2_delay;
               --     end if;

               -- when r_fisical2 =>
               --     get_crc    <= '0';
               --     enable_crc <= '0';
               --     fifo_read  <= '0';
               --     if (fifo_dout(8) = '1' and fifo_dout(0) = '0') then
               --         state_r <= r_early_eop;
               --     elsif (fifo_dout(8) = '1') then
               --         state_r <= r_eep;
               --     else
               --         state_r <= r_logical_delay;
               --         if (target_fisical_address_in(7 downto 0) /= fifo_dout(7 downto 0)) then
               --             erro_h(1) <= '1';
               --         else
               --             erro_h(1) <= '0';
               --         end if;
               --     end if;

                when r_logical_delay =>
                    fifo_read   <= '0';
                    enable_crc  <= '1';
                    state_r     <= r_logical;

                when r_logical =>
                    enable_crc     <= '0';
                    if (fifo_dout(8) = '1' and fifo_dout(0) = '0') then
                        state_r <= r_early_eop;
                    elsif (fifo_dout(8) = '1') then
                        state_r <= r_eep;
                    else
                        if (fifo_empty = '0' and crc_idle = '1') then
                            fifo_read   <= '1';
                            state_r     <= r_protocol_identifier_delay;
                            
                            if (target_logical_address_in(7 downto 0) /= fifo_dout(7 downto 0)) then
                                erro_h(2) <= '1';
                            else
                                erro_h(2) <= '0';
                            end if;
                        else
                            state_r     <= r_logical;
                        end if;
                    end if;

                when r_protocol_identifier_delay =>
                    fifo_read   <= '0';
                    enable_crc  <= '1';
                    state_r     <= r_protocol_identifier;

                when r_protocol_identifier =>
                    enable_crc     <= '0';
                    if (fifo_dout(8) = '1' and fifo_dout(0) = '0') then
                        state_r <= r_early_eop;
                    elsif (fifo_dout(8) = '1') then
                        state_r <= r_eep;
                    else
                        if (fifo_empty = '0' and crc_idle = '1') then
                            fifo_read   <= '1';
                            if (rmap_identifier /= fifo_dout(7 downto 0)) then
                                erro_h(3) <= '1';
                                state_r   <= r_wait;
                            else
                                state_r   <= r_instruction_delay;
                            end if;
                        else
                            state_r     <= r_protocol_identifier;
                        end if;
                    end if;

                when r_instruction_delay =>
                    fifo_read   <= '0';
                    enable_crc  <= '1';
                    state_r     <= r_instruction;

                when r_instruction =>
                    enable_crc     <= '0';
                    if (fifo_dout(8) = '1' and fifo_dout(0) = '0') then
                        state_r <= r_early_eop;
                    elsif (fifo_dout(8) = '1') then
                        state_r <= r_eep;
                    else
                        if (fifo_empty = '0' and crc_idle = '1') then
                            fifo_read   <= '1';
                            state_r     <= r_key_delay;
                        else
                            state_r     <= r_instruction;
                        end if;

                        reply_size     <= fifo_dout(1 downto 0);
                        verify_data_en <= fifo_dout(4);
                        reply_en       <= fifo_dout(3);
                        increment_en   <= fifo_dout(2);
                        if (fifo_dout(7 downto 5) = "011") then
                            erro_h(4)     <= '0';
                            write_command <= '1';
                            read_command  <= '0';
                        elsif (fifo_dout(7 downto 3) = "01001") then
                            erro_h(4)     <= '0';
                            read_command  <= '1';
                            write_command <= '0';
                        else
                            read_command  <= '0';
                            write_command <= '0';
                            erro_h(4)     <= '1';
                            state_r       <= r_wait;
                        end if;
                    end if;

         --     when r_key_delay =>
         --         --fifo_read  <= '1';
         --         get_crc    <= '0';
         --         enable_crc <= '0';
         --         if (fifo_empty = '0' and crc_idle = '1') then
         --           enable_crc <= '1';
         --           state_r    <= r_key;
         --         else
         --           state_r <= r_key_delay;
         --         end if;

         -- when r_key =>
         --   get_crc    <= '0';
         --   enable_crc <= '0';
         --   --fifo_read  <= '0';
         --   if (fifo_dout(8) = '1' and fifo_dout(0) = '0') then
         --     state_r <= r_early_eop;
         --   elsif (fifo_dout(8) = '1') then
         --     state_r <= r_eep;
         --   else
         --     case reply_size is
         --       when "00"   => state_r <= r_initiator_delay;
         --       when "01"   => state_r <= r_reply_add4_delay;
         --       when "10"   => state_r <= r_reply_add8_delay;
         --       when "11"   => state_r <= r_reply_add12_delay;
         --       when others => null;
         --     end case;
         --     if (key_in /= fifo_dout(7 downto 0)) then
         --       erro_h(5) <= '1';
         --     else
         --       erro_h(5) <= '0';
         --     end if;
         --   end if;

         --   ---------------------------------------------------------------------
         --   -- Reply address
         --   ---------------------------------------------------------------------

         -- when r_reply_add12_delay =>
         --   --fifo_read  <= '1';
         --   get_crc    <= '0';
         --   enable_crc <= '0';
         --   if (fifo_empty = '0' and crc_idle = '1') then
         --     enable_crc <= '1';
         --     state_r    <= r_reply_add12;
         --   else
         --     state_r <= r_reply_add12_delay;
         --   end if;
         --   
         -- when r_reply_add12 =>
         --   get_crc    <= '0';
         --   enable_crc <= '0';
         --   --fifo_read  <= '0';
         --   if (fifo_dout(8) = '1' and fifo_dout(0) = '0') then
         --     state_r <= r_early_eop;
         --   elsif (fifo_dout(8) = '1') then
         --     state_r <= r_eep;
         --   else
         --     state_r                  <= r_reply_add11_delay;
         --     reply_addr(95 downto 88) <= fifo_dout(7 downto 0);
         --   end if;

         -- when r_reply_add11_delay =>
         --   --fifo_read  <= '1';
         --   get_crc    <= '0';
         --   enable_crc <= '0';
         --   if (fifo_empty = '0' and crc_idle = '1') then
         --     enable_crc <= '1';
         --     state_r    <= r_reply_add11;
         --   else
         --     state_r <= r_reply_add11_delay;
         --   end if;

         -- when r_reply_add11 =>
         --   get_crc    <= '0';
         --   enable_crc <= '0';
         --   --fifo_read  <= '0';
         --   if (fifo_dout(8) = '1' and fifo_dout(0) = '0') then
         --     state_r <= r_early_eop;
         --   elsif (fifo_dout(8) = '1') then
         --     state_r <= r_eep;
         --   else
         --     state_r                  <= r_reply_add10_delay;
         --     reply_addr(87 downto 80) <= fifo_dout(7 downto 0);
         --   end if;

         -- when r_reply_add10_delay =>
         --   --fifo_read  <= '1';
         --   get_crc    <= '0';
         --   enable_crc <= '0';
         --   if (fifo_empty = '0' and crc_idle = '1') then
         --     enable_crc <= '1';
         --     state_r    <= r_reply_add10;
         --   else
         --     state_r <= r_reply_add10_delay;
         --   end if;

         -- when r_reply_add10 =>
         --   get_crc    <= '0';
         --   enable_crc <= '0';
         --   --fifo_read  <= '0';
         --   if (fifo_dout(8) = '1' and fifo_dout(0) = '0') then
         --     state_r <= r_early_eop;
         --   elsif (fifo_dout(8) = '1') then
         --     state_r <= r_eep;
         --   else
         --     state_r                  <= r_reply_add9_delay;
         --     reply_addr(79 downto 72) <= fifo_dout(7 downto 0);
         --   end if;

         -- when r_reply_add9_delay =>
         --   --fifo_read  <= '1';
         --   get_crc    <= '0';
         --   enable_crc <= '0';
         --   if (fifo_empty = '0' and crc_idle = '1') then
         --     enable_crc <= '1';
         --     state_r    <= r_reply_add9;
         --   else
         --     state_r <= r_reply_add9_delay;
         --   end if;

         -- when r_reply_add9 =>
         --   get_crc    <= '0';
         --   enable_crc <= '0';
         --   --fifo_read  <= '0';
         --   if (fifo_dout(8) = '1' and fifo_dout(0) = '0') then
         --     state_r <= r_early_eop;
         --   elsif (fifo_dout(8) = '1') then
         --     state_r <= r_eep;
         --   else
         --     state_r                  <= r_reply_add8_delay;
         --     reply_addr(71 downto 64) <= fifo_dout(7 downto 0);
         --   end if;

         --   
         -- when r_reply_add8_delay =>
         --   --fifo_read  <= '1';
         --   get_crc    <= '0';
         --   enable_crc <= '0';
         --   if (fifo_empty = '0' and crc_idle = '1') then
         --     enable_crc <= '1';
         --     state_r    <= r_reply_add8;
         --   else
         --     state_r <= r_reply_add8_delay;
         --   end if;

         -- when r_reply_add8 =>
         --   get_crc    <= '0';
         --   enable_crc <= '0';
         --   --fifo_read  <= '0';
         --   if (fifo_dout(8) = '1' and fifo_dout(0) = '0') then
         --     state_r <= r_early_eop;
         --   elsif (fifo_dout(8) = '1') then
         --     state_r <= r_eep;
         --   else
         --     state_r                  <= r_reply_add7_delay;
         --     reply_addr(63 downto 56) <= fifo_dout(7 downto 0);
         --   end if;

         -- when r_reply_add7_delay =>
         --   --fifo_read  <= '1';
         --   get_crc    <= '0';
         --   enable_crc <= '0';
         --   if (fifo_empty = '0' and crc_idle = '1') then
         --     enable_crc <= '1';
         --     state_r    <= r_reply_add7;
         --   else
         --     state_r <= r_reply_add7_delay;
         --   end if;

         -- when r_reply_add7 =>
         --   get_crc    <= '0';
         --   enable_crc <= '0';
         --   --fifo_read  <= '0';
         --   if (fifo_dout(8) = '1' and fifo_dout(0) = '0') then
         --     state_r <= r_early_eop;
         --   elsif (fifo_dout(8) = '1') then
         --     state_r <= r_eep;
         --   else
         --     state_r                  <= r_reply_add6_delay;
         --     reply_addr(55 downto 48) <= fifo_dout(7 downto 0);
         --   end if;

         -- when r_reply_add6_delay =>
         --   --fifo_read  <= '1';
         --   get_crc    <= '0';
         --   enable_crc <= '0';
         --   if (fifo_empty = '0' and crc_idle = '1') then
         --     enable_crc <= '1';
         --     state_r    <= r_reply_add6;
         --   else
         --     state_r <= r_reply_add6_delay;
         --   end if;

         -- when r_reply_add6 =>
         --   get_crc    <= '0';
         --   enable_crc <= '0';
         --   --fifo_read  <= '0';
         --   if (fifo_dout(8) = '1' and fifo_dout(0) = '0') then
         --     state_r <= r_early_eop;
         --   elsif (fifo_dout(8) = '1') then
         --     state_r <= r_eep;
         --   else
         --     state_r                  <= r_reply_add5_delay;
         --     reply_addr(47 downto 40) <= fifo_dout(7 downto 0);
         --   end if;

         -- when r_reply_add5_delay =>
         --   --fifo_read  <= '1';
         --   get_crc    <= '0';
         --   enable_crc <= '0';
         --   if (fifo_empty = '0' and crc_idle = '1') then
         --     enable_crc <= '1';
         --     state_r    <= r_reply_add5;
         --   else
         --     state_r <= r_reply_add5_delay;
         --   end if;

         -- when r_reply_add5 =>
         --   get_crc    <= '0';
         --   enable_crc <= '0';
         --   --fifo_read  <= '0';
         --   if (fifo_dout(8) = '1' and fifo_dout(0) = '0') then
         --     state_r <= r_early_eop;
         --   elsif (fifo_dout(8) = '1') then
         --     state_r <= r_eep;
         --   else
         --     state_r                  <= r_reply_add4_delay;
         --     reply_addr(39 downto 32) <= fifo_dout(7 downto 0);
         --   end if;

         -- when r_reply_add4_delay =>
         --   --fifo_read  <= '1';
         --   get_crc    <= '0';
         --   enable_crc <= '0';
         --   if (fifo_empty = '0' and crc_idle = '1') then
         --     enable_crc <= '1';
         --     state_r    <= r_reply_add4;
         --   else
         --     state_r <= r_reply_add4_delay;
         --   end if;

         -- when r_reply_add4 =>
         --   get_crc    <= '0';
         --   enable_crc <= '0';
         --   --fifo_read  <= '0';
         --   if (fifo_dout(8) = '1' and fifo_dout(0) = '0') then
         --     state_r <= r_early_eop;
         --   elsif (fifo_dout(8) = '1') then
         --     state_r <= r_eep;
         --   else
         --     state_r                  <= r_reply_add3_delay;
         --     reply_addr(31 downto 24) <= fifo_dout(7 downto 0);
         --   end if;

         -- when r_reply_add3_delay =>
         --   --fifo_read  <= '1';
         --   get_crc    <= '0';
         --   enable_crc <= '0';
         --   if (fifo_empty = '0' and crc_idle = '1') then
         --     enable_crc <= '1';
         --     state_r    <= r_reply_add3;
         --   else
         --     state_r <= r_reply_add3_delay;
         --   end if;

         -- when r_reply_add3 =>
         --   get_crc    <= '0';
         --   enable_crc <= '0';
         --   --fifo_read  <= '0';
         --   if (fifo_dout(8) = '1' and fifo_dout(0) = '0') then
         --     state_r <= r_early_eop;
         --   elsif (fifo_dout(8) = '1') then
         --     state_r <= r_eep;
         --   else
         --     state_r                  <= r_reply_add2_delay;
         --     reply_addr(23 downto 16) <= fifo_dout(7 downto 0);
         --   end if;

         -- when r_reply_add2_delay =>
         --   --fifo_read  <= '1';
         --   get_crc    <= '0';
         --   enable_crc <= '0';
         --   if (fifo_empty = '0' and crc_idle = '1') then
         --     enable_crc <= '1';
         --     state_r    <= r_reply_add2;
         --   else
         --     state_r <= r_reply_add2_delay;
         --   end if;

         -- when r_reply_add2 =>
         --   get_crc    <= '0';
         --   enable_crc <= '0';
         --   --fifo_read  <= '0';
         --   if (fifo_dout(8) = '1' and fifo_dout(0) = '0') then
         --     state_r <= r_early_eop;
         --   elsif (fifo_dout(8) = '1') then
         --     state_r <= r_eep;
         --   else
         --     state_r                 <= r_reply_add1_delay;
         --     reply_addr(15 downto 8) <= fifo_dout(7 downto 0);
         --   end if;

         -- when r_reply_add1_delay =>
         --   --fifo_read  <= '1';
         --   get_crc    <= '0';
         --   enable_crc <= '0';
         --   if (fifo_empty = '0' and crc_idle = '1') then
         --     enable_crc <= '1';
         --     state_r    <= r_reply_add1;
         --   else
         --     state_r <= r_reply_add1_delay;
         --   end if;

         -- when r_reply_add1 =>
         --   get_crc    <= '0';
         --   enable_crc <= '0';
         --   --fifo_read  <= '0';
         --   if (fifo_dout(8) = '1' and fifo_dout(0) = '0') then
         --     state_r <= r_early_eop;
         --   elsif (fifo_dout(8) = '1') then
         --     state_r <= r_eep;
         --   else
         --     state_r                <= r_initiator_delay;
         --     reply_addr(7 downto 0) <= fifo_dout(7 downto 0);
         --   end if;
         --   
         -- when r_initiator_delay =>
         --   --fifo_read  <= '1';
         --   get_crc    <= '0';
         --   enable_crc <= '0';
         --   if (fifo_empty = '0' and crc_idle = '1') then
         --     enable_crc <= '1';
         --     state_r    <= r_initiator;
         --   else
         --     state_r <= r_initiator_delay;
         --   end if;

         -- when r_initiator =>
         --   get_crc    <= '0';
         --   enable_crc <= '0';
         --   --fifo_read  <= '0';
         --   if (fifo_dout(8) = '1' and fifo_dout(0) = '0') then
         --     state_r <= r_early_eop;
         --   elsif (fifo_dout(8) = '1') then
         --     state_r <= r_eep;
         --   else
         --     state_r        <= r_transaction_ms_delay;
         --     initiator_addr <= fifo_dout(7 downto 0);
         --   end if;

         -- when r_transaction_ms_delay =>
         --   --fifo_read  <= '1';
         --   get_crc    <= '0';
         --   enable_crc <= '0';
         --   if (fifo_empty = '0' and crc_idle = '1') then
         --     enable_crc <= '1';
         --     state_r    <= r_transaction_ms;
         --   else
         --     state_r <= r_transaction_ms_delay;
         --   end if;

         --   ---------------------------------------------------------------------
         --   -- Reply end
         --   ---------------------------------------------------------------------
         --   
         -- when r_transaction_ms =>
         --   get_crc    <= '0';
         --   enable_crc <= '0';
         --   --fifo_read  <= '0';
         --   if (fifo_dout(8) = '1' and fifo_dout(0) = '0') then
         --     state_r <= r_early_eop;
         --   elsif (fifo_dout(8) = '1') then
         --     state_r <= r_eep;
         --   else
         --     state_r                          <= r_transaction_ls_delay;
         --     transaction_counter(15 downto 8) <= fifo_dout(7 downto 0);
         --   end if;

         -- when r_transaction_ls_delay =>
         --   --fifo_read  <= '1';
         --   get_crc    <= '0';
         --   enable_crc <= '0';
         --   if (fifo_empty = '0' and crc_idle = '1') then
         --     enable_crc <= '1';
         --     state_r    <= r_transaction_ls;
         --   else
         --     state_r <= r_transaction_ls_delay;
         --   end if;

         -- when r_transaction_ls =>
         --   get_crc    <= '0';
         --   enable_crc <= '0';
         --   --fifo_read  <= '0';
         --   if (fifo_dout(8) = '1' and fifo_dout(0) = '0') then
         --     state_r <= r_early_eop;
         --   elsif (fifo_dout(8) = '1') then
         --     state_r <= r_eep;
         --   else
         --     state_r                         <= r_extend_address_delay;
         --     transaction_counter(7 downto 0) <= fifo_dout(7 downto 0);
         --   end if;

         -- when r_extend_address_delay =>
         --   --fifo_read  <= '1';
         --   get_crc    <= '0';
         --   enable_crc <= '0';
         --   if (fifo_empty = '0' and crc_idle = '1') then
         --     enable_crc <= '1';
         --     state_r    <= r_extend_address;
         --   else
         --     state_r <= r_extend_address_delay;
         --   end if;

         -- when r_extend_address =>
         --   get_crc    <= '0';
         --   enable_crc <= '0';
         --   --fifo_read  <= '0';
         --   if (fifo_dout(8) = '1' and fifo_dout(0) = '0') then
         --     state_r <= r_early_eop;
         --   elsif (fifo_dout(8) = '1') then
         --     state_r <= r_eep;
         --   else
         --     state_r                            <= r_address_4_delay;
         --     memory_start_address(39 downto 32) <= unsigned(fifo_dout(7 downto 0));
         --   end if;

         --   
         -- when r_address_4_delay =>
         --   --fifo_read  <= '1';
         --   get_crc    <= '0';
         --   enable_crc <= '0';
         --   if (fifo_empty = '0' and crc_idle = '1') then
         --     enable_crc <= '1';
         --     state_r    <= r_address_4;
         --   else
         --     state_r <= r_address_4_delay;
         --   end if;

         -- when r_address_4 =>
         --   get_crc    <= '0';
         --   enable_crc <= '0';
         --   --fifo_read  <= '0';
         --   if (fifo_dout(8) = '1' and fifo_dout(0) = '0') then
         --     state_r <= r_early_eop;
         --   elsif (fifo_dout(8) = '1') then
         --     state_r <= r_eep;
         --   else
         --     state_r                            <= r_address_3_delay;
         --     memory_start_address(31 downto 24) <= unsigned(fifo_dout(7 downto 0));
         --   end if;

         -- when r_address_3_delay =>
         --   --fifo_read  <= '1';
         --   get_crc    <= '0';
         --   enable_crc <= '0';
         --   if (fifo_empty = '0' and crc_idle = '1') then
         --     enable_crc <= '1';
         --     state_r    <= r_address_3;
         --   else
         --     state_r <= r_address_3_delay;
         --   end if;

         -- when r_address_3 =>
         --   get_crc    <= '0';
         --   enable_crc <= '0';
         --   --fifo_read  <= '0';
         --   if (fifo_dout(8) = '1' and fifo_dout(0) = '0') then
         --     state_r <= r_early_eop;
         --   elsif (fifo_dout(8) = '1') then
         --     state_r <= r_eep;
         --   else
         --     state_r                            <= r_address_2_delay;
         --     memory_start_address(23 downto 16) <= unsigned(fifo_dout(7 downto 0));
         --   end if;

         -- when r_address_2_delay =>
         --   --fifo_read  <= '1';
         --   get_crc    <= '0';
         --   enable_crc <= '0';
         --   if (fifo_empty = '0' and crc_idle = '1') then
         --     enable_crc <= '1';
         --     state_r    <= r_address_2;
         --   else
         --     state_r <= r_address_2_delay;
         --   end if;

         -- when r_address_2 =>
         --   get_crc    <= '0';
         --   enable_crc <= '0';
         --   --fifo_read  <= '0';
         --   if (fifo_dout(8) = '1' and fifo_dout(0) = '0') then
         --     state_r <= r_early_eop;
         --   elsif (fifo_dout(8) = '1') then
         --     state_r <= r_eep;
         --   else
         --     state_r                           <= r_address_1_delay;
         --     memory_start_address(15 downto 8) <= unsigned(fifo_dout(7 downto 0));
         --   end if;

         -- when r_address_1_delay =>
         --   --fifo_read  <= '1';
         --   get_crc    <= '0';
         --   enable_crc <= '0';
         --   if (fifo_empty = '0' and crc_idle = '1') then
         --     enable_crc <= '1';
         --     state_r    <= r_address_1;
         --   else
         --     state_r <= r_address_1_delay;
         --   end if;

         -- when r_address_1 =>
         --   get_crc    <= '0';
         --   enable_crc <= '0';
         --   --fifo_read  <= '0';
         --   if (fifo_dout(8) = '1' and fifo_dout(0) = '0') then
         --     state_r <= r_early_eop;
         --   elsif (fifo_dout(8) = '1') then
         --     state_r <= r_eep;
         --   else
         --     state_r                          <= r_data_length_3_delay;
         --     memory_start_address(7 downto 0) <= unsigned(fifo_dout(7 downto 0));
         --   end if;

         -- when r_data_length_3_delay =>
         --   --fifo_read  <= '1';
         --   get_crc    <= '0';
         --   enable_crc <= '0';
         --   if (fifo_empty = '0' and crc_idle = '1') then
         --     enable_crc <= '1';
         --     state_r    <= r_data_length_3;
         --   else
         --     state_r <= r_data_length_3_delay;
         --   end if;

         -- when r_data_length_3 =>
         --   get_crc    <= '0';
         --   enable_crc <= '0';
         --   --fifo_read  <= '0';
         --   if (fifo_dout(8) = '1' and fifo_dout(0) = '0') then
         --     state_r <= r_early_eop;
         --   elsif (fifo_dout(8) = '1') then
         --     state_r <= r_eep;
         --   else
         --     state_r                   <= r_data_length_2_delay;
         --     data_length(23 downto 16) <= unsigned(fifo_dout(7 downto 0));
         --   end if;

         -- when r_data_length_2_delay =>
         --   --fifo_read  <= '1';
         --   get_crc    <= '0';
         --   enable_crc <= '0';
         --   if (fifo_empty = '0' and crc_idle = '1') then
         --     enable_crc <= '1';
         --     state_r    <= r_data_length_2;
         --   else
         --     state_r <= r_data_length_2_delay;
         --   end if;

         -- when r_data_length_2 =>
         --   get_crc    <= '0';
         --   enable_crc <= '0';
         --   --fifo_read  <= '0';
         --   if (fifo_dout(8) = '1' and fifo_dout(0) = '0') then
         --     state_r <= r_early_eop;
         --   elsif (fifo_dout(8) = '1') then
         --     state_r <= r_eep;
         --   else
         --     state_r                  <= r_data_length_1_delay;
         --     data_length(15 downto 8) <= unsigned(fifo_dout(7 downto 0));
         --   end if;
         --   
         -- when r_data_length_1_delay =>
         --   --fifo_read  <= '1';
         --   get_crc    <= '0';
         --   enable_crc <= '0';
         --   if (fifo_empty = '0' and crc_idle = '1') then
         --     enable_crc <= '1';
         --     state_r    <= r_data_length_1;
         --   else
         --     state_r <= r_data_length_1_delay;
         --   end if;

         -- when r_data_length_1 =>
         --   get_crc    <= '0';
         --   enable_crc <= '0';
         --   --fifo_read  <= '0';
         --   if (to_integer(memory_start_address(39 downto memory_length)) /= to_integer(to_unsigned(0, 1))) then
         --     erro_h(7) <= '1';
         --   else
         --     erro_h(7) <= '0';
         --   end if;
         --   if (fifo_dout(8) = '1' and fifo_dout(0) = '0') then
         --     state_r <= r_early_eop;
         --   elsif (fifo_dout(8) = '1') then
         --     state_r <= r_eep;
         --   else
         --     state_r                 <= r_get_head_crc_delay;
         --     data_length(7 downto 0) <= unsigned(fifo_dout(7 downto 0));
         --   end if;

         --   ---------------------------------------------------------------------
         --   -- HEAD CRC
         --   ---------------------------------------------------------------------

         -- when r_get_head_crc_delay =>    -- HEAD ready on fifo_dout
         --   --fifo_read  <= '1';
         --   get_crc    <= '0';
         --   enable_crc <= '0';
         --   if (fifo_empty = '0' and crc_idle = '1') then
         --     get_crc <= '1';
         --     state_r <= r_get_head_crc;
         --   else
         --     state_r <= r_get_head_crc_delay;
         --   end if;

         -- when r_get_head_crc =>          --check the head crc
         --   get_crc    <= '0';
         --   enable_crc <= '0';
         --   --fifo_read  <= '1';
         --   if (fifo_dout(8) = '1' and fifo_dout(0) = '0') then
         --     state_r <= r_early_eop;
         --   elsif (fifo_dout(8) = '1') then
         --     state_r <= r_eep;
         --   else
         --     state_r <= r_check_head_crc;
         --   end if;

         -- when r_check_head_crc =>
         --   if (CRC_ready = '1' or crc_idle = '1') then
         --     --fifo_read <= '0';
         --     if (crc_data_out = fifo_dout(7 downto 0)) then
         --       clear_crc <= '1';
         --       if (read_command = '1') then
         --         state_r <= r_eop_head_delay;
         --       else
         --         state_r <= r_data_presset;
         --       end if;
         --     else
         --       state_r <= r_erro_crc_head;
         --     end if;
         --   else
         --     state_r <= r_check_head_crc;
         --   end if;

         --   ---------------------------------------------------------------------
         --   -- HEAD EOP
         --   ---------------------------------------------------------------------
         --   
         -- when r_eop_head_delay =>
         --   --fifo_read  <= '1';
         --   get_crc    <= '0';
         --   enable_crc <= '0';
         --   clear_crc  <= '0';
         --   if (fifo_empty = '0' and crc_idle = '1') then
         --     state_r <= r_eop_head;
         --   else
         --     state_r <= r_eop_head_delay;
         --   end if;
         --   
         -- when r_eop_head =>
         --   get_crc   <= '0';
         --   --fifo_read <= '0';
         --   clear_crc <= '1';
         --   if (fifo_dout(8) = '1' and fifo_dout(0) = '0') then
         --     state_r <= r_endpackage;
         --   elsif (fifo_dout(8) = '1') then
         --     state_r <= r_eep;
         --   else
         --     state_r <= r_erro_to_much_data;
         --   end if;

         --   ---------------------------------------------------------------------
         --   -- Data Write to internal memory
         --   ---------------------------------------------------------------------

         -- when r_data_presset =>
         --   get_crc        <= '0';
         --   clear_crc      <= '0';
         --   enable_crc     <= '0';
         --   --fifo_read      <= '1';
         --   memory_address <= memory_start_address;
         --   memory_counter <= to_unsigned(1, 24);
         --   state_r        <= r_get_data_delay;

         -- when r_get_data_delay =>
         --   get_crc    <= '0';
         --   enable_crc <= '1';
         --   clear_crc  <= '0';
         --   --fifo_read  <= '1';
         --   waddr_out  <= std_logic_vector(memory_address);
         --   if (fifo_empty = '0' and crc_idle = '1') then
         --     --   enable_crc <= '1';
         --     if (verify_data_en = '0') then
         --       write_enable_out <= '1';
         --       buffer_write     <= '0';
         --       state_r          <= r_get_data;
         --     else
         --       if (buffer_full = '1') then
         --         buffer_write     <= '0';
         --         write_enable_out <= '0';
         --         state_r          <= r_erro_buffer_overflow;
         --       else
         --         state_r          <= r_get_data;
         --         buffer_write     <= '1';
         --         write_enable_out <= '0';
         --       end if;
         --     end if;
         --     buffer_din     <= fifo_dout(8 downto 0);
         --     write_data_out <= fifo_dout(7 downto 0);
         --   else
         --     state_r    <= r_get_data_delay;
         --     enable_crc <= '0';
         --   end if;

         -- when r_get_data =>
         --   write_enable_out <= '0';
         --   buffer_write     <= '0';
         --   enable_crc       <= '0';
         --   --fifo_read        <= '0';
         --   if (fifo_dout(8) = '1' and fifo_dout(0) = '0') then
         --     state_r <= r_early_eop_data;
         --   elsif (fifo_dout(8) = '1') then
         --     state_r <= r_eep_data;
         --   else
         --     if (memory_counter >= data_length) then
         --       state_r <= r_get_data_crc_delay;
         --     else
         --       state_r <= r_update_address;
         --     end if;
         --   end if;

         --   ---------------------------------------------------------------------
         --   -- Update address
         --   ---------------------------------------------------------------------

         -- when r_update_address =>
         --   write_enable_out <= '0';
         --   --fifo_read        <= '1';
         --   memory_counter   <= memory_counter + to_unsigned(1, 1);
         --   if (increment_en = '1') then
         --     memory_address <= memory_address + to_unsigned(1, 1);
         --   else
         --     memory_address <= memory_start_address;
         --   end if;
         --   if (verify_flag = '1') then
         --     state_r     <= r_update_memory_buffer;
         --     buffer_read <= '1';
         --   else
         --     state_r     <= r_get_data_delay;
         --     buffer_read <= '0';
         --   end if;


         --   ---------------------------------------------------------------------
         --   -- Data CRC
         --   ---------------------------------------------------------------------
         --   
         -- when r_get_data_crc_delay =>
         --   --fifo_read  <= '1';
         --   get_crc    <= '0';
         --   enable_crc <= '0';
         --   if (fifo_empty = '0' and crc_idle = '1') then
         --     get_crc <= '1';
         --     state_r <= r_get_data_crc;
         --   else
         --     state_r <= r_get_data_crc_delay;
         --   end if;

         -- when r_get_data_crc =>
         --   get_crc    <= '0';
         --   enable_crc <= '0';
         --   --fifo_read  <= '1';
         --   if (fifo_dout(8) = '1' and fifo_dout(0) = '0') then
         --     state_r <= r_eop_data;
         --   elsif (fifo_dout(8) = '1') then
         --     state_r <= r_eep_data;
         --   else
         --     state_r <= r_check_data_crc;
         --   end if;

         -- when r_check_data_crc =>
         --   --fifo_read <= '0';
         --   if (CRC_ready = '1' or crc_idle = '1') then
         --     state_r <= r_check_eop_data_delay;
         --     if (crc_data_out = fifo_dout(7 downto 0)) then
         --       erro_h(6) <= '0';
         --     else
         --       erro_h(6) <= '1';         -- Erro data crc  
         --     end if;
         --   else
         --     state_r <= r_check_data_crc;
         --   end if;

         --   ---------------------------------------------------------------------
         --   -- Data eop
         --   ---------------------------------------------------------------------

         -- when r_check_eop_data_delay =>
         --   --fifo_read  <= '1';
         --   get_crc    <= '0';
         --   enable_crc <= '0';
         --   clear_crc  <= '1';
         --   if (fifo_empty = '0' and crc_idle = '1') then
         --     state_r <= r_check_eop_data;
         --   else
         --     state_r <= r_check_eop_data_delay;
         --   end if;
         --   
         -- when r_check_eop_data =>
         --   get_crc   <= '0';
         --   --fifo_read <= '0';
         --   clear_crc <= '1';
         --   if (fifo_dout(8) = '1' and fifo_dout(0) = '0') then
         --     if (verify_data_en = '1' and to_integer(unsigned(erro_h)) = 0) then
         --       state_r <= r_verify_preset;
         --     else
         --       state_r <= r_endpackage;
         --     end if;
         --   elsif (fifo_dout(8) = '1') then
         --     state_r <= r_eep_data;
         --   else
         --     state_r <= r_erro_to_much_data;
         --   end if;

         --   ---------------------------------------------------------------------
         --   -- Update memory whit buffer
         --   ---------------------------------------------------------------------

         -- when r_verify_preset =>
         --   get_crc        <= '0';
         --   clear_crc      <= '0';
         --   enable_crc     <= '0';
         --   --fifo_read      <= '1';
         --   verify_flag    <= '1';
         --   memory_address <= memory_start_address;
         --   memory_counter <= to_unsigned(1, 24);
         --   state_r        <= r_update_memory_buffer;
         --   if (buffer_empty = '1') then
         --     state_r <= r_endpackage;
         --   else
         --     state_r     <= r_update_memory_buffer;
         --     buffer_read <= '1';
         --   end if;
         --   
         -- when r_update_memory_buffer =>
         --   buffer_read      <= '0';
         --   waddr_out        <= std_logic_vector(memory_address);
         --   write_data_out   <= buffer_dout(7 downto 0);
         --   write_enable_out <= '1';
         --   if (memory_counter >= data_length) then
         --     state_r <= r_endpackage;
         --   else
         --     if (fifo_empty = '1') then
         --       state_r <= r_update_address;
         --     else
         --       state_r <= r_update_wait;
         --     end if;
         --   end if;
         --   
         -- when r_update_wait =>
         --   write_enable_out <= '0';
         --   if (fifo_empty = '1') then
         --     state_r <= r_update_address;
         --   else
         --     state_r <= r_update_wait;
         --   end if;

          when others => state_r <= r_wait;
                     
        end case;
      end if;
  end if;
end process global;

-------------------------------------------------------------------------------
-- CRC
-------------------------------------------------------------------------------

  rst_crc <= clear_crc or rst;

-------------------------------------------------------------------------------
-- Interpreted command 
-------------------------------------------------------------------------------

  read_op_out <= '1' when (state_r = r_endpackage and read_command = '1') else
                 '0';

  write_op_out <= '1' when (state_r = r_endpackage and write_command = '1') else
                  '0';
  -----------------------------------------------------------------------------
  -- Errors 
  -----------------------------------------------------------------------------

  early_eop_out <= '1' when (state_r = r_early_eop) else
                   '0';

  eep_data_out <= '1' when (state_r = r_eep_data) else
                  '0';

  eep_out <= '1' when (state_r = r_eep) else
             '0';

  -- Wrong target fisical address
  rmap_command_not_implemented_autrorized_out <= '1' when (state_r = r_endpackage and (erro_h(0) = '1' or erro_h(1) = '1')) else
                                                 '0';

  -- invalid key
  invalid_key_out <= '1' when (state_r = r_endpackage and erro_h(5) = '1') else
                     '0';

                                        -- Wrong logical adddress
  invalid_target_logical_add_out <= '1' when (state_r = r_endpackage and erro_h(2) = '1') else
                                    '0';

                                        -- Wrong instructions or address out of
                                        -- range
  unsed_rmap_type_out <= '1' when (state_r = r_endpackage and erro_h(4) = '1') else
                         '1' when (state_r = r_endpackage and erro_h(3) = '1') else  --protocolo_identifier
                         '0';

                                        -- Wrong data crc
  invalid_header_crc_out <= '1' when (state_r = r_erro_crc_head) else
                            '0';

  -- Wrong data crc  
  invalid_data_crc_out <= '1' when (state_r = r_endpackage and erro_h(6) = '1') else
                          '0';

  -- Buffer overflow
  verify_buffer_overrun_out <= '1' when (state_r = r_erro_buffer_overflow) else
                               '0';

  -- TO much data 
  too_much_data_out <= '1' when (state_r = r_erro_to_much_data) else
                       '0';

  -- Early eop in data
  insufficient_data_out <= '1' when (state_r = r_eop_data) else
                           '0';

  -- Address out of range
  address_out_of_range_out <= '1' when (state_r = r_endpackage and erro_h(7) = '1') else
                              '0';




------------------------------------------------------------------------------
-- To reply block 
-------------------------------------------------------------------------------

  reply_addr_out <= reply_addr;
  reply_size_out <= reply_size;

  transaction_counter_out <= std_logic_vector(transaction_counter);

  initiator_logical_address_out <= initiator_addr;

  memory_end_address_out <= std_logic_vector(memory_address);

  verify_data_out    <= verify_data_en;
  increment_data_out <= increment_en;
  reply_en_out       <= reply_en;

  data_length_out  <= std_logic_vector(data_length);
  data_address_out <= std_logic_vector(memory_start_address);

-------------------------------------------------------------------------------
-- Memory block
-------------------------------------------------------------------------------

  
  
end bhv;



