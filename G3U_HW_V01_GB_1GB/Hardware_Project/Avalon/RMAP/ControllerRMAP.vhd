--N�cleo de Sistemas Embarcados - Instituto Mau� de Tecnologia
--projeto: Simulador FEE
--nome do programa:
--finalidade: Finalidade do programa
--vers�o: 1.0
--autor: Tiago Sanches da Silva
--                 <tiago.eem@gmail.com>
--data: 30-08-11

-- controlador do Bloco SPW/RMAP Handling
-------------------------------------------------------------------------------
-- ======================
-- Modificacoes	- Corsi
-- ======================
-- PLATO 2.0 - set/2014
-------------------------------------------------------------------------------
--
---------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity ControllerRMAP is
  port
    (
      clock : in std_logic;
      aclr  : in std_logic;

      sync_6  : in std_logic;
      sync_25 : in std_logic;

      n_write_Control     : out std_logic;
      full_acfifo_Control : in  std_logic;
      Clear_SubControls   : out std_logic;

      -- interface com o controlador Geral
      Acesso_a_Memoria       : in  std_logic;
      Transmissao_finalizada : out std_logic;

      --interface com o Registrado geral
      conf_Modo_OP_geral   : in std_logic;                     -- is running
      conf_Modo_OP_Running : in std_logic_vector(1 downto 0);  --(00:StandBy;01:test;10:integration;11:Operational)

      -- controle do ca�alho de escrita
      -- interface com Sub_Control_Head
      Free_to_Transmit_tr_Head : out std_logic;
      transmit_done_Head       : in  std_logic;
      idle_SubControl_Head     : in  std_logic;

      -- controle do corpo do datagrama de escrita
      -- interface com DataBody_Charge_Control
      new_half_line_DataBody               : out std_logic;
      en_new_CCD_DataBody                  : out std_logic;
      one_link_mode_DataBody               : out std_logic;
      Free_to_AccessMemory_Charger         : out std_logic;
      Free_to_Transmit_DataBody            : out std_logic;
      Charge_HalfLine_Fifo_Done_DataBody   : in  std_logic;
      Critical_OP_Charger                  : in  std_logic;
      All_halfLine_Frame_sent_DataBody     : in  std_logic;
      End_CCD_charge_Fifo                  : in  std_logic;
      End_CCD_Transfer                     : in  std_logic;

      -- controle do bloco de leitura e Resposta do RMAP
      -- interface com RMAP_read_reply
      Free_to_transmit_Read_Reply    : out std_logic;
      request_to_transmit_Read_Reply : in  std_logic;
      enbale_Reader_HK               : out std_logic;
      enable_Reader                  : out std_logic;

      -- controle do bloco Patern
      patern_enable : out std_logic;

      Sel_DMux_nWrite_Data : out std_logic_vector(2 downto 0)  -- (000:Head;001:DataBody;010:HK;011:Read; 1XX: EEP)

      );

end ControllerRMAP;


architecture rtl of ControllerRMAP is

  type state_type is (StandBy, Test, Integration, Operational);
  signal SModo_op : state_type := StandBy;

  type state_Charge is (ERRO_1, ERRO_2, ERRO_Reinicio, lostclockA, lostclockB, lostclockC, waiting_access, waiting_FrameDone, waiting_transmit_done, lostClock0, lostClock1, lostClock2, waiting_sync);
  signal SCharge     : state_Charge := waiting_access;
  signal SChargeTest : state_Charge := waiting_access;

  type state_Transf is (transf_head1, transf_head2, transf_Data_Body1, transf_Data_Body2, transf_HK1, transf_HK2, transf_FimLinha, transf_NovaLinha, transf_Finalizar, transf_AguardandoSync, ERRO_1, ERRO_2, ERRO_Reinicio);
  signal Stransf     : state_Transf := transf_head1;
  signal StransfTest : state_Transf := transf_head1;

  type state_StandbY is (normal, ERRO_1, ERRO_2, ERRO_3, ERRO_4, ERRO_wast, ERRO_Reinicio);
  signal SstandBy : state_StandbY := normal;

begin

  process(aclr, clock)
  begin
    if aclr = '1' then
      SModo_op                     <= StandBy;
      Sel_DMux_nWrite_Data         <= "011";  -- (00:Head;01:DataBody;10:HK;11:Read)
      Transmissao_finalizada       <= '0';
      Free_to_transmit_Read_Reply  <= '0';
      Free_to_Transmit_tr_Head     <= '0';
      Free_to_AccessMemory_Charger <= '0';
      Free_to_Transmit_DataBody    <= '0';
      new_half_line_DataBody       <= '0';
      en_new_CCD_DataBody          <= '0';
      one_link_mode_DataBody       <= '0';
      n_write_Control              <= '1';    -- escreve em 0
      enbale_Reader_HK             <= '0';
      patern_enable                <= '0';
      Clear_SubControls            <= '1';

      SChargeTest <= waiting_sync;
      StransfTest <= transf_AguardandoSync;

      SCharge <= waiting_sync;
      Stransf <= transf_AguardandoSync;

      SstandBy <= normal;
    elsif (rising_edge(clock)) then

      Clear_SubControls            <= '0';

      -- entra somente se estiver no modo Running
      if conf_Modo_OP_geral = '1' then

        if (sync_6 = '1' or sync_25 = '1') then

                SModo_op                     <= Test;
                Sel_DMux_nWrite_Data         <= "000";  -- (00:Head;01:DataBody;10:HK;11:Read)
                Transmissao_finalizada       <= '0';
                Free_to_transmit_Read_Reply  <= '0';
                Free_to_Transmit_tr_Head     <= '0';
                Free_to_AccessMemory_Charger <= '0';
                Free_to_Transmit_DataBody    <= '0';
                en_new_CCD_DataBody          <= '1';  -- envia pois recebeu um sync 25
                enbale_Reader_HK             <= '1';
                patern_enable                <= '1';
                n_write_Control              <= '1';  -- escreve em 1

                -- verifica se ja havia finalizado a transmiss�o!
                if (StransfTest = transf_AguardandoSync) then  -- acabou a transmiss�o
                  SChargeTest          <= lostclockA;
                  StransfTest          <= transf_head1;
                  Sel_DMux_nWrite_Data <= "000";  -- (00:Head;01:DataBody;10:HK;11:Read)
                else                      --n�o acabou a transmiss�o
                  SChargeTest          <= ERRO_1;
                  StransfTest          <= ERRO_1;
                  Sel_DMux_nWrite_Data <= "100";  -- (00:Head;01:DataBody;10:HK;11:Read;100:ERRO)
                  n_write_Control      <= '1';    -- escreve em 1
                end if;

        else

              --------------------------------------------------------
              -- maquina de estado controlador dos modulos
              -------------------------------------------------------
              case StransfTest is
                -----------------------
                -- HEAD
                -----------------------
                when transf_head1 =>
                  en_new_CCD_DataBody  <= '0';
                  Sel_DMux_nWrite_Data <= "000"; --00:Head; 01:DataBody; 10:HK; 11:Read
                  if idle_SubControl_Head = '1' then
                    Free_to_Transmit_tr_Head <= '1';
                    StransfTest              <= transf_head2;
                  else
                    StransfTest <= transf_head1;
                  end if;

                when transf_head2 =>
                  Free_to_Transmit_tr_Head <= '0';
                  if transmit_done_Head = '1' then
                    StransfTest          <= transf_Data_Body1;
                    Sel_DMux_nWrite_Data <= "001";  -- (00:Head;01:DataBody;10:HK;11:Read)
                  else
                    StransfTest <= transf_head2;
                  end if;

                -----------------------
                -- Data body
                -----------------------
                when transf_Data_Body1 =>
                  Free_to_Transmit_DataBody <= '1';
                  StransfTest               <= transf_Data_Body2;

                when transf_Data_Body2 =>
                  if ((End_CCD_Transfer = '1') or (All_halfLine_Frame_sent_DataBody = '1')) then

                    Sel_DMux_nWrite_Data        <= "000";  -- (00:Head;01:DataBody;10:HK;11:Read)
                    Free_to_transmit_Read_Reply <= '0';
                    Free_to_Transmit_tr_Head    <= '0';
                    Free_to_Transmit_DataBody   <= '0';

                    if (End_CCD_Transfer = '1') then
                        StransfTest <= transf_Finalizar;
                    else
                        StransfTest <= transf_NovaLinha;
                    end if;
                  else
                    StransfTest <= transf_Data_Body2;
                  end if;

                -- EOP
                when transf_FimLinha =>
                  if (All_halfLine_Frame_sent_DataBody = '1') then
                    StransfTest <= transf_Finalizar;
                  else
                    StransfTest <= transf_NovaLinha;
                  end if;
                  Free_to_transmit_Read_Reply <= '0';
                  Free_to_Transmit_tr_Head    <= '0';
                  Free_to_Transmit_DataBody   <= '0';

                -----------------------
                -- Nova linha
                -----------------------
                when transf_NovaLinha =>
                  Transmissao_finalizada <= '0';
                  Sel_DMux_nWrite_Data   <= "000";  -- (00:Head;01:DataBody;10:HK;11:Read)
                  StransfTest            <= transf_head1;

                when transf_Finalizar =>
                  Transmissao_finalizada <= '1';
                  Sel_DMux_nWrite_Data   <= "000";  -- (00:Head;01:DataBody;10:HK;11:Read)
                  StransfTest            <= transf_AguardandoSync;

                -----------------------
                -- Aguardando Sync
                -----------------------
                when transf_AguardandoSync =>
                  enable_Reader     <= '1';
                  StransfTest       <= transf_AguardandoSync;

                -----------------------
                -- Erro
                -----------------------
                when ERRO_1 =>
                  en_new_CCD_DataBody  <= '0';
                  Sel_DMux_nWrite_Data <= "100";  -- (000:Head;001:DataBody;010:HK;011:Read; 1XX: EEP)
                  if (full_acfifo_Control = '0') then
                    n_write_Control <= '0';       -- escreve em 0
                    StransfTest     <= ERRO_2;
                  else
                    StransfTest <= ERRO_1;
                  end if;

                when ERRO_2 =>
                  n_write_Control <= '1';         -- escreve em 0
                  StransfTest     <= ERRO_Reinicio;

                when ERRO_Reinicio =>
                  StransfTest                 <= transf_head1;
                  Free_to_transmit_Read_Reply <= '0';
                  Sel_DMux_nWrite_Data        <= "000";  -- (00:Head;01:DataBody;10:HK;11:Read)
                  Transmissao_finalizada      <= '0';
                  Free_to_Transmit_tr_Head    <= '0';
                  Free_to_Transmit_DataBody   <= '0';
                  n_write_Control             <= '1';    -- escreve em 1

                when others =>
                  StransfTest <= transf_AguardandoSync;

            end case;


        end if; -- sync
      end if; -- op mode
    end if; -- clk
end process;



end rtl;
