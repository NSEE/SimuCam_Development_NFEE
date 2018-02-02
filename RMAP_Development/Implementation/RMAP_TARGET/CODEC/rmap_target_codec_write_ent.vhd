library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.rmap_target_codec_pkg.all;

entity rmap_target_codec_write_ent is
	port(
		clk_i                   : in  std_logic;
		rst_i                   : in  std_logic;
		-- spw codec comunication (data receive)
		spw_valid_i             : in  std_logic;
		spw_flag_i              : in  std_logic;
		spw_data_i              : in  std_logic_vector(7 downto 0);
		spw_read_o              : out std_logic;
		spw_codec_error_o       : out std_logic;
		-- header data
		rmap_write_headerdata_i : in  rmap_target_codec_write_headerdata_type;
		-- write data
		rmap_write_data_o       : out rmap_target_codec_write_data_type;
		-- error flags
		rmap_write_error_o      : out rmap_target_codec_write_error_type;
		-- status flags
		rmap_write_flags_o      : out rmap_target_codec_write_flags_type;
		-- control flags
		rmap_write_control_i    : in  rmap_target_codec_write_control_type;
		-- busy flag
		rmap_write_busy_o       : out std_logic
	);
end entity rmap_target_codec_write_ent;

architecture RTL of rmap_target_codec_write_ent is

	type rmap_write_state_machine_type is (
		standby_state,
		waiting_data_state,
		field_data_state,
		field_data_crc_state,
		field_eop_state,
		write_data_state,
		unexpected_package_end_state,
		waiting_package_end_state
	);

	type rmap_target_codec_write_verify_buffer_type is array (0 to ((2 ** 10) - 1)) of std_logic_vector(7 downto 0);

	constant SPW_EOP_CONST : std_logic := '0';
	constant SPW_EEP_CONST : std_logic := '1';

begin

	rmap_target_codec_write_proc : process(clk_i, rst_i) is
		variable rmap_write_data_var                     : rmap_target_codec_write_data_type;
		variable rmap_write_error_var                    : rmap_target_codec_write_error_type;
		variable rmap_write_flags_var                    : rmap_target_codec_write_flags_type;
		variable rmap_write_state_machine_var            : rmap_write_state_machine_type := standby_state;
		variable rmap_write_state_machine_next_state_var : rmap_write_state_machine_type := standby_state;
		variable rmap_write_crc_var                      : std_logic_vector(7 downto 0)  := (others => '0');
		variable rmap_write_byte_field_counter_var       : rmap_target_codec_write_data_length_type;
		variable rmap_write_verify_buffer                : rmap_target_codec_write_verify_buffer_type;

	begin
		if (rst_i = '1') then
		-- reset procedures

		-- ports init
		-- TODO: ports init

		-- signals init
		-- TODO: signals init

		-- variables init
		-- TODO: variables init

		elsif (rising_edge(clk_i)) then

			-- signals atribution to avoid latches and paths were no value is given to a signal
			-- variables atribution checks to avoid a path where no value is given to a variable

			case (rmap_write_state_machine_var) is

				when standby_state =>
					-- TODO: standby_state
					-- does nothing until user application signals a write authorization
					-- reset internal information
					-- keep output as is
					-- check if user application authorized a write
					if (rmap_write_control_i.write_authorization = '1') then
						-- write authorized
						-- update data address
						rmap_write_data_var.address             := rmap_write_headerdata_i.full_address;
						-- prepare byte field counter for multi-field header data
						rmap_write_byte_field_counter_var       := rmap_write_headerdata_i.data_length;
						-- set busy flag; go to waiting data
						rmap_write_busy_o                       <= '1';
						rmap_write_state_machine_var            := waiting_data_state;
						rmap_write_state_machine_next_state_var := field_data_state;
					else
						-- write not authorized; stay in standby
						rmap_write_state_machine_var := standby_state;
					end if;

				when waiting_data_state =>
					spw_read_o <= '0';
					if (spw_valid_i = '1') then
						rmap_write_state_machine_var := rmap_write_state_machine_next_state_var;
					else
						rmap_write_state_machine_var := waiting_data_state;
					end if;

				when field_data_state =>
					-- check if an unexpected eop or eep arrived
					if (spw_flag_i = '1') then
						-- unexpected eop or eep, go to treatment state
						rmap_write_state_machine_var := unexpected_package_end_state;
					else
						-- expected data field
						-- check if the data need to be verified before written
						if (rmap_write_headerdata_i.instruction_verify_data_before_write = '1') then
							-- data need to be verified
							-- buffer data for verification
							rmap_write_verify_buffer(rmap_write_byte_field_counter_var) := spw_data_i;
							-- prepare for next field arrival
							rmap_write_state_machine_var                                := waiting_data_state;
						else
							-- data can be written to memory
							-- collect field data
							rmap_write_data_var.writedata := spw_data_i;
							-- go to write data state
							rmap_write_state_machine_var  := write_data_state;
						end if;
						-- update crc calculation
						rmap_write_crc_var                := RMAP_CalculateCRC(rmap_write_crc_var, spw_data_i);
						-- update byte field counter
						rmap_write_byte_field_counter_var := rmap_write_byte_field_counter_var - 1;
						-- indicate that the spw data was used
						spw_read_o                        <= '1';
						-- check if multi-field data field ended
						if (rmap_write_byte_field_counter_var = 0) then
							-- last byte field processed, go to next data field
							rmap_write_state_machine_next_state_var := field_data_crc_state;
						else
							-- more byte fields remaining
							rmap_write_state_machine_next_state_var := field_data_state;
						end if;
					end if;

				when field_data_crc_state =>
					-- TODO: field_data_crc_state
					-- check if an unexpected eop or eep arrived
					if (spw_flag_i = '1') then
						-- unexpected eop or eep, go to treatment state
						rmap_write_state_machine_var := unexpected_package_end_state;
					else
						-- expected data field
						-- check if the incoming data crc matches the calculated one
						if (spw_data_i = rmap_write_crc_var) then
							-- data crc match
							-- next expected field is an eop
							-- prepare for next field arrival
							rmap_write_state_machine_next_state_var := field_eop_state;
							rmap_write_state_machine_var            := waiting_data_state;
						else
							-- data crc does not match; flag the error
							rmap_write_error_var.invalid_data_crc := '1';
							-- TODO: data crc does not match
						end if;
					end if;

				when field_eop_state =>
					-- TODO: field_eop_state
					-- check if an eop or eep arrived
					if (spw_flag_i = '1') then
						if (spw_data_i = SPW_EOP_CONST) then
							-- eop arrived as expected
							-- check if the data need to be verified before written
							if (rmap_write_headerdata_i.instruction_verify_data_before_write = '1') then
								-- data need to be verified and data crc checked out
								-- data can be written in memory, go to verified data write state
								rmap_write_state_machine_var := write_verified_data_state;
							else
								-- data does not need to be verified
								-- data already written to memory, finish of the write operation
								-- update output information
								-- clear busy flag; go to standby
								rmap_write_busy_o             <= '0';
								rmap_header_state_machine_var := standby_state;
							end if;

						elsif (spw_data_i = SPW_EEP_CONST) then
							-- unexpected eep; flag the error
							rmap_write_error_var.eep := '1';
						-- TODO: unexpected eep
						else
							-- spacewire codec error (impossible value)
							-- flag the error; indicate that the spw data was used; clear busy flag; go to standby
							spw_codec_error_o            <= '1';
							spw_read_o                   <= '1';
							rmap_write_busy_o            <= '0';
							rmap_write_state_machine_var := standby_state;
						end if;
					else
						-- too much data; flag the error
						rmap_write_error_var.too_much_data := '1';
						-- TODO: too much data
					end if;
					-- indicate that the spw data was used
					rmap_write_state_machine_var := standby_state;

				when write_verified_data_state =>
					-- TODO: write_data_state
					null;

				when write_unverified_data_state =>
					-- TODO: write_data_state
					null;

				when unexpected_package_end_state =>
					-- TODO: unexpected_package_end_state
					-- verify if the unexpected package end is an eop or an eep
					-- not necessary to check the flag because it was already checked in the previous state
					if (spw_data_i = SPW_EOP_CONST) then
						-- incomplete header error; flag the error
						rmap_write_error_var.early_eop := '1';
					-- TODO: early oep error
					elsif (spw_data_i = SPW_EEP_CONST) then
						-- error end of package; flag the error
						rmap_write_error_var.eep := '1';
					-- TODO: eep error
					else
						-- spacewire codec error (impossible value)
						-- flag the error; indicate that the spw data was used; clear busy flag; go to standby
						spw_codec_error_o            <= '1';
						spw_read_o                   <= '1';
						rmap_write_busy_o            <= '0';
						rmap_write_state_machine_var := standby_state;
					end if;

				when waiting_package_end_state =>
					-- check if an eop or eep arrived
					if (spw_flag_i = '1') then
						if ((spw_data_i = SPW_EOP_CONST) or (spw_data_i = SPW_EEP_CONST)) then
							-- current package ended (eop or eep arrived)
							-- indicate that the spw data was used; clear busy flag; go to standy
							spw_read_o                   <= '1';
							rmap_write_busy_o            <= '0';
							rmap_write_state_machine_var := standby_state;
						else
							-- spacewire codec error (impossible value)
							-- flag the error; indicate that the spw data was used; clear busy flag; go to standby
							spw_codec_error_o            <= '1';
							spw_read_o                   <= '1';
							rmap_write_busy_o            <= '0';
							rmap_write_state_machine_var := standby_state;
						end if;
					else
						-- not end of current package yet; keep listening
						-- indicate that the spw data was used; prepare for next byte arrival
						spw_read_o                              <= '1';
						rmap_write_state_machine_var            := waiting_data_state;
						rmap_write_state_machine_next_state_var := waiting_package_end_state;
					end if;

			end case;

		end if;
	end process rmap_target_codec_write_proc;

end architecture RTL;
