library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.scom_avs_config_pkg.all;
use work.scom_avs_config_registers_pkg.all;

entity scom_avs_config_write_ent is
    port(
        clk_i            : in  std_logic;
        rst_i            : in  std_logic;
        avs_config_i     : in  t_scom_avs_config_write_in;
        avs_config_o     : out t_scom_avs_config_write_out;
        config_wr_regs_o : out t_scom_config_wr_regs
    );
end entity scom_avs_config_write_ent;

architecture rtl of scom_avs_config_write_ent is

    signal s_data_acquired : std_logic;

begin

    p_scom_avs_config_write : process(clk_i, rst_i) is
        procedure p_reset_registers is
        begin

            -- Write Registers Reset/Default State

            -- Scom Device Address Register : Scom Device Base Address
            config_wr_regs_o.scom_dev_addr_reg.scom_dev_base_addr           <= (others => '0');
            -- SpaceWire Device Address Register : SpaceWire Device Base Address
            config_wr_regs_o.spw_dev_addr_reg.spw_dev_base_addr             <= (others => '0');
            -- SpaceWire Link Config Register : SpaceWire Link Config Enable
            config_wr_regs_o.spw_link_config_reg.spw_lnkcfg_enable          <= '0';
            -- SpaceWire Link Config Register : SpaceWire Link Config Disconnect
            config_wr_regs_o.spw_link_config_reg.spw_lnkcfg_disconnect      <= '0';
            -- SpaceWire Link Config Register : SpaceWire Link Config Linkstart
            config_wr_regs_o.spw_link_config_reg.spw_lnkcfg_linkstart       <= '0';
            -- SpaceWire Link Config Register : SpaceWire Link Config Autostart
            config_wr_regs_o.spw_link_config_reg.spw_lnkcfg_autostart       <= '0';
            -- SpaceWire Link Config Register : SpaceWire Link Config TxDivCnt
            config_wr_regs_o.spw_link_config_reg.spw_lnkcfg_txdivcnt        <= x"01";
            -- SpaceWire Timecode Config Register : SpaceWire Timecode Clear
            config_wr_regs_o.spw_timecode_config_reg.timecode_clear         <= '0';
            -- SpaceWire Timecode Config Register : SpaceWire Timecode Enable
            config_wr_regs_o.spw_timecode_config_reg.timecode_en            <= '1';
            -- RMAP Device Address Register : RMAP Device Base Address
            config_wr_regs_o.rmap_dev_addr_reg.rmap_dev_base_addr           <= (others => '0');
            -- RMAP Codec Config Register : RMAP Target Logical Address
            config_wr_regs_o.rmap_codec_config_reg.rmap_target_logical_addr <= x"51";
            -- RMAP Codec Config Register : RMAP Target Key
            config_wr_regs_o.rmap_codec_config_reg.rmap_target_key          <= x"D1";
            --          -- RMAP Memory Config Register : RMAP Windowing Area Offset (High Dword)
            --          config_wr_regs_o.rmap_memory_config_reg.rmap_win_area_offset_high_dword <= (others => '0');
            --          -- RMAP Memory Config Register : RMAP Windowing Area Offset (Low Dword)
            --          config_wr_regs_o.rmap_memory_config_reg.rmap_win_area_offset_low_dword  <= (others => '0');
            -- RMAP Memory Area Pointer Register : RMAP Memory Area Pointer
            config_wr_regs_o.rmap_mem_area_ptr_reg.rmap_mem_area_ptr        <= (others => '0');
            -- FEE Machine Config Register : FEE Machine Clear
            config_wr_regs_o.fee_machine_config_reg.fee_machine_clear       <= '0';
            -- FEE Machine Config Register : FEE Machine Stop
            config_wr_regs_o.fee_machine_config_reg.fee_machine_stop        <= '0';
            -- FEE Machine Config Register : FEE Machine Start
            config_wr_regs_o.fee_machine_config_reg.fee_machine_start       <= '0';
            -- Data Packet Config Register : Data Packet Packet Length
            config_wr_regs_o.data_packet_config_reg.data_pkt_packet_length  <= std_logic_vector(to_unsigned(32768, 16));
            -- Data Packet Config Register : Data Packet FEE Mode
            config_wr_regs_o.data_packet_config_reg.data_pkt_fee_mode       <= std_logic_vector(to_unsigned(0, 5));
            -- Data Packet Config Register : Data Packet CCD Number
            config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_number     <= std_logic_vector(to_unsigned(0, 2));
            -- Data Packet Config Register : Data Packet Protocol ID
            config_wr_regs_o.data_packet_config_reg.data_pkt_protocol_id    <= x"F0";
            -- Data Packet Config Register : Data Packet Logical Address
            config_wr_regs_o.data_packet_config_reg.data_pkt_logical_addr   <= x"50";

        end procedure p_reset_registers;

        procedure p_control_triggers is
        begin

            -- Write Registers Triggers Reset

            -- SpaceWire Timecode Config Register : SpaceWire Timecode Clear
            config_wr_regs_o.spw_timecode_config_reg.timecode_clear   <= '0';
            -- FEE Machine Config Register : FEE Machine Clear
            config_wr_regs_o.fee_machine_config_reg.fee_machine_clear <= '0';
            -- FEE Machine Config Register : FEE Machine Stop
            config_wr_regs_o.fee_machine_config_reg.fee_machine_stop  <= '0';
            -- FEE Machine Config Register : FEE Machine Start
            config_wr_regs_o.fee_machine_config_reg.fee_machine_start <= '0';

        end procedure p_control_triggers;

        procedure p_writedata(write_address_i : t_scom_avs_config_address) is
        begin

            -- Registers Write Data
            case (write_address_i) is
                -- Case for access to all registers address

                when (16#00#) =>
                    -- Scom Device Address Register : Scom Device Base Address
                    -- if (avs_config_i.byteenable(0) = '1') then
                    config_wr_regs_o.scom_dev_addr_reg.scom_dev_base_addr(7 downto 0)   <= avs_config_i.writedata(7 downto 0);
                    -- end if;
                    -- if (avs_config_i.byteenable(1) = '1') then
                    config_wr_regs_o.scom_dev_addr_reg.scom_dev_base_addr(15 downto 8)  <= avs_config_i.writedata(15 downto 8);
                    -- end if;
                    -- if (avs_config_i.byteenable(2) = '1') then
                    config_wr_regs_o.scom_dev_addr_reg.scom_dev_base_addr(23 downto 16) <= avs_config_i.writedata(23 downto 16);
                    -- end if;
                    -- if (avs_config_i.byteenable(3) = '1') then
                    config_wr_regs_o.scom_dev_addr_reg.scom_dev_base_addr(31 downto 24) <= avs_config_i.writedata(31 downto 24);
                -- end if;

                when (16#01#) =>
                    -- SpaceWire Device Address Register : SpaceWire Device Base Address
                    -- if (avs_config_i.byteenable(0) = '1') then
                    config_wr_regs_o.spw_dev_addr_reg.spw_dev_base_addr(7 downto 0)   <= avs_config_i.writedata(7 downto 0);
                    -- end if;
                    -- if (avs_config_i.byteenable(1) = '1') then
                    config_wr_regs_o.spw_dev_addr_reg.spw_dev_base_addr(15 downto 8)  <= avs_config_i.writedata(15 downto 8);
                    -- end if;
                    -- if (avs_config_i.byteenable(2) = '1') then
                    config_wr_regs_o.spw_dev_addr_reg.spw_dev_base_addr(23 downto 16) <= avs_config_i.writedata(23 downto 16);
                    -- end if;
                    -- if (avs_config_i.byteenable(3) = '1') then
                    config_wr_regs_o.spw_dev_addr_reg.spw_dev_base_addr(31 downto 24) <= avs_config_i.writedata(31 downto 24);
                -- end if;

                when (16#02#) =>
                    -- SpaceWire Link Config Register : SpaceWire Link Config Enable
                    -- if (avs_config_i.byteenable(0) = '1') then
                    config_wr_regs_o.spw_link_config_reg.spw_lnkcfg_enable <= avs_config_i.writedata(0);
                -- end if;

                when (16#03#) =>
                    -- SpaceWire Link Config Register : SpaceWire Link Config Disconnect
                    -- if (avs_config_i.byteenable(0) = '1') then
                    config_wr_regs_o.spw_link_config_reg.spw_lnkcfg_disconnect <= avs_config_i.writedata(0);
                -- end if;

                when (16#04#) =>
                    -- SpaceWire Link Config Register : SpaceWire Link Config Linkstart
                    -- if (avs_config_i.byteenable(0) = '1') then
                    config_wr_regs_o.spw_link_config_reg.spw_lnkcfg_linkstart <= avs_config_i.writedata(0);
                -- end if;

                when (16#05#) =>
                    -- SpaceWire Link Config Register : SpaceWire Link Config Autostart
                    -- if (avs_config_i.byteenable(0) = '1') then
                    config_wr_regs_o.spw_link_config_reg.spw_lnkcfg_autostart <= avs_config_i.writedata(0);
                -- end if;

                when (16#06#) =>
                    -- SpaceWire Link Config Register : SpaceWire Link Config TxDivCnt
                    -- if (avs_config_i.byteenable(0) = '1') then
                    config_wr_regs_o.spw_link_config_reg.spw_lnkcfg_txdivcnt <= avs_config_i.writedata(7 downto 0);
                -- end if;

                when (16#0E#) =>
                    -- SpaceWire Timecode Config Register : SpaceWire Timecode Clear
                    -- if (avs_config_i.byteenable(0) = '1') then
                    config_wr_regs_o.spw_timecode_config_reg.timecode_clear <= avs_config_i.writedata(0);
                -- end if;

                when (16#0F#) =>
                    -- SpaceWire Timecode Config Register : SpaceWire Timecode Enable
                    -- if (avs_config_i.byteenable(0) = '1') then
                    config_wr_regs_o.spw_timecode_config_reg.timecode_en <= avs_config_i.writedata(0);
                -- end if;

                when (16#12#) =>
                    -- RMAP Device Address Register : RMAP Device Base Address
                    -- if (avs_config_i.byteenable(0) = '1') then
                    config_wr_regs_o.rmap_dev_addr_reg.rmap_dev_base_addr(7 downto 0)   <= avs_config_i.writedata(7 downto 0);
                    -- end if;
                    -- if (avs_config_i.byteenable(1) = '1') then
                    config_wr_regs_o.rmap_dev_addr_reg.rmap_dev_base_addr(15 downto 8)  <= avs_config_i.writedata(15 downto 8);
                    -- end if;
                    -- if (avs_config_i.byteenable(2) = '1') then
                    config_wr_regs_o.rmap_dev_addr_reg.rmap_dev_base_addr(23 downto 16) <= avs_config_i.writedata(23 downto 16);
                    -- end if;
                    -- if (avs_config_i.byteenable(3) = '1') then
                    config_wr_regs_o.rmap_dev_addr_reg.rmap_dev_base_addr(31 downto 24) <= avs_config_i.writedata(31 downto 24);
                -- end if;

                when (16#13#) =>
                    -- RMAP Codec Config Register : RMAP Target Logical Address
                    -- if (avs_config_i.byteenable(0) = '1') then
                    config_wr_regs_o.rmap_codec_config_reg.rmap_target_logical_addr <= avs_config_i.writedata(7 downto 0);
                -- end if;

                when (16#14#) =>
                    -- RMAP Codec Config Register : RMAP Target Key
                    -- if (avs_config_i.byteenable(0) = '1') then
                    config_wr_regs_o.rmap_codec_config_reg.rmap_target_key <= avs_config_i.writedata(7 downto 0);
                -- end if;

                --              when (16#27#) =>
                --                  -- RMAP Memory Config Register : RMAP Windowing Area Offset (High Dword)
                --                  -- if (avs_config_i.byteenable(0) = '1') then
                --                      config_wr_regs_o.rmap_memory_config_reg.rmap_win_area_offset_high_dword(7 downto 0) <= avs_config_i.writedata(7 downto 0);
                --                  -- end if;
                --                  -- if (avs_config_i.byteenable(1) = '1') then
                --                      config_wr_regs_o.rmap_memory_config_reg.rmap_win_area_offset_high_dword(15 downto 8) <= avs_config_i.writedata(15 downto 8);
                --                  -- end if;
                --                  -- if (avs_config_i.byteenable(2) = '1') then
                --                      config_wr_regs_o.rmap_memory_config_reg.rmap_win_area_offset_high_dword(23 downto 16) <= avs_config_i.writedata(23 downto 16);
                --                  -- end if;
                --                  -- if (avs_config_i.byteenable(3) = '1') then
                --                      config_wr_regs_o.rmap_memory_config_reg.rmap_win_area_offset_high_dword(31 downto 24) <= avs_config_i.writedata(31 downto 24);
                --                  -- end if;
                --
                --              when (16#28#) =>
                --                  -- RMAP Memory Config Register : RMAP Windowing Area Offset (Low Dword)
                --                  -- if (avs_config_i.byteenable(0) = '1') then
                --                      config_wr_regs_o.rmap_memory_config_reg.rmap_win_area_offset_low_dword(7 downto 0) <= avs_config_i.writedata(7 downto 0);
                --                  -- end if;
                --                  -- if (avs_config_i.byteenable(1) = '1') then
                --                      config_wr_regs_o.rmap_memory_config_reg.rmap_win_area_offset_low_dword(15 downto 8) <= avs_config_i.writedata(15 downto 8);
                --                  -- end if;
                --                  -- if (avs_config_i.byteenable(2) = '1') then
                --                      config_wr_regs_o.rmap_memory_config_reg.rmap_win_area_offset_low_dword(23 downto 16) <= avs_config_i.writedata(23 downto 16);
                --                  -- end if;
                --                  -- if (avs_config_i.byteenable(3) = '1') then
                --                      config_wr_regs_o.rmap_memory_config_reg.rmap_win_area_offset_low_dword(31 downto 24) <= avs_config_i.writedata(31 downto 24);
                --                  -- end if;

                when (16#29#) =>
                    -- RMAP Memory Area Pointer Register : RMAP Memory Area Pointer
                    -- if (avs_config_i.byteenable(0) = '1') then
                    config_wr_regs_o.rmap_mem_area_ptr_reg.rmap_mem_area_ptr(7 downto 0)   <= avs_config_i.writedata(7 downto 0);
                    -- end if;
                    -- if (avs_config_i.byteenable(1) = '1') then
                    config_wr_regs_o.rmap_mem_area_ptr_reg.rmap_mem_area_ptr(15 downto 8)  <= avs_config_i.writedata(15 downto 8);
                    -- end if;
                    -- if (avs_config_i.byteenable(2) = '1') then
                    config_wr_regs_o.rmap_mem_area_ptr_reg.rmap_mem_area_ptr(23 downto 16) <= avs_config_i.writedata(23 downto 16);
                    -- end if;
                    -- if (avs_config_i.byteenable(3) = '1') then
                    config_wr_regs_o.rmap_mem_area_ptr_reg.rmap_mem_area_ptr(31 downto 24) <= avs_config_i.writedata(31 downto 24);
                -- end if;

                when (16#2A#) =>
                    -- FEE Machine Config Register : FEE Machine Clear
                    -- if (avs_config_i.byteenable(0) = '1') then
                    config_wr_regs_o.fee_machine_config_reg.fee_machine_clear <= avs_config_i.writedata(0);
                -- end if;

                when (16#2B#) =>
                    -- FEE Machine Config Register : FEE Machine Stop
                    -- if (avs_config_i.byteenable(0) = '1') then
                    config_wr_regs_o.fee_machine_config_reg.fee_machine_stop <= avs_config_i.writedata(0);
                -- end if;

                when (16#2C#) =>
                    -- FEE Machine Config Register : FEE Machine Start
                    -- if (avs_config_i.byteenable(0) = '1') then
                    config_wr_regs_o.fee_machine_config_reg.fee_machine_start <= avs_config_i.writedata(0);
                -- end if;

                when (16#2D#) =>
                    -- Data Packet Config Register : Data Packet Packet Length
                    -- if (avs_config_i.byteenable(0) = '1') then
                    config_wr_regs_o.data_packet_config_reg.data_pkt_packet_length(7 downto 0)  <= avs_config_i.writedata(7 downto 0);
                    -- end if;
                    -- if (avs_config_i.byteenable(1) = '1') then
                    config_wr_regs_o.data_packet_config_reg.data_pkt_packet_length(15 downto 8) <= avs_config_i.writedata(15 downto 8);
                -- end if;

                when (16#2E#) =>
                    -- Data Packet Config Register : Data Packet FEE Mode
                    -- if (avs_config_i.byteenable(0) = '1') then
                    config_wr_regs_o.data_packet_config_reg.data_pkt_fee_mode <= avs_config_i.writedata(4 downto 0);
                -- end if;

                when (16#2F#) =>
                    -- Data Packet Config Register : Data Packet CCD Number
                    -- if (avs_config_i.byteenable(0) = '1') then
                    config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_number <= avs_config_i.writedata(1 downto 0);
                -- end if;

                when (16#30#) =>
                    -- Data Packet Config Register : Data Packet Protocol ID
                    -- if (avs_config_i.byteenable(0) = '1') then
                    config_wr_regs_o.data_packet_config_reg.data_pkt_protocol_id <= avs_config_i.writedata(7 downto 0);
                -- end if;

                when (16#31#) =>
                    -- Data Packet Config Register : Data Packet Logical Address
                    -- if (avs_config_i.byteenable(0) = '1') then
                    config_wr_regs_o.data_packet_config_reg.data_pkt_logical_addr <= avs_config_i.writedata(7 downto 0);
                -- end if;

                when others =>
                    -- No register associated to the address, do nothing
                    null;

            end case;

        end procedure p_writedata;

        variable v_write_address : t_scom_avs_config_address := 0;
    begin
        if (rst_i = '1') then
            avs_config_o.waitrequest <= '1';
            s_data_acquired          <= '0';
            v_write_address          := 0;
            p_reset_registers;
        elsif (rising_edge(clk_i)) then
            avs_config_o.waitrequest <= '1';
            p_control_triggers;
            s_data_acquired          <= '0';
            if (avs_config_i.write = '1') then
                v_write_address          := to_integer(unsigned(avs_config_i.address));
                -- check if the address is allowed
                --              if ((v_write_address >= c_SCOM_AVS_CONFIG_MIN_ADDR) and (v_write_address <= c_SCOM_AVS_CONFIG_MAX_ADDR)) then
                avs_config_o.waitrequest <= '0';
                s_data_acquired          <= '1';
                if (s_data_acquired = '0') then
                    p_writedata(v_write_address);
                end if;
                --              end if;
            end if;
        end if;
    end process p_scom_avs_config_write;

end architecture rtl;
