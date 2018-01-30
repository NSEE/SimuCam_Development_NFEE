library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.rmap_target_userp_app_pkg.all;

entity rmap_target_userp_app_top is
	port(
		clk_i : in std_logic;
		rst_i : in std_logic
	);
end entity rmap_target_userp_app_top;

architecture RTL of rmap_target_userp_app_top is

	type rmap_user_app_state_machine_type is (
		standby_state,
		waiting_state,
		treatment_discarded_package,
		treatment_write_request,
		treatment_read_request
	);

	constant RMAP_USER_REGISTER : rmap_target_user_app_register_type := (
		target_logical_address => x"FE",
		key                    => x"00"
	);

	signal rmap_user_headerdata_sig : rmap_target_user_app_headerdata_type;

begin

	rmap_target_codec_top_inst : entity work.rmap_target_codec_top
		port map(
			clk_i              => clk_i,
			rst_i              => rst_i,
			codec_headerdata_o => rmap_user_headerdata_sig
		);

	rmap_target_userp_app_proc : process(clk_i, rst_i) is
		variable rmap_user_app_state_machine_var : rmap_user_app_state_machine_type := standby_state;
	begin
		if (rst_i = '1') then
		-- reset procedures

		-- ports init

		-- signals init

		-- variables init

		elsif (rising_edge(clk_i)) then

			case rmap_user_app_state_machine_var is

				when standby_state =>
					-- TODO: standby state
					null;

				when waiting_state =>
					-- TODO: waiting state
					null;

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
					-- invalid key
					-- invalid logical address
					-- command rejection
					-- write operation authorization
					-- write data error
					-- retrieve error information
					-- send error reply
					-- clear codec state
					-- write data indication
					-- write reply
					-- write command complete confirmation
					-- clear codec state
					null;

				when treatment_read_request =>
					-- TODO: read operation
					-- read operation authorization request
					-- invalid key
					-- invalid logical address
					-- command rejection
					-- read operation authorization
					-- read data error
					-- retrieve error information
					-- send error reply
					-- clear codec state
					-- read data indication
					-- read reply
					-- read command complete confirmation
					-- clear codec state	
					null;

			end case;

		end if;
	end process rmap_target_userp_app_proc;

end architecture RTL;
