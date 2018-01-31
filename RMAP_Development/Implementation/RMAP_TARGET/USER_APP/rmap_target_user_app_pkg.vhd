package rmap_target_user_app_pkg is

	-- RMAP reply error code
	constant ERROR_CODE_COMMAND_EXECUTED_SUCCESSFULLY                  : natural := 0;
	constant ERROR_CODE_GENERAL_ERROR_CODE                             : natural := 1;
	constant ERROR_CODE_UNUSED_RMAP_PACKET_TYPE_OR_COMMAND_CODE        : natural := 2;
	constant ERROR_CODE_INVALID_KEY                                    : natural := 3;
	constant ERROR_CODE_INVALID_DATA_CRC                               : natural := 4;
	constant ERROR_CODE_EARLY_EOP                                      : natural := 5;
	constant ERROR_CODE_TOO_MUCH_DATA                                  : natural := 6;
	constant ERROR_CODE_EEP                                            : natural := 7;
	constant ERROR_CODE_VERIFY_BUFFER_OVERRUN                          : natural := 9;
	constant ERROR_CODE_RMAP_COMMAND_NOT_IMPLEMENTED_OR_NOT_AUTHORISED : natural := 10;
	constant ERROR_CODE_RMW_DATA_LENGTH_ERROR                          : natural := 11;
	constant ERROR_CODE_INVALID_TARGET_LOGICAL_ADDRESS                 : natural := 12;

	-- registers

	type rmap_target_user_app_register_type is record
		target_logical_address : std_logic_vector(7 downto 0);
		key                    : std_logic_vector(7 downto 0);
	end record rmap_target_user_app_register_type;

	-- internal

	type rmap_target_user_app_internal_flags_type is record
		dummy : std_logic;
	end record rmap_target_user_app_internal_flags_type;

	-- header user data

	type rmap_target_user_app_instructions_command_type is record
		write_read               : std_logic;
		verify_data_before_write : std_logic;
		reply                    : std_logic;
		increment_address        : std_logic;
	end record rmap_target_user_app_instructions_command_type;

	type rmap_target_user_app_instructions_type is record
		packet_type          : std_logic_vector(1 downto 0);
		command              : rmap_target_user_app_instructions_command_type;
		reply_address_length : std_logic_vector(1 downto 0);
	end record rmap_target_user_app_instructions_type;

	type rmap_target_user_app_headerdata_type is record
		target_logical_address    : std_logic_vector(7 downto 0);
		instructions              : rmap_target_user_app_instructions_type;
		key                       : std_logic_vector(7 downto 0);
		initiator_logical_address : std_logic_vector(7 downto 0);
		transaction_identifier    : std_logic_vector(15 downto 0);
		extended_address          : std_logic_vector(7 downto 0);
		memory_address            : std_logic_vector(31 downto 0);
		data_length               : std_logic_vector(23 downto 0);
	end record rmap_target_user_app_headerdata_type;

	type rmap_target_user_app_codecbusy_type is record
		header_busy : std_logic;
		reply_busy  : std_logic;
		write_busy  : std_logic;
		read_busy   : std_logic;
	end record rmap_target_user_app_codecbusy_type;

	type rmap_target_user_app_codecflags_type is record
		command_received       : std_logic;
		write_request          : std_logic;
		read_request           : std_logic;
		discarded_package      : std_logic;
		write_reply_finished   : std_logic;
		read_reply_finished    : std_logic;
		write_data_indication  : std_logic;
		read_data_indication   : std_logic;
		write_operation_failed : std_logic;
		read_operation_failed  : std_logic;
	end record rmap_target_user_app_codecflags_type;

	type rmap_target_user_app_codecerror_type is record
		early_eop             : std_logic;
		eep                   : std_logic;
		header_crc            : std_logic;
		unused_packet_type    : std_logic;
		invalid_command_code  : std_logic;
		too_much_data         : std_logic;
		verify_buffer_overrun : std_logic;
		invalid_data_crc      : std_logic;
	end record rmap_target_user_app_codecerror_type;

	type rmap_target_user_app_codeccontrol_type is record
		ready_for_another_package : std_logic;
		write_authorization       : std_logic;
		read_authorization        : std_logic;
		discard_package           : std_logic;
		send_write_reply          : std_logic;
		send_read_reply           : std_logic;
		reply_error_code          : natural range 0 to 255;
	end record rmap_target_user_app_codeccontrol_type;

end package rmap_target_user_app_pkg;

package body rmap_target_user_app_pkg is

end package body rmap_target_user_app_pkg;
