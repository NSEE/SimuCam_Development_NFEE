library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use work.all;


  entity tb is
  end entity tb;

architecture bhv of tb is

  signal clk, clk_slow, rst, empty, nread : std_logic := '0';
  signal dout9 : std_logic_vector( 8 downto 0);
  
begin  -- architecture bhv
  
  U5 : entity rmap_reader
    port map(
-------------------------------------------------------------------------------
-- Global
-------------------------------------------------------------------------------    
      clk      => clk,
      clk_slow => clk_slow,
      rst      => rst,

      enable_reader_in => '1',

-------------------------------------------------------------------------------
-- To Application
-------------------------------------------------------------------------------

      read_op_out     => open,
      write_op_out    => open,
      data_length_out => open,

      data_address_out => open,


      -- ERROR flags
      early_eop_out                               => open,
      eep_out                                     => open,
      eep_data_out                                => open,
      unsed_rmap_type_out                         => open,
      rmap_command_not_implemented_autrorized_out => open,
      invalid_header_crc_out                      => open,
      invalid_key_out                             => open,
      invalid_target_logical_add_out              => open,
      invalid_data_crc_out                        => open,
      verify_buffer_overrun_out                   => open,
      too_much_data_out                           => open,
      insufficient_data_out                       => open,

-------------------------------------------------------------------------------
-- From Application
-------------------------------------------------------------------------------

      key_in                    => X"00",
      target_fisical_address_in => X"0000",
      fisical_adddress_size_in  => "00",
      target_logical_address_in => X"FE",

-------------------------------------------------------------------------------
-- To dual port ram  (memory)
-------------------------------------------------------------------------------

      waddr_out        => open,
      write_data_out   => open,
      write_enable_out => open,

-------------------------------------------------------------------------------
-- To reply block
-------------------------------------------------------------------------------

      reply_size_out                => open,
      reply_addr_out                => open,
      transaction_counter_out       => open,
      initiator_logical_address_out => open,

      memory_end_address_out => open,
      verify_data_out        => open,
      increment_data_out     => open,
      reply_en_out           => open,

-------------------------------------------------------------------------------
-- From reply block
-------------------------------------------------------------------------------

      reply_idle_in => '1',

-------------------------------------------------------------------------------
-- SpW output FIFO
-------------------------------------------------------------------------------
      dout_in   => dout9,
      empty_in  => '0',
      nread_out => nread
      );


  process

    file arquivo_imagem_in : text is in "/home/corsi/Desktop/datain.dat";
    variable Vetor         : std_logic_vector(8 downto 0);
    variable VetorBit      : bit_vector(8 downto 0);
    variable Tamanho_Vetor : natural;
    variable escrita       : natural := 0;
    variable linha_in      : line;
    variable linha_out     : line;

  begin
    file_open(arquivo_imagem_in, "/home/corsi/Desktop/datain.dat", read_mode);
    empty <= '0';
    while not ENDFILE(arquivo_imagem_in) loop
      READLINE(arquivo_imagem_in, linha_in);
      READ (linha_in, VetorBit);
      -- Sending 1 NChar's by Codec 0
      -- fica aguardando se pode escrever na entrada de dados (até obter tx_ready0=1)
      esperaout_ready_em_1 : while (nread = '0') loop
           wait for 5 ns;
      end loop esperaout_ready_em_1;
      -- Já pode escrever !!!!!!!!!
      dout9 <= To_StdLogicVector(VetorBit);
      wait for 5 ns;
    end loop;
    FILE_CLOSE(arquivo_imagem_in);
  end process;

 process 
  begin
    clk <= not clk;
    wait for 2 ns;
  end process;

  process
  begin
    clk_slow <= not clk_slow;
    wait for 5 ns;
  end process;

  process
  begin
    rst <= '1';
    wait for 20 ns;
    rst <= '0';
    wait;
  end process;
    
end architecture bhv;
