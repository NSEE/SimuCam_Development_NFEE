library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package spwc_errinj_pkg is

	-- spw error injection code constants
	constant c_SPWC_ERRINJ_CODE_NONE          : std_logic_vector(3 downto 0) := x"0";
	constant c_SPWC_ERRINJ_CODE_DISCONNECTION : std_logic_vector(3 downto 0) := x"1";
	constant c_SPWC_ERRINJ_CODE_PARITY        : std_logic_vector(3 downto 0) := x"2";
	constant c_SPWC_ERRINJ_CODE_ESCAPE        : std_logic_vector(3 downto 0) := x"3";
	constant c_SPWC_ERRINJ_CODE_CREDIT        : std_logic_vector(3 downto 0) := x"4";
	constant c_SPWC_ERRINJ_CODE_CHAR          : std_logic_vector(3 downto 0) := x"5";

	-- spw error injection controller control record
	type t_spwc_errinj_controller_control is record
		start_errinj : std_logic;
		reset_errinj : std_logic;
		errinj_code  : std_logic_vector(3 downto 0);
	end record t_spwc_errinj_controller_control;

	-- spw error injection controller status record
	type t_spwc_errinj_controller_status is record
		errinj_busy  : std_logic;
		errinj_ready : std_logic;
	end record t_spwc_errinj_controller_status;

	-- spw error injection controller control reset constant
	constant c_SPWC_ERRINJ_CONTROLLER_CONTROL_RST : t_spwc_errinj_controller_control := (
		start_errinj => '0',
		reset_errinj => '0',
		errinj_code  => c_SPWC_ERRINJ_CODE_NONE
	);

	-- spw error injection controller status constant
	constant c_SPWC_ERRINJ_CONTROLLER_STATUS_RST : t_spwc_errinj_controller_status := (
		errinj_busy  => '0',
		errinj_ready => '0'
	);

end package spwc_errinj_pkg;

package body spwc_errinj_pkg is

end package body spwc_errinj_pkg;
