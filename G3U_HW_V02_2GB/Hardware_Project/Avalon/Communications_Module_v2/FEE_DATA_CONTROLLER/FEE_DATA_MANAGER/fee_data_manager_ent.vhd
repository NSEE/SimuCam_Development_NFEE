library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.fee_data_controller_pkg.all;

entity fee_data_manager_ent is
	port(
		clk_i                                    : in  std_logic;
		rst_i                                    : in  std_logic;
		-- fee data manager inputs --
		-- general inputs
		fee_clear_signal_i                       : in  std_logic;
		fee_stop_signal_i                        : in  std_logic;
		fee_start_signal_i                       : in  std_logic;
		fee_manager_sync_i                       : in  std_logic;
		fee_manager_hk_only_i                    : in  std_logic;
		fee_left_buffer_activated_i              : in  std_logic;
		fee_right_buffer_activated_i             : in  std_logic;
		-- fee housekeeping data manager status
		hkdataman_manager_i                      : in  t_fee_dpkt_general_status;
		-- fee left_image data manager status			
		left_imgdataman_manager_i                : in  t_fee_dpkt_general_status;
		-- fee right image data manager status
		right_imgdataman_manager_i               : in  t_fee_dpkt_general_status;
		-- data transmitter status
		data_transmitter_finished_i              : in  std_logic;
		-- hkdata send buffer status
		hkdata_send_double_buffer_empty_i        : in  std_logic;
		-- left imgdata send buffer status
		left_imgdata_send_double_buffer_empty_i  : in  std_logic;
		-- right imgdata send buffer status
		right_imgdata_send_double_buffer_empty_i : in  std_logic;
		-- fee data manager outputs --
		-- general outputs
		-- fee data manager status			
		fee_data_manager_busy_o                  : out std_logic;
		-- fee housekeeping data manager control		
		hkdataman_manager_o                      : out t_fee_dpkt_general_control;
		-- left fee image data manager control
		left_imgdataman_manager_o                : out t_fee_dpkt_general_control;
		-- right fee image data manager control
		right_imgdataman_manager_o               : out t_fee_dpkt_general_control
		-- data transmitter control
	);
end entity fee_data_manager_ent;

architecture RTL of fee_data_manager_ent is

	-- fee data manager fsm type
	type t_fee_data_manager_fsm is (
		STOPPED,
		IDLE,
		HKDATA_CONTROLLER_START,
		WAITING_HKDATA_CONTROLLER_FINISH,
		IMGDATA_CONTROLLER_START,
		WAITING_IMGDATA_CONTROLLER_FINISH,
		WAITING_DATA_TRANSMITTER_FINISH,
		WAITING_SEND_DOUBLE_BUFFER_EMPTY,
		FINISH_FEE_OPERATION
	);

	-- fee data manager fsm state signal
	signal s_fee_data_manager_state : t_fee_data_manager_fsm;

begin

	p_fee_data_manager : process(clk_i, rst_i) is
	begin
		if (rst_i = '1') then
			-- signals
			s_fee_data_manager_state         <= STOPPED;
			-- outputs
			fee_data_manager_busy_o          <= '0';
			hkdataman_manager_o.start        <= '0';
			hkdataman_manager_o.reset        <= '1';
			left_imgdataman_manager_o.start  <= '0';
			left_imgdataman_manager_o.reset  <= '1';
			right_imgdataman_manager_o.start <= '0';
			right_imgdataman_manager_o.reset <= '1';
		elsif rising_edge(clk_i) then

			-- standart signal/outputs values
			fee_data_manager_busy_o          <= '0';
			hkdataman_manager_o.start        <= '0';
			hkdataman_manager_o.reset        <= '0';
			left_imgdataman_manager_o.start  <= '0';
			left_imgdataman_manager_o.reset  <= '0';
			right_imgdataman_manager_o.start <= '0';
			right_imgdataman_manager_o.reset <= '0';

			case (s_fee_data_manager_state) is

				when STOPPED =>
					-- stopped state. do nothing and reset fee data manager
					s_fee_data_manager_state <= STOPPED;
					-- check if a start was issued
					if (fee_start_signal_i = '1') then
						-- start issued, go to idle
						s_fee_data_manager_state <= IDLE;
					end if;

				when IDLE =>
					-- do nothing until a sync signal is received
					s_fee_data_manager_state <= IDLE;
					-- keep signals and outputs at the reset state
					if (fee_manager_sync_i = '1') then
						-- sync signal received
						-- go to housekeeping data controller start
						s_fee_data_manager_state <= HKDATA_CONTROLLER_START;
					end if;

				when HKDATA_CONTROLLER_START =>
					-- start the housekeeping data manager
					s_fee_data_manager_state  <= WAITING_HKDATA_CONTROLLER_FINISH;
					fee_data_manager_busy_o   <= '1';
					-- configure the housekeeping data manager
					-- start the housekeeping data manager
					hkdataman_manager_o.start <= '1';

				when WAITING_HKDATA_CONTROLLER_FINISH =>
					-- wait for the hk header generation to finish
					s_fee_data_manager_state <= WAITING_HKDATA_CONTROLLER_FINISH;
					fee_data_manager_busy_o  <= '1';
					-- check if the housekeeping data manager is finished
					if (hkdataman_manager_i.finished = '1') then
						-- housekeeping data manager finished
						-- reset the housekeeping data manager
						hkdataman_manager_o.reset <= '1';
						-- only packet, finish operation
						-- check if its only hk
						if (fee_manager_hk_only_i = '1') then
							-- only hk
							-- go to waiting data transmitter finish
							s_fee_data_manager_state <= WAITING_DATA_TRANSMITTER_FINISH;
						else
							-- not only hk, go to img data
							-- go to img header start
							s_fee_data_manager_state <= IMGDATA_CONTROLLER_START;
						end if;
					end if;

				when IMGDATA_CONTROLLER_START =>
					-- start the image data manager
					s_fee_data_manager_state <= WAITING_IMGDATA_CONTROLLER_FINISH;
					fee_data_manager_busy_o  <= '1';
					-- start the image data manager
					-- check if the left side is activated
					if (fee_left_buffer_activated_i = '1') then
						-- left side is activated, start left image data manager
						left_imgdataman_manager_o.start <= '1';
					end if;
					-- check if the right side is activated
					if (fee_right_buffer_activated_i = '1') then
						-- right side is activated, start right image data manager
						right_imgdataman_manager_o.start <= '1';
					end if;

				when WAITING_IMGDATA_CONTROLLER_FINISH =>
					-- wait for the data writer to finish
					s_fee_data_manager_state <= WAITING_IMGDATA_CONTROLLER_FINISH;
					fee_data_manager_busy_o  <= '1';
					-- check if both sides are activated
					if ((fee_left_buffer_activated_i = '1') and (fee_right_buffer_activated_i = '1')) then
						-- both sides are activated
						-- check if both image data managers is finished
						if ((left_imgdataman_manager_i.finished = '1') and (right_imgdataman_manager_i.finished = '1')) then
							-- both image data managers finished
							-- reset both image data managers
							left_imgdataman_manager_o.reset  <= '1';
							right_imgdataman_manager_o.reset <= '1';
							-- go to waiting data transmitter finish
							s_fee_data_manager_state         <= WAITING_DATA_TRANSMITTER_FINISH;
						end if;
					-- check if the left side is activated
					elsif (fee_left_buffer_activated_i = '1') then
						-- left side is activated
						-- check if the left image data manager is finished
						if (left_imgdataman_manager_i.finished = '1') then
							-- left image data manager finished
							-- reset the left image data manager
							left_imgdataman_manager_o.reset <= '1';
							-- go to waiting data transmitter finish
							s_fee_data_manager_state        <= WAITING_DATA_TRANSMITTER_FINISH;
						end if;
					-- check if the right side is activated
					elsif (fee_right_buffer_activated_i = '1') then
						-- right side is activated
						-- check if the right image data manager is finished
						if (right_imgdataman_manager_i.finished = '1') then
							-- right image data manager finished
							-- reset the right image data manager
							right_imgdataman_manager_o.reset <= '1';
							-- go to waiting data transmitter finish
							s_fee_data_manager_state         <= WAITING_DATA_TRANSMITTER_FINISH;
						end if;
					end if;

				when WAITING_DATA_TRANSMITTER_FINISH =>
					-- wait for the data transmitter to finish
					s_fee_data_manager_state <= WAITING_DATA_TRANSMITTER_FINISH;
					fee_data_manager_busy_o  <= '1';
					-- check if the data transmitter is finished
					if (data_transmitter_finished_i = '1') then
						-- go to waiting send double buffer empty
						s_fee_data_manager_state <= WAITING_SEND_DOUBLE_BUFFER_EMPTY;
					end if;

				when WAITING_SEND_DOUBLE_BUFFER_EMPTY =>
					-- wait the send double buffer to become empty (ensure the transmission of all the data)
					s_fee_data_manager_state <= WAITING_SEND_DOUBLE_BUFFER_EMPTY;
					fee_data_manager_busy_o  <= '1';
					-- check if the double buffer is completely empty (all data transmitted)
					if ((hkdata_send_double_buffer_empty_i = '1') and (left_imgdata_send_double_buffer_empty_i = '1') and (right_imgdata_send_double_buffer_empty_i = '1')) then
						-- go to finish fee operation
						s_fee_data_manager_state <= FINISH_FEE_OPERATION;
					end if;

				when FINISH_FEE_OPERATION =>
					-- finish the fee operation
					-- return to idle to wait another sync
					s_fee_data_manager_state <= IDLE;

			end case;

			-- check if a stop was issued
			if (fee_stop_signal_i = '1') then
				-- stop issued, go to stopped
				s_fee_data_manager_state <= STOPPED;
			end if;

		end if;
	end process p_fee_data_manager;

end architecture RTL;
