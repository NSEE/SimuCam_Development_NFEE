library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package avalon_mm_rst_controller_registers_pkg is

    --  SimuCam Reset Control Register                  (32 bits):
    --    31-31 : SimuCam Reset control bit              [R/W]
    --    30-30 : SimuCam Reset Counter Clear            [R/W]
    --    29- 0 : SimuCam Reset Timer value              [R/W]

    --  Device Reset Control Register                  (32 bits):
    --    31-12 : Reserved                               [-/-]
    --    11-11 : FTDI Module Reset control bit          [R/W]
    --    10-10 : Sync Module Reset control bit          [R/W]
    --     9- 9 : RS232 Module Reset control bit         [R/W]
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
    --    31- 0 : Reset Counter status value             [R/-]

    constant c_RSTC_AVALON_MM_REG_OFFSET         : natural := 0;
    constant c_RSTC_SIMUCAM_RESET_MM_REG_ADDRESS : natural := 0;
    constant c_RSTC_DEVICE_RESET_MM_REG_ADDRESS  : natural := 1;
    constant c_RSTC_RESET_COUNTER_MM_REG_ADDRESS : natural := 2;

    type t_rstc_simucam_reset_register is record
        simucam_reset         : std_logic;
        simucam_reset_cnt_clr : std_logic;
        simucam_timer         : std_logic_vector(29 downto 0);
    end record t_rstc_simucam_reset_register;

    type t_rstc_device_reset_register is record
        rs232_reset : std_logic;
    end record t_rstc_device_reset_register;

    type t_rstc_reset_counter_register is record
        reset_cnt : std_logic_vector(31 downto 0);
    end record t_rstc_reset_counter_register;

    type t_rst_controller_write_registers is record
        simucam_reset : t_rstc_simucam_reset_register;
        device_reset  : t_rstc_device_reset_register;
    end record t_rst_controller_write_registers;

    type t_rst_controller_read_registers is record
        reset_counter : t_rstc_reset_counter_register;
    end record t_rst_controller_read_registers;

end package avalon_mm_rst_controller_registers_pkg;

package body avalon_mm_rst_controller_registers_pkg is

end package body avalon_mm_rst_controller_registers_pkg;
