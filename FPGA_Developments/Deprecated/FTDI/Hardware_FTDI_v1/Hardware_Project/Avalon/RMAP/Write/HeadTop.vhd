--Nucleo de Sistemas Embarcados - Instituto Maua de Tecnologia
--projeto: Simulador FEE
--nome do programa: 
--finalidade: Finalidade do programa
--versao: 1.0
--autor: Tiago Sanches da Silva
--                 <tiago.eem@gmail.com>
--data: 18-07-11
--
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
-- Adequaçao PLATO 2.0
--	tirar os registros de borda de descida 
--
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use std.standard.all;
use work.all;

entity HeadTop is
  port
    (
      aclr            : in  std_logic;
      clock           : in  std_logic;
      
      -- sinais do sub_controlador
      FreeToTransmit  : in  std_logic;
      Sync            : in  std_logic; 
      Error_Mode      : in  std_logic := '0';  --1: envia valor errado para o CRC; 0 error_mode desabilitado
      transmit_done   : out std_logic;
      Idle_SubControl : out std_logic; 

      head_sync_reset : in std_logic;


      config_address_step_in           : in std_logic_vector(31 downto 0);  -- Step for address
                                        -- update if 0 use data length
      config_fisical_length_in         : in std_logic_vector(1 downto 0);  -- fisical addres length
                                        -- 00=0,
                                        -- 01=1,
                                        -- 10=11= 2
      -- Fisical Target address, used when fisical_length_in /= 00
      config_target_fisical_addr_in    : in std_logic_vector(15 downto 0);
      -- Target Logical Address
      config_target_logical_in         : in std_logic_vector(7 downto 0);
      -- Key 
      config_key_in                    : in std_logic_vector(7 downto 0);
      -- Used when the SpW networ has fisical address
      config_reply_addr_in             : in std_logic_vector(15 downto 0);
      -- Initiator logical addr
      config_initiator_logical_addr_in : in std_logic_vector(7 downto 0);
      -- Extended Address
      config_addr_extend_in            : in std_logic_vector(7 downto 0);
      -- Address MS
      config_addr3_in                  : in std_logic_vector(7 downto 0);
      -- Address MSLS
      config_addr2_in                  : in std_logic_vector(7 downto 0);
      -- Address LSMS
      config_addr1_in                  : in std_logic_vector(7 downto 0);
      -- Address LS
      config_addr0_in                  : in std_logic_vector(7 downto 0);
      -- Data Length MS
      config_length2_in                : in std_logic_vector(7 downto 0);
      -- Data Length MSLS
      config_length1_in                : in std_logic_vector(7 downto 0);
      -- Data Length LS
      config_length0_in                : in std_logic_vector(7 downto 0);

      
      data_OUT  : out std_logic_vector(7 downto 0); 
      
      --sinais para o assincronous fifo conectado no SPW
      nwrite_ac : out std_logic;
      full_ac   : in  std_logic
      );
end HeadTop;


architecture uniao of HeadTop is

  signal head_eof_signal           : std_logic;
  signal reset_address_head_signal : std_logic;
  signal head_idle_signal          : std_logic;
  signal head_data_ready_signal    : std_logic;
  signal enable_data_head_signal   : std_logic;

  signal data_out_head_signal : std_logic_vector (7 downto 0);
  signal head_Error_signal    : std_logic_vector(3 downto 0);

  signal crc_idle_signal            : std_logic;
  signal enable_ler_data_CRC_signal : std_logic;
  signal get_crc_signal             : std_logic;
  signal CRC_ready_signal           : std_logic;
  signal CRC_clear_signal           : std_logic;
  signal CRC_clear_sub_signal       : std_logic;
  signal CRC_out_signal             : std_logic_vector(7 downto 0);

  signal Demux_HeadCRC_signal : std_logic;
  signal Demux_dataOUT_signal : std_logic_vector (7 downto 0);
  signal Error_Mode_signal    : std_logic;

  signal head_crc_en_signal : std_logic;
  
begin

  HeadLogic0 : entity HeadLogic
    port map (

      aclr            => aclr,
      clock           => clock,
      FreeToTransmit  => FreeToTransmit,
      Sync            => Sync,
      transmit_done   => transmit_done,
      Idle_SubControl => Idle_SubControl,


      -- interface com o HeadRmap
      head_eof           => head_eof_signal,
      reset_address_head => reset_address_head_signal,
      head_idle          => head_idle_signal,
      head_data_ready    => head_data_ready_signal,
      enable_data_head   => enable_data_head_signal,
      head_crc_en        => head_crc_en_signal,

      --interface com CRC
      idle_CRC            => crc_idle_signal,
      enable_ler_data_CRC => enable_ler_data_CRC_signal,
      get_crc             => get_crc_signal,
      CRC_ready           => CRC_ready_signal,
      CRC_clear           => CRC_clear_sub_signal,

      --interface SPW_autonomus_FIFO
      nwrite_acFifo => nwrite_ac,
      full_acFifo   => full_ac,

      --interface demux. Este demutiplexador se faz necessario pois o crc e o HeadRamp precisam acessar a fifo do SPW
      Demux_HeadCRC => Demux_HeadCRC_signal  -- 0:Head transmitindo; 1: CRC Transmitindo     

      );


  HeadMux0 : entity HeadMux 
    port map (
	clock	=>	clock,
	
      head_or_CRC  => Demux_HeadCRC_signal,  --(0: Head; 1:CRC)
      Error_Mode   => Error_Mode,
      data_head_in => data_out_head_signal,
      data_CRC_in  => CRC_out_signal,
      data_OUT     => data_OUT
      );        


  CRC_clear_signal <= aclr or CRC_clear_sub_signal;

  Modulo_crc_top_inst0 : entity Modulo_crc_top
    port map (

      clock           => clock,
      clear           => CRC_clear_signal,
      enable_ler_data => enable_ler_data_CRC_signal,
      get_crc         => get_crc_signal,
      data_in         => data_out_head_signal,
      CRC_out         => CRC_out_signal,
      idle            => crc_idle_signal,
      CRC_ready       => CRC_ready_signal

      );        

  head_write_inst0 : entity head_write
    port map (

      clk                     => clock,
      reset                   => aclr,
      enable_to_transmit_Byte => enable_data_head_signal,
      sync_reset              => head_sync_reset,

      ------------------------------------------------------------------------------
      -- Parametros do cabe�alho
      ------------------------------------------------------------------------------
      config_address_step_in           => config_address_step_in,
      config_fisical_length_in         => config_fisical_length_in,
      config_target_fisical_addr_in    => config_target_fisical_addr_in,
      -- Target Logical Address
      config_target_logical_in         => config_target_logical_in,
      -- Key 
      config_key_in                    => config_key_in,
      -- Used when the SpW networ has fisical address
      config_reply_addr_in             => config_reply_addr_in,
      -- Initiator logical addr
      config_initiator_logical_addr_in => config_initiator_logical_addr_in,
      -- Extended Address
      config_addr_extend_in            => config_addr_extend_in,
      -- Address MS
      config_addr3_in                  => config_addr3_in,
      -- Address MSLS
      config_addr2_in                  => config_addr2_in,
      -- Address LSMS
      config_addr1_in                  => config_addr1_in,
      -- Address LS
      config_addr0_in                  => config_addr0_in,
      -- Data Length MS
      config_length2_in                => config_length2_in,
      -- Data Length MSLS
      config_length1_in                => config_length1_in,
      -- Data Length LS
      config_length0_in                => config_length0_in,
      reset_address_in                 => reset_address_head_signal,
      head_data_out                    => data_out_head_signal,
      head_idle_out                    => head_idle_signal,
      head_eof_out                     => head_eof_signal,
      head_crc_en                      => head_crc_en_signal,
      head_data_ready_out              => head_data_ready_signal
      );


end uniao;
