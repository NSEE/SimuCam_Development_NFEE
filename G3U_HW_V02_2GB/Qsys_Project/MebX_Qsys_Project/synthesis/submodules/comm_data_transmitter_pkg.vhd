library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package comm_data_transmitter_pkg is

	-- packet header constants
	constant c_PKT_HEADER_LOGICAL_ADDR     : natural range 0 to 9 := 0;
	constant c_PKT_HEADER_PROTOCOL_ID      : natural range 0 to 9 := 1;
	constant c_PKT_HEADER_LENGTH_MSB       : natural range 0 to 9 := 2;
	constant c_PKT_HEADER_LENGTH_LSB       : natural range 0 to 9 := 3;
	constant c_PKT_HEADER_TYPE_MSB         : natural range 0 to 9 := 4;
	constant c_PKT_HEADER_TYPE_LSB         : natural range 0 to 9 := 5;
	constant c_PKT_HEADER_FRAME_CNT_MSB    : natural range 0 to 9 := 6;
	constant c_PKT_HEADER_FRAME_CNT_LSB    : natural range 0 to 9 := 7;
	constant c_PKT_HEADER_SEQUENCE_CNT_MSB : natural range 0 to 9 := 8;
	constant c_PKT_HEADER_SEQUENCE_CNT_LSB : natural range 0 to 9 := 9;

	constant c_PKT_HEADER_SIZE : std_logic_vector(15 downto 0) := x"000A"; -- header is 10 bytes

	constant c_SPW_CODEC_DATA_ID_FLAG   : std_logic                    := '0';
	constant c_SPW_CODEC_PKTEND_ID_FLAG : std_logic                    := '1';
	constant c_SPW_CODEC_EOP_ID_DATA    : std_logic_vector(7 downto 0) := x"00";
	constant c_SPW_CODEC_EEP_ID_DATA    : std_logic_vector(7 downto 0) := x"01";

	-- data transmitter control record
	type t_comm_data_trans_control is record
		start_transmission    : std_logic;
		reset_transmitter     : std_logic;
		sequence_cnt_init_val : std_logic_vector(15 downto 0);
	end record t_comm_data_trans_control;

	-- data transmitter status record
	type t_comm_data_trans_status is record
		transmission_finished : std_logic;
		sequence_cnt_next_val : std_logic_vector(15 downto 0);
	end record t_comm_data_trans_status;

	-- data transmitter control reset constant
	constant c_COMM_DATA_TRANS_CONTROL_RST : t_comm_data_trans_control := (
		start_transmission    => '0',
		reset_transmitter     => '0',
		sequence_cnt_init_val => (others => '0')
	);

	-- data transmitter status reset constant
	constant c_COMM_DATA_TRANS_STATUS_RST : t_comm_data_trans_status := (
		transmission_finished => '0',
		sequence_cnt_next_val => (others => '0')
	);

	-- data transmitter spw tx control record
	type t_comm_data_trans_spw_tx_control is record
		tx_flag  : std_logic;
		tx_data  : std_logic_vector(7 downto 0);
		tx_write : std_logic;
	end record t_comm_data_trans_spw_tx_control;

	-- data transmitter spw tx status record
	type t_comm_data_trans_spw_tx_status is record
		tx_ready : std_logic;
	end record t_comm_data_trans_spw_tx_status;

	-- data transmitter spw tx control reset constant
	constant c_COMM_DATA_TRANS_SPW_TX_CONTROL_RST : t_comm_data_trans_spw_tx_control := (
		tx_flag  => '0',
		tx_data  => (others => '0'),
		tx_write => '0'
	);

	-- data transmitter spw tx status reset constant
	constant c_COMM_DATA_TRANS_SPW_TX_STATUS_RST : t_comm_data_trans_spw_tx_status := (
		tx_ready => '0'
	);

end package comm_data_transmitter_pkg;

package body comm_data_transmitter_pkg is

end package body comm_data_transmitter_pkg;
