
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
--  Bloco utilziado para controlar o Codec Spw e adapatar no RMAP e nos registradores
--  
--Funcionalidade
-- Transformar a FIFO do codec em uma autonomous FIFO (escrita e leitura)
-- Mapear as portas de configuração para o mapa de registradores (para poder
-- ser acessado via up/ Barramento)
--
-- TODO
--  o Gerar duas autonomous fifo via a fifo atual
--  o Mapear o controle para os registradores
--------------------------------------------------------------------------------

-- Bibliotecas
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.spwpkg.all;
--use work.all;

-- SpW Light Codec

entity Codec_Controller is
	generic (
        -- System clock frequency in Hz.
        -- This must be set to the frequency of "clk". It is used to setup
        -- counters for reset timing, disconnect timeout and to transmit
        -- at 10 Mbit/s during the link handshake.
        sysfreq:        real := 10_000_000.0;

        -- Transmit clock frequency in Hz (only if tximpl = impl_fast).
        -- This must be set to the frequency of "txclk". It is used to
        -- transmit at 10 Mbit/s during the link handshake.
        txclkfreq:      real := 100_000_000.0;

        -- Selection of a receiver front-end implementation.
        rximpl:         spw_implementation_type := impl_fast;

        -- Maximum number of bits received per system clock
        -- (must be 1 in case of impl_generic).
        rxchunk:        integer range 1 to 4 := 1;

        -- Selection of a transmitter implementation.
        tximpl:         spw_implementation_type := impl_generic;

        -- Size of the receive FIFO as the 2-logarithm of the number of bytes.
        -- Must be at least 6 (64 bytes).
        rxfifosize_bits: integer range 6 to 14 := 11;

        -- Size of the transmit FIFO as the 2-logarithm of the number of bytes.
        txfifosize_bits: integer range 2 to 14 := 4

	);

	port(
	
        -- Global
	    clk_codec	 : in std_logic;
        clk_avalon   : in std_logic;
	    MainReset	 : in std_logic;
	
        -- Synchronous reset Sync FIFO (active-high).
        rst_fifo     : in  std_logic;	
   
        -- Sinais externos LVDS
        spw_si       : in  std_logic;
        spw_so 	     : out std_logic;
        spw_di       : in  std_logic;
        spw_do	     : out std_logic;

        -- Status CODEC
        codec_status : out std_logic_vector(10 downto 0);
        
        -- Controller Codec
        codec_ctr   : in  std_logic_vector(7 downto 0);    

        -- TX clk divid rate
        txdivcnt    : in std_logic_vector(7 downto 0);

        -- ADC Rate in 0.01 ns
        ADC_DELAY   : in std_logic_vector(15 downto 0);

        -- Input TC
        tick_in     : in std_logic;
        ctrl_in     : in std_logic_vector(1 downto 0);
        time_in     : in std_logic_vector(5 downto 0);

        -- Output TC
        tick_out    : out std_logic;
        ctrl_out    : out std_logic_vector(1 downto 0);
        time_out    : out std_logic_vector(5 downto 0);
     
        -- Output FIFO Write
        nwrite       : in  std_logic;
        full         : out std_logic;
        din          : in  std_logic_vector(8 downto 0);

        -- Input FIFO READ
        spw_fifo_r_dout  : out std_logic_vector(8 downto 0);
        spw_fifo_r_empty : out std_logic;
        spw_fifo_r_read  : in  std_logic

	);
end entity;

architecture bhv of Codec_Controller is


    component spwstream is
    generic (
        -- System clock frequency in Hz.
        -- This must be set to the frequency of "clk". It is used to setup
        -- counters for reset timing, disconnect timeout and to transmit
        -- at 10 Mbit/s during the link handshake.
        sysfreq:        real;

        -- Transmit clock frequency in Hz (only if tximpl = impl_fast).
        -- This must be set to the frequency of "txclk". It is used to
        -- transmit at 10 Mbit/s during the link handshake.
        txclkfreq:      real := 10_000_000.0;

        -- Selection of a receiver front-end implementation.
        rximpl:         spw_implementation_type := impl_generic;

        -- Maximum number of bits received per system clock
        -- (must be 1 in case of impl_generic).
        rxchunk:        integer range 1 to 4 := 1;

        -- Selection of a transmitter implementation.
        tximpl:         spw_implementation_type := impl_generic;

        -- Size of the receive FIFO as the 2-logarithm of the number of bytes.
        -- Must be at least 6 (64 bytes).
        rxfifosize_bits: integer range 6 to 14 := 11;

        -- Size of the transmit FIFO as the 2-logarithm of the number of bytes.
        txfifosize_bits: integer range 2 to 14 := 11
    );

    port (
        -- System clock.
        clk:        in  std_logic;

        -- Receiver sample clock (only for impl_fast)
        rxclk:      in  std_logic;

        -- Transmit clock (only for impl_fast)
        txclk:      in  std_logic;

        -- Synchronous reset (active-high).
        rst:        in  std_logic;

        
        -- Enables automatic link start on receipt of a NULL character.
        autostart:  in  std_logic;

        -- Enables link start once the Ready state is reached.
        -- Without autostart or linkstart, the link remains in state Ready.
        linkstart:  in  std_logic;

        -- Do not start link (overrides linkstart and autostart) and/or
        -- disconnect a running link.
        linkdis:    in  std_logic;

        -- Scaling factor minus 1, used to scale the transmit base clock into
        -- the transmission bit rate. The system clock (for impl_generic) or
        -- the txclk (for impl_fast) is divided by (unsigned(txdivcnt) + 1).
        -- Changing this signal will immediately change the transmission rate.
        -- During link setup, the transmission rate is always 10 Mbit/s.
        txdivcnt:   in  std_logic_vector(7 downto 0);

        -- High for one clock cycle to request transmission of a TimeCode.
        -- The request is registered inside the entity until it can be processed.
        tick_in:    in  std_logic;

        -- Control bits of the TimeCode to be sent. Must be valid while tick_in is high.
        ctrl_in:    in  std_logic_vector(1 downto 0);

        -- Counter value of the TimeCode to be sent. Must be valid while tick_in is high.
        time_in:    in  std_logic_vector(5 downto 0);

        -- Pulled high by the application to write an N-Char to the transmit
        -- queue. If "txwrite" and "txrdy" are both high on the rising edge
        -- of "clk", a character is added to the transmit queue.
        -- This signal has no effect if "txrdy" is low.
        txwrite:    in  std_logic;

        -- Control flag to be sent with the next N_Char.
        -- Must be valid while txwrite is high.
        txflag:     in  std_logic;

        -- Byte to be sent, or "00000000" for EOP or "00000001" for EEP.
        -- Must be valid while txwrite is high.
        txdata:     in  std_logic_vector(7 downto 0);

        -- High if the entity is ready to accept an N-Char for transmission.
        txrdy:      out std_logic;

        -- High if the transmission queue is at least half full.
        txhalff:    out std_logic;

        -- High for one clock cycle if a TimeCode was just received.
        tick_out:   out std_logic;

        -- Control bits of the last received TimeCode.
        ctrl_out:   out std_logic_vector(1 downto 0);

        -- Counter value of the last received TimeCode.
        time_out:   out std_logic_vector(5 downto 0);

        -- High if "rxflag" and "rxdata" contain valid data.
        -- This signal is high unless the receive FIFO is empty.
        rxvalid:    out std_logic;

        -- High if the receive FIFO is at least half full.
        rxhalff:    out std_logic;

        -- High if the received character is EOP or EEP; low if the received
        -- character is a data byte. Valid if "rxvalid" is high.
        rxflag:     out std_logic;

        -- Received byte, or "00000000" for EOP or "00000001" for EEP.
        -- Valid if "rxvalid" is high.
        rxdata:     out std_logic_vector(7 downto 0);

        -- Pulled high by the application to accept a received character.
        -- If "rxvalid" and "rxread" are both high on the rising edge of "clk",
        -- a character is removed from the receive FIFO and "rxvalid", "rxflag"
        -- and "rxdata" are updated.
        -- This signal has no effect if "rxvalid" is low.
        rxread:     in  std_logic;

        -- High if the link state machine is currently in the Started state.
        started:    out std_logic;

        -- High if the link state machine is currently in the Connecting state.
        connecting: out std_logic;

        -- High if the link state machine is currently in the Run state, indicating
        -- that the link is fully operational. If none of started, connecting or running
        -- is high, the link is in an initial state and the transmitter is not yet enabled.
        running:    out std_logic;

        -- Disconnect detected in state Run. Triggers a reset and reconnect of the link.
        -- This indication is auto-clearing.
        errdisc:    out std_logic;

        -- Parity error detected in state Run. Triggers a reset and reconnect of the link.
        -- This indication is auto-clearing.
        errpar:     out std_logic;

        -- Invalid escape sequence detected in state Run. Triggers a reset and reconnect of
        -- the link. This indication is auto-clearing.
        erresc:     out std_logic;

        -- Credit error detected. Triggers a reset and reconnect of the link.
        -- This indication is auto-clearing.
        errcred:    out std_logic;

        -- Data In signal from SpaceWire bus.
        spw_di:     in  std_logic;

        -- Strobe In signal from SpaceWire bus.
        spw_si:     in  std_logic;

        -- Data Out signal to SpaceWire bus.
        spw_do:     out std_logic;

        -- Strobe Out signal to SpaceWire bus.
        spw_so:     out std_logic
    );
    end component;

-----------------------------------------
-- Sync FIFO
-----------------------------------------
    component fifo_codec
        PORT
        (
            aclr        : IN STD_LOGIC;
            data		: IN STD_LOGIC_VECTOR (8 DOWNTO 0);
            rdclk		: IN STD_LOGIC ;
            rdreq		: IN STD_LOGIC ;
            wrclk		: IN STD_LOGIC ;
            wrreq		: IN STD_LOGIC ;
            q		    : OUT STD_LOGIC_VECTOR (8 DOWNTO 0);
            rdempty		: OUT STD_LOGIC ;
            wrfull		: OUT STD_LOGIC;
	        wrusedw		: OUT STD_LOGIC_VECTOR (1 DOWNTO 0)
        );
    end component;

-----------------------------------------
-- Registros 
-----------------------------------------

   signal autostart:   std_logic;
   signal linkstart:   std_logic;
   signal linkdis:     std_logic;

   signal started:     std_logic;
   signal connecting:  std_logic;
   signal running:     std_logic;
   signal errdisc:     std_logic;
   signal errpar:      std_logic;
   signal erresc:      std_logic;
   signal errcred:     std_logic;
     
   signal txwrite:     std_logic;
   signal txflag:      std_logic;
   signal txdata:      std_logic_vector(7 downto 0);
   signal rxread:      std_logic;

   signal rxdata:      std_logic_vector(7 downto 0);
   signal txrdy:       std_logic;
   signal txhalff:     std_logic;
   signal rxvalid:     std_logic;
   signal rxhalff:     std_logic;
   signal rxflag:      std_logic := '0';
   
   -- Rst
   signal rst     :    std_logic; 

   -- rst fifo
   signal rst_fifo_global : std_logic;
   
   -- Autonomous fifo 
   signal empty_i :    std_logic := '1';
   
   -- Sync Fifo Status
   signal syncFifoWused :  std_logic_vector(1 downto 0); 
   signal SyncFifoWriteQ        : std_logic_vector(8 downto 0);
   SIGNAL SyncFifoWriteEmpty, SyncFifoWriteRReq, SyncFifoWriteWReq, wr_en, nread_S, nwrite_S  : STD_LOGIC;
   signal SyncFifoData : std_logic_vector(8 downto 0);

   signal SyncFifoReadRReq, SyncFifoReadFull, SyncFifoReadWReq : STD_LOGIC;

   signal delay_en  : std_logic;
   
   type state_type is (s0,s1);  --type of state machine.
   signal state_c: state_type;  --current and next state declaration.
   signal state_r: state_type;  --current and next state declaration.





Begin

-----------------------------------------
-- Codec
-----------------------------------------
codec1 : spwstream 
	GENERIC MAP(
        sysfreq     => sysfreq,
        txclkfreq   => txclkfreq,
        rximpl      => rximpl,
        tximpl      => tximpl,
        rxchunk          => rxchunk,
        rxfifosize_bits  => rxfifosize_bits,
        txfifosize_bits  => txfifosize_bits
	)
	PORT MAP(
        clk 		=> clk_codec,
        rxclk		=> clk_codec,
        txclk		=> clk_codec,
        rst 		=> rst,

        autostart  => autostart, 
        linkstart  => linkstart, 
        linkdis    => linkdis  , 
        txdivcnt   => txdivcnt ,  

        tick_in    => tick_in  , 
        ctrl_in    => ctrl_in  ,  
        time_in    => time_in  ,  
        
        txwrite    => txwrite  , 
        txflag     => txflag   , 
        txdata     => txdata   ,  
        txrdy      => txrdy    , 
        txhalff    => txhalff  , 
        
        tick_out   => tick_out , 
        ctrl_out   => ctrl_out ,   
        time_out   => time_out ,  
        
        rxvalid    => rxvalid  , 
        rxhalff    => rxhalff  , 
        rxflag     => rxflag   , 
        rxdata     => rxdata   ,  
        rxread     => rxread   , 
        
        started    => started  , 
        connecting => connecting,
        running    => running  , 
        errdisc    => errdisc  , 
        errpar     => errpar   , 
        erresc     => erresc   , 
        errcred    => errcred  , 
		
        spw_di 	=> spw_di,
        spw_do	=> spw_do,
        spw_si	=> spw_si,
        spw_so	=> spw_so
);


 -----------------------------
 -- Rst
 -----------------------------
 rst <= MainReset; 

 rst_fifo_global <= MainReset OR rst_fifo;

-----------------------------
 -- Dual port FIFO 
 -----------------------------
SyncFifoWriteWReq <= not nwrite;

fifo_write : fifo_codec 
    PORT MAP (
        aclr     => rst_fifo_global,
		data	 => din,
		rdclk	 => clk_codec,
		rdreq	 => SyncFifoWriteRReq,
		wrclk	 => clk_avalon,
		wrreq	 => SyncFifoWriteWReq,
		q	     => SyncFifoWriteQ,
		rdempty	 => SyncFifoWriteEmpty,
		wrfull	 => full,
		wrusedw	 => syncFifoWused
);
 
fifo_read : fifo_codec 
    PORT MAP (
        aclr     => rst_fifo_global,

		wrclk	 => clk_codec,
		data	 => SyncFifoData,
		wrreq	 => SyncFifoReadWReq, 
		wrfull	 => SyncFifoReadFull,
		wrusedw	 => OPEN,   

		rdclk	 => clk_avalon,
		rdempty	 => spw_fifo_r_empty,
		rdreq	 => spw_fifo_r_read,
		q	     => spw_fifo_r_dout
);

fifoREADWrite : process(clk_codec)
begin
    if(RISING_EDGE(clk_codec)) then
        if(rst_fifo_global = '1') then
            state_r          <= s0;
            SyncFifoReadWReq <= '0';
            rxread           <= '0';
        else
            case state_r is
                when s0 =>
                    if((rxvalid = '1') AND (SyncFifoReadFull = '0')) then
                        rxread           <= '1';
                        SyncFifoReadWReq <= '1';
                        state_r          <= s1;
                    else
                        rxread           <= '0';
                        SyncFifoReadWReq <= '0';
                        state_r          <= s0;
                    end if;

                when s1 =>
                        rxread           <= '0';
                        SyncFifoReadWReq <= '0';
                        state_r          <= s0;
                end case;
        end if;
    end if;
end process;

process(clk_codec)
begin
    if(RISING_EDGE(clk_codec)) then
        if(rst_fifo_global = '1') then
            state_c <= s0;
            SyncFifoWriteRReq   <= '0';
            wr_en   <= '0';
        else
            case state_c is
                when s0 =>
                    wr_en <= '0';
                    if((SyncFifoWriteEmpty = '0') AND (delay_en = '1') AND (txrdy = '1')) then
                        state_c <= s1;
                        SyncFifoWriteRReq   <= '1';
                    else
                        state_c <= s0;
                        SyncFifoWriteRReq   <= '0';
                    end if;
            
                when s1 =>
                    SyncFifoWriteRReq     <= '0';
                    if(txrdy = '1') then
                        wr_en     <= '1';
                        state_c   <= s0;
                    else
                        wr_en     <= '0';
                        state_c   <= s1;
                    end if;
                 
                when others =>
                    state_C   <= s0;
                    SyncFifoWriteRReq     <= '0';
                    wr_en     <= '0';
       end case;
      end if;
    end if;
end process;

 -- contador

 PROCESS(clk_codec)
     variable cnt_delay : natural range 0 to (2**ADC_DELAY'left - 1);
 
 BEGIN
     IF RISING_EDGE(clk_codec) THEN
       IF (rst = '1') THEN
         cnt_delay := 0;
         delay_en <= '0';
       ELSE
         IF (cnt_delay < to_integer(unsigned(ADC_DELAY))) THEN
             cnt_delay := cnt_delay + 1;
             delay_en  <= '0';
         ELSE
             IF((SyncFifoWriteEmpty = '0') AND (delay_en = '1') AND (txrdy = '1')) then
                 cnt_delay := 0;
                 delay_en <= '0';
             else
                 delay_en <= '1';
             end if;
         end if;   
       END IF;
     END IF;
 END PROCESS;


-----------------------------
 -- TX FIFO 
 -----------------------------
  SyncFifoData <= rxflag & rxdata;

  -- Codec
  txflag  <= SyncFifoWriteQ(8);              -- n char
  txdata  <= SyncFifoWriteQ(7 downto 0);     -- data
  txwrite <= wr_en;



 -----------------------------
 -- RX FIFO 
 -----------------------------
 
 -- Dado concatenado de EOP e Nchar
 -- Se rxflag = 1 -> EOP/EEP
 -- se rxflag = 0 -> nchar
 --dout   <= rxflag & rxdata; 
 --rxread <= not(nread);
 --empty  <= not rxvalid;


 ------------------------------------------------------
 --  Codec Status & Controller 
 ------------------------------------------------------

 codec_status <= syncFifoWused  &    -- 2 bits
                 txhalff        &    -- 1 bit
                 rxhalff        &    -- 1 bit
                 started        & 
                 connecting     & 
                 running        &
                 errdisc        &
                 errpar         &
                 erresc         &
                 errcred;

 autostart <= codec_ctr(0);
 linkstart <= codec_ctr(1);
 linkdis   <= codec_ctr(2);

end bhv;




