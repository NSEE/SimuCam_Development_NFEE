--Núcleo de Sistemas Embarcados - Instituto Mauá de Tecnologia
--projeto: Simulador FEE
--nome do programa: 
--finalidade: Finalidade do programa
--versão: 1.0
--autor: Tiago Sanches da Silva
--                 <tiago.eem@gmail.com>
--data: 04-08-11


library ieee;
use ieee.std_logic_1164.all;
use work.all;

entity HeadTopHK is
  generic
    (
      QTD_HK : natural range 0 to 127 := 64
      );

  port
    (
      aclr  : in std_logic;
      clock : in std_logic;

      DataOut_9b        : out std_logic_vector(8 downto 0);
      freeToTransmit_Tr : in  std_logic;
      Error_Mode_in     : in  std_logic;  -- calcula CRC errado
      head_sync_reset   : in  std_logic;

      --interface SPW_autonomus_FIFO
      nwrite_acFifo : out std_logic;
      full_acFifo   : in  std_logic;

      -- interface do Controlador externo com o CCD_Identify
      -- (00,01,10,11)
      --        ( 1, 2, 3, 4)
      -- será atualizada pelo bloco de timeCode
      CCD_number     : in std_logic_vector(1 downto 0);
      en_update_CCDi : in std_logic;

      --interface do controlador externo para o SubControl HK
      Sync            : in  std_logic;  -- quando vier o sync os endereços de envio são reiniciados
      transmit_done   : out std_logic;
      Idle_SubControl : out std_logic;

      -- interface com o Bloco HK SnapShot (central)
      en_data_out_HK : out std_logic;   -- enable read
      addr_out_HK    : out std_logic_vector(6 downto 0);
      data_ready_HK  : in  std_logic;
      data_HK        : in  std_logic_vector(7 downto 0);

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
      config_length0_in                : in std_logic_vector(7 downto 0)

      );
end HeadTopHK;


architecture rtl of HeadTopHK is

-- Sub_Control_HK -> Mux_head_CCDi_HK
  signal MUX_head_CCDi_HK_signal : std_logic_vector(1 downto 0);

-- Mux_head_CCDi_HK -> MUX_ALL_CRC
  signal data_inter_Mux_signal : std_logic_vector(7 downto 0);

-- Para Mux_head_CCDi_HK
  signal Data_Head_signal : std_logic_vector(7 downto 0);
  signal Data_CCDi_signal : std_logic_vector(7 downto 0);

-- CRC -> MUX_ALL_CRC1
  signal Data_CRC_signal    : std_logic_vector(7 downto 0);
-- Sub_Control_HK -> MUX_ALL_CRC1 
  signal MUX_ALL_CRC_signal : std_logic_vector(1 downto 0);
-- Sub_Control_HK -> MUX_ALL_CRC1 

-- CCDi -> Sub_Control_HK
  signal en_data_signal       : std_logic;

-- Sub_Control_HK -> CRC
  signal Clear_crc_signal  : std_logic;
  signal enable_crc_signal : std_logic;
  signal idel_crc_signal   : std_logic;
  signal ready_crc_signal  : std_logic;
  signal get_crc_signal    : std_logic;

  signal head_eof_signal                              : std_logic;
  signal enable_data_head_signal                      : std_logic;
  signal reset_address_head_signal                    : std_logic;
  signal head_idle_signal                             : std_logic;
  signal head_data_ready_signal                       : std_logic;
  signal data_out_head_signal, data_out_head_L_signal : std_logic_vector(7 downto 0);


  signal reset_CRC : std_logic;

  signal head_crc_en_signal : std_logic;
begin

  HeadMuxHK0 : entity HeadMuxHk 
    port map
    (
      clock => clock,

      channel   => MUX_head_CCDi_HK_signal,  -- 00: Head; 01:CCDi; 10: SnapShot HK; 11:erro-> saida "01010101"
      data_Head => data_out_head_signal,
      data_CCdi => Data_CCDi_signal,
      data_HK   => data_HK,
      data_out  => data_inter_Mux_signal
      );

  MUX_ALL_CRC1_instH0 : entity MUX_ALL_CRC1
    port map
    (
  --    clock => clock,

      ALL_or_CRC_EEP_EOP => MUX_ALL_CRC_signal,  --(00: ALL; 01:CRC; 10:EEP; 11:EOP)
      Error_Mode         => Error_Mode_in,
      data_ALL_in        => data_inter_Mux_signal,
      data_CRC_in        => Data_CRC_signal,
      data_OUT           => DataOut_9b
      );

  CCD_identify_Top_instH0 : entity CCD_identify_Top
    port map
    (
      clock      => clock,
      aclr       => aclr,
      -- (00,01,10,11)
      --        ( 1, 2, 3, 4)
      -- será atualizada pelo bloco de timeCode
      CCD_number => CCD_number,
      en_update  => en_update_CCDi,

      -- transmitido pelo bloco HK
      en_data       => en_data_signal,
      data_out      => Data_CCDi_signal
      );

  reset_CRC <= aclr or Clear_crc_signal;

  Modulo_crc_top_instH0 : entity Modulo_crc_top
    port map
    (
      clock           => clock,
      clear           => reset_CRC,
      enable_ler_data => enable_crc_signal,
      get_crc         => get_crc_signal,
      data_in         => data_inter_Mux_signal,
      CRC_out         => Data_CRC_signal,
      idle            => idel_crc_signal,
      CRC_ready       => ready_crc_signal
      );        

  head_write_instH0 : entity head_write
    port map
    (
      clk                     => clock,
      reset                   => aclr,
      enable_to_transmit_Byte => enable_data_head_signal,
      sync_reset              => head_sync_reset,

      ------------------------------------------------------------------------------
      -- Parametros do cabeçalho
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

      reset_address_in    => reset_address_head_signal,
      head_data_out       => data_out_head_signal,
      head_idle_out       => head_idle_signal,
      head_eof_out        => head_eof_signal,
      head_crc_en         => head_crc_en_signal,
      head_data_ready_out => head_data_ready_signal
      );        


  HeadLogicHK0 : entity HeadLogicHK
    generic map
    (
      QTD_HK => QTD_HK
      )
    port map
    (
      aclr  => aclr,
      clock => clock,

      FreeToTransmit  => freeToTransmit_Tr,
      Sync            => Sync,  -- quando vier o sync os endereços de envio são reiniciados
      transmit_done   => transmit_done,
      Idle_SubControl => Idle_SubControl,


      -- interface com o Head HK
      head_eof            => head_eof_signal,
      enable_data_head    => enable_data_head_signal,
      reset_address_head  => reset_address_head_signal,
      head_idle           => head_idle_signal,
      head_data_ready     => head_data_ready_signal,
      --interface com CRC
      idle_CRC            => idel_crc_signal,
      enable_ler_data_CRC => enable_CRC_signal,
      get_crc             => get_crc_signal,
      CRC_ready           => ready_crc_signal,
      CRC_clear           => Clear_crc_signal,
      --interface SPW_autonomus_FIFO
      nwrite_acFifo       => nwrite_acFifo,
      full_acFifo         => full_acFifo,
      --interface com CCD_Identify
      en_data_CCDi        => en_data_signal,
      --interface com SnapShot HK
      en_data_HK          => en_data_out_HK,      -- enable read
      addr_HK             => addr_out_HK,
      data_ready_HK       => data_ready_HK,
      --interface Mux_head_CCDi_HK
      Mux_head_CCDi_HK    => MUX_head_CCDi_HK_signal,  -- 00: Head; 01:CCDi; 10: SnapShot HK; 11:erro-> saida "01010101"
      -- interface MUX_CRC_ALL
      MUX_ALL_CRC         => MUX_ALL_CRC_signal        --       0:ALL ;1:CRC

      );

  

end rtl;
