library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity ReadTop is
  generic(
    memory_length    : natural := 38;
    hk_start_address : natural := 64;
    hk_end_address   : natural := 127
    );
  port (

-------------------------------------------------------------------------------
-- Global
-------------------------------------------------------------------------------    
    clk      : in std_logic;
    clk_slow : in std_logic;
    rst      : in std_logic;

-------------------------------------------------------------------------------
-- Data recovered information
    -------------------------------------------------------------------------------

    read_op_out  : out std_logic;       -- Operacao de leitura ok
    write_op_out : out std_logic;       -- Operação de escrita ok

    data_length_out  : out std_logic_vector(23 downto 0);  --indicate the new data
                                                           --size
    data_address_out : out std_logic_vector(39 downto 0);  --indicate the new data                                                       
                                                           --address

-------------------------------------------------------------------------------
-- Erros
-------------------------------------------------------------------------------

    erro_early_eop_out                  : out std_logic;
    erro_eep_out                        : out std_logic;
    erro_eep_data_out                   : out std_logic;
    erro_unsed_rmap_type_out            : out std_logic;
    erro_rmap_comd_not_impl_auto_out    : out std_logic;
    erro_invalid_header_crc_out         : out std_logic;
    erro_invalid_key_out                : out std_logic;
    erro_invalid_target_logical_add_out : out std_logic;
    erro_invalid_data_crc_out           : out std_logic;
    erro_verify_buffer_overrun_out      : out std_logic;
    erro_too_much_data_out              : out std_logic;
    erro_insufficient_data_out          : out std_logic;
    erro_address_out_of_range_out       : out std_logic;

------------------------------------------------------------------------------
-- Write FIFO
-------------------------------------------------------------------------------

    fifo_w_dout_out   : out std_logic_vector(8 downto 0);  -- Sync FIFO data output
    fifo_w_nwrite_out : out std_logic;  -- Sync FIFO controll output
    fifo_w_full_in    : in  std_logic;  -- Sync FIFO read command

-------------------------------------------------------------------------------
-- Read Autonomus SpW fifo
-------------------------------------------------------------------------------
    spw_fifo_r_dout  : in  std_logic_vector(8 downto 0);  -- SpW FIFO data output
    spw_fifo_r_empty : in  std_logic;   -- SpW FIFO controll output
    spw_fifo_r_read  : out std_logic;   -- SpW FIFO read command

-------------------------------------------------------------------------------
-- Configurations 
-------------------------------------------------------------------------------

    config_key_in                 : in std_logic_vector(7 downto 0);
    config_logical_addr_in        : in std_logic_vector(7 downto 0);
    config_target_fisical_addr_in : in std_logic_vector(15 downto 0);
    config_fisical_addr_size_in   : in std_logic_vector(1 downto 0);

-------------------------------------------------------------------------------
-- Enables/ Requests
-------------------------------------------------------------------------------

    enable_reader_in        : in  std_logic;
    enable_hk_transmit_in   : in  std_logic;
    free_to_transmit_in     : in  std_logic;
    request_to_transmit_out : out std_logic;

-------------------------------------------------------------------------------
-- Memory 
-------------------------------------------------------------------------------

    -- Read
    memory_read_enable_out    : out std_logic;
    memory_read_addr_out      : out std_logic_vector(memory_length-1 downto 0) := (others => '0');
    memory_read_data_ready_in : in  std_logic;
    memory_read_data_in       : in  std_logic_vector(7 downto 0);

    --Write    
    memory_write_addr_out   : out std_logic_vector(39 downto 0);
    memory_write_data_out   : out std_logic_vector(7 downto 0);
    memory_write_enable_out : out std_logic;

-------------------------------------------------------------------------------
-- HouseKeep information
-------------------------------------------------------------------------------
    hk_accepted_out : out std_logic;
    hk_rejected_out : out std_logic
    );

end entity ReadTop;


architecture top of ReadTop is

  signal reply_idle                                                          : std_logic;
  signal data_length                                                         : std_logic_vector(23 downto 0);
  signal data_address                                                        : std_logic_vector(39 downto 0);
  signal read_op, write_op                                                   : std_logic;
  signal reply_size                                                          : std_logic_vector(1 downto 0);
  signal reply_addr                                                          : std_logic_vector(95 downto 0);
  signal transaction_counter                                                 : std_logic_vector(15 downto 0);
  signal initiator_logical_address                                           : std_logic_vector(7 downto 0);
  signal verify_data, increment_data, reply_en                               : std_logic;
  signal eep_data, unsed_rmap_type, rmap_not_autrorized, invalid_key         : std_logic;
  signal invalid_target_logical_add, invalid_data_crc, verify_buffer_overrun : std_logic;
  signal too_much_data, insufficient_data                                    : std_logic;
  signal address_out_of_range                                                : std_logic;
  
begin  -- architecture top

  REPLY : entity rmap_reply
    generic map(
      hk_start_address => 64,
      hk_end_address   => 127,
      memory_length    => memory_length
      )

    port map(

      clk      => clk,
      clk_slow => clk_slow,
      rst      => rst,

      reply_idle_out  => reply_idle,
      data_length_in  => data_length,
      data_address_in => data_address(memory_length-1 downto 0),

      read_op_in  => read_op,
      write_op_in => write_op,

      reply_size_in                => reply_size,
      reply_addr_in                => reply_addr,
      transaction_counter_in       => transaction_counter,
      initiator_logical_address_in => initiator_logical_address,
      verify_data_in               => verify_data,
      increment_data_in            => increment_data,
      reply_en_in                  => reply_en,

      eep_data_in                   => eep_data,
      unsed_rmap_type_in            => unsed_rmap_type,
      rmap_not_autrorized_in        => rmap_not_autrorized,
      invalid_key_in                => invalid_key,
      invalid_target_logical_add_in => invalid_target_logical_add,
      invalid_data_crc_in           => invalid_data_crc,
      verify_buffer_overrun_in      => verify_buffer_overrun,
      too_much_data_in              => too_much_data,
      insufficient_data_in          => insufficient_data,
      address_out_of_range_in       => address_out_of_range,

      fifo_dout_out   => fifo_w_dout_out,
      fifo_nwrite_out => fifo_w_nwrite_out,
      fifo_full_in    => fifo_w_full_in,

      logical_address_in => config_logical_addr_in,

      enable_hk_transmit_in   => enable_hk_transmit_in,
      free_to_transmit_in     => free_to_transmit_in,
      request_to_transmit_out => request_to_transmit_out,

      memory_enable_out    => memory_read_enable_out,
      memory_addr_out      => memory_read_addr_out,
      memory_data_ready_in => memory_read_data_ready_in,
      memory_data_in       => memory_read_data_in,

      hk_accepted_out => hk_accepted_out,
      hk_rejected_out => hk_rejected_out
      );

  READER : entity rmap_reader
    generic map(
      memory_length => memory_length
      )
    port map(

      clk      => clk,
      rst      => rst,

      enable_reader_in => enable_reader_in,

      read_op_out     => read_op,
      write_op_out    => write_op,
      data_length_out => data_length,

      data_address_out => data_address,


      -- ERROR flags
      early_eop_out                               => erro_early_eop_out,
      eep_out                                     => erro_eep_out,
      eep_data_out                                => eep_data,
      unsed_rmap_type_out                         => unsed_rmap_type,
      rmap_command_not_implemented_autrorized_out => rmap_not_autrorized,
      invalid_header_crc_out                      => erro_invalid_header_crc_out,
      invalid_key_out                             => invalid_key,
      invalid_target_logical_add_out              => invalid_target_logical_add,
      invalid_data_crc_out                        => invalid_data_crc,
      verify_buffer_overrun_out                   => verify_buffer_overrun,
      too_much_data_out                           => too_much_data,
      insufficient_data_out                       => insufficient_data,
      address_out_of_range_out                    => address_out_of_range,

      key_in                    => config_key_in,
      target_fisical_address_in => config_target_fisical_addr_in,
      fisical_adddress_size_in  => config_fisical_addr_size_in,
      target_logical_address_in => config_logical_addr_in,

      waddr_out        => memory_write_addr_out,
      write_data_out   => memory_write_data_out,
      write_enable_out => memory_write_enable_out,

      reply_size_out                => reply_size,
      reply_addr_out                => reply_addr,
      transaction_counter_out       => transaction_counter,
      initiator_logical_address_out => initiator_logical_address,

      memory_end_address_out => open,
      verify_data_out        => verify_data,
      increment_data_out     => increment_data,
      reply_en_out           => reply_en,

      reply_idle_in => reply_idle,

      fifo_dout  => spw_fifo_r_dout,
      fifo_empty => spw_fifo_r_empty,
      fifo_read  => spw_fifo_r_read
      );

  
  erro_eep_data_out                   <= eep_data;
  erro_unsed_rmap_type_out            <= unsed_rmap_type;
  erro_rmap_comd_not_impl_auto_out    <= rmap_not_autrorized;
  erro_invalid_key_out                <= invalid_key;
  erro_invalid_target_logical_add_out <= invalid_target_logical_add;
  erro_invalid_data_crc_out           <= invalid_data_crc;
  erro_verify_buffer_overrun_out      <= verify_buffer_overrun;
  erro_too_much_data_out              <= too_much_data;
  erro_insufficient_data_out          <= insufficient_data;
  erro_address_out_of_range_out       <= address_out_of_range;
  read_op_out                         <= read_op;
  write_op_out                        <= write_op;
  data_length_out                     <= data_length;
  data_address_out                    <= data_address;
  
  
end architecture top;
