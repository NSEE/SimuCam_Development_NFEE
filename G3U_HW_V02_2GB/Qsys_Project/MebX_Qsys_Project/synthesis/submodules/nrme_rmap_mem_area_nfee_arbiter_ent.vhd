library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.nrme_rmap_mem_area_nfee_pkg.all;
use work.nrme_avalon_mm_rmap_nfee_pkg.all;

entity nrme_rmap_mem_area_nfee_arbiter_ent is
    generic(
        g_ARB_TIMEOUT_CYCLES       : positive := 1024;
        g_ARB_RD_SWITCH_GAP_CYCLES : positive := 2;
        g_ARB_WR_SWITCH_GAP_CYCLES : positive := 1;
        g_ARB_QUEUE_DEPTH          : positive := 7
    );
    port(
        clk_i                 : in  std_logic;
        rst_i                 : in  std_logic;
        fee_0_wr_rmap_i       : in  t_nrme_nfee_rmap_write_in;
        fee_0_rd_rmap_i       : in  t_nrme_nfee_rmap_read_in;
        fee_1_wr_rmap_i       : in  t_nrme_nfee_rmap_write_in;
        fee_1_rd_rmap_i       : in  t_nrme_nfee_rmap_read_in;
        avalon_0_mm_wr_rmap_i : in  t_nrme_avalon_mm_rmap_nfee_write_in;
        avalon_0_mm_rd_rmap_i : in  t_nrme_avalon_mm_rmap_nfee_read_in;
        fee_wr_rmap_cfg_hk_i  : in  t_nrme_nfee_rmap_write_out;
        fee_rd_rmap_cfg_hk_i  : in  t_nrme_nfee_rmap_read_out;
        fee_wr_rmap_win_i     : in  t_nrme_nfee_rmap_write_out;
        fee_rd_rmap_win_i     : in  t_nrme_nfee_rmap_read_out;
        avalon_mm_wr_rmap_i   : in  t_nrme_avalon_mm_rmap_nfee_write_out;
        avalon_mm_rd_rmap_i   : in  t_nrme_avalon_mm_rmap_nfee_read_out;
        fee_0_wr_rmap_o       : out t_nrme_nfee_rmap_write_out;
        fee_0_rd_rmap_o       : out t_nrme_nfee_rmap_read_out;
        fee_1_wr_rmap_o       : out t_nrme_nfee_rmap_write_out;
        fee_1_rd_rmap_o       : out t_nrme_nfee_rmap_read_out;
        avalon_0_mm_wr_rmap_o : out t_nrme_avalon_mm_rmap_nfee_write_out;
        avalon_0_mm_rd_rmap_o : out t_nrme_avalon_mm_rmap_nfee_read_out;
        fee_wr_rmap_cfg_hk_o  : out t_nrme_nfee_rmap_write_in;
        fee_rd_rmap_cfg_hk_o  : out t_nrme_nfee_rmap_read_in;
        fee_wr_rmap_win_o     : out t_nrme_nfee_rmap_write_in;
        fee_rd_rmap_win_o     : out t_nrme_nfee_rmap_read_in;
        avalon_mm_wr_rmap_o   : out t_nrme_avalon_mm_rmap_nfee_write_in;
        avalon_mm_rd_rmap_o   : out t_nrme_avalon_mm_rmap_nfee_read_in
    );
end entity nrme_rmap_mem_area_nfee_arbiter_ent;

architecture RTL of nrme_rmap_mem_area_nfee_arbiter_ent is

    type t_master_list is (
        master_none,
        master_wr_fee_0,
        master_wr_fee_1,
        master_wr_avs_0,
        master_rd_fee_0,
        master_rd_fee_1,
        master_rd_avs_0
    );

    subtype t_source_index is natural range 0 to 5;
    constant c_NUM_SOURCES : natural := t_source_index'high + 1;

    subtype t_queue_index is natural range 0 to (g_ARB_QUEUE_DEPTH - 1);
    type t_master_queue is array (t_queue_index) of t_master_list;
    type t_source_flags is array (t_source_index) of std_logic;

    function f_source_to_master(source_i : t_source_index) return t_master_list is
    begin
        case (source_i) is
            when 0      => return master_wr_fee_0;
            when 1      => return master_wr_fee_1;
            when 2      => return master_wr_avs_0;
            when 3      => return master_rd_fee_0;
            when 4      => return master_rd_fee_1;
            when others => return master_rd_avs_0;
        end case;
    end function f_source_to_master;

    function f_master_to_source(master_i : t_master_list) return integer is
    begin
        case (master_i) is
            when master_wr_fee_0 => return 0;
            when master_wr_fee_1 => return 1;
            when master_wr_avs_0 => return 2;
            when master_rd_fee_0 => return 3;
            when master_rd_fee_1 => return 4;
            when master_rd_avs_0 => return 5;
            when others          => return -1;
        end case;
    end function f_master_to_source;

    function f_is_win_address(addr_i : std_logic_vector(31 downto 0)) return std_logic is
    begin
        if ((addr_i(c_NRME_NFEE_RMAP_WIN_OFFSET_BIT) = '1') and (addr_i(31 downto (c_NRME_NFEE_RMAP_WIN_OFFSET_BIT + 1)) = x"00")) then
            return '1';
        else
            return '0';
        end if;
    end function f_is_win_address;

    function f_max_positive(a_i : positive; b_i : positive) return positive is
    begin
        if (a_i >= b_i) then
            return a_i;
        else
            return b_i;
        end if;
    end function f_max_positive;

    function f_master_switch_gap(master_i : t_master_list) return positive is
    begin
        case (master_i) is
            when master_wr_fee_0 | master_wr_fee_1 | master_wr_avs_0 =>
                return g_ARB_WR_SWITCH_GAP_CYCLES;
            when master_rd_fee_0 | master_rd_fee_1 | master_rd_avs_0 =>
                return g_ARB_RD_SWITCH_GAP_CYCLES;
            when others =>
                return g_ARB_WR_SWITCH_GAP_CYCLES;
        end case;
    end function f_master_switch_gap;

    constant c_ARB_MAX_SWITCH_GAP_CYCLES : positive := f_max_positive(g_ARB_RD_SWITCH_GAP_CYCLES, g_ARB_WR_SWITCH_GAP_CYCLES);

    signal s_selected_master : t_master_list;
    signal s_master_queue    : t_master_queue;
    signal s_queue_count     : natural range 0 to g_ARB_QUEUE_DEPTH;

    signal s_source_queued       : t_source_flags;
    signal s_source_wait_release : t_source_flags;
    signal s_rr_admit_start      : t_source_index;

    signal s_switch_gap_cnt     : natural range 0 to c_ARB_MAX_SWITCH_GAP_CYCLES;
    signal s_active_timeout_cnt : natural range 0 to g_ARB_TIMEOUT_CYCLES;

    signal s_queue_overflow_fault : std_logic;
    signal s_timeout_fault        : std_logic;

    signal s_fee_0_wr_rmap_latched : t_nrme_nfee_rmap_write_in;
    signal s_fee_1_wr_rmap_latched : t_nrme_nfee_rmap_write_in;
    signal s_fee_0_rd_rmap_latched : t_nrme_nfee_rmap_read_in;
    signal s_fee_1_rd_rmap_latched : t_nrme_nfee_rmap_read_in;
    signal s_avs_0_wr_rmap_latched : t_nrme_avalon_mm_rmap_nfee_write_in;
    signal s_avs_0_rd_rmap_latched : t_nrme_avalon_mm_rmap_nfee_read_in;

    signal s_fee_0_wr_win_address_flag_latched : std_logic;
    signal s_fee_1_wr_win_address_flag_latched : std_logic;
    signal s_fee_0_rd_win_address_flag_latched : std_logic;
    signal s_fee_1_rd_win_address_flag_latched : std_logic;

begin

    s_selected_master <= s_master_queue(0) when ((s_queue_count > 0) and (s_switch_gap_cnt = 0)) else master_none;

    p_nrme_rmap_mem_area_nfee_arbiter : process(clk_i, rst_i) is
        variable v_master_queue         : t_master_queue;
        variable v_queue_count          : natural range 0 to g_ARB_QUEUE_DEPTH;
        variable v_source_queued        : t_source_flags;
        variable v_source_wait_release  : t_source_flags;
        variable v_req                  : t_source_flags;
        variable v_req_source           : t_source_index;
        variable v_head_master          : t_master_list;
        variable v_head_source          : integer range -1 to t_source_index'high;
        variable v_complete             : std_logic;
        variable v_popped_head          : std_logic;
        variable v_rr_admit_start       : t_source_index;
        variable v_switch_gap_cnt       : natural range 0 to c_ARB_MAX_SWITCH_GAP_CYCLES;
        variable v_active_timeout_cnt   : natural range 0 to g_ARB_TIMEOUT_CYCLES;
        variable v_queue_overflow_fault : std_logic;
        variable v_timeout_fault        : std_logic;
    begin
        if (rst_i = '1') then
            s_master_queue                 <= (others => master_none);
            s_queue_count                  <= 0;
            s_source_queued                <= (others => '0');
            s_source_wait_release          <= (others => '0');
            s_rr_admit_start               <= 0;
            s_switch_gap_cnt               <= 0;
            s_active_timeout_cnt           <= 0;
            s_queue_overflow_fault         <= '0';
            s_timeout_fault                <= '0';
            s_fee_0_wr_rmap_latched        <= c_NRME_NFEE_RMAP_WRITE_IN_RST;
            s_fee_1_wr_rmap_latched        <= c_NRME_NFEE_RMAP_WRITE_IN_RST;
            s_fee_0_rd_rmap_latched        <= c_NRME_NFEE_RMAP_READ_IN_RST;
            s_fee_1_rd_rmap_latched        <= c_NRME_NFEE_RMAP_READ_IN_RST;
            s_avs_0_wr_rmap_latched        <= c_NRME_AVALON_MM_RMAP_NFEE_WRITE_IN_RST;
            s_avs_0_rd_rmap_latched        <= c_NRME_AVALON_MM_RMAP_NFEE_READ_IN_RST;
            s_fee_0_wr_win_address_flag_latched <= '0';
            s_fee_1_wr_win_address_flag_latched <= '0';
            s_fee_0_rd_win_address_flag_latched <= '0';
            s_fee_1_rd_win_address_flag_latched <= '0';
        elsif rising_edge(clk_i) then
            v_master_queue         := s_master_queue;
            v_queue_count          := s_queue_count;
            v_source_queued        := s_source_queued;
            v_source_wait_release  := s_source_wait_release;
            v_rr_admit_start       := s_rr_admit_start;
            v_switch_gap_cnt       := s_switch_gap_cnt;
            v_active_timeout_cnt   := s_active_timeout_cnt;
            v_queue_overflow_fault := s_queue_overflow_fault;
            v_timeout_fault        := s_timeout_fault;

            v_head_master := master_none;
            v_head_source := -1;
            v_complete    := '0';
            v_popped_head := '0';

            if ((v_queue_count > 0) and (v_switch_gap_cnt = 0)) then
                v_head_master := v_master_queue(0);
                v_head_source := f_master_to_source(v_head_master);
                case (v_head_master) is
                    when master_wr_fee_0 =>
                        if (s_fee_0_wr_win_address_flag_latched = '1') then
                            v_complete := not fee_wr_rmap_win_i.waitrequest;
                        else
                            v_complete := not fee_wr_rmap_cfg_hk_i.waitrequest;
                        end if;
                    when master_wr_fee_1 =>
                        if (s_fee_1_wr_win_address_flag_latched = '1') then
                            v_complete := not fee_wr_rmap_win_i.waitrequest;
                        else
                            v_complete := not fee_wr_rmap_cfg_hk_i.waitrequest;
                        end if;
                    when master_wr_avs_0 =>
                        v_complete := not avalon_mm_wr_rmap_i.waitrequest;
                    when master_rd_fee_0 =>
                        if (s_fee_0_rd_win_address_flag_latched = '1') then
                            v_complete := not fee_rd_rmap_win_i.waitrequest;
                        else
                            v_complete := not fee_rd_rmap_cfg_hk_i.waitrequest;
                        end if;
                    when master_rd_fee_1 =>
                        if (s_fee_1_rd_win_address_flag_latched = '1') then
                            v_complete := not fee_rd_rmap_win_i.waitrequest;
                        else
                            v_complete := not fee_rd_rmap_cfg_hk_i.waitrequest;
                        end if;
                    when master_rd_avs_0 =>
                        v_complete := not avalon_mm_rd_rmap_i.waitrequest;
                    when others =>
                        v_complete := '0';
                end case;
            end if;

            if (v_head_master /= master_none) then
                if (v_complete = '1') or (v_active_timeout_cnt >= (g_ARB_TIMEOUT_CYCLES - 1)) then
                    if (v_complete = '0') then
                        v_timeout_fault := '1';
                    end if;
                    if (v_head_source >= 0) then
                        v_source_queued(v_head_source)       := '0';
                        v_source_wait_release(v_head_source) := '1';
                    end if;
                    if (g_ARB_QUEUE_DEPTH > 1) then
                        for index in 0 to (g_ARB_QUEUE_DEPTH - 2) loop
                            v_master_queue(index) := v_master_queue(index + 1);
                        end loop;
                    end if;
                    v_master_queue(g_ARB_QUEUE_DEPTH - 1) := master_none;
                    if (v_queue_count > 0) then
                        v_queue_count := v_queue_count - 1;
                    end if;
                    v_active_timeout_cnt := 0;
                    v_switch_gap_cnt     := f_master_switch_gap(v_head_master);
                    v_popped_head        := '1';
                    if (v_head_source >= 0) then
                        v_rr_admit_start := t_source_index((v_head_source + 1) mod c_NUM_SOURCES);
                    end if;
                else
                    v_active_timeout_cnt := v_active_timeout_cnt + 1;
                end if;
            else
                v_active_timeout_cnt := 0;
                if (v_switch_gap_cnt > 0) then
                    v_switch_gap_cnt := v_switch_gap_cnt - 1;
                end if;
            end if;

            v_req(0) := fee_0_wr_rmap_i.write and (not fee_0_rd_rmap_i.read);
            v_req(1) := fee_1_wr_rmap_i.write and (not fee_1_rd_rmap_i.read);
            v_req(2) := avalon_0_mm_wr_rmap_i.write and (not avalon_0_mm_rd_rmap_i.read);
            v_req(3) := fee_0_rd_rmap_i.read and (not fee_0_wr_rmap_i.write);
            v_req(4) := fee_1_rd_rmap_i.read and (not fee_1_wr_rmap_i.write);
            v_req(5) := avalon_0_mm_rd_rmap_i.read and (not avalon_0_mm_wr_rmap_i.write);

            for source in 0 to (c_NUM_SOURCES - 1) loop
                if (v_req(source) = '0') then
                    v_source_wait_release(source) := '0';
                end if;
            end loop;

            if (((fee_0_wr_rmap_i.write = '1') and (fee_0_rd_rmap_i.read = '1')) or
                ((fee_1_wr_rmap_i.write = '1') and (fee_1_rd_rmap_i.read = '1')) or
                ((avalon_0_mm_wr_rmap_i.write = '1') and (avalon_0_mm_rd_rmap_i.read = '1'))) then
                v_queue_overflow_fault := '1';
            end if;

            for offset in 0 to (c_NUM_SOURCES - 1) loop
                v_req_source := t_source_index((v_rr_admit_start + offset) mod c_NUM_SOURCES);
                if (v_req(v_req_source) = '1') then
                    if ((v_source_queued(v_req_source) = '0') and (v_source_wait_release(v_req_source) = '0')) then
                        if (v_queue_count < g_ARB_QUEUE_DEPTH) then
                            v_master_queue(v_queue_count) := f_source_to_master(v_req_source);
                            v_queue_count                 := v_queue_count + 1;
                            v_source_queued(v_req_source) := '1';
                            case (v_req_source) is
                                when 0 =>
                                    s_fee_0_wr_rmap_latched             <= fee_0_wr_rmap_i;
                                    s_fee_0_wr_win_address_flag_latched <= f_is_win_address(fee_0_wr_rmap_i.address);
                                when 1 =>
                                    s_fee_1_wr_rmap_latched             <= fee_1_wr_rmap_i;
                                    s_fee_1_wr_win_address_flag_latched <= f_is_win_address(fee_1_wr_rmap_i.address);
                                when 2 =>
                                    s_avs_0_wr_rmap_latched <= avalon_0_mm_wr_rmap_i;
                                when 3 =>
                                    s_fee_0_rd_rmap_latched             <= fee_0_rd_rmap_i;
                                    s_fee_0_rd_win_address_flag_latched <= f_is_win_address(fee_0_rd_rmap_i.address);
                                when 4 =>
                                    s_fee_1_rd_rmap_latched             <= fee_1_rd_rmap_i;
                                    s_fee_1_rd_win_address_flag_latched <= f_is_win_address(fee_1_rd_rmap_i.address);
                                when others =>
                                    s_avs_0_rd_rmap_latched <= avalon_0_mm_rd_rmap_i;
                            end case;
                        else
                            v_queue_overflow_fault := '1';
                        end if;
                    end if;
                end if;
            end loop;

            if (v_popped_head = '0') then
                v_rr_admit_start := t_source_index((v_rr_admit_start + 1) mod c_NUM_SOURCES);
            end if;

            s_master_queue         <= v_master_queue;
            s_queue_count          <= v_queue_count;
            s_source_queued        <= v_source_queued;
            s_source_wait_release  <= v_source_wait_release;
            s_rr_admit_start       <= v_rr_admit_start;
            s_switch_gap_cnt       <= v_switch_gap_cnt;
            s_active_timeout_cnt   <= v_active_timeout_cnt;
            s_queue_overflow_fault <= v_queue_overflow_fault;
            s_timeout_fault        <= v_timeout_fault;
        end if;
    end process p_nrme_rmap_mem_area_nfee_arbiter;

    fee_wr_rmap_cfg_hk_o <= c_NRME_NFEE_RMAP_WRITE_IN_RST when (rst_i = '1')
                            else s_fee_0_wr_rmap_latched when ((s_selected_master = master_wr_fee_0) and (s_fee_0_wr_win_address_flag_latched = '0'))
                            else s_fee_1_wr_rmap_latched when ((s_selected_master = master_wr_fee_1) and (s_fee_1_wr_win_address_flag_latched = '0'))
                            else c_NRME_NFEE_RMAP_WRITE_IN_RST;

    fee_wr_rmap_win_o <= c_NRME_NFEE_RMAP_WRITE_IN_RST when (rst_i = '1')
                         else s_fee_0_wr_rmap_latched when ((s_selected_master = master_wr_fee_0) and (s_fee_0_wr_win_address_flag_latched = '1'))
                         else s_fee_1_wr_rmap_latched when ((s_selected_master = master_wr_fee_1) and (s_fee_1_wr_win_address_flag_latched = '1'))
                         else c_NRME_NFEE_RMAP_WRITE_IN_RST;

    avalon_mm_wr_rmap_o <= c_NRME_AVALON_MM_RMAP_NFEE_WRITE_IN_RST when (rst_i = '1')
                           else s_avs_0_wr_rmap_latched when (s_selected_master = master_wr_avs_0)
                           else c_NRME_AVALON_MM_RMAP_NFEE_WRITE_IN_RST;

    fee_0_wr_rmap_o <= c_NRME_NFEE_RMAP_WRITE_OUT_RST when (rst_i = '1')
                       else fee_wr_rmap_cfg_hk_i when ((s_selected_master = master_wr_fee_0) and (s_fee_0_wr_win_address_flag_latched = '0'))
                       else fee_wr_rmap_win_i when ((s_selected_master = master_wr_fee_0) and (s_fee_0_wr_win_address_flag_latched = '1'))
                       else c_NRME_NFEE_RMAP_WRITE_OUT_RST;

    fee_1_wr_rmap_o <= c_NRME_NFEE_RMAP_WRITE_OUT_RST when (rst_i = '1')
                       else fee_wr_rmap_cfg_hk_i when ((s_selected_master = master_wr_fee_1) and (s_fee_1_wr_win_address_flag_latched = '0'))
                       else fee_wr_rmap_win_i when ((s_selected_master = master_wr_fee_1) and (s_fee_1_wr_win_address_flag_latched = '1'))
                       else c_NRME_NFEE_RMAP_WRITE_OUT_RST;

    avalon_0_mm_wr_rmap_o <= c_NRME_AVALON_MM_RMAP_NFEE_WRITE_OUT_RST when (rst_i = '1')
                             else avalon_mm_wr_rmap_i when (s_selected_master = master_wr_avs_0)
                             else c_NRME_AVALON_MM_RMAP_NFEE_WRITE_OUT_RST;

    fee_rd_rmap_cfg_hk_o <= c_NRME_NFEE_RMAP_READ_IN_RST when (rst_i = '1')
                            else s_fee_0_rd_rmap_latched when ((s_selected_master = master_rd_fee_0) and (s_fee_0_rd_win_address_flag_latched = '0'))
                            else s_fee_1_rd_rmap_latched when ((s_selected_master = master_rd_fee_1) and (s_fee_1_rd_win_address_flag_latched = '0'))
                            else c_NRME_NFEE_RMAP_READ_IN_RST;

    fee_rd_rmap_win_o <= c_NRME_NFEE_RMAP_READ_IN_RST when (rst_i = '1')
                         else s_fee_0_rd_rmap_latched when ((s_selected_master = master_rd_fee_0) and (s_fee_0_rd_win_address_flag_latched = '1'))
                         else s_fee_1_rd_rmap_latched when ((s_selected_master = master_rd_fee_1) and (s_fee_1_rd_win_address_flag_latched = '1'))
                         else c_NRME_NFEE_RMAP_READ_IN_RST;

    avalon_mm_rd_rmap_o <= c_NRME_AVALON_MM_RMAP_NFEE_READ_IN_RST when (rst_i = '1')
                           else s_avs_0_rd_rmap_latched when (s_selected_master = master_rd_avs_0)
                           else c_NRME_AVALON_MM_RMAP_NFEE_READ_IN_RST;

    fee_0_rd_rmap_o <= c_NRME_NFEE_RMAP_READ_OUT_RST when (rst_i = '1')
                       else fee_rd_rmap_cfg_hk_i when ((s_selected_master = master_rd_fee_0) and (s_fee_0_rd_win_address_flag_latched = '0'))
                       else fee_rd_rmap_win_i when ((s_selected_master = master_rd_fee_0) and (s_fee_0_rd_win_address_flag_latched = '1'))
                       else c_NRME_NFEE_RMAP_READ_OUT_RST;

    fee_1_rd_rmap_o <= c_NRME_NFEE_RMAP_READ_OUT_RST when (rst_i = '1')
                       else fee_rd_rmap_cfg_hk_i when ((s_selected_master = master_rd_fee_1) and (s_fee_1_rd_win_address_flag_latched = '0'))
                       else fee_rd_rmap_win_i when ((s_selected_master = master_rd_fee_1) and (s_fee_1_rd_win_address_flag_latched = '1'))
                       else c_NRME_NFEE_RMAP_READ_OUT_RST;

    avalon_0_mm_rd_rmap_o <= c_NRME_AVALON_MM_RMAP_NFEE_READ_OUT_RST when (rst_i = '1')
                             else avalon_mm_rd_rmap_i when (s_selected_master = master_rd_avs_0)
                             else c_NRME_AVALON_MM_RMAP_NFEE_READ_OUT_RST;

end architecture RTL;
