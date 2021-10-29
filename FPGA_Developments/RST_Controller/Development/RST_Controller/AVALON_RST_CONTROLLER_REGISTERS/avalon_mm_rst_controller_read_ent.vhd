library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.avalon_mm_rst_controller_pkg.all;
use work.avalon_mm_rst_controller_registers_pkg.all;

entity avalon_mm_rst_controller_read_ent is
    port(
        clk_i                            : in  std_logic;
        rst_i                            : in  std_logic;
        avalon_mm_spacewire_i            : in  t_avalon_mm_rst_controller_read_in;
        avalon_mm_spacewire_o            : out t_avalon_mm_rst_controller_read_out;
        rst_controller_write_registers_i : in  t_rst_controller_write_registers;
        rst_controller_read_registers_i  : in  t_rst_controller_read_registers
    );
end entity avalon_mm_rst_controller_read_ent;

architecture rtl of avalon_mm_rst_controller_read_ent is

begin

    p_avalon_mm_rst_controller_read : process(clk_i, rst_i) is
        procedure p_reset_registers is
        begin
            null;
        end procedure p_reset_registers;

        procedure p_flags_hold is
        begin
            null;
        end procedure p_flags_hold;

        procedure p_readdata(read_address_i : t_avalon_mm_rst_controller_address) is
        begin
            -- Registers Data Read
            case (read_address_i) is
                -- Case for access to all registers address

                --  SimuCam Reset Control Register                  (32 bits):
                when (c_RSTC_SIMUCAM_RESET_MM_REG_ADDRESS + c_RSTC_AVALON_MM_REG_OFFSET) =>
                    --    31-31 : SimuCam Reset control bit              [R/W]
                    avalon_mm_spacewire_o.readdata(31)          <= rst_controller_write_registers_i.simucam_reset.simucam_reset;
                    --    30-30 : SimuCam Reset Counter Clear            [R/W]
                    avalon_mm_spacewire_o.readdata(30)          <= rst_controller_write_registers_i.simucam_reset.simucam_reset_cnt_clr;
                    --    29- 0 : SimuCam Reset Timer value              [R/W]
                    avalon_mm_spacewire_o.readdata(29 downto 0) <= rst_controller_write_registers_i.simucam_reset.simucam_timer;

                --  Device Reset Control Register                  (32 bits):
                when (c_RSTC_DEVICE_RESET_MM_REG_ADDRESS + c_RSTC_AVALON_MM_REG_OFFSET) =>
                    --    31-12 : Reserved                               [-/-]
                    avalon_mm_spacewire_o.readdata(31 downto 12) <= (others => '0');
                    --    11-11 : FTDI Module Reset control bit          [R/W]
                    --    10-10 : Sync Module Reset control bit          [R/W]
                    --     9- 9 : RS232 Module Reset control bit         [R/W]
                    avalon_mm_spacewire_o.readdata(9)            <= rst_controller_write_registers_i.device_reset.rs232_reset;
                --     8- 8 : SD Card Module Reset control bit       [R/W]
                --     7- 7 : Comm Module CH8 Reset control bit      [R/W]
                --     6- 6 : Comm Module CH7 Reset control bit      [R/W]
                --     5- 5 : Comm Module CH6 Reset control bit      [R/W]
                --     4- 4 : Comm Module CH5 Reset control bit      [R/W]
                --     3- 3 : Comm Module CH4 Reset control bit      [R/W]
                --     2- 2 : Comm Module CH3 Reset control bit      [R/W]
                --     1- 1 : Comm Module CH2 Reset control bit      [R/W]
                --     0- 0 : Comm Module CH1 Reset control bit      [R/W]

                --  Reset Counter Status Register                  (32 bits):
                when (c_RSTC_RESET_COUNTER_MM_REG_ADDRESS + c_RSTC_AVALON_MM_REG_OFFSET) =>
                    --    31- 0 : Reset Counter status value             [R/-]
                    avalon_mm_spacewire_o.readdata(31 downto 0) <= rst_controller_read_registers_i.reset_counter.reset_cnt;

                when others =>
                    avalon_mm_spacewire_o.readdata <= (others => '0');
            end case;
        end procedure p_readdata;

        variable v_read_address : t_avalon_mm_rst_controller_address := 0;
    begin
        if (rst_i = '1') then
            avalon_mm_spacewire_o.readdata    <= (others => '0');
            avalon_mm_spacewire_o.waitrequest <= '1';
            v_read_address                    := 0;
            p_reset_registers;
        elsif (rising_edge(clk_i)) then
            avalon_mm_spacewire_o.readdata    <= (others => '0');
            avalon_mm_spacewire_o.waitrequest <= '1';
            p_flags_hold;
            if (avalon_mm_spacewire_i.read = '1') then
                avalon_mm_spacewire_o.waitrequest <= '0';
                v_read_address                    := to_integer(unsigned(avalon_mm_spacewire_i.address));
                p_readdata(v_read_address);
            end if;
        end if;
    end process p_avalon_mm_rst_controller_read;

end architecture rtl;
