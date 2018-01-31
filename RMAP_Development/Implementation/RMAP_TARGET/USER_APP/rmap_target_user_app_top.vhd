library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.rmap_target_user_app_pkg.all;

entity rmap_target_user_app_top is
	port(
		clk_i : in std_logic;
		rst_i : in std_logic
	);
end entity rmap_target_user_app_top;

architecture RTL of rmap_target_user_app_top is

	type rmap_user_app_state_machine_type is (
		standby_state,
		waiting_state,
		treatment_discarded_package,
		treatment_write_request,
		treatment_write_authorized,
		treatment_read_request,
		treatment_read_authorized
	);

	constant RMAP_USER_REGISTER : rmap_target_user_app_register_type := (
		target_logical_address => x"FE",
		key                    => x"00"
	);

	signal rmap_user_headerdata_sig   : rmap_target_user_app_headerdata_type;
	signal rmap_user_codecbusy_sig    : rmap_target_user_app_codecbusy_type;
	signal rmap_user_codecflags_sig   : rmap_target_user_app_codecflags_type;
	signal rmap_user_codecerror_sig   : rmap_target_user_app_codecerror_type;
	signal rmap_user_codeccontrol_sig : rmap_target_user_app_codeccontrol_type;

begin

	rmap_target_codec_top_inst : entity work.rmap_target_codec_top
		port map(
			clk_i              => clk_i,
			rst_i              => rst_i,
			codec_headerdata_o => rmap_user_headerdata_sig
		);

	rmap_target_userp_app_proc : process(clk_i, rst_i) is
		variable rmap_user_internal_flags_var    : rmap_target_user_app_internal_flags_type;
		variable rmap_user_app_state_machine_var : rmap_user_app_state_machine_type := standby_state;

	begin
		if (rst_i = '1') then
		-- reset procedures
		-- TODO: reset procedures

		-- ports init                        
		-- TODO: ports init

		-- signals init                      
		-- TODO: signals init

		-- variables init                    
		-- TODO: variables init

		elsif (rising_edge(clk_i)) then

			case (rmap_user_app_state_machine_var) is

				when standby_state =>
					-- TODO: standby state
					if (rmap_user_codecflags_sig.discarded_package = '1') then
						rmap_user_app_state_machine_var := treatment_discarded_package;
					end if;
					if (rmap_user_codecflags_sig.write_request = '1') then
						rmap_user_app_state_machine_var := treatment_write_request;
					end if;
					if (rmap_user_codecflags_sig.read_request = '1') then
						rmap_user_app_state_machine_var := treatment_read_request;
					end if;

				when waiting_state =>
					-- TODO: waiting state

				when treatment_discarded_package =>
					-- TODO: package discarded reply and error retrieval
					-- discarded package
					-- retrieve error information
					-- send error reply
					-- clear codec state 
					null;

				when treatment_write_request =>
					-- TODO: write operation
					-- write operation authorization request
					if (rmap_user_headerdata_sig.key /= RMAP_USER_REGISTER.key) then
						-- invalid key
						-- discard package
						rmap_user_codeccontrol_sig.discard_package  <= '1';
						-- reply invalid key error					
						rmap_user_codeccontrol_sig.reply_error_code <= ERROR_CODE_INVALID_KEY;
						rmap_user_codeccontrol_sig.send_write_reply <= '1';
					elsif (rmap_user_headerdata_sig.target_logical_address /= RMAP_USER_REGISTER.target_logical_address) then
						-- invalid logical address
						-- discard package
						rmap_user_codeccontrol_sig.discard_package  <= '1';
						-- reply invalid logical address error
						rmap_user_codeccontrol_sig.reply_error_code <= ERROR_CODE_INVALID_TARGET_LOGICAL_ADDRESS;
						rmap_user_codeccontrol_sig.send_write_reply <= '1';
					elsif (0) then
						-- command rejection
						-- discard package
						rmap_user_codeccontrol_sig.discard_package  <= '1';
						-- reply rmap command not implemented or not authorised error
						rmap_user_codeccontrol_sig.reply_error_code <= ERROR_CODE_RMAP_COMMAND_NOT_IMPLEMENTED_OR_NOT_AUTHORISED;
						rmap_user_codeccontrol_sig.send_write_reply <= '1';
					else
						-- write operation authorization
						rmap_user_codeccontrol_sig.write_authorization <= '1';
						rmap_user_app_state_machine_var                := treatment_write_authorized;
					end if;

				when treatment_write_authorized =>
					if (rmap_user_codecflags_sig.write_operation_failed = '1') then
						-- write data error
						-- retrieve error information
						if (rmap_user_codecerror_sig.verify_buffer_overrun = '1') then
							--verify_buffer_overrun
							rmap_user_codeccontrol_sig.reply_error_code <= ERROR_CODE_VERIFY_BUFFER_OVERRUN;
						elsif (rmap_user_codecerror_sig.invalid_data_crc = '1') then
							--invalid_data_crc
							rmap_user_codeccontrol_sig.reply_error_code <= ERROR_CODE_INVALID_DATA_CRC;
						elsif (rmap_user_codecerror_sig.early_eop = '1') then
							--early_eop
							--insufficient_data
							rmap_user_codeccontrol_sig.reply_error_code <= ERROR_CODE_EARLY_EOP;
						elsif (rmap_user_codecerror_sig.too_much_data = '1') then
							--too_much_data
							rmap_user_codeccontrol_sig.reply_error_code <= ERROR_CODE_TOO_MUCH_DATA;
						elsif (rmap_user_codecerror_sig.eep = '1') then
							--eep
							rmap_user_codeccontrol_sig.reply_error_code <= ERROR_CODE_EEP;
						else
							-- unspecified error, reply with general error code
							rmap_user_codeccontrol_sig.reply_error_code <= ERROR_CODE_GENERAL_ERROR_CODE;
						end if;
						-- send error reply
						rmap_user_codeccontrol_sig.send_write_reply          <= '1';
						-- clear codec state						
						rmap_user_codeccontrol_sig.ready_for_another_package <= '1';
					elsif (rmap_user_codecflags_sig.write_data_indication = '1') then
						-- write data indication
						-- write command complete confirmation
						rmap_user_codeccontrol_sig.reply_error_code          <= ERROR_CODE_GENERAL_ERROR_CODE;
						-- write reply
						rmap_user_codeccontrol_sig.send_write_reply          <= '1';
						-- clear codec state
						rmap_user_codeccontrol_sig.ready_for_another_package <= '1';
					else
						-- keep waiting for the codec response to the write authorization
						rmap_user_app_state_machine_var := treatment_write_authorized;
					end if;

				when treatment_read_request =>
					-- TODO: read operation
					-- read operation authorization request
					--	-- invalid key
					--	-- invalid logical address
					--	-- command rejection
					-- read operation authorization
					--	-- read data error
					--		-- retrieve error information
					--		-- send error reply
					--		-- clear codec state
					--	-- read data indication
					--		-- read reply
					--		-- read command complete confirmation
					--		-- clear codec state	
					null;

				when treatment_read_authorized =>
					null;

			end case;

		end if;
	end process rmap_target_userp_app_proc;

end architecture RTL;
