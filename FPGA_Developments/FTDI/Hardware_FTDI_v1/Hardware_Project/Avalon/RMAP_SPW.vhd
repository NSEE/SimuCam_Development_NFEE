-------------------------------------------------------------------------------
-- Instituto Maua de Tecnologia
-- 	Nucleo de Sistemas Eletronicos Embarcados
--
-- Rafael Corsi - rafael.corsi@maua.br
-- Platao Simucam 2.0
--
-- Set/2014
--
--------------------------------------------------------------------------------
-- Descriao
--
--Funcionalidade
--	Possui os elementos basicos para a transmissao de dados entre um (N/F)-FEE e
-- 	uma (N/F)-DPU, o sistema e controlado via registradores que serao geridos
--	por um uc (NIOS).
--  A transmissao das imagems, hk e controle da FEE e´ realizada via comandos RMAP
--  esse bloco deve portanto implemnetar comandos RMAP de Leitura, Escrita, Leitura-Escrita
--
-- tab_length= 4
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.spwpkg.all;
use work.all;

entity RMAP_SPW is
    generic ( 
        ---------- 
        -- RMAP --
        ----------
        -- RMAP READ REPLY
        memory_length              : natural := 9;
        hk_start_address           : natural := 0;
        hk_end_address             : natural := 127
    );
    port (
        -- Gloabals
        codec_clk     : in  std_logic := '0';
        avalon_clk    : in  std_logic := '0';
        reset         : in  std_logic := '0';             

        -- IRQ
        ins_irq0_irq  : out std_logic;                                             -- irq0.irq

        -- RMAP Register
        -- Avalion Memmory Mapped Slave
        avs_s0_address     : in  std_logic_vector(7 downto 0)  := (others => '0'); -- s0.address
        avs_s0_read        : in  std_logic                     := '0';             -- .read
        avs_s0_readdata    : out std_logic_vector(31 downto 0);                    -- .readdata
        avs_s0_write       : in  std_logic                     := '0';             -- .write
        avs_s0_writedata   : in  std_logic_vector(31 downto 0) := (others => '0'); -- .writedata
        avs_s0_waitrequest : out std_logic;                                        -- .waitrequest

        -- DC FIFO
        -- Avalion Memmory Mapped Slave
        avs_s1_address     : in  std_logic_vector(12 downto 0)  := (others => '0'); -- s1.address
        avs_s1_readdata    : out std_logic_vector(31 downto 0);                    -- .readdata
        avs_s1_read        : in  std_logic                     := '0';             -- .read
        avs_s1_write       : in  std_logic                     := '0';             -- .write
        avs_s1_writedata   : in  std_logic_vector(31 downto 0) := (others => '0'); -- .writedata
        avs_s1_waitrequest : out std_logic;                                        -- .waitrequest

        -- SpW Signals
        spw_si   : in std_logic;
        spw_so   : out std_logic;
        spw_di   : in std_logic;
        spw_do   : out std_logic;

        -- SYNC
        Sync  : in std_logic_vector(1 downto 0)

	);
end entity RMAP_SPW;

architecture rtl of RMAP_SPW is

--=====================--
--       Sinal         --
--=====================--

-----------------------------------------
-- Clock e reset
-----------------------------------------
  signal s_sysclk, s_rxclk, s_txclk: std_logic;

  attribute KEEP: boolean;
  attribute KEEP of s_sysclk: signal is true;
  attribute KEEP of s_txclk:  signal is true;
  attribute KEEP of s_rxclk:  signal is true;


--===============--
-- Avalon MM Slave
--===============--
  -- Acesso a memória geral
  signal reg_dout           : std_logic_vector(31 downto 0);
  signal reg_din            : std_logic_vector(31 downto 0);
  signal reg_address        : std_logic_vector(8 downto 0);
  signal reg_read           : std_logic;
  signal reg_write          : std_logic;

  -- Acesso ao DC FIFO
  signal dc_data            : std_logic_vector(31 downto 0);
  signal dc_write           : std_logic;
  signal dc_waitrequest     : std_logic;
  signal dc_wrusedw         : std_logic_vector(12 downto 0);
  signal dc_rdempty         : std_logic;
  signal dc_rdusedw         : std_logic_vector (14 downto 0);

  signal DC_FIFO_rst       : std_logic; 
  signal DC_FIFO_auto_rst  : std_logic; 

--====================--
--      RMAP
--====================--

--------------------
-- Registro
--------------------

  signal Operation_global    : std_logic;
  signal Operation_service   : std_logic;
  signal Operation_running   : std_logic_vector(1 downto 0);
  signal Operation_CRC_fault : std_logic;
  signal Operation_sync      : std_logic;


  signal Operation_Start_Stop_signal    : std_logic;
  signal Operation_Pause_Resume_signal  : std_logic;
  signal Operation_Reset_Pattern_signal : std_logic;
  signal Operation_Spill_on_signal      : std_logic;

  signal time_sync_signal           : std_logic_vector(15 downto 0);
  signal ADC_delay_10ns_signal      : std_logic_vector(15 downto 0);

  signal Cols_PIX_signal           : std_logic_vector(12 downto 0);
  signal Lin_PIX_signal            : std_logic_vector(12 downto 0);
  signal line_transfer_time_signal : std_logic_vector(23 downto 0);

--------------------
-- Reader 
--------------------
  signal reader_config_key                 : std_logic_vector(7 downto 0);
  signal reader_config_logical_addr        : std_logic_vector(7 downto 0);
  signal reader_config_target_fisical_addr : std_logic_vector(15 downto 0);
  signal reader_config_fisical_addr_size   : std_logic_vector(1 downto 0);

  -- Read
  signal reader_memory_read_enable     : std_logic;
  signal reader_memory_read_addr       : std_logic_vector(8 downto 0) := (others => '0');
  signal reader_memory_read_data_ready : std_logic;
  signal reader_memory_read_data       : std_logic_vector(7 downto 0);

  --Write
  signal reader_memory_write_addr   : std_logic_vector(39 downto 0);
  signal reader_memory_write_data   : std_logic_vector(7 downto 0);
  signal reader_memory_write_enable : std_logic;

--------------------
-- House Keeping
--------------------


  -- Configurations

  signal hk_config_address_step           : std_logic_vector(31 downto 0);
  signal hk_config_fisical_length         : std_logic_vector(1 downto 0);
  signal hk_config_target_fisical_addr    : std_logic_vector(15 downto 0);
  signal hk_config_target_logical         : std_logic_vector(7 downto 0);
  signal hk_config_key                    : std_logic_vector(7 downto 0);
  signal hk_config_reply_addr             : std_logic_vector(15 downto 0);
  signal hk_config_initiator_logical_addr : std_logic_vector(7 downto 0);
  signal hk_config_addr_extend            : std_logic_vector(7 downto 0);
  signal hk_config_addr3                  : std_logic_vector(7 downto 0);
  signal hk_config_addr2                  : std_logic_vector(7 downto 0);
  signal hk_config_addr1                  : std_logic_vector(7 downto 0);
  signal hk_config_addr0                  : std_logic_vector(7 downto 0);
  signal hk_config_length2                : std_logic_vector(7 downto 0);
  signal hk_config_length1                : std_logic_vector(7 downto 0);
  signal hk_config_length0                : std_logic_vector(7 downto 0);

------------------
-- Head
------------------
  signal head_config_address_step           : std_logic_vector(31 downto 0);
  signal head_config_fisical_length         : std_logic_vector(1 downto 0);
  signal head_config_target_fisical_addr    : std_logic_vector(15 downto 0);
  signal head_config_target_logical         : std_logic_vector(7 downto 0);
  signal head_config_key                    : std_logic_vector(7 downto 0);
  signal head_config_reply_addr             : std_logic_vector(15 downto 0);
  signal head_config_initiator_logical_addr : std_logic_vector(7 downto 0);
  signal head_config_addr_extend            : std_logic_vector(7 downto 0);
  signal head_config_addr3                  : std_logic_vector(7 downto 0);
  signal head_config_addr2                  : std_logic_vector(7 downto 0);
  signal head_config_addr1                  : std_logic_vector(7 downto 0);
  signal head_config_addr0                  : std_logic_vector(7 downto 0);
  signal head_config_length2                : std_logic_vector(7 downto 0);
  signal head_config_length1                : std_logic_vector(7 downto 0);
  signal head_config_length0                : std_logic_vector(7 downto 0);

------------------
-- Sincronismo
------------------
  signal sync_timer : std_logic_vector(15 downto 0);
  signal sync_counter : std_logic_vector(7 downto 0);
------------------
-- Pattern
------------------
  signal pattern_type : std_logic_vector(7 downto 0);

------------------
-- CCD enable
------------------
  signal ccd_enable : std_logic;

------------------
-- Prescan
------------------
  signal charge_en_data_preS    : std_logic;
  signal charge_addr_preS       : std_logic_vector(5 downto 0);  -- usar apenas da posiçao 0 até a 49
  signal charge_data_ready_preS : std_logic;
  signal charge_data_PreS_in    : std_logic_vector(7 downto 0);
  signal Pre_Scan_px_signal       : std_logic_vector(7 downto 0);
  signal Smearing_rows_signal     : std_logic_vector(7 downto 0);

------------------
-- Autonomus Fifos
------------------
  -- Read Data
  -- todo: mapear para o lugar certo !!!
  signal spw_fifo_r_dout        : std_logic_vector(8 downto 0);
  signal spw_fifo_r_read       : std_logic;
  signal spw_fifo_r_read_READ  : std_logic;
  signal spw_fifo_r_empty       : std_logic;

  -- Write Data

  signal autonomous_w_dout  : std_logic_vector(8 downto 0);
  signal autonomous_w_nread : std_logic;
  signal autonomous_w_empty : std_logic;

------------------
-- Data Body
------------------
   -- Append Bytes
   signal append_read_en      : std_logic;    -- enable read
   signal append_read_addr    : std_logic_vector(7 downto 0);
   signal append_read_data    : std_logic_vector(7 downto 0);
   signal append_byte_size    : std_logic_vector(7 downto 0);

--===============--
-- SYNC
--===============--
  signal sync_25, sync_6 : std_logic;

--===============--
-- CODEC
--===============--

  signal codec_status, codec_status1, codec_status2  : std_logic_vector(10 downto 0);
  signal codec_ctr, codec_ctr1 ,codec_ctr2           : std_logic_vector(7 downto 0); --:= "00000" & "011";
  signal codec_rst         : std_logic := '1';
  signal codec_rst_global, codec_rst_global1, codec_rst_global2: std_logic;
  signal codec_loopback    : std_logic;

-- Tx clock div
  signal codec_txdivcnt  : std_logic_vector(7 downto 0) ;

-- Input TC
  signal tick_in     : std_logic    := '0';
  signal ctrl_in     : std_logic_vector(1 downto 0) := (others => '0');
  signal time_in, time_in1, time_in2     : std_logic_vector(5 downto 0) := (others => '0');

-- Output TC
  signal tick_out    : std_logic;
  signal ctrl_out    : std_logic_vector(1 downto 0);
  signal time_out    : std_logic_vector(5 downto 0);

--------------------
-- Timecode
--------------------
  signal Tim_nwrite      : std_logic;
  signal tim_nwrite_fifo : std_logic;
  signal Tim_data        : std_logic_vector(7 downto 0);
  signal timecode_enable : std_logic;

  -- timecode SM 
  type t_s is ( enable,  wait_sync);
  signal timecode_s  : t_s := wait_sync;

--====================--
-- Sinais internos SpW p/ Siulação ou Imple.
--====================--
  signal spw_si_int : std_logic;
  signal spw_so_int : std_logic;
  signal spw_di_int : std_logic;
  signal spw_do_int : std_logic;

  -- Receiver front-end implementation.
  signal s_rximpl:     spw_implementation_type := impl_generic;

  -- Transmitter implementation.
  signal s_tximpl:     spw_implementation_type := impl_generic;


-----------------------------------------
-- Estrutural
-----------------------------------------
begin
 
 --====================--
 -- CLOCKs
 --====================--
     
 --======================--
 --  Sync
 --======================--
 sync_25 <= sync(1);
 sync_6  <= sync(0);


 --====================--
 -- loopback mode 
 --====================--

 process(codec_loopback, spw_so_int, spw_do_int, spw_si, spw_di) 
 begin
  if(codec_loopback = '1') then
      spw_si_int        <= spw_so_int; 
      spw_di_int        <= spw_do_int;
      spw_do            <= '0';
      spw_so            <= '0';
  else
      spw_si_int        <= spw_si;
      spw_di_int        <= spw_di;
      spw_so            <= spw_so_int;
      spw_do            <= spw_do_int;
  end if;
 end process;


 spw_fifo_r_read <= '1'      when (codec_loopback = '1') else
                    spw_fifo_r_read_READ;

 
 --====================--
 --  TimeCode Send
 --====================--
 process(codec_clk)
 begin
    if(rising_edge(codec_clk)) then 
        case timecode_s is
          when wait_sync =>
             if(timecode_enable = '1') then
                 tick_in    <= '0';
                 if( (sync_6 or sync_25) = '1') then
                    timecode_s <= enable;
                    tick_in    <= '1';
                 else
                    timecode_s <= wait_sync;
                 end if;
             else
                 timecode_s <= wait_sync;
             end if;

          when enable => 
             tick_in <= '0';

             -- Avoid to send more than one TC per sync pulse
             if( (sync_6 or sync_25) = '1') then
                 timecode_s <= enable;
             else
                 timecode_s <= wait_sync;
             end if;

          when others =>
             timecode_s <= wait_sync;

        end case;
    end if;
 end process;

 time_in2 <= sync_counter(5 downto 0);
 ctrl_in <= (others => '0');

 --====================--
 --  AVALON TRANSLATE
 --====================--

 -------------------------------
 -- Reg. Memória Geral
 -------------------------------
 reg_address(7 DOWNTO 0)     <= avs_s0_address(7 downto 0);      -- Endereçamento
 reg_address(8)              <= '0';

 -- Remapear a memoria e usar os 32 bits alinhados
 reg_dout        <= avs_s0_writedata;    -- Dado proviniente do Avalon

 reg_read        <= avs_s0_read;         -- Read, 2 ciclos de latência
 reg_write       <= avs_s0_write;        -- Write

 avs_s0_waitrequest <= '0';             -- Controle de fluxo, não utilizado
 avs_s0_readdata    <= reg_din;         -- Dado proviniente da memória

 -------------------------------
 -- DC FIFO
 -------------------------------
 -- Precisamos mapear as informações de Write used e Read Used para a memoria geral
 -- com isso o processador consegue verificar como anda o carregamento/descarregamento
 -- da FIFO 
 -- Acho que essa fifo não precisar retornar nada na leitura (talvez só um número
 -- que corresponda ao bloco)

 dc_data         <= avs_s1_writedata;
 dc_write        <= avs_s1_write;

 -- Wait request for burst transfer
 avs_s1_waitrequest              <= dc_waitrequest;

 -------------------------------
 -- Interruption
 -------------------------------

 -------------------------------------------------------------------------------
 -- Memoria Gera
 -------------------------------------------------------------------------------
 Reg : entity REG_Geral
   port map (

     ---------------------------------------------------------------------------
     -- Global
     ---------------------------------------------------------------------------

     clock             => avalon_clk,
     aclr              => Reset,
     Enable_SnapShotHK => '0',

     ---------------------------------------------------------------------------
     -- Escrita
     ---------------------------------------------------------------------------

     -- atualizacao realizada pelo link 1 SPW
     data_in_RMAP    => reader_memory_write_data,
     en_data_in_RMAP => reader_memory_write_enable,
     addr_in_RMAP    => reader_memory_write_addr(8 downto 0), -- TODO: Verificar

    -- -- Acesso aos registradores via Avalon
     data_in_AVALON    => reg_dout,
     en_data_in_AVALON => reg_write,
     addr_in_AVALON    => reg_address,

     ---------------------------------------------------------------------------
     -- Blocos apenas de Leitura
     ---------------------------------------------------------------------------

     -- Para bloco Read RMAP link 1
     en_data_out_RMAP  	=> reader_memory_read_enable,
     addr_out_RMAP     	=> reader_memory_read_addr,
     data_ready_RMAP   	=> reader_memory_read_data_ready,
     data_out_RMAP 		=> reader_memory_read_data,

     -- Acesso aos registradores via Avalon
     -- um ciclo de delay na leitura
     en_data_out_AVALON => reg_read,
     data_out_AVALON	=> reg_din,

     -- Append bytes on databody
     append_byte_size    => append_byte_size,
     append_read_en      => append_read_en,  
     append_read_addr    => append_read_addr,  
     append_read_data    => append_read_data, 
     
     ---------------------------------------------------------------------------
     -- Mapeamento direto para os cabecalho do link1
     ---------------------------------------------------------------------------

     -- head write (link 1)
     Phy_lenght_head_write1     => head_config_fisical_length,
     Phy_addrMSB_head_write1    => head_config_target_fisical_addr(15 downto 8),
     Phy_addrLSB_head_write1    => head_config_target_fisical_addr(7 downto 0),
     Logic_addr_head_write1     => head_config_target_logical,
     Key_head_write1            => head_config_key,
     InitLogic_addr_head_write1 => head_config_initiator_logical_addr,
     Addr_step_data_head_write1 => head_config_address_step,
     Extended_addr_head_write1  => head_config_addr_extend ,
     Addr_field3_head_write1    => head_config_addr3,
     Addr_field2_head_write1    => head_config_addr2,
     Addr_field1_head_write1    => head_config_addr1,
     Addr_field0_head_write1    => head_config_addr0,
     Data_lenght2_head_write1   => head_config_length2,
     Data_lenght1_head_write1   => head_config_length1,
     Data_lenght0_head_write1   => head_config_length0,

     -- head write HOUSE KEEPING (link 1)
     Phy_lenght_HK1     => hk_config_fisical_length,
     Phy_addrMSB_HK1    => hk_config_target_fisical_addr(15 downto 8),
     Phy_addrLSB_HK1    => hk_config_target_fisical_addr(7 downto 0),
     Logic_addr_HK1     => hk_config_target_logical ,
     Key_HK1            => hk_config_key,
     InitLogic_HK1      => hk_config_initiator_logical_addr,
     Addr_step_data_HK1 => hk_config_address_step,
     Extended_addr_HK1  => hk_config_addr_extend,
     Addr_field3_HK1    => hk_config_addr3,
     Addr_field2_HK1    => hk_config_addr2,
     Addr_field1_HK1    => hk_config_addr1,
     Addr_field0_HK1    => hk_config_addr0,
     Data_lenght2_HK1   => hk_config_length2,
     Data_lenght1_HK1   => hk_config_length1,
     Data_lenght0_HK1   => hk_config_length0,

     -- bloco de leitura (link 1)
     Phy_length_Read1  => reader_config_fisical_addr_size,
     Phy_addrMSB_Read1 => reader_config_target_fisical_addr(15 downto 8),
     Phy_addrLSB_Read1 => reader_config_target_fisical_addr(7 downto 0),
     Logic_addr_read1  => reader_config_logical_addr,
     Key_read1         => reader_config_key,

     -- Patern Bloco (link1) Sync

     ---------------------------------------------------------------------------
     -- Parametros Simulador
     ---------------------------------------------------------------------------

     Operation_global    => Operation_global,
     Operation_service   => Operation_service,
     Operation_running   => Operation_running,
     Operation_CRC_fault => Operation_CRC_fault,
     Operation_sync      => Operation_sync,

     Operation_Start_Stop    => Operation_Start_Stop_signal,
     Operation_Pause_Resume  => Operation_Pause_Resume_signal,
     Operation_Reset_Pattern => Operation_Reset_Pattern_signal,
     Operation_Spill         => Operation_Spill_on_signal,

     ---------------------------------------------------------------------------
     -- DC FIFO
     ---------------------------------------------------------------------------
     DC_FIFO_wrfull   => dc_waitrequest,
     DC_FIFO_wrusedw  => dc_wrusedw,
     DC_FIFO_rdempty  => dc_rdempty,
     DC_FIFO_rdusedw  => dc_rdusedw,
       
     -- Configura o RST da DC-FIFO (25/3/2015)
     DC_FIFO_rst      => DC_FIFO_rst,
     DC_FIFO_auto_rst => DC_FIFO_auto_rst,

     ---------------------------------------------------------------------------
     -- Config CODEC
     ---------------------------------------------------------------------------
     codec_status  => codec_status,
     codec_ctr     => codec_ctr2,
     codec_txdivcnt=> codec_txdivcnt,
     codec_rst     => codec_rst,
     codec_loopback=> codec_loopback,

     ---------------------------------------------------------------------------
     -- Synchronism
     ---------------------------------------------------------------------------
     sync_timer   => sync_timer,
     sync_counter => sync_counter,

     ---------------------------------------------------------------------------
     -- Timecode Enable
     ---------------------------------------------------------------------------
     timecode_enable => timecode_enable,

     ---------------------------------------------------------------------------
     -- CCD Descriptions
     ---------------------------------------------------------------------------
     ADC_delay_10ns => ADC_delay_10ns_signal,

     Pre_Scan_px   => Pre_Scan_px_signal,
     Smearing_rows => Smearing_rows_signal,

     line_transfer_time => line_transfer_time_signal,
     COLS_PIX           => Cols_PIX_signal,
     Lin_PIX            => Lin_PIX_signal

     );

 -------------------------------------------------------------------------------
 -- RMAP
 -------------------------------------------------------------------------------
   RMAP : entity rmapSpWTopLevel
     generic map(
       -- RMAP READ REPLY --
       memory_length    => memory_length,
       hk_start_address => hk_start_address,
       hk_end_address   => hk_end_address,

       -- Data body Charge
       Link_side_CCD => 0,               -- LEFT
       QTD_HK        => 12,
       -- Autonomus fifo
       data_width    => 9
       )
     port map(
       sysclk	=> avalon_clk,
       rst      => Reset,

       Sync_6           => Sync_6,
       Sync_25          => Sync_25,
       CCD_number_in    => sync_counter(1 downto 0),
       CCD_en_update_in => ccd_enable,

 -------------------------------------------------------------------------------
 -- Controlador RMAP_SPW
 -------------------------------------------------------------------------------

       Acesso_a_Memoria       => '1',
       Transmissao_finalizada => ins_irq0_irq,

       conf_Modo_OP_geral   => Operation_global,
       conf_Modo_OP_Running => Operation_running,

       Cols_PIX            => Cols_PIX_signal,
       Lin_PIX             => Lin_PIX_signal,
       Line_transfer_delay => line_transfer_time_signal,

       Pre_Scan_px   => Pre_Scan_px_signal,
       Smearing_rows => Smearing_rows_signal,

 -------------------------------------------------------------------------------
 -- RMAP READ REPLY
 -------------------------------------------------------------------------------

 -- Data recovered information

       reader_read_op_out      => open,
       reader_write_op_out     => open,
       reader_data_length_out  => open,
       reader_data_address_out => open,

 -- Erros

       erro_early_eop_out                  => open,
       erro_eep_out                        => open,
       erro_eep_data_out                   => open,
       erro_unsed_rmap_type_out            => open,
       erro_rmap_comd_not_impl_auto_out    => open,
       erro_invalid_header_crc_out         => open,
       erro_invalid_key_out                => open,
       erro_invalid_target_logical_add_out => open,
       erro_invalid_data_crc_out           => open,
       erro_verify_buffer_overrun_out      => open,
       erro_too_much_data_out              => open,
       erro_insufficient_data_out          => open,
       erro_address_out_of_range_out       => open,

 -- Read Autonomus SpW fifo
       
       spw_fifo_r_dout  => spw_fifo_r_dout,
       spw_fifo_r_empty => spw_fifo_r_empty,
       spw_fifo_r_read  => spw_fifo_r_read_READ,

 -- Configurations  READER

       reader_config_key_in                 => reader_config_key,
       reader_config_logical_addr_in        => reader_config_logical_addr,
       reader_config_target_fisical_addr_in => reader_config_target_fisical_addr,
       reader_config_fisical_addr_size_in   => reader_config_fisical_addr_size,

 -- Memory

       -- Read
       reader_memory_read_enable_out    => reader_memory_read_enable,
       reader_memory_read_addr_out      => reader_memory_read_addr,
       reader_memory_read_data_ready_in => reader_memory_read_data_ready,
       reader_memory_read_data_in       => reader_memory_read_data,

       --Write
       reader_memory_write_addr_out   => reader_memory_write_addr,
       reader_memory_write_data_out   => reader_memory_write_data,
       reader_memory_write_enable_out => reader_memory_write_enable,


 -------------------------------------------------------------------------------
 -- HEAD
 -------------------------------------------------------------------------------

       -- sinais do sub_controlador
       head_error_mode_in => Operation_CRC_fault,

       -- Configurations
       head_config_address_step_in           => head_config_address_step,
       head_config_fisical_length_in         => head_config_fisical_length,
       head_config_target_fisical_addr_in    => head_config_target_fisical_addr,
       head_config_target_logical_in         => head_config_target_logical,
       head_config_key_in                    => head_config_key,
       head_config_reply_addr_in             => head_config_reply_addr,
       head_config_initiator_logical_addr_in => head_config_initiator_logical_addr,
       head_config_addr_extend_in            => head_config_addr_extend,
       head_config_addr3_in                  => head_config_addr3,
       head_config_addr2_in                  => head_config_addr2,
       head_config_addr1_in                  => head_config_addr1,
       head_config_addr0_in                  => head_config_addr0,
       head_config_length2_in                => head_config_length2,
       head_config_length1_in                => head_config_length1,
       head_config_length0_in                => head_config_length0,

 -------------------------------------------------------------------------------
 -- CHARGE DATA BODY
 -- DC FIFO 32b -> 8b
 -------------------------------------------------------------------------------
       DC_FIFO_wclock   => avalon_clk,
       DC_FIFO_rclock   => avalon_clk,
       DC_FIFO_wrreq    => dc_write,
       DC_FIFO_data     => dc_data,
       DC_FIFO_wrfull   => dc_waitrequest,
       DC_FIFO_wrusedw  => dc_wrusedw,
       DC_FIFO_rdempty  => dc_rdempty,
       DC_FIFO_rdusedw  => dc_rdusedw,

       -- Configura o RST da DC-FIFO (25/3/2015)
       DC_FIFO_rst      => DC_FIFO_rst,
       DC_FIFO_auto_rst => DC_FIFO_auto_rst,
      
       append_byte_size    => append_byte_size, 
       append_read_en       => append_read_en ,  
       append_read_addr    => append_read_addr,  
       append_read_data    => append_read_data, 

 -------------------------------------------------------------------------------
 -- charge erro ?
-------------------------------------------------------------------------------
       -- sinais do sub_controlador
       -- TODO Esse sinal já nao interessa ?
       charge_error_mode_in => '0',

 -------------------------------------------------------------------------------
 -- Autonomus FIFO Write
 -------------------------------------------------------------------------------

       autonomous_w_empty => autonomous_w_empty,
       autonomous_w_nread => autonomous_w_nread,
       autonomous_w_dout  => autonomous_w_dout,

       fifo_w_full_out => open
   );

 -------------------------------------------------------------------------------
 -- Sync Chain 
 -- diferent clock domain, syncronization by
 -- resampling
 -------------------------------------------------------------------------------

-- CODEC to Avalon 
process(avalon_clk)
begin
    if(rising_edge(avalon_clk)) then
        if(reset = '1') then
            codec_status  <= (others => '0');
            codec_status1 <= (others => '0');
        else
            codec_status1 <= codec_status2;
            codec_status  <= codec_status1;
        end if;
    end if;
end process;

-- Avalon to CODEC
process(codec_clk)
begin
    if(rising_edge(codec_clk)) then
        if(reset = '1') then
            codec_ctr  <= (others => '0');
            codec_ctr1 <= (others => '0');

            time_in    <= (others => '0');
            time_in1   <= (others => '0');

            codec_rst_global  <= '0';
            codec_rst_global1 <= '0';
        else
            codec_ctr1 <= codec_ctr2;
            codec_ctr  <= codec_ctr1;
            
            time_in1 <= time_in2;
            time_in  <= time_in1;

            codec_rst_global1 <=  codec_rst_global2;
            codec_rst_global  <=  codec_rst_global1;
        end if;
    end if;
end process;

 --======================--
 --  Codec + Controller
 --======================--
   
   codec_rst_global2 <= Reset OR codec_rst;


   codecC : entity Codec_Controller
 	generic map(
         sysfreq  	        => 200_000_000.0,    -- Hz
         txclkfreq          => 200_000_000.0,    -- Hz

         rximpl             => impl_generic,   
         rxchunk            => 1, 
         tximpl             => impl_generic,  

         rxfifosize_bits	=> 11,
         txfifosize_bits	=> 4
            )
    port map(

         -- Global
         clk_codec  => codec_clk,
	     clk_avalon => avalon_clk,         
         MainReset	=> codec_rst_global,

         -- Synchronous reset Sync FIFO (active-high).
         rst_fifo   => DC_FIFO_rst,

         -- Sinais externos LVDS
         spw_si      => spw_si_int, --_tb,
         spw_so 	 => spw_so_int, --_tb,
         spw_di      => spw_di_int, --_tb,
         spw_do	     => spw_do_int, --_tb,

         -- Status CODEC + controller
         codec_status => codec_status2,
         codec_ctr    => codec_ctr,
         txdivcnt     => codec_txdivcnt,

         -- ADC rate in 0.01 ns
         ADC_DELAY   => ADC_delay_10ns_signal,

         -- Input TC
         tick_in     => tick_in,
         ctrl_in     => ctrl_in,
         time_in     => time_in,

         -- Output TC
         tick_out   => tick_out,
         ctrl_out   => ctrl_out,
         time_out   => time_out,

         -- Output FIFO Write
         nwrite     => autonomous_w_empty,
         full       => autonomous_w_nread,
         din        => autonomous_w_dout,

         -- Input FIFO READ
         spw_fifo_r_dout   => spw_fifo_r_dout,
         spw_fifo_r_empty  => spw_fifo_r_empty,
         spw_fifo_r_read   => spw_fifo_r_read
     );




end architecture rtl; -- of RMAP_SPW
