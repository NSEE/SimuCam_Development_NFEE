--Núcleo de Sistemas Embarcados - Instituto Mauá de Tecnologia
--projeto: Simulador FEE
--nome do programa: 
--finalidade: Finalidade do programa
--versão: 1.0
--autor: Tiago Sanches da Silva
--                 <tiago.eem@gmail.com>
--data: 12-07-11

-- WARNIG WARNING
-- O phisical logical adress não deve entrar no CRC!!!!! isto ainda deve ser implementado


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity HeadLogic is
  port
    (
      aclr            : in  std_logic;
      clock           : in  std_logic;
      FreeToTransmit  : in  std_logic;
      Sync            : in  std_logic;
      transmit_done   : out std_logic;
      Idle_SubControl : out std_logic;


      -- interface com o HeadRmap
      enable_data_head   : out std_logic;
      head_eof           : in  std_logic;
      reset_address_head : out std_logic;
      head_idle          : in  std_logic;
      head_data_ready    : in  std_logic;
      head_crc_en        : in  std_logic;

      --interface com CRC
      idle_CRC            : in  std_logic;
      enable_ler_data_CRC : out std_logic;
      get_crc             : out std_logic;
      CRC_ready           : in  std_logic;
      CRC_clear           : out std_logic;

      --interface SPW_autonomus_FIFO
      nwrite_acFifo : out std_logic;
      full_acFifo   : in  std_logic;

      --interface demux. Este demutiplexador se faz necessario pois o crc e o HeadRamp precisam acessar a fifo do SPW
      Demux_HeadCRC : out std_logic  -- 0:Head transmitindo; 1: CRC Transmitindo     

      );
end HeadLogic;


architecture rtl of HeadLogic is
  --maquina de estados para transmissão dos dados
  type stateatransm_type is (
                             SelecionarOp,
                             EnabModoOP,
                             Envio1,
                             Envio2,
                             FirstStepCRC,
                             Lost_clock,
                             SecStepCRC,
                             TirStepCRC,
                             Finalizar
                             );
  signal state_transmit : stateatransm_type := SelecionarOp;
begin

  process(clock, aclr)
  begin
    if (aclr = '1') then

      transmit_done       <= '0';
      CRC_clear           <= '0';
      get_crc             <= '0';
      reset_address_head  <= '0';
      Demux_HeadCRC       <= '0';
      Idle_SubControl     <= '0';
      enable_ler_data_CRC <= '0';
      enable_data_head    <= '0';
      nwrite_acFifo       <= '1';
      
    elsif (rising_edge(clock)) then
      
      if (Sync = '1') then
        reset_address_head <= '1';
      else
        reset_address_head <= '0';
        case state_transmit is
          when SelecionarOp =>
            
            if FreeToTransmit = '1' then
              state_transmit      <= EnabModoOP;
              enable_ler_data_CRC <= '0';
              nwrite_acFifo       <= '1';  --desabilitado em 0
              Demux_HeadCRC       <= '0';  -- passando para o demux para headRmap
              Idle_SubControl     <= '0';
              CRC_clear           <= '1';  --limpand o buffer do crc
              get_crc             <= '0';
            else
              Idle_SubControl <= '1';
            end if;

          -- mudar de operaçao não gasta nenhum clock(Corsi)
          when EnabModoOP =>
            CRC_clear      <= '0';
            state_transmit <= Envio1;

          when Envio1 =>
            enable_ler_data_CRC <= '0';
            nwrite_acFifo       <= '1';  -- 1,desabilita    
            
            -- se o CRC estiver idle, o head tambem e a fifo não tiver cheia, então dado é enviado
            if(head_eof = '1') then
              state_transmit   <= FirstStepCRC;
              enable_data_head <= '0';
            elsif((idle_CRC = '1') and (head_idle = '1') and (full_acFifo = '0')) then
              enable_data_head <= '1';
              state_transmit   <= Envio2;

             -- if(head_crc_en = '1') then
             --  enable_ler_data_CRC <= '1';  -- Habilitar a leitura do CRC
             -- else
                enable_ler_data_CRC <= '0';  -- Habilitar a leitura do CRC
             -- end if;

            else
              enable_data_head <= '0';
              state_transmit   <= Envio1;
            end if;

          when Envio2 =>
            if (head_data_ready = '1') then
              enable_data_head <= '0';
              nwrite_acFifo       <= '0';  -- 0,habilita
              
              if(head_crc_en = '1') then
                enable_ler_data_CRC <= '1';  -- Habilitar a leitura do CRC
              else
                enable_ler_data_CRC <= '0';  -- Habilitar a leitura do CRC
              end if;

              if (head_eof = '1') then  -- já transmitiu todo cabeçalho
                state_transmit   <= FirstStepCRC;
              else   
                enable_data_head <= '0';
                state_transmit <= Envio1;
              end if;
              
            else
              enable_ler_data_CRC <= '0';
              nwrite_acFifo       <= '1';  -- 1,desabilita        
              state_transmit      <= Envio2;
            end if;
            
          when FirstStepCRC =>
            
            enable_ler_data_CRC <= '0';
            nwrite_acFifo       <= '1';
            state_transmit      <= Lost_clock;
            
          when Lost_clock =>
                                        --Precisa Fazer: mudar o demux para CRC
            Demux_HeadCRC <= '1';
            get_crc       <= '0';
            if (idle_CRC = '1') then
              get_crc        <= '1';
              state_transmit <= SecStepCRC;
            elsif (idle_CRC = '0') then
              get_crc <= '0';
            end if;
            
          when SecStepCRC =>
            
            get_crc <= '0';
            if (CRC_Ready = '1') then
              state_transmit <= TirStepCRC;
            elsif (CRC_Ready = '0') then
              state_transmit <= SecStepCRC;
            end if;
            
          when TirStepCRC =>
            
            if (full_acFifo = '0') then
              state_transmit <= Finalizar;
              nwrite_acFifo  <= '0';
              transmit_done  <= '1';
            elsif (full_acFifo = '1') then
              nwrite_acFifo <= '1';     -- 1,desabilita     
              transmit_done <= '0';
            end if;

          when Finalizar =>
            
            nwrite_acFifo   <= '1';     -- 1,desabilita        
            transmit_done   <= '0';
            Idle_SubControl <= '1';
            state_transmit  <= SelecionarOp;
        end case;
        
      end if;
      
    end if;
    
  end process;


end rtl;
