--Nï¿½cleo de Sistemas Embarcados - Instituto Mauï¿½ de Tecnologia
--projeto: Simulador FEE
--nome do programa: 
--finalidade: Finalidade do programa
--versï¿½o: 1.0
--autor: Tiago Sanches da Silva..
--                 <tiago.eem@gmail.com>
--data: 03-08-11
-------------------------------------------------------------------------------
-- ======================
-- Modificacoes - Corsi
-- ======================
-- PLATO 2.0 - set/2014
-------------------------------------------------------------------------------
-- Removido os dois links que eram mapeado na memoria
-- removido o prescan
-- TODO
--  Verificar endereÃ§o memoria
--  N. SPILL ??? o que Ã© isso ?
--  Adicionar nÃºmero do codec
--  Renomear de memoria geral para Registrador Geral
--  modificar para ter largura de 32 bits
--
-- PLATO 2.0 - 3/2015
--
-- Modificando para largura de 32bits
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity Reg_Geral is
  port (

    ---------------------------------------------------------------------------
    -- Global
    ---------------------------------------------------------------------------

    clock       : in std_logic;
    aclr              : in std_logic;
    Enable_SnapShotHK : in std_logic;

    ---------------------------------------------------------------------------
    -- Escrita/Leitura
    ---------------------------------------------------------------------------

    -- atualizacao realizada pelo AVALON
    data_in_AVALON      : in  std_logic_vector(31 downto 0);
    en_data_in_AVALON   : in  std_logic;
    en_data_out_AVALON  : in  std_logic;
    addr_in_AVALON      : in  std_logic_vector(8 downto 0);
    data_ready_AVALON   : out std_logic;
    data_out_AVALON     : out std_logic_vector(31 downto 0);

    -- Para bloco Read RMAP link 1
    data_in_RMAP     : in  std_logic_vector(7 downto 0);
    en_data_in_RMAP  : in  std_logic;
    addr_in_RMAP     : in  std_logic_vector(8 downto 0);

    en_data_out_RMAP : in  std_logic;      -- enable read
    addr_out_RMAP    : in  std_logic_vector(8 downto 0);
    data_ready_RMAP  : out std_logic;
    data_out_RMAP    : out std_logic_vector(7 downto 0);

   -- Append Bytes
    append_read_en      : in  std_logic;    
    append_read_addr    : in  std_logic_vector(7 downto 0);
    append_read_data    : out std_logic_vector(7 downto 0);
    append_byte_size    : out std_logic_vector(7 downto 0);
     
   --Para House Keeping Link 1
   -- en_data_out_HK  : in  std_logic;    -- enable read
   -- addr_out_HK     : in  std_logic_vector(8 downto 0);
   -- data_ready_HK   : out std_logic;
   -- data_out_HK     : out std_logic_vector(7 downto 0);

    ---------------------------------------------------------------------------
    -- Mapeamento direto para os cabecalho do link1
    ---------------------------------------------------------------------------

    -- head write (link 1)
    Phy_lenght_head_write1     : out std_logic_vector(1 downto 0);
    Phy_addrMSB_head_write1    : out std_logic_vector(7 downto 0);
    Phy_addrLSB_head_write1    : out std_logic_vector(7 downto 0);
    Logic_addr_head_write1     : out std_logic_vector(7 downto 0);
    Key_head_write1            : out std_logic_vector(7 downto 0);
    InitLogic_addr_head_write1 : out std_logic_vector(7 downto 0);
    Addr_step_data_head_write1 : out std_logic_vector(31 downto 0);
    Extended_addr_head_write1  : out std_logic_vector(7 downto 0);  --MSB
    Addr_field3_head_write1    : out std_logic_vector(7 downto 0);
    Addr_field2_head_write1    : out std_logic_vector(7 downto 0);
    Addr_field1_head_write1    : out std_logic_vector(7 downto 0);
    Addr_field0_head_write1    : out std_logic_vector(7 downto 0);  -- LSB
    Data_lenght2_head_write1   : out std_logic_vector(7 downto 0);
    Data_lenght1_head_write1   : out std_logic_vector(7 downto 0);
    Data_lenght0_head_write1   : out std_logic_vector(7 downto 0);

    -- head write HOUSE KEEPING (link 1)
    Phy_lenght_HK1     : out std_logic_vector(1 downto 0);
    Phy_addrMSB_HK1    : out std_logic_vector(7 downto 0);
    Phy_addrLSB_HK1    : out std_logic_vector(7 downto 0);
    Logic_addr_HK1     : out std_logic_vector(7 downto 0);
    Key_HK1            : out std_logic_vector(7 downto 0);
    InitLogic_HK1      : out std_logic_vector(7 downto 0);
    Addr_step_data_HK1 : out std_logic_vector(31 downto 0);
    Extended_addr_HK1  : out std_logic_vector(7 downto 0);  --MSB
    Addr_field3_HK1    : out std_logic_vector(7 downto 0);
    Addr_field2_HK1    : out std_logic_vector(7 downto 0);
    Addr_field1_HK1    : out std_logic_vector(7 downto 0);
    Addr_field0_HK1    : out std_logic_vector(7 downto 0);  -- LSB
    Data_lenght2_HK1   : out std_logic_vector(7 downto 0);
    Data_lenght1_HK1   : out std_logic_vector(7 downto 0);
    Data_lenght0_HK1   : out std_logic_vector(7 downto 0);

    -- bloco de leitura (link 1)
    Phy_length_Read1  : out std_logic_vector(1 downto 0);
    Phy_addrMSB_Read1 : out std_logic_vector(7 downto 0);
    Phy_addrLSB_Read1 : out std_logic_vector(7 downto 0);
    Logic_addr_read1  : out std_logic_vector(7 downto 0);
    Key_read1         : out std_logic_vector(7 downto 0);

    ---------------------------------------------------------------------------
    -- Parametros Simulador
    ---------------------------------------------------------------------------
    Operation_global    : out std_logic;
    Operation_service   : out std_logic;
    Operation_running   : out std_logic_vector(1 downto 0);
    Operation_CRC_fault : out std_logic;
    Operation_sync      : out std_logic;

    Operation_Start_Stop    : out std_logic;
    Operation_Pause_Resume  : out std_logic;
    Operation_Reset_Pattern : out std_logic;
    Operation_Spill         : out std_logic;

    ---------------------------------------------------------------------------
    -- DC FIFO
    ---------------------------------------------------------------------------
    DC_FIFO_wrfull  : in std_logic;
    DC_FIFO_wrusedw : in std_logic_vector (12 downto 0);
    DC_FIFO_rdempty : in std_logic;
    DC_FIFO_rdusedw : in std_logic_vector (14 downto 0);

    -- Configura o RST da DC-FIFO (25/3/2015)
    DC_FIFO_rst      : out std_logic; -- forced rst DC_FIFO
    DC_FIFO_auto_rst : out std_logic; -- rst dc fifo when new half_line or new_ccd

    ---------------------------------------------------------------------------
    -- CODEC
    ---------------------------------------------------------------------------
    codec_status   : in  std_logic_vector(10 downto 0);
    codec_ctr      : out std_logic_vector(7  downto 0);
    codec_txdivcnt : out std_logic_vector(7  downto 0);
    codec_loopback : out std_logic;
    codec_rst      : out std_logic;

    ---------------------------------------------------------------------------
    -- Sync 
    ---------------------------------------------------------------------------
    sync_timer : out std_logic_vector(15 downto 0);
    sync_counter : out std_logic_vector(7 downto 0);

    ---------------------------------------------------------------------------
    -- Timecode Enable
    ---------------------------------------------------------------------------
    timecode_enable : out std_logic;

    ---------------------------------------------------------------------------
    -- CCD Descriptions
    ---------------------------------------------------------------------------
    ADC_delay_10ns : out std_logic_vector(15 downto 0);

    Pre_Scan_px   : out std_logic_vector(7 downto 0);
    Smearing_rows : out std_logic_vector(7 downto 0);

    line_transfer_time : out std_logic_vector(23 downto 0);  --10 ns
    COLS_PIX           : out std_logic_vector(12 downto 0);
    Lin_PIX            : out std_logic_vector(12 downto 0)

    );
end Reg_Geral;


architecture rtl of Reg_Geral is

        type REG_Type_FEE is array (128 to 150) of std_logic_vector(31 downto 0);
        signal REG_FEE : REG_Type_FEE;

        type Mem_Type_FEE is array (0 to 127) of std_logic_vector(7 downto 0);
        signal MEM_FEE : MEM_Type_FEE;

        signal codecErrdisc, codecErrdiscFlag : std_logic;        
        signal codecErrpar,  codecErrparFlag  : std_logic;        
        signal codecErresc,  codecErrescFlag  : std_logic;        
        signal codecErrcred, codecErrcredFlag : std_logic;

begin

process(clock, aclr)
begin

    if (aclr = '1') then
  
        -----------------------------------------------------------------------------
        -- House Keeping
        -----------------------------------------------------------------------------
        for i in 0 to 127 loop  -- House Keeping e SnapShot of House Keeping
            MEM_FEE(i) <= (others => '0');
        end loop;

        ------------------------------------------------------------------------------
        --  Simulador
        ------------------------------------------------------------------------------
        -- ConfiguraÃ§Ã£o geral
        REG_FEE(128) <= X"00_01_00_03";     -- Operation Mode
        REG_FEE(129) <= X"00_01_00_03";     -- Configurations
        REG_FEE(130) <= X"01_00_64_18";     -- Timecode Enable & Top Sync counter & TimeCode us 
        REG_FEE(131) <= X"00_00_00_00";     -- DC FIFO Rst

        -- Codec Ctr
        REG_FEE(132) <= x"10_00_00_00";     -- Ctr, tx div and rst 
        REG_FEE(133) <= (others => '0');    -- Codec Status and DC fifo Status

        -- CCD
        REG_FEE(136) <= X"00_02_00_04";     -- CCD Heigth & Width
        REG_FEE(137) <= X"00_00_00_00";      -- CCD ADC Speed, Smearing & Prescan
        REG_FEE(138) <= X"00_00_00_00";     -- Line transfer time

        -- RMAP FEE
        REG_FEE(139) <= X"00_00_00_00";     -- Phisical address size & address
        REG_FEE(140) <= X"00_00_00_00";     -- Logical address & Key
       
        -- RMAP DPU
        REG_FEE(141) <= X"00_00_00_00";     -- Phisical address size & address
        REG_FEE(142) <= X"00_00_00_01";     -- Logical address & Key    
        REG_FEE(143) <= X"00_00_00_00";     -- Extended address data    
        REG_FEE(144) <= X"00_00_00_00";     -- Address data     
        REG_FEE(145) <= X"00_00_00_04";     -- Data length  
      
        REG_FEE(147) <= X"00_00_00_00";     -- HK Extended address data    
        REG_FEE(148) <= X"00_00_00_00";     -- HK Address data     
        REG_FEE(149) <= X"00_00_00_00";     -- HK Data length  
        REG_FEE(146) <= X"00_00_00_00";     -- Step-Address

        REG_FEE(150) <= (others => '0');
     ------------------------------------------------------------------------------

    elsif (rising_edge(clock)) then

        --------------------
        -- append data
        --------------------
        append_read_data <=  MEM_FEE(to_integer(unsigned(append_read_addr)));   

        --------------------
        -- Codec and DC FIFO
        --------------------
        REG_FEE(133)(10  downto 0)  <= codec_status;
        REG_FEE(133)(23 downto 11)  <= DC_FIFO_wrusedw;
        REG_FEE(133)(24)            <= DC_FIFO_wrfull;
        REG_FEE(133)(31 downto 25)  <= (others => '0'); -- ZEROS

        ----------------
        -- AVALON
        ----------------
        
        -- blocos de gravacao nos registradores
        if (en_data_in_AVALON = '1') then
            if (to_integer(unsigned(addr_in_AVALON)) <= 127) then
                MEM_FEE(TO_INTEGER(UNSIGNED(ADDR_IN_AVALON))) <= data_in_AVALON(7 downto 0);
            else
                REG_FEE(to_integer(unsigned(addr_in_AVALON))) <= data_in_AVALON;
            end if;
        end if;

        if (en_data_out_AVALON = '1') then
            if (to_integer(unsigned(addr_in_AVALON)) <= 127) then
                data_out_AVALON(7 downto  0)  <= MEM_FEE(to_integer(unsigned(addr_in_AVALON)));
                data_out_AVALON(31 downto 0)  <= (others => '0'); 
                data_READY_avalon             <= '1';

            elsif (to_integer(unsigned(addr_in_AVALON)) > 127) then
                data_out_AVALON     <= REG_FEE(to_integer(unsigned(addr_in_AVALON)));
                data_READY_avalon   <= '1';
            else
                data_out_AVALON     <= (others => '0');
                data_ready_AVALON   <= '0';
            end if;
        else
            data_ready_AVALON <= '0';
        end if;

        ----------------
        -- RMAP READ
        ----------------
        -- blocos de gravacao nos registradores
        if (en_data_in_RMAP = '1') then
            if (to_integer(unsigned(addr_in_RMAP)) <= 127) then
                MEM_FEE(TO_INTEGER(UNSIGNED(addr_in_RMAP))) <= data_in_RMAP(7 downto 0);
            end if;
        end if;

        if (en_data_out_RMAP = '1') then
            if (to_integer(unsigned(addr_in_RMAP)) <= 127) then
                data_out_RMAP(7 downto  0)  <= MEM_FEE(to_integer(unsigned(addr_in_RMAP)));
                data_READY_RMAP             <= '1';
            else
                data_out_RMAP     <= (others => '0');
                data_ready_AVALON <= '0';
            end if;
        else
            data_ready_AVALON <= '0';
        end if;
        
        --------------------
        -- CODEC ERRO
        --------------------
        -- only increment counter if value its comming from previus state 0
        -- to avoid increment more than one time for the same error.

        -- ErrCred
        if(codec_status(0) = '1') then
                if(codecErrcredFlag = '0') then
                        if (REG_FEE(134)(7 downto 0) = x"FF") then
                                REG_FEE(134)(7 downto 0) <= std_logic_vector(unsigned(REG_FEE(133)(7 downto 0)) + "00" );
                        else
                                REG_FEE(134)(7 downto 0) <= std_logic_vector(unsigned(REG_FEE(133)(7 downto 0)) + "01" );
                        end if;
                else
                        REG_FEE(134)(7 downto 0) <= std_logic_vector(unsigned(REG_FEE(133)(7 downto 0)) +  "00" );
                end if;
                codecErrcredFlag <= '1';
        else
                codecErrcredFlag <= '0';
        end if;

        -- ErrEsc
        if(codec_status(1) = '1') then
                if(codecErrescFlag = '0') then
                        if (REG_FEE(134)(15 downto 8) = x"FF") then
                                REG_FEE(134)(15 downto 8) <= std_logic_vector(unsigned(REG_FEE(133)(15 downto 8)) + "00" );
                        else
                                REG_FEE(134)(15 downto 8) <= std_logic_vector(unsigned(REG_FEE(133)(15 downto 8)) + "01" );
                        end if;
                else
                        REG_FEE(134)(15 downto 8) <= std_logic_vector(unsigned(REG_FEE(133)(15 downto 8)) + "00" );
                end if;
                codecErrescFlag <= '1';
        else
                codecErrescFlag <= '0';
        end if;
         
        -- ErrPar
        if(codec_status(2) = '1') then
                if(codecErrparFlag = '0') then
                        if (REG_FEE(134)(23 downto 16) = x"FF") then
                                REG_FEE(134)(23 downto 16) <= std_logic_vector(unsigned(REG_FEE(133)(23 downto 16)) + "00" );
                        else
                                REG_FEE(134)(23 downto 16) <= std_logic_vector(unsigned(REG_FEE(133)(23 downto 16)) + "01" );
                        end if;
                else
                        REG_FEE(134)(23 downto 16) <= std_logic_vector(unsigned(REG_FEE(133)(23 downto 16)) + "00" );
                end if;
                codecErrparFlag <= '1';
        else
                codecErrparFlag <= '0';
        end if;

        -- ErrDisc
        if(codec_status(3) = '1') then
                if(codecErrDiscFlag = '0') then
                        if (REG_FEE(134)(31 downto 24) = x"FF") then
                                REG_FEE(134)(31 downto 24) <= std_logic_vector(unsigned(REG_FEE(133)(31 downto 24)) + "00" );
                        else
                                REG_FEE(134)(31 downto 24) <= std_logic_vector(unsigned(REG_FEE(133)(31 downto 24)) + "01" );
                        end if;
                else
                        REG_FEE(134)(31 downto 24) <= std_logic_vector(unsigned(REG_FEE(133)(31 downto 24)) + "0" );
                end if;
                codecErrDiscFlag <= '1';
        else
                codecErrDiscFlag <= '0';
        end if;


    end if;
 end process;

    Phy_lenght_head_write1     <= REG_FEE(141)(1 downto 0);
    Phy_addrMSB_head_write1    <= REG_FEE(141)(23 downto 16);
    Phy_addrLSB_head_write1    <= REG_FEE(141)(15 downto 8 );
    Logic_addr_head_write1     <= REG_FEE(142)(7  downto 0 );  -- logical da DPU
    Key_head_write1            <= REG_FEE(142)(15 downto 8 );
    InitLogic_addr_head_write1 <= REG_FEE(140)(7  downto 0 );  -- nosso logical
    Addr_step_data_head_write1 <= REG_FEE(146)(31 downto 0 );
    Extended_addr_head_write1  <= REG_FEE(143)(7  downto 0 );  -- MSB
    Addr_field3_head_write1    <= REG_FEE(144)(31 downto 24);
    Addr_field2_head_write1    <= REG_FEE(144)(23 downto 16);
    Addr_field1_head_write1    <= REG_FEE(144)(15 downto 8 );
    Addr_field0_head_write1    <= REG_FEE(144)(7  downto 0 );  -- LSB
    Data_lenght2_head_write1   <= REG_FEE(145)(23 downto 16);  -- MSB
    Data_lenght1_head_write1   <= REG_FEE(145)(15 downto 8 );
    Data_lenght0_head_write1   <= REG_FEE(145)(7  downto 0 );  -- LSB

    Phy_lenght_HK1     <= REG_FEE(141)(1 downto 0);
    Phy_addrMSB_HK1    <= REG_FEE(141)(23 downto 16);
    Phy_addrLSB_HK1    <= REG_FEE(141)(15 downto 8 );
    Logic_addr_HK1     <= REG_FEE(142)(7  downto 0 ); 
    Key_HK1            <= REG_FEE(142)(15 downto 8 );
    InitLogic_HK1      <= REG_FEE(140)(7  downto 0 );
    Addr_step_data_HK1 <= (others => '0');             -- todo: Verificar
    Extended_addr_HK1  <= REG_FEE(144)(7  downto 0 );  -- MSB
    Addr_field3_HK1    <= REG_FEE(148)(31 downto 24);
    Addr_field2_HK1    <= REG_FEE(148)(23 downto 16);
    Addr_field1_HK1    <= REG_FEE(148)(15 downto 8 );
    Addr_field0_HK1    <= REG_FEE(148)(7  downto 0 );  -- LSB
    Data_lenght2_HK1   <= REG_FEE(149)(23 downto 16);  -- MSB
    Data_lenght1_HK1   <= REG_FEE(149)(15 downto 8 );
    Data_lenght0_HK1   <= REG_FEE(149)(7  downto 0 );  -- LSB

    Phy_length_Read1  <= REG_FEE(139)(17 downto 16);
    Phy_addrMSB_Read1 <= REG_FEE(139)(15 downto 8 );
    Phy_addrLSB_Read1 <= REG_FEE(139)(7  downto 0 );
    Logic_addr_read1  <= REG_FEE(140)(7  downto 0 );
    Key_read1         <= REG_FEE(139)(15 downto 8 );   -- key do FEE

    Operation_global    <= REG_FEE(128)(1);
    Operation_service   <= REG_FEE(128)(0);
    Operation_running   <= REG_FEE(128)(25 downto 24);
    Operation_CRC_fault <= REG_FEE(129)(0);
    Operation_sync      <= REG_FEE(129)(16);

    --PaternNumber_1      <= tbl_NFEE(129)(23 downto 16);      -- pattern

    COLS_PIX <= REG_FEE(136)(12 downto 0 );
    Lin_PIX  <= REG_FEE(136)(28 downto 16);

    Pre_Scan_px   <= REG_FEE(137)(15 downto 8 );
    Smearing_rows <= REG_FEE(137)(7  downto 0 );

    sync_timer   <= REG_FEE(130)(15 downto 0);
    sync_counter <= REG_FEE(130)(23 downto 16);
    
    timecode_enable <= REG_FEE(130)(24);

    ADC_delay_10ns     <= REG_FEE(137)(31 downto 16);
    line_transfer_time <= REG_FEE(138)(23 downto 0 );

    Operation_Start_Stop    <= REG_FEE(129)(24);
    Operation_Pause_Resume  <= REG_FEE(139)(25);
    Operation_Reset_Pattern <= REG_FEE(140)(26);
    Operation_Spill         <= REG_FEE(141)(27);

    --------------------------------------------------------------------------
    -- DC FIFO rst
    --------------------------------------------------------------------------
    DC_FIFO_rst      <= REG_FEE(131)(0); 
    DC_FIFO_auto_rst <= REG_FEE(131)(8);

    --------------------------------------------------------------------------
    -- Append
    --------------------------------------------------------------------------
    append_byte_size <= REG_FEE(150)(7 downto 0);

    --------------------------------------------------------------------------
    -- Codec
    --------------------------------------------------------------------------
    codec_ctr      <= REG_FEE(132)(7  downto 0 );
    codec_loopback <= REG_FEE(132)(8);
    codec_txdivcnt <= REG_FEE(132)(23 downto 16);
    codec_rst      <= REG_FEE(132)(31);

end rtl;
