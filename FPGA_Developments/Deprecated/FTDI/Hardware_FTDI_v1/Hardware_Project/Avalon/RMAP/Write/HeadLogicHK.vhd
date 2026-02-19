--N�cleo de Sistemas Embarcados - Instituto Mau� de Tecnologia
--projeto: Simulador FEE
--nome do programa:
--finalidade: Finalidade do programa
--vers�o: 1.0
--autor: Tiago Sanches da Silva
--                 <tiago.eem@gmail.com>
--data: 04-08-11


-- WARNIG WARNING
-- O phisical logical adress n�o deve entrar no CRC!!!!! isto ainda deve ser implementado

--este bloco precisa apenas de um pequeno pulso para come�ar a transmitir

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity HeadLogicHK is
  generic
    (
      QTD_HK : natural range 0 to 63
      );

  port
    (
      aclr  : in std_logic;
      clock : in std_logic;

      FreeToTransmit  : in  std_logic;
      Sync            : in  std_logic;  -- quando vier o sync os endere�os de envio s�o reiniciados
      transmit_done   : out std_logic;
      Idle_SubControl : out std_logic;

      -- interface com o Head HK
      head_eof           : in  std_logic;
      enable_data_head   : out std_logic;
      reset_address_head : out std_logic;
      head_idle          : in  std_logic;
      head_data_ready    : in  std_logic;

      --interface com CRC
      idle_CRC            : in  std_logic;
      CRC_ready           : in  std_logic;
      enable_ler_data_CRC : out std_logic;
      get_crc             : out std_logic;
      CRC_clear           : out std_logic;

      --interface SPW_autonomus_FIFO
      nwrite_acFifo : out std_logic;
      full_acFifo   : in  std_logic;

      --interface com CCD_Identify
      en_data_CCDi       : out std_logic;

      --interface com SnapShot HK
      en_data_HK    : out std_logic;    -- enable read
      addr_HK       : out std_logic_vector(6 downto 0);
      data_ready_HK : in  std_logic;
--              data_in_Sub_HK  :       in std_logic_vector(7 downto 0);


      --interface Mux_head_CCDi_HK
      Mux_head_CCDi_HK : out std_logic_vector(1 downto 0);  -- 00: Head; 01:CCDi; 10: SnapShot HK; 11:erro-> saida "01010101"

      -- interface MUX_CRC_ALL
      MUX_ALL_CRC : out std_logic_vector(1 downto 0)  --       0:ALL ;1:CRC

      );
end HeadLogicHK;


architecture rtl of HeadLogicHK is
--maquina de estados para transmiss�o dos dados
  type stateatransm_type is (
                             SelecionarOp,
                             EnabModoOP,
                             Envio1,
                             Envio2,
                             FirstStepCRC,
                             Lost_clock,
                             SecStepCRC,
                             TirStepCRC,
                             FinalizarCRC1,
                             PreparoCCDid,
                             CCDId_Spare1,
                             CCDId_number1,
                             CCDId_number2,
                             CCDid_MSBc1,
                             CCDid_MSBc2,
                             CCDid_LSBc1,
                             CCDid_LSBc2,
                             CCDid_End,
                             HK1,
                             HK2,
                             HK3,
                             Finalizar_HK,
                             Finalizar,
                             FirstStepCRC2,
                             Lost_clock2,
                             SecStepCRC2,
                             TirStepCRC2,
                             FinalizarCRC2,
                             Enviar_EOP,
                             Enviar_EOP2,
                             wait_clock,
                             going_to_SelecionarOp
                             );

  signal state_Transfer_All : stateatransm_type := SelecionarOp;

  signal data_in_signal     : std_logic_vector(7 downto 0);
  signal data_adress_signal : std_logic_vector(4 downto 0);

  signal addr_in_HK_signal : natural range 0 to 127;

begin


  process(clock, aclr)
    variable mod_OP : std_logic;
  begin
    if (aclr = '1') then

      transmit_done       <= '0';
      CRC_clear           <= '0';
      get_crc             <= '0';
      reset_address_head  <= '0';
      MUX_ALL_CRC         <= "00";
      Idle_SubControl     <= '0';
      enable_ler_data_CRC <= '0';
      enable_data_head    <= '0';
      nwrite_acFifo       <= '1';
      en_data_CCDi        <= '0';
      en_data_HK          <= '0';       -- enable read
      addr_HK             <= (others => '0');
      addr_in_HK_signal   <= 0;
      Mux_head_CCDi_HK    <= "00";  -- 00: Head; 01:CCDi; 10: SnapShot HK; 11:erro-> saida "01010101"
      MUX_ALL_CRC         <= "00";      --     0:CRC ; 1:ALL

    elsif (rising_edge(clock)) then

      if (Sync = '1') then
        reset_address_head <= '1';
      else
        reset_address_head <= '0';
        case state_Transfer_All is
          when SelecionarOp =>

            if (FreeToTransmit = '1') then
              state_Transfer_All  <= EnabModoOP;
              en_data_HK          <= '0';   -- enable read
              addr_HK             <= (others => '0');
              addr_in_HK_signal   <= 0;
              Mux_head_CCDi_HK    <= "00";  -- 00: Head; 01:CCDi; 10: SnapShot HK; 11:erro-> saida "01010101"
              MUX_ALL_CRC         <= "00";  --     ALL
              enable_ler_data_CRC <= '0';
              nwrite_acFifo       <= '1';   --desabilitado em 0
              Idle_SubControl     <= '0';   -- subcontrolador ocupado
              CRC_clear           <= '1';   --limpand o buffer do crc
              get_crc             <= '0';
              enable_data_head    <= '0';
            else
              Idle_SubControl <= '1';
            end if;

          when EnabModoOP =>

            CRC_clear          <= '0';
                                        -- mudar de opera�ao n�o gasta nenhum clock(Corsi)
            state_Transfer_All <= Envio1;

          when Envio1 =>
            enable_ler_data_CRC <= '0';
            nwrite_acFifo       <= '1';  -- 1,desabilita
                                   -- se o CRC estiver idle, o head tambem e a fifo n�o tiver cheia, ent�o data � enviado
            if ((idle_CRC = '1') and (full_acFifo = '0')) then
              enable_data_head   <= '1';
              state_Transfer_All <= Envio2;
            else
              enable_data_head <= '0';
            end if;

          when Envio2 =>
            enable_data_head <= '0';
            -- dado do head pronto
            if (head_data_ready = '1') then
              enable_ler_data_CRC <= '1';  -- Habilitar a leitura do CRC
              nwrite_acFifo       <= '0';  -- 0,habilita
              if (head_eof = '1') then     -- j� transmitiu todo cabe�alho
                state_Transfer_All <= FirstStepCRC;
              else
                state_Transfer_All <= Envio1;
              end if;
            else
              enable_ler_data_CRC <= '0';
              nwrite_acFifo       <= '1';  -- 1,desabilita
              state_Transfer_All  <= Envio2;
            end if;

          when FirstStepCRC =>
                                        --Precisa Fazer: mudar o mux para CRC
            get_crc             <= '0';
            enable_ler_data_CRC <= '0';
            nwrite_acFifo       <= '1';
            state_Transfer_All  <= Lost_clock;

          when Lost_clock =>
            MUX_ALL_CRC <= "01";        --CRC : 0
            if (idle_CRC = '1') then
              get_crc            <= '1';
              state_Transfer_All <= SecStepCRC;
            else
              get_crc            <= '0';
              state_Transfer_All <= Lost_clock;
            end if;

          when SecStepCRC =>
            get_crc <= '0';
            if (CRC_Ready = '1') then
              state_Transfer_All <= TirStepCRC;
            else
              state_Transfer_All <= SecStepCRC;
            end if;

          when TirStepCRC =>
            if (full_acFifo = '0') then
              nwrite_acFifo      <= '0';  --0: escreve na autonomous fifo
              state_Transfer_All <= FinalizarCRC1;
            else
              nwrite_acFifo      <= '1';  --0: escreve na autonomous fifo
              state_Transfer_All <= TirStepCRC;
            end if;

          when FinalizarCRC1 =>
            nwrite_acFifo      <= '1';  -- 1,desabilita
                                        --limpando o CRC
            CRC_clear          <= '1';  --limpand o buffer do crc
            state_Transfer_All <= PreparoCCDid;
          -- preparar para transmitir o CCD_identify
          when PreparoCCDid =>
            CRC_Clear        <= '0';
            MUX_ALL_CRC      <= "00";   -- multiplexando para ALL
            Mux_head_CCDi_HK <= "01";  -- passando para o mux para headHK

            state_Transfer_All <= CCDId_Spare1;

          when CCDId_Spare1 =>
                                           -- CCD_identify j� esta na primeira posi�ao
                                           -- ao dar enable ele vai para a segunda posi�ao da memoria
            if (full_acFifo = '0' and idle_CRC = '1') then
              nwrite_acFifo       <= '0';  -- 0: realiza a escrita
              enable_ler_data_CRC <= '1';
              state_Transfer_All  <= CCDId_number1;
            else
              state_Transfer_All <= CCDId_Spare1;
            end if;

          when CCDId_number1 =>
            nwrite_acFifo       <= '1';  -- 0: realiza a escrita
            enable_ler_data_CRC <= '0';

                                        -- 2 posi�ao do CCd_identify
            en_data_CCDi       <= '1';
            state_Transfer_All <= CCDId_number2;

          when CCDId_number2 =>
            en_data_CCDi <= '0';
            if (full_acFifo = '0' and idle_CRC = '1') then
              nwrite_acFifo       <= '0';  -- 0: realiza a escrita
              enable_ler_data_CRC <= '1';
              state_Transfer_All  <= CCDid_MSBc1;
            else
              state_Transfer_All <= CCDId_number2;
            end if;

          when CCDid_MSBc1 =>
            nwrite_acFifo       <= '1';  -- 0: realiza a escrita
            enable_ler_data_CRC <= '0';

                                        -- 3 posi�ao do CCd_identify
            en_data_CCDi       <= '1';
            state_Transfer_All <= CCDid_MSBc2;

          when CCDid_MSBc2 =>
            en_data_CCDi <= '0';
            if (full_acFifo = '0' and idle_CRC = '1') then
              nwrite_acFifo       <= '0';  -- 0: realiza a escrita
              enable_ler_data_CRC <= '1';
              state_Transfer_All  <= CCDid_LSBc1;
            else
              state_Transfer_All <= CCDid_MSBc2;
            end if;

          when CCDid_LSBc1 =>
            nwrite_acFifo       <= '1';  -- 0: realiza a escrita
            enable_ler_data_CRC <= '0';

                                        -- 4 posi�ao do CCd_identify
            en_data_CCDi       <= '1';
            state_Transfer_All <= CCDid_LSBc2;

          when CCDid_LSBc2 =>
                                           -- reiniciado do if
            --                                  en_data_idCCD <= '0';
            if (full_acFifo = '0' and idle_CRC = '1') then
              nwrite_acFifo       <= '0';  -- 0: realiza a escrita
              enable_ler_data_CRC <= '1';
              state_Transfer_All  <= CCDid_End;
              en_data_CCDi        <= '1';
            else
              state_Transfer_All <= CCDid_LSBc2;
              en_data_CCDi       <= '0';
            end if;

          when CCDid_End =>
            en_data_CCDi        <= '0';
            nwrite_acFifo       <= '1';  -- 0: realiza a escrita
            enable_ler_data_CRC <= '0';

            addr_in_HK_signal  <= 0;
            addr_HK            <= (others => '0');  -- endere�o do hk central
            state_Transfer_All <= HK1;

          when HK1 =>
            MUX_ALL_CRC         <= "00";  -- multiplexando para ALL
            Mux_head_CCDi_HK    <= "10";  -- passando hk
            enable_ler_data_CRC <= '0';
            nwrite_acFifo       <= '1';   -- enable em 0

            if (addr_in_HK_signal < QTD_HK) then
              en_data_HK         <= '1';
              state_Transfer_All <= HK2;
            else
                                        -- finalizar HK
              state_Transfer_All <= Finalizar_HK;
            end if;

          when HK2 =>
            en_data_HK <= '0';

            if (data_ready_HK = '1') then
              state_Transfer_All <= HK3;
              addr_in_HK_signal  <= addr_in_HK_signal + 1;
            else
              state_Transfer_All <= HK2;
            end if;

          when HK3 =>

            if ((full_acFifo = '0') and (idle_CRC = '1')) then
              enable_ler_data_CRC <= '1';
              nwrite_acFifo       <= '0';  -- enable em 0
              addr_HK             <= std_logic_vector(to_unsigned(addr_in_HK_signal, 7));
              state_Transfer_All  <= HK1;
            else
              state_Transfer_All <= HK3;
            end if;

          when Finalizar_HK =>
            en_data_HK        <= '0';
            addr_in_HK_signal <= 0;
            addr_HK           <= (others => '0');

            state_Transfer_All <= FirstStepCRC2;

          when FirstStepCRC2 =>
                                        -- voltando mux 1 para CCD_Ident
            Mux_head_CCDi_HK <= "00";
                                        -- multiplexando para CRC
            Mux_ALL_CRC      <= "01";

            get_crc             <= '0';
            enable_ler_data_CRC <= '0';
            nwrite_acFifo       <= '1';
            state_Transfer_All  <= Lost_clock2;

          when Lost_clock2 =>
            if (idle_CRC = '1') then
              get_crc            <= '1';
              state_Transfer_All <= SecStepCRC2;
            else
              get_crc            <= '0';
              state_Transfer_All <= Lost_clock2;
            end if;

          when SecStepCRC2 =>
            get_crc <= '0';
            if (CRC_Ready = '1') then
              state_Transfer_All <= TirStepCRC2;
            else
              state_Transfer_All <= SecStepCRC2;
            end if;

          when TirStepCRC2 =>
            if (full_acFifo = '0') then
              nwrite_acFifo      <= '0';  --0: escreve na autonomous fifo
              state_Transfer_All <= FinalizarCRC2;
            else
              nwrite_acFifo      <= '1';  --0: escreve na autonomous fifo
              state_Transfer_All <= TirStepCRC2;
            end if;

          when FinalizarCRC2 =>
            nwrite_acFifo      <= '1';  -- 1,desabilita
                                        --limpando o CRC
            CRC_clear          <= '1';  --limpand o buffer do crc
            state_Transfer_All <= Finalizar;

          when Finalizar =>
            state_Transfer_All <= Enviar_EOP;
                                        -- multiplexando para EOP
            Mux_ALL_CRC        <= "10";

          when Enviar_EOP =>
            nwrite_acFifo      <= '0';  --0: escreve na autonomous fifo
            state_Transfer_All <= Enviar_EOP2;

          when Enviar_EOP2 =>
            nwrite_acFifo      <= '1';  --0: escreve na autonomous fifo
            state_Transfer_All <= wait_clock;
            transmit_done      <= '1';

          when wait_clock =>
            transmit_done      <= '0';
            state_Transfer_All <= going_to_SelecionarOp;

          when going_to_SelecionarOp =>
                                        -- multiplexando para ALL
            Mux_ALL_CRC        <= "00";
            state_Transfer_All <= SelecionarOp;
            Idle_SubControl    <= '1';

        end case;
      end if;
    end if;

  end process;


end rtl;
