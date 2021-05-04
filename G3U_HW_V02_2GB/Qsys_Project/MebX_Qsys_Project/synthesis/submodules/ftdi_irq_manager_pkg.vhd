library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package ftdi_irq_manager_pkg is

	type t_ftdi_rx_irq_manager_watches is record
		rx_buffer_empty         : std_logic;
		rly_hccd_last_rx_buffer : std_logic;
		rx_hccd_comm_err_state  : std_logic;
	end record t_ftdi_rx_irq_manager_watches;

	type t_ftdi_rx_irq_manager_flags is record
		rx_hccd_received : std_logic;
		rx_hccd_comm_err : std_logic;
	end record t_ftdi_rx_irq_manager_flags;

	constant c_FTDI_RX_IRQ_MANAGER_WATCHES_RST : t_ftdi_rx_irq_manager_watches := (
		rx_buffer_empty         => '0',
		rly_hccd_last_rx_buffer => '0',
		rx_hccd_comm_err_state  => '0'
	);

	constant c_FTDI_RX_IRQ_MANAGER_FLAGS_RST : t_ftdi_rx_irq_manager_flags := (
		rx_hccd_received => '0',
		rx_hccd_comm_err => '0'
	);

	--

	type t_ftdi_tx_irq_manager_watches is record
		tx_lut_transmitted    : std_logic;
		tx_lut_comm_err_state : std_logic;
	end record t_ftdi_tx_irq_manager_watches;

	type t_ftdi_tx_irq_manager_flags is record
		tx_lut_finished : std_logic;
		tx_lut_comm_err : std_logic;
	end record t_ftdi_tx_irq_manager_flags;

	constant c_FTDI_TX_IRQ_MANAGER_WATCHES_RST : t_ftdi_tx_irq_manager_watches := (
		tx_lut_transmitted    => '0',
		tx_lut_comm_err_state => '0'
	);

	constant c_FTDI_TX_IRQ_MANAGER_FLAGS_RST : t_ftdi_tx_irq_manager_flags := (
		tx_lut_finished => '0',
		tx_lut_comm_err => '0'
	);

end package ftdi_irq_manager_pkg;

package body ftdi_irq_manager_pkg is

end package body ftdi_irq_manager_pkg;
