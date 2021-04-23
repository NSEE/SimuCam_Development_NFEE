library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.nrme_rmap_mem_area_nfee_pkg.all;
use work.nrme_avalon_mm_rmap_nfee_pkg.all;

entity nrme_rmap_mem_area_nfee_read_ent is
    port(
        clk_i               : in  std_logic;
        rst_i               : in  std_logic;
        fee_rmap_i          : in  t_nrme_nfee_rmap_read_in;
        avalon_mm_rmap_i    : in  t_nrme_avalon_mm_rmap_nfee_read_in;
        memarea_idle_i      : in  std_logic;
        memarea_rdvalid_i   : in  std_logic;
        memarea_rddata_i    : in  std_logic_vector(31 downto 0);
        rmap_registers_wr_i : in  t_rmap_memory_wr_area;
        rmap_registers_rd_i : in  t_rmap_memory_rd_area;
        fee_rmap_o          : out t_nrme_nfee_rmap_read_out;
        avalon_mm_rmap_o    : out t_nrme_avalon_mm_rmap_nfee_read_out;
        memarea_rdaddress_o : out std_logic_vector(5 downto 0);
        memarea_read_o      : out std_logic
    );
end entity nrme_rmap_mem_area_nfee_read_ent;

architecture RTL of nrme_rmap_mem_area_nfee_read_ent is

    signal s_read_started     : std_logic;
    signal s_read_in_progress : std_logic;
    signal s_read_finished    : std_logic;

begin

    p_nrme_rmap_mem_area_nfee_read : process(clk_i, rst_i) is
        --
        procedure p_rmap_ram_rd(
            constant RMAP_ADDRESS_I   : in std_logic_vector;
            signal rmap_waitrequest_o : out std_logic;
            variable rmap_readdata_o  : out std_logic_vector
        ) is
        begin
            memarea_rdaddress_o <= (others => '0');
            memarea_read_o      <= '0';
            -- check if a read was finished    
            if (s_read_finished = '1') then
                -- a read was finished
                -- read the memory data
                rmap_readdata_o((memarea_rddata_i'length - 1) downto 0) := memarea_rddata_i;
                -- keep setted the read finished flag
                s_read_finished                                         <= '1';
                -- keep cleared the waitrequest flag
                rmap_waitrequest_o                                      <= '0';
            else
                -- a read was not finished
                -- check if a read is not in progress and was not just started
                if ((s_read_in_progress = '0') and (s_read_started = '0')) then
                    -- a read is not in progress
                    -- check if the mem aerea is on idle (can receive commands)
                    if (memarea_idle_i = '1') then
                        -- the mem aerea is on idle (can receive commands)
                        -- send read to mem area
                        memarea_rdaddress_o <= RMAP_ADDRESS_I((memarea_rdaddress_o'length - 1) downto 0);
                        memarea_read_o      <= '1';
                        -- set the read started flag
                        s_read_started      <= '1';
                        -- set the read in progress flag
                        s_read_in_progress  <= '1';
                    end if;
                -- check if a read is in progress and was just started    
                elsif ((s_read_in_progress = '1') and (s_read_started = '1')) then
                    -- clear the read started flag
                    s_read_started     <= '0';
                    -- keep setted the read in progress flag
                    s_read_in_progress <= '1';
                -- check if a read is in progress and was not just started    
                elsif ((s_read_in_progress = '1') and (s_read_started = '0')) then
                    -- a read is in progress
                    -- keep setted the read in progress flag
                    s_read_in_progress <= '1';
                    -- check if the read data is valid
                    if ((memarea_rdvalid_i = '1') or (memarea_idle_i = '1')) then
                        -- the read data is valid
                        -- read the memory data
                        rmap_readdata_o((memarea_rddata_i'length - 1) downto 0) := memarea_rddata_i;
                        -- clear the read in progress flag
                        s_read_in_progress                                      <= '0';
                        -- set the read finished flag
                        s_read_finished                                         <= '1';
                        -- clear the waitrequest flag
                        rmap_waitrequest_o                                      <= '0';
                    end if;
                end if;
            end if;
        end procedure p_rmap_ram_rd;
        --
        procedure p_nfee_rmap_mem_rd(rd_addr_i : std_logic_vector) is
            variable v_ram_address  : std_logic_vector(5 downto 0)  := (others => '0');
            variable v_ram_readdata : std_logic_vector(31 downto 0) := (others => '0');
        begin

            -- MemArea Data Read
            case (rd_addr_i(31 downto 0)) is
                -- Case for access to all memory area

                when (x"00000000") =>
                    -- RMAP Area Config Register 0 : V End Config Field
                    v_ram_address       := "000000";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"00000001") =>
                    -- RMAP Area Config Register 0 : V End Config Field
                    v_ram_address       := "000000";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"00000002") =>
                    -- RMAP Area Config Register 0 : V Start Config Field
                    v_ram_address       := "000000";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"00000003") =>
                    -- RMAP Area Config Register 0 : V Start Config Field
                    v_ram_address       := "000000";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"00000004") =>
                    -- RMAP Area Config Register 1 : Charge Injection Gap Config Field
                    v_ram_address       := "000001";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"00000005") =>
                    -- RMAP Area Config Register 1 : Charge Injection Gap Config Field
                    v_ram_address       := "000001";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"00000006") =>
                    -- RMAP Area Config Register 1 : Charge Injection Width Config Field
                    v_ram_address       := "000001";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"00000007") =>
                    -- RMAP Area Config Register 1 : Charge Injection Width Config Field
                    v_ram_address       := "000001";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"00000008") =>
                    -- RMAP Area Config Register 2 : CCD Readout Order Config Field (1st CCD)
                    -- RMAP Area Config Register 2 : CCD Readout Order Config Field (2nd CCD)
                    -- RMAP Area Config Register 2 : CCD Readout Order Config Field (3rd CCD)
                    -- RMAP Area Config Register 2 : CCD Readout Order Config Field (4th CCD)
                    v_ram_address       := "000010";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"00000009") =>
                    -- RMAP Area Config Register 2 : Parallel Clock Overlap Config Field
                    v_ram_address       := "000010";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"0000000A") =>
                    -- RMAP Area Config Register 2 : Parallel Toi Period Config Field
                    -- RMAP Area Config Register 2 : Parallel Clock Overlap Config Field
                    v_ram_address       := "000010";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"0000000B") =>
                    -- RMAP Area Config Register 2 : Parallel Toi Period Config Field
                    v_ram_address       := "000010";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"0000000C") =>
                    -- RMAP Area Config Register 3 : H End Config Field
                    -- RMAP Area Config Register 3 : Charge Injection Enable Config Field
                    -- RMAP Area Config Register 3 : Tri Level Clock Enable Config Field
                    -- RMAP Area Config Register 3 : Image Clock Direction Config Field
                    -- RMAP Area Config Register 3 : Register Clock Direction Config Field
                    v_ram_address       := "000011";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"0000000D") =>
                    -- RMAP Area Config Register 3 : H End Config Field
                    v_ram_address       := "000011";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"0000000E") =>
                    -- RMAP Area Config Register 3 : N Final Dump Config Field
                    v_ram_address       := "000011";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"0000000F") =>
                    -- RMAP Area Config Register 3 : N Final Dump Config Field
                    v_ram_address       := "000011";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"00000010") =>
                    -- RMAP Area Config Register 4 : Internal Sync Period Config Field
                    v_ram_address       := "000100";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"00000011") =>
                    -- RMAP Area Config Register 4 : Internal Sync Period Config Field
                    v_ram_address       := "000100";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"00000012") =>
                    -- RMAP Area Config Register 4 : Data Packet Size Config Field
                    v_ram_address       := "000100";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"00000013") =>
                    -- RMAP Area Config Register 4 : Data Packet Size Config Field
                    v_ram_address       := "000100";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"00000014") =>
                    -- RMAP Area Config Register 5 : DG (Drain Gate) Enable Field
                    -- RMAP Area Config Register 5 : CCD Readout Enable Field
                    -- RMAP Area Config Register 5 : Conversion Delay Value
                    -- RMAP Area Config Register 5 : High Precison Housekeep Enable Field
                    v_ram_address       := "000101";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"00000015") =>
                    -- RMAP Area Config Register 5 : Trap Pumping Dwell Counter Field
                    -- RMAP Area Config Register 5 : Sync Source Selection Config Field
                    -- RMAP Area Config Register 5 : CCD Port Data Sensor Selection Config Field
                    -- RMAP Area Config Register 5 : Digitalise Enable Config Field
                    v_ram_address       := "000101";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"00000016") =>
                    -- RMAP Area Config Register 5 : Trap Pumping Dwell Counter Field
                    v_ram_address       := "000101";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"00000017") =>
                    -- RMAP Area Config Register 5 : Trap Pumping Dwell Counter Field
                    v_ram_address       := "000101";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"00000018") =>
                    -- RMAP Area Config Register 6 : CCD 1 Window List Pointer Config Field
                    v_ram_address       := "000110";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"00000019") =>
                    -- RMAP Area Config Register 6 : CCD 1 Window List Pointer Config Field
                    v_ram_address       := "000110";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"0000001A") =>
                    -- RMAP Area Config Register 6 : CCD 1 Window List Pointer Config Field
                    v_ram_address       := "000110";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"0000001B") =>
                    -- RMAP Area Config Register 6 : CCD 1 Window List Pointer Config Field
                    v_ram_address       := "000110";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"0000001C") =>
                    -- RMAP Area Config Register 7 : CCD 1 Packet Order List Pointer Config Field
                    v_ram_address       := "000111";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"0000001D") =>
                    -- RMAP Area Config Register 7 : CCD 1 Packet Order List Pointer Config Field
                    v_ram_address       := "000111";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"0000001E") =>
                    -- RMAP Area Config Register 7 : CCD 1 Packet Order List Pointer Config Field
                    v_ram_address       := "000111";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"0000001F") =>
                    -- RMAP Area Config Register 7 : CCD 1 Packet Order List Pointer Config Field
                    v_ram_address       := "000111";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"00000020") =>
                    -- RMAP Area Config Register 8 : CCD 1 Window Size Y Config Field
                    -- RMAP Area Config Register 8 : Register 8 Configuration Reserved
                    v_ram_address       := "001000";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"00000021") =>
                    -- RMAP Area Config Register 8 : CCD 1 Window Size X Config Field
                    -- RMAP Area Config Register 8 : CCD 1 Window Size Y Config Field
                    v_ram_address       := "001000";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"00000022") =>
                    -- RMAP Area Config Register 8 : CCD 1 Window List Length Config Field
                    v_ram_address       := "001000";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"00000023") =>
                    -- RMAP Area Config Register 8 : CCD 1 Window List Length Config Field
                    v_ram_address       := "001000";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"00000024") =>
                    -- RMAP Area Config Register 9 : CCD 2 Window List Pointer Config Field
                    v_ram_address       := "001001";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"00000025") =>
                    -- RMAP Area Config Register 9 : CCD 2 Window List Pointer Config Field
                    v_ram_address       := "001001";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"00000026") =>
                    -- RMAP Area Config Register 9 : CCD 2 Window List Pointer Config Field
                    v_ram_address       := "001001";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"00000027") =>
                    -- RMAP Area Config Register 9 : CCD 2 Window List Pointer Config Field
                    v_ram_address       := "001001";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"00000028") =>
                    -- RMAP Area Config Register 10 : CCD 2 Packet Order List Pointer Config Field
                    v_ram_address       := "001010";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"00000029") =>
                    -- RMAP Area Config Register 10 : CCD 2 Packet Order List Pointer Config Field
                    v_ram_address       := "001010";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"0000002A") =>
                    -- RMAP Area Config Register 10 : CCD 2 Packet Order List Pointer Config Field
                    v_ram_address       := "001010";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"0000002B") =>
                    -- RMAP Area Config Register 10 : CCD 2 Packet Order List Pointer Config Field
                    v_ram_address       := "001010";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"0000002C") =>
                    -- RMAP Area Config Register 11 : CCD 2 Window Size Y Config Field
                    -- RMAP Area Config Register 11 : Register 11 Configuration Reserved
                    v_ram_address       := "001011";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"0000002D") =>
                    -- RMAP Area Config Register 11 : CCD 2 Window Size X Config Field
                    -- RMAP Area Config Register 11 : CCD 2 Window Size Y Config Field
                    v_ram_address       := "001011";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"0000002E") =>
                    -- RMAP Area Config Register 11 : CCD 2 Window List Length Config Field
                    v_ram_address       := "001011";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"0000002F") =>
                    -- RMAP Area Config Register 11 : CCD 2 Window List Length Config Field
                    v_ram_address       := "001011";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"00000030") =>
                    -- RMAP Area Config Register 12 : CCD 3 Window List Pointer Config Field
                    v_ram_address       := "001100";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"00000031") =>
                    -- RMAP Area Config Register 12 : CCD 3 Window List Pointer Config Field
                    v_ram_address       := "001100";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"00000032") =>
                    -- RMAP Area Config Register 12 : CCD 3 Window List Pointer Config Field
                    v_ram_address       := "001100";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"00000033") =>
                    -- RMAP Area Config Register 12 : CCD 3 Window List Pointer Config Field
                    v_ram_address       := "001100";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"00000034") =>
                    -- RMAP Area Config Register 13 : CCD 3 Packet Order List Pointer Config Field
                    v_ram_address       := "001101";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"00000035") =>
                    -- RMAP Area Config Register 13 : CCD 3 Packet Order List Pointer Config Field
                    v_ram_address       := "001101";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"00000036") =>
                    -- RMAP Area Config Register 13 : CCD 3 Packet Order List Pointer Config Field
                    v_ram_address       := "001101";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"00000037") =>
                    -- RMAP Area Config Register 13 : CCD 3 Packet Order List Pointer Config Field
                    v_ram_address       := "001101";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"00000038") =>
                    -- RMAP Area Config Register 14 : CCD 3 Window Size Y Config Field
                    -- RMAP Area Config Register 14 : Register 14 Configuration Reserved
                    v_ram_address       := "001110";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"00000039") =>
                    -- RMAP Area Config Register 14 : CCD 3 Window Size X Config Field
                    -- RMAP Area Config Register 14 : CCD 3 Window Size Y Config Field
                    v_ram_address       := "001110";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"0000003A") =>
                    -- RMAP Area Config Register 14 : CCD 3 Window List Length Config Field
                    v_ram_address       := "001110";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"0000003B") =>
                    -- RMAP Area Config Register 14 : CCD 3 Window List Length Config Field
                    v_ram_address       := "001110";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"0000003C") =>
                    -- RMAP Area Config Register 15 : CCD 4 Window List Pointer Config Field
                    v_ram_address       := "001111";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"0000003D") =>
                    -- RMAP Area Config Register 15 : CCD 4 Window List Pointer Config Field
                    v_ram_address       := "001111";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"0000003E") =>
                    -- RMAP Area Config Register 15 : CCD 4 Window List Pointer Config Field
                    v_ram_address       := "001111";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"0000003F") =>
                    -- RMAP Area Config Register 15 : CCD 4 Window List Pointer Config Field
                    v_ram_address       := "001111";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"00000040") =>
                    -- RMAP Area Config Register 16 : CCD 4 Packet Order List Pointer Config Field
                    v_ram_address       := "010000";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"00000041") =>
                    -- RMAP Area Config Register 16 : CCD 4 Packet Order List Pointer Config Field
                    v_ram_address       := "010000";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"00000042") =>
                    -- RMAP Area Config Register 16 : CCD 4 Packet Order List Pointer Config Field
                    v_ram_address       := "010000";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"00000043") =>
                    -- RMAP Area Config Register 16 : CCD 4 Packet Order List Pointer Config Field
                    v_ram_address       := "010000";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"00000044") =>
                    -- RMAP Area Config Register 17 : CCD 4 Window Size Y Config Field
                    -- RMAP Area Config Register 17 : Register 17 Configuration Reserved
                    v_ram_address       := "010001";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"00000045") =>
                    -- RMAP Area Config Register 17 : CCD 4 Window Size X Config Field
                    -- RMAP Area Config Register 17 : CCD 4 Window Size Y Config Field
                    v_ram_address       := "010001";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"00000046") =>
                    -- RMAP Area Config Register 17 : CCD 4 Window List Length Config Field
                    v_ram_address       := "010001";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"00000047") =>
                    -- RMAP Area Config Register 17 : CCD 4 Window List Length Config Field
                    v_ram_address       := "010001";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"00000048") =>
                    -- RMAP Area Config Register 18 : CCD 2 Vrd Configuration Config Field
                    v_ram_address       := "010010";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"00000049") =>
                    -- RMAP Area Config Register 18 : CCD 1 Vrd Configuration Config Field
                    v_ram_address       := "010010";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"0000004A") =>
                    -- RMAP Area Config Register 18 : CCD Vod Configuration Config Field
                    -- RMAP Area Config Register 18 : CCD 1 Vrd Configuration Config Field
                    v_ram_address       := "010010";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"0000004B") =>
                    -- RMAP Area Config Register 18 : CCD Vod Configuration Config Field
                    v_ram_address       := "010010";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"0000004C") =>
                    -- RMAP Area Config Register 19 : CCD 4 Vrd Configuration Config Field
                    -- RMAP Area Config Register 19 : CCD Vgd Configuration Config Field
                    v_ram_address       := "010011";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"0000004D") =>
                    -- RMAP Area Config Register 19 : CCD 4 Vrd Configuration Config Field
                    v_ram_address       := "010011";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"0000004E") =>
                    -- RMAP Area Config Register 19 : CCD 3 Vrd Configuration Config Field
                    v_ram_address       := "010011";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"0000004F") =>
                    -- RMAP Area Config Register 19 : CCD 2 Vrd Configuration Config Field
                    -- RMAP Area Config Register 19 : CCD 3 Vrd Configuration Config Field
                    v_ram_address       := "010011";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"00000050") =>
                    -- RMAP Area Config Register 20 : CCD Ig High Configuration Config Field
                    v_ram_address       := "010100";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"00000051") =>
                    -- RMAP Area Config Register 20 : CCD Vog Configurion Config Field
                    -- RMAP Area Config Register 20 : CCD Ig High Configuration Config Field
                    v_ram_address       := "010100";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"00000052") =>
                    -- RMAP Area Config Register 20 : CCD Vog Configurion Config Field
                    v_ram_address       := "010100";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"00000053") =>
                    -- RMAP Area Config Register 20 : CCD Vgd Configuration Config Field
                    v_ram_address       := "010100";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"00000054") =>
                    -- RMAP Area Config Register 21 : CCD Mode Configuration Config Field
                    -- RMAP Area Config Register 21 : Register 21 Configuration Reserved
                    v_ram_address                   := "010101";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata(6 downto 0) <= v_ram_readdata(30 downto 24);
                    -- RMAP Area Config Register 21 : Clear Error Flag Config Field
                    fee_rmap_o.readdata(7)          <= rmap_registers_wr_i.reg_21_config.clear_error_flag;

                when (x"00000055") =>
                    -- RMAP Area Config Register 21 : Trk Hld High Configuration Config Field
                    -- RMAP Area Config Register 21 : Trk Hld Low Configuration Config Field
                    -- RMAP Area Config Register 21 : Register 21 Configuration Reserved
                    v_ram_address       := "010101";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"00000056") =>
                    -- RMAP Area Config Register 21 : CCD Ig Low Configuration Config Field
                    -- RMAP Area Config Register 21 : Trk Hld High Configuration Config Field
                    v_ram_address       := "010101";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"00000057") =>
                    -- RMAP Area Config Register 21 : CCD Ig Low Configuration Config Field
                    v_ram_address       := "010101";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"00000058") =>
                    -- RMAP Area Config Register 22 : Register 22 Configuration Reserved
                    v_ram_address       := "010110";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"00000059") =>
                    -- RMAP Area Config Register 22 : Register 22 Configuration Reserved
                    v_ram_address       := "010110";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"0000005A") =>
                    -- RMAP Area Config Register 22 : Cdsclp Lo Field
                    -- RMAP Area Config Register 22 : Register 22 Configuration Reserved
                    v_ram_address       := "010110";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"0000005B") =>
                    -- RMAP Area Config Register 22 : R Config 1 Field
                    -- RMAP Area Config Register 22 : R Config 2 Field
                    v_ram_address       := "010110";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"0000005C") =>
                    -- RMAP Area Config Register 23 : CCD 2 Last E Packet Field
                    -- RMAP Area Config Register 23 : Register 23 Configuration Reserved
                    v_ram_address       := "010111";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"0000005D") =>
                    -- RMAP Area Config Register 23 : CCD 1 Last F Packet Field
                    -- RMAP Area Config Register 23 : CCD 2 Last E Packet Field
                    v_ram_address       := "010111";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"0000005E") =>
                    -- RMAP Area Config Register 23 : CCD 1 Last E Packet Field
                    -- RMAP Area Config Register 23 : CCD 1 Last F Packet Field
                    v_ram_address       := "010111";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"0000005F") =>
                    -- RMAP Area Config Register 23 : CCD 1 Last E Packet Field
                    v_ram_address       := "010111";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"00000060") =>
                    -- RMAP Area Config Register 24 : CCD 3 Last F Packet Field
                    -- RMAP Area Config Register 24 : Register 24 Configuration Reserved
                    v_ram_address       := "011000";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"00000061") =>
                    -- RMAP Area Config Register 24 : CCD 3 Last E Packet Field
                    -- RMAP Area Config Register 24 : CCD 3 Last F Packet Field
                    v_ram_address       := "011000";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"00000062") =>
                    -- RMAP Area Config Register 24 : CCD 2 Last F Packet Field
                    -- RMAP Area Config Register 24 : CCD 3 Last E Packet Field
                    v_ram_address       := "011000";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"00000063") =>
                    -- RMAP Area Config Register 24 : CCD 2 Last F Packet Field
                    v_ram_address       := "011000";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"00000064") =>
                    -- RMAP Area Config Register 25 : Surface Inversion Counter Field
                    -- RMAP Area Config Register 25 : Register 25 Configuration Reserved
                    v_ram_address       := "011001";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"00000065") =>
                    -- RMAP Area Config Register 25 : CCD 4 Last F Packet Field
                    -- RMAP Area Config Register 25 : Surface Inversion Counter Field
                    v_ram_address       := "011001";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"00000066") =>
                    -- RMAP Area Config Register 25 : CCD 4 Last E Packet Field
                    -- RMAP Area Config Register 25 : CCD 4 Last F Packet Field
                    v_ram_address       := "011001";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"00000067") =>
                    -- RMAP Area Config Register 25 : CCD 4 Last E Packet Field
                    v_ram_address       := "011001";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"00000068") =>
                    -- RMAP Area Config Register 26 : Trap Pumping Shuffle Counter Field
                    v_ram_address       := "011010";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"00000069") =>
                    -- RMAP Area Config Register 26 : Trap Pumping Shuffle Counter Field
                    v_ram_address       := "011010";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"0000006A") =>
                    -- RMAP Area Config Register 26 : Readout Pause Counter Field
                    v_ram_address       := "011010";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"0000006B") =>
                    -- RMAP Area Config Register 26 : Readout Pause Counter Field
                    v_ram_address       := "011010";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"00000700") =>
                    -- RMAP Area HK Register 0 : TOU Sense 1 HK Field
                    v_ram_address       := "011011";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"00000701") =>
                    -- RMAP Area HK Register 0 : TOU Sense 1 HK Field
                    v_ram_address       := "011011";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"00000702") =>
                    -- RMAP Area HK Register 0 : TOU Sense 2 HK Field
                    v_ram_address       := "011011";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"00000703") =>
                    -- RMAP Area HK Register 0 : TOU Sense 2 HK Field
                    v_ram_address       := "011011";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"00000704") =>
                    -- RMAP Area HK Register 1 : TOU Sense 3 HK Field
                    v_ram_address       := "011100";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"00000705") =>
                    -- RMAP Area HK Register 1 : TOU Sense 3 HK Field
                    v_ram_address       := "011100";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"00000706") =>
                    -- RMAP Area HK Register 1 : TOU Sense 4 HK Field
                    v_ram_address       := "011100";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"00000707") =>
                    -- RMAP Area HK Register 1 : TOU Sense 4 HK Field
                    v_ram_address       := "011100";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"00000708") =>
                    -- RMAP Area HK Register 2 : TOU Sense 5 HK Field
                    v_ram_address       := "011101";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"00000709") =>
                    -- RMAP Area HK Register 2 : TOU Sense 5 HK Field
                    v_ram_address       := "011101";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"0000070A") =>
                    -- RMAP Area HK Register 2 : TOU Sense 6 HK Field
                    v_ram_address       := "011101";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"0000070B") =>
                    -- RMAP Area HK Register 2 : TOU Sense 6 HK Field
                    v_ram_address       := "011101";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"0000070C") =>
                    -- RMAP Area HK Register 3 : CCD 1 TS HK Field
                    v_ram_address       := "011110";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"0000070D") =>
                    -- RMAP Area HK Register 3 : CCD 1 TS HK Field
                    v_ram_address       := "011110";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"0000070E") =>
                    -- RMAP Area HK Register 3 : CCD 2 TS HK Field
                    v_ram_address       := "011110";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"0000070F") =>
                    -- RMAP Area HK Register 3 : CCD 2 TS HK Field
                    v_ram_address       := "011110";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"00000710") =>
                    -- RMAP Area HK Register 4 : CCD 3 TS HK Field
                    v_ram_address       := "011111";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"00000711") =>
                    -- RMAP Area HK Register 4 : CCD 3 TS HK Field
                    v_ram_address       := "011111";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"00000712") =>
                    -- RMAP Area HK Register 4 : CCD 4 TS HK Field
                    v_ram_address       := "011111";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"00000713") =>
                    -- RMAP Area HK Register 4 : CCD 4 TS HK Field
                    v_ram_address       := "011111";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"00000714") =>
                    -- RMAP Area HK Register 5 : PRT 1 HK Field
                    v_ram_address       := "100000";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"00000715") =>
                    -- RMAP Area HK Register 5 : PRT 1 HK Field
                    v_ram_address       := "100000";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"00000716") =>
                    -- RMAP Area HK Register 5 : PRT 2 HK Field
                    v_ram_address       := "100000";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"00000717") =>
                    -- RMAP Area HK Register 5 : PRT 2 HK Field
                    v_ram_address       := "100000";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"00000718") =>
                    -- RMAP Area HK Register 6 : PRT 3 HK Field
                    v_ram_address       := "100001";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"00000719") =>
                    -- RMAP Area HK Register 6 : PRT 3 HK Field
                    v_ram_address       := "100001";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"0000071A") =>
                    -- RMAP Area HK Register 6 : PRT 4 HK Field
                    v_ram_address       := "100001";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"0000071B") =>
                    -- RMAP Area HK Register 6 : PRT 4 HK Field
                    v_ram_address       := "100001";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"0000071C") =>
                    -- RMAP Area HK Register 7 : PRT 5 HK Field
                    v_ram_address       := "100010";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"0000071D") =>
                    -- RMAP Area HK Register 7 : PRT 5 HK Field
                    v_ram_address       := "100010";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"0000071E") =>
                    -- RMAP Area HK Register 7 : Zero Diff Amplifier HK Field
                    v_ram_address       := "100010";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"0000071F") =>
                    -- RMAP Area HK Register 7 : Zero Diff Amplifier HK Field
                    v_ram_address       := "100010";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"00000720") =>
                    -- RMAP Area HK Register 8 : CCD 1 Vod Monitor HK Field
                    v_ram_address       := "100011";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"00000721") =>
                    -- RMAP Area HK Register 8 : CCD 1 Vod Monitor HK Field
                    v_ram_address       := "100011";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"00000722") =>
                    -- RMAP Area HK Register 8 : CCD 1 Vog Monitor HK Field
                    v_ram_address       := "100011";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"00000723") =>
                    -- RMAP Area HK Register 8 : CCD 1 Vog Monitor HK Field
                    v_ram_address       := "100011";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"00000724") =>
                    -- RMAP Area HK Register 9 : CCD 1 Vrd Monitor E HK Field
                    v_ram_address       := "100100";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"00000725") =>
                    -- RMAP Area HK Register 9 : CCD 1 Vrd Monitor E HK Field
                    v_ram_address       := "100100";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"00000726") =>
                    -- RMAP Area HK Register 9 : CCD 2 Vod Monitor HK Field
                    v_ram_address       := "100100";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"00000727") =>
                    -- RMAP Area HK Register 9 : CCD 2 Vod Monitor HK Field
                    v_ram_address       := "100100";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"00000728") =>
                    -- RMAP Area HK Register 10 : CCD 2 Vog Monitor HK Field
                    v_ram_address       := "100101";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"00000729") =>
                    -- RMAP Area HK Register 10 : CCD 2 Vog Monitor HK Field
                    v_ram_address       := "100101";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"0000072A") =>
                    -- RMAP Area HK Register 10 : CCD 2 Vrd Monitor E HK Field
                    v_ram_address       := "100101";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"0000072B") =>
                    -- RMAP Area HK Register 10 : CCD 2 Vrd Monitor E HK Field
                    v_ram_address       := "100101";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"0000072C") =>
                    -- RMAP Area HK Register 11 : CCD 3 Vod Monitor HK Field
                    v_ram_address       := "100110";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"0000072D") =>
                    -- RMAP Area HK Register 11 : CCD 3 Vod Monitor HK Field
                    v_ram_address       := "100110";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"0000072E") =>
                    -- RMAP Area HK Register 11 : CCD 3 Vog Monitor HK Field
                    v_ram_address       := "100110";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"0000072F") =>
                    -- RMAP Area HK Register 11 : CCD 3 Vog Monitor HK Field
                    v_ram_address       := "100110";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"00000730") =>
                    -- RMAP Area HK Register 12 : CCD 3 Vrd Monitor E HK Field
                    v_ram_address       := "100111";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"00000731") =>
                    -- RMAP Area HK Register 12 : CCD 3 Vrd Monitor E HK Field
                    v_ram_address       := "100111";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"00000732") =>
                    -- RMAP Area HK Register 12 : CCD 4 Vod Monitor HK Field
                    v_ram_address       := "100111";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"00000733") =>
                    -- RMAP Area HK Register 12 : CCD 4 Vod Monitor HK Field
                    v_ram_address       := "100111";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"00000734") =>
                    -- RMAP Area HK Register 13 : CCD 4 Vog Monitor HK Field
                    v_ram_address       := "101000";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"00000735") =>
                    -- RMAP Area HK Register 13 : CCD 4 Vog Monitor HK Field
                    v_ram_address       := "101000";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"00000736") =>
                    -- RMAP Area HK Register 13 : CCD 4 Vrd Monitor E HK Field
                    v_ram_address       := "101000";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"00000737") =>
                    -- RMAP Area HK Register 13 : CCD 4 Vrd Monitor E HK Field
                    v_ram_address       := "101000";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"00000738") =>
                    -- RMAP Area HK Register 14 : V CCD HK Field
                    v_ram_address       := "101001";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"00000739") =>
                    -- RMAP Area HK Register 14 : V CCD HK Field
                    v_ram_address       := "101001";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"0000073A") =>
                    -- RMAP Area HK Register 14 : VRClock Monitor HK Field
                    v_ram_address       := "101001";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"0000073B") =>
                    -- RMAP Area HK Register 14 : VRClock Monitor HK Field
                    v_ram_address       := "101001";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"0000073C") =>
                    -- RMAP Area HK Register 15 : VIClock HK Field
                    v_ram_address       := "101010";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"0000073D") =>
                    -- RMAP Area HK Register 15 : VIClock HK Field
                    v_ram_address       := "101010";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"0000073E") =>
                    -- RMAP Area HK Register 15 : VRClock Low HK Field
                    v_ram_address       := "101010";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"0000073F") =>
                    -- RMAP Area HK Register 15 : VRClock Low HK Field
                    v_ram_address       := "101010";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"00000740") =>
                    -- RMAP Area HK Register 16 : 5Vb Positive Monitor HK Field
                    v_ram_address       := "101011";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"00000741") =>
                    -- RMAP Area HK Register 16 : 5Vb Positive Monitor HK Field
                    v_ram_address       := "101011";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"00000742") =>
                    -- RMAP Area HK Register 16 : 5Vb Negative Monitor HK Field
                    v_ram_address       := "101011";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"00000743") =>
                    -- RMAP Area HK Register 16 : 5Vb Negative Monitor HK Field
                    v_ram_address       := "101011";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"00000744") =>
                    -- RMAP Area HK Register 17 : 3V3b Monitor HK Field
                    v_ram_address       := "101100";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"00000745") =>
                    -- RMAP Area HK Register 17 : 3V3b Monitor HK Field
                    v_ram_address       := "101100";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"00000746") =>
                    -- RMAP Area HK Register 17 : 2V5a Monitor HK Field
                    v_ram_address       := "101100";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"00000747") =>
                    -- RMAP Area HK Register 17 : 2V5a Monitor HK Field
                    v_ram_address       := "101100";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"00000748") =>
                    -- RMAP Area HK Register 18 : 3V3d Monitor HK Field
                    v_ram_address       := "101101";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"00000749") =>
                    -- RMAP Area HK Register 18 : 3V3d Monitor HK Field
                    v_ram_address       := "101101";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"0000074A") =>
                    -- RMAP Area HK Register 18 : 2V5d Monitor HK Field
                    v_ram_address       := "101101";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"0000074B") =>
                    -- RMAP Area HK Register 18 : 2V5d Monitor HK Field
                    v_ram_address       := "101101";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"0000074C") =>
                    -- RMAP Area HK Register 19 : 1V5d Monitor HK Field
                    v_ram_address       := "101110";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"0000074D") =>
                    -- RMAP Area HK Register 19 : 1V5d Monitor HK Field
                    v_ram_address       := "101110";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"0000074E") =>
                    -- RMAP Area HK Register 19 : 5Vref Monitor HK Field
                    v_ram_address       := "101110";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"0000074F") =>
                    -- RMAP Area HK Register 19 : 5Vref Monitor HK Field
                    v_ram_address       := "101110";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"00000750") =>
                    -- RMAP Area HK Register 20 : Vccd Positive Raw HK Field
                    v_ram_address       := "101111";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"00000751") =>
                    -- RMAP Area HK Register 20 : Vccd Positive Raw HK Field
                    v_ram_address       := "101111";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"00000752") =>
                    -- RMAP Area HK Register 20 : Vclk Positive Raw HK Field
                    v_ram_address       := "101111";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"00000753") =>
                    -- RMAP Area HK Register 20 : Vclk Positive Raw HK Field
                    v_ram_address       := "101111";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"00000754") =>
                    -- RMAP Area HK Register 21 : Van 1 Positive Raw HK Field
                    v_ram_address       := "110000";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"00000755") =>
                    -- RMAP Area HK Register 21 : Van 1 Positive Raw HK Field
                    v_ram_address       := "110000";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"00000756") =>
                    -- RMAP Area HK Register 21 : Van 3 Negative Monitor HK Field
                    v_ram_address       := "110000";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"00000757") =>
                    -- RMAP Area HK Register 21 : Van 3 Negative Monitor HK Field
                    v_ram_address       := "110000";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"00000758") =>
                    -- RMAP Area HK Register 22 : Van Positive Raw HK Field
                    v_ram_address       := "110001";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"00000759") =>
                    -- RMAP Area HK Register 22 : Van Positive Raw HK Field
                    v_ram_address       := "110001";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"0000075A") =>
                    -- RMAP Area HK Register 22 : Vdig Raw HK Field
                    v_ram_address       := "110001";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"0000075B") =>
                    -- RMAP Area HK Register 22 : Vdig Raw HK Field
                    v_ram_address       := "110001";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"0000075C") =>
                    -- RMAP Area HK Register 23 : Vdig Raw 2 HK Field
                    v_ram_address       := "110010";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"0000075D") =>
                    -- RMAP Area HK Register 23 : Vdig Raw 2 HK Field
                    v_ram_address       := "110010";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"0000075E") =>
                    -- RMAP Area HK Register 23 : VIClock Low HK Field
                    v_ram_address       := "110010";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"0000075F") =>
                    -- RMAP Area HK Register 23 : VIClock Low HK Field
                    v_ram_address       := "110010";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"00000760") =>
                    -- RMAP Area HK Register 24 : CCD 1 Vrd Monitor F HK Field
                    v_ram_address       := "110011";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"00000761") =>
                    -- RMAP Area HK Register 24 : CCD 1 Vrd Monitor F HK Field
                    v_ram_address       := "110011";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"00000762") =>
                    -- RMAP Area HK Register 24 : CCD 1 Vdd Monitor HK Field
                    v_ram_address       := "110011";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"00000763") =>
                    -- RMAP Area HK Register 24 : CCD 1 Vdd Monitor HK Field
                    v_ram_address       := "110011";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"00000764") =>
                    -- RMAP Area HK Register 25 : CCD 1 Vgd Monitor HK Field
                    v_ram_address       := "110100";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"00000765") =>
                    -- RMAP Area HK Register 25 : CCD 1 Vgd Monitor HK Field
                    v_ram_address       := "110100";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"00000766") =>
                    -- RMAP Area HK Register 25 : CCD 2 Vrd Monitor F HK Field
                    v_ram_address       := "110100";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"00000767") =>
                    -- RMAP Area HK Register 25 : CCD 2 Vrd Monitor F HK Field
                    v_ram_address       := "110100";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"00000768") =>
                    -- RMAP Area HK Register 26 : CCD 2 Vdd Monitor HK Field
                    v_ram_address       := "110101";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"00000769") =>
                    -- RMAP Area HK Register 26 : CCD 2 Vdd Monitor HK Field
                    v_ram_address       := "110101";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"0000076A") =>
                    -- RMAP Area HK Register 26 : CCD 2 Vgd Monitor HK Field
                    v_ram_address       := "110101";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"0000076B") =>
                    -- RMAP Area HK Register 26 : CCD 2 Vgd Monitor HK Field
                    v_ram_address       := "110101";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"0000076C") =>
                    -- RMAP Area HK Register 27 : CCD 3 Vrd Monitor F HK Field
                    v_ram_address       := "110110";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"0000076D") =>
                    -- RMAP Area HK Register 27 : CCD 3 Vrd Monitor F HK Field
                    v_ram_address       := "110110";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"0000076E") =>
                    -- RMAP Area HK Register 27 : CCD 3 Vdd Monitor HK Field
                    v_ram_address       := "110110";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"0000076F") =>
                    -- RMAP Area HK Register 27 : CCD 3 Vdd Monitor HK Field
                    v_ram_address       := "110110";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"00000770") =>
                    -- RMAP Area HK Register 28 : CCD 3 Vgd Monitor HK Field
                    v_ram_address       := "110111";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"00000771") =>
                    -- RMAP Area HK Register 28 : CCD 3 Vgd Monitor HK Field
                    v_ram_address       := "110111";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"00000772") =>
                    -- RMAP Area HK Register 28 : CCD 4 Vrd Monitor F HK Field
                    v_ram_address       := "110111";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"00000773") =>
                    -- RMAP Area HK Register 28 : CCD 4 Vrd Monitor F HK Field
                    v_ram_address       := "110111";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"00000774") =>
                    -- RMAP Area HK Register 29 : CCD 4 Vdd Monitor HK Field
                    v_ram_address       := "111000";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"00000775") =>
                    -- RMAP Area HK Register 29 : CCD 4 Vdd Monitor HK Field
                    v_ram_address       := "111000";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"00000776") =>
                    -- RMAP Area HK Register 29 : CCD 4 Vgd Monitor HK Field
                    v_ram_address       := "111000";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"00000777") =>
                    -- RMAP Area HK Register 29 : CCD 4 Vgd Monitor HK Field
                    v_ram_address       := "111000";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"00000778") =>
                    -- RMAP Area HK Register 30 : Ig High Monitor HK Field
                    v_ram_address       := "111001";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"00000779") =>
                    -- RMAP Area HK Register 30 : Ig High Monitor HK Field
                    v_ram_address       := "111001";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"0000077A") =>
                    -- RMAP Area HK Register 30 : Ig Low Monitor HK Field
                    v_ram_address       := "111001";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"0000077B") =>
                    -- RMAP Area HK Register 30 : Ig Low Monitor HK Field
                    v_ram_address       := "111001";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"0000077C") =>
                    -- RMAP Area HK Register 31 : Tsense A HK Field
                    v_ram_address       := "111010";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"0000077D") =>
                    -- RMAP Area HK Register 31 : Tsense A HK Field
                    v_ram_address       := "111010";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"0000077E") =>
                    -- RMAP Area HK Register 31 : Tsense B HK Field
                    v_ram_address       := "111010";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"0000077F") =>
                    -- RMAP Area HK Register 31 : Tsense B HK Field
                    v_ram_address       := "111010";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"00000780") =>
                    -- RMAP Area HK Register 32 : Register 32 HK Reserved
                    v_ram_address       := "111011";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"00000781") =>
                    -- RMAP Area HK Register 32 : SpW Status : Timecode From SpaceWire HK Field
                    fee_rmap_o.readdata    <= rmap_registers_rd_i.reg_32_hk.spw_status_timecode_from_spw;
                    fee_rmap_o.waitrequest <= '0';

                when (x"00000782") =>
                    -- RMAP Area HK Register 32 : SpW Status : RMAP Target Status HK Field
                    fee_rmap_o.readdata    <= rmap_registers_rd_i.reg_32_hk.spw_status_rmap_target_status;
                    fee_rmap_o.waitrequest <= '0';

                when (x"00000783") =>
                    -- RMAP Area HK Register 32 : SpW Status : Status Link Running HK Field
                    fee_rmap_o.readdata(0)          <= rmap_registers_rd_i.reg_32_hk.spw_status_stat_link_running;
                    -- RMAP Area HK Register 32 : SpW Status : Status Link Disconnect HK Field
                    fee_rmap_o.readdata(1)          <= rmap_registers_rd_i.reg_32_hk.spw_status_stat_link_disconnect;
                    -- RMAP Area HK Register 32 : SpW Status : Status Link Parity Error HK Field
                    fee_rmap_o.readdata(2)          <= rmap_registers_rd_i.reg_32_hk.spw_status_stat_link_parity_error;
                    -- RMAP Area HK Register 32 : SpW Status : Status Link Credit Error HK Field
                    fee_rmap_o.readdata(3)          <= rmap_registers_rd_i.reg_32_hk.spw_status_stat_link_credit_error;
                    -- RMAP Area HK Register 32 : SpW Status : Status Link Escape Error HK Field
                    fee_rmap_o.readdata(4)          <= rmap_registers_rd_i.reg_32_hk.spw_status_stat_link_escape_error;
                    -- RMAP Area HK Register 32 : SpW Status : RMAP Target Indicate HK Field
                    fee_rmap_o.readdata(5)          <= rmap_registers_rd_i.reg_32_hk.spw_status_rmap_target_indicate;
                    -- RMAP Area HK Register 32 : SpW Status : SpaceWire Status Reserved
                    v_ram_address                   := "111011";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata(7 downto 6) <= v_ram_readdata(7 downto 6);

                when (x"00000784") =>
                    -- RMAP Area HK Register 33 : Frame Counter HK Field
                    fee_rmap_o.readdata    <= rmap_registers_rd_i.reg_33_hk.frame_counter(15 downto 8);
                    fee_rmap_o.waitrequest <= '0';

                when (x"00000785") =>
                    -- RMAP Area HK Register 33 : Frame Counter HK Field
                    fee_rmap_o.readdata    <= rmap_registers_rd_i.reg_33_hk.frame_counter(7 downto 0);
                    fee_rmap_o.waitrequest <= '0';

                when (x"00000786") =>
                    -- RMAP Area HK Register 33 : Register 33 HK Reserved
                    v_ram_address       := "111100";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"00000787") =>
                    -- RMAP Area HK Register 33 : Frame Number HK Field
                    fee_rmap_o.readdata(1 downto 0) <= rmap_registers_rd_i.reg_33_hk.frame_number;
                    -- RMAP Area HK Register 33 : Operational Mode HK Field
                    -- RMAP Area HK Register 33 : Register 33 HK Reserved
                    v_ram_address                   := "111100";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata(7 downto 2) <= v_ram_readdata(7 downto 2);

                when (x"00000788") =>
                    -- RMAP Area HK Register 34 : Error Flags : Error Flags Reserved
                    v_ram_address       := "111101";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"00000789") =>
                    -- RMAP Area HK Register 34 : Error Flags : Error Flags Reserved
                    v_ram_address       := "111101";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"0000078A") =>
                    -- RMAP Area HK Register 34 : Error Flags : Error Flags Reserved
                    v_ram_address       := "111101";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"0000078B") =>
                    -- RMAP Area HK Register 34 : Error Flags : Window Pixels Fall Outside CDD Boundary Due To Wrong X Coordinate HK Field
                    fee_rmap_o.readdata(0) <= rmap_registers_rd_i.reg_34_hk.error_flags_window_pixels_fall_outside_cdd_boundary_due_to_wrong_x_coordinate;
                    -- RMAP Area HK Register 34 : Error Flags : Window Pixels Fall Outside CDD Boundary Due To Wrong Y Coordinate HK Field
                    fee_rmap_o.readdata(1) <= rmap_registers_rd_i.reg_34_hk.error_flags_window_pixels_fall_outside_cdd_boundary_due_to_wrong_y_coordinate;
                    -- RMAP Area HK Register 34 : Error Flags : E Side Pixel External SRAM Buffer is Full HK Field
                    fee_rmap_o.readdata(2) <= rmap_registers_rd_i.reg_34_hk.error_flags_e_side_pixel_external_sram_buffer_is_full;
                    -- RMAP Area HK Register 34 : Error Flags : F Side Pixel External SRAM Buffer is Full HK Field
                    fee_rmap_o.readdata(3) <= rmap_registers_rd_i.reg_34_hk.error_flags_f_side_pixel_external_sram_buffer_is_full;
                    -- RMAP Area HK Register 34 : Error Flags : Too Many Overlapping Windows
                    fee_rmap_o.readdata(4) <= rmap_registers_rd_i.reg_34_hk.error_flags_too_many_overlapping_windows;
                    -- RMAP Area HK Register 34 : Error Flags : SRAM EDAC Correctable
                    fee_rmap_o.readdata(5) <= rmap_registers_rd_i.reg_34_hk.error_flags_sram_edac_correctable;
                    -- RMAP Area HK Register 34 : Error Flags : SRAM EDAC Uncorrectable
                    fee_rmap_o.readdata(6) <= rmap_registers_rd_i.reg_34_hk.error_flags_sram_edac_uncorrectable;
                    -- RMAP Area HK Register 34 : Error Flags : BLOCK RAM EDAC Uncorrectable
                    fee_rmap_o.readdata(7) <= rmap_registers_rd_i.reg_34_hk.error_flags_block_ram_edac_uncorrectable;
                    fee_rmap_o.waitrequest <= '0';

                when (x"0000078C") =>
                    -- RMAP Area HK Register 35 : Register 35 HK Reserved HK Field
                    v_ram_address       := "111110";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"0000078D") =>
                    -- RMAP Area HK Register 35 : Board ID Field
                    -- RMAP Area HK Register 35 : Register 35 HK Reserved HK Field
                    v_ram_address       := "111110";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"0000078E") =>
                    -- RMAP Area HK Register 35 : FPGA Major Version Field
                    -- RMAP Area HK Register 35 : Board ID Field
                    v_ram_address       := "111110";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"0000078F") =>
                    -- RMAP Area HK Register 35 : FPGA Minor Version Field
                    v_ram_address       := "111110";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when others =>
                    fee_rmap_o.readdata    <= (others => '0');
                    fee_rmap_o.waitrequest <= '0';

            end case;

        end procedure p_nfee_rmap_mem_rd;
        --
        procedure p_avs_readdata(read_address_i : t_nrme_avalon_mm_rmap_nfee_address) is
            variable v_ram_address  : std_logic_vector(5 downto 0)  := (others => '0');
            variable v_ram_readdata : std_logic_vector(31 downto 0) := (others => '0');
        begin

            -- Registers Data Read
            case (read_address_i) is
                -- Case for access to all registers address

                when (16#00#) =>
                    -- RMAP Area Config Register 0 : V Start Config Field
                    v_ram_address                          := "000000";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(15 downto 0);

                when (16#01#) =>
                    -- RMAP Area Config Register 0 : V End Config Field
                    v_ram_address                          := "000000";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(31 downto 16);

                when (16#02#) =>
                    -- RMAP Area Config Register 1 : Charge Injection Width Config Field
                    v_ram_address                          := "000001";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(15 downto 0);

                when (16#03#) =>
                    -- RMAP Area Config Register 1 : Charge Injection Gap Config Field
                    v_ram_address                          := "000001";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(31 downto 16);

                when (16#04#) =>
                    -- RMAP Area Config Register 2 : Parallel Toi Period Config Field
                    v_ram_address                          := "000010";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(11 downto 0) <= v_ram_readdata(11 downto 0);

                when (16#05#) =>
                    -- RMAP Area Config Register 2 : Parallel Clock Overlap Config Field
                    v_ram_address                          := "000010";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(11 downto 0) <= v_ram_readdata(23 downto 12);

                when (16#06#) =>
                    -- RMAP Area Config Register 2 : CCD Readout Order Config Field (1st CCD)
                    v_ram_address                         := "000010";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(1 downto 0) <= v_ram_readdata(25 downto 24);

                when (16#07#) =>
                    -- RMAP Area Config Register 2 : CCD Readout Order Config Field (2nd CCD)
                    v_ram_address                         := "000010";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(1 downto 0) <= v_ram_readdata(27 downto 26);

                when (16#08#) =>
                    -- RMAP Area Config Register 2 : CCD Readout Order Config Field (3rd CCD)
                    v_ram_address                         := "000010";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(1 downto 0) <= v_ram_readdata(29 downto 28);

                when (16#09#) =>
                    -- RMAP Area Config Register 2 : CCD Readout Order Config Field (4th CCD)
                    v_ram_address                         := "000010";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(1 downto 0) <= v_ram_readdata(31 downto 30);

                when (16#0A#) =>
                    -- RMAP Area Config Register 3 : N Final Dump Config Field
                    v_ram_address                          := "000011";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(15 downto 0);

                when (16#0B#) =>
                    -- RMAP Area Config Register 3 : H End Config Field
                    v_ram_address                          := "000011";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(11 downto 0) <= v_ram_readdata(27 downto 16);

                when (16#0C#) =>
                    -- RMAP Area Config Register 3 : Charge Injection Enable Config Field
                    v_ram_address                         := "000011";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(0 downto 0) <= v_ram_readdata(28 downto 28);

                when (16#0D#) =>
                    -- RMAP Area Config Register 3 : Tri Level Clock Enable Config Field
                    v_ram_address                         := "000011";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(0 downto 0) <= v_ram_readdata(29 downto 29);

                when (16#0E#) =>
                    -- RMAP Area Config Register 3 : Image Clock Direction Config Field
                    v_ram_address                         := "000011";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(0 downto 0) <= v_ram_readdata(30 downto 30);

                when (16#0F#) =>
                    -- RMAP Area Config Register 3 : Register Clock Direction Config Field
                    v_ram_address                         := "000011";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(0 downto 0) <= v_ram_readdata(31 downto 31);

                when (16#10#) =>
                    -- RMAP Area Config Register 4 : Data Packet Size Config Field
                    v_ram_address                          := "000100";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(15 downto 0);

                when (16#11#) =>
                    -- RMAP Area Config Register 4 : Internal Sync Period Config Field
                    v_ram_address                          := "000100";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(31 downto 16);

                when (16#12#) =>
                    -- RMAP Area Config Register 5 : Trap Pumping Dwell Counter Field
                    v_ram_address                          := "000101";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(19 downto 0) <= v_ram_readdata(19 downto 0);

                when (16#13#) =>
                    -- RMAP Area Config Register 5 : Sync Source Selection Config Field
                    v_ram_address                         := "000101";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(0 downto 0) <= v_ram_readdata(20 downto 20);

                when (16#14#) =>
                    -- RMAP Area Config Register 5 : CCD Port Data Sensor Selection Config Field
                    v_ram_address                         := "000101";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(1 downto 0) <= v_ram_readdata(22 downto 21);

                when (16#15#) =>
                    -- RMAP Area Config Register 5 : Digitalise Enable Config Field
                    v_ram_address                         := "000101";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(0 downto 0) <= v_ram_readdata(23 downto 23);

                when (16#16#) =>
                    -- RMAP Area Config Register 5 : DG (Drain Gate) Enable Field
                    v_ram_address                         := "000101";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(0 downto 0) <= v_ram_readdata(24 downto 24);

                when (16#17#) =>
                    -- RMAP Area Config Register 5 : CCD Readout Enable Field
                    v_ram_address                         := "000101";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(0 downto 0) <= v_ram_readdata(25 downto 25);

                when (16#18#) =>
                    -- RMAP Area Config Register 5 : Conversion Delay Value
                    v_ram_address                         := "000101";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(4 downto 0) <= v_ram_readdata(30 downto 26);

                when (16#19#) =>
                    -- RMAP Area Config Register 5 : High Precison Housekeep Enable Field
                    v_ram_address                         := "000101";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(0 downto 0) <= v_ram_readdata(31 downto 31);

                when (16#1A#) =>
                    -- RMAP Area Config Register 6 : CCD 1 Window List Pointer Config Field
                    v_ram_address             := "000110";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata <= v_ram_readdata;

                when (16#1B#) =>
                    -- RMAP Area Config Register 7 : CCD 1 Packet Order List Pointer Config Field
                    v_ram_address             := "000111";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata <= v_ram_readdata;

                when (16#1C#) =>
                    -- RMAP Area Config Register 8 : CCD 1 Window List Length Config Field
                    v_ram_address                          := "001000";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(15 downto 0);

                when (16#1D#) =>
                    -- RMAP Area Config Register 8 : CCD 1 Window Size X Config Field
                    v_ram_address                         := "001000";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(5 downto 0) <= v_ram_readdata(21 downto 16);

                when (16#1E#) =>
                    -- RMAP Area Config Register 8 : CCD 1 Window Size Y Config Field
                    v_ram_address                         := "001000";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(5 downto 0) <= v_ram_readdata(27 downto 22);

                when (16#1F#) =>
                    -- RMAP Area Config Register 8 : Register 8 Configuration Reserved
                    v_ram_address                         := "001000";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(3 downto 0) <= v_ram_readdata(31 downto 28);

                when (16#20#) =>
                    -- RMAP Area Config Register 9 : CCD 2 Window List Pointer Config Field
                    v_ram_address             := "001001";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata <= v_ram_readdata;

                when (16#21#) =>
                    -- RMAP Area Config Register 10 : CCD 2 Packet Order List Pointer Config Field
                    v_ram_address             := "001010";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata <= v_ram_readdata;

                when (16#22#) =>
                    -- RMAP Area Config Register 11 : CCD 2 Window List Length Config Field
                    v_ram_address                          := "001011";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(15 downto 0);

                when (16#23#) =>
                    -- RMAP Area Config Register 11 : CCD 2 Window Size X Config Field
                    v_ram_address                         := "001011";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(5 downto 0) <= v_ram_readdata(21 downto 16);

                when (16#24#) =>
                    -- RMAP Area Config Register 11 : CCD 2 Window Size Y Config Field
                    v_ram_address                         := "001011";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(5 downto 0) <= v_ram_readdata(27 downto 22);

                when (16#25#) =>
                    -- RMAP Area Config Register 11 : Register 11 Configuration Reserved
                    v_ram_address                         := "001011";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(3 downto 0) <= v_ram_readdata(31 downto 28);

                when (16#26#) =>
                    -- RMAP Area Config Register 12 : CCD 3 Window List Pointer Config Field
                    v_ram_address             := "001100";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata <= v_ram_readdata;

                when (16#27#) =>
                    -- RMAP Area Config Register 13 : CCD 3 Packet Order List Pointer Config Field
                    v_ram_address             := "001101";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata <= v_ram_readdata;

                when (16#28#) =>
                    -- RMAP Area Config Register 14 : CCD 3 Window List Length Config Field
                    v_ram_address                          := "001110";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(15 downto 0);

                when (16#29#) =>
                    -- RMAP Area Config Register 14 : CCD 3 Window Size X Config Field
                    v_ram_address                         := "001110";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(5 downto 0) <= v_ram_readdata(21 downto 16);

                when (16#2A#) =>
                    -- RMAP Area Config Register 14 : CCD 3 Window Size Y Config Field
                    v_ram_address                         := "001110";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(5 downto 0) <= v_ram_readdata(27 downto 22);

                when (16#2B#) =>
                    -- RMAP Area Config Register 14 : Register 14 Configuration Reserved
                    v_ram_address                         := "001110";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(3 downto 0) <= v_ram_readdata(31 downto 28);

                when (16#2C#) =>
                    -- RMAP Area Config Register 15 : CCD 4 Window List Pointer Config Field
                    v_ram_address             := "001111";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata <= v_ram_readdata;

                when (16#2D#) =>
                    -- RMAP Area Config Register 16 : CCD 4 Packet Order List Pointer Config Field
                    v_ram_address             := "010000";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata <= v_ram_readdata;

                when (16#2E#) =>
                    -- RMAP Area Config Register 17 : CCD 4 Window List Length Config Field
                    v_ram_address                          := "010001";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(15 downto 0);

                when (16#2F#) =>
                    -- RMAP Area Config Register 17 : CCD 4 Window Size X Config Field
                    v_ram_address                         := "010001";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(5 downto 0) <= v_ram_readdata(21 downto 16);

                when (16#30#) =>
                    -- RMAP Area Config Register 17 : CCD 4 Window Size Y Config Field
                    v_ram_address                         := "010001";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(5 downto 0) <= v_ram_readdata(27 downto 22);

                when (16#31#) =>
                    -- RMAP Area Config Register 17 : Register 17 Configuration Reserved
                    v_ram_address                         := "010001";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(3 downto 0) <= v_ram_readdata(31 downto 28);

                when (16#32#) =>
                    -- RMAP Area Config Register 18 : CCD Vod Configuration Config Field
                    v_ram_address                          := "010010";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(11 downto 0) <= v_ram_readdata(11 downto 0);

                when (16#33#) =>
                    -- RMAP Area Config Register 18 : CCD 1 Vrd Configuration Config Field
                    v_ram_address                          := "010010";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(11 downto 0) <= v_ram_readdata(23 downto 12);

                when (16#34#) =>
                    -- RMAP Area Config Register 18 : CCD 2 Vrd Configuration Config Field
                    v_ram_address                         := "010010";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(7 downto 0) <= v_ram_readdata(31 downto 24);

                when (16#35#) =>
                    -- RMAP Area Config Register 19 : CCD 2 Vrd Configuration Config Field
                    v_ram_address                         := "010011";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(3 downto 0) <= v_ram_readdata(3 downto 0);

                when (16#36#) =>
                    -- RMAP Area Config Register 19 : CCD 3 Vrd Configuration Config Field
                    v_ram_address                          := "010011";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(11 downto 0) <= v_ram_readdata(15 downto 4);

                when (16#37#) =>
                    -- RMAP Area Config Register 19 : CCD 4 Vrd Configuration Config Field
                    v_ram_address                          := "010011";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(11 downto 0) <= v_ram_readdata(27 downto 16);

                when (16#38#) =>
                    -- RMAP Area Config Register 19 : CCD Vgd Configuration Config Field
                    v_ram_address                         := "010011";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(3 downto 0) <= v_ram_readdata(31 downto 28);

                when (16#39#) =>
                    -- RMAP Area Config Register 20 : CCD Vgd Configuration Config Field
                    v_ram_address                         := "010100";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(7 downto 0) <= v_ram_readdata(7 downto 0);

                when (16#3A#) =>
                    -- RMAP Area Config Register 20 : CCD Vog Configurion Config Field
                    v_ram_address                          := "010100";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(11 downto 0) <= v_ram_readdata(19 downto 8);

                when (16#3B#) =>
                    -- RMAP Area Config Register 20 : CCD Ig High Configuration Config Field
                    v_ram_address                          := "010100";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(11 downto 0) <= v_ram_readdata(31 downto 20);

                when (16#3C#) =>
                    -- RMAP Area Config Register 21 : CCD Ig Low Configuration Config Field
                    v_ram_address                          := "010101";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(11 downto 0) <= v_ram_readdata(11 downto 0);

                when (16#3D#) =>
                    -- RMAP Area Config Register 21 : Trk Hld High Configuration Config Field
                    v_ram_address                         := "010101";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(4 downto 0) <= v_ram_readdata(16 downto 12);

                when (16#3E#) =>
                    -- RMAP Area Config Register 21 : Trk Hld Low Configuration Config Field
                    v_ram_address                         := "010101";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(4 downto 0) <= v_ram_readdata(21 downto 17);

                when (16#3F#) =>
                    -- RMAP Area Config Register 21 : Register 21 Configuration Reserved
                    v_ram_address                         := "010101";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(1 downto 0) <= v_ram_readdata(23 downto 22);

                when (16#40#) =>
                    -- RMAP Area Config Register 21 : CCD Mode Configuration Config Field
                    v_ram_address                         := "010101";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(3 downto 0) <= v_ram_readdata(27 downto 24);

                when (16#41#) =>
                    -- RMAP Area Config Register 21 : Register 21 Configuration Reserved
                    v_ram_address                         := "010101";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(2 downto 0) <= v_ram_readdata(30 downto 28);

                when (16#42#) =>
                    -- RMAP Area Config Register 21 : Clear Error Flag Config Field
                    avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.reg_21_config.clear_error_flag;
                    avalon_mm_rmap_o.waitrequest <= '0';

                when (16#43#) =>
                    -- RMAP Area Config Register 22 : R Config 1 Field
                    v_ram_address                         := "010110";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(3 downto 0) <= v_ram_readdata(3 downto 0);

                when (16#44#) =>
                    -- RMAP Area Config Register 22 : R Config 2 Field
                    v_ram_address                         := "010110";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(3 downto 0) <= v_ram_readdata(7 downto 4);

                when (16#45#) =>
                    -- RMAP Area Config Register 22 : Cdsclp Lo Field
                    v_ram_address                         := "010110";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(3 downto 0) <= v_ram_readdata(11 downto 8);

                when (16#46#) =>
                    -- RMAP Area Config Register 22 : Register 22 Configuration Reserved
                    v_ram_address                          := "010110";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(19 downto 0) <= v_ram_readdata(31 downto 12);

                when (16#47#) =>
                    -- RMAP Area Config Register 23 : CCD 1 Last E Packet Field
                    v_ram_address                         := "010111";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(9 downto 0) <= v_ram_readdata(9 downto 0);

                when (16#48#) =>
                    -- RMAP Area Config Register 23 : CCD 1 Last F Packet Field
                    v_ram_address                         := "010111";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(9 downto 0) <= v_ram_readdata(19 downto 10);

                when (16#49#) =>
                    -- RMAP Area Config Register 23 : CCD 2 Last E Packet Field
                    v_ram_address                         := "010111";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(9 downto 0) <= v_ram_readdata(29 downto 20);

                when (16#4A#) =>
                    -- RMAP Area Config Register 23 : Register 23 Configuration Reserved
                    v_ram_address                         := "010111";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(1 downto 0) <= v_ram_readdata(31 downto 30);

                when (16#4B#) =>
                    -- RMAP Area Config Register 24 : CCD 2 Last F Packet Field
                    v_ram_address                         := "011000";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(9 downto 0) <= v_ram_readdata(9 downto 0);

                when (16#4C#) =>
                    -- RMAP Area Config Register 24 : CCD 3 Last E Packet Field
                    v_ram_address                         := "011000";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(9 downto 0) <= v_ram_readdata(19 downto 10);

                when (16#4D#) =>
                    -- RMAP Area Config Register 24 : CCD 3 Last F Packet Field
                    v_ram_address                         := "011000";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(9 downto 0) <= v_ram_readdata(29 downto 20);

                when (16#4E#) =>
                    -- RMAP Area Config Register 24 : Register 24 Configuration Reserved
                    v_ram_address                         := "011000";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(1 downto 0) <= v_ram_readdata(31 downto 30);

                when (16#4F#) =>
                    -- RMAP Area Config Register 25 : CCD 4 Last E Packet Field
                    v_ram_address                         := "011001";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(9 downto 0) <= v_ram_readdata(9 downto 0);

                when (16#50#) =>
                    -- RMAP Area Config Register 25 : CCD 4 Last F Packet Field
                    v_ram_address                         := "011001";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(9 downto 0) <= v_ram_readdata(19 downto 10);

                when (16#51#) =>
                    -- RMAP Area Config Register 25 : Surface Inversion Counter Field
                    v_ram_address                         := "011001";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(9 downto 0) <= v_ram_readdata(29 downto 20);

                when (16#52#) =>
                    -- RMAP Area Config Register 25 : Register 25 Configuration Reserved
                    v_ram_address                         := "011001";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(1 downto 0) <= v_ram_readdata(31 downto 30);

                when (16#53#) =>
                    -- RMAP Area Config Register 26 : Readout Pause Counter Field
                    v_ram_address                          := "011010";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(15 downto 0);

                when (16#54#) =>
                    -- RMAP Area Config Register 26 : Trap Pumping Shuffle Counter Field
                    v_ram_address                          := "011010";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(31 downto 16);

                when (16#55#) =>
                    -- RMAP Area HK Register 0 : TOU Sense 1 HK Field
                    v_ram_address                          := "011011";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(31 downto 16);

                when (16#56#) =>
                    -- RMAP Area HK Register 0 : TOU Sense 2 HK Field
                    v_ram_address                          := "011011";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(15 downto 0);

                when (16#57#) =>
                    -- RMAP Area HK Register 1 : TOU Sense 3 HK Field
                    v_ram_address                          := "011100";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(31 downto 16);

                when (16#58#) =>
                    -- RMAP Area HK Register 1 : TOU Sense 4 HK Field
                    v_ram_address                          := "011100";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(15 downto 0);

                when (16#59#) =>
                    -- RMAP Area HK Register 2 : TOU Sense 5 HK Field
                    v_ram_address                          := "011101";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(31 downto 16);

                when (16#5A#) =>
                    -- RMAP Area HK Register 2 : TOU Sense 6 HK Field
                    v_ram_address                          := "011101";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(15 downto 0);

                when (16#5B#) =>
                    -- RMAP Area HK Register 3 : CCD 1 TS HK Field
                    v_ram_address                          := "011110";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(31 downto 16);

                when (16#5C#) =>
                    -- RMAP Area HK Register 3 : CCD 2 TS HK Field
                    v_ram_address                          := "011110";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(15 downto 0);

                when (16#5D#) =>
                    -- RMAP Area HK Register 4 : CCD 3 TS HK Field
                    v_ram_address                          := "011111";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(31 downto 16);

                when (16#5E#) =>
                    -- RMAP Area HK Register 4 : CCD 4 TS HK Field
                    v_ram_address                          := "011111";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(15 downto 0);

                when (16#5F#) =>
                    -- RMAP Area HK Register 5 : PRT 1 HK Field
                    v_ram_address                          := "100000";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(31 downto 16);

                when (16#60#) =>
                    -- RMAP Area HK Register 5 : PRT 2 HK Field
                    v_ram_address                          := "100000";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(15 downto 0);

                when (16#61#) =>
                    -- RMAP Area HK Register 6 : PRT 3 HK Field
                    v_ram_address                          := "100001";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(31 downto 16);

                when (16#62#) =>
                    -- RMAP Area HK Register 6 : PRT 4 HK Field
                    v_ram_address                          := "100001";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(15 downto 0);

                when (16#63#) =>
                    -- RMAP Area HK Register 7 : PRT 5 HK Field
                    v_ram_address                          := "100010";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(31 downto 16);

                when (16#64#) =>
                    -- RMAP Area HK Register 7 : Zero Diff Amplifier HK Field
                    v_ram_address                          := "100010";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(15 downto 0);

                when (16#65#) =>
                    -- RMAP Area HK Register 8 : CCD 1 Vod Monitor HK Field
                    v_ram_address                          := "100011";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(31 downto 16);

                when (16#66#) =>
                    -- RMAP Area HK Register 8 : CCD 1 Vog Monitor HK Field
                    v_ram_address                          := "100011";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(15 downto 0);

                when (16#67#) =>
                    -- RMAP Area HK Register 9 : CCD 1 Vrd Monitor E HK Field
                    v_ram_address                          := "100100";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(31 downto 16);

                when (16#68#) =>
                    -- RMAP Area HK Register 9 : CCD 2 Vod Monitor HK Field
                    v_ram_address                          := "100100";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(15 downto 0);

                when (16#69#) =>
                    -- RMAP Area HK Register 10 : CCD 2 Vog Monitor HK Field
                    v_ram_address                          := "100101";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(31 downto 16);

                when (16#6A#) =>
                    -- RMAP Area HK Register 10 : CCD 2 Vrd Monitor E HK Field
                    v_ram_address                          := "100101";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(15 downto 0);

                when (16#6B#) =>
                    -- RMAP Area HK Register 11 : CCD 3 Vod Monitor HK Field
                    v_ram_address                          := "100110";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(31 downto 16);

                when (16#6C#) =>
                    -- RMAP Area HK Register 11 : CCD 3 Vog Monitor HK Field
                    v_ram_address                          := "100110";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(15 downto 0);

                when (16#6D#) =>
                    -- RMAP Area HK Register 12 : CCD 3 Vrd Monitor E HK Field
                    v_ram_address                          := "100111";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(31 downto 16);

                when (16#6E#) =>
                    -- RMAP Area HK Register 12 : CCD 4 Vod Monitor HK Field
                    v_ram_address                          := "100111";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(15 downto 0);

                when (16#6F#) =>
                    -- RMAP Area HK Register 13 : CCD 4 Vog Monitor HK Field
                    v_ram_address                          := "101000";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(31 downto 16);

                when (16#70#) =>
                    -- RMAP Area HK Register 13 : CCD 4 Vrd Monitor E HK Field
                    v_ram_address                          := "101000";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(15 downto 0);

                when (16#71#) =>
                    -- RMAP Area HK Register 14 : V CCD HK Field
                    v_ram_address                          := "101001";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(31 downto 16);

                when (16#72#) =>
                    -- RMAP Area HK Register 14 : VRClock Monitor HK Field
                    v_ram_address                          := "101001";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(15 downto 0);

                when (16#73#) =>
                    -- RMAP Area HK Register 15 : VIClock HK Field
                    v_ram_address                          := "101010";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(31 downto 16);

                when (16#74#) =>
                    -- RMAP Area HK Register 15 : VRClock Low HK Field
                    v_ram_address                          := "101010";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(15 downto 0);

                when (16#75#) =>
                    -- RMAP Area HK Register 16 : 5Vb Positive Monitor HK Field
                    v_ram_address                          := "101011";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(31 downto 16);

                when (16#76#) =>
                    -- RMAP Area HK Register 16 : 5Vb Negative Monitor HK Field
                    v_ram_address                          := "101011";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(15 downto 0);

                when (16#77#) =>
                    -- RMAP Area HK Register 17 : 3V3b Monitor HK Field
                    v_ram_address                          := "101100";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(31 downto 16);

                when (16#78#) =>
                    -- RMAP Area HK Register 17 : 2V5a Monitor HK Field
                    v_ram_address                          := "101100";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(15 downto 0);

                when (16#79#) =>
                    -- RMAP Area HK Register 18 : 3V3d Monitor HK Field
                    v_ram_address                          := "101101";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(31 downto 16);

                when (16#7A#) =>
                    -- RMAP Area HK Register 18 : 2V5d Monitor HK Field
                    v_ram_address                          := "101101";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(15 downto 0);

                when (16#7B#) =>
                    -- RMAP Area HK Register 19 : 1V5d Monitor HK Field
                    v_ram_address                          := "101110";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(31 downto 16);

                when (16#7C#) =>
                    -- RMAP Area HK Register 19 : 5Vref Monitor HK Field
                    v_ram_address                          := "101110";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(15 downto 0);

                when (16#7D#) =>
                    -- RMAP Area HK Register 20 : Vccd Positive Raw HK Field
                    v_ram_address                          := "101111";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(31 downto 16);

                when (16#7E#) =>
                    -- RMAP Area HK Register 20 : Vclk Positive Raw HK Field
                    v_ram_address                          := "101111";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(15 downto 0);

                when (16#7F#) =>
                    -- RMAP Area HK Register 21 : Van 1 Positive Raw HK Field
                    v_ram_address                          := "110000";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(31 downto 16);

                when (16#80#) =>
                    -- RMAP Area HK Register 21 : Van 3 Negative Monitor HK Field
                    v_ram_address                          := "110000";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(15 downto 0);

                when (16#81#) =>
                    -- RMAP Area HK Register 22 : Van Positive Raw HK Field
                    v_ram_address                          := "110001";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(31 downto 16);

                when (16#82#) =>
                    -- RMAP Area HK Register 22 : Vdig Raw HK Field
                    v_ram_address                          := "110001";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(15 downto 0);

                when (16#83#) =>
                    -- RMAP Area HK Register 23 : Vdig Raw 2 HK Field
                    v_ram_address                          := "110010";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(31 downto 16);

                when (16#84#) =>
                    -- RMAP Area HK Register 23 : VIClock Low HK Field
                    v_ram_address                          := "110010";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(15 downto 0);

                when (16#85#) =>
                    -- RMAP Area HK Register 24 : CCD 1 Vrd Monitor F HK Field
                    v_ram_address                          := "110011";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(31 downto 16);

                when (16#86#) =>
                    -- RMAP Area HK Register 24 : CCD 1 Vdd Monitor HK Field
                    v_ram_address                          := "110011";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(15 downto 0);

                when (16#87#) =>
                    -- RMAP Area HK Register 25 : CCD 1 Vgd Monitor HK Field
                    v_ram_address                          := "110100";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(31 downto 16);

                when (16#88#) =>
                    -- RMAP Area HK Register 25 : CCD 2 Vrd Monitor F HK Field
                    v_ram_address                          := "110100";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(15 downto 0);

                when (16#89#) =>
                    -- RMAP Area HK Register 26 : CCD 2 Vdd Monitor HK Field
                    v_ram_address                          := "110101";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(31 downto 16);

                when (16#8A#) =>
                    -- RMAP Area HK Register 26 : CCD 2 Vgd Monitor HK Field
                    v_ram_address                          := "110101";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(15 downto 0);

                when (16#8B#) =>
                    -- RMAP Area HK Register 27 : CCD 3 Vrd Monitor F HK Field
                    v_ram_address                          := "110110";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(31 downto 16);

                when (16#8C#) =>
                    -- RMAP Area HK Register 27 : CCD 3 Vdd Monitor HK Field
                    v_ram_address                          := "110110";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(15 downto 0);

                when (16#8D#) =>
                    -- RMAP Area HK Register 28 : CCD 3 Vgd Monitor HK Field
                    v_ram_address                          := "110111";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(31 downto 16);

                when (16#8E#) =>
                    -- RMAP Area HK Register 28 : CCD 4 Vrd Monitor F HK Field
                    v_ram_address                          := "110111";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(15 downto 0);

                when (16#8F#) =>
                    -- RMAP Area HK Register 29 : CCD 4 Vdd Monitor HK Field
                    v_ram_address                          := "111000";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(31 downto 16);

                when (16#90#) =>
                    -- RMAP Area HK Register 29 : CCD 4 Vgd Monitor HK Field
                    v_ram_address                          := "111000";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(15 downto 0);

                when (16#91#) =>
                    -- RMAP Area HK Register 30 : Ig High Monitor HK Field
                    v_ram_address                          := "111001";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(31 downto 16);

                when (16#92#) =>
                    -- RMAP Area HK Register 30 : Ig Low Monitor HK Field
                    v_ram_address                          := "111001";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(15 downto 0);

                when (16#93#) =>
                    -- RMAP Area HK Register 31 : Tsense A HK Field
                    v_ram_address                          := "111010";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(31 downto 16);

                when (16#94#) =>
                    -- RMAP Area HK Register 31 : Tsense B HK Field
                    v_ram_address                          := "111010";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(15 downto 0);

                when (16#95#) =>
                    -- RMAP Area HK Register 32 : SpW Status : Timecode From SpaceWire HK Field
                    avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_rd_i.reg_32_hk.spw_status_timecode_from_spw;
                    avalon_mm_rmap_o.waitrequest          <= '0';

                when (16#96#) =>
                    -- RMAP Area HK Register 32 : SpW Status : RMAP Target Status HK Field
                    avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_rd_i.reg_32_hk.spw_status_rmap_target_status;
                    avalon_mm_rmap_o.waitrequest          <= '0';

                when (16#97#) =>
                    -- RMAP Area HK Register 32 : SpW Status : SpaceWire Status Reserved
                    v_ram_address                         := "111011";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(1 downto 0) <= v_ram_readdata(7 downto 6);

                when (16#98#) =>
                    -- RMAP Area HK Register 32 : SpW Status : RMAP Target Indicate HK Field
                    avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.reg_32_hk.spw_status_rmap_target_indicate;
                    avalon_mm_rmap_o.waitrequest <= '0';

                when (16#99#) =>
                    -- RMAP Area HK Register 32 : SpW Status : Status Link Escape Error HK Field
                    avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.reg_32_hk.spw_status_stat_link_escape_error;
                    avalon_mm_rmap_o.waitrequest <= '0';

                when (16#9A#) =>
                    -- RMAP Area HK Register 32 : SpW Status : Status Link Credit Error HK Field
                    avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.reg_32_hk.spw_status_stat_link_credit_error;
                    avalon_mm_rmap_o.waitrequest <= '0';

                when (16#9B#) =>
                    -- RMAP Area HK Register 32 : SpW Status : Status Link Parity Error HK Field
                    avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.reg_32_hk.spw_status_stat_link_parity_error;
                    avalon_mm_rmap_o.waitrequest <= '0';

                when (16#9C#) =>
                    -- RMAP Area HK Register 32 : SpW Status : Status Link Disconnect HK Field
                    avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.reg_32_hk.spw_status_stat_link_disconnect;
                    avalon_mm_rmap_o.waitrequest <= '0';

                when (16#9D#) =>
                    -- RMAP Area HK Register 32 : SpW Status : Status Link Running HK Field
                    avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.reg_32_hk.spw_status_stat_link_running;
                    avalon_mm_rmap_o.waitrequest <= '0';

                when (16#9E#) =>
                    -- RMAP Area HK Register 32 : Register 32 HK Reserved
                    v_ram_address                         := "111011";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(7 downto 0) <= v_ram_readdata(31 downto 24);

                when (16#9F#) =>
                    -- RMAP Area HK Register 33 : Frame Counter HK Field
                    avalon_mm_rmap_o.readdata(15 downto 0) <= rmap_registers_rd_i.reg_33_hk.frame_counter;
                    avalon_mm_rmap_o.waitrequest           <= '0';

                when (16#A0#) =>
                    -- RMAP Area HK Register 33 : Register 33 HK Reserved
                    v_ram_address                         := "111100";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(9 downto 0) <= v_ram_readdata(15 downto 6);

                when (16#A1#) =>
                    -- RMAP Area HK Register 33 : Operational Mode HK Field
                    v_ram_address                         := "111100";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(3 downto 0) <= v_ram_readdata(5 downto 2);

                when (16#A2#) =>
                    -- RMAP Area HK Register 33 : Frame Number HK Field
                    avalon_mm_rmap_o.readdata(1 downto 0) <= rmap_registers_rd_i.reg_33_hk.frame_number;
                    avalon_mm_rmap_o.waitrequest          <= '0';

                when (16#A3#) =>
                    -- RMAP Area HK Register 34 : Error Flags : Window Pixels Fall Outside CDD Boundary Due To Wrong X Coordinate HK Field
                    avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.reg_34_hk.error_flags_window_pixels_fall_outside_cdd_boundary_due_to_wrong_x_coordinate;
                    avalon_mm_rmap_o.waitrequest <= '0';

                when (16#A4#) =>
                    -- RMAP Area HK Register 34 : Error Flags : Window Pixels Fall Outside CDD Boundary Due To Wrong Y Coordinate HK Field
                    avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.reg_34_hk.error_flags_window_pixels_fall_outside_cdd_boundary_due_to_wrong_y_coordinate;
                    avalon_mm_rmap_o.waitrequest <= '0';

                when (16#A5#) =>
                    -- RMAP Area HK Register 34 : Error Flags : E Side Pixel External SRAM Buffer is Full HK Field
                    avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.reg_34_hk.error_flags_e_side_pixel_external_sram_buffer_is_full;
                    avalon_mm_rmap_o.waitrequest <= '0';

                when (16#A6#) =>
                    -- RMAP Area HK Register 34 : Error Flags : F Side Pixel External SRAM Buffer is Full HK Field
                    avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.reg_34_hk.error_flags_f_side_pixel_external_sram_buffer_is_full;
                    avalon_mm_rmap_o.waitrequest <= '0';

                when (16#A7#) =>
                    -- RMAP Area HK Register 34 : Error Flags : Too Many Overlapping Windows
                    avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.reg_34_hk.error_flags_too_many_overlapping_windows;
                    avalon_mm_rmap_o.waitrequest <= '0';

                when (16#A8#) =>
                    -- RMAP Area HK Register 34 : Error Flags : SRAM EDAC Correctable
                    avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.reg_34_hk.error_flags_sram_edac_correctable;
                    avalon_mm_rmap_o.waitrequest <= '0';

                when (16#A9#) =>
                    -- RMAP Area HK Register 34 : Error Flags : SRAM EDAC Uncorrectable
                    avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.reg_34_hk.error_flags_sram_edac_uncorrectable;
                    avalon_mm_rmap_o.waitrequest <= '0';

                when (16#AA#) =>
                    -- RMAP Area HK Register 34 : Error Flags : BLOCK RAM EDAC Uncorrectable
                    avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.reg_34_hk.error_flags_block_ram_edac_uncorrectable;
                    avalon_mm_rmap_o.waitrequest <= '0';

                when (16#AB#) =>
                    -- RMAP Area HK Register 34 : Error Flags : Error Flags Reserved
                    v_ram_address                          := "111101";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(23 downto 0) <= v_ram_readdata(31 downto 8);

                when (16#AC#) =>
                    -- RMAP Area HK Register 35 : FPGA Minor Version Field
                    v_ram_address                         := "111110";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(7 downto 0) <= v_ram_readdata(7 downto 0);

                when (16#AD#) =>
                    -- RMAP Area HK Register 35 : FPGA Major Version Field
                    v_ram_address                         := "111110";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(3 downto 0) <= v_ram_readdata(11 downto 8);

                when (16#AE#) =>
                    -- RMAP Area HK Register 35 : Board ID Field
                    v_ram_address                         := "111110";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(8 downto 0) <= v_ram_readdata(20 downto 12);

                when (16#AF#) =>
                    -- RMAP Area HK Register 35 : Register 35 HK Reserved HK Field
                    v_ram_address                          := "111110";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(10 downto 0) <= v_ram_readdata(31 downto 21);

                when others =>
                    -- No register associated to the address, return with 0x00000000
                    avalon_mm_rmap_o.readdata    <= (others => '0');
                    avalon_mm_rmap_o.waitrequest <= '0';

            end case;

        end procedure p_avs_readdata;
        --
        variable v_fee_read_address : std_logic_vector(31 downto 0)      := (others => '0');
        variable v_avs_read_address : t_nrme_avalon_mm_rmap_nfee_address := 0;
    begin
        if (rst_i = '1') then
            fee_rmap_o.readdata          <= (others => '0');
            fee_rmap_o.waitrequest       <= '1';
            avalon_mm_rmap_o.readdata    <= (others => '0');
            avalon_mm_rmap_o.waitrequest <= '1';
            s_read_started               <= '0';
            s_read_in_progress           <= '0';
            s_read_finished              <= '0';
            v_fee_read_address           := (others => '0');
            v_avs_read_address           := 0;
        elsif (rising_edge(clk_i)) then

            fee_rmap_o.readdata          <= (others => '0');
            fee_rmap_o.waitrequest       <= '1';
            avalon_mm_rmap_o.readdata    <= (others => '0');
            avalon_mm_rmap_o.waitrequest <= '1';
            s_read_started               <= '0';
            s_read_in_progress           <= '0';
            s_read_finished              <= '0';
            if (fee_rmap_i.read = '1') then
                v_fee_read_address := fee_rmap_i.address;
                --                fee_rmap_o.waitrequest <= '0';
                p_nfee_rmap_mem_rd(v_fee_read_address);
            elsif (avalon_mm_rmap_i.read = '1') then
                v_avs_read_address := to_integer(unsigned(avalon_mm_rmap_i.address));
                --                avalon_mm_rmap_o.waitrequest <= '0';
                p_avs_readdata(v_avs_read_address);
            end if;

        end if;
    end process p_nrme_rmap_mem_area_nfee_read;

end architecture RTL;
