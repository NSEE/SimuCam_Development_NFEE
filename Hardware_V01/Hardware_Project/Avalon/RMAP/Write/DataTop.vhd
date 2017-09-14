--N�cleo de Sistemas Embarcados - Instituto Mau� de Tecnologia
--projeto: Simulador FEE
--nome do programa: 
--finalidade: Finalidade do programa
--vers�o: 1.0
--autor: Tiago Sanches da Silva
--                 <tiago.eem@gmail.com>
--data: 01-06-11
-------------------------------------------------------------------------------
-- Validado (Dia do bigode) 05.08.2011
-------------------------------------------------------------------------------
-- ======================
-- Modificacoes - Corsi
-- ======================
-- PLATO 2.0 - set/2014
-------------------------------------------------------------------------------
-- Alteraçoes para suportar a nova arquitetura proposta para o SIMUCAM 2.0
-- o databody nao acessa mais a memoria, os dados serao disponibilizados
-- em uma FIFO, o databody deve somente liberar os dados dessa fifo para o
-- dmux. Porem continua contato a quantidade de dados enviados, isso ser´a usado
-- para indicar ao up que a transmissao da linha foi concluida e que pode armezanar
-- novos dados.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.all;

entity DataTop is
     port(
          --------------------------------------------------
          -- Clk/ Rst
          --------------------------------------------------
          clock : in std_logic;
          aclr  : in std_logic;

          --------------------------------------------------
          -- config. do tamanho do pacote, incluindo pre_Scan_Pixel e
          -- smearing_rows.
          --------------------------------------------------
          Cols_PIX  :   in  std_logic_vector(12 downto 0);
          Lin_PIX   :   in  std_logic_vector(12 downto 0);

          Pre_Scan_px   : in std_logic_vector(7 downto 0);
          Smearing_rows : in std_logic_vector(7 downto 0);

          --------------------------------------------------
          -- delay entre um transferencia das meias linhas
          --------------------------------------------------
          Line_transfer_delay : in std_logic_vector(23 downto 0); --tempo em uso

          --------------------------------------------------
          -- para  controle RMAP
          --------------------------------------------------
          enable_patern : in std_logic;
          new_half_line : in std_logic;
          en_new_CCD    : in std_logic;     -- come after sync

          --------------------------------------------------
          -- Configura o RST da DC-FIFO (25/3/2015)
          --------------------------------------------------
          DC_FIFO_rst      : in std_logic; -- forced rst DC_FIFO
          DC_FIFO_auto_rst : in std_logic; -- rst dc fifo when new half_line or new_ccd

          --------------------------------------------------
          -- do Sub_Control_ChargeFIFO
          --------------------------------------------------
          Charge_HalfLine_Fifo_done   : out std_logic;
          Free_to_AccessMemory_Charge : in  std_logic;
          Critical_OP_Charge          : out std_logic;

          --------------------------------------------------
          --do Subcontrol_dataBody
          --------------------------------------------------
          Free_to_Transmit_DataBody   : in  std_logic;
          All_HalfLine_frame_done     : out std_logic;

          --------------------------------------------------
          --interface com CRC interno
          --------------------------------------------------
          ERROR_mode_CRC   : in  std_logic;   -- 0: desligado; 1: ligado modo erro
          CCD_number_CCDi  : in  std_logic_vector(1 downto 0);
          en_update_CCDi   : in  std_logic;

          --------------------------------------------------
          --interface externa
          --------------------------------------------------
          End_CCD_charge_FiFO   : out std_logic;
          End_CCD_Tranfer       : out std_logic;

          --------------------------------------------------
          --DC FIFO OUT
          --------------------------------------------------
          DC_FIFO_wclock   : in  std_logic;
          DC_FIFO_rclock   : in  std_logic;

          DC_FIFO_wrreq   : in  std_logic;
          DC_FIFO_data    : in  std_logic_vector(31 downto 0);
          DC_FIFO_wrfull  : out std_logic;
          DC_FIFO_wrusedw : out std_logic_vector (12 downto 0);

          DC_FIFO_rdempty : out std_logic;
          DC_FIFO_rdusedw : out std_logic_vector (12 downto 0);

          --------------------------------------------------
          -- Append byte
          --------------------------------------------------
          append_read_en      : out std_logic;    
          append_read_addr    : out std_logic_vector(7 downto 0);
          append_read_data    : in  std_logic_vector(7 downto 0);
          append_byte_size    : in  std_logic_vector(7 downto 0);

          --------------------------------------------------
          --Saida de dados do Bloco
          -- interface com autonomous FIFO
          --------------------------------------------------
          Data_out_SubC         : out std_logic_vector(8 downto 0);
          full_fifo_au          : in  std_logic;
          ac_fifo_empty         : in  std_logic;
          nwrite_fifo_au        : out std_logic  -- escrita em 0

    );
end DataTop;

architecture rtl of DataTop is
-- DC_FIFO
  signal aclr_DC_FIFO_signal         : std_logic;

-- Sub_Cont_dataBody
  signal Force_reset_dcfifo_signal   : std_logic;
  signal Force_clear_CRC_signal      : std_logic;

--Modulo CRC
  signal Clear_CRC_signal            : std_logic;
  signal enable_ler_data_CRC_signal  : std_logic;
  signal get_crc_CRC_signal          : std_logic;
  signal idle_CRC_signal             : std_logic;
  signal CRC_ready_CRC_signal        : std_logic;

--MUX_CCD_Data_PreS_HK
  signal data_CCD_in_signal          : std_logic_vector(7 downto 0);
  signal data_DATA_in_signal         : std_logic_vector(7 downto 0);
  signal data_OUT_signal             : std_logic_vector(7 downto 0);
  signal mux_data_select : std_logic_vector(1 downto 0);

--MUX_ALL_CRC
  signal data_CRC_in_signal          : std_logic_vector(7 downto 0);
  signal ALL_or_CRC_signal           : std_logic_vector(1 downto 0);

--DC_FIFO_TOP
  signal rdreq_dcfifo_signal         : std_logic;
  signal rdempty_dcfifo_signal       : std_logic;
  signal rdusedw_dcfifo_signal       : std_logic_vector(14 downto 0);

--Sub_Control_ChargeFIFO
  signal All_HalfLine_in_Fifo_signal : std_logic;
  signal All_transmited_signal       : std_logic;

  signal Fifo_charged_signal : std_logic;
  signal END_CCD_signal      : std_logic;
  
begin

  -- rst dc fifo, três modos:
  --   1. rst geral
  --   2. Forçado via Avalon ( DC_FIFO_rst)
  --   3. Forçado a cada nova linha ou a cada novo ccd
  aclr_DC_FIFO_signal <= aclr or DC_FIFO_rst or ((new_half_line or en_new_CCD) and DC_FIFO_auto_rst);

  DataMux0 : entity DataMux 
    port map
    (
        MuxSelect       => mux_data_select,
        Append          => append_read_data,
        Image	        => data_DATA_in_signal,
        data_OUT        => data_OUT_signal
    );

  MUX_ALL_CRC_inst0 : entity MUX_ALL_CRC1
    port map
    (
      ALL_or_CRC_EEP_EOP => ALL_or_CRC_signal,
      Error_Mode         => ERROR_mode_CRC,
      data_ALL_in        => data_OUT_signal,
      data_CRC_in        => data_CRC_in_signal,
      data_OUT           => Data_out_SubC
    );

  DC_FIFO_TOP_inst0 : entity DC_FIFO_TOP
    port map
    (
      clock   => clock,
      aclr    => aclr_DC_FIFO_signal,
      data    => DC_FIFO_data,               --externo
      rdclk   => DC_FIFO_rclock,
      rdreq   => rdreq_dcfifo_signal,
      wrclk   => DC_FIFO_wclock,              --externo
      wrreq   => DC_FIFO_wrreq,       --externo
      q       => data_DATA_in_signal,
      rdempty => rdempty_dcfifo_signal,
      rdusedw => DC_FIFO_rdusedw,
      wrfull  => DC_FIFO_wrfull,      --externo
      wrusedw => DC_FIFO_wrusedw      --externo
      );

  Clear_CRC_signal <= aclr or Force_clear_CRC_signal;

  Modulo_crc_top_inst0 : entity Modulo_crc_top
    port map
    (
      clock           => clock,
      clear           => Clear_CRC_signal,
      enable_ler_data => enable_ler_data_CRC_signal,
      get_crc         => get_crc_CRC_signal,
      data_in         => data_OUT_signal,
      CRC_out         => data_CRC_in_signal,
      idle            => idle_CRC_signal,
      CRC_ready       => CRC_ready_CRC_signal
      );

  DataLogic0 : entity DataLogic
    port map (
      clock => clock,
      clear => aclr,

      enable_patern           => enable_patern,
      new_half_line           => new_half_line,
      en_new_CCD              => en_new_CCD,
      free_to_transmit        => Free_to_Transmit_DataBody,
      All_transmited          => All_transmited_signal,
      End_CCD_Trasfer         => END_CCD_signal,
      Cols_PIX                => Cols_PIX,
      Lins_PIX                => Lin_Pix,

      -- delay entre um transferencia das meias linhas
      Line_transfer_delay     => Line_transfer_delay,
      Pre_Scan_px             => Pre_Scan_px,
      Smearing_rows           => Smearing_rows,

      -- interface com o bloco que carrega os dados da mem�ria
      Fifo_charged      => Fifo_charged_signal,

      -- interface com a autonomous fifo
      full_fifo_au            => full_fifo_au,
      nwrite_fifo_au          => nwrite_fifo_au,
      ac_fifo_empty           => ac_fifo_empty,


      -- interface com Dual clock Fifo
      rdreq_dcfifo            => rdreq_dcfifo_signal,
      rdempty_dcfifo          => rdempty_dcfifo_signal,
      Force_reset_dcfifo      => Force_reset_dcfifo_signal,

      -- interface Modulo_crc
      enable_ler_data_CRC     => enable_ler_data_CRC_signal,
      get_crc_CRC             => get_crc_CRC_signal,
      idle_CRC                => idle_CRC_signal,
      CRC_ready_CRC           => CRC_ready_CRC_signal,
      clear_CRC               => Force_clear_CRC_signal,

      -- MUX interno 1
      Mux_CCD_Data_PreS       => mux_data_select,

      -- Append Bytes
      append_byte_size    => append_byte_size, 
      append_read_en      => append_read_en,  
      append_read_addr    => append_read_addr,  
    
      -- Mux 2 para externo
      Mux_ALL_CRC             => ALL_or_CRC_signal
      );

  ----------------------------------------------------
  -- CORsi
  ----------------------------------------------------
  -- TODO:
  -- sinais que eram controlados pelo charge e nao sao mais
  -- precisamos editar isso futuramente e entender direito no
  -- que isso vai influenciar -> Simular
  -- DC-FIFO deve ser exportado para fora.
  ----------------------------------------------------
  Fifo_charged_signal   <= '1';

  --END_CCD_signal      <= '0';
  Critical_OP_Charge    <= '0';

  ----------------------------------------------------
  Charge_HalfLine_Fifo_done <= Fifo_charged_signal;
  End_CCD_charge_FiFO       <= END_CCD_signal;
  All_HalfLine_frame_done   <= All_transmited_signal;
  End_CCD_Tranfer           <= END_CCD_signal and All_transmited_signal;

  ----------------------------------------------------
  -- Sinais da DC fifo são mapeados para a mem_geral
  ----------------------------------------------------
  -- 3/3/2015
  DC_FIFO_rdempty <= rdempty_dcfifo_signal;

end rtl;
