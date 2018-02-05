library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.rmap_target_codec_pkg.all;
use work.rmap_target_codec_crc_pkg.all;

entity rmap_target_codec_read_ent is
	port(
		clk_i                  : in  std_logic;
		rst_i                  : in  std_logic;
		-- spw codec comunication (data transmission)
		spw_ready_i            : in  std_logic;
		spw_flag_o             : out std_logic;
		spw_data_o             : out std_logic_vector(7 downto 0);
		spw_write_o            : out std_logic;
		-- memory communication (read)
		mem_read_data_i        : in  rmap_target_codec_read_mem_data_type;
		mem_read_control_o     : out rmap_target_codec_read_mem_control_type;
		-- header data
		rmap_read_headerdata_i : in  rmap_target_codec_read_headerdata_type;
		-- status flags
		rmap_read_flags_o      : out rmap_target_codec_read_flags_type;
		-- control flags
		rmap_read_control_i    : in  rmap_target_codec_read_control_type;
		-- busy flag
		rmap_read_busy_o       : out std_logic
	);
end entity rmap_target_codec_read_ent;

architecture RTL of rmap_target_codec_read_ent is

	type rmap_read_state_machine_type is (
		standby_state,
		waiting_buffer_space_state,
		field_data_state,
		field_data_crc_state,
		field_eop_state,
		read_data_state,
		read_finish_operation_state,
		read_not_ok_state
	);

	constant SPW_EOP_CONST : std_logic := '0';
	constant SPW_EEP_CONST : std_logic := '1';

begin

	rmap_target_codec_read_proc : process(clk_i, rst_i) is
		variable rmap_read_mem_control_var              : rmap_target_codec_read_mem_control_type;
		variable rmap_read_flags_var                    : rmap_target_codec_read_flags_type;
		variable rmap_read_state_machine_var            : rmap_read_state_machine_type := standby_state;
		variable rmap_read_state_machine_next_state_var : rmap_read_state_machine_type := standby_state;
		variable rmap_read_crc_var                      : std_logic_vector(7 downto 0) := (others => '0');
		variable rmap_read_byte_field_counter_var       : rmap_target_codec_write_data_length_type;

	begin
		if (rst_i = '1') then
			-- reset procedures

			-- ports init
			-- spw codec comunication (data transmission)
			spw_flag_o                              <= '0';
			spw_data_o                              <= x"00";
			spw_write_o                             <= '0';
			-- memory communication (read)
			mem_read_control_o.address              <= 0;
			-- status flags
			rmap_read_flags_o.read_data_indication  <= '0';
			rmap_read_flags_o.read_operation_failed <= '0';
			-- busy flag
			rmap_read_busy_o                        <= '0';

			-- signals init

			-- variables init
			-- rmap_read_mem_control_var
			rmap_read_mem_control_var.address         := 0;
			-- rmap_read_flags_var
			rmap_read_flags_var.read_data_indication  := '0';
			rmap_read_flags_var.read_operation_failed := '0';
			-- non-record variables
			rmap_read_state_machine_var               := standby_state;
			rmap_read_state_machine_next_state_var    := standby_state;
			rmap_read_crc_var                         := x"00";
			rmap_read_byte_field_counter_var          := 0;

		elsif (rising_edge(clk_i)) then

			-- signals atribution to avoid latches and paths were no value is given to a signal
			-- spw codec comunication (data transmission)
			spw_flag_o         <= spw_flag_o;
			spw_data_o         <= spw_data_o;
			spw_write_o        <= spw_write_o;
			-- memory communication (read)             
			mem_read_control_o <= mem_read_control_o;
			-- status flags                            
			rmap_read_flags_o  <= rmap_read_flags_o;
			-- busy flag                               
			rmap_read_busy_o   <= rmap_read_busy_o;

			-- variables atribution checks to avoid a path where no value is given to a variable

			case (rmap_read_state_machine_var) is

				when standby_state =>
					-- does nothing until user application signals a read authorization
					-- reset internal information
					-- rmap_read_mem_control_var
					rmap_read_mem_control_var.address         := 0;
					-- rmap_read_flags_var
					rmap_read_flags_var.read_data_indication  := '0';
					rmap_read_flags_var.read_operation_failed := '0';
					-- non-record variables
					rmap_read_crc_var                         := x"00";
					rmap_read_byte_field_counter_var          := 0;
					-- keep output as is
					rmap_read_busy_o                          <= '0';
					-- check if user application authorized a write
					if (rmap_write_control_i.write_authorization = '1') then
						-- read authorized
						-- update data address
						rmap_read_mem_control_var.address      := rmap_read_headerdata_i.full_address;
						-- prepare byte field counter for multi-field header data
						rmap_read_byte_field_counter_var       := rmap_read_headerdata_i.data_length - 1;
						-- set busy flag; go to waiting buffer space
						rmap_read_busy_o                       <= '1';
						rmap_read_state_machine_var            := waiting_buffer_space_state;
						rmap_read_state_machine_next_state_var := field_data_state;
					else
						-- read not authorized; stay in standby
						rmap_read_state_machine_var := standby_state;
					end if;

				when waiting_buffer_space_state =>
					spw_write_o <= '0';
					if (spw_ready_i = '1') then
						rmap_read_state_machine_var := rmap_read_state_machine_next_state_var;
					else
						rmap_read_state_machine_var := waiting_buffer_space_state;
					end if;

				when field_data_state =>
					-- check if a read error ocurred
					if (mem_read_data_i.read_error = '1') then
						-- read error occured
						-- flag the error; go to read not ok state
						rmap_read_flags_var.read_operation_failed := '1';
						rmap_reply_state_machine_var              := read_not_ok_state;
					else
						-- read was successful
						-- clear spw flag (to indicate a data)
						spw_flag_o                       <= '0';
						-- fill spw data with field data
						spw_data_o                       <= mem_read_data_i.readdata;
						-- update crc calculation
						rmap_read_crc_var                := RMAP_CalculateCRC(rmap_read_crc_var, mem_read_data_i.readdata);
						-- update byte field counter
						rmap_read_byte_field_counter_var := rmap_read_byte_field_counter_var - 1;
						-- write the spw data; prepare for next field
						spw_write_o                      <= '1';
						rmap_reply_state_machine_var     := waiting_buffer_space_state;
						-- check if all data has been read
						if (rmap_read_byte_field_counter_var = 0) then
							-- all data read; go to next field
							rmap_reply_state_machine_next_state_var := field_data_crc_state;
						else
							-- there are still more data to be read
							rmap_reply_state_machine_next_state_var := field_data_state;
						end if;
					end if;

				when field_data_crc_state =>
					-- clear spw flag (to indicate a data)
					spw_flag_o                              <= '0';
					-- fill spw data with the reply header crc
					spw_data_o                              <= rmap_read_crc_var;
					-- write the spw data; prepare for next field
					spw_write_o                             <= '1';
					-- prepare for next field
					rmap_reply_state_machine_var            := waiting_buffer_space_state;
					rmap_reply_state_machine_next_state_var := field_eop_state;

				when field_eop_state =>
					-- set spw flag (to indicate a package end)
					spw_flag_o                               <= '1';
					-- fill spw data with the eop identifier (0x00)
					spw_data_o(7 downto 1)                   <= (others => '0');
					spw_data_o(0)                            <= SPW_EOP_CONST;
					-- write the spw data; indicate the end of the read operation
					spw_write_o                              <= '1';
					rmap_read_flags_var.read_data_indication := '1';
					-- finish the read operation
					rmap_read_state_machine_next_state_var   := standby_state;
					rmap_reply_state_machine_var             := read_finish_operation_state;

				when read_data_state =>
					-- fetch memory data
					-- set memory address
					mem_read_control_o.address <= rmap_read_mem_control_var.address;
					-- check if address need to be incremented
					if (rmap_read_headerdata_i.instruction_increment_address = '1') then
						-- increment address
						rmap_read_mem_control_var.address := rmap_read_mem_control_var.address + 1;
						-- TODO: verificar se o endereço precisa ser modificado antes ou depois. se for depois, pode ser que estoure o endereço e o último espaço não possa ser acessado. Se for antes, precisa ter ajuste na passagem do parametro inicial.
					end if;

				when read_finish_operation_state =>
					-- update output information
					rmap_read_flags_o           <= rmap_read_flags_var;
					-- go to next state
					rmap_read_state_machine_var := rmap_read_state_machine_next_state_var;

				when read_not_ok_state =>
					-- an error ocurred during the data read
					-- finish the read reply package with an EEP
					-- set spw flag (to indicate a package end)
					spw_flag_o                             <= '1';
					-- fill spw data with the eop identifier (0x01)
					spw_data_o(7 downto 1)                 <= (others => '0');
					spw_data_o(0)                          <= SPW_EEP_CONST;
					-- write the spw data
					spw_write_o                            <= '1';
					-- finish the read operation
					rmap_read_state_machine_next_state_var := standby_state;
					rmap_reply_state_machine_var           := read_finish_operation_state;

			end case;

		end if;
	end process rmap_target_codec_read_proc;

end architecture RTL;
