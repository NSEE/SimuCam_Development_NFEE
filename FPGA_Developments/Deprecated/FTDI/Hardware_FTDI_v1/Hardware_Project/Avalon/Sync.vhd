-------------------------------------------------------------------------------
-- Instituto Maua de Tecnologia
-- 	Nucleo de Sistemas Eletronicos Embarcados
--
-- Rafael Corsi - rafael.corsi@maua.br
-- Platao Simucam 2.0
--
-- Mar/2015
--
--------------------------------------------------------------------------------
-- Descriao
--
-- Modulo responsÃ¡vel pelo sincronismo do RMAP/SpW
-- 
-- dois modos de operacao: sinal interno ou externo, em ambos os casos o sincro
-- nismo vem externo a esse modulo, ou vem via interrupÃ§Ã£o do timer no qsys
-- ou via pino externo
--
-- tab_length= 4
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;
use work.all;

entity Sync is
    generic (
		CLKF    : natural := 100000000;
        PULSEW  : natural := 1          -- us         
    );
    port (
        -- Gloabals
        clk                : in  std_logic                     := '0';             -- clock.clk
        reset              : in  std_logic                     := '0';             -- reset.reset
        
        -- Interrupçao out
        IRQ_Sync        : out std_logic;                                        -- irq0.irq
        
        -- Conduit para o RMAP_SPW
        Sync_A            : out std_logic_vector(1 downto 0);                      -- Sync_25 out
        Sync_B            : out std_logic_vector(1 downto 0);                      -- Sync_25 out
        Sync_C            : out std_logic_vector(1 downto 0);                      -- Sync_25 out
        Sync_D            : out std_logic_vector(1 downto 0);                      -- Sync_25 out
        Sync_E            : out std_logic_vector(1 downto 0);                      -- Sync_25 out
        Sync_F            : out std_logic_vector(1 downto 0);                      -- sync 6 out 
        Sync_G            : out std_logic_vector(1 downto 0);                      -- sync 6 out 
        Sync_H            : out std_logic_vector(1 downto 0);                      -- sync 6 out     

        -- RMAP Register
        -- Avalion Memmory Mapped Slave
        avs_s0_address     : in  std_logic_vector(3 downto 0)  := (others => '0'); -- s0.address
        avs_s0_read        : in  std_logic                     := '0';             -- .read
        avs_s0_readdata    : out std_logic_vector(31 downto 0);                    -- .readdata
        avs_s0_write       : in  std_logic                     := '0';             -- .write
        avs_s0_writedata   : in  std_logic_vector(31 downto 0) := (others => '0'); -- .writedata
        avs_s0_waitrequest : out std_logic;                                        -- .waitrequest

        Extern_sync_in     : in  std_logic					   := '0';
        Extern_sync_out    : out std_logic                     := '0'
	);
end entity Sync;

architecture rtl of Sync is

----------------------------------------
-- Sinais
-----------------------------------------

-- Reg. Config
type REG_Type_Sync is array (0 to 6) of std_logic_vector(31 downto 0);
signal REG_Sync : REG_Type_Sync ;


-- sinais de sincronismo
signal s_6              : std_logic := '0';
signal s_25             : std_logic := '0';

-- Propagates syncs extern
signal sync_out   : std_logic;


    -- Counters
    signal time_pulse_counter : integer range 0 to ((2**31) - 1) := 0; -- time pulse duration
    signal time_inter_counter : integer range 0 to ((2**31) - 1) := 0; -- time inter pulses
    signal total_sync_counter : integer range 0 to ((2**24) - 1) := 0; -- total sync numbers
    signal local_sync_counter : integer range 0 to ((2**24) - 1) := 0; -- local sync numbers (top 6 ou top 25)

    -- Sinal de sincronismo interno/externo
    signal s_sync       : std_logic := '0';   -- sync detected  
    signal s_syncf      : std_logic := '0';   -- sync forced via uC

begin

process(clk, reset)

begin
    if (reset = '1') then
        
        Reg_Sync(0) <= std_logic_vector(to_unsigned(1, 32));    -- Modo de operação
                                                                -- bit 0 : On/OFF
                                                                -- bit 1 : Internal single
                                                                -- bit 2 : Internal astable
                                                                -- bit 3 : External 
                                                                -- bit 4 : Propagate sync
        Reg_Sync(1) <= std_logic_vector(to_unsigned(625, 32));  -- Duração do pulso em CLKs
        Reg_Sync(2) <= std_logic_vector(to_unsigned(625, 32));  -- Periodo do pulso em CLKs        
        Reg_Sync(3) <= std_logic_vector(to_unsigned(1, 32));    -- in astable mode, generate n syncs (n X númebers of syncs)

        Reg_Sync(4) <= std_logic_vector(to_unsigned(0, 32));    -- total syncs counter (write -> rsts counter, read) and local sync counter
        Reg_Sync(5) <= (others => '0');                         -- Força Sync
                                                                   
        -- rst vars 
        time_pulse_counter   <= 0;
        time_inter_counter   <= 0;
        total_sync_counter   <= 0;
        local_sync_counter   <= 0;
        s_syncf              <= '0';                                       
        sync_out             <= '0';
        s_25                 <= '0';
        s_6                  <= '0';
        IRQ_Sync             <= '0';

    elsif(rising_edge(clk)) then

   
        --------------------------
        -- Leitura do registrador
        --------------------------

        if(avs_s0_read = '1') then
            avs_s0_readdata <= Reg_Sync(to_integer(unsigned(avs_s0_address)));
    
            -- reading on the sync ounter resets IRQ
            if(to_integer(unsigned(avs_s0_address)) = 4) then 
                IRQ_sync <= '0';
            end if;

        else
            avs_s0_readdata <= (others => '0');
        end if;

        --------------------------
        -- Sync PULSE internal is one clock wide
        -------------------------- 
        s_25 <= '0';
        s_6  <= '0';
        
        --------------------------
        -- Escrita no registrador
        --------------------------
        
        if(avs_s0_write = '1') then
            -- checks if is to force sync
            if(to_integer(unsigned(avs_s0_address)) = 5) then
                if avs_s0_writedata(0) = '1' then
                    s_syncf <= '1';
                else
                    s_syncf <= '0';
                end if;

            -- rst sync counter
            elsif (to_integer(unsigned(avs_s0_address)) = 4) then 
                Reg_Sync(3) <= (others => '0'); 

            -- return data
            else 
                Reg_Sync(to_integer(unsigned(avs_s0_address))) <= avs_s0_writedata;
            end if;
        end if;

        --------------------------
        -- Generate sync
        --------------------------
        if(s_syncf = '1' AND Reg_Sync(0)(0) = '1') then
           s_sync   <= '1';
           s_syncf  <= '0';

           -- external sync out
           sync_out <= '1';

           -- IRQ out
           IRQ_sync <= '1';

           -- update local sync counter
           local_sync_counter <= local_sync_counter + 1;

           -- generates pulse on the correct sync and IRQ
           if(local_sync_counter = 0) then
               s_25 <= '1';
               s_6  <= '0';
           elsif(local_sync_counter < to_integer(unsigned(Reg_Sync(3)))) then
               s_25 <= '0';
               s_6  <= '1';
           else
               local_sync_counter <= 1;
               s_25 <= '1';
               s_6  <= '0';
           end if;

           -- atualiza registrador com nÃºmero total de syncs;
           Reg_Sync(4)(23 downto 0)  <= std_logic_vector(unsigned(Reg_Sync(4)(23 downto 0)) + x"01");
           Reg_Sync(4)(31 downto 24) <= std_logic_vector(to_unsigned(local_sync_counter,8));
        end if;

        --------------------------
        -- Sync Astable
        --------------------------
        if(Reg_Sync(0)(2) = '1') then
            time_inter_counter <= time_inter_counter + 1;
            
            if(time_inter_counter >= to_integer(unsigned(Reg_Sync(2)))) then
                time_inter_counter  <= 0;
                s_syncf             <= '1';
            end if;
        end if;

        --------------------------
        -- Sync PULSE
        --------------------------
        if(s_sync = '1') then
            -- generates pulse width
            if(time_pulse_counter < to_integer(unsigned(Reg_Sync(1)))) then
                time_pulse_counter <= time_pulse_counter + 1;
            else
                sync_out <= '0';
                s_sync  <= '0';
                time_pulse_counter <= 0;
            end if;
        end if;
       
    end if;
end process;

-- TODO version 0.9    
-- Sync intenal 
--s_sync <= Internal_sync_in when Reg_Sync(0)(1) = '1' AND Reg_Sync(2)(0) = '1' else
--          Extern_sync_in   when Reg_Sync(0)(3) = '1' AND Reg_Sync(2)(0) = '1' else
--          '0';


-- Popaga Sync Externo
Extern_sync_out <= s_sync    	  when Reg_Sync(0)(1) = '1' OR Reg_Sync(0)(2) = '1' else
                   Extern_sync_in when Reg_Sync(0)(3) = '1' else
                   '0';

Sync_A <= s_25 & s_6; 
Sync_B <= s_25 & s_6; 
Sync_C <= s_25 & s_6; 
Sync_D <= s_25 & s_6; 
Sync_E <= s_25 & s_6; 
Sync_F <= s_25 & s_6; 
Sync_G <= s_25 & s_6; 
Sync_H <= s_25 & s_6; 

avs_s0_waitrequest <= '0';


end architecture rtl; -- of RMAP_SPW



