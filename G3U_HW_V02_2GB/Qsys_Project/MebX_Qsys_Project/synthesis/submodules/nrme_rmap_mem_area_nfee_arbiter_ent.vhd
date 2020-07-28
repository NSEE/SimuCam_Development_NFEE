library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.nrme_rmap_mem_area_nfee_pkg.all;
use work.nrme_avalon_mm_rmap_nfee_pkg.all;

entity nrme_rmap_mem_area_nfee_arbiter_ent is
	port(
		clk_i                 : in  std_logic;
		rst_i                 : in  std_logic;
		fee_0_wr_rmap_i       : in  t_nrme_nfee_rmap_write_in;
		fee_0_rd_rmap_i       : in  t_nrme_nfee_rmap_read_in;
		fee_1_wr_rmap_i       : in  t_nrme_nfee_rmap_write_in;
		fee_1_rd_rmap_i       : in  t_nrme_nfee_rmap_read_in;
		avalon_0_mm_wr_rmap_i : in  t_nrme_avalon_mm_rmap_nfee_write_in;
		avalon_0_mm_rd_rmap_i : in  t_nrme_avalon_mm_rmap_nfee_read_in;
		fee_wr_rmap_cfg_hk_i  : in  t_nrme_nfee_rmap_write_out;
		fee_rd_rmap_cfg_hk_i  : in  t_nrme_nfee_rmap_read_out;
		fee_wr_rmap_win_i     : in  t_nrme_nfee_rmap_write_out;
		fee_rd_rmap_win_i     : in  t_nrme_nfee_rmap_read_out;
		avalon_mm_wr_rmap_i   : in  t_nrme_avalon_mm_rmap_nfee_write_out;
		avalon_mm_rd_rmap_i   : in  t_nrme_avalon_mm_rmap_nfee_read_out;
		fee_0_wr_rmap_o       : out t_nrme_nfee_rmap_write_out;
		fee_0_rd_rmap_o       : out t_nrme_nfee_rmap_read_out;
		fee_1_wr_rmap_o       : out t_nrme_nfee_rmap_write_out;
		fee_1_rd_rmap_o       : out t_nrme_nfee_rmap_read_out;
		avalon_0_mm_wr_rmap_o : out t_nrme_avalon_mm_rmap_nfee_write_out;
		avalon_0_mm_rd_rmap_o : out t_nrme_avalon_mm_rmap_nfee_read_out;
		fee_wr_rmap_cfg_hk_o  : out t_nrme_nfee_rmap_write_in;
		fee_rd_rmap_cfg_hk_o  : out t_nrme_nfee_rmap_read_in;
		fee_wr_rmap_win_o     : out t_nrme_nfee_rmap_write_in;
		fee_rd_rmap_win_o     : out t_nrme_nfee_rmap_read_in;
		avalon_mm_wr_rmap_o   : out t_nrme_avalon_mm_rmap_nfee_write_in;
		avalon_mm_rd_rmap_o   : out t_nrme_avalon_mm_rmap_nfee_read_in
	);
end entity nrme_rmap_mem_area_nfee_arbiter_ent;

architecture RTL of nrme_rmap_mem_area_nfee_arbiter_ent is

	signal s_fee_rmap_waitrequest       : std_logic;
	signal s_avalon_mm_rmap_waitrequest : std_logic;
	signal s_rmap_waitrequest           : std_logic;

	type t_master_list is (
		master_none,
		master_wr_fee_0,
		master_wr_fee_1,
		master_wr_avs_0,
		master_rd_fee_0,
		master_rd_fee_1,
		master_rd_avs_0
	);
	signal s_selected_master : t_master_list;

	subtype t_master_queue_index is natural range 0 to 6;
	type t_master_queue is array (0 to t_master_queue_index'high) of t_master_list;
	signal s_master_queue : t_master_queue;

	signal s_master_wr_fee_0_queued : std_logic;
	signal s_master_wr_fee_1_queued : std_logic;
	signal s_master_wr_avs_0_queued : std_logic;
	signal s_master_rd_fee_0_queued : std_logic;
	signal s_master_rd_fee_1_queued : std_logic;
	signal s_master_rd_avs_0_queued : std_logic;

	signal s_fee_0_wr_win_address_flag : std_logic;
	signal s_fee_1_wr_win_address_flag : std_logic;
	signal s_fee_0_rd_win_address_flag : std_logic;
	signal s_fee_1_rd_win_address_flag : std_logic;

begin

	p_nrme_rmap_mem_area_nfee_arbiter : process(clk_i, rst_i) is
		variable v_master_queue_index : t_master_queue_index := 0;

	begin
		if (rst_i = '1') then
			s_selected_master        <= master_none;
			s_master_queue           <= (others => master_none);
			s_master_wr_fee_0_queued <= '0';
			s_master_wr_fee_1_queued <= '0';
			s_master_wr_avs_0_queued <= '0';
			s_master_rd_fee_0_queued <= '0';
			s_master_rd_fee_1_queued <= '0';
			s_master_rd_avs_0_queued <= '0';
			v_master_queue_index     := 0;
		elsif (rising_edge(clk_i)) then

			-- check if master fee 0 requested a write and is not queued
			if ((fee_0_wr_rmap_i.write = '1') and (s_master_wr_fee_0_queued = '0')) then
				-- master fee 0 requested a write and is not queued
				-- put master fee 0 write in the queue
				s_master_queue(v_master_queue_index) <= master_wr_fee_0;
				s_master_wr_fee_0_queued             <= '1';
				-- update master queue index
				if (v_master_queue_index < t_master_queue_index'high) then
					v_master_queue_index := v_master_queue_index + 1;
				end if;
			end if;

			-- check if master fee 1 requested a write and is not queued
			if ((fee_1_wr_rmap_i.write = '1') and (s_master_wr_fee_1_queued = '0')) then
				-- master fee 1 requested a write and is not queued
				-- put master fee 1 write in the queue
				s_master_queue(v_master_queue_index) <= master_wr_fee_1;
				s_master_wr_fee_1_queued             <= '1';
				-- update master queue index
				if (v_master_queue_index < t_master_queue_index'high) then
					v_master_queue_index := v_master_queue_index + 1;
				end if;
			end if;

			-- check if master avs 0 requested a write and is not queued
			if ((avalon_0_mm_wr_rmap_i.write = '1') and (s_master_wr_avs_0_queued = '0')) then
				-- master avs 0 requested a write and is not queued
				-- put master avs 0 write in the queue
				s_master_queue(v_master_queue_index) <= master_wr_avs_0;
				s_master_wr_avs_0_queued             <= '1';
				-- update master queue index
				if (v_master_queue_index < t_master_queue_index'high) then
					v_master_queue_index := v_master_queue_index + 1;
				end if;
			end if;

			-- check if master fee 0 requested a read and is not queued
			if ((fee_0_rd_rmap_i.read = '1') and (s_master_rd_fee_0_queued = '0')) then
				-- master fee 0 requested a read and is not queued
				-- put master fee read 0 in the queue
				s_master_queue(v_master_queue_index) <= master_rd_fee_0;
				s_master_rd_fee_0_queued             <= '1';
				-- update master queue index
				if (v_master_queue_index < t_master_queue_index'high) then
					v_master_queue_index := v_master_queue_index + 1;
				end if;
			end if;

			-- check if master fee 1 requested a read and is not queued
			if ((fee_1_rd_rmap_i.read = '1') and (s_master_rd_fee_1_queued = '0')) then
				-- master fee 1 requested a read and is not queued
				-- put master fee read 1 in the queue
				s_master_queue(v_master_queue_index) <= master_rd_fee_1;
				s_master_rd_fee_1_queued             <= '1';
				-- update master queue index
				if (v_master_queue_index < t_master_queue_index'high) then
					v_master_queue_index := v_master_queue_index + 1;
				end if;
			end if;

			-- check if master avs 0 requested a read and is not queued
			if ((avalon_0_mm_rd_rmap_i.read = '1') and (s_master_rd_avs_0_queued = '0')) then
				-- master avs 0 requested a read and is not queued
				-- put master avs read 0 in the queue
				s_master_queue(v_master_queue_index) <= master_rd_avs_0;
				s_master_rd_avs_0_queued             <= '1';
				-- update master queue index
				if (v_master_queue_index < t_master_queue_index'high) then
					v_master_queue_index := v_master_queue_index + 1;
				end if;
			end if;

			-- master queue management
			-- case to handle the master queue
			case (s_master_queue(0)) is

				when master_none =>
					-- no master waiting at the queue
					s_selected_master <= master_none;

				when master_wr_fee_0 =>
					-- master fee 0 write at top of the queue
					s_selected_master <= master_wr_fee_0;
					-- check if the master is finished
					if (fee_0_wr_rmap_i.write = '0') then
						-- master is finished
						-- set master selection to none
						s_selected_master                         <= master_none;
						-- remove master from the queue
						for index in 0 to (t_master_queue_index'high - 1) loop
							s_master_queue(index) <= s_master_queue(index + 1);
						end loop;
						s_master_queue(t_master_queue_index'high) <= master_none;
						s_master_wr_fee_0_queued                  <= '0';
						-- update master queue index
						if (v_master_queue_index > t_master_queue_index'low) then
							v_master_queue_index := v_master_queue_index - 1;
						end if;
					end if;

				when master_wr_fee_1 =>
					-- master fee 1 write at top of the queue
					s_selected_master <= master_wr_fee_1;
					-- check if the master is finished
					if (fee_1_wr_rmap_i.write = '0') then
						-- master is finished
						-- set master selection to none
						s_selected_master                         <= master_none;
						-- remove master from the queue
						for index in 0 to (t_master_queue_index'high - 1) loop
							s_master_queue(index) <= s_master_queue(index + 1);
						end loop;
						s_master_queue(t_master_queue_index'high) <= master_none;
						s_master_wr_fee_1_queued                  <= '0';
						-- update master queue index
						if (v_master_queue_index > t_master_queue_index'low) then
							v_master_queue_index := v_master_queue_index - 1;
						end if;
					end if;

				when master_wr_avs_0 =>
					-- master avs 0 write at top of the queue
					s_selected_master <= master_wr_avs_0;
					-- check if the master is finished
					if (avalon_0_mm_wr_rmap_i.write = '0') then
						-- master is finished
						-- set master selection to none
						s_selected_master                         <= master_none;
						-- remove master from the queue
						for index in 0 to (t_master_queue_index'high - 1) loop
							s_master_queue(index) <= s_master_queue(index + 1);
						end loop;
						s_master_queue(t_master_queue_index'high) <= master_none;
						s_master_wr_avs_0_queued                  <= '0';
						-- update master queue index
						if (v_master_queue_index > t_master_queue_index'low) then
							v_master_queue_index := v_master_queue_index - 1;
						end if;
					end if;

				when master_rd_fee_0 =>
					-- master fee 0 read at top of the queue
					s_selected_master <= master_rd_fee_0;
					-- check if the master is finished
					if (fee_0_rd_rmap_i.read = '0') then
						-- master is finished
						-- set master selection to none
						s_selected_master                         <= master_none;
						-- remove master from the queue
						for index in 0 to (t_master_queue_index'high - 1) loop
							s_master_queue(index) <= s_master_queue(index + 1);
						end loop;
						s_master_queue(t_master_queue_index'high) <= master_none;
						s_master_rd_fee_0_queued                  <= '0';
						-- update master queue index
						if (v_master_queue_index > t_master_queue_index'low) then
							v_master_queue_index := v_master_queue_index - 1;
						end if;
					end if;

				when master_rd_fee_1 =>
					-- master fee 1 read at top of the queue
					s_selected_master <= master_rd_fee_1;
					-- check if the master is finished
					if (fee_1_rd_rmap_i.read = '0') then
						-- master is finished
						-- set master selection to none
						s_selected_master                         <= master_none;
						-- remove master from the queue
						for index in 0 to (t_master_queue_index'high - 1) loop
							s_master_queue(index) <= s_master_queue(index + 1);
						end loop;
						s_master_queue(t_master_queue_index'high) <= master_none;
						s_master_rd_fee_1_queued                  <= '0';
						-- update master queue index
						if (v_master_queue_index > t_master_queue_index'low) then
							v_master_queue_index := v_master_queue_index - 1;
						end if;
					end if;

				when master_rd_avs_0 =>
					-- master avs 0 read at top of the queue
					s_selected_master <= master_rd_avs_0;
					-- check if the master is finished
					if (avalon_0_mm_rd_rmap_i.read = '0') then
						-- master is finished
						-- set master selection to none
						s_selected_master                         <= master_none;
						-- remove master from the queue
						for index in 0 to (t_master_queue_index'high - 1) loop
							s_master_queue(index) <= s_master_queue(index + 1);
						end loop;
						s_master_queue(t_master_queue_index'high) <= master_none;
						s_master_rd_avs_0_queued                  <= '0';
						-- update master queue index
						if (v_master_queue_index > t_master_queue_index'low) then
							v_master_queue_index := v_master_queue_index - 1;
						end if;
					end if;

			end case;

		end if;
	end process p_nrme_rmap_mem_area_nfee_arbiter;

	-- Signals assignments --

	-- Waitrequest
	s_fee_rmap_waitrequest       <= (fee_wr_rmap_cfg_hk_i.waitrequest) and (fee_rd_rmap_cfg_hk_i.waitrequest);
	s_avalon_mm_rmap_waitrequest <= (avalon_mm_wr_rmap_i.waitrequest) and (avalon_mm_rd_rmap_i.waitrequest);
	s_rmap_waitrequest           <= (s_fee_rmap_waitrequest) and (s_avalon_mm_rmap_waitrequest);

	-- Windowing Area Address Flags
	s_fee_0_wr_win_address_flag <= ('0') when (rst_i = '1')
	                               else ('1') when ((fee_0_wr_rmap_i.address(c_NRME_NFEE_RMAP_WIN_OFFSET_BIT) = '1') and (fee_0_wr_rmap_i.address(31 downto (c_NRME_NFEE_RMAP_WIN_OFFSET_BIT + 1)) = x"00"))
	                               else ('0');
	s_fee_1_wr_win_address_flag <= ('0') when (rst_i = '1')
	                               else ('1') when ((fee_1_wr_rmap_i.address(c_NRME_NFEE_RMAP_WIN_OFFSET_BIT) = '1') and (fee_1_wr_rmap_i.address(31 downto (c_NRME_NFEE_RMAP_WIN_OFFSET_BIT + 1)) = x"00"))
	                               else ('0');
	s_fee_0_rd_win_address_flag <= ('0') when (rst_i = '1')
	                               else ('1') when ((fee_0_rd_rmap_i.address(c_NRME_NFEE_RMAP_WIN_OFFSET_BIT) = '1') and (fee_0_rd_rmap_i.address(31 downto (c_NRME_NFEE_RMAP_WIN_OFFSET_BIT + 1)) = x"00"))
	                               else ('0');
	s_fee_1_rd_win_address_flag <= ('0') when (rst_i = '1')
	                               else ('1') when ((fee_1_rd_rmap_i.address(c_NRME_NFEE_RMAP_WIN_OFFSET_BIT) = '1') and (fee_1_rd_rmap_i.address(31 downto (c_NRME_NFEE_RMAP_WIN_OFFSET_BIT + 1)) = x"00"))
	                               else ('0');

	-- Masters Write inputs
	fee_wr_rmap_cfg_hk_o <= (c_NRME_NFEE_RMAP_WRITE_IN_RST) when (rst_i = '1')
	                        else (fee_0_wr_rmap_i) when ((s_selected_master = master_wr_fee_0) and (s_fee_0_wr_win_address_flag = '0'))
	                        else (fee_1_wr_rmap_i) when ((s_selected_master = master_wr_fee_1) and (s_fee_1_wr_win_address_flag = '0'))
	                        else (c_NRME_NFEE_RMAP_WRITE_IN_RST);
	fee_wr_rmap_win_o    <= (c_NRME_NFEE_RMAP_WRITE_IN_RST) when (rst_i = '1')
	                        else (fee_0_wr_rmap_i) when ((s_selected_master = master_wr_fee_0) and (s_fee_0_wr_win_address_flag = '1'))
	                        else (fee_1_wr_rmap_i) when ((s_selected_master = master_wr_fee_1) and (s_fee_1_wr_win_address_flag = '1'))
	                        else (c_NRME_NFEE_RMAP_WRITE_IN_RST);
	avalon_mm_wr_rmap_o  <= (c_NRME_AVALON_MM_RMAP_NFEE_WRITE_IN_RST) when (rst_i = '1')
	                        else (avalon_0_mm_wr_rmap_i) when (s_selected_master = master_wr_avs_0)
	                        else (c_NRME_AVALON_MM_RMAP_NFEE_WRITE_IN_RST);

	-- Masters Write outputs
	fee_0_wr_rmap_o       <= (c_NRME_NFEE_RMAP_WRITE_OUT_RST) when (rst_i = '1')
	                         else (fee_wr_rmap_cfg_hk_i) when ((s_selected_master = master_wr_fee_0) and (s_fee_0_wr_win_address_flag = '0'))
	                         else (fee_wr_rmap_win_i) when ((s_selected_master = master_wr_fee_0) and (s_fee_0_wr_win_address_flag = '1'))
	                         else (c_NRME_NFEE_RMAP_WRITE_OUT_RST);
	fee_1_wr_rmap_o       <= (c_NRME_NFEE_RMAP_WRITE_OUT_RST) when (rst_i = '1')
	                         else (fee_wr_rmap_cfg_hk_i) when ((s_selected_master = master_wr_fee_1) and (s_fee_1_wr_win_address_flag = '0'))
	                         else (fee_wr_rmap_win_i) when ((s_selected_master = master_wr_fee_1) and (s_fee_1_wr_win_address_flag = '1'))
	                         else (c_NRME_NFEE_RMAP_WRITE_OUT_RST);
	avalon_0_mm_wr_rmap_o <= (c_NRME_AVALON_MM_RMAP_NFEE_WRITE_OUT_RST) when (rst_i = '1')
	                         else (avalon_mm_wr_rmap_i) when (s_selected_master = master_wr_avs_0)
	                         else (c_NRME_AVALON_MM_RMAP_NFEE_WRITE_OUT_RST);

	-- Masters Read inputs
	fee_rd_rmap_cfg_hk_o <= (c_NRME_NFEE_RMAP_READ_IN_RST) when (rst_i = '1')
	                        else (fee_0_rd_rmap_i) when ((s_selected_master = master_rd_fee_0) and (s_fee_0_rd_win_address_flag = '0'))
	                        else (fee_1_rd_rmap_i) when ((s_selected_master = master_rd_fee_1) and (s_fee_1_rd_win_address_flag = '0'))
	                        else (c_NRME_NFEE_RMAP_READ_IN_RST);
	fee_rd_rmap_win_o    <= (c_NRME_NFEE_RMAP_READ_IN_RST) when (rst_i = '1')
	                        else (fee_0_rd_rmap_i) when ((s_selected_master = master_rd_fee_0) and (s_fee_0_rd_win_address_flag = '1'))
	                        else (fee_1_rd_rmap_i) when ((s_selected_master = master_rd_fee_1) and (s_fee_1_rd_win_address_flag = '1'))
	                        else (c_NRME_NFEE_RMAP_READ_IN_RST);
	avalon_mm_rd_rmap_o  <= (c_NRME_AVALON_MM_RMAP_NFEE_READ_IN_RST) when (rst_i = '1')
	                        else (avalon_0_mm_rd_rmap_i) when (s_selected_master = master_rd_avs_0)
	                        else (c_NRME_AVALON_MM_RMAP_NFEE_READ_IN_RST);

	-- Masters Read outputs
	fee_0_rd_rmap_o       <= (c_NRME_NFEE_RMAP_READ_OUT_RST) when (rst_i = '1')
	                         else (fee_rd_rmap_cfg_hk_i) when ((s_selected_master = master_rd_fee_0) and (s_fee_0_rd_win_address_flag = '0'))
	                         else (fee_rd_rmap_win_i) when ((s_selected_master = master_rd_fee_0) and (s_fee_0_rd_win_address_flag = '1'))
	                         else (c_NRME_NFEE_RMAP_READ_OUT_RST);
	fee_1_rd_rmap_o       <= (c_NRME_NFEE_RMAP_READ_OUT_RST) when (rst_i = '1')
	                         else (fee_rd_rmap_cfg_hk_i) when ((s_selected_master = master_rd_fee_1) and (s_fee_1_rd_win_address_flag = '0'))
	                         else (fee_rd_rmap_win_i) when ((s_selected_master = master_rd_fee_1) and (s_fee_1_rd_win_address_flag = '1'))
	                         else (c_NRME_NFEE_RMAP_READ_OUT_RST);
	avalon_0_mm_rd_rmap_o <= (c_NRME_AVALON_MM_RMAP_NFEE_READ_OUT_RST) when (rst_i = '1')
	                         else (avalon_mm_rd_rmap_i) when (s_selected_master = master_rd_avs_0)
	                         else (c_NRME_AVALON_MM_RMAP_NFEE_READ_OUT_RST);

end architecture RTL;
