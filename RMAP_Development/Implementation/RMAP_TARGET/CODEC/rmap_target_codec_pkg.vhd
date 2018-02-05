package rmap_target_codec_pkg is

	-- header

	constant RMAP_PROTOCOL_IDENTIFIER_CONST : std_logic_vector(7 downto 0) := x"01";

	type rmap_target_codec_header_instructions_command_type is record
		write_read               : std_logic;
		verify_data_before_write : std_logic;
		reply                    : std_logic;
		increment_address        : std_logic;
	end record rmap_target_codec_header_instructions_command_type;

	constant RMAP_INSTRUCTION_COMMAND_RESET : rmap_target_codec_header_instructions_command_type := (
		write_read               => '0',
		verify_data_before_write => '0',
		reply                    => '0',
		increment_address        => '0'
	);

	type rmap_target_codec_header_instructions_type is record
		packet_type          : std_logic_vector(1 downto 0);
		command              : rmap_target_codec_header_instructions_command_type;
		reply_address_length : std_logic_vector(1 downto 0);
	end record rmap_target_codec_header_instructions_type;

	constant RMAP_INSTRUCTION_RESET : rmap_target_codec_header_instructions_type := (
		packet_type          => "00",
		command              => RMAP_INSTRUCTION_COMMAND_RESET,
		reply_address_length => "00"
	);

	type rmap_target_codec_header_reply_address_type is array (1 to 12) of std_logic_vector(7 downto 0);
	type rmap_target_codec_header_transaction_identifier_type is array (1 to 2) of std_logic_vector(7 downto 0);
	type rmap_target_codec_header_address_type is array (1 to 4) of std_logic_vector(7 downto 0);
	type rmap_target_codec_header_data_length_type is array (1 to 3) of std_logic_vector(7 downto 0);

	type rmap_target_codec_header_data_type is record
		target_logical_address    : std_logic_vector(7 downto 0);
		instructions              : rmap_target_codec_header_instructions_type;
		key                       : std_logic_vector(7 downto 0);
		reply_address             : rmap_target_codec_header_reply_address_type;
		reply_address_is_used     : std_logic_vector;
		initiator_logical_address : std_logic_vector(7 downto 0);
		transaction_identifier    : rmap_target_codec_header_transaction_identifier_type;
		extended_address          : std_logic_vector(7 downto 0);
		address                   : rmap_target_codec_header_address_type;
		data_length               : rmap_target_codec_header_data_length_type;
	end record rmap_target_codec_header_data_type;

	subtype rmap_target_codec_header_transaction_identifier is natural range 0 to ((2**16) - 1);
	subtype rmap_target_codec_header_data_length is natural range 0 to ((2**24) - 1);

	type rmap_target_codec_header_error_type is record
		early_eop            : std_logic;
		eep                  : std_logic;
		header_crc           : std_logic;
		unused_packet_type   : std_logic;
		invalid_command_code : std_logic;
		too_much_data        : std_logic;
	end record rmap_target_codec_header_error_type;

	type rmap_target_codec_header_flags_type is record
		command_received  : std_logic;
		write_request     : std_logic;
		read_request      : std_logic;
		discarded_package : std_logic;
	end record rmap_target_codec_header_flags_type;

	type rmap_target_codec_header_control_type is record
		ready_for_another_package : std_logic;
	end record rmap_target_codec_header_control_type;

	-- reply

	type rmap_target_codec_reply_data_type is record
		reply_spw_address         : rmap_target_codec_header_reply_address_type;
		reply_spw_address_is_used : std_logic;
		initiator_logical_address : std_logic_vector(7 downto 0);
		instructions              : rmap_target_codec_header_instructions_type;
		status                    : std_logic_vector(7 downto 0);
		target_logical_address    : std_logic_vector(7 downto 0);
		transaction_identifier    : rmap_target_codec_header_transaction_identifier_type;
		data_length               : rmap_target_codec_header_data_length_type;
	end record rmap_target_codec_reply_data_type;

	type rmap_target_codec_reply_flags_type is record
		write_reply_finished : std_logic;
		read_reply_finished  : std_logic;
	end record rmap_target_codec_reply_flags_type;

	type rmap_target_codec_reply_control_type is record
		ready_to_send_reply : std_logic;
	end record rmap_target_codec_reply_control_type;

	-- write

	subtype rmap_target_codec_write_address_type is natural range 0 to ((2 ** 40) - 1);
	subtype rmap_target_codec_write_data_length_type is natural range 0 to ((2 ** 24) - 1);

	type rmap_target_codec_write_headerdata_type is record
		instruction_verify_data_before_write : std_logic;
		instruction_increment_address        : std_logic;
		full_address                         : rmap_target_codec_write_address_type;
		data_length                          : rmap_target_codec_write_data_length_type;
	end record rmap_target_codec_write_headerdata_type;

	type rmap_target_codec_write_data_type is record
		writedata : std_logic_vector(7 downto 0);
		address   : rmap_target_codec_write_address_type;
	end record rmap_target_codec_write_data_type;

	type rmap_target_codec_write_error_type is record
		early_eop             : std_logic;
		eep                   : std_logic;
		too_much_data         : std_logic;
		verify_buffer_overrun : std_logic;
		invalid_data_crc      : std_logic;
	end record rmap_target_codec_write_error_type;

	type rmap_target_codec_write_flags_type is record
		write_data_indication  : std_logic;
		write_operation_failed : std_logic;
	end record rmap_target_codec_write_flags_type;

	type rmap_target_codec_write_control_type is record
		write_authorization : std_logic;
	end record rmap_target_codec_write_control_type;

	-- read

	type rmap_target_codec_read_headerdata_type is record
		instruction_increment_address : std_logic;
		full_address                  : rmap_target_codec_write_address_type;
		data_length                   : rmap_target_codec_write_data_length_type;
	end record rmap_target_codec_read_headerdata_type;

	type rmap_target_codec_read_mem_data_type is record
		read_error : std_logic;
		readdata   : std_logic_vector(7 downto 0);
	end record rmap_target_codec_read_mem_data_type;

	type rmap_target_codec_read_mem_control_type is record
		address : rmap_target_codec_write_address_type;
	end record rmap_target_codec_read_mem_control_type;

	type rmap_target_codec_read_flags_type is record
		read_data_indication  : std_logic;
		read_operation_failed : std_logic;
	end record rmap_target_codec_read_flags_type;

	type rmap_target_codec_read_control_type is record
		read_authorization : std_logic;
	end record rmap_target_codec_read_control_type;

end package rmap_target_codec_pkg;

package body rmap_target_codec_pkg is

end package body rmap_target_codec_pkg;
