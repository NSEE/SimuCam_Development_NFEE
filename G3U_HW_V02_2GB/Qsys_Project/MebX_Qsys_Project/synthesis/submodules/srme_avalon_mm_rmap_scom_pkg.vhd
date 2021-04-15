library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package srme_avalon_mm_rmap_scom_pkg is

    constant c_SRME_AVALON_MM_RMAP_SCOM_ADRESS_SIZE : natural := 12;
    constant c_SRME_AVALON_MM_RMAP_SCOM_DATA_SIZE   : natural := 32;
    constant c_SRME_AVALON_MM_RMAP_SCOM_SYMBOL_SIZE : natural := 8;

    subtype t_srme_avalon_mm_rmap_scom_address is natural range 0 to ((2 ** c_SRME_AVALON_MM_RMAP_SCOM_ADRESS_SIZE) - 1);

    type t_srme_avalon_mm_rmap_scom_read_in is record
        address    : std_logic_vector((c_SRME_AVALON_MM_RMAP_SCOM_ADRESS_SIZE - 1) downto 0);
        read       : std_logic;
        byteenable : std_logic_vector(((c_SRME_AVALON_MM_RMAP_SCOM_DATA_SIZE / c_SRME_AVALON_MM_RMAP_SCOM_SYMBOL_SIZE) - 1) downto 0);
    end record t_srme_avalon_mm_rmap_scom_read_in;

    type t_srme_avalon_mm_rmap_scom_read_out is record
        readdata    : std_logic_vector((c_SRME_AVALON_MM_RMAP_SCOM_DATA_SIZE - 1) downto 0);
        waitrequest : std_logic;
    end record t_srme_avalon_mm_rmap_scom_read_out;

    type t_srme_avalon_mm_rmap_scom_write_in is record
        address    : std_logic_vector((c_SRME_AVALON_MM_RMAP_SCOM_ADRESS_SIZE - 1) downto 0);
        write      : std_logic;
        writedata  : std_logic_vector((c_SRME_AVALON_MM_RMAP_SCOM_DATA_SIZE - 1) downto 0);
        byteenable : std_logic_vector(((c_SRME_AVALON_MM_RMAP_SCOM_DATA_SIZE / c_SRME_AVALON_MM_RMAP_SCOM_SYMBOL_SIZE) - 1) downto 0);
    end record t_srme_avalon_mm_rmap_scom_write_in;

    type t_srme_avalon_mm_rmap_scom_write_out is record
        waitrequest : std_logic;
    end record t_srme_avalon_mm_rmap_scom_write_out;

    constant c_SRME_AVALON_MM_RMAP_SCOM_READ_IN_RST : t_srme_avalon_mm_rmap_scom_read_in := (
        address    => (others => '0'),
        read       => '0',
        byteenable => (others => '0')
    );

    constant c_SRME_AVALON_MM_RMAP_SCOM_READ_OUT_RST : t_srme_avalon_mm_rmap_scom_read_out := (
        readdata    => (others => '0'),
        waitrequest => '1'
    );

    constant c_SRME_AVALON_MM_RMAP_SCOM_WRITE_IN_RST : t_srme_avalon_mm_rmap_scom_write_in := (
        address    => (others => '0'),
        write      => '0',
        writedata  => (others => '0'),
        byteenable => (others => '0')
    );

    constant c_SRME_AVALON_MM_RMAP_SCOM_WRITE_OUT_RST : t_srme_avalon_mm_rmap_scom_write_out := (
        waitrequest => '1'
    );

end package srme_avalon_mm_rmap_scom_pkg;
