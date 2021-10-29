library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.scom_avs_config_pkg.all;
use work.scom_avs_config_registers_pkg.all;

entity scom_config_avalon_mm_stimulli is
    port(
        clk_i                       : in  std_logic;
        rst_i                       : in  std_logic;
        avs_config_rd_regs_i        : in  t_scom_config_rd_regs;
        avs_config_wr_regs_o        : out t_scom_config_wr_regs;
        avs_config_rd_readdata_o    : out std_logic_vector(31 downto 0);
        avs_config_rd_waitrequest_o : out std_logic;
        avs_config_wr_waitrequest_o : out std_logic
    );
end entity scom_config_avalon_mm_stimulli;

architecture RTL of scom_config_avalon_mm_stimulli is

    signal s_counter : natural := 0;

begin

    p_scom_config_avalon_mm_stimulli : process(clk_i, rst_i) is
        procedure p_reset_registers is
        begin

            -- Write Registers Reset/Default State

            -- Scom Device Address Register : Scom Device Base Address
            avs_config_wr_regs_o.scom_dev_addr_reg.scom_dev_base_addr           <= (others => '0');
            -- SpaceWire Device Address Register : SpaceWire Device Base Address
            avs_config_wr_regs_o.spw_dev_addr_reg.spw_dev_base_addr             <= (others => '0');
            -- SpaceWire Link Config Register : SpaceWire Link Config Enable
            avs_config_wr_regs_o.spw_link_config_reg.spw_lnkcfg_enable          <= '0';
            -- SpaceWire Link Config Register : SpaceWire Link Config Disconnect
            avs_config_wr_regs_o.spw_link_config_reg.spw_lnkcfg_disconnect      <= '0';
            -- SpaceWire Link Config Register : SpaceWire Link Config Linkstart
            avs_config_wr_regs_o.spw_link_config_reg.spw_lnkcfg_linkstart       <= '0';
            -- SpaceWire Link Config Register : SpaceWire Link Config Autostart
            avs_config_wr_regs_o.spw_link_config_reg.spw_lnkcfg_autostart       <= '0';
            -- SpaceWire Link Config Register : SpaceWire Link Config TxDivCnt
            avs_config_wr_regs_o.spw_link_config_reg.spw_lnkcfg_txdivcnt        <= x"01";
            -- SpaceWire Timecode Config Register : SpaceWire Timecode Clear
            avs_config_wr_regs_o.spw_timecode_config_reg.timecode_clear         <= '0';
            -- SpaceWire Timecode Config Register : SpaceWire Timecode Enable
            avs_config_wr_regs_o.spw_timecode_config_reg.timecode_en            <= '1';
            -- RMAP Device Address Register : RMAP Device Base Address
            avs_config_wr_regs_o.rmap_dev_addr_reg.rmap_dev_base_addr           <= (others => '0');
            -- RMAP Codec Config Register : RMAP Target Logical Address
            avs_config_wr_regs_o.rmap_codec_config_reg.rmap_target_logical_addr <= x"51";
            -- RMAP Codec Config Register : RMAP Target Key
            avs_config_wr_regs_o.rmap_codec_config_reg.rmap_target_key          <= x"D1";
            --			-- RMAP Memory Config Register : RMAP Windowing Area Offset (High Dword)
            --			avs_config_wr_regs_o.rmap_memory_config_reg.rmap_win_area_offset_high_dword <= (others => '0');
            --			-- RMAP Memory Config Register : RMAP Windowing Area Offset (Low Dword)
            --			avs_config_wr_regs_o.rmap_memory_config_reg.rmap_win_area_offset_low_dword  <= (others => '0');
            -- RMAP Memory Area Pointer Register : RMAP Memory Area Pointer
            avs_config_wr_regs_o.rmap_mem_area_ptr_reg.rmap_mem_area_ptr        <= (others => '0');
            -- FEE Machine Config Register : FEE Machine Clear
            avs_config_wr_regs_o.fee_machine_config_reg.fee_machine_clear       <= '0';
            -- FEE Machine Config Register : FEE Machine Stop
            avs_config_wr_regs_o.fee_machine_config_reg.fee_machine_stop        <= '0';
            -- FEE Machine Config Register : FEE Machine Start
            avs_config_wr_regs_o.fee_machine_config_reg.fee_machine_start       <= '0';
            -- Data Packet Config Register : Data Packet Packet Length
            avs_config_wr_regs_o.data_packet_config_reg.data_pkt_packet_length  <= std_logic_vector(to_unsigned(32768, 16));
            -- Data Packet Config Register : Data Packet FEE Mode
            avs_config_wr_regs_o.data_packet_config_reg.data_pkt_fee_mode       <= std_logic_vector(to_unsigned(0, 5));
            -- Data Packet Config Register : Data Packet CCD Number
            avs_config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_number     <= std_logic_vector(to_unsigned(0, 2));
            -- Data Packet Config Register : Data Packet Protocol ID
            avs_config_wr_regs_o.data_packet_config_reg.data_pkt_protocol_id    <= x"F0";
            -- Data Packet Config Register : Data Packet Logical Address
            avs_config_wr_regs_o.data_packet_config_reg.data_pkt_logical_addr   <= x"50";

        end procedure p_reset_registers;

        procedure p_control_triggers is
        begin

            -- Write Registers Triggers Reset

            -- SpaceWire Timecode Config Register : SpaceWire Timecode Clear
            avs_config_wr_regs_o.spw_timecode_config_reg.timecode_clear   <= '0';
            -- FEE Machine Config Register : FEE Machine Clear
            avs_config_wr_regs_o.fee_machine_config_reg.fee_machine_clear <= '0';
            -- FEE Machine Config Register : FEE Machine Stop
            avs_config_wr_regs_o.fee_machine_config_reg.fee_machine_stop  <= '0';
            -- FEE Machine Config Register : FEE Machine Start
            avs_config_wr_regs_o.fee_machine_config_reg.fee_machine_start <= '0';

        end procedure p_control_triggers;

    begin
        if (rst_i = '1') then

            s_counter                   <= 0;
            p_reset_registers;
            avs_config_rd_readdata_o    <= (others => '0');
            avs_config_rd_waitrequest_o <= '1';
            avs_config_wr_waitrequest_o <= '1';

        elsif rising_edge(clk_i) then

            s_counter                   <= s_counter + 1;
            p_control_triggers;
            avs_config_rd_readdata_o    <= (others => '0');
            avs_config_rd_waitrequest_o <= '1';
            avs_config_wr_waitrequest_o <= '1';

            case s_counter is

                when 5 =>
                    -- stop the comm module
                    avs_config_wr_regs_o.fee_machine_config_reg.fee_machine_stop <= '1';

                when 10 =>
                    -- clear the comm module
                    avs_config_wr_regs_o.fee_machine_config_reg.fee_machine_clear <= '1';

                when 15 =>
                    -- start the comm module
                    avs_config_wr_regs_o.fee_machine_config_reg.fee_machine_start <= '1';

                when 20 =>
                    -- configure simulation parameters
                    -- data packet parameters
                    avs_config_wr_regs_o.data_packet_config_reg.data_pkt_packet_length <= std_logic_vector(to_unsigned(1024, 16));
                    avs_config_wr_regs_o.data_packet_config_reg.data_pkt_logical_addr  <= x"25";
                    avs_config_wr_regs_o.data_packet_config_reg.data_pkt_protocol_id   <= x"02";
                    avs_config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_number    <= std_logic_vector(to_unsigned(3, 2));
                    avs_config_wr_regs_o.data_packet_config_reg.data_pkt_fee_mode      <= "00001"; -- N-FEE On Mode

                when others =>
                    null;

            end case;

        end if;
    end process p_scom_config_avalon_mm_stimulli;

    avs_config_rd_readdata_o    <= (others => '0');
    avs_config_rd_waitrequest_o <= '1';
    avs_config_wr_waitrequest_o <= '1';

end architecture RTL;
