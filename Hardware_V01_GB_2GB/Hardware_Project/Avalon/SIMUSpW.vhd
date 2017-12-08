library STD;
use STD.textio.all;                     -- basic I/Ouse 

library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.spwpkg.all;
use IEEE.std_logic_textio.all;          -- I/O for logic types

entity SIMUSpW  is
    port(
        -- Global
        clock_codec  : in std_logic;
        clock_avalon : in std_logic;
        rst          : in std_logic;

        -- Avalon 
        avs_s0_address     : in  std_logic_vector(7 downto 0)  := (others => '0'); -- s0.address
        avs_s0_read        : in  std_logic                     := '0';             -- .read
        avs_s0_readdata    : out std_logic_vector(31 downto 0);                    -- .readdata
        avs_s0_write       : in  std_logic                     := '0';             -- .write
        avs_s0_writedata   : in  std_logic_vector(31 downto 0) := (others => '0'); -- .writedata
        avs_s0_waitrequest : out std_logic;   

        -- SpW
        spw_so   : out std_logic; --si
        spw_si   : in  std_logic; --so
        spw_do   : out std_logic; --di
        spw_di   : in  std_logic  --do

        );
end SIMUSpW;

architecture read_from_file of SIMUSpW is

   CONSTANT EOP : std_logic_vector := '1' & x"00";
   CONSTANT EEP : std_logic_vector := '1' & x"01";

   CONSTANT memSize : NATURAL := 19; 
   TYPE mem IS ARRAY (0 TO memSize) OF std_logic_vector(8 downto 0);

   -- Target SpW address (non)
   -- Protocol ID
   -- Instuction
    -- 0 | 1 | 1 | Verify | Reply | Increment | Reply Address Length
   -- KEY
   -- REPLY ADDRESS (NON)
   -- Initiator Logical Address
   -- Transaction ID MSB
   -- Transaction ID LSB
   -- Extende Address
   -- Address (MS)
   -- Address
   -- Address
   -- Address (LS)
   -- Data Length (MS)
   -- Data Length
   -- Data Length (LS)
   -- Header CRC
   -- DATA
   -- DATA
   -- ..
   -- DATA CRC
   -- EOP
   CONSTANT memWriteNonVerifyNonAck : mem := (
    0  => '0' & x"01",       -- Logical ID
    1  => '0' & x"01",       -- RMAP ID
    2  => '0' & "01100000",  -- Write non verify non ack
    3  => '0' & x"01",       -- KEY
    4  => '0' & x"01",       -- Logical initiator address
    5  => '0' & x"12",       -- Transaction ID MSB
    6  => '0' & x"34",       -- Transaction ID LSB
    7  => '0' & x"00",       -- Extende Address
    8  => '0' & x"00",       -- Address (MS)
    9  => '0' & x"00",       -- Address
    10 => '0' & x"00",       -- Address
    11 => '0' & x"00",       -- Address (LS)
    12 => '0' & x"00",       -- Data Length (MS)
    13 => '0' & x"00",       -- Data Length
    14 => '0' & x"02",       -- Data Length (LS)
    15 => '0' & x"FF",        -- Header CRC
    16 => '0' & x"AB",       -- Data 0
    17 => '0' & x"FC",       -- Data 1
    18 => '0' & x"00",       -- Data CRC
    19 => '1' & x"00"        -- EOP
   );

    TYPE   STATE_TYPE IS (s0, s1, s2, s3, s3n, s3m, c1, c2, c3,
	             		 s4, s5, s6, s6d, s7, s7d, s8, s8d, s9,
			 s9d, s10, s10d, s11, s11d, s12, s12d ,
 			 s13, s13d, s14, s14d, s15, s15d);
    SIGNAL state   : STATE_TYPE := s0;


    signal autostart:   std_logic := '1';
    signal linkstart:   std_logic := '1';
    signal linkdis:     std_logic := '0';
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
    signal txdivcnt:    std_logic_vector(7 downto 0) := X"02";

    signal tick_in     : std_logic := '0';
    signal ctrl_in     : std_logic_vector(1 downto 0);
    signal time_in     : std_logic_vector(5 downto 0);

    signal tick_out    : std_logic;
    signal ctrl_out    : std_logic_vector(1 downto 0);
    signal time_out    : std_logic_vector(5 downto 0);

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


begin
-----------------------------------------
-- Codec
-----------------------------------------
codec1 : spwstream 
	GENERIC MAP(
        sysfreq     => 200_000_000.0,
        txclkfreq   => 200_000_000.0,
        rximpl      => impl_generic,
        tximpl      => impl_generic,
        rxchunk          => 1,
        rxfifosize_bits  => 11,
        txfifosize_bits  => 4
	)
	PORT MAP(
        clk 		=> clock_codec,
        rxclk		=> clock_codec,
        txclk		=> clock_codec,
        rst 		=> rst,

        autostart  => '1', 
        linkstart  => '1', 
        linkdis    => '0' , 
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

read: process(clock_codec)
begin
    if(rising_edge(clock_codec)) then
        if((running = '1') AND (rxvalid = '1')) then
            rxread <= '1';
        else
            rxread <= '0';
        end if;
     end if;
end process;

write : process(clock_codec)
    variable pcount : natural := 0;
    begin
        if(rising_edge(clock_codec)) then
            if((running = '1') AND (txrdy = '1')) THEN
            CASE state IS
                when s0 =>
                    --if(pcount <= memSize) then
                    if(pcount <= 3) then
                        txwrite <= '1';
                        txwrite <= '1';
                        txdata  <= memWriteNonVerifyNonAck(pcount)(7 downto 0);
                        txflag  <= memWriteNonVerifyNonAck(pcount)(8);
                        pcount  := pcount + 1;
                        state   <= s1;
                    else
                        txwrite <= '0';
                        state   <= s0;
                    end if;

                when s1 =>
                    txwrite <= '0';
                    state   <= s0;

                when others =>
                    state <= s0; 
            end case;
                                 
            else                 
                txwrite <= '0';  
            end if;              
        end if;
    end process;
end; 
