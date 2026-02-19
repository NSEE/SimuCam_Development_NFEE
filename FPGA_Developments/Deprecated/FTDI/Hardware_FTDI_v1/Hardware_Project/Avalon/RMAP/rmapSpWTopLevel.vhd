-------------------------------------------------------------------------------
-- Title      : RMAP CONTROLLER
-- Project    : N-FEE
-------------------------------------------------------------------------------
-- File       : read_Handler_TOP.vhd
-- Author     : Rafael Corsi Ferrao - corsiferrao@gmail.com
-- Company    : Instituto Mauá de Tecnologia - NSEE
-- Created    : 2011-08-30
-- Last update: 2017-02-17
-- Platform   :
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: RMAP CONTROLLER
-------------------------------------------------------------------------------
-- Copyright (c) 2011 Instituto Mauá de Tecnologia - NSEE - Brasil
-------------------------------------------------------------------------------
-- Revisions  : 1.1 Add more signal from de dc and ac fifo
-- Date        Version  Author  Description
-- 2011-08-30  1.0      corsi   Created
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
use ieee.numeric_std.all;
use work.all;

entity rmapSpWTopLevel is
  generic(
    -- RMAP READ REPLY --
    memory_length    : natural	:= 9;
    hk_start_address : natural	:= 64;
    hk_end_address   : natural	:= 127;

    -- Data body Charge
    Link_side_CCD : natural range 0 to 1 := 0;
    QTD_HK        : natural				 := 12;

    -- Autonomus fifo
    data_width : natural	:= 9
    );  
  port (
-------------------------------------------------------------------------------
-- Global
-------------------------------------------------------------------------------
    sysclk   : in std_logic;
    rst      : in std_logic;

    Sync_6           : in std_logic;
    Sync_25          : in std_logic;
    CCD_number_in    : in std_logic_vector(1 downto 0);
    CCD_en_update_in : in std_logic;

-------------------------------------------------------------------------------
-- Controlador RMAP_SPW
-------------------------------------------------------------------------------
    Acesso_a_Memoria       : in  std_logic;
    Transmissao_finalizada : out std_logic;

    conf_Modo_OP_geral   : in std_logic;                     -- is running
    conf_Modo_OP_Running : in std_logic_vector(1 downto 0);  --(00:StandBy;01:test;10:integration;11:Operational)

-------------------------------------------------------------------------------
-- RMAP READ REPLY
-------------------------------------------------------------------------------
-- Data recovered information
    reader_read_op_out  : out std_logic;  -- Operacao de leitura ok
    reader_write_op_out : out std_logic;  -- Operação de escrita ok

    reader_data_length_out  : out std_logic_vector(23 downto 0);  --indicate the new data
                                                                  --size
    reader_data_address_out : out std_logic_vector(39 downto 0);  --indicate the new data
                                                                  --address
-- Erros

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

    -- Configurations
    reader_config_key_in                 : in std_logic_vector(7 downto 0);
    reader_config_logical_addr_in        : in std_logic_vector(7 downto 0);
    reader_config_target_fisical_addr_in : in std_logic_vector(15 downto 0);
    reader_config_fisical_addr_size_in   : in std_logic_vector(1 downto 0);

    -- CCD config.
    Cols_PIX            : in std_logic_vector(12 downto 0);
    Lin_PIX             : in std_logic_vector(12 downto 0);
    Pre_Scan_px         : in std_logic_vector(7 downto 0);
    Smearing_rows       : in std_logic_vector(7 downto 0);
    Line_transfer_delay : in std_logic_vector(23 downto 0);  --tempo em us                       
  
    -- Read
    reader_memory_read_enable_out    : out std_logic;
    reader_memory_read_addr_out      : out std_logic_vector(memory_length-1 downto 0) := (others => '0');
    reader_memory_read_data_ready_in : in  std_logic;
    reader_memory_read_data_in       : in  std_logic_vector(7 downto 0);

    --Write
    reader_memory_write_addr_out   : out std_logic_vector(39 downto 0);
    reader_memory_write_data_out   : out std_logic_vector(7 downto 0);
    reader_memory_write_enable_out : out std_logic;

    -- HouseKeep information
    reader_hk_accepted_out : out std_logic;
    reader_hk_rejected_out : out std_logic;

-------------------------------------------------------------------------------
-- HEAD
-------------------------------------------------------------------------------

    -- sinais do sub_controlador
    head_error_mode_in : in std_logic;

    -- Configurations
    head_config_address_step_in           : in std_logic_vector(31 downto 0);
    head_config_fisical_length_in         : in std_logic_vector(1 downto 0);
    head_config_target_fisical_addr_in    : in std_logic_vector(15 downto 0);
    head_config_target_logical_in         : in std_logic_vector(7 downto 0);
    head_config_key_in                    : in std_logic_vector(7 downto 0);
    head_config_reply_addr_in             : in std_logic_vector(15 downto 0);
    head_config_initiator_logical_addr_in : in std_logic_vector(7 downto 0);
    head_config_addr_extend_in            : in std_logic_vector(7 downto 0);
    head_config_addr3_in                  : in std_logic_vector(7 downto 0);
    head_config_addr2_in                  : in std_logic_vector(7 downto 0);
    head_config_addr1_in                  : in std_logic_vector(7 downto 0);
    head_config_addr0_in                  : in std_logic_vector(7 downto 0);
    head_config_length2_in                : in std_logic_vector(7 downto 0);
    head_config_length1_in                : in std_logic_vector(7 downto 0);
    head_config_length0_in                : in std_logic_vector(7 downto 0);

-------------------------------------------------------------------------------
-- CHARGE DATA BODY
-------------------------------------------------------------------------------
    -- sinais do sub_controlador
    charge_error_mode_in        : in std_logic;

    -- End of op
    charge_end_ccd_transfer_out : out std_logic;

-------------------------------------------------------------------------------
-- DC FIFO 32b -> 8b
-------------------------------------------------------------------------------	
-- modificado : 3/3/2015 - Adicionei rdempty e rdusedw
-- padronizei os nomes dos sinais
    DC_FIFO_wclock   : in  std_logic;
    DC_FIFO_rclock   : in  std_logic;

    DC_FIFO_wrreq   : in  std_logic;
    DC_FIFO_data    : in  std_logic_vector(31 downto 0);
    DC_FIFO_wrfull  : out std_logic;
    DC_FIFO_wrusedw : out std_logic_vector (12 downto 0);

    DC_FIFO_rdempty : out std_logic;
    DC_FIFO_rdusedw : out std_logic_vector (14 downto 0);

    -- Configura o RST da DC-FIFO (25/3/2015)
    DC_FIFO_rst      : in std_logic; -- forced rst DC_FIFO
    DC_FIFO_auto_rst : in std_logic; -- rst dc fifo when new half_line or new_ccd

   -- Append Bytes
    append_read_en      : out std_logic;    
    append_read_addr    : out std_logic_vector(7 downto 0);
    append_read_data    : in  std_logic_vector(7 downto 0);
    append_byte_size    : in  std_logic_vector(7 downto 0);

-----------------------------------------------------------------------------
-- Autonomus FIFO READ
-------------------------------------------------------------------------------
    spw_fifo_r_dout     : in  std_logic_vector(8 downto 0);  -- SpW FIFO data output
    spw_fifo_r_empty    : in  std_logic;  -- SpW FIFO controll output
    spw_fifo_r_read     : out std_logic;  -- SpW FIFO read command

-----------------------------------------------------------------------------
-- Autonomus FIFO Write
-----------------------------------------------------------------------------
    autonomous_w_empty : out std_logic;
    autonomous_w_nread : in  std_logic;
    autonomous_w_dout  : out std_logic_vector(data_width-1 downto 0);

-- Debug
    fifo_w_full_out    : out std_logic

    );

end entity rmapSpWTopLevel;


architecture bhv of rmapSpWTopLevel is

  signal Sync_in           : std_logic;
  signal clear_subcontrol : std_logic;

-----------------------------------------------------------------------------
-- Control
-----------------------------------------------------------------------------
  signal Sel_DMux_nWrite_Data_signal : std_logic_vector(2 downto 0);  -- (000:Head;001:DataBody;010:HK;011:Read; 1XX: EEP)
  signal Control_nwrite_signal       : std_logic;


-----------------------------------------------------------------------------
-- Reader
-----------------------------------------------------------------------------

  signal reader_fifo_w_dout_9b         : std_logic_vector(8 downto 0);  -- Sync FIFO data output
  signal reader_fifo_w_nwrite          : std_logic;  -- Sync FIFO controll output
  signal reader_free_to_transmit       : std_logic;
  signal reader_request_to_transmit    : std_logic;
  -- enables e requests
  signal reader_enable_signal          : std_logic;
  signal reader_enable_hk_reply_signal : std_logic;

-------------------------------------------------------------------------------
-- House Keeping
-------------------------------------------------------------------------------

  signal hk_free_to_transmit_tr : std_logic;
  signal hk_fifo_w_dout_9b      : std_logic_vector(8 downto 0);
  signal hk_nwrite_acfifo       : std_logic;
  signal hk_transmit_done       : std_logic;
  signal hk_idle                : std_logic;

-------------------------------------------------------------------------------
-- HEAD
-------------------------------------------------------------------------------

  signal head_free_to_transmit_tr : std_logic;
  signal head_fifo_w_dout_8b      : std_logic_vector(7 downto 0);
  signal head_nwrite_acfifo       : std_logic;
  signal head_transmit_done       : std_logic;
  signal head_idle                : std_logic;
  signal head_data_9b_signal      : std_logic_vector(8 downto 0);

-------------------------------------------------------------------------------
-- CHARGE
-------------------------------------------------------------------------------

  signal charge_new_half_line : std_logic;
  signal charge_en_new_ccd    : std_logic;
  signal charge_one_link_mode : std_logic;

  signal charge_halfLine_fifo_done          : std_logic;
  signal charge_free_to_accessmemory        : std_logic;
  signal charge_critical_op                 : std_logic;
  signal charge_free_to_transmit_dataBody   : std_logic;
  signal charge_DCFIFO_transm_halfLine_done : std_logic;
  signal charge_All_halfline_frame_done     : std_logic;
  signal charge_end_ccd_transfer            : std_logic;
  signal charge_end_ccd_charge_fifo         : std_logic;

  signal charge_fifo_w_dout_9b : std_logic_vector(8 downto 0);
  signal charge_nwrite_acfifo  : std_logic;

-------------------------------------------------------------------------------
-- Pattern
-------------------------------------------------------------------------------
  signal pattern_enable : std_logic;

  signal charge_memcontroller_ready : std_logic;
  signal charge_memcontroller_idle  : std_logic;

  signal charge_memcontroller_data    : std_logic_vector(31 downto 0);
  signal charge_memcontroller_en_read : std_logic;
  signal charge_memcontroller_addr    : std_logic_vector(24 downto 0);
  -- constant config_cols_px             : std_logic_vector(12 downto 0) := std_logic_vector(to_unsigned((half_line_px_size*2), 13));
-------------------------------------------------------------------------------
-- Autonomous FIFO Write
-------------------------------------------------------------------------------

  signal fifo_w_nwrite          : std_logic;
  signal fifo_w_full            : std_logic;
  signal fifo_w_din_9b          : std_logic_vector(8 downto 0);
  signal fifo_w_clear           : std_logic := '0';
  signal autonomous_w_empty_int : std_logic;
  signal ac_fifo_empty          : std_logic;

begin  -- architecture top

-----------------------------------------------------------------------------
-- RMAP_READ_REPLY_TOP
-----------------------------------------------------------------------------

  ReadTop0 : entity ReadTop

    generic map(
      memory_length    => memory_length,
      hk_start_address => hk_start_address,
      hk_end_address   => hk_end_address
      )
    port map(

-- Global
      clk      => sysclk,
      clk_slow => sysclk,
      rst      => rst,

-- Data recovered information
      read_op_out  => reader_read_op_out,   -- Operacao de leitura ok
      write_op_out => reader_write_op_out,  -- Operação de escrita ok

      data_length_out  => reader_data_length_out,   --indicate the new data
                                                    --size
      data_address_out => reader_data_address_out,  --indicate the new data
                                                    --address

-- Erros
      erro_early_eop_out                  => erro_early_eop_out,
      erro_eep_out                        => erro_eep_out,
      erro_eep_data_out                   => erro_eep_data_out,
      erro_unsed_rmap_type_out            => erro_unsed_rmap_type_out,
      erro_rmap_comd_not_impl_auto_out    => erro_rmap_comd_not_impl_auto_out,
      erro_invalid_header_crc_out         => erro_invalid_header_crc_out,
      erro_invalid_key_out                => erro_invalid_key_out,
      erro_invalid_target_logical_add_out => erro_invalid_target_logical_add_out,
      erro_invalid_data_crc_out           => erro_invalid_data_crc_out,
      erro_verify_buffer_overrun_out      => erro_verify_buffer_overrun_out,
      erro_too_much_data_out              => erro_too_much_data_out,
      erro_insufficient_data_out          => erro_insufficient_data_out,
      erro_address_out_of_range_out       => erro_address_out_of_range_out,

-- Write FIFO
      fifo_w_dout_out   => reader_fifo_w_dout_9b,  -- Sync FIFO data output
      fifo_w_nwrite_out => reader_fifo_w_nwrite,   -- Sync FIFO controll output
      fifo_w_full_in    => fifo_w_full,            -- Sync FIFO read command

-- Read Autonomus SpW fifo
       spw_fifo_r_dout    => spw_fifo_r_dout,    -- SpW FIFO data output
       spw_fifo_r_empty   => spw_fifo_r_empty,   -- SpW FIFO controll output
       spw_fifo_r_read    => spw_fifo_r_read,  -- SpW FIFO read command

-- Configurations
      config_key_in                 => reader_config_key_in,
      config_logical_addr_in        => reader_config_logical_addr_in,
      config_target_fisical_addr_in => reader_config_target_fisical_addr_in,
      config_fisical_addr_size_in   => reader_config_fisical_addr_size_in,

-- Enables/ Requests
      enable_reader_in        => reader_enable_signal,
      enable_hk_transmit_in   => reader_enable_hk_reply_signal,
      free_to_transmit_in     => reader_free_to_transmit,
      request_to_transmit_out => reader_request_to_transmit,


-- Memory

      -- Read
      memory_read_enable_out    => reader_memory_read_enable_out,
      memory_read_addr_out      => reader_memory_read_addr_out,
      memory_read_data_ready_in => reader_memory_read_data_ready_in,
      memory_read_data_in       => reader_memory_read_data_in,

      --Write
      memory_write_addr_out   => reader_memory_write_addr_out,
      memory_write_data_out   => reader_memory_write_data_out,
      memory_write_enable_out => reader_memory_write_enable_out,

-- HouseKeep information
      hk_accepted_out => reader_hk_accepted_out,
      hk_rejected_out => reader_hk_rejected_out
      );

  -------------------------------------------------------------------------------
-- HEAD DATA
-------------------------------------------------------------------------------

  HeadTop0 : entity HeadTop 
    port map
    (
        aclr  => clear_subcontrol,
        clock => sysclk,

        -- sinais do sub_controlador
        FreeToTransmit  => head_free_to_transmit_tr,
        Sync            => Sync_in,
        Error_Mode      => head_error_mode_in,
        transmit_done   => head_transmit_done,
        Idle_SubControl => head_idle,
        head_sync_reset => charge_en_new_ccd,

        -- Configuration
        config_address_step_in           => head_config_address_step_in,
        config_fisical_length_in         => head_config_fisical_length_in,
        config_target_fisical_addr_in    => head_config_target_fisical_addr_in,
        config_target_logical_in         => head_config_target_logical_in,
        config_key_in                    => head_config_key_in,
        config_reply_addr_in             => head_config_reply_addr_in,
        config_initiator_logical_addr_in => head_config_initiator_logical_addr_in,
        config_addr_extend_in            => head_config_addr_extend_in,
        config_addr3_in                  => head_config_addr3_in,
        config_addr2_in                  => head_config_addr2_in,
        config_addr1_in                  => head_config_addr1_in,
        config_addr0_in                  => head_config_addr0_in,
        config_length2_in                => head_config_length2_in,
        config_length1_in                => head_config_length1_in,
        config_length0_in                => head_config_length0_in,

        --interface SPW_autonomus_FIFO
        data_OUT  => head_fifo_w_dout_8b,
        nwrite_ac => head_nwrite_acfifo,
        full_ac   => fifo_w_full
      );

-------------------------------------------------------------------------------
-- DATA BODY
-------------------------------------------------------------------------------

    DataTop0 : entity DataTop
      port map (

        clock => sysclk,
        aclr  => clear_subcontrol,

        Cols_PIX            => Cols_PIX,
        Lin_PIX             => Lin_PIX,
        Line_transfer_delay => Line_transfer_delay,

        Pre_Scan_px   => Pre_Scan_px,
        Smearing_rows => Smearing_rows,

        enable_patern => pattern_enable,
        --Para  Controle Externo

        new_half_line   => charge_new_half_line,
        en_new_CCD      => charge_en_new_ccd,

        -- Configura o RST da DC-FIFO (25/3/2015)
        DC_FIFO_rst      =>  DC_FIFO_rst,      -- forced rst DC_FIFO
        DC_FIFO_auto_rst =>  DC_FIFO_auto_rst, -- rst dc fifo when new half_line or new_ccd

        --do Sub_Control_ChargeFIFO
        Charge_HalfLine_Fifo_done   => charge_halfLine_fifo_done,
        Free_to_AccessMemory_Charge => charge_free_to_accessmemory,
        Critical_OP_Charge          => charge_critical_op,

        --do Subcontrol_dataBody
        Free_to_Transmit_DataBody => charge_free_to_transmit_dataBody,
        All_HalfLine_frame_done   => charge_All_halfline_frame_done,

        -- corsi
        DC_FIFO_wrfull  => DC_FIFO_wrfull,
        DC_FIFO_wrusedw => DC_FIFO_wrusedw,
        DC_FIFO_rclock  => DC_FIFO_rclock,
        DC_FIFO_wclock  => DC_FIFO_wclock,
        DC_FIFO_wrreq   => DC_FIFO_wrreq,
        DC_FIFO_data    => DC_FIFO_data,
        DC_FIFO_rdempty => DC_FIFO_rdempty,
        DC_FIFO_rdusedw => DC_FIFO_rdusedw(12 downto 0),

        -- corsi : append bytes
        append_byte_size    => append_byte_size, 
        append_read_en      => append_read_en,  
        append_read_addr    => append_read_addr,  
        append_read_data    => append_read_data, 
        
        -- error mode ?
        ERROR_mode_CRC => charge_error_mode_in,

        -- interface com o CCD_identify interno
        CCD_number_CCDi => CCD_number_in,
        en_update_CCDi  => CCD_en_update_in,

        --interface externa
        End_CCD_charge_FiFO => charge_end_ccd_charge_fifo,
        End_CCD_Tranfer     => charge_end_ccd_transfer,

        --interface com autonomous FIFO
        full_fifo_au   => fifo_w_full,
        nwrite_fifo_au => charge_nwrite_acfifo,
        ac_fifo_empty  => autonomous_w_empty_int,
        Data_out_SubC  => charge_fifo_w_dout_9b
        );

-------------------------------------------------------------------------------
-- Controler Rmap WRITE
-------------------------------------------------------------------------------

  controllerRMAP0 : entity ControllerRMAP 
    port map
    (
      clock => sysclk,
      aclr  => rst,

      sync_6  => sync_6,
      sync_25 => sync_25,

      n_write_Control     => Control_nwrite_signal,
      full_acfifo_Control => fifo_w_full,
      Clear_SubControls   => clear_subcontrol,

      -- Pattern
      patern_enable => pattern_enable,


      -- interface com o controlador Geral
      Acesso_a_Memoria       => Acesso_a_Memoria,
      Transmissao_finalizada => Transmissao_finalizada,

      --interface com o Registrado geral
      conf_Modo_OP_geral   => conf_Modo_OP_geral,    -- is running
      conf_Modo_OP_Running => conf_Modo_OP_Running,  --(00:StandBy;01:test;10:integration;11:Operational)

      -- controle do caçalho de escrita
      -- interface com Sub_Control_Head
      Free_to_Transmit_tr_Head => head_free_to_transmit_tr,
      transmit_done_Head       => head_transmit_done,
      idle_SubControl_Head     => head_idle,


      -- controle do corpo do datagrama de escrita
      -- interface com DataBody_Charge_Control
      new_half_line_DataBody             => charge_new_half_line,
      en_new_CCD_DataBody                => charge_en_new_ccd,
      one_link_mode_DataBody             => charge_one_link_mode,
      Free_to_AccessMemory_Charger       => charge_free_to_accessmemory,
      Free_to_Transmit_DataBody          => charge_free_to_transmit_dataBody,
      Charge_HalfLine_Fifo_Done_DataBody => charge_halfLine_fifo_done,
      Critical_OP_Charger                => charge_critical_op,
      All_halfLine_Frame_sent_DataBody   => charge_All_halfline_frame_done,
      End_CCD_charge_Fifo                => charge_end_ccd_charge_fifo,
      End_CCD_Transfer                   => charge_end_ccd_transfer,

      -- controle do bloco de leitura e Resposta do RMAP
      -- interface com RMAP_read_reply
      Free_to_transmit_Read_Reply    => reader_free_to_transmit,
      request_to_transmit_Read_Reply => reader_request_to_transmit,
      enbale_Reader_HK               => reader_enable_hk_reply_signal,
      enable_Reader                  => reader_enable_signal,

      Sel_DMux_nWrite_Data => Sel_DMux_nWrite_Data_signal  -- (000:Head;001:DataBody;010:HK;011:Read; 1XX: EEP)

      );

	  
-------------------------------------------------------------------------------
-- Autonomus FIFO
-------------------------------------------------------------------------------

    autono_L : entity ac_fifo_wrap
      generic map(
        --== Data Width ==--
        AC_WRITE   => '1',
        data_width => data_width
        )
      port map(
        --==  General Interface ==--

        rst       => fifo_w_clear,
        clk_write => sysclk,
        clk_read  => sysclk,

        --== Input Interface ==--

        nwrite => fifo_w_nwrite,
        full   => fifo_w_full,
        din    => fifo_w_din_9b,

        --== Output Interface ==--

        empty => autonomous_w_empty_int,
        nread => autonomous_w_nread,
        dout  => autonomous_w_dout
        );

  fifo_w_clear       <= rst or Sync_25 or Sync_6;  -- Clear fifo @ new sync
  autonomous_w_empty <= autonomous_w_empty_int;

  -- Debug
  ac_fifo_empty   <= autonomous_w_empty_int;
  fifo_w_full_out <= fifo_w_full;	  
  
-------------------------------------------------------------------------------
-- Demux
-------------------------------------------------------------------------------

  GlobalMux0 : entity GlobalMux
    port map
    (
      clock                => sysclk,
      Sel_DMux_nWrite_Data => Sel_DMux_nWrite_Data_signal,  -- (000:Head;001:DataBody;010:HK;011:Read; 1XX: EEP)

      nWrite_Head     => head_nwrite_acfifo,
      nWrite_DataBody => charge_nwrite_acfifo,
      nWrite_Read     => reader_fifo_w_nwrite,
      nWrite_Control  => Control_nwrite_signal,

      data_Head     => head_data_9b_signal,
      data_DataBody => charge_fifo_w_dout_9b,
      data_Read     => reader_fifo_w_dout_9b,

      nWrite_out => fifo_w_nwrite,
      data_out   => fifo_w_din_9b
      );
	  
-------------------------------------------------------------------------------
-- Internal to external reg
-------------------------------------------------------------------------------

  charge_end_ccd_transfer_out <= charge_end_ccd_transfer;
  Sync_in                     <= Sync_6 or Sync_25;
  head_data_9b_signal         <= '0' & head_fifo_w_dout_8b;
  
end architecture bhv;
