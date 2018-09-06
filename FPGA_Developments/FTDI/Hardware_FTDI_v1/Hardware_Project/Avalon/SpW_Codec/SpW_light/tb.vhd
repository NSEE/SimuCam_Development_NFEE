library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.spwpkg.all;


entity tb is
end entity;

architecture bhv of tb is


component streamtest is

  generic (
        -- System clock frequency in Hz.
        -- This must be set to the frequency of "clk". It is used to setup
        -- counters for reset timing, disconnect timeout and to transmit
        -- at 10 Mbit/s during the link handshake.
        sysfreq:        real;

        -- Transmit clock frequency in Hz (only if tximpl = impl_fast).
        -- This must be set to the frequency of "txclk". It is used to
        -- transmit at 10 Mbit/s during the link handshake.
        txclkfreq:      real := 0.0;

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
-- Registros 
-----------------------------------------
type regs_type is record

    autostart:   std_logic;
    linkstart:   std_logic;
    linkdis:     std_logic;
    txdivcnt:    std_logic_vector(7 downto 0);
    tick_in:     std_logic;
    ctrl_in:     std_logic_vector(1 downto 0);
    time_in:     std_logic_vector(5 downto 0);
    txwrite:     std_logic;
    txflag:      std_logic;
    txdata:      std_logic_vector(7 downto 0);
    rxread:      std_logic;
end record;

   signal  started:     std_logic;
   signal  connecting:  std_logic;
   signal  running:     std_logic;
   signal  errdisc:     std_logic;
   signal  errpar:      std_logic;
   signal  erresc:      std_logic;
   signal  errcred:     std_logic;
   signal  rxdata:      std_logic_vector(7 downto 0);
   signal txrdy:       std_logic;
   signal txhalff:     std_logic;
   signal tick_out:    std_logic;
   signal ctrl_out:    std_logic_vector(1 downto 0);
   signal time_out:    std_logic_vector(5 downto 0);
   signal rxvalid:     std_logic;
   signal rxhalff:     std_logic;
   signal rxflag:      std_logic;

   
constant regs_reset: regs_type := (
        autostart  => '0',
        linkstart  => '0',
        linkdis    => '0',
        txdivcnt   => (others => '0'),
        tick_in    => '0',
        ctrl_in    => (others => '0'),
        time_in    => (others => '0'),
        txwrite    => '0',
        txflag     => '0',
        txdata     => (others => '0'),
        rxread     => '0' 
);

signal r: regs_type := regs_reset;
signal rin : regs_type;

-----------------------------------------
-- Clock e reset 
-----------------------------------------
signal clk 		    : std_logic := '0';
signal rst 		    : std_logic := '0';

constant half_period : time := 0.1 ns;

-----------------------------------------
-- Sinais externos LVDS
-----------------------------------------
signal spw_si       : std_logic;
signal spw_so 	    : std_logic;
signal spw_di       : std_logic;
signal spw_do	    : std_logic;


-----------------------------------------
-- Estrutural 
-----------------------------------------
BEGIN

-----------------------------------------
-- Codec
-----------------------------------------
tb1 : spwstream 
	GENERIC MAP(
		sysfreq => 10_000_000.0
	)
	PORT MAP(
		clk 		=> clk,
		rxclk		=> clk,
		txclk		=> clk,
		rst 		=> rst,

        autostart  => r.autostart, 
        linkstart  => r.linkstart, 
        linkdis    => r.linkdis  , 
        txdivcnt   => r.txdivcnt ,  
        tick_in    => r.tick_in  , 
        ctrl_in    => r.ctrl_in  ,  
        time_in    => r.time_in  ,  
        txwrite    => r.txwrite  , 
        txflag     => r.txflag   , 
        txdata     => r.txdata   ,  
        txrdy      => txrdy    , 
        txhalff    => txhalff  , 
        tick_out   => tick_out , 
        ctrl_out   => ctrl_out ,   
        time_out   => time_out ,  
        rxvalid    => rxvalid  , 
        rxhalff    => rxhalff  , 
        rxflag     => rxflag   , 
        rxdata     => rxdata   ,  
        rxread     => r.rxread   , 
        started    => started  , 
        connecting => connecting,
        running    => running  , 
        errdisc    => errdisc  , 
        errpar     => errpar   , 
        erresc     => erresc   , 
        errcred    => errcred  , 
		
		spw_di	   	=> spw_di,
		spw_do		=> spw_do,

		spw_si		=> spw_si,
		spw_so		=> spw_so
);

-----------------------------------------
-- LoopBack
-----------------------------------------
	--	sendtick	=> sendtick,
spw_di <= spw_do;
spw_si <= spw_so;

-----------------------------------------
-- Clock generator
-----------------------------------------
clk1 : process
BEGIN
	clk <= not clk;
	wait for half_period;
	clk <= not clk;
	wait for half_period;
END PROCESS;

-----------------------------------------
-- Reset generator 
-----------------------------------------
rst1 : process
begin
	rst <= '1';
	wait for half_period*100;
	rst <= '0';
	wait;
end process;

-----------------------------------------
-- Data generator
-----------------------------------------
dado : process(r, rst) is
    variable v : regs_type;
    variable status : std_logic;
    variable cnt    : std_logic_vector(7 downto 0) := (others => '0');
    begin
        -- Atualiza variável
        v := r;

        -- Ativa link
        v.linkstart := '1';
        v.autostart := '1';
        
        -- atualiza variavel de status
        -- 1 link ok
        -- 0 link off
        status :=  (started nand connecting) and running;

        if(running = '1') then
            -- checa se o codec esta pronto para enviar n-chars
            if txrdy = '1' then
                v.txdata := std_logic_vector(unsigned(v.txdata) + to_unsigned(1, 7));
                v.txwrite := '1';
            else
                v.txwrite := '0';
            end if;
        end if;
        -- Synchronous reset.
        if rst = '1' then
            v := regs_reset;
        end if;

        -- Atualiza registrador
        rin <= v;
    end process;

    atualiza : process(clk) is
    begin
        if rising_edge(clk) then
            r <= rin;
        end if;
    end process;


end bhv;
