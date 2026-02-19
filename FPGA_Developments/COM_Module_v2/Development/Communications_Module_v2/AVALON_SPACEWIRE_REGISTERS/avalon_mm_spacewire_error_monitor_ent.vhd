library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.avalon_mm_spacewire_pkg.all;

-- Aggregates Avalon read/write local error events into a single external
-- error interface intended for top-level routing (for example, a Qsys conduit).
--
-- This block does not store history. It only forwards events that are asserted
-- in the current clock cycle and outputs a one-cycle pulse (`avs_err`) together
-- with the corresponding metadata.
entity avalon_mm_spacewire_error_monitor_ent is
    port(
        -- System clock / reset.
        clk_i                             : in  std_logic;
        rst_i                             : in  std_logic;

        -- Error events coming from Avalon read path.
        avalon_mm_spacewire_read_error_i  : in  t_avalon_mm_spacewire_error_out;

        -- Error events coming from Avalon write path.
        avalon_mm_spacewire_write_error_i : in  t_avalon_mm_spacewire_error_out;

        -- Unified error output:
        --   avs_err           : one-cycle pulse when any supported error occurs
        --   avs_err_addr      : address associated with the event
        --   avs_err_data      : data associated with the event
        --   avs_err_operation : '0' write / '1' read
        --   avs_err_type      : 0 timeout / 1 invalid address
        avalon_mm_spacewire_avs_error_o   : out t_avalon_mm_spacewire_avs_error_out
    );
end entity avalon_mm_spacewire_error_monitor_ent;

architecture rtl of avalon_mm_spacewire_error_monitor_ent is

begin

    -- Error aggregation/arbitration process.
    --
    -- Important behavior:
    -- 1) Output is reset to c_AVALON_MM_SPACEWIRE_AVS_ERROR_OUT_RST on reset.
    -- 2) On every rising edge, output is first reset to default value.
    --    This guarantees `avs_err` is a pulse (unless a new error is present
    --    in that same cycle).
    -- 3) If more than one error source is asserted in the same cycle, a fixed
    --    priority order is applied by the if/elsif chain.
    --    Priority (highest to lowest):
    --      a) write timeout
    --      b) write invalid address
    --      c) read timeout
    --      d) read invalid address
    --
    -- The selected error source fills address/data/operation/type fields.
    p_avalon_mm_spacewire_error_monitor : process(clk_i, rst_i) is
    begin
        if (rst_i = '1') then
            -- Asynchronous reset: clear all monitor outputs.
            avalon_mm_spacewire_avs_error_o <= c_AVALON_MM_SPACEWIRE_AVS_ERROR_OUT_RST;
        elsif (rising_edge(clk_i)) then
            -- Default each cycle to create pulse-based behavior.
            avalon_mm_spacewire_avs_error_o <= c_AVALON_MM_SPACEWIRE_AVS_ERROR_OUT_RST;

            -- Priority 1: write timeout event.
            if (avalon_mm_spacewire_write_error_i.timeout_err = '1') then
                avalon_mm_spacewire_avs_error_o.avs_err                                              <= '1';
                avalon_mm_spacewire_avs_error_o.avs_err_addr                                         <= avalon_mm_spacewire_write_error_i.avs_err_addr;
                avalon_mm_spacewire_avs_error_o.avs_err_data                                         <= avalon_mm_spacewire_write_error_i.avs_err_data;
                avalon_mm_spacewire_avs_error_o.avs_err_operation                                    <= '0';
                -- Type 0 = timeout error.
                avalon_mm_spacewire_avs_error_o.avs_err_type                                         <= std_logic_vector(to_unsigned(0, 7));

            -- Priority 2: write invalid-address event.
            elsif (avalon_mm_spacewire_write_error_i.invalid_addr_err = '1') then
                avalon_mm_spacewire_avs_error_o.avs_err                                              <= '1';
                avalon_mm_spacewire_avs_error_o.avs_err_addr                                         <= avalon_mm_spacewire_write_error_i.avs_err_addr;
                avalon_mm_spacewire_avs_error_o.avs_err_data                                         <= avalon_mm_spacewire_write_error_i.avs_err_data;
                avalon_mm_spacewire_avs_error_o.avs_err_operation                                    <= '0';
                -- Type 1 = invalid address error.
                avalon_mm_spacewire_avs_error_o.avs_err_type                                         <= std_logic_vector(to_unsigned(1, 7));

            -- Priority 3: read timeout event.
            elsif (avalon_mm_spacewire_read_error_i.timeout_err = '1') then
                avalon_mm_spacewire_avs_error_o.avs_err                                              <= '1';
                avalon_mm_spacewire_avs_error_o.avs_err_addr                                         <= avalon_mm_spacewire_read_error_i.avs_err_addr;
                avalon_mm_spacewire_avs_error_o.avs_err_data                                         <= avalon_mm_spacewire_read_error_i.avs_err_data;
                avalon_mm_spacewire_avs_error_o.avs_err_operation                                    <= '1';
                -- Type 0 = timeout error.
                avalon_mm_spacewire_avs_error_o.avs_err_type                                         <= std_logic_vector(to_unsigned(0, 7));

            -- Priority 4: read invalid-address event.
            elsif (avalon_mm_spacewire_read_error_i.invalid_addr_err = '1') then
                avalon_mm_spacewire_avs_error_o.avs_err                                              <= '1';
                avalon_mm_spacewire_avs_error_o.avs_err_addr                                         <= avalon_mm_spacewire_read_error_i.avs_err_addr;
                avalon_mm_spacewire_avs_error_o.avs_err_data                                         <= avalon_mm_spacewire_read_error_i.avs_err_data;
                avalon_mm_spacewire_avs_error_o.avs_err_operation                                    <= '1';
                -- Type 1 = invalid address error.
                avalon_mm_spacewire_avs_error_o.avs_err_type                                         <= std_logic_vector(to_unsigned(1, 7));
            end if;
        end if;
    end process p_avalon_mm_spacewire_error_monitor;

end architecture rtl;
