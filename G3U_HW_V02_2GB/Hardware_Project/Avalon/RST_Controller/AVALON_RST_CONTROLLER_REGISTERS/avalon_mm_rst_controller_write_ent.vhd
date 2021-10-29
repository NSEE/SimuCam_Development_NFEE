library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.avalon_mm_rst_controller_pkg.all;
use work.avalon_mm_rst_controller_registers_pkg.all;

entity avalon_mm_rst_controller_write_ent is
    port(
        clk_i                            : in  std_logic;
        rst_i                            : in  std_logic;
        avalon_mm_spacewire_i            : in  t_avalon_mm_rst_controller_write_in;
        avalon_mm_spacewire_o            : out t_avalon_mm_rst_controller_write_out;
        rst_controller_write_registers_o : out t_rst_controller_write_registers
    );
end entity avalon_mm_rst_controller_write_ent;

architecture rtl of avalon_mm_rst_controller_write_ent is

begin

    p_avalon_mm_rst_controller_write : process(clk_i, rst_i) is
        procedure p_reset_registers is
        begin
            rst_controller_write_registers_o.simucam_reset.simucam_reset <= '1';
            rst_controller_write_registers_o.simucam_reset.simucam_timer <= std_logic_vector(to_unsigned(5000000, rst_controller_write_registers_o.simucam_reset.simucam_timer'length)); -- 100 ms of reset
            rst_controller_write_registers_o.device_reset.rs232_reset    <= '0';
        end procedure p_reset_registers;

        procedure p_control_triggers is
        begin
            --			rst_controller_write_registers_o.simucam_reset.simucam_reset <= '0';
        end procedure p_control_triggers;

        procedure p_writedata(write_address_i : t_avalon_mm_rst_controller_address) is
        begin
            -- Registers Write Data
            case (write_address_i) is
                -- Case for access to all registers address

                --  SimuCam Reset Control Register                  (32 bits):
                when (c_RSTC_SIMUCAM_RESET_MM_REG_ADDRESS + c_RSTC_AVALON_MM_REG_OFFSET) =>
                    --    31-31 : SimuCam Reset control bit              [R/W]
                    rst_controller_write_registers_o.simucam_reset.simucam_reset         <= avalon_mm_spacewire_i.writedata(31);
                    --    30-30 : SimuCam Reset Counter Clear            [R/W]
                    rst_controller_write_registers_o.simucam_reset.simucam_reset_cnt_clr <= avalon_mm_spacewire_i.writedata(30);
                    --    29- 0 : SimuCam Reset Timer value              [R/W]
                    rst_controller_write_registers_o.simucam_reset.simucam_timer         <= avalon_mm_spacewire_i.writedata(29 downto 0);

                --  Device Reset Control Register                  (32 bits):
                when (c_RSTC_DEVICE_RESET_MM_REG_ADDRESS + c_RSTC_AVALON_MM_REG_OFFSET) =>
                    --    31-12 : Reserved                               [-/-]
                    --    11-11 : FTDI Module Reset control bit          [R/W]
                    --    10-10 : Sync Module Reset control bit          [R/W]
                    --     9- 9 : RS232 Module Reset control bit         [R/W]
                    rst_controller_write_registers_o.device_reset.rs232_reset <= avalon_mm_spacewire_i.writedata(9);
                --     8- 8 : SD Card Module Reset control bit       [R/W]
                --     7- 7 : Comm Module CH8 Reset control bit      [R/W]
                --     6- 6 : Comm Module CH7 Reset control bit      [R/W]
                --     5- 5 : Comm Module CH6 Reset control bit      [R/W]
                --     4- 4 : Comm Module CH5 Reset control bit      [R/W]
                --     3- 3 : Comm Module CH4 Reset control bit      [R/W]
                --     2- 2 : Comm Module CH3 Reset control bit      [R/W]
                --     1- 1 : Comm Module CH2 Reset control bit      [R/W]
                --     0- 0 : Comm Module CH1 Reset control bit      [R/W]

                when others =>
                    null;
            end case;
        end procedure p_writedata;

        variable v_write_address : t_avalon_mm_rst_controller_address := 0;
    begin
        if (rst_i = '1') then
            avalon_mm_spacewire_o.waitrequest <= '1';
            v_write_address                   := 0;
            p_reset_registers;
        elsif (rising_edge(clk_i)) then
            avalon_mm_spacewire_o.waitrequest <= '1';
            p_control_triggers;
            if (avalon_mm_spacewire_i.write = '1') then
                avalon_mm_spacewire_o.waitrequest <= '0';
                v_write_address                   := to_integer(unsigned(avalon_mm_spacewire_i.address));
                p_writedata(v_write_address);
            end if;
        end if;
    end process p_avalon_mm_rst_controller_write;

end architecture rtl;
