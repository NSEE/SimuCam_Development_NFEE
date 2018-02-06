-- TODO: write to memory error 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.rmap_target_codec_pkg.all;
use work.rmap_target_codec_crc_pkg.all;

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
		-- memory communication (write)
		mem_write_data_o        : out rmap_target_codec_write_data_type;
		-- header data
		rmap_write_headerdata_i : in  rmap_target_codec_write_headerdata_type;
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
		write_verified_data_state,
		write_unverified_data_state,
		write_finish_operation_state,
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
			-- spw codec comunication (data receive)
			spw_read_o                                <= '0';
			spw_codec_error_o                         <= '0';
			-- memory communication (write)
			mem_write_data_o.writedata                <= x"00";
			mem_write_data_o.address                  <= 0;
			-- error flags
			rmap_write_error_o.early_eop              <= '0';
			rmap_write_error_o.eep                    <= '0';
			rmap_write_error_o.too_much_data          <= '0';
			rmap_write_error_o.verify_buffer_overrun  <= '0';
			rmap_write_error_o.invalid_data_crc       <= '0';
			-- status flags
			rmap_write_flags_o.write_data_indication  <= '0';
			rmap_write_flags_o.write_operation_failed <= '0';
			-- busy flag
			rmap_write_busy_o                         <= '0';

			-- signals init

			-- variables init
			-- rmap_write_data_var
			rmap_write_data_var.writedata               := x"00";
			rmap_write_data_var.address                 := 0;
			-- rmap_write_error_var
			rmap_write_error_var.early_eop              := '0';
			rmap_write_error_var.eep                    := '0';
			rmap_write_error_var.too_much_data          := '0';
			rmap_write_error_var.verify_buffer_overrun  := '0';
			rmap_write_error_var.invalid_data_crc       := '0';
			-- rmap_write_flags_var
			rmap_write_flags_var.write_data_indication  := '0';
			rmap_write_flags_var.write_operation_failed := '0';
			-- non-record variables
			rmap_write_state_machine_var                := standby_state;
			rmap_write_state_machine_next_state_var     := standby_state;
			rmap_write_crc_var                          := x"00";
			rmap_write_byte_field_counter_var           := 0;
			rmap_write_verify_buffer                    := (others => x"00");

		elsif (rising_edge(clk_i)) then

			-- signals atribution to avoid latches and paths were no value is given to a signal
			-- spw codec comunication (data receive)
			spw_read_o         <= spw_read_o;
			spw_codec_error_o  <= spw_codec_error_o;
			-- memory communication (write)
			mem_write_data_o   <= mem_write_data_o;
			-- error flags
			rmap_write_error_o <= rmap_write_error_o;
			-- status flags
			rmap_write_flags_o <= rmap_write_flags_o;
			-- busy flag
			rmap_write_busy_o  <= rmap_write_busy_o;

			-- variables atribution checks to avoid a path where no value is given to a variable

			case (rmap_write_state_machine_var) is

				when standby_state =>
					-- does nothing until user application signals a write authorization
					-- reset internal information
					-- rmap_write_data_var
					rmap_write_data_var.writedata               := x"00";
					rmap_write_data_var.address                 := 0;
					-- rmap_write_error_var
					rmap_write_error_var.early_eop              := '0';
					rmap_write_error_var.eep                    := '0';
					rmap_write_error_var.too_much_data          := '0';
					rmap_write_error_var.verify_buffer_overrun  := '0';
					rmap_write_error_var.invalid_data_crc       := '0';
					-- rmap_write_flags_var
					rmap_write_flags_var.write_data_indication  := '0';
					rmap_write_flags_var.write_operation_failed := '0';
					-- non-record variables
					rmap_write_crc_var                          := x"00";
					rmap_write_byte_field_counter_var           := 0;
					-- keep output as is
					rmap_write_busy_o                           <= '0';
					-- check if user application authorized a write
					if (rmap_write_control_i.write_authorization = '1') then
						-- write authorized
						-- update data address
						rmap_write_data_var.address             := rmap_write_headerdata_i.full_address;
						-- prepare byte field counter for multi-field header data
						rmap_write_byte_field_counter_var       := rmap_write_headerdata_i.data_length - 1;
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
					-- check if an unexpected eop or eep arrived
					if (spw_flag_i = '1') then
						-- unexpected eop or eep, go to treatment state
						rmap_write_state_machine_var := unexpected_package_end_state;
					else
						-- expected data field
						-- check if the incoming data crc matches the calculated one
						if (spw_data_i /= rmap_write_crc_var) then
							-- data crc does not match, invalid data crc error; flag the error
							rmap_write_error_var.invalid_data_crc := '1';
						end if;
						-- next expected field is an eop
						-- prepare for next field arrival
						rmap_write_state_machine_next_state_var := field_eop_state;
						rmap_write_state_machine_var            := waiting_data_state;
					end if;

				when field_eop_state =>
					-- check if an eop or eep arrived
					if (spw_flag_i = '1') then
						if (spw_data_i = SPW_EOP_CONST) then
							-- eop arrived as expected
							-- check if the data need to be verified before written
							if (rmap_write_headerdata_i.instruction_verify_data_before_write = '1') then
								-- data need to be verified and data crc checked out
								-- data can be written in memory
								-- prepare the data counter; go to verified data write state
								rmap_write_byte_field_counter_var := rmap_write_headerdata_i.data_length - 1;
								rmap_write_state_machine_var      := write_verified_data_state;
							else
								-- data does not need to be verified
								-- data already written to memory, finish of the write operation
								rmap_write_state_machine_next_state_var := standby_state;
								rmap_write_state_machine_var            := write_finish_operation_state;
							end if;
						elsif (spw_data_i = SPW_EEP_CONST) then
							-- unexpected eep; flag the error
							rmap_write_error_var.eep                := '1';
							-- finish the write operation
							rmap_write_state_machine_next_state_var := standby_state;
							rmap_write_state_machine_var            := write_finish_operation_state;
						else
							-- spacewire codec error (impossible value)
							-- flag the error; indicate that the spw data was used; clear busy flag; go to standby
							spw_codec_error_o            <= '1';
							rmap_write_busy_o            <= '0';
							rmap_write_state_machine_var := standby_state;
						end if;
					else
						-- too much data; flag the error
						rmap_write_error_var.too_much_data      := '1';
						-- finish the write operation and go wait for a package end
						rmap_write_state_machine_next_state_var := waiting_package_end_state;
						rmap_write_state_machine_var            := write_finish_operation_state;
					end if;
					-- indicate that the spw data was used
					spw_read_o                   <= '1';
					rmap_write_state_machine_var := standby_state;

				when write_verified_data_state =>
					-- check if the data crc is valid
					if (rmap_write_error_var.invalid_data_crc = '0') then
						-- data crc checked out
						-- transfer content from verify buffer to memory
						mem_write_data_o.address          <= rmap_write_data_var.address;
						mem_write_data_o.writedata        <= rmap_write_verify_buffer(rmap_write_byte_field_counter_var);
						-- update data counter;
						rmap_write_byte_field_counter_var := rmap_write_byte_field_counter_var - 1;
						if (rmap_write_headerdata_i.instruction_increment_address = '1') then
							-- increment address
							rmap_write_data_var.address := rmap_write_data_var.address + 1;
							-- TODO: verificar se o endereço precisa ser modificado antes ou depois. se for depois, pode ser que estoure o endereço e o último espaço não possa ser acessado. Se for antes, precisa ter ajuste na passagem do parametro inicial.
						end if;
						-- check if all the verify buffer data was transfered to memory
						if (rmap_write_byte_field_counter_var = 0) then
							-- finished transfering data to memory; finish the write operation
							rmap_write_state_machine_next_state_var := standby_state;
							rmap_write_state_machine_var            := write_finish_operation_state;
						else
							-- more data in the verify buffer; keep the state
							rmap_write_state_machine_var := write_verified_data_state;
						end if;
					else
						-- finish the write operation without writing to memory
						rmap_write_state_machine_next_state_var := standby_state;
						rmap_write_state_machine_var            := write_finish_operation_state;
					end if;

				when write_unverified_data_state =>
					-- write data in correct address
					mem_write_data_o.address     <= rmap_write_data_var.address;
					mem_write_data_o.writedata   <= rmap_write_data_var.writedata;
					-- check if address need to be incremented
					if (rmap_write_headerdata_i.instruction_increment_address = '1') then
						-- increment address
						rmap_write_data_var.address := rmap_write_data_var.address + 1;
					end if;
					-- go to next state
					rmap_write_state_machine_var := rmap_write_state_machine_next_state_var;

				when write_finish_operation_state =>
					-- update output information
					rmap_write_error_o           <= rmap_write_error_var;
					rmap_write_flags_o           <= rmap_write_flags_var;
					-- go to next state
					rmap_write_state_machine_var := rmap_write_state_machine_next_state_var;

				when unexpected_package_end_state =>
					-- verify if the unexpected package end is an eop or an eep
					-- not necessary to check the flag because it was already checked in the previous state
					if (spw_data_i = SPW_EOP_CONST) then
						-- incomplete header error; flag the error
						rmap_write_error_var.early_eop          := '1';
						-- finish the write operation
						rmap_write_state_machine_next_state_var := standby_state;
						rmap_write_state_machine_var            := write_finish_operation_state;
					elsif (spw_data_i = SPW_EEP_CONST) then
						-- error end of package; flag the error
						rmap_write_error_var.eep                := '1';
						-- finish the write operation
						rmap_write_state_machine_next_state_var := standby_state;
						rmap_write_state_machine_var            := write_finish_operation_state;
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
