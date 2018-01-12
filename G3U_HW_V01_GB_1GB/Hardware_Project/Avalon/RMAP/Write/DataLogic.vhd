--N�cleo de Sistemas Embarcados - Instituto Mau� de Tecnologia
--projeto: Simulador FEE
--nome do programa: 
--finalidade: Finalidade do programa
--vers�o: 1.0
--autor: Tiago Sanches da Silva
--		   <tiago.eem@gmail.com>
--data: 26-07-11
--
-- Este bloco permite a transmissão tanto em 2 link como em 1 link de forma dinamica! Penalidade: desempenho
--
--
-- este bloco ser� implementado por link SPW, para a transferencia
-- este bloco transmite para a autonomous fifo os dados da Fifo data Transfer
-- do CCd identify e CRC8.
-------------------------------------------------------------------------------
-- ======================
-- Modificacoes	- Corsi
-- ======================
-- PLATO 2.0 - set/2014
-------------------------------------------------------------------------------
-- Alteraçoes para suportar a nova arquitetura proposta para o SIMUCAM 2.0
-- o databody nao acessa mais a memoria, os dados serao disponibilizados
-- em uma FIFO, o databody deve somente liberar os dados dessa fifo para o
-- dmux. Porem continua contato a quantidade de dados enviados, isso será usado
-- para indicar ao up que a transmissao da linha foi concluida e que pode armezanar
-- novos dados.
--
-- adicionei contador para verificar o fim da transmissão da linha
-------------------------------------------------------------------------------

LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity DataLogic is
port
(
    clock :	in std_logic;
    clear : in std_logic;

    -----------------------------------------------
    -- Controlador RMAP
    -----------------------------------------------	
    -- interface com o controlador RAMAP SPW, para habilitar a transmissao do patern!
    enable_patern			: in  std_logic; -- TODO: REMOVER
    new_half_line			: in  std_logic;
    en_new_CCD				: in  std_logic; -- come after sync
    free_to_transmit		: in  std_logic;
    All_transmited			: out std_logic; -- indica que terminou a transmissao
    end_CCD_Trasfer         : out std_logic;

    -----------------------------------------------
    -- MEMORIA GERAL
    -----------------------------------------------
    -- o numero de linhas e o numero de colunas sera mapeado diretamente da memoria central! EM BYTEs
    -- TAMANHO DA MEMORIA EM PIXELS
    -- tamanho maximo: 8.192 Pixels X 8.192 Pixels
    -- 8.192 Pixels
    Cols_PIX    : in std_logic_vector(12 downto 0);		
    Lins_PIX    : in std_logic_vector(12 downto 0);	

    -- delay entre um transferencia das meias linhas
    Line_transfer_delay : in std_logic_vector(23 downto 0); --tempo em us

    Pre_Scan_px	  : in std_logic_vector(7 downto 0);
    Smearing_rows : in std_logic_vector(7 downto 0);	

    -- Append Bytes
    append_read_en      : out std_logic;    
    append_read_addr    : out std_logic_vector(7 downto 0);
    append_byte_size    : in  std_logic_vector(7 downto 0);

    -----------------------------------------------
    -- Sub_Control_Charger
    -----------------------------------------------
    -- TODO : Não serve para nada
    Fifo_charged		: in std_logic;

    -----------------------------------------------
    -- Autonomous Fifo
    -----------------------------------------------
    full_fifo_au		: in std_logic;
    nwrite_fifo_au		: out std_logic; -- escrita em 0	
    ac_fifo_empty  		: in  std_logic;

    -----------------------------------------------
    -- CCD_identify
    -----------------------------------------------	
    en_data_idCCD		: out std_logic; -- en_read

    -----------------------------------------------
    -- DC_FIFO
    -----------------------------------------------	
    rdreq_dcfifo		: out std_logic;
    rdempty_dcfifo		: in std_logic;
    Force_reset_dcfifo	: out std_logic;

    -----------------------------------------------
    -- Modulo_crc
    -----------------------------------------------		
    enable_ler_data_CRC : out std_logic;
    get_crc_CRC 		: out std_logic;
    idle_CRC 			: in  std_logic;
    CRC_ready_CRC 		: in std_logic;
    clear_CRC			: out std_logic;		

    -----------------------------------------------
    -- MUX
    -----------------------------------------------			
    -- MUX interno 1
    -- este mux leva a informacao da fifo, do hk e do prescan e do CCD_identify ate o CRC
    -- 00 : CCD_identify
    -- 01 : Data - FIFO
    -- 10 : Pre Scan
    -- 11 : HK
    Mux_CCD_Data_PreS : out std_logic_vector(1 downto 0);

    -- Mux 2 para externo
    -- este mux leva os outros blocos e o CRC para o autonomus FIFO
    -- 0 : ALL(CCD_identify, data-Fifo, Pre Scan, HK) to autonomous
    -- 1 : CRC to autonomous
    Mux_ALL_CRC				:	out std_logic_vector(1 downto 0)		
);
end DataLogic;


architecture rtl of  DataLogic is

    type  state_type is (   append_send,
                            append_wait,
                            sending_data,
                            waiting_data,
                            waiting_sync,
                            sending_delay,
                            waiting_newline,
                            send_data,
                            CRC1,CRC2,CRC3,CRC4,
                            Finalizar_CRC0,Finalizar_CRC1,Finalizar_CRC2,
                            Delay_line0,Delay_line1,
                            Enviar_EOP0,Enviar_EOP,Enviar_EOP2,Enviar_EOP3,
                            lost
                        );
    signal	state_Tran :	state_type := waiting_data; 
        
    signal	nwrite_fifo_au_signal		: std_logic; -- escrita em 0	
    signal	rdreq_dcfifo_signal			: std_logic;
    signal	Force_reset_dcfifo_signal	: std_logic;
    signal	enable_ler_data_CRC_signal  : std_logic;
    signal	get_crc_CRC_signal 			: std_logic;
    signal	clear_CRC_signal			: std_logic;

    -- usado para contar qnt de pixes enviados e linhas
    signal cnt_colspix 	 : natural range 0 to 65535 := 0; -- 2^16 -1 
    signal cnt_linspix   : natural range 0 to 65535 := 0; -- 2^16 -1
    signal cnt_append    : natural range 0 to 255   := 0; -- 2^8 -1


begin

process(clock)
begin

if ((clock'event) and (clock = '1')) then
    -----------------------------------------------
    -- clear
    -----------------------------------------------	
    if (clear = '1') then
    
        All_transmited			  <= '0';
        end_CCD_Trasfer           <= '0';

        nwrite_fifo_au_signal	  <= '1';	
        rdreq_dcfifo_signal	      <= '0';

        Force_reset_dcfifo_signal <= '0';			
    
        enable_ler_data_CRC_signal<= '0';
        get_crc_CRC_signal 		  <= '0';
        clear_CRC_signal		  <= '0';	

        Mux_CCD_Data_PreS         <= "01";
        Mux_ALL_CRC			      <= (others => '0'); -- Data

        cnt_colspix               <= 0;
        cnt_linspix               <= 0;
        cnt_append                <= 0;

        state_Tran  			  <= waiting_sync;				

    else
        if ((new_half_line = '1') or (en_new_CCD = '1')) then
            
            All_transmited		<= '0';
            end_CCD_Trasfer     <= '0';
            clear_CRC_signal	<= '1'; 		-- limpando CRC

            Mux_ALL_CRC			<= "00";
            Mux_CCD_Data_PreS   <= "01";
            
            -- a fifo encontra-se com dado ?
            -- a fifo de escrita tem espaco ?
            if(to_integer(unsigned(Lins_PIX)) > 0) then
                state_Tran  <= append_wait;
            else
                state_Tran  <= Enviar_EOP;
            end if;

            if (en_new_CCD ='1') then
                cnt_linspix <= 0;
            end if;

            -- o contador de pix deve sempre zerar!
            -- lembrar que um px = 2 bytes
            -- TODO Verificar isso
            -- corrigido no commit: bde9ec6c
            cnt_colspix     <= 0;
            cnt_append      <= 0;

        elsif (free_to_transmit = '1') then

            case state_Tran is

                    --------------------------
                    when waiting_sync =>
                        state_Tran <=   waiting_sync;
                        clear_CRC_signal  <= '0';
                
                    --------------------------
                    when waiting_newline =>
                        if(free_to_transmit = '1') then
                            state_Tran  <= append_wait;
                            cnt_colspix <= 0;
                        else
                            state_Tran <= waiting_newline;
                        end if;

                    --------------------------
                    when append_wait =>
                        
                        clear_CRC_signal            <= '0';
                        enable_ler_data_CRC_signal  <= '1';
                        nwrite_fifo_au_signal       <= '1';
                        end_CCD_Trasfer             <= '0';
                        All_transmited              <= '0';
                        Mux_ALL_CRC                 <= "00";
                        Mux_CCD_Data_PreS           <= "01";

                        append_read_addr <= std_logic_vector(to_unsigned(cnt_append,8));

                        if( cnt_append < to_integer(unsigned(append_byte_size))) then 
                                if(full_fifo_au = '1') then
                                        state_Tran <= append_wait;
                                else
                                        state_Tran <= append_send;
                                end if;
                        
                        else
                                state_Tran           <= waiting_data;
                                Mux_CCD_Data_PreS    <= "00";
                        end if;

                    --------------------------
                    when append_send =>
                        cnt_append              <= cnt_append + 1;
                        state_Tran              <= append_wait;
                        nwrite_fifo_au_signal   <= '0';                 
                    
                    --             if( to_integer(unsigned(append_byte_size)) > 0) then
                    --------------------------
                    when waiting_data =>

                        clear_CRC_signal            <= '0';
                        nwrite_fifo_au_signal       <= '1';
                        rdreq_dcfifo_signal         <= '0';

                        -- Final da transferência, enviar CRC
                        if(cnt_colspix >= ((to_integer(unsigned(Cols_PIX)) + to_integer(unsigned(Pre_Scan_px)))*2) ) then
                            if(full_fifo_au = '1') then
                                state_Tran            <= waiting_data;
                                nwrite_fifo_au_signal <= '1';
                                rdreq_dcfifo_signal	  <= '0';
                            else
                                state_Tran                  <= CRC1;
                                rdreq_dcfifo_signal         <= '0';
                                nwrite_fifo_au_signal       <= '1';
                                enable_ler_data_CRC_signal  <= '0';
                            end if;
                        -- Ainda precisa enviar dados
                        else
                            -- nenhum dado disponivel na DC FIFO 
                            if(rdempty_dcfifo = '1' or full_fifo_au = '1') then
                                state_Tran            <= waiting_data;
                                nwrite_fifo_au_signal <= '1';
                                rdreq_dcfifo_signal	  <= '0';
                            else
                                state_Tran            <= sending_data;
                                nwrite_fifo_au_signal <= '1';
                                rdreq_dcfifo_signal	  <= '1';
                            end if;
                        end if;

                    --------------------------
                    when sending_data =>
                        state_Tran              <= waiting_data;
                        rdreq_dcfifo_signal     <= '0';
                        nwrite_fifo_au_signal   <= '0';
                        cnt_colspix             <= cnt_colspix + 1;

                    --------------------------
                    -- Added because DC FIFO puts update dout only after rdreq.
                    when sending_delay =>
                        state_Tran              <= sending_data;
                        rdreq_dcfifo_signal     <= '0';
                        nwrite_fifo_au_signal   <= '0';

                    ---------------------------
                    when CRC1 =>
                        nwrite_fifo_au_signal 	   <= '1'; 
                        Force_reset_dcfifo_signal  <= '0'; --se tiver pattern, vem direto do dado
                        state_Tran                 <= CRC2;

                    ---------------------------
                    when CRC2	=>
                        --Mudar mux para CRC line 
                        -- voltando mux 1 para CCD_Ident
                        Mux_CCD_Data_PreS <= "00";
                        -- multiplexando mux 2 para CRC
                        Mux_ALL_CRC       <= "01";	
                        if (idle_CRC = '1') then
                            get_crc_CRC_signal <= '1';
                            state_Tran         <= CRC3;
                        else
                            get_crc_CRC_signal  <= '0';
                            state_Tran          <= CRC2;
                        end if;

                    ---------------------------
                    when CRC3	=>
                        get_crc_CRC_signal <= '0';
                        if ((CRC_ready_CRC = '1') and (full_fifo_au = '0')) then
                            state_Tran              <= CRC4;
                            nwrite_fifo_au_signal   <= '0';
                        else
                            nwrite_fifo_au_signal   <= '1';
                            state_Tran              <= CRC3;
                        end if;

                    ---------------------------
                    when CRC4 =>
                        nwrite_fifo_au_signal <= '1';
                        state_Tran <= Finalizar_CRC0;

                    ---------------------------
                    when Finalizar_CRC0 =>
                        state_Tran <= Finalizar_CRC1;

                    ---------------------------	
                    when Finalizar_CRC1 =>	
                        state_Tran 		<= Enviar_EOP;
                        -- multiplexando para EOP
                        Mux_ALL_CRC  	<= "10";

                    ---------------------------
                    when Finalizar_CRC2 =>
                        state_Tran 		<= Enviar_EOP0;

                    ---------------------------
                    when Enviar_EOP0 =>
                        state_Tran  <= Enviar_EOP;

                    ---------------------------
                    when Enviar_EOP =>
                        if (full_fifo_au = '0') then
                            nwrite_fifo_au_signal <= '0';      --0: escreve na autonomous fifo
                            state_Tran     <= Enviar_EOP2;
                        else
                            nwrite_fifo_au_signal <= '1';
                            state_Tran     <= Enviar_EOP;
                        end if;	

                    ---------------------------	
                    when Enviar_EOP2 =>
                        nwrite_fifo_au_signal   <= '1';  --0: escreve na autonomous fifo
                        if (full_fifo_au = '0') then

                            clear_CRC_signal    <= '1';
                            All_transmited		<= '1';

                            if (cnt_linspix >= (((to_integer(unsigned(Lins_pix))) + to_integer(unsigned(Smearing_rows))) - 1)) then
                               cnt_linspix     <= 0;
                               end_CCD_Trasfer <= '1';
                               state_Tran      <= waiting_sync;
                            else
                               cnt_linspix     <= cnt_linspix + 1;
                               end_CCD_Trasfer <= '0';
                               state_Tran      <= lost;
                            end if;

                        else
                            clear_CRC_signal    <= '0';
                            All_transmited	    <= '0';
                            state_Tran          <= Enviar_EOP2;
                        end if;

                    -----------------------------
                    -- Para esperar o rmap controller desativar
                    -- o free to transmit
                    when lost =>
                        state_Tran     <= waiting_newline;
                        All_transmited <= '0';

                    ---------------------------	
                    when others =>
                        state_Tran	<=	waiting_sync;

                end case;

        else    -- nao tem liberdade para transmitir
            clear_CRC_signal			<= '0';
            enable_ler_data_CRC_signal  <= '0';
            nwrite_fifo_au_signal	    <= '1';
            rdreq_dcfifo_signal		    <= '0';
        end if;		
    end if;--clear		
end if;

end process;


process(clear, nwrite_fifo_au_signal, rdreq_dcfifo_signal,
    Force_reset_dcfifo_signal,enable_ler_data_CRC_signal,get_crc_CRC_signal,
    clear_CRC_signal) 
begin
    if (clear = '1') then
        nwrite_fifo_au	<=	'1';	
    
        rdreq_dcfifo		<=	'0';
        Force_reset_dcfifo	<=	'0';			
    
        enable_ler_data_CRC <=	'0';
        get_crc_CRC 		<=	'0';
        clear_CRC			<=	'0';
    else
        nwrite_fifo_au	    <=	nwrite_fifo_au_signal;	
    
        rdreq_dcfifo		<=	rdreq_dcfifo_signal;
        Force_reset_dcfifo	<=	Force_reset_dcfifo_signal;			
    
        enable_ler_data_CRC <=	enable_ler_data_CRC_signal AND NOT(nwrite_fifo_au_signal);
        get_crc_CRC 		<=	get_crc_CRC_signal;
        clear_CRC			<=	clear_CRC_signal;
    end if;		
end process;


end architecture;
