library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.nrme_rmap_mem_area_nfee_pkg.all;
use work.nrme_avalon_mm_rmap_nfee_pkg.all;

entity nrme_rmap_mem_area_nfee_write_ent is
    port(
        clk_i                  : in  std_logic;
        rst_i                  : in  std_logic;
        fee_rmap_i             : in  t_nrme_nfee_rmap_write_in;
        avalon_mm_rmap_i       : in  t_nrme_avalon_mm_rmap_nfee_write_in;
        memarea_idle_i         : in  std_logic;
        memarea_wrdone_i       : in  std_logic;
        fee_rmap_o             : out t_nrme_nfee_rmap_write_out;
        avalon_mm_rmap_o       : out t_nrme_avalon_mm_rmap_nfee_write_out;
        rmap_registers_wr_o    : out t_rmap_memory_wr_area;
        memarea_wraddress_o    : out std_logic_vector(5 downto 0);
        memarea_wrbyteenable_o : out std_logic_vector(3 downto 0);
        memarea_wrbitmask_o    : out std_logic_vector(31 downto 0);
        memarea_wrdata_o       : out std_logic_vector(31 downto 0);
        memarea_write_o        : out std_logic
    );
end entity nrme_rmap_mem_area_nfee_write_ent;

architecture RTL of nrme_rmap_mem_area_nfee_write_ent is

    signal s_write_started     : std_logic;
    signal s_write_in_progress : std_logic;
    signal s_write_finished    : std_logic;

    signal s_data_registered : std_logic;

begin

    p_nrme_rmap_mem_area_nfee_write : process(clk_i, rst_i) is
        procedure p_rmap_ram_wr(
            constant RMAP_ADDRESS_I    : in std_logic_vector;
            constant RMAP_BYTEENABLE_I : in std_logic_vector;
            constant RMAP_BITMASK_I    : in std_logic_vector;
            constant RMAP_WRITEDATA_I  : in std_logic_vector;
            signal rmap_waitrequest_o  : out std_logic
        ) is
        begin
            memarea_wraddress_o    <= (others => '0');
            memarea_wrbyteenable_o <= (others => '1');
            memarea_wrbitmask_o    <= (others => '1');
            memarea_wrdata_o       <= (others => '0');
            memarea_write_o        <= '0';
            -- check if a write was finished    
            if (s_write_finished = '1') then
                -- a write was finished
                -- keep setted the write finished flag
                s_write_finished   <= '1';
                -- keep cleared the waitrequest flag
                rmap_waitrequest_o <= '0';
            else
                -- check if a write is not in progress and was not just started
                if ((s_write_in_progress = '0') and (s_write_started = '0')) then
                    -- a write is not in progress
                    -- check if the mem aerea is on idle (can receive commands)
                    if (memarea_idle_i = '1') then
                        -- the mem aerea is on idle (can receive commands)
                        -- send write to mem area
                        memarea_wraddress_o    <= RMAP_ADDRESS_I((memarea_wraddress_o'length - 1) downto 0);
                        memarea_wrbyteenable_o <= RMAP_BYTEENABLE_I((memarea_wrbyteenable_o'length - 1) downto 0);
                        memarea_wrbitmask_o    <= RMAP_BITMASK_I((memarea_wrbitmask_o'length - 1) downto 0);
                        memarea_wrdata_o       <= RMAP_WRITEDATA_I((memarea_wrdata_o'length - 1) downto 0);
                        memarea_write_o        <= '1';
                        -- set the write started flag
                        s_write_started        <= '1';
                        -- set the write in progress flag
                        s_write_in_progress    <= '1';
                    end if;
                -- check if a write is in progress and was just started    
                elsif ((s_write_in_progress = '1') and (s_write_started = '1')) then
                    -- clear the write started flag
                    s_write_started     <= '0';
                    -- keep setted the write in progress flag
                    s_write_in_progress <= '1';
                -- check if a write is in progress and was not just started    
                elsif ((s_write_in_progress = '1') and (s_write_started = '0')) then
                    -- a write is in progress
                    -- keep setted the write in progress flag
                    s_write_in_progress <= '1';
                    -- check if the write is done
                    if ((memarea_wrdone_i = '1') or (memarea_idle_i = '1')) then
                        -- the write is done
                        -- clear the write in progress flag
                        s_write_in_progress <= '0';
                        -- set the write finished flag
                        s_write_finished    <= '1';
                        -- clear the waitrequest flag
                        rmap_waitrequest_o  <= '0';
                    end if;
                end if;
            end if;
        end procedure p_rmap_ram_wr;
        --
        procedure p_nfee_reg_reset is
        begin

            -- Write Registers Reset/Default State

            -- RMAP Area Config Register 21 : Clear Error Flag Config Field
            rmap_registers_wr_o.reg_21_config.clear_error_flag <= '0';

        end procedure p_nfee_reg_reset;
        --
        procedure p_nfee_reg_trigger is
        begin

            -- Write Registers Triggers Reset

            -- RMAP Area Config Register 21 : Clear Error Flag Config Field
            rmap_registers_wr_o.reg_21_config.clear_error_flag <= '0';

        end procedure p_nfee_reg_trigger;
        --
        procedure p_nfee_mem_wr(wr_addr_i : std_logic_vector) is
            variable v_ram_address    : std_logic_vector(5 downto 0)  := (others => '0');
            variable v_ram_byteenable : std_logic_vector(3 downto 0)  := (others => '1');
            constant c_RAM_BITMASK    : std_logic_vector(31 downto 0) := (others => '1');
            variable v_ram_writedata  : std_logic_vector(31 downto 0) := (others => '0');
        begin

            -- MemArea Write Data

            case (wr_addr_i(31 downto 0)) is
                -- Case for access to all memory area

                when (x"00000000") =>
                    -- RMAP Area Config Register 0 : V End Config Field
                    v_ram_address                 := "000000";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000001") =>
                    -- RMAP Area Config Register 0 : V End Config Field
                    v_ram_address                 := "000000";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000002") =>
                    -- RMAP Area Config Register 0 : V Start Config Field
                    v_ram_address                := "000000";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000003") =>
                    -- RMAP Area Config Register 0 : V Start Config Field
                    v_ram_address               := "000000";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000004") =>
                    -- RMAP Area Config Register 1 : Charge Injection Gap Config Field
                    v_ram_address                 := "000001";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000005") =>
                    -- RMAP Area Config Register 1 : Charge Injection Gap Config Field
                    v_ram_address                 := "000001";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000006") =>
                    -- RMAP Area Config Register 1 : Charge Injection Width Config Field
                    v_ram_address                := "000001";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000007") =>
                    -- RMAP Area Config Register 1 : Charge Injection Width Config Field
                    v_ram_address               := "000001";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000008") =>
                    -- RMAP Area Config Register 2 : CCD Readout Order Config Field (1st CCD)
                    -- RMAP Area Config Register 2 : CCD Readout Order Config Field (2nd CCD)
                    -- RMAP Area Config Register 2 : CCD Readout Order Config Field (3rd CCD)
                    -- RMAP Area Config Register 2 : CCD Readout Order Config Field (4th CCD)
                    v_ram_address                 := "000010";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000009") =>
                    -- RMAP Area Config Register 2 : Parallel Clock Overlap Config Field
                    v_ram_address                 := "000010";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000000A") =>
                    -- RMAP Area Config Register 2 : Parallel Toi Period Config Field
                    -- RMAP Area Config Register 2 : Parallel Clock Overlap Config Field
                    v_ram_address                := "000010";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000000B") =>
                    -- RMAP Area Config Register 2 : Parallel Toi Period Config Field
                    v_ram_address               := "000010";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000000C") =>
                    -- RMAP Area Config Register 3 : H End Config Field
                    -- RMAP Area Config Register 3 : Charge Injection Enable Config Field
                    -- RMAP Area Config Register 3 : Tri Level Clock Enable Config Field
                    -- RMAP Area Config Register 3 : Image Clock Direction Config Field
                    -- RMAP Area Config Register 3 : Register Clock Direction Config Field
                    v_ram_address                 := "000011";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000000D") =>
                    -- RMAP Area Config Register 3 : H End Config Field
                    v_ram_address                 := "000011";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000000E") =>
                    -- RMAP Area Config Register 3 : N Final Dump Config Field
                    v_ram_address                := "000011";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000000F") =>
                    -- RMAP Area Config Register 3 : N Final Dump Config Field
                    v_ram_address               := "000011";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000010") =>
                    -- RMAP Area Config Register 4 : Internal Sync Period Config Field
                    v_ram_address                 := "000100";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000011") =>
                    -- RMAP Area Config Register 4 : Internal Sync Period Config Field
                    v_ram_address                 := "000100";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000012") =>
                    -- RMAP Area Config Register 4 : Data Packet Size Config Field
                    v_ram_address                := "000100";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000013") =>
                    -- RMAP Area Config Register 4 : Data Packet Size Config Field
                    v_ram_address               := "000100";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000014") =>
                    -- RMAP Area Config Register 5 : DG (Drain Gate) Enable Field
                    -- RMAP Area Config Register 5 : CCD Readout Enable Field
                    -- RMAP Area Config Register 5 : Conversion Delay Value
                    -- RMAP Area Config Register 5 : High Precison Housekeep Enable Field
                    v_ram_address                 := "000101";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000015") =>
                    -- RMAP Area Config Register 5 : Trap Pumping Dwell Counter Field
                    -- RMAP Area Config Register 5 : Sync Source Selection Config Field
                    -- RMAP Area Config Register 5 : CCD Port Data Sensor Selection Config Field
                    -- RMAP Area Config Register 5 : Digitalise Enable Config Field
                    v_ram_address                 := "000101";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000016") =>
                    -- RMAP Area Config Register 5 : Trap Pumping Dwell Counter Field
                    v_ram_address                := "000101";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000017") =>
                    -- RMAP Area Config Register 5 : Trap Pumping Dwell Counter Field
                    v_ram_address               := "000101";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000018") =>
                    -- RMAP Area Config Register 6 : CCD 1 Window List Pointer Config Field
                    v_ram_address                 := "000110";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000019") =>
                    -- RMAP Area Config Register 6 : CCD 1 Window List Pointer Config Field
                    v_ram_address                 := "000110";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000001A") =>
                    -- RMAP Area Config Register 6 : CCD 1 Window List Pointer Config Field
                    v_ram_address                := "000110";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000001B") =>
                    -- RMAP Area Config Register 6 : CCD 1 Window List Pointer Config Field
                    v_ram_address               := "000110";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000001C") =>
                    -- RMAP Area Config Register 7 : CCD 1 Packet Order List Pointer Config Field
                    v_ram_address                 := "000111";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000001D") =>
                    -- RMAP Area Config Register 7 : CCD 1 Packet Order List Pointer Config Field
                    v_ram_address                 := "000111";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000001E") =>
                    -- RMAP Area Config Register 7 : CCD 1 Packet Order List Pointer Config Field
                    v_ram_address                := "000111";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000001F") =>
                    -- RMAP Area Config Register 7 : CCD 1 Packet Order List Pointer Config Field
                    v_ram_address               := "000111";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000020") =>
                    -- RMAP Area Config Register 8 : CCD 1 Window Size Y Config Field
                    -- RMAP Area Config Register 8 : Register 8 Configuration Reserved
                    v_ram_address                 := "001000";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000021") =>
                    -- RMAP Area Config Register 8 : CCD 1 Window Size X Config Field
                    -- RMAP Area Config Register 8 : CCD 1 Window Size Y Config Field
                    v_ram_address                 := "001000";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000022") =>
                    -- RMAP Area Config Register 8 : CCD 1 Window List Length Config Field
                    v_ram_address                := "001000";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000023") =>
                    -- RMAP Area Config Register 8 : CCD 1 Window List Length Config Field
                    v_ram_address               := "001000";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000024") =>
                    -- RMAP Area Config Register 9 : CCD 2 Window List Pointer Config Field
                    v_ram_address                 := "001001";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000025") =>
                    -- RMAP Area Config Register 9 : CCD 2 Window List Pointer Config Field
                    v_ram_address                 := "001001";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000026") =>
                    -- RMAP Area Config Register 9 : CCD 2 Window List Pointer Config Field
                    v_ram_address                := "001001";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000027") =>
                    -- RMAP Area Config Register 9 : CCD 2 Window List Pointer Config Field
                    v_ram_address               := "001001";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000028") =>
                    -- RMAP Area Config Register 10 : CCD 2 Packet Order List Pointer Config Field
                    v_ram_address                 := "001010";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000029") =>
                    -- RMAP Area Config Register 10 : CCD 2 Packet Order List Pointer Config Field
                    v_ram_address                 := "001010";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000002A") =>
                    -- RMAP Area Config Register 10 : CCD 2 Packet Order List Pointer Config Field
                    v_ram_address                := "001010";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000002B") =>
                    -- RMAP Area Config Register 10 : CCD 2 Packet Order List Pointer Config Field
                    v_ram_address               := "001010";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000002C") =>
                    -- RMAP Area Config Register 11 : CCD 2 Window Size Y Config Field
                    -- RMAP Area Config Register 11 : Register 11 Configuration Reserved
                    v_ram_address                 := "001011";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000002D") =>
                    -- RMAP Area Config Register 11 : CCD 2 Window Size X Config Field
                    -- RMAP Area Config Register 11 : CCD 2 Window Size Y Config Field
                    v_ram_address                 := "001011";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000002E") =>
                    -- RMAP Area Config Register 11 : CCD 2 Window List Length Config Field
                    v_ram_address                := "001011";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000002F") =>
                    -- RMAP Area Config Register 11 : CCD 2 Window List Length Config Field
                    v_ram_address               := "001011";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000030") =>
                    -- RMAP Area Config Register 12 : CCD 3 Window List Pointer Config Field
                    v_ram_address                 := "001100";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000031") =>
                    -- RMAP Area Config Register 12 : CCD 3 Window List Pointer Config Field
                    v_ram_address                 := "001100";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000032") =>
                    -- RMAP Area Config Register 12 : CCD 3 Window List Pointer Config Field
                    v_ram_address                := "001100";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000033") =>
                    -- RMAP Area Config Register 12 : CCD 3 Window List Pointer Config Field
                    v_ram_address               := "001100";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000034") =>
                    -- RMAP Area Config Register 13 : CCD 3 Packet Order List Pointer Config Field
                    v_ram_address                 := "001101";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000035") =>
                    -- RMAP Area Config Register 13 : CCD 3 Packet Order List Pointer Config Field
                    v_ram_address                 := "001101";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000036") =>
                    -- RMAP Area Config Register 13 : CCD 3 Packet Order List Pointer Config Field
                    v_ram_address                := "001101";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000037") =>
                    -- RMAP Area Config Register 13 : CCD 3 Packet Order List Pointer Config Field
                    v_ram_address               := "001101";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000038") =>
                    -- RMAP Area Config Register 14 : CCD 3 Window Size Y Config Field
                    -- RMAP Area Config Register 14 : Register 14 Configuration Reserved
                    v_ram_address                 := "001110";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000039") =>
                    -- RMAP Area Config Register 14 : CCD 3 Window Size X Config Field
                    -- RMAP Area Config Register 14 : CCD 3 Window Size Y Config Field
                    v_ram_address                 := "001110";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000003A") =>
                    -- RMAP Area Config Register 14 : CCD 3 Window List Length Config Field
                    v_ram_address                := "001110";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000003B") =>
                    -- RMAP Area Config Register 14 : CCD 3 Window List Length Config Field
                    v_ram_address               := "001110";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000003C") =>
                    -- RMAP Area Config Register 15 : CCD 4 Window List Pointer Config Field
                    v_ram_address                 := "001111";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000003D") =>
                    -- RMAP Area Config Register 15 : CCD 4 Window List Pointer Config Field
                    v_ram_address                 := "001111";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000003E") =>
                    -- RMAP Area Config Register 15 : CCD 4 Window List Pointer Config Field
                    v_ram_address                := "001111";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000003F") =>
                    -- RMAP Area Config Register 15 : CCD 4 Window List Pointer Config Field
                    v_ram_address               := "001111";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000040") =>
                    -- RMAP Area Config Register 16 : CCD 4 Packet Order List Pointer Config Field
                    v_ram_address                 := "010000";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000041") =>
                    -- RMAP Area Config Register 16 : CCD 4 Packet Order List Pointer Config Field
                    v_ram_address                 := "010000";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000042") =>
                    -- RMAP Area Config Register 16 : CCD 4 Packet Order List Pointer Config Field
                    v_ram_address                := "010000";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000043") =>
                    -- RMAP Area Config Register 16 : CCD 4 Packet Order List Pointer Config Field
                    v_ram_address               := "010000";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000044") =>
                    -- RMAP Area Config Register 17 : CCD 4 Window Size Y Config Field
                    -- RMAP Area Config Register 17 : Register 17 Configuration Reserved
                    v_ram_address                 := "010001";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000045") =>
                    -- RMAP Area Config Register 17 : CCD 4 Window Size X Config Field
                    -- RMAP Area Config Register 17 : CCD 4 Window Size Y Config Field
                    v_ram_address                 := "010001";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000046") =>
                    -- RMAP Area Config Register 17 : CCD 4 Window List Length Config Field
                    v_ram_address                := "010001";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000047") =>
                    -- RMAP Area Config Register 17 : CCD 4 Window List Length Config Field
                    v_ram_address               := "010001";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000048") =>
                    -- RMAP Area Config Register 18 : CCD 2 Vrd Configuration Config Field
                    v_ram_address                 := "010010";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000049") =>
                    -- RMAP Area Config Register 18 : CCD 1 Vrd Configuration Config Field
                    v_ram_address                 := "010010";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000004A") =>
                    -- RMAP Area Config Register 18 : CCD Vod Configuration Config Field
                    -- RMAP Area Config Register 18 : CCD 1 Vrd Configuration Config Field
                    v_ram_address                := "010010";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000004B") =>
                    -- RMAP Area Config Register 18 : CCD Vod Configuration Config Field
                    v_ram_address               := "010010";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000004C") =>
                    -- RMAP Area Config Register 19 : CCD 4 Vrd Configuration Config Field
                    -- RMAP Area Config Register 19 : CCD Vgd Configuration Config Field
                    v_ram_address                 := "010011";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000004D") =>
                    -- RMAP Area Config Register 19 : CCD 4 Vrd Configuration Config Field
                    v_ram_address                 := "010011";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000004E") =>
                    -- RMAP Area Config Register 19 : CCD 3 Vrd Configuration Config Field
                    v_ram_address                := "010011";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000004F") =>
                    -- RMAP Area Config Register 19 : CCD 2 Vrd Configuration Config Field
                    -- RMAP Area Config Register 19 : CCD 3 Vrd Configuration Config Field
                    v_ram_address               := "010011";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000050") =>
                    -- RMAP Area Config Register 20 : CCD Ig High Configuration Config Field
                    v_ram_address                 := "010100";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000051") =>
                    -- RMAP Area Config Register 20 : CCD Vog Configurion Config Field
                    -- RMAP Area Config Register 20 : CCD Ig High Configuration Config Field
                    v_ram_address                 := "010100";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000052") =>
                    -- RMAP Area Config Register 20 : CCD Vog Configurion Config Field
                    v_ram_address                := "010100";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000053") =>
                    -- RMAP Area Config Register 20 : CCD Vgd Configuration Config Field
                    v_ram_address               := "010100";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000054") =>
                    v_ram_address                 := "010101";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(30 downto 24) := fee_rmap_i.writedata(6 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);
                    -- RMAP Area Config Register 21 : Clear Error Flag Config Field
                    if (s_data_registered = '0') then
                        rmap_registers_wr_o.reg_21_config.clear_error_flag <= fee_rmap_i.writedata(7);
                    end if;
                    s_data_registered             <= '1';

                when (x"00000055") =>
                    -- RMAP Area Config Register 21 : Trk Hld High Configuration Config Field
                    -- RMAP Area Config Register 21 : Trk Hld Low Configuration Config Field
                    -- RMAP Area Config Register 21 : Register 21 Configuration Reserved
                    v_ram_address                 := "010101";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000056") =>
                    -- RMAP Area Config Register 21 : CCD Ig Low Configuration Config Field
                    -- RMAP Area Config Register 21 : Trk Hld High Configuration Config Field
                    v_ram_address                := "010101";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000057") =>
                    -- RMAP Area Config Register 21 : CCD Ig Low Configuration Config Field
                    v_ram_address               := "010101";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000058") =>
                    -- RMAP Area Config Register 22 : Register 22 Configuration Reserved
                    v_ram_address                 := "010110";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000059") =>
                    -- RMAP Area Config Register 22 : Register 22 Configuration Reserved
                    v_ram_address                 := "010110";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000005A") =>
                    -- RMAP Area Config Register 22 : Cdsclp Lo Field
                    -- RMAP Area Config egister 22 : Register 22 Configuration Reserved
                    v_ram_address                := "010110";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000005B") =>
                    -- RMAP Area Config Register 22 : R Config 1 Field
                    -- RMAP Area Config Register 22 : R Config 2 Field
                    v_ram_address               := "010110";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000005C") =>
                    -- RMAP Area Config Register 23 : CCD 2 Last E Packet Field
                    -- RMAP Area Config Register 23 : Register 23 Configuration Reserved
                    v_ram_address                 := "010111";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000005D") =>
                    -- RMAP Area Config Register 23 : CCD 1 Last F Packet Field
                    -- RMAP Area Config Register 23 : CCD 2 Last E Packet Field
                    v_ram_address                 := "010111";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000005E") =>
                    -- RMAP Area Config Register 23 : CCD 1 Last E Packet Field
                    -- RMAP Area Config Register 23 : CCD 1 Last F Packet Field
                    v_ram_address                := "010111";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000005F") =>
                    -- RMAP Area Config Register 23 : CCD 1 Last E Packet Field
                    v_ram_address               := "010111";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000060") =>
                    -- RMAP Area Config Register 24 : CCD 3 Last F Packet Field
                    -- RMAP Area Config Register 24 : Register 24 Configuration Reserved
                    v_ram_address                 := "011000";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000061") =>
                    -- RMAP Area Config Register 24 : CCD 3 Last E Packet Field
                    -- RMAP Area Config Register 24 : CCD 3 Last F Packet Field
                    v_ram_address                 := "011000";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000062") =>
                    -- RMAP Area Config Register 24 : CCD 2 Last F Packet Field
                    -- RMAP Area Config Register 24 : CCD 3 Last E Packet Field
                    v_ram_address                := "011000";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000063") =>
                    -- RMAP Area Config Register 24 : CCD 2 Last F Packet Field
                    v_ram_address               := "011000";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000064") =>
                    -- RMAP Area Config Register 25 : Surface Inversion Counter Field
                    -- RMAP Area Config Register 25 : Register 25 Configuration Reserved
                    v_ram_address                 := "011001";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000065") =>
                    -- RMAP Area Config Register 25 : CCD 4 Last F Packet Field
                    -- RMAP Area Config Register 25 : Surface Inversion Counter Field
                    v_ram_address                 := "011001";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000066") =>
                    -- RMAP Area Config Register 25 : CCD 4 Last E Packet Field
                    -- RMAP Area Config Register 25 : CCD 4 Last F Packet Field
                    v_ram_address                := "011001";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000067") =>
                    -- RMAP Area Config Register 25 : CCD 4 Last E Packet Field
                    v_ram_address               := "011001";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000068") =>
                    -- RMAP Area Config Register 26 : Trap Pumping Shuffle Counter Field
                    v_ram_address                 := "011010";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000069") =>
                    -- RMAP Area Config Register 26 : Trap Pumping Shuffle Counter Field
                    v_ram_address                 := "011010";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000006A") =>
                    -- RMAP Area Config Register 26 : Readout Pause Counter Field
                    v_ram_address                := "011010";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000006B") =>
                    -- RMAP Area Config Register 26 : Readout Pause Counter Field
                    v_ram_address               := "011010";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when others =>
                    fee_rmap_o.waitrequest <= '0';

            end case;

        end procedure p_nfee_mem_wr;
        --
        procedure p_avs_writedata(write_address_i : t_nrme_avalon_mm_rmap_nfee_address) is
            variable v_ram_address    : std_logic_vector(5 downto 0)  := (others => '0');
            variable v_ram_byteenable : std_logic_vector(3 downto 0)  := (others => '1');
            variable v_ram_wrbitmask  : std_logic_vector(31 downto 0) := (others => '1');
            variable v_ram_writedata  : std_logic_vector(31 downto 0) := (others => '0');
        begin

            -- Registers Write Data
            case (write_address_i) is
                -- Case for access to all registers address

                when (16#00#) =>
                    -- RMAP Area Config Register 0 : V Start Config Field
                    v_ram_address                := "000000";
                    v_ram_byteenable             := "0011";
                    v_ram_writedata              := (others => '0');
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata(15 downto 0) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#01#) =>
                    -- RMAP Area Config Register 0 : V End Config Field
                    v_ram_address                 := "000000";
                    v_ram_byteenable              := "1100";
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask               := (others => '1');
                    v_ram_writedata(31 downto 16) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#02#) =>
                    -- RMAP Area Config Register 1 : Charge Injection Width Config Field
                    v_ram_address                := "000001";
                    v_ram_byteenable             := "0011";
                    v_ram_writedata              := (others => '0');
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata(15 downto 0) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#03#) =>
                    -- RMAP Area Config Register 1 : Charge Injection Gap Config Field
                    v_ram_address                 := "000001";
                    v_ram_byteenable              := "1100";
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask               := (others => '1');
                    v_ram_writedata(31 downto 16) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#04#) =>
                    -- RMAP Area Config Register 2 : Parallel Toi Period Config Field
                    v_ram_address                := "000010";
                    v_ram_byteenable             := "0011";
                    v_ram_wrbitmask              := (others => '0');
                    v_ram_writedata              := (others => '0');
                    v_ram_wrbitmask(11 downto 0) := (others => '1');
                    v_ram_writedata(11 downto 0) := avalon_mm_rmap_i.writedata(11 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#05#) =>
                    -- RMAP Area Config Register 2 : Parallel Clock Overlap Config Field
                    v_ram_address                 := "000010";
                    v_ram_byteenable              := "0110";
                    v_ram_wrbitmask               := (others => '0');
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask(23 downto 12) := (others => '1');
                    v_ram_writedata(23 downto 12) := avalon_mm_rmap_i.writedata(11 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#06#) =>
                    -- RMAP Area Config Register 2 : CCD Readout Order Config Field (1st CCD)
                    v_ram_address                 := "000010";
                    v_ram_byteenable              := "1000";
                    v_ram_wrbitmask               := (others => '0');
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask(25 downto 24) := (others => '1');
                    v_ram_writedata(25 downto 24) := avalon_mm_rmap_i.writedata(1 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#07#) =>
                    -- RMAP Area Config Register 2 : CCD Readout Order Config Field (2nd CCD)
                    v_ram_address                 := "000010";
                    v_ram_byteenable              := "1000";
                    v_ram_wrbitmask               := (others => '0');
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask(27 downto 26) := (others => '1');
                    v_ram_writedata(27 downto 26) := avalon_mm_rmap_i.writedata(1 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#08#) =>
                    -- RMAP Area Config Register 2 : CCD Readout Order Config Field (3rd CCD)
                    v_ram_address                 := "000010";
                    v_ram_byteenable              := "1000";
                    v_ram_wrbitmask               := (others => '0');
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask(29 downto 28) := (others => '1');
                    v_ram_writedata(29 downto 28) := avalon_mm_rmap_i.writedata(1 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#09#) =>
                    -- RMAP Area Config Register 2 : CCD Readout Order Config Field (4th CCD)
                    v_ram_address                 := "000010";
                    v_ram_byteenable              := "1000";
                    v_ram_wrbitmask               := (others => '0');
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask(31 downto 30) := (others => '1');
                    v_ram_writedata(31 downto 30) := avalon_mm_rmap_i.writedata(1 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#0A#) =>
                    -- RMAP Area Config Register 3 : N Final Dump Config Field
                    v_ram_address                := "000011";
                    v_ram_byteenable             := "0011";
                    v_ram_writedata              := (others => '0');
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata(15 downto 0) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#0B#) =>
                    -- RMAP Area Config Register 3 : H End Config Field
                    v_ram_address                 := "000011";
                    v_ram_byteenable              := "1100";
                    v_ram_wrbitmask               := (others => '0');
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask(27 downto 16) := (others => '1');
                    v_ram_writedata(27 downto 16) := avalon_mm_rmap_i.writedata(11 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#0C#) =>
                    -- RMAP Area Config Register 3 : Charge Injection Enable Config Field
                    v_ram_address       := "000011";
                    v_ram_byteenable    := "1000";
                    v_ram_wrbitmask     := (others => '0');
                    v_ram_writedata     := (others => '0');
                    v_ram_wrbitmask(28) := '1';
                    v_ram_writedata(28) := avalon_mm_rmap_i.writedata(0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#0D#) =>
                    -- RMAP Area Config Register 3 : Tri Level Clock Enable Config Field
                    v_ram_address       := "000011";
                    v_ram_byteenable    := "1000";
                    v_ram_wrbitmask     := (others => '0');
                    v_ram_writedata     := (others => '0');
                    v_ram_wrbitmask(29) := '1';
                    v_ram_writedata(29) := avalon_mm_rmap_i.writedata(0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#0E#) =>
                    -- RMAP Area Config Register 3 : Image Clock Direction Config Field
                    v_ram_address       := "000011";
                    v_ram_byteenable    := "1000";
                    v_ram_wrbitmask     := (others => '0');
                    v_ram_writedata     := (others => '0');
                    v_ram_wrbitmask(30) := '1';
                    v_ram_writedata(30) := avalon_mm_rmap_i.writedata(0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#0F#) =>
                    -- RMAP Area Config Register 3 : Register Clock Direction Config Field
                    v_ram_address       := "000011";
                    v_ram_byteenable    := "1000";
                    v_ram_wrbitmask     := (others => '0');
                    v_ram_writedata     := (others => '0');
                    v_ram_wrbitmask(31) := '1';
                    v_ram_writedata(31) := avalon_mm_rmap_i.writedata(0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#10#) =>
                    -- RMAP Area Config Register 4 : Data Packet Size Config Field
                    v_ram_address                := "000100";
                    v_ram_byteenable             := "0011";
                    v_ram_writedata              := (others => '0');
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata(15 downto 0) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#11#) =>
                    -- RMAP Area Config Register 4 : Internal Sync Period Config Field
                    v_ram_address                 := "000100";
                    v_ram_byteenable              := "1100";
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask               := (others => '1');
                    v_ram_writedata(31 downto 16) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#12#) =>
                    -- RMAP Area Config Register 5 : Trap Pumping Dwell Counter Field
                    v_ram_address                := "000101";
                    v_ram_byteenable             := "0111";
                    v_ram_wrbitmask              := (others => '0');
                    v_ram_writedata              := (others => '0');
                    v_ram_wrbitmask(19 downto 0) := (others => '1');
                    v_ram_writedata(19 downto 0) := avalon_mm_rmap_i.writedata(19 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#13#) =>
                    -- RMAP Area Config Register 5 : Sync Source Selection Config Field
                    v_ram_address       := "000101";
                    v_ram_byteenable    := "0100";
                    v_ram_wrbitmask     := (others => '0');
                    v_ram_writedata     := (others => '0');
                    v_ram_wrbitmask(20) := '1';
                    v_ram_writedata(20) := avalon_mm_rmap_i.writedata(0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#14#) =>
                    -- RMAP Area Config Register 5 : CCD Port Data Sensor Selection Config Field
                    v_ram_address                 := "000101";
                    v_ram_byteenable              := "0100";
                    v_ram_wrbitmask               := (others => '0');
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask(22 downto 21) := (others => '1');
                    v_ram_writedata(22 downto 21) := avalon_mm_rmap_i.writedata(1 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#15#) =>
                    -- RMAP Area Config Register 5 : Digitalise Enable Config Field
                    v_ram_address       := "000101";
                    v_ram_byteenable    := "0100";
                    v_ram_wrbitmask     := (others => '0');
                    v_ram_writedata     := (others => '0');
                    v_ram_wrbitmask(23) := '1';
                    v_ram_writedata(23) := avalon_mm_rmap_i.writedata(0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#16#) =>
                    -- RMAP Area Config Register 5 : DG (Drain Gate) Enable Field
                    v_ram_address       := "000101";
                    v_ram_byteenable    := "1000";
                    v_ram_wrbitmask     := (others => '0');
                    v_ram_writedata     := (others => '0');
                    v_ram_wrbitmask(24) := '1';
                    v_ram_writedata(24) := avalon_mm_rmap_i.writedata(0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#17#) =>
                    -- RMAP Area Config Register 5 : CCD Readout Enable Field
                    v_ram_address       := "000101";
                    v_ram_byteenable    := "1000";
                    v_ram_wrbitmask     := (others => '0');
                    v_ram_writedata     := (others => '0');
                    v_ram_wrbitmask(25) := '1';
                    v_ram_writedata(25) := avalon_mm_rmap_i.writedata(0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#18#) =>
                    -- RMAP Area Config Register 5 : Conversion Delay Value
                    v_ram_address                 := "000101";
                    v_ram_byteenable              := "1000";
                    v_ram_wrbitmask               := (others => '0');
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask(30 downto 26) := (others => '1');
                    v_ram_writedata(30 downto 26) := avalon_mm_rmap_i.writedata(4 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#19#) =>
                    -- RMAP Area Config Register 5 : High Precison Housekeep Enable Field
                    v_ram_address       := "000101";
                    v_ram_byteenable    := "1000";
                    v_ram_wrbitmask     := (others => '0');
                    v_ram_writedata     := (others => '0');
                    v_ram_wrbitmask(31) := '1';
                    v_ram_writedata(31) := avalon_mm_rmap_i.writedata(0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#1A#) =>
                    -- RMAP Area Config Register 6 : CCD 1 Window List Pointer Config Field
                    v_ram_address                := "000110";
                    v_ram_byteenable             := "1111";
                    v_ram_writedata              := (others => '0');
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#1B#) =>
                    -- RMAP Area Config Register 7 : CCD 1 Packet Order List Pointer Config Field
                    v_ram_address                := "000111";
                    v_ram_byteenable             := "1111";
                    v_ram_writedata              := (others => '0');
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#1C#) =>
                    -- RMAP Area Config Register 8 : CCD 1 Window List Length Config Field
                    v_ram_address                := "001000";
                    v_ram_byteenable             := "0011";
                    v_ram_writedata              := (others => '0');
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata(15 downto 0) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#1D#) =>
                    -- RMAP Area Config Register 8 : CCD 1 Window Size X Config Field
                    v_ram_address                 := "001000";
                    v_ram_byteenable              := "0100";
                    v_ram_wrbitmask               := (others => '0');
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask(21 downto 16) := (others => '1');
                    v_ram_writedata(21 downto 16) := avalon_mm_rmap_i.writedata(5 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#1E#) =>
                    -- RMAP Area Config Register 8 : CCD 1 Window Size Y Config Field
                    v_ram_address                 := "001000";
                    v_ram_byteenable              := "1100";
                    v_ram_wrbitmask               := (others => '0');
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask(27 downto 22) := (others => '1');
                    v_ram_writedata(27 downto 22) := avalon_mm_rmap_i.writedata(5 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#1F#) =>
                    -- RMAP Area Config Register 8 : Register 8 Configuration Reserved
                    v_ram_address                 := "001000";
                    v_ram_byteenable              := "1000";
                    v_ram_wrbitmask               := (others => '0');
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask(31 downto 28) := (others => '1');
                    v_ram_writedata(31 downto 28) := avalon_mm_rmap_i.writedata(3 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#20#) =>
                    -- RMAP Area Config Register 9 : CCD 2 Window List Pointer Config Field
                    v_ram_address                := "001001";
                    v_ram_byteenable             := "1111";
                    v_ram_writedata              := (others => '0');
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#21#) =>
                    -- RMAP Area Config Register 10 : CCD 2 Packet Order List Pointer Config Field
                    v_ram_address                := "001010";
                    v_ram_byteenable             := "1111";
                    v_ram_writedata              := (others => '0');
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#22#) =>
                    -- RMAP Area Config Register 11 : CCD 2 Window List Length Config Field
                    v_ram_address                := "001011";
                    v_ram_byteenable             := "0011";
                    v_ram_writedata              := (others => '0');
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata(15 downto 0) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#23#) =>
                    -- RMAP Area Config Register 11 : CCD 2 Window Size X Config Field
                    v_ram_address                 := "001011";
                    v_ram_byteenable              := "0100";
                    v_ram_wrbitmask               := (others => '0');
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask(21 downto 16) := (others => '1');
                    v_ram_writedata(21 downto 16) := avalon_mm_rmap_i.writedata(5 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#24#) =>
                    -- RMAP Area Config Register 11 : CCD 2 Window Size Y Config Field
                    v_ram_address                 := "001011";
                    v_ram_byteenable              := "1100";
                    v_ram_wrbitmask               := (others => '0');
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask(27 downto 22) := (others => '1');
                    v_ram_writedata(27 downto 22) := avalon_mm_rmap_i.writedata(5 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#25#) =>
                    -- RMAP Area Config Register 11 : Register 11 Configuration Reserved
                    v_ram_address                 := "001011";
                    v_ram_byteenable              := "1000";
                    v_ram_wrbitmask               := (others => '0');
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask(31 downto 28) := (others => '1');
                    v_ram_writedata(31 downto 28) := avalon_mm_rmap_i.writedata(3 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#26#) =>
                    -- RMAP Area Config Register 12 : CCD 3 Window List Pointer Config Field
                    v_ram_address                := "001100";
                    v_ram_byteenable             := "1111";
                    v_ram_writedata              := (others => '0');
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#27#) =>
                    -- RMAP Area Config Register 13 : CCD 3 Packet Order List Pointer Config Field
                    v_ram_address                := "001101";
                    v_ram_byteenable             := "1111";
                    v_ram_writedata              := (others => '0');
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#28#) =>
                    -- RMAP Area Config Register 14 : CCD 3 Window List Length Config Field
                    v_ram_address                := "001110";
                    v_ram_byteenable             := "0011";
                    v_ram_writedata              := (others => '0');
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata(15 downto 0) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#29#) =>
                    -- RMAP Area Config Register 14 : CCD 3 Window Size X Config Field
                    v_ram_address                 := "001110";
                    v_ram_byteenable              := "0100";
                    v_ram_wrbitmask               := (others => '0');
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask(21 downto 16) := (others => '1');
                    v_ram_writedata(21 downto 16) := avalon_mm_rmap_i.writedata(5 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#2A#) =>
                    -- RMAP Area Config Register 14 : CCD 3 Window Size Y Config Field
                    v_ram_address                 := "001110";
                    v_ram_byteenable              := "1100";
                    v_ram_wrbitmask               := (others => '0');
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask(27 downto 22) := (others => '1');
                    v_ram_writedata(27 downto 22) := avalon_mm_rmap_i.writedata(5 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#2B#) =>
                    -- RMAP Area Config Register 14 : Register 14 Configuration Reserved
                    v_ram_address                 := "001110";
                    v_ram_byteenable              := "1000";
                    v_ram_wrbitmask               := (others => '0');
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask(31 downto 28) := (others => '1');
                    v_ram_writedata(31 downto 28) := avalon_mm_rmap_i.writedata(3 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#2C#) =>
                    -- RMAP Area Config Register 15 : CCD 4 Window List Pointer Config Field
                    v_ram_address                := "001111";
                    v_ram_byteenable             := "1111";
                    v_ram_writedata              := (others => '0');
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#2D#) =>
                    -- RMAP Area Config Register 16 : CCD 4 Packet Order List Pointer Config Field
                    v_ram_address                := "010000";
                    v_ram_byteenable             := "1111";
                    v_ram_writedata              := (others => '0');
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#2E#) =>
                    -- RMAP Area Config Register 17 : CCD 4 Window List Length Config Field
                    v_ram_address                := "010001";
                    v_ram_byteenable             := "0011";
                    v_ram_writedata              := (others => '0');
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata(15 downto 0) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#2F#) =>
                    -- RMAP Area Config Register 17 : CCD 4 Window Size X Config Field
                    v_ram_address                 := "010001";
                    v_ram_byteenable              := "0100";
                    v_ram_wrbitmask               := (others => '0');
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask(21 downto 16) := (others => '1');
                    v_ram_writedata(21 downto 16) := avalon_mm_rmap_i.writedata(5 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#30#) =>
                    -- RMAP Area Config Register 17 : CCD 4 Window Size Y Config Field
                    v_ram_address                 := "010001";
                    v_ram_byteenable              := "1100";
                    v_ram_wrbitmask               := (others => '0');
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask(27 downto 22) := (others => '1');
                    v_ram_writedata(27 downto 22) := avalon_mm_rmap_i.writedata(5 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#31#) =>
                    -- RMAP Area Config Register 17 : Register 17 Configuration Reserved
                    v_ram_address                 := "010001";
                    v_ram_byteenable              := "1000";
                    v_ram_wrbitmask               := (others => '0');
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask(31 downto 28) := (others => '1');
                    v_ram_writedata(31 downto 28) := avalon_mm_rmap_i.writedata(3 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#32#) =>
                    -- RMAP Area Config Register 18 : CCD Vod Configuration Config Field
                    v_ram_address                := "010010";
                    v_ram_byteenable             := "0011";
                    v_ram_wrbitmask              := (others => '0');
                    v_ram_writedata              := (others => '0');
                    v_ram_wrbitmask(11 downto 0) := (others => '1');
                    v_ram_writedata(11 downto 0) := avalon_mm_rmap_i.writedata(11 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#33#) =>
                    -- RMAP Area Config Register 18 : CCD 1 Vrd Configuration Config Field
                    v_ram_address                 := "010010";
                    v_ram_byteenable              := "0110";
                    v_ram_wrbitmask               := (others => '0');
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask(23 downto 12) := (others => '1');
                    v_ram_writedata(23 downto 12) := avalon_mm_rmap_i.writedata(11 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#34#) =>
                    -- RMAP Area Config Register 18 : CCD 2 Vrd Configuration Config Field
                    v_ram_address                 := "010010";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask               := (others => '1');
                    v_ram_writedata(31 downto 24) := avalon_mm_rmap_i.writedata(7 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#35#) =>
                    -- RMAP Area Config Register 19 : CCD 2 Vrd Configuration Config Field
                    v_ram_address               := "010011";
                    v_ram_byteenable            := "0001";
                    v_ram_wrbitmask             := (others => '0');
                    v_ram_writedata             := (others => '0');
                    v_ram_wrbitmask(3 downto 0) := (others => '1');
                    v_ram_writedata(3 downto 0) := avalon_mm_rmap_i.writedata(3 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#36#) =>
                    -- RMAP Area Config Register 19 : CCD 3 Vrd Configuration Config Field
                    v_ram_address                := "010011";
                    v_ram_byteenable             := "0011";
                    v_ram_wrbitmask              := (others => '0');
                    v_ram_writedata              := (others => '0');
                    v_ram_wrbitmask(15 downto 4) := (others => '1');
                    v_ram_writedata(15 downto 4) := avalon_mm_rmap_i.writedata(11 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#37#) =>
                    -- RMAP Area Config Register 19 : CCD 4 Vrd Configuration Config Field
                    v_ram_address                 := "010011";
                    v_ram_byteenable              := "1100";
                    v_ram_wrbitmask               := (others => '0');
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask(27 downto 16) := (others => '1');
                    v_ram_writedata(27 downto 16) := avalon_mm_rmap_i.writedata(11 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#38#) =>
                    -- RMAP Area Config Register 19 : CCD Vgd Configuration Config Field
                    v_ram_address                 := "010011";
                    v_ram_byteenable              := "1000";
                    v_ram_wrbitmask               := (others => '0');
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask(31 downto 28) := (others => '1');
                    v_ram_writedata(31 downto 28) := avalon_mm_rmap_i.writedata(3 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#39#) =>
                    -- RMAP Area Config Register 20 : CCD Vgd Configuration Config Field
                    v_ram_address               := "010100";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_wrbitmask             := (others => '1');
                    v_ram_writedata(7 downto 0) := avalon_mm_rmap_i.writedata(7 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#3A#) =>
                    -- RMAP Area Config Register 20 : CCD Vog Configurion Config Field
                    v_ram_address                := "010100";
                    v_ram_byteenable             := "0110";
                    v_ram_wrbitmask              := (others => '0');
                    v_ram_writedata              := (others => '0');
                    v_ram_wrbitmask(19 downto 8) := (others => '1');
                    v_ram_writedata(19 downto 8) := avalon_mm_rmap_i.writedata(11 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#3B#) =>
                    -- RMAP Area Config Register 20 : CCD Ig High Configuration Config Field
                    v_ram_address                 := "010100";
                    v_ram_byteenable              := "1100";
                    v_ram_wrbitmask               := (others => '0');
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask(31 downto 20) := (others => '1');
                    v_ram_writedata(31 downto 20) := avalon_mm_rmap_i.writedata(11 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#3C#) =>
                    -- RMAP Area Config Register 21 : CCD Ig Low Configuration Config Field
                    v_ram_address                := "010101";
                    v_ram_byteenable             := "0011";
                    v_ram_wrbitmask              := (others => '0');
                    v_ram_writedata              := (others => '0');
                    v_ram_wrbitmask(11 downto 0) := (others => '1');
                    v_ram_writedata(11 downto 0) := avalon_mm_rmap_i.writedata(11 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#3D#) =>
                    -- RMAP Area Config Register 21 : Trk Hld High Configuration Config Field
                    v_ram_address                 := "010101";
                    v_ram_byteenable              := "0110";
                    v_ram_wrbitmask               := (others => '0');
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask(16 downto 12) := (others => '1');
                    v_ram_writedata(16 downto 12) := avalon_mm_rmap_i.writedata(4 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#3E#) =>
                    -- RMAP Area Config Register 21 : Trk Hld Low Configuration Config Field
                    v_ram_address                 := "010101";
                    v_ram_byteenable              := "0100";
                    v_ram_wrbitmask               := (others => '0');
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask(21 downto 17) := (others => '1');
                    v_ram_writedata(21 downto 17) := avalon_mm_rmap_i.writedata(4 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#3F#) =>
                    -- RMAP Area Config Register 21 : Register 21 Configuration Reserved
                    v_ram_address                 := "010101";
                    v_ram_byteenable              := "0100";
                    v_ram_wrbitmask               := (others => '0');
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask(23 downto 22) := (others => '1');
                    v_ram_writedata(23 downto 22) := avalon_mm_rmap_i.writedata(1 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#40#) =>
                    -- RMAP Area Config Register 21 : CCD Mode Configuration Config Field
                    v_ram_address                 := "010101";
                    v_ram_byteenable              := "1000";
                    v_ram_wrbitmask               := (others => '0');
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask(27 downto 24) := (others => '1');
                    v_ram_writedata(27 downto 24) := avalon_mm_rmap_i.writedata(3 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#41#) =>
                    -- RMAP Area Config Register 21 : Register 21 Configuration Reserved
                    v_ram_address                 := "010101";
                    v_ram_byteenable              := "1000";
                    v_ram_wrbitmask               := (others => '0');
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask(30 downto 28) := (others => '1');
                    v_ram_writedata(30 downto 28) := avalon_mm_rmap_i.writedata(2 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#42#) =>
                    -- RMAP Area Config Register 21 : Clear Error Flag Config Field
                    if (s_data_registered = '0') then
                        rmap_registers_wr_o.reg_21_config.clear_error_flag <= avalon_mm_rmap_i.writedata(0);
                    end if;
                    s_data_registered            <= '1';
                    avalon_mm_rmap_o.waitrequest <= '0';

                when (16#43#) =>
                    -- RMAP Area Config Register 22 : R Config 1 Field
                    v_ram_address               := "010110";
                    v_ram_byteenable            := "0001";
                    v_ram_wrbitmask             := (others => '0');
                    v_ram_writedata             := (others => '0');
                    v_ram_wrbitmask(3 downto 0) := (others => '1');
                    v_ram_writedata(3 downto 0) := avalon_mm_rmap_i.writedata(3 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#44#) =>
                    -- RMAP Area Config Register 22 : R Config 2 Field
                    v_ram_address               := "010110";
                    v_ram_byteenable            := "0001";
                    v_ram_wrbitmask             := (others => '0');
                    v_ram_writedata             := (others => '0');
                    v_ram_wrbitmask(7 downto 4) := (others => '1');
                    v_ram_writedata(7 downto 4) := avalon_mm_rmap_i.writedata(3 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#45#) =>
                    -- RMAP Area Config Register 22 : Cdsclp Lo Field
                    v_ram_address                := "010110";
                    v_ram_byteenable             := "0010";
                    v_ram_wrbitmask              := (others => '0');
                    v_ram_writedata              := (others => '0');
                    v_ram_wrbitmask(11 downto 8) := (others => '1');
                    v_ram_writedata(11 downto 8) := avalon_mm_rmap_i.writedata(3 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#46#) =>
                    -- RMAP Area Config Register 22 : Register 22 Configuration Reserved
                    v_ram_address                 := "010110";
                    v_ram_byteenable              := "1110";
                    v_ram_wrbitmask               := (others => '0');
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask(31 downto 12) := (others => '1');
                    v_ram_writedata(31 downto 12) := avalon_mm_rmap_i.writedata(19 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#47#) =>
                    -- RMAP Area Config Register 23 : CCD 1 Last E Packet Field
                    v_ram_address               := "010111";
                    v_ram_byteenable            := "0011";
                    v_ram_wrbitmask             := (others => '0');
                    v_ram_writedata             := (others => '0');
                    v_ram_wrbitmask(9 downto 0) := (others => '1');
                    v_ram_writedata(9 downto 0) := avalon_mm_rmap_i.writedata(9 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#48#) =>
                    -- RMAP Area Config Register 23 : CCD 1 Last F Packet Field
                    v_ram_address                 := "010111";
                    v_ram_byteenable              := "0110";
                    v_ram_wrbitmask               := (others => '0');
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask(19 downto 10) := (others => '1');
                    v_ram_writedata(19 downto 10) := avalon_mm_rmap_i.writedata(9 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#49#) =>
                    -- RMAP Area Config Register 23 : CCD 2 Last E Packet Field
                    v_ram_address                 := "010111";
                    v_ram_byteenable              := "1100";
                    v_ram_wrbitmask               := (others => '0');
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask(29 downto 20) := (others => '1');
                    v_ram_writedata(29 downto 20) := avalon_mm_rmap_i.writedata(9 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#4A#) =>
                    -- RMAP Area Config Register 23 : Register 23 Configuration Reserved
                    v_ram_address                 := "010111";
                    v_ram_byteenable              := "1000";
                    v_ram_wrbitmask               := (others => '0');
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask(31 downto 30) := (others => '1');
                    v_ram_writedata(31 downto 30) := avalon_mm_rmap_i.writedata(1 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#4B#) =>
                    -- RMAP Area Config Register 24 : CCD 2 Last F Packet Field
                    v_ram_address               := "011000";
                    v_ram_byteenable            := "0011";
                    v_ram_wrbitmask             := (others => '0');
                    v_ram_writedata             := (others => '0');
                    v_ram_wrbitmask(9 downto 0) := (others => '1');
                    v_ram_writedata(9 downto 0) := avalon_mm_rmap_i.writedata(9 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#4C#) =>
                    -- RMAP Area Config Register 24 : CCD 3 Last E Packet Field
                    v_ram_address                 := "011000";
                    v_ram_byteenable              := "0110";
                    v_ram_wrbitmask               := (others => '0');
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask(19 downto 10) := (others => '1');
                    v_ram_writedata(19 downto 10) := avalon_mm_rmap_i.writedata(9 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#4D#) =>
                    -- RMAP Area Config Register 24 : CCD 3 Last F Packet Field
                    v_ram_address                 := "011000";
                    v_ram_byteenable              := "1100";
                    v_ram_wrbitmask               := (others => '0');
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask(29 downto 20) := (others => '1');
                    v_ram_writedata(29 downto 20) := avalon_mm_rmap_i.writedata(9 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#4E#) =>
                    -- RMAP Area Config Register 24 : Register 24 Configuration Reserved
                    v_ram_address                 := "011000";
                    v_ram_byteenable              := "1000";
                    v_ram_wrbitmask               := (others => '0');
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask(31 downto 30) := (others => '1');
                    v_ram_writedata(31 downto 30) := avalon_mm_rmap_i.writedata(1 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#4F#) =>
                    -- RMAP Area Config Register 25 : CCD 4 Last E Packet Field
                    v_ram_address               := "011001";
                    v_ram_byteenable            := "0011";
                    v_ram_wrbitmask             := (others => '0');
                    v_ram_writedata             := (others => '0');
                    v_ram_wrbitmask(9 downto 0) := (others => '1');
                    v_ram_writedata(9 downto 0) := avalon_mm_rmap_i.writedata(9 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#50#) =>
                    -- RMAP Area Config Register 25 : CCD 4 Last F Packet Field
                    v_ram_address                 := "011001";
                    v_ram_byteenable              := "0110";
                    v_ram_wrbitmask               := (others => '0');
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask(19 downto 10) := (others => '1');
                    v_ram_writedata(19 downto 10) := avalon_mm_rmap_i.writedata(9 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#51#) =>
                    -- RMAP Area Config Register 25 : Surface Inversion Counter Field
                    v_ram_address                 := "011001";
                    v_ram_byteenable              := "1100";
                    v_ram_wrbitmask               := (others => '0');
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask(29 downto 20) := (others => '1');
                    v_ram_writedata(29 downto 20) := avalon_mm_rmap_i.writedata(9 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#52#) =>
                    -- RMAP Area Config Register 25 : Register 25 Configuration Reserved
                    v_ram_address                 := "011001";
                    v_ram_byteenable              := "1000";
                    v_ram_wrbitmask               := (others => '0');
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask(31 downto 30) := (others => '1');
                    v_ram_writedata(31 downto 30) := avalon_mm_rmap_i.writedata(1 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#53#) =>
                    -- RMAP Area Config Register 26 : Readout Pause Counter Field
                    v_ram_address                := "011010";
                    v_ram_byteenable             := "0011";
                    v_ram_writedata              := (others => '0');
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata(15 downto 0) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#54#) =>
                    -- RMAP Area Config Register 26 : Trap Pumping Shuffle Counter Field
                    v_ram_address                 := "011010";
                    v_ram_byteenable              := "1100";
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask               := (others => '1');
                    v_ram_writedata(31 downto 16) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#55#) =>
                    -- RMAP Area HK Register 0 : TOU Sense 1 HK Field
                    v_ram_address                 := "011011";
                    v_ram_byteenable              := "1100";
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask               := (others => '1');
                    v_ram_writedata(31 downto 16) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#56#) =>
                    -- RMAP Area HK Register 0 : TOU Sense 2 HK Field
                    v_ram_address                := "011011";
                    v_ram_byteenable             := "0011";
                    v_ram_writedata              := (others => '0');
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata(15 downto 0) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#57#) =>
                    -- RMAP Area HK Register 1 : TOU Sense 3 HK Field
                    v_ram_address                 := "011100";
                    v_ram_byteenable              := "1100";
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask               := (others => '1');
                    v_ram_writedata(31 downto 16) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#58#) =>
                    -- RMAP Area HK Register 1 : TOU Sense 4 HK Field
                    v_ram_address                := "011100";
                    v_ram_byteenable             := "0011";
                    v_ram_writedata              := (others => '0');
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata(15 downto 0) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#59#) =>
                    -- RMAP Area HK Register 2 : TOU Sense 5 HK Field
                    v_ram_address                 := "011101";
                    v_ram_byteenable              := "1100";
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask               := (others => '1');
                    v_ram_writedata(31 downto 16) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#5A#) =>
                    -- RMAP Area HK Register 2 : TOU Sense 6 HK Field
                    v_ram_address                := "011101";
                    v_ram_byteenable             := "0011";
                    v_ram_writedata              := (others => '0');
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata(15 downto 0) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#5B#) =>
                    -- RMAP Area HK Register 3 : CCD 1 TS HK Field
                    v_ram_address                 := "011110";
                    v_ram_byteenable              := "1100";
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask               := (others => '1');
                    v_ram_writedata(31 downto 16) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#5C#) =>
                    -- RMAP Area HK Register 3 : CCD 2 TS HK Field
                    v_ram_address                := "011110";
                    v_ram_byteenable             := "0011";
                    v_ram_writedata              := (others => '0');
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata(15 downto 0) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#5D#) =>
                    -- RMAP Area HK Register 4 : CCD 3 TS HK Field
                    v_ram_address                 := "011111";
                    v_ram_byteenable              := "1100";
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask               := (others => '1');
                    v_ram_writedata(31 downto 16) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#5E#) =>
                    -- RMAP Area HK Register 4 : CCD 4 TS HK Field
                    v_ram_address                := "011111";
                    v_ram_byteenable             := "0011";
                    v_ram_writedata              := (others => '0');
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata(15 downto 0) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#5F#) =>
                    -- RMAP Area HK Register 5 : PRT 1 HK Field
                    v_ram_address                 := "100000";
                    v_ram_byteenable              := "1100";
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask               := (others => '1');
                    v_ram_writedata(31 downto 16) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#60#) =>
                    -- RMAP Area HK Register 5 : PRT 2 HK Field
                    v_ram_address                := "100000";
                    v_ram_byteenable             := "0011";
                    v_ram_writedata              := (others => '0');
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata(15 downto 0) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#61#) =>
                    -- RMAP Area HK Register 6 : PRT 3 HK Field
                    v_ram_address                 := "100001";
                    v_ram_byteenable              := "1100";
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask               := (others => '1');
                    v_ram_writedata(31 downto 16) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#62#) =>
                    -- RMAP Area HK Register 6 : PRT 4 HK Field
                    v_ram_address                := "100001";
                    v_ram_byteenable             := "0011";
                    v_ram_writedata              := (others => '0');
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata(15 downto 0) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#63#) =>
                    -- RMAP Area HK Register 7 : PRT 5 HK Field
                    v_ram_address                 := "100010";
                    v_ram_byteenable              := "1100";
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask               := (others => '1');
                    v_ram_writedata(31 downto 16) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#64#) =>
                    -- RMAP Area HK Register 7 : Zero Diff Amplifier HK Field
                    v_ram_address                := "100010";
                    v_ram_byteenable             := "0011";
                    v_ram_writedata              := (others => '0');
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata(15 downto 0) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#65#) =>
                    -- RMAP Area HK Register 8 : CCD 1 Vod Monitor HK Field
                    v_ram_address                 := "100011";
                    v_ram_byteenable              := "1100";
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask               := (others => '1');
                    v_ram_writedata(31 downto 16) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#66#) =>
                    -- RMAP Area HK Register 8 : CCD 1 Vog Monitor HK Field
                    v_ram_address                := "100011";
                    v_ram_byteenable             := "0011";
                    v_ram_writedata              := (others => '0');
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata(15 downto 0) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#67#) =>
                    -- RMAP Area HK Register 9 : CCD 1 Vrd Monitor E HK Field
                    v_ram_address                 := "100100";
                    v_ram_byteenable              := "1100";
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask               := (others => '1');
                    v_ram_writedata(31 downto 16) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#68#) =>
                    -- RMAP Area HK Register 9 : CCD 2 Vod Monitor HK Field
                    v_ram_address                := "100100";
                    v_ram_byteenable             := "0011";
                    v_ram_writedata              := (others => '0');
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata(15 downto 0) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#69#) =>
                    -- RMAP Area HK Register 10 : CCD 2 Vog Monitor HK Field
                    v_ram_address                 := "100101";
                    v_ram_byteenable              := "1100";
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask               := (others => '1');
                    v_ram_writedata(31 downto 16) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#6A#) =>
                    -- RMAP Area HK Register 10 : CCD 2 Vrd Monitor E HK Field
                    v_ram_address                := "100101";
                    v_ram_byteenable             := "0011";
                    v_ram_writedata              := (others => '0');
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata(15 downto 0) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#6B#) =>
                    -- RMAP Area HK Register 11 : CCD 3 Vod Monitor HK Field
                    v_ram_address                 := "100110";
                    v_ram_byteenable              := "1100";
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask               := (others => '1');
                    v_ram_writedata(31 downto 16) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#6C#) =>
                    -- RMAP Area HK Register 11 : CCD 3 Vog Monitor HK Field
                    v_ram_address                := "100110";
                    v_ram_byteenable             := "0011";
                    v_ram_writedata              := (others => '0');
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata(15 downto 0) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#6D#) =>
                    -- RMAP Area HK Register 12 : CCD 3 Vrd Monitor E HK Field
                    v_ram_address                 := "100111";
                    v_ram_byteenable              := "1100";
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask               := (others => '1');
                    v_ram_writedata(31 downto 16) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#6E#) =>
                    -- RMAP Area HK Register 12 : CCD 4 Vod Monitor HK Field
                    v_ram_address                := "100111";
                    v_ram_byteenable             := "0011";
                    v_ram_writedata              := (others => '0');
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata(15 downto 0) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#6F#) =>
                    -- RMAP Area HK Register 13 : CCD 4 Vog Monitor HK Field
                    v_ram_address                 := "101000";
                    v_ram_byteenable              := "1100";
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask               := (others => '1');
                    v_ram_writedata(31 downto 16) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#70#) =>
                    -- RMAP Area HK Register 13 : CCD 4 Vrd Monitor E HK Field
                    v_ram_address                := "101000";
                    v_ram_byteenable             := "0011";
                    v_ram_writedata              := (others => '0');
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata(15 downto 0) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#71#) =>
                    -- RMAP Area HK Register 14 : V CCD HK Field
                    v_ram_address                 := "101001";
                    v_ram_byteenable              := "1100";
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask               := (others => '1');
                    v_ram_writedata(31 downto 16) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#72#) =>
                    -- RMAP Area HK Register 14 : VRClock Monitor HK Field
                    v_ram_address                := "101001";
                    v_ram_byteenable             := "0011";
                    v_ram_writedata              := (others => '0');
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata(15 downto 0) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#73#) =>
                    -- RMAP Area HK Register 15 : VIClock HK Field
                    v_ram_address                 := "101010";
                    v_ram_byteenable              := "1100";
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask               := (others => '1');
                    v_ram_writedata(31 downto 16) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#74#) =>
                    -- RMAP Area HK Register 15 : VRClock Low HK Field
                    v_ram_address                := "101010";
                    v_ram_byteenable             := "0011";
                    v_ram_writedata              := (others => '0');
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata(15 downto 0) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#75#) =>
                    -- RMAP Area HK Register 16 : 5Vb Positive Monitor HK Field
                    v_ram_address                 := "101011";
                    v_ram_byteenable              := "1100";
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask               := (others => '1');
                    v_ram_writedata(31 downto 16) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#76#) =>
                    -- RMAP Area HK Register 16 : 5Vb Negative Monitor HK Field
                    v_ram_address                := "101011";
                    v_ram_byteenable             := "0011";
                    v_ram_writedata              := (others => '0');
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata(15 downto 0) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#77#) =>
                    -- RMAP Area HK Register 17 : 3V3b Monitor HK Field
                    v_ram_address                 := "101100";
                    v_ram_byteenable              := "1100";
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask               := (others => '1');
                    v_ram_writedata(31 downto 16) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#78#) =>
                    -- RMAP Area HK Register 17 : 2V5a Monitor HK Field
                    v_ram_address                := "101100";
                    v_ram_byteenable             := "0011";
                    v_ram_writedata              := (others => '0');
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata(15 downto 0) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#79#) =>
                    -- RMAP Area HK Register 18 : 3V3d Monitor HK Field
                    v_ram_address                 := "101101";
                    v_ram_byteenable              := "1100";
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask               := (others => '1');
                    v_ram_writedata(31 downto 16) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#7A#) =>
                    -- RMAP Area HK Register 18 : 2V5d Monitor HK Field
                    v_ram_address                := "101101";
                    v_ram_byteenable             := "0011";
                    v_ram_writedata              := (others => '0');
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata(15 downto 0) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#7B#) =>
                    -- RMAP Area HK Register 19 : 1V5d Monitor HK Field
                    v_ram_address                 := "101110";
                    v_ram_byteenable              := "1100";
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask               := (others => '1');
                    v_ram_writedata(31 downto 16) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#7C#) =>
                    -- RMAP Area HK Register 19 : 5Vref Monitor HK Field
                    v_ram_address                := "101110";
                    v_ram_byteenable             := "0011";
                    v_ram_writedata              := (others => '0');
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata(15 downto 0) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#7D#) =>
                    -- RMAP Area HK Register 20 : Vccd Positive Raw HK Field
                    v_ram_address                 := "101111";
                    v_ram_byteenable              := "1100";
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask               := (others => '1');
                    v_ram_writedata(31 downto 16) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#7E#) =>
                    -- RMAP Area HK Register 20 : Vclk Positive Raw HK Field
                    v_ram_address                := "101111";
                    v_ram_byteenable             := "0011";
                    v_ram_writedata              := (others => '0');
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata(15 downto 0) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#7F#) =>
                    -- RMAP Area HK Register 21 : Van 1 Positive Raw HK Field
                    v_ram_address                 := "110000";
                    v_ram_byteenable              := "1100";
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask               := (others => '1');
                    v_ram_writedata(31 downto 16) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#80#) =>
                    -- RMAP Area HK Register 21 : Van 3 Negative Monitor HK Field
                    v_ram_address                := "110000";
                    v_ram_byteenable             := "0011";
                    v_ram_writedata              := (others => '0');
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata(15 downto 0) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#81#) =>
                    -- RMAP Area HK Register 22 : Van Positive Raw HK Field
                    v_ram_address                 := "110001";
                    v_ram_byteenable              := "1100";
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask               := (others => '1');
                    v_ram_writedata(31 downto 16) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#82#) =>
                    -- RMAP Area HK Register 22 : Vdig Raw HK Field
                    v_ram_address                := "110001";
                    v_ram_byteenable             := "0011";
                    v_ram_writedata              := (others => '0');
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata(15 downto 0) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#83#) =>
                    -- RMAP Area HK Register 23 : Vdig Raw 2 HK Field
                    v_ram_address                 := "110010";
                    v_ram_byteenable              := "1100";
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask               := (others => '1');
                    v_ram_writedata(31 downto 16) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#84#) =>
                    -- RMAP Area HK Register 23 : VIClock Low HK Field
                    v_ram_address                := "110010";
                    v_ram_byteenable             := "0011";
                    v_ram_writedata              := (others => '0');
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata(15 downto 0) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#85#) =>
                    -- RMAP Area HK Register 24 : CCD 1 Vrd Monitor F HK Field
                    v_ram_address                 := "110011";
                    v_ram_byteenable              := "1100";
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask               := (others => '1');
                    v_ram_writedata(31 downto 16) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#86#) =>
                    -- RMAP Area HK Register 24 : CCD 1 Vdd Monitor HK Field
                    v_ram_address                := "110011";
                    v_ram_byteenable             := "0011";
                    v_ram_writedata              := (others => '0');
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata(15 downto 0) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#87#) =>
                    -- RMAP Area HK Register 25 : CCD 1 Vgd Monitor HK Field
                    v_ram_address                 := "110100";
                    v_ram_byteenable              := "1100";
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask               := (others => '1');
                    v_ram_writedata(31 downto 16) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#88#) =>
                    -- RMAP Area HK Register 25 : CCD 2 Vrd Monitor F HK Field
                    v_ram_address                := "110100";
                    v_ram_byteenable             := "0011";
                    v_ram_writedata              := (others => '0');
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata(15 downto 0) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#89#) =>
                    -- RMAP Area HK Register 26 : CCD 2 Vdd Monitor HK Field
                    v_ram_address                 := "110101";
                    v_ram_byteenable              := "1100";
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask               := (others => '1');
                    v_ram_writedata(31 downto 16) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#8A#) =>
                    -- RMAP Area HK Register 26 : CCD 2 Vgd Monitor HK Field
                    v_ram_address                := "110101";
                    v_ram_byteenable             := "0011";
                    v_ram_writedata              := (others => '0');
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata(15 downto 0) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#8B#) =>
                    -- RMAP Area HK Register 27 : CCD 3 Vrd Monitor F HK Field
                    v_ram_address                 := "110110";
                    v_ram_byteenable              := "1100";
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask               := (others => '1');
                    v_ram_writedata(31 downto 16) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#8C#) =>
                    -- RMAP Area HK Register 27 : CCD 3 Vdd Monitor HK Field
                    v_ram_address                := "110110";
                    v_ram_byteenable             := "0011";
                    v_ram_writedata              := (others => '0');
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata(15 downto 0) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#8D#) =>
                    -- RMAP Area HK Register 28 : CCD 3 Vgd Monitor HK Field
                    v_ram_address                 := "110111";
                    v_ram_byteenable              := "1100";
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask               := (others => '1');
                    v_ram_writedata(31 downto 16) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#8E#) =>
                    -- RMAP Area HK Register 28 : CCD 4 Vrd Monitor F HK Field
                    v_ram_address                := "110111";
                    v_ram_byteenable             := "0011";
                    v_ram_writedata              := (others => '0');
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata(15 downto 0) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#8F#) =>
                    -- RMAP Area HK Register 29 : CCD 4 Vdd Monitor HK Field
                    v_ram_address                 := "111000";
                    v_ram_byteenable              := "1100";
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask               := (others => '1');
                    v_ram_writedata(31 downto 16) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#90#) =>
                    -- RMAP Area HK Register 29 : CCD 4 Vgd Monitor HK Field
                    v_ram_address                := "111000";
                    v_ram_byteenable             := "0011";
                    v_ram_writedata              := (others => '0');
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata(15 downto 0) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#91#) =>
                    -- RMAP Area HK Register 30 : Ig High Monitor HK Field
                    v_ram_address                 := "111001";
                    v_ram_byteenable              := "1100";
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask               := (others => '1');
                    v_ram_writedata(31 downto 16) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#92#) =>
                    -- RMAP Area HK Register 30 : Ig Low Monitor HK Field
                    v_ram_address                := "111001";
                    v_ram_byteenable             := "0011";
                    v_ram_writedata              := (others => '0');
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata(15 downto 0) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#93#) =>
                    -- RMAP Area HK Register 31 : Tsense A HK Field
                    v_ram_address                 := "111010";
                    v_ram_byteenable              := "1100";
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask               := (others => '1');
                    v_ram_writedata(31 downto 16) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#94#) =>
                    -- RMAP Area HK Register 31 : Tsense B HK Field
                    v_ram_address                := "111010";
                    v_ram_byteenable             := "0011";
                    v_ram_writedata              := (others => '0');
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata(15 downto 0) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#97#) =>
                    -- RMAP Area HK Register 32 : SpW Status : SpaceWire Status Reserved
                    v_ram_address               := "111011";
                    v_ram_byteenable            := "0001";
                    v_ram_wrbitmask             := (others => '0');
                    v_ram_writedata             := (others => '0');
                    v_ram_wrbitmask(7 downto 6) := (others => '1');
                    v_ram_writedata(7 downto 6) := avalon_mm_rmap_i.writedata(1 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#9E#) =>
                    -- RMAP Area HK Register 32 : Register 32 HK Reserved
                    v_ram_address                 := "111011";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask               := (others => '1');
                    v_ram_writedata(31 downto 24) := avalon_mm_rmap_i.writedata(7 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#A0#) =>
                    -- RMAP Area HK Register 33 : Register 33 HK Reserved
                    v_ram_address                := "111100";
                    v_ram_byteenable             := "0011";
                    v_ram_wrbitmask              := (others => '0');
                    v_ram_writedata              := (others => '0');
                    v_ram_wrbitmask(15 downto 6) := (others => '1');
                    v_ram_writedata(15 downto 6) := avalon_mm_rmap_i.writedata(9 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#A1#) =>
                    -- RMAP Area HK Register 33 : Operational Mode HK Field
                    v_ram_address               := "111100";
                    v_ram_byteenable            := "0001";
                    v_ram_wrbitmask             := (others => '0');
                    v_ram_writedata             := (others => '0');
                    v_ram_wrbitmask(5 downto 2) := (others => '1');
                    v_ram_writedata(5 downto 2) := avalon_mm_rmap_i.writedata(3 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#AB#) =>
                    -- RMAP Area HK Register 34 : Error Flags : Error Flags Reserved
                    v_ram_address                := "111101";
                    v_ram_byteenable             := "1110";
                    v_ram_writedata              := (others => '0');
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata(31 downto 8) := avalon_mm_rmap_i.writedata(23 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#AC#) =>
                    -- RMAP Area HK Register 35 : FPGA Minor Version Field
                    v_ram_address               := "111110";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_wrbitmask             := (others => '1');
                    v_ram_writedata(7 downto 0) := avalon_mm_rmap_i.writedata(7 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#AD#) =>
                    -- RMAP Area HK Register 35 : FPGA Major Version Field
                    v_ram_address                := "111110";
                    v_ram_byteenable             := "0010";
                    v_ram_wrbitmask              := (others => '0');
                    v_ram_writedata              := (others => '0');
                    v_ram_wrbitmask(11 downto 8) := (others => '1');
                    v_ram_writedata(11 downto 8) := avalon_mm_rmap_i.writedata(3 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#AE#) =>
                    -- RMAP Area HK Register 35 : Board ID Field
                    v_ram_address                 := "111110";
                    v_ram_byteenable              := "0110";
                    v_ram_wrbitmask               := (others => '0');
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask(20 downto 12) := (others => '1');
                    v_ram_writedata(20 downto 12) := avalon_mm_rmap_i.writedata(8 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#AF#) =>
                    -- RMAP Area HK Register 35 : Register 35 HK Reserved HK Field
                    v_ram_address                 := "111110";
                    v_ram_byteenable              := "1100";
                    v_ram_wrbitmask               := (others => '0');
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask(31 downto 21) := (others => '1');
                    v_ram_writedata(31 downto 21) := avalon_mm_rmap_i.writedata(10 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when others =>
                    -- No register associated to the address, do nothing
                    avalon_mm_rmap_o.waitrequest <= '0';

            end case;

        end procedure p_avs_writedata;
        --
        variable v_fee_write_address : std_logic_vector(31 downto 0)      := (others => '0');
        variable v_avs_write_address : t_nrme_avalon_mm_rmap_nfee_address := 0;
    begin
        if (rst_i = '1') then
            fee_rmap_o.waitrequest       <= '1';
            avalon_mm_rmap_o.waitrequest <= '1';
            memarea_wraddress_o          <= (others => '0');
            memarea_wrbyteenable_o       <= (others => '1');
            memarea_wrbitmask_o          <= (others => '1');
            memarea_wrdata_o             <= (others => '0');
            memarea_write_o              <= '0';
            s_write_started              <= '0';
            s_write_in_progress          <= '0';
            s_write_finished             <= '0';
            s_data_registered            <= '0';
            p_nfee_reg_reset;
            v_fee_write_address          := (others => '0');
            v_avs_write_address          := 0;
        elsif (rising_edge(clk_i)) then

            fee_rmap_o.waitrequest       <= '1';
            avalon_mm_rmap_o.waitrequest <= '1';
            p_nfee_reg_trigger;
            s_write_started              <= '0';
            s_write_in_progress          <= '0';
            s_write_finished             <= '0';
            s_data_registered            <= '0';
            if (fee_rmap_i.write = '1') then
                v_fee_write_address := fee_rmap_i.address;
                --                fee_rmap_o.waitrequest <= '0';
                p_nfee_mem_wr(v_fee_write_address);
            elsif (avalon_mm_rmap_i.write = '1') then
                v_avs_write_address := to_integer(unsigned(avalon_mm_rmap_i.address));
                --                avalon_mm_rmap_o.waitrequest <= '0';
                p_avs_writedata(v_avs_write_address);
            end if;

        end if;
    end process p_nrme_rmap_mem_area_nfee_write;

end architecture RTL;
