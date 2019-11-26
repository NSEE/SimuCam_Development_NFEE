library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.windowing_fifo_pkg.all;
use work.windowing_dataset_pkg.all;

entity windowing_buffer_ent is
	port(
		clk_i                   : in  std_logic;
		rst_i                   : in  std_logic;
		fee_clear_signal_i      : in  std_logic;
		fee_stop_signal_i       : in  std_logic;
		fee_start_signal_i      : in  std_logic;
		fee_sync_signal_i       : in  std_logic;
		window_double_buffer_i  : in  t_windowing_double_buffer;
		window_data_read_i      : in  std_logic;
		window_mask_read_i      : in  std_logic;
		window_buffer_control_o : out t_windowing_buffer_control;
		window_data_o           : out std_logic_vector(63 downto 0);
		window_mask_o           : out std_logic_vector(63 downto 0);
		window_data_ready_o     : out std_logic;
		window_mask_ready_o     : out std_logic;
		window_buffer_empty_o   : out std_logic;
		window_buffer_0_empty_o : out std_logic;
		window_buffer_1_empty_o : out std_logic
	);
end entity windowing_buffer_ent;

architecture RTL of windowing_buffer_ent is

	signal s_windowing_large_avsbuff_sc_double_fifo : t_windowing_large_avsbuff_sc_double_fifo;
	signal s_windowing_small_avsbuff_sc_double_fifo : t_windowing_small_avsbuff_sc_double_fifo;

	signal s_windowing_large_avsbuff_qword_double_data : t_windowing_avsbuff_qword_double_data;
	signal s_windowing_small_avsbuff_qword_double_data : t_windowing_avsbuff_qword_double_data;

	-- windowing data fifo signals
	signal s_windowing_data_fifo_control : t_windowing_fifo_control;
	signal s_windowing_data_fifo_wr_data : t_windowing_fifo_wr_data;
	signal s_windowing_data_fifo_status  : t_windowing_data_fifo_status;
	signal s_windowing_data_fifo_rd_data : t_windowing_fifo_rd_data;

	-- windowing mask fifo signals
	signal s_windowing_mask_fifo_control : t_windowing_fifo_control;
	signal s_windowing_mask_fifo_wr_data : t_windowing_fifo_wr_data;
	signal s_windowing_mask_fifo_status  : t_windowing_mask_fifo_status;
	signal s_windowing_mask_fifo_rd_data : t_windowing_fifo_rd_data;

	-- stopped flag signal
	signal s_stopped_flag : std_logic;

	-- windowing dataset double buffer
	signal s_dataset_double_buffer : t_windowing_dataset_double_buffer;

	signal s_selected_read_dbuffer : natural range 0 to 1;

	signal s_dbuffer_0_empty : std_logic;
	signal s_dbuffer_1_empty : std_logic;

	signal s_dbuffer_0_readable : std_logic;
	signal s_dbuffer_1_readable : std_logic;

	type t_dbuffer_write_fsm is (
		STOPPED,
		DBUFFER_0,
		DBUFFER_1
	);
	signal s_dbuffer_write_state : t_dbuffer_write_fsm;

	type t_dbuffer_read_fsm is (
		STOPPED,
		WAITING_SYNC,
		IDLE,
		DATA_WRITE,
		DATA_DELAY,
		MASK_WRITE,
		MASK_DELAY,
		DBUFFER_CHANGE
	);
	signal s_dbuffer_read_state : t_dbuffer_read_fsm;

	signal s_dbuffer_data_cnt   : natural range 0 to 15;
	signal s_dbuffer_buffer_cnt : natural range 0 to 15;
	signal s_dbuffer_qword_cnt  : natural range 0 to 3;
	signal s_dbuffer_addr_cnt   : natural range 0 to 271;

begin

	windowing_large_avsbuff_sc_fifo_0_inst : entity work.windowing_large_avsbuff_sc_fifo
		port map(
			aclr  => rst_i,
			clock => clk_i,
			data  => window_double_buffer_i(0).large_wrdata,
			rdreq => s_windowing_large_avsbuff_sc_double_fifo(0).rdreq,
			sclr  => window_double_buffer_i(0).sclr,
			wrreq => window_double_buffer_i(0).large_wrreq,
			empty => s_windowing_large_avsbuff_sc_double_fifo(0).empty,
			full  => s_windowing_large_avsbuff_sc_double_fifo(0).full,
			q     => s_windowing_large_avsbuff_sc_double_fifo(0).rddata,
			usedw => s_windowing_large_avsbuff_sc_double_fifo(0).usedw
		);

	windowing_small_avsbuff_sc_fifo_0_inst : entity work.windowing_small_avsbuff_sc_fifo
		port map(
			aclr  => rst_i,
			clock => clk_i,
			data  => window_double_buffer_i(0).small_wrdata,
			rdreq => s_windowing_small_avsbuff_sc_double_fifo(0).rdreq,
			sclr  => window_double_buffer_i(0).sclr,
			wrreq => window_double_buffer_i(0).small_wrreq,
			empty => s_windowing_small_avsbuff_sc_double_fifo(0).empty,
			full  => s_windowing_small_avsbuff_sc_double_fifo(0).full,
			q     => s_windowing_small_avsbuff_sc_double_fifo(0).rddata,
			usedw => s_windowing_small_avsbuff_sc_double_fifo(0).usedw
		);

	windowing_large_avsbuff_sc_fifo_1_inst : entity work.windowing_large_avsbuff_sc_fifo
		port map(
			aclr  => rst_i,
			clock => clk_i,
			data  => window_double_buffer_i(1).large_wrdata,
			rdreq => s_windowing_large_avsbuff_sc_double_fifo(1).rdreq,
			sclr  => window_double_buffer_i(1).sclr,
			wrreq => window_double_buffer_i(1).large_wrreq,
			empty => s_windowing_large_avsbuff_sc_double_fifo(1).empty,
			full  => s_windowing_large_avsbuff_sc_double_fifo(1).full,
			q     => s_windowing_large_avsbuff_sc_double_fifo(1).rddata,
			usedw => s_windowing_large_avsbuff_sc_double_fifo(1).usedw
		);

	windowing_small_avsbuff_sc_fifo_1_inst : entity work.windowing_small_avsbuff_sc_fifo
		port map(
			aclr  => rst_i,
			clock => clk_i,
			data  => window_double_buffer_i(1).small_wrdata,
			rdreq => s_windowing_small_avsbuff_sc_double_fifo(1).rdreq,
			sclr  => window_double_buffer_i(1).sclr,
			wrreq => window_double_buffer_i(1).small_wrreq,
			empty => s_windowing_small_avsbuff_sc_double_fifo(1).empty,
			full  => s_windowing_small_avsbuff_sc_double_fifo(1).full,
			q     => s_windowing_small_avsbuff_sc_double_fifo(1).rddata,
			usedw => s_windowing_small_avsbuff_sc_double_fifo(1).usedw
		);

	-- windowing data fifo instantiation
	windowing_data_fifo_ent_inst : entity work.windowing_data_fifo_ent
		port map(
			clk_i          => clk_i,
			rst_i          => rst_i,
			fifo_control_i => s_windowing_data_fifo_control,
			fifo_wr_data   => s_windowing_data_fifo_wr_data,
			fifo_status_o  => s_windowing_data_fifo_status,
			fifo_rd_data   => s_windowing_data_fifo_rd_data
		);

	-- windowing mask fifo instantiation
	windowing_mask_fifo_ent_inst : entity work.windowing_mask_fifo_ent
		port map(
			clk_i          => clk_i,
			rst_i          => rst_i,
			fifo_control_i => s_windowing_mask_fifo_control,
			fifo_wr_data   => s_windowing_mask_fifo_wr_data,
			fifo_status_o  => s_windowing_mask_fifo_status,
			fifo_rd_data   => s_windowing_mask_fifo_rd_data
		);

	p_windowing_buffer : process(clk_i, rst_i) is
	begin
		if (rst_i = '1') then
			window_buffer_control_o.locked                    <= '0';
			window_buffer_control_o.selected                  <= 0;
			window_data_o                                     <= (others => '0');
			window_mask_o                                     <= (others => '0');
			s_windowing_large_avsbuff_sc_double_fifo(0).rdreq <= '0';
			s_windowing_large_avsbuff_sc_double_fifo(1).rdreq <= '0';
			s_windowing_small_avsbuff_sc_double_fifo(0).rdreq <= '0';
			s_windowing_small_avsbuff_sc_double_fifo(1).rdreq <= '0';
			s_windowing_data_fifo_control.read.rdreq          <= '0';
			s_windowing_data_fifo_control.read.sclr           <= '1';
			s_windowing_data_fifo_control.write.wrreq         <= '0';
			s_windowing_data_fifo_control.write.sclr          <= '1';
			s_windowing_data_fifo_wr_data.data                <= (others => '0');
			s_windowing_mask_fifo_control.read.rdreq          <= '0';
			s_windowing_mask_fifo_control.read.sclr           <= '1';
			s_windowing_mask_fifo_control.write.wrreq         <= '0';
			s_windowing_mask_fifo_control.write.sclr          <= '1';
			s_windowing_mask_fifo_wr_data.data                <= (others => '0');
			s_stopped_flag                                    <= '1';
			s_selected_read_dbuffer                           <= 0;
			s_dbuffer_0_empty                                 <= '1';
			s_dbuffer_1_empty                                 <= '1';
			s_dbuffer_0_readable                              <= '0';
			s_dbuffer_1_readable                              <= '0';
			s_dbuffer_write_state                             <= STOPPED;
			s_dbuffer_read_state                              <= STOPPED;
			s_dbuffer_data_cnt                                <= 0;
			s_dbuffer_buffer_cnt                              <= 0;
			s_dbuffer_qword_cnt                               <= 0;
			s_dbuffer_addr_cnt                                <= 0;
		elsif rising_edge(clk_i) then

			-- data buffer write
			case (s_dbuffer_write_state) is

				when STOPPED =>
					s_dbuffer_write_state            <= STOPPED;
					s_dbuffer_0_empty                <= '1';
					s_dbuffer_1_empty                <= '1';
					s_dbuffer_0_readable             <= '0';
					s_dbuffer_1_readable             <= '0';
					window_buffer_control_o.selected <= 0;
					window_buffer_control_o.locked   <= '1';
					if (fee_start_signal_i = '1') then
						s_dbuffer_write_state <= DBUFFER_0;
					end if;

				when DBUFFER_0 =>
					s_dbuffer_write_state            <= DBUFFER_0;
					window_buffer_control_o.selected <= 0;
					if (s_dbuffer_0_empty = '1') then
						window_buffer_control_o.locked <= '0';
					end if;
					if (window_double_buffer_i(0).full = '1') then
						window_buffer_control_o.locked   <= '1';
						s_dbuffer_0_readable             <= '1';
						s_dbuffer_0_empty                <= '0';
						s_dbuffer_write_state            <= DBUFFER_1;
						window_buffer_control_o.selected <= 1;
						if (s_dbuffer_1_empty = '1') then
							window_buffer_control_o.locked <= '0';
						end if;
					end if;

				when DBUFFER_1 =>
					s_dbuffer_write_state            <= DBUFFER_1;
					window_buffer_control_o.selected <= 1;
					if (s_dbuffer_1_empty = '1') then
						window_buffer_control_o.locked <= '0';
					end if;
					if (window_double_buffer_i(1).full = '1') then
						window_buffer_control_o.locked   <= '1';
						s_dbuffer_1_readable             <= '1';
						s_dbuffer_1_empty                <= '0';
						s_dbuffer_write_state            <= DBUFFER_0;
						window_buffer_control_o.selected <= 0;
						if (s_dbuffer_0_empty = '1') then
							window_buffer_control_o.locked <= '0';
						end if;
					end if;

			end case;

			-- data buffer read
			case (s_dbuffer_read_state) is

				when STOPPED =>
					s_dbuffer_read_state                              <= STOPPED;
					s_windowing_large_avsbuff_sc_double_fifo(0).rdreq <= '0';
					s_windowing_large_avsbuff_sc_double_fifo(1).rdreq <= '0';
					s_windowing_small_avsbuff_sc_double_fifo(0).rdreq <= '0';
					s_windowing_small_avsbuff_sc_double_fifo(1).rdreq <= '0';
					s_windowing_data_fifo_control.write.wrreq         <= '0';
					s_windowing_data_fifo_control.write.sclr          <= '0';
					s_windowing_data_fifo_wr_data.data                <= (others => '0');
					s_windowing_mask_fifo_control.write.wrreq         <= '0';
					s_windowing_mask_fifo_control.write.sclr          <= '0';
					s_windowing_mask_fifo_wr_data.data                <= (others => '0');
					s_selected_read_dbuffer                           <= 0;
					s_dbuffer_data_cnt                                <= 0;
					s_dbuffer_buffer_cnt                              <= 0;
					s_dbuffer_qword_cnt                               <= 0;
					s_dbuffer_addr_cnt                                <= 0;
					if (fee_clear_signal_i = '1') then
						s_windowing_data_fifo_control.write.sclr <= '1';
						s_windowing_mask_fifo_control.write.sclr <= '1';
					elsif (fee_start_signal_i = '1') then
						s_dbuffer_read_state <= WAITING_SYNC;
					end if;

				when WAITING_SYNC =>
					s_dbuffer_read_state                              <= WAITING_SYNC;
					s_windowing_large_avsbuff_sc_double_fifo(0).rdreq <= '0';
					s_windowing_large_avsbuff_sc_double_fifo(1).rdreq <= '0';
					s_windowing_small_avsbuff_sc_double_fifo(0).rdreq <= '0';
					s_windowing_small_avsbuff_sc_double_fifo(1).rdreq <= '0';
					s_windowing_data_fifo_control.write.wrreq         <= '0';
					s_windowing_data_fifo_control.write.sclr          <= '0';
					s_windowing_data_fifo_wr_data.data                <= (others => '0');
					s_windowing_mask_fifo_control.write.wrreq         <= '0';
					s_windowing_mask_fifo_control.write.sclr          <= '0';
					s_windowing_mask_fifo_wr_data.data                <= (others => '0');
					s_selected_read_dbuffer                           <= 0;
					s_dbuffer_data_cnt                                <= 0;
					s_dbuffer_buffer_cnt                              <= 0;
					s_dbuffer_qword_cnt                               <= 0;
					s_dbuffer_addr_cnt                                <= 0;
					if (fee_sync_signal_i = '1') then
						s_dbuffer_read_state <= IDLE;
					end if;

				when IDLE =>
					s_dbuffer_read_state                              <= IDLE;
					s_dbuffer_data_cnt                                <= 0;
					s_dbuffer_buffer_cnt                              <= 0;
					s_dbuffer_qword_cnt                               <= 0;
					s_dbuffer_addr_cnt                                <= 0;
					s_windowing_large_avsbuff_sc_double_fifo(0).rdreq <= '0';
					s_windowing_large_avsbuff_sc_double_fifo(1).rdreq <= '0';
					s_windowing_small_avsbuff_sc_double_fifo(0).rdreq <= '0';
					s_windowing_small_avsbuff_sc_double_fifo(1).rdreq <= '0';
					s_windowing_data_fifo_control.write.wrreq         <= '0';
					s_windowing_data_fifo_wr_data.data                <= (others => '0');
					s_windowing_mask_fifo_control.write.wrreq         <= '0';
					s_windowing_mask_fifo_wr_data.data                <= (others => '0');
					if (s_selected_read_dbuffer = 0) then
						if (s_dbuffer_0_readable = '1') then
							s_dbuffer_read_state <= DATA_WRITE;
						end if;
					else
						if (s_dbuffer_1_readable = '1') then
							s_dbuffer_read_state <= DATA_WRITE;
						end if;
					end if;
					if (window_double_buffer_i(s_selected_read_dbuffer).full = '1') then
						s_dbuffer_read_state <= DATA_WRITE;
					end if;

				when DATA_WRITE =>
					s_dbuffer_read_state                              <= DATA_WRITE;
					s_windowing_large_avsbuff_sc_double_fifo(0).rdreq <= '0';
					s_windowing_large_avsbuff_sc_double_fifo(1).rdreq <= '0';
					s_windowing_small_avsbuff_sc_double_fifo(0).rdreq <= '0';
					s_windowing_small_avsbuff_sc_double_fifo(1).rdreq <= '0';
					s_windowing_data_fifo_control.write.wrreq         <= '0';
					s_windowing_data_fifo_wr_data.data                <= (others => '0');
					s_windowing_mask_fifo_control.write.wrreq         <= '0';
					s_windowing_mask_fifo_wr_data.data                <= (others => '0');
					if (s_windowing_data_fifo_status.write.full = '0') then
						s_dbuffer_read_state                      <= DATA_DELAY;
						s_windowing_data_fifo_control.write.wrreq <= '1';
						if (s_dbuffer_addr_cnt <= 255) then
							s_windowing_data_fifo_wr_data.data <= f_pixels_data_little_to_big_endian(s_windowing_large_avsbuff_qword_double_data(s_selected_read_dbuffer)(s_dbuffer_qword_cnt));
						else
							s_windowing_data_fifo_wr_data.data <= f_pixels_data_little_to_big_endian(s_windowing_small_avsbuff_qword_double_data(s_selected_read_dbuffer)(s_dbuffer_qword_cnt));
						end if;
						if (s_dbuffer_qword_cnt = 3) then
							s_dbuffer_qword_cnt <= 0;
							if (s_dbuffer_addr_cnt <= 255) then
								if (s_selected_read_dbuffer = 0) then
									s_windowing_large_avsbuff_sc_double_fifo(0).rdreq <= '1';
								else
									s_windowing_large_avsbuff_sc_double_fifo(1).rdreq <= '1';
								end if;
							else
								if (s_selected_read_dbuffer = 0) then
									s_windowing_small_avsbuff_sc_double_fifo(0).rdreq <= '1';
								else
									s_windowing_small_avsbuff_sc_double_fifo(1).rdreq <= '1';
								end if;
							end if;
						else
							s_dbuffer_qword_cnt <= s_dbuffer_qword_cnt + 1;
						end if;
						if (s_dbuffer_addr_cnt = 271) then
							s_dbuffer_addr_cnt <= 0;
						else
							s_dbuffer_addr_cnt <= s_dbuffer_addr_cnt + 1;
						end if;
						if (s_dbuffer_data_cnt = 15) then
							s_dbuffer_data_cnt <= 0;
						else
							s_dbuffer_data_cnt <= s_dbuffer_data_cnt + 1;
						end if;
					end if;

				when DATA_DELAY =>
					s_dbuffer_read_state                              <= DATA_WRITE;
					s_windowing_large_avsbuff_sc_double_fifo(0).rdreq <= '0';
					s_windowing_large_avsbuff_sc_double_fifo(1).rdreq <= '0';
					s_windowing_small_avsbuff_sc_double_fifo(0).rdreq <= '0';
					s_windowing_small_avsbuff_sc_double_fifo(1).rdreq <= '0';
					s_windowing_data_fifo_control.write.wrreq         <= '0';
					s_windowing_data_fifo_wr_data.data                <= (others => '0');
					s_windowing_mask_fifo_control.write.wrreq         <= '0';
					s_windowing_mask_fifo_wr_data.data                <= (others => '0');
					if (s_dbuffer_data_cnt = 0) then
						s_dbuffer_read_state <= MASK_WRITE;
					end if;

				when MASK_WRITE =>
					s_dbuffer_read_state                              <= MASK_WRITE;
					s_windowing_large_avsbuff_sc_double_fifo(0).rdreq <= '0';
					s_windowing_large_avsbuff_sc_double_fifo(1).rdreq <= '0';
					s_windowing_small_avsbuff_sc_double_fifo(0).rdreq <= '0';
					s_windowing_small_avsbuff_sc_double_fifo(1).rdreq <= '0';
					s_windowing_data_fifo_control.write.wrreq         <= '0';
					s_windowing_data_fifo_wr_data.data                <= (others => '0');
					s_windowing_mask_fifo_control.write.wrreq         <= '0';
					s_windowing_mask_fifo_wr_data.data                <= (others => '0');
					if (s_windowing_mask_fifo_status.write.full = '0') then
						s_dbuffer_read_state                      <= MASK_DELAY;
						s_windowing_mask_fifo_control.write.wrreq <= '1';
						if (s_dbuffer_addr_cnt <= 255) then
							s_windowing_mask_fifo_wr_data.data <= f_mask_conv(s_windowing_large_avsbuff_qword_double_data(s_selected_read_dbuffer)(s_dbuffer_qword_cnt));
						else
							s_windowing_mask_fifo_wr_data.data <= f_mask_conv(s_windowing_small_avsbuff_qword_double_data(s_selected_read_dbuffer)(s_dbuffer_qword_cnt));
						end if;
						if (s_dbuffer_qword_cnt = 3) then
							s_dbuffer_qword_cnt <= 0;
							if (s_dbuffer_addr_cnt <= 255) then
								if (s_selected_read_dbuffer = 0) then
									s_windowing_large_avsbuff_sc_double_fifo(0).rdreq <= '1';
								else
									s_windowing_large_avsbuff_sc_double_fifo(1).rdreq <= '1';
								end if;
							else
								if (s_selected_read_dbuffer = 0) then
									s_windowing_small_avsbuff_sc_double_fifo(0).rdreq <= '1';
								else
									s_windowing_small_avsbuff_sc_double_fifo(1).rdreq <= '1';
								end if;
							end if;
						else
							s_dbuffer_qword_cnt <= s_dbuffer_qword_cnt + 1;
						end if;
						if (s_dbuffer_addr_cnt = 271) then
							s_dbuffer_addr_cnt <= 0;
						else
							s_dbuffer_addr_cnt <= s_dbuffer_addr_cnt + 1;
						end if;
						if (s_dbuffer_buffer_cnt = to_integer(unsigned(window_double_buffer_i(s_selected_read_dbuffer).size))) then
							s_dbuffer_buffer_cnt <= 0;
						else
							s_dbuffer_buffer_cnt <= s_dbuffer_buffer_cnt + 1;
						end if;
					end if;

				when MASK_DELAY =>
					s_dbuffer_read_state                              <= DATA_WRITE;
					s_windowing_large_avsbuff_sc_double_fifo(0).rdreq <= '0';
					s_windowing_large_avsbuff_sc_double_fifo(1).rdreq <= '0';
					s_windowing_small_avsbuff_sc_double_fifo(0).rdreq <= '0';
					s_windowing_small_avsbuff_sc_double_fifo(1).rdreq <= '0';
					s_windowing_data_fifo_control.write.wrreq         <= '0';
					s_windowing_data_fifo_wr_data.data                <= (others => '0');
					s_windowing_mask_fifo_control.write.wrreq         <= '0';
					s_windowing_mask_fifo_wr_data.data                <= (others => '0');
					if (s_dbuffer_buffer_cnt = 0) then
						s_dbuffer_read_state <= DBUFFER_CHANGE;
					end if;

				when DBUFFER_CHANGE =>
					s_dbuffer_read_state                              <= IDLE;
					s_windowing_large_avsbuff_sc_double_fifo(0).rdreq <= '0';
					s_windowing_large_avsbuff_sc_double_fifo(1).rdreq <= '0';
					s_windowing_small_avsbuff_sc_double_fifo(0).rdreq <= '0';
					s_windowing_small_avsbuff_sc_double_fifo(1).rdreq <= '0';
					s_dbuffer_data_cnt                                <= 0;
					s_dbuffer_buffer_cnt                              <= 0;
					s_dbuffer_qword_cnt                               <= 0;
					s_dbuffer_addr_cnt                                <= 0;
					s_windowing_data_fifo_control.write.wrreq         <= '0';
					s_windowing_data_fifo_wr_data.data                <= (others => '0');
					s_windowing_mask_fifo_control.write.wrreq         <= '0';
					s_windowing_mask_fifo_wr_data.data                <= (others => '0');
					if (s_selected_read_dbuffer = 1) then
						s_selected_read_dbuffer <= 0;
						s_dbuffer_1_empty       <= '1';
						s_dbuffer_1_readable    <= '0';
					else
						s_selected_read_dbuffer <= 1;
						s_dbuffer_0_empty       <= '1';
						s_dbuffer_0_readable    <= '0';
					end if;

			end case;

			-- check if the windowing buffer is stopped
			if (s_stopped_flag = '1') then
				-- windowing buffer stopped, do nothing
				-- clear signals
				window_data_o                            <= (others => '0');
				window_mask_o                            <= (others => '0');
				s_windowing_data_fifo_control.read.rdreq <= '0';
				s_windowing_data_fifo_control.read.sclr  <= '0';
				s_windowing_mask_fifo_control.read.rdreq <= '0';
				s_windowing_mask_fifo_control.read.sclr  <= '0';
				-- check if a clear request was received
				if (fee_clear_signal_i = '1') then
					-- clear request received
					-- clear buffer
					s_windowing_data_fifo_control.read.sclr <= '1';
					s_windowing_mask_fifo_control.read.sclr <= '1';
				end if;
				-- check if a start request was received
				if (fee_start_signal_i = '1') then
					-- start request received
					-- clear stopped flag
					s_stopped_flag <= '0';
				end if;
			else
				-- windowing buffer started, normal operation
				-- Windowing Buffer Read
				window_data_o                            <= (others => '0');
				window_mask_o                            <= (others => '0');
				s_windowing_data_fifo_control.read.rdreq <= '0';
				s_windowing_mask_fifo_control.read.rdreq <= '0';
				-- check if a buffer data read was requested
				if (window_data_read_i = '1') then
					-- read data from the data buffer 0
					s_windowing_data_fifo_control.read.rdreq <= '1';
					window_data_o                            <= s_windowing_data_fifo_rd_data.q;
				-- check if a buffer mask read was requested	
				elsif (window_mask_read_i = '1') then
					-- read data from the mask buffer 0
					s_windowing_mask_fifo_control.read.rdreq <= '1';
					window_mask_o                            <= s_windowing_mask_fifo_rd_data.q;
				end if;

			end if;

			-- check if a stop request was received
			if (fee_stop_signal_i = '1') then
				-- stop request received
				-- set stopped flag
				s_stopped_flag        <= '1';
				s_dbuffer_write_state <= STOPPED;
				s_dbuffer_read_state  <= STOPPED;
			end if;

		end if;
	end process p_windowing_buffer;

	-- signals assignments
	s_windowing_large_avsbuff_qword_double_data(0)(0) <= s_windowing_large_avsbuff_sc_double_fifo(0).rddata(((64 * 0) + 63) downto (64 * 0));
	s_windowing_large_avsbuff_qword_double_data(0)(1) <= s_windowing_large_avsbuff_sc_double_fifo(0).rddata(((64 * 1) + 63) downto (64 * 1));
	s_windowing_large_avsbuff_qword_double_data(0)(2) <= s_windowing_large_avsbuff_sc_double_fifo(0).rddata(((64 * 2) + 63) downto (64 * 2));
	s_windowing_large_avsbuff_qword_double_data(0)(3) <= s_windowing_large_avsbuff_sc_double_fifo(0).rddata(((64 * 3) + 63) downto (64 * 3));

	s_windowing_large_avsbuff_qword_double_data(1)(0) <= s_windowing_large_avsbuff_sc_double_fifo(1).rddata(((64 * 0) + 63) downto (64 * 0));
	s_windowing_large_avsbuff_qword_double_data(1)(1) <= s_windowing_large_avsbuff_sc_double_fifo(1).rddata(((64 * 1) + 63) downto (64 * 1));
	s_windowing_large_avsbuff_qword_double_data(1)(2) <= s_windowing_large_avsbuff_sc_double_fifo(1).rddata(((64 * 2) + 63) downto (64 * 2));
	s_windowing_large_avsbuff_qword_double_data(1)(3) <= s_windowing_large_avsbuff_sc_double_fifo(1).rddata(((64 * 3) + 63) downto (64 * 3));

	s_windowing_small_avsbuff_qword_double_data(0)(0) <= s_windowing_small_avsbuff_sc_double_fifo(0).rddata(((64 * 0) + 63) downto (64 * 0));
	s_windowing_small_avsbuff_qword_double_data(0)(1) <= s_windowing_small_avsbuff_sc_double_fifo(0).rddata(((64 * 1) + 63) downto (64 * 1));
	s_windowing_small_avsbuff_qword_double_data(0)(2) <= s_windowing_small_avsbuff_sc_double_fifo(0).rddata(((64 * 2) + 63) downto (64 * 2));
	s_windowing_small_avsbuff_qword_double_data(0)(3) <= s_windowing_small_avsbuff_sc_double_fifo(0).rddata(((64 * 3) + 63) downto (64 * 3));

	s_windowing_small_avsbuff_qword_double_data(1)(0) <= s_windowing_small_avsbuff_sc_double_fifo(1).rddata(((64 * 0) + 63) downto (64 * 0));
	s_windowing_small_avsbuff_qword_double_data(1)(1) <= s_windowing_small_avsbuff_sc_double_fifo(1).rddata(((64 * 1) + 63) downto (64 * 1));
	s_windowing_small_avsbuff_qword_double_data(1)(2) <= s_windowing_small_avsbuff_sc_double_fifo(1).rddata(((64 * 2) + 63) downto (64 * 2));
	s_windowing_small_avsbuff_qword_double_data(1)(3) <= s_windowing_small_avsbuff_sc_double_fifo(1).rddata(((64 * 3) + 63) downto (64 * 3));

	-- output signals generation:
	window_buffer_empty_o   <= (s_dbuffer_0_empty) or (s_dbuffer_1_empty);
	window_buffer_0_empty_o <= (s_dbuffer_0_empty);
	window_buffer_1_empty_o <= (s_dbuffer_1_empty);
	window_data_ready_o     <= not (s_windowing_data_fifo_status.read.empty);
	window_mask_ready_o     <= not (s_windowing_mask_fifo_status.read.empty);

	--	-- windowing dataset double buffer assingments
	--
	--	-- dataset double buffer 0
	--	-- dataset buffer 0
	--	s_dataset_double_buffer(0)(0).data(0)   <= window_double_buffer_i(0).dbuffer(0);
	--	s_dataset_double_buffer(0)(0).data(1)   <= window_double_buffer_i(0).dbuffer(1);
	--	s_dataset_double_buffer(0)(0).data(2)   <= window_double_buffer_i(0).dbuffer(2);
	--	s_dataset_double_buffer(0)(0).data(3)   <= window_double_buffer_i(0).dbuffer(3);
	--	s_dataset_double_buffer(0)(0).data(4)   <= window_double_buffer_i(0).dbuffer(4);
	--	s_dataset_double_buffer(0)(0).data(5)   <= window_double_buffer_i(0).dbuffer(5);
	--	s_dataset_double_buffer(0)(0).data(6)   <= window_double_buffer_i(0).dbuffer(6);
	--	s_dataset_double_buffer(0)(0).data(7)   <= window_double_buffer_i(0).dbuffer(7);
	--	s_dataset_double_buffer(0)(0).data(8)   <= window_double_buffer_i(0).dbuffer(8);
	--	s_dataset_double_buffer(0)(0).data(9)   <= window_double_buffer_i(0).dbuffer(9);
	--	s_dataset_double_buffer(0)(0).data(10)  <= window_double_buffer_i(0).dbuffer(10);
	--	s_dataset_double_buffer(0)(0).data(11)  <= window_double_buffer_i(0).dbuffer(11);
	--	s_dataset_double_buffer(0)(0).data(12)  <= window_double_buffer_i(0).dbuffer(12);
	--	s_dataset_double_buffer(0)(0).data(13)  <= window_double_buffer_i(0).dbuffer(13);
	--	s_dataset_double_buffer(0)(0).data(14)  <= window_double_buffer_i(0).dbuffer(14);
	--	s_dataset_double_buffer(0)(0).data(15)  <= window_double_buffer_i(0).dbuffer(15);
	--	s_dataset_double_buffer(0)(0).mask      <= window_double_buffer_i(0).dbuffer(16);
	--	-- dataset buffer 1
	--	s_dataset_double_buffer(0)(1).data(0)   <= window_double_buffer_i(0).dbuffer(17);
	--	s_dataset_double_buffer(0)(1).data(1)   <= window_double_buffer_i(0).dbuffer(18);
	--	s_dataset_double_buffer(0)(1).data(2)   <= window_double_buffer_i(0).dbuffer(19);
	--	s_dataset_double_buffer(0)(1).data(3)   <= window_double_buffer_i(0).dbuffer(20);
	--	s_dataset_double_buffer(0)(1).data(4)   <= window_double_buffer_i(0).dbuffer(21);
	--	s_dataset_double_buffer(0)(1).data(5)   <= window_double_buffer_i(0).dbuffer(22);
	--	s_dataset_double_buffer(0)(1).data(6)   <= window_double_buffer_i(0).dbuffer(23);
	--	s_dataset_double_buffer(0)(1).data(7)   <= window_double_buffer_i(0).dbuffer(24);
	--	s_dataset_double_buffer(0)(1).data(8)   <= window_double_buffer_i(0).dbuffer(25);
	--	s_dataset_double_buffer(0)(1).data(9)   <= window_double_buffer_i(0).dbuffer(26);
	--	s_dataset_double_buffer(0)(1).data(10)  <= window_double_buffer_i(0).dbuffer(27);
	--	s_dataset_double_buffer(0)(1).data(11)  <= window_double_buffer_i(0).dbuffer(28);
	--	s_dataset_double_buffer(0)(1).data(12)  <= window_double_buffer_i(0).dbuffer(29);
	--	s_dataset_double_buffer(0)(1).data(13)  <= window_double_buffer_i(0).dbuffer(30);
	--	s_dataset_double_buffer(0)(1).data(14)  <= window_double_buffer_i(0).dbuffer(31);
	--	s_dataset_double_buffer(0)(1).data(15)  <= window_double_buffer_i(0).dbuffer(32);
	--	s_dataset_double_buffer(0)(1).mask      <= window_double_buffer_i(0).dbuffer(33);
	--	-- dataset buffer 2
	--	s_dataset_double_buffer(0)(2).data(0)   <= window_double_buffer_i(0).dbuffer(34);
	--	s_dataset_double_buffer(0)(2).data(1)   <= window_double_buffer_i(0).dbuffer(35);
	--	s_dataset_double_buffer(0)(2).data(2)   <= window_double_buffer_i(0).dbuffer(36);
	--	s_dataset_double_buffer(0)(2).data(3)   <= window_double_buffer_i(0).dbuffer(37);
	--	s_dataset_double_buffer(0)(2).data(4)   <= window_double_buffer_i(0).dbuffer(38);
	--	s_dataset_double_buffer(0)(2).data(5)   <= window_double_buffer_i(0).dbuffer(39);
	--	s_dataset_double_buffer(0)(2).data(6)   <= window_double_buffer_i(0).dbuffer(40);
	--	s_dataset_double_buffer(0)(2).data(7)   <= window_double_buffer_i(0).dbuffer(41);
	--	s_dataset_double_buffer(0)(2).data(8)   <= window_double_buffer_i(0).dbuffer(42);
	--	s_dataset_double_buffer(0)(2).data(9)   <= window_double_buffer_i(0).dbuffer(43);
	--	s_dataset_double_buffer(0)(2).data(10)  <= window_double_buffer_i(0).dbuffer(44);
	--	s_dataset_double_buffer(0)(2).data(11)  <= window_double_buffer_i(0).dbuffer(45);
	--	s_dataset_double_buffer(0)(2).data(12)  <= window_double_buffer_i(0).dbuffer(46);
	--	s_dataset_double_buffer(0)(2).data(13)  <= window_double_buffer_i(0).dbuffer(47);
	--	s_dataset_double_buffer(0)(2).data(14)  <= window_double_buffer_i(0).dbuffer(48);
	--	s_dataset_double_buffer(0)(2).data(15)  <= window_double_buffer_i(0).dbuffer(49);
	--	s_dataset_double_buffer(0)(2).mask      <= window_double_buffer_i(0).dbuffer(50);
	--	-- dataset buffer 3
	--	s_dataset_double_buffer(0)(3).data(0)   <= window_double_buffer_i(0).dbuffer(51);
	--	s_dataset_double_buffer(0)(3).data(1)   <= window_double_buffer_i(0).dbuffer(52);
	--	s_dataset_double_buffer(0)(3).data(2)   <= window_double_buffer_i(0).dbuffer(53);
	--	s_dataset_double_buffer(0)(3).data(3)   <= window_double_buffer_i(0).dbuffer(54);
	--	s_dataset_double_buffer(0)(3).data(4)   <= window_double_buffer_i(0).dbuffer(55);
	--	s_dataset_double_buffer(0)(3).data(5)   <= window_double_buffer_i(0).dbuffer(56);
	--	s_dataset_double_buffer(0)(3).data(6)   <= window_double_buffer_i(0).dbuffer(57);
	--	s_dataset_double_buffer(0)(3).data(7)   <= window_double_buffer_i(0).dbuffer(58);
	--	s_dataset_double_buffer(0)(3).data(8)   <= window_double_buffer_i(0).dbuffer(59);
	--	s_dataset_double_buffer(0)(3).data(9)   <= window_double_buffer_i(0).dbuffer(60);
	--	s_dataset_double_buffer(0)(3).data(10)  <= window_double_buffer_i(0).dbuffer(61);
	--	s_dataset_double_buffer(0)(3).data(11)  <= window_double_buffer_i(0).dbuffer(62);
	--	s_dataset_double_buffer(0)(3).data(12)  <= window_double_buffer_i(0).dbuffer(63);
	--	s_dataset_double_buffer(0)(3).data(13)  <= window_double_buffer_i(0).dbuffer(64);
	--	s_dataset_double_buffer(0)(3).data(14)  <= window_double_buffer_i(0).dbuffer(65);
	--	s_dataset_double_buffer(0)(3).data(15)  <= window_double_buffer_i(0).dbuffer(66);
	--	s_dataset_double_buffer(0)(3).mask      <= window_double_buffer_i(0).dbuffer(67);
	--	-- dataset buffer 4
	--	s_dataset_double_buffer(0)(4).data(0)   <= window_double_buffer_i(0).dbuffer(68);
	--	s_dataset_double_buffer(0)(4).data(1)   <= window_double_buffer_i(0).dbuffer(69);
	--	s_dataset_double_buffer(0)(4).data(2)   <= window_double_buffer_i(0).dbuffer(70);
	--	s_dataset_double_buffer(0)(4).data(3)   <= window_double_buffer_i(0).dbuffer(71);
	--	s_dataset_double_buffer(0)(4).data(4)   <= window_double_buffer_i(0).dbuffer(72);
	--	s_dataset_double_buffer(0)(4).data(5)   <= window_double_buffer_i(0).dbuffer(73);
	--	s_dataset_double_buffer(0)(4).data(6)   <= window_double_buffer_i(0).dbuffer(74);
	--	s_dataset_double_buffer(0)(4).data(7)   <= window_double_buffer_i(0).dbuffer(75);
	--	s_dataset_double_buffer(0)(4).data(8)   <= window_double_buffer_i(0).dbuffer(76);
	--	s_dataset_double_buffer(0)(4).data(9)   <= window_double_buffer_i(0).dbuffer(77);
	--	s_dataset_double_buffer(0)(4).data(10)  <= window_double_buffer_i(0).dbuffer(78);
	--	s_dataset_double_buffer(0)(4).data(11)  <= window_double_buffer_i(0).dbuffer(79);
	--	s_dataset_double_buffer(0)(4).data(12)  <= window_double_buffer_i(0).dbuffer(80);
	--	s_dataset_double_buffer(0)(4).data(13)  <= window_double_buffer_i(0).dbuffer(81);
	--	s_dataset_double_buffer(0)(4).data(14)  <= window_double_buffer_i(0).dbuffer(82);
	--	s_dataset_double_buffer(0)(4).data(15)  <= window_double_buffer_i(0).dbuffer(83);
	--	s_dataset_double_buffer(0)(4).mask      <= window_double_buffer_i(0).dbuffer(84);
	--	-- dataset buffer 5
	--	s_dataset_double_buffer(0)(5).data(0)   <= window_double_buffer_i(0).dbuffer(85);
	--	s_dataset_double_buffer(0)(5).data(1)   <= window_double_buffer_i(0).dbuffer(86);
	--	s_dataset_double_buffer(0)(5).data(2)   <= window_double_buffer_i(0).dbuffer(87);
	--	s_dataset_double_buffer(0)(5).data(3)   <= window_double_buffer_i(0).dbuffer(88);
	--	s_dataset_double_buffer(0)(5).data(4)   <= window_double_buffer_i(0).dbuffer(89);
	--	s_dataset_double_buffer(0)(5).data(5)   <= window_double_buffer_i(0).dbuffer(90);
	--	s_dataset_double_buffer(0)(5).data(6)   <= window_double_buffer_i(0).dbuffer(91);
	--	s_dataset_double_buffer(0)(5).data(7)   <= window_double_buffer_i(0).dbuffer(92);
	--	s_dataset_double_buffer(0)(5).data(8)   <= window_double_buffer_i(0).dbuffer(93);
	--	s_dataset_double_buffer(0)(5).data(9)   <= window_double_buffer_i(0).dbuffer(94);
	--	s_dataset_double_buffer(0)(5).data(10)  <= window_double_buffer_i(0).dbuffer(95);
	--	s_dataset_double_buffer(0)(5).data(11)  <= window_double_buffer_i(0).dbuffer(96);
	--	s_dataset_double_buffer(0)(5).data(12)  <= window_double_buffer_i(0).dbuffer(97);
	--	s_dataset_double_buffer(0)(5).data(13)  <= window_double_buffer_i(0).dbuffer(98);
	--	s_dataset_double_buffer(0)(5).data(14)  <= window_double_buffer_i(0).dbuffer(99);
	--	s_dataset_double_buffer(0)(5).data(15)  <= window_double_buffer_i(0).dbuffer(100);
	--	s_dataset_double_buffer(0)(5).mask      <= window_double_buffer_i(0).dbuffer(101);
	--	-- dataset buffer 6
	--	s_dataset_double_buffer(0)(6).data(0)   <= window_double_buffer_i(0).dbuffer(102);
	--	s_dataset_double_buffer(0)(6).data(1)   <= window_double_buffer_i(0).dbuffer(103);
	--	s_dataset_double_buffer(0)(6).data(2)   <= window_double_buffer_i(0).dbuffer(104);
	--	s_dataset_double_buffer(0)(6).data(3)   <= window_double_buffer_i(0).dbuffer(105);
	--	s_dataset_double_buffer(0)(6).data(4)   <= window_double_buffer_i(0).dbuffer(106);
	--	s_dataset_double_buffer(0)(6).data(5)   <= window_double_buffer_i(0).dbuffer(107);
	--	s_dataset_double_buffer(0)(6).data(6)   <= window_double_buffer_i(0).dbuffer(108);
	--	s_dataset_double_buffer(0)(6).data(7)   <= window_double_buffer_i(0).dbuffer(109);
	--	s_dataset_double_buffer(0)(6).data(8)   <= window_double_buffer_i(0).dbuffer(110);
	--	s_dataset_double_buffer(0)(6).data(9)   <= window_double_buffer_i(0).dbuffer(111);
	--	s_dataset_double_buffer(0)(6).data(10)  <= window_double_buffer_i(0).dbuffer(112);
	--	s_dataset_double_buffer(0)(6).data(11)  <= window_double_buffer_i(0).dbuffer(113);
	--	s_dataset_double_buffer(0)(6).data(12)  <= window_double_buffer_i(0).dbuffer(114);
	--	s_dataset_double_buffer(0)(6).data(13)  <= window_double_buffer_i(0).dbuffer(115);
	--	s_dataset_double_buffer(0)(6).data(14)  <= window_double_buffer_i(0).dbuffer(116);
	--	s_dataset_double_buffer(0)(6).data(15)  <= window_double_buffer_i(0).dbuffer(117);
	--	s_dataset_double_buffer(0)(6).mask      <= window_double_buffer_i(0).dbuffer(118);
	--	-- dataset buffer 7
	--	s_dataset_double_buffer(0)(7).data(0)   <= window_double_buffer_i(0).dbuffer(119);
	--	s_dataset_double_buffer(0)(7).data(1)   <= window_double_buffer_i(0).dbuffer(120);
	--	s_dataset_double_buffer(0)(7).data(2)   <= window_double_buffer_i(0).dbuffer(121);
	--	s_dataset_double_buffer(0)(7).data(3)   <= window_double_buffer_i(0).dbuffer(122);
	--	s_dataset_double_buffer(0)(7).data(4)   <= window_double_buffer_i(0).dbuffer(123);
	--	s_dataset_double_buffer(0)(7).data(5)   <= window_double_buffer_i(0).dbuffer(124);
	--	s_dataset_double_buffer(0)(7).data(6)   <= window_double_buffer_i(0).dbuffer(125);
	--	s_dataset_double_buffer(0)(7).data(7)   <= window_double_buffer_i(0).dbuffer(126);
	--	s_dataset_double_buffer(0)(7).data(8)   <= window_double_buffer_i(0).dbuffer(127);
	--	s_dataset_double_buffer(0)(7).data(9)   <= window_double_buffer_i(0).dbuffer(128);
	--	s_dataset_double_buffer(0)(7).data(10)  <= window_double_buffer_i(0).dbuffer(129);
	--	s_dataset_double_buffer(0)(7).data(11)  <= window_double_buffer_i(0).dbuffer(130);
	--	s_dataset_double_buffer(0)(7).data(12)  <= window_double_buffer_i(0).dbuffer(131);
	--	s_dataset_double_buffer(0)(7).data(13)  <= window_double_buffer_i(0).dbuffer(132);
	--	s_dataset_double_buffer(0)(7).data(14)  <= window_double_buffer_i(0).dbuffer(133);
	--	s_dataset_double_buffer(0)(7).data(15)  <= window_double_buffer_i(0).dbuffer(134);
	--	s_dataset_double_buffer(0)(7).mask      <= window_double_buffer_i(0).dbuffer(135);
	--	-- dataset buffer 8
	--	s_dataset_double_buffer(0)(8).data(0)   <= window_double_buffer_i(0).dbuffer(136);
	--	s_dataset_double_buffer(0)(8).data(1)   <= window_double_buffer_i(0).dbuffer(137);
	--	s_dataset_double_buffer(0)(8).data(2)   <= window_double_buffer_i(0).dbuffer(138);
	--	s_dataset_double_buffer(0)(8).data(3)   <= window_double_buffer_i(0).dbuffer(139);
	--	s_dataset_double_buffer(0)(8).data(4)   <= window_double_buffer_i(0).dbuffer(140);
	--	s_dataset_double_buffer(0)(8).data(5)   <= window_double_buffer_i(0).dbuffer(141);
	--	s_dataset_double_buffer(0)(8).data(6)   <= window_double_buffer_i(0).dbuffer(142);
	--	s_dataset_double_buffer(0)(8).data(7)   <= window_double_buffer_i(0).dbuffer(143);
	--	s_dataset_double_buffer(0)(8).data(8)   <= window_double_buffer_i(0).dbuffer(144);
	--	s_dataset_double_buffer(0)(8).data(9)   <= window_double_buffer_i(0).dbuffer(145);
	--	s_dataset_double_buffer(0)(8).data(10)  <= window_double_buffer_i(0).dbuffer(146);
	--	s_dataset_double_buffer(0)(8).data(11)  <= window_double_buffer_i(0).dbuffer(147);
	--	s_dataset_double_buffer(0)(8).data(12)  <= window_double_buffer_i(0).dbuffer(148);
	--	s_dataset_double_buffer(0)(8).data(13)  <= window_double_buffer_i(0).dbuffer(149);
	--	s_dataset_double_buffer(0)(8).data(14)  <= window_double_buffer_i(0).dbuffer(150);
	--	s_dataset_double_buffer(0)(8).data(15)  <= window_double_buffer_i(0).dbuffer(151);
	--	s_dataset_double_buffer(0)(8).mask      <= window_double_buffer_i(0).dbuffer(152);
	--	-- dataset buffer 9
	--	s_dataset_double_buffer(0)(9).data(0)   <= window_double_buffer_i(0).dbuffer(153);
	--	s_dataset_double_buffer(0)(9).data(1)   <= window_double_buffer_i(0).dbuffer(154);
	--	s_dataset_double_buffer(0)(9).data(2)   <= window_double_buffer_i(0).dbuffer(155);
	--	s_dataset_double_buffer(0)(9).data(3)   <= window_double_buffer_i(0).dbuffer(156);
	--	s_dataset_double_buffer(0)(9).data(4)   <= window_double_buffer_i(0).dbuffer(157);
	--	s_dataset_double_buffer(0)(9).data(5)   <= window_double_buffer_i(0).dbuffer(158);
	--	s_dataset_double_buffer(0)(9).data(6)   <= window_double_buffer_i(0).dbuffer(159);
	--	s_dataset_double_buffer(0)(9).data(7)   <= window_double_buffer_i(0).dbuffer(160);
	--	s_dataset_double_buffer(0)(9).data(8)   <= window_double_buffer_i(0).dbuffer(161);
	--	s_dataset_double_buffer(0)(9).data(9)   <= window_double_buffer_i(0).dbuffer(162);
	--	s_dataset_double_buffer(0)(9).data(10)  <= window_double_buffer_i(0).dbuffer(163);
	--	s_dataset_double_buffer(0)(9).data(11)  <= window_double_buffer_i(0).dbuffer(164);
	--	s_dataset_double_buffer(0)(9).data(12)  <= window_double_buffer_i(0).dbuffer(165);
	--	s_dataset_double_buffer(0)(9).data(13)  <= window_double_buffer_i(0).dbuffer(166);
	--	s_dataset_double_buffer(0)(9).data(14)  <= window_double_buffer_i(0).dbuffer(167);
	--	s_dataset_double_buffer(0)(9).data(15)  <= window_double_buffer_i(0).dbuffer(168);
	--	s_dataset_double_buffer(0)(9).mask      <= window_double_buffer_i(0).dbuffer(169);
	--	-- dataset buffer 10
	--	s_dataset_double_buffer(0)(10).data(0)  <= window_double_buffer_i(0).dbuffer(170);
	--	s_dataset_double_buffer(0)(10).data(1)  <= window_double_buffer_i(0).dbuffer(171);
	--	s_dataset_double_buffer(0)(10).data(2)  <= window_double_buffer_i(0).dbuffer(172);
	--	s_dataset_double_buffer(0)(10).data(3)  <= window_double_buffer_i(0).dbuffer(173);
	--	s_dataset_double_buffer(0)(10).data(4)  <= window_double_buffer_i(0).dbuffer(174);
	--	s_dataset_double_buffer(0)(10).data(5)  <= window_double_buffer_i(0).dbuffer(175);
	--	s_dataset_double_buffer(0)(10).data(6)  <= window_double_buffer_i(0).dbuffer(176);
	--	s_dataset_double_buffer(0)(10).data(7)  <= window_double_buffer_i(0).dbuffer(177);
	--	s_dataset_double_buffer(0)(10).data(8)  <= window_double_buffer_i(0).dbuffer(178);
	--	s_dataset_double_buffer(0)(10).data(9)  <= window_double_buffer_i(0).dbuffer(179);
	--	s_dataset_double_buffer(0)(10).data(10) <= window_double_buffer_i(0).dbuffer(180);
	--	s_dataset_double_buffer(0)(10).data(11) <= window_double_buffer_i(0).dbuffer(181);
	--	s_dataset_double_buffer(0)(10).data(12) <= window_double_buffer_i(0).dbuffer(182);
	--	s_dataset_double_buffer(0)(10).data(13) <= window_double_buffer_i(0).dbuffer(183);
	--	s_dataset_double_buffer(0)(10).data(14) <= window_double_buffer_i(0).dbuffer(184);
	--	s_dataset_double_buffer(0)(10).data(15) <= window_double_buffer_i(0).dbuffer(185);
	--	s_dataset_double_buffer(0)(10).mask     <= window_double_buffer_i(0).dbuffer(186);
	--	-- dataset buffer 11
	--	s_dataset_double_buffer(0)(11).data(0)  <= window_double_buffer_i(0).dbuffer(187);
	--	s_dataset_double_buffer(0)(11).data(1)  <= window_double_buffer_i(0).dbuffer(188);
	--	s_dataset_double_buffer(0)(11).data(2)  <= window_double_buffer_i(0).dbuffer(189);
	--	s_dataset_double_buffer(0)(11).data(3)  <= window_double_buffer_i(0).dbuffer(190);
	--	s_dataset_double_buffer(0)(11).data(4)  <= window_double_buffer_i(0).dbuffer(191);
	--	s_dataset_double_buffer(0)(11).data(5)  <= window_double_buffer_i(0).dbuffer(192);
	--	s_dataset_double_buffer(0)(11).data(6)  <= window_double_buffer_i(0).dbuffer(193);
	--	s_dataset_double_buffer(0)(11).data(7)  <= window_double_buffer_i(0).dbuffer(194);
	--	s_dataset_double_buffer(0)(11).data(8)  <= window_double_buffer_i(0).dbuffer(195);
	--	s_dataset_double_buffer(0)(11).data(9)  <= window_double_buffer_i(0).dbuffer(196);
	--	s_dataset_double_buffer(0)(11).data(10) <= window_double_buffer_i(0).dbuffer(197);
	--	s_dataset_double_buffer(0)(11).data(11) <= window_double_buffer_i(0).dbuffer(198);
	--	s_dataset_double_buffer(0)(11).data(12) <= window_double_buffer_i(0).dbuffer(199);
	--	s_dataset_double_buffer(0)(11).data(13) <= window_double_buffer_i(0).dbuffer(200);
	--	s_dataset_double_buffer(0)(11).data(14) <= window_double_buffer_i(0).dbuffer(201);
	--	s_dataset_double_buffer(0)(11).data(15) <= window_double_buffer_i(0).dbuffer(202);
	--	s_dataset_double_buffer(0)(11).mask     <= window_double_buffer_i(0).dbuffer(203);
	--	-- dataset buffer 12
	--	s_dataset_double_buffer(0)(12).data(0)  <= window_double_buffer_i(0).dbuffer(204);
	--	s_dataset_double_buffer(0)(12).data(1)  <= window_double_buffer_i(0).dbuffer(205);
	--	s_dataset_double_buffer(0)(12).data(2)  <= window_double_buffer_i(0).dbuffer(206);
	--	s_dataset_double_buffer(0)(12).data(3)  <= window_double_buffer_i(0).dbuffer(207);
	--	s_dataset_double_buffer(0)(12).data(4)  <= window_double_buffer_i(0).dbuffer(208);
	--	s_dataset_double_buffer(0)(12).data(5)  <= window_double_buffer_i(0).dbuffer(209);
	--	s_dataset_double_buffer(0)(12).data(6)  <= window_double_buffer_i(0).dbuffer(210);
	--	s_dataset_double_buffer(0)(12).data(7)  <= window_double_buffer_i(0).dbuffer(211);
	--	s_dataset_double_buffer(0)(12).data(8)  <= window_double_buffer_i(0).dbuffer(212);
	--	s_dataset_double_buffer(0)(12).data(9)  <= window_double_buffer_i(0).dbuffer(213);
	--	s_dataset_double_buffer(0)(12).data(10) <= window_double_buffer_i(0).dbuffer(214);
	--	s_dataset_double_buffer(0)(12).data(11) <= window_double_buffer_i(0).dbuffer(215);
	--	s_dataset_double_buffer(0)(12).data(12) <= window_double_buffer_i(0).dbuffer(216);
	--	s_dataset_double_buffer(0)(12).data(13) <= window_double_buffer_i(0).dbuffer(217);
	--	s_dataset_double_buffer(0)(12).data(14) <= window_double_buffer_i(0).dbuffer(218);
	--	s_dataset_double_buffer(0)(12).data(15) <= window_double_buffer_i(0).dbuffer(219);
	--	s_dataset_double_buffer(0)(12).mask     <= window_double_buffer_i(0).dbuffer(220);
	--	-- dataset buffer 13
	--	s_dataset_double_buffer(0)(13).data(0)  <= window_double_buffer_i(0).dbuffer(221);
	--	s_dataset_double_buffer(0)(13).data(1)  <= window_double_buffer_i(0).dbuffer(222);
	--	s_dataset_double_buffer(0)(13).data(2)  <= window_double_buffer_i(0).dbuffer(223);
	--	s_dataset_double_buffer(0)(13).data(3)  <= window_double_buffer_i(0).dbuffer(224);
	--	s_dataset_double_buffer(0)(13).data(4)  <= window_double_buffer_i(0).dbuffer(225);
	--	s_dataset_double_buffer(0)(13).data(5)  <= window_double_buffer_i(0).dbuffer(226);
	--	s_dataset_double_buffer(0)(13).data(6)  <= window_double_buffer_i(0).dbuffer(227);
	--	s_dataset_double_buffer(0)(13).data(7)  <= window_double_buffer_i(0).dbuffer(228);
	--	s_dataset_double_buffer(0)(13).data(8)  <= window_double_buffer_i(0).dbuffer(229);
	--	s_dataset_double_buffer(0)(13).data(9)  <= window_double_buffer_i(0).dbuffer(230);
	--	s_dataset_double_buffer(0)(13).data(10) <= window_double_buffer_i(0).dbuffer(231);
	--	s_dataset_double_buffer(0)(13).data(11) <= window_double_buffer_i(0).dbuffer(232);
	--	s_dataset_double_buffer(0)(13).data(12) <= window_double_buffer_i(0).dbuffer(233);
	--	s_dataset_double_buffer(0)(13).data(13) <= window_double_buffer_i(0).dbuffer(234);
	--	s_dataset_double_buffer(0)(13).data(14) <= window_double_buffer_i(0).dbuffer(235);
	--	s_dataset_double_buffer(0)(13).data(15) <= window_double_buffer_i(0).dbuffer(236);
	--	s_dataset_double_buffer(0)(13).mask     <= window_double_buffer_i(0).dbuffer(237);
	--	-- dataset buffer 14
	--	s_dataset_double_buffer(0)(14).data(0)  <= window_double_buffer_i(0).dbuffer(238);
	--	s_dataset_double_buffer(0)(14).data(1)  <= window_double_buffer_i(0).dbuffer(239);
	--	s_dataset_double_buffer(0)(14).data(2)  <= window_double_buffer_i(0).dbuffer(240);
	--	s_dataset_double_buffer(0)(14).data(3)  <= window_double_buffer_i(0).dbuffer(241);
	--	s_dataset_double_buffer(0)(14).data(4)  <= window_double_buffer_i(0).dbuffer(242);
	--	s_dataset_double_buffer(0)(14).data(5)  <= window_double_buffer_i(0).dbuffer(243);
	--	s_dataset_double_buffer(0)(14).data(6)  <= window_double_buffer_i(0).dbuffer(244);
	--	s_dataset_double_buffer(0)(14).data(7)  <= window_double_buffer_i(0).dbuffer(245);
	--	s_dataset_double_buffer(0)(14).data(8)  <= window_double_buffer_i(0).dbuffer(246);
	--	s_dataset_double_buffer(0)(14).data(9)  <= window_double_buffer_i(0).dbuffer(247);
	--	s_dataset_double_buffer(0)(14).data(10) <= window_double_buffer_i(0).dbuffer(248);
	--	s_dataset_double_buffer(0)(14).data(11) <= window_double_buffer_i(0).dbuffer(249);
	--	s_dataset_double_buffer(0)(14).data(12) <= window_double_buffer_i(0).dbuffer(250);
	--	s_dataset_double_buffer(0)(14).data(13) <= window_double_buffer_i(0).dbuffer(251);
	--	s_dataset_double_buffer(0)(14).data(14) <= window_double_buffer_i(0).dbuffer(252);
	--	s_dataset_double_buffer(0)(14).data(15) <= window_double_buffer_i(0).dbuffer(253);
	--	s_dataset_double_buffer(0)(14).mask     <= window_double_buffer_i(0).dbuffer(254);
	--	-- dataset buffer 15
	--	s_dataset_double_buffer(0)(15).data(0)  <= window_double_buffer_i(0).dbuffer(255);
	--	s_dataset_double_buffer(0)(15).data(1)  <= window_double_buffer_i(0).dbuffer(256);
	--	s_dataset_double_buffer(0)(15).data(2)  <= window_double_buffer_i(0).dbuffer(257);
	--	s_dataset_double_buffer(0)(15).data(3)  <= window_double_buffer_i(0).dbuffer(258);
	--	s_dataset_double_buffer(0)(15).data(4)  <= window_double_buffer_i(0).dbuffer(259);
	--	s_dataset_double_buffer(0)(15).data(5)  <= window_double_buffer_i(0).dbuffer(260);
	--	s_dataset_double_buffer(0)(15).data(6)  <= window_double_buffer_i(0).dbuffer(261);
	--	s_dataset_double_buffer(0)(15).data(7)  <= window_double_buffer_i(0).dbuffer(262);
	--	s_dataset_double_buffer(0)(15).data(8)  <= window_double_buffer_i(0).dbuffer(263);
	--	s_dataset_double_buffer(0)(15).data(9)  <= window_double_buffer_i(0).dbuffer(264);
	--	s_dataset_double_buffer(0)(15).data(10) <= window_double_buffer_i(0).dbuffer(265);
	--	s_dataset_double_buffer(0)(15).data(11) <= window_double_buffer_i(0).dbuffer(266);
	--	s_dataset_double_buffer(0)(15).data(12) <= window_double_buffer_i(0).dbuffer(267);
	--	s_dataset_double_buffer(0)(15).data(13) <= window_double_buffer_i(0).dbuffer(268);
	--	s_dataset_double_buffer(0)(15).data(14) <= window_double_buffer_i(0).dbuffer(269);
	--	s_dataset_double_buffer(0)(15).data(15) <= window_double_buffer_i(0).dbuffer(270);
	--	s_dataset_double_buffer(0)(15).mask     <= window_double_buffer_i(0).dbuffer(271);
	--
	--	-- dataset double buffer 1
	--	-- dataset buffer 0
	--	s_dataset_double_buffer(1)(0).data(0)   <= window_double_buffer_i(1).dbuffer(0);
	--	s_dataset_double_buffer(1)(0).data(1)   <= window_double_buffer_i(1).dbuffer(1);
	--	s_dataset_double_buffer(1)(0).data(2)   <= window_double_buffer_i(1).dbuffer(2);
	--	s_dataset_double_buffer(1)(0).data(3)   <= window_double_buffer_i(1).dbuffer(3);
	--	s_dataset_double_buffer(1)(0).data(4)   <= window_double_buffer_i(1).dbuffer(4);
	--	s_dataset_double_buffer(1)(0).data(5)   <= window_double_buffer_i(1).dbuffer(5);
	--	s_dataset_double_buffer(1)(0).data(6)   <= window_double_buffer_i(1).dbuffer(6);
	--	s_dataset_double_buffer(1)(0).data(7)   <= window_double_buffer_i(1).dbuffer(7);
	--	s_dataset_double_buffer(1)(0).data(8)   <= window_double_buffer_i(1).dbuffer(8);
	--	s_dataset_double_buffer(1)(0).data(9)   <= window_double_buffer_i(1).dbuffer(9);
	--	s_dataset_double_buffer(1)(0).data(10)  <= window_double_buffer_i(1).dbuffer(10);
	--	s_dataset_double_buffer(1)(0).data(11)  <= window_double_buffer_i(1).dbuffer(11);
	--	s_dataset_double_buffer(1)(0).data(12)  <= window_double_buffer_i(1).dbuffer(12);
	--	s_dataset_double_buffer(1)(0).data(13)  <= window_double_buffer_i(1).dbuffer(13);
	--	s_dataset_double_buffer(1)(0).data(14)  <= window_double_buffer_i(1).dbuffer(14);
	--	s_dataset_double_buffer(1)(0).data(15)  <= window_double_buffer_i(1).dbuffer(15);
	--	s_dataset_double_buffer(1)(0).mask      <= window_double_buffer_i(1).dbuffer(16);
	--	-- dataset buffer 1
	--	s_dataset_double_buffer(1)(1).data(0)   <= window_double_buffer_i(1).dbuffer(17);
	--	s_dataset_double_buffer(1)(1).data(1)   <= window_double_buffer_i(1).dbuffer(18);
	--	s_dataset_double_buffer(1)(1).data(2)   <= window_double_buffer_i(1).dbuffer(19);
	--	s_dataset_double_buffer(1)(1).data(3)   <= window_double_buffer_i(1).dbuffer(20);
	--	s_dataset_double_buffer(1)(1).data(4)   <= window_double_buffer_i(1).dbuffer(21);
	--	s_dataset_double_buffer(1)(1).data(5)   <= window_double_buffer_i(1).dbuffer(22);
	--	s_dataset_double_buffer(1)(1).data(6)   <= window_double_buffer_i(1).dbuffer(23);
	--	s_dataset_double_buffer(1)(1).data(7)   <= window_double_buffer_i(1).dbuffer(24);
	--	s_dataset_double_buffer(1)(1).data(8)   <= window_double_buffer_i(1).dbuffer(25);
	--	s_dataset_double_buffer(1)(1).data(9)   <= window_double_buffer_i(1).dbuffer(26);
	--	s_dataset_double_buffer(1)(1).data(10)  <= window_double_buffer_i(1).dbuffer(27);
	--	s_dataset_double_buffer(1)(1).data(11)  <= window_double_buffer_i(1).dbuffer(28);
	--	s_dataset_double_buffer(1)(1).data(12)  <= window_double_buffer_i(1).dbuffer(29);
	--	s_dataset_double_buffer(1)(1).data(13)  <= window_double_buffer_i(1).dbuffer(30);
	--	s_dataset_double_buffer(1)(1).data(14)  <= window_double_buffer_i(1).dbuffer(31);
	--	s_dataset_double_buffer(1)(1).data(15)  <= window_double_buffer_i(1).dbuffer(32);
	--	s_dataset_double_buffer(1)(1).mask      <= window_double_buffer_i(1).dbuffer(33);
	--	-- dataset buffer 2
	--	s_dataset_double_buffer(1)(2).data(0)   <= window_double_buffer_i(1).dbuffer(34);
	--	s_dataset_double_buffer(1)(2).data(1)   <= window_double_buffer_i(1).dbuffer(35);
	--	s_dataset_double_buffer(1)(2).data(2)   <= window_double_buffer_i(1).dbuffer(36);
	--	s_dataset_double_buffer(1)(2).data(3)   <= window_double_buffer_i(1).dbuffer(37);
	--	s_dataset_double_buffer(1)(2).data(4)   <= window_double_buffer_i(1).dbuffer(38);
	--	s_dataset_double_buffer(1)(2).data(5)   <= window_double_buffer_i(1).dbuffer(39);
	--	s_dataset_double_buffer(1)(2).data(6)   <= window_double_buffer_i(1).dbuffer(40);
	--	s_dataset_double_buffer(1)(2).data(7)   <= window_double_buffer_i(1).dbuffer(41);
	--	s_dataset_double_buffer(1)(2).data(8)   <= window_double_buffer_i(1).dbuffer(42);
	--	s_dataset_double_buffer(1)(2).data(9)   <= window_double_buffer_i(1).dbuffer(43);
	--	s_dataset_double_buffer(1)(2).data(10)  <= window_double_buffer_i(1).dbuffer(44);
	--	s_dataset_double_buffer(1)(2).data(11)  <= window_double_buffer_i(1).dbuffer(45);
	--	s_dataset_double_buffer(1)(2).data(12)  <= window_double_buffer_i(1).dbuffer(46);
	--	s_dataset_double_buffer(1)(2).data(13)  <= window_double_buffer_i(1).dbuffer(47);
	--	s_dataset_double_buffer(1)(2).data(14)  <= window_double_buffer_i(1).dbuffer(48);
	--	s_dataset_double_buffer(1)(2).data(15)  <= window_double_buffer_i(1).dbuffer(49);
	--	s_dataset_double_buffer(1)(2).mask      <= window_double_buffer_i(1).dbuffer(50);
	--	-- dataset buffer 3
	--	s_dataset_double_buffer(1)(3).data(0)   <= window_double_buffer_i(1).dbuffer(51);
	--	s_dataset_double_buffer(1)(3).data(1)   <= window_double_buffer_i(1).dbuffer(52);
	--	s_dataset_double_buffer(1)(3).data(2)   <= window_double_buffer_i(1).dbuffer(53);
	--	s_dataset_double_buffer(1)(3).data(3)   <= window_double_buffer_i(1).dbuffer(54);
	--	s_dataset_double_buffer(1)(3).data(4)   <= window_double_buffer_i(1).dbuffer(55);
	--	s_dataset_double_buffer(1)(3).data(5)   <= window_double_buffer_i(1).dbuffer(56);
	--	s_dataset_double_buffer(1)(3).data(6)   <= window_double_buffer_i(1).dbuffer(57);
	--	s_dataset_double_buffer(1)(3).data(7)   <= window_double_buffer_i(1).dbuffer(58);
	--	s_dataset_double_buffer(1)(3).data(8)   <= window_double_buffer_i(1).dbuffer(59);
	--	s_dataset_double_buffer(1)(3).data(9)   <= window_double_buffer_i(1).dbuffer(60);
	--	s_dataset_double_buffer(1)(3).data(10)  <= window_double_buffer_i(1).dbuffer(61);
	--	s_dataset_double_buffer(1)(3).data(11)  <= window_double_buffer_i(1).dbuffer(62);
	--	s_dataset_double_buffer(1)(3).data(12)  <= window_double_buffer_i(1).dbuffer(63);
	--	s_dataset_double_buffer(1)(3).data(13)  <= window_double_buffer_i(1).dbuffer(64);
	--	s_dataset_double_buffer(1)(3).data(14)  <= window_double_buffer_i(1).dbuffer(65);
	--	s_dataset_double_buffer(1)(3).data(15)  <= window_double_buffer_i(1).dbuffer(66);
	--	s_dataset_double_buffer(1)(3).mask      <= window_double_buffer_i(1).dbuffer(67);
	--	-- dataset buffer 4
	--	s_dataset_double_buffer(1)(4).data(0)   <= window_double_buffer_i(1).dbuffer(68);
	--	s_dataset_double_buffer(1)(4).data(1)   <= window_double_buffer_i(1).dbuffer(69);
	--	s_dataset_double_buffer(1)(4).data(2)   <= window_double_buffer_i(1).dbuffer(70);
	--	s_dataset_double_buffer(1)(4).data(3)   <= window_double_buffer_i(1).dbuffer(71);
	--	s_dataset_double_buffer(1)(4).data(4)   <= window_double_buffer_i(1).dbuffer(72);
	--	s_dataset_double_buffer(1)(4).data(5)   <= window_double_buffer_i(1).dbuffer(73);
	--	s_dataset_double_buffer(1)(4).data(6)   <= window_double_buffer_i(1).dbuffer(74);
	--	s_dataset_double_buffer(1)(4).data(7)   <= window_double_buffer_i(1).dbuffer(75);
	--	s_dataset_double_buffer(1)(4).data(8)   <= window_double_buffer_i(1).dbuffer(76);
	--	s_dataset_double_buffer(1)(4).data(9)   <= window_double_buffer_i(1).dbuffer(77);
	--	s_dataset_double_buffer(1)(4).data(10)  <= window_double_buffer_i(1).dbuffer(78);
	--	s_dataset_double_buffer(1)(4).data(11)  <= window_double_buffer_i(1).dbuffer(79);
	--	s_dataset_double_buffer(1)(4).data(12)  <= window_double_buffer_i(1).dbuffer(80);
	--	s_dataset_double_buffer(1)(4).data(13)  <= window_double_buffer_i(1).dbuffer(81);
	--	s_dataset_double_buffer(1)(4).data(14)  <= window_double_buffer_i(1).dbuffer(82);
	--	s_dataset_double_buffer(1)(4).data(15)  <= window_double_buffer_i(1).dbuffer(83);
	--	s_dataset_double_buffer(1)(4).mask      <= window_double_buffer_i(1).dbuffer(84);
	--	-- dataset buffer 5
	--	s_dataset_double_buffer(1)(5).data(0)   <= window_double_buffer_i(1).dbuffer(85);
	--	s_dataset_double_buffer(1)(5).data(1)   <= window_double_buffer_i(1).dbuffer(86);
	--	s_dataset_double_buffer(1)(5).data(2)   <= window_double_buffer_i(1).dbuffer(87);
	--	s_dataset_double_buffer(1)(5).data(3)   <= window_double_buffer_i(1).dbuffer(88);
	--	s_dataset_double_buffer(1)(5).data(4)   <= window_double_buffer_i(1).dbuffer(89);
	--	s_dataset_double_buffer(1)(5).data(5)   <= window_double_buffer_i(1).dbuffer(90);
	--	s_dataset_double_buffer(1)(5).data(6)   <= window_double_buffer_i(1).dbuffer(91);
	--	s_dataset_double_buffer(1)(5).data(7)   <= window_double_buffer_i(1).dbuffer(92);
	--	s_dataset_double_buffer(1)(5).data(8)   <= window_double_buffer_i(1).dbuffer(93);
	--	s_dataset_double_buffer(1)(5).data(9)   <= window_double_buffer_i(1).dbuffer(94);
	--	s_dataset_double_buffer(1)(5).data(10)  <= window_double_buffer_i(1).dbuffer(95);
	--	s_dataset_double_buffer(1)(5).data(11)  <= window_double_buffer_i(1).dbuffer(96);
	--	s_dataset_double_buffer(1)(5).data(12)  <= window_double_buffer_i(1).dbuffer(97);
	--	s_dataset_double_buffer(1)(5).data(13)  <= window_double_buffer_i(1).dbuffer(98);
	--	s_dataset_double_buffer(1)(5).data(14)  <= window_double_buffer_i(1).dbuffer(99);
	--	s_dataset_double_buffer(1)(5).data(15)  <= window_double_buffer_i(1).dbuffer(100);
	--	s_dataset_double_buffer(1)(5).mask      <= window_double_buffer_i(1).dbuffer(101);
	--	-- dataset buffer 6
	--	s_dataset_double_buffer(1)(6).data(0)   <= window_double_buffer_i(1).dbuffer(102);
	--	s_dataset_double_buffer(1)(6).data(1)   <= window_double_buffer_i(1).dbuffer(103);
	--	s_dataset_double_buffer(1)(6).data(2)   <= window_double_buffer_i(1).dbuffer(104);
	--	s_dataset_double_buffer(1)(6).data(3)   <= window_double_buffer_i(1).dbuffer(105);
	--	s_dataset_double_buffer(1)(6).data(4)   <= window_double_buffer_i(1).dbuffer(106);
	--	s_dataset_double_buffer(1)(6).data(5)   <= window_double_buffer_i(1).dbuffer(107);
	--	s_dataset_double_buffer(1)(6).data(6)   <= window_double_buffer_i(1).dbuffer(108);
	--	s_dataset_double_buffer(1)(6).data(7)   <= window_double_buffer_i(1).dbuffer(109);
	--	s_dataset_double_buffer(1)(6).data(8)   <= window_double_buffer_i(1).dbuffer(110);
	--	s_dataset_double_buffer(1)(6).data(9)   <= window_double_buffer_i(1).dbuffer(111);
	--	s_dataset_double_buffer(1)(6).data(10)  <= window_double_buffer_i(1).dbuffer(112);
	--	s_dataset_double_buffer(1)(6).data(11)  <= window_double_buffer_i(1).dbuffer(113);
	--	s_dataset_double_buffer(1)(6).data(12)  <= window_double_buffer_i(1).dbuffer(114);
	--	s_dataset_double_buffer(1)(6).data(13)  <= window_double_buffer_i(1).dbuffer(115);
	--	s_dataset_double_buffer(1)(6).data(14)  <= window_double_buffer_i(1).dbuffer(116);
	--	s_dataset_double_buffer(1)(6).data(15)  <= window_double_buffer_i(1).dbuffer(117);
	--	s_dataset_double_buffer(1)(6).mask      <= window_double_buffer_i(1).dbuffer(118);
	--	-- dataset buffer 7
	--	s_dataset_double_buffer(1)(7).data(0)   <= window_double_buffer_i(1).dbuffer(119);
	--	s_dataset_double_buffer(1)(7).data(1)   <= window_double_buffer_i(1).dbuffer(120);
	--	s_dataset_double_buffer(1)(7).data(2)   <= window_double_buffer_i(1).dbuffer(121);
	--	s_dataset_double_buffer(1)(7).data(3)   <= window_double_buffer_i(1).dbuffer(122);
	--	s_dataset_double_buffer(1)(7).data(4)   <= window_double_buffer_i(1).dbuffer(123);
	--	s_dataset_double_buffer(1)(7).data(5)   <= window_double_buffer_i(1).dbuffer(124);
	--	s_dataset_double_buffer(1)(7).data(6)   <= window_double_buffer_i(1).dbuffer(125);
	--	s_dataset_double_buffer(1)(7).data(7)   <= window_double_buffer_i(1).dbuffer(126);
	--	s_dataset_double_buffer(1)(7).data(8)   <= window_double_buffer_i(1).dbuffer(127);
	--	s_dataset_double_buffer(1)(7).data(9)   <= window_double_buffer_i(1).dbuffer(128);
	--	s_dataset_double_buffer(1)(7).data(10)  <= window_double_buffer_i(1).dbuffer(129);
	--	s_dataset_double_buffer(1)(7).data(11)  <= window_double_buffer_i(1).dbuffer(130);
	--	s_dataset_double_buffer(1)(7).data(12)  <= window_double_buffer_i(1).dbuffer(131);
	--	s_dataset_double_buffer(1)(7).data(13)  <= window_double_buffer_i(1).dbuffer(132);
	--	s_dataset_double_buffer(1)(7).data(14)  <= window_double_buffer_i(1).dbuffer(133);
	--	s_dataset_double_buffer(1)(7).data(15)  <= window_double_buffer_i(1).dbuffer(134);
	--	s_dataset_double_buffer(1)(7).mask      <= window_double_buffer_i(1).dbuffer(135);
	--	-- dataset buffer 8
	--	s_dataset_double_buffer(1)(8).data(0)   <= window_double_buffer_i(1).dbuffer(136);
	--	s_dataset_double_buffer(1)(8).data(1)   <= window_double_buffer_i(1).dbuffer(137);
	--	s_dataset_double_buffer(1)(8).data(2)   <= window_double_buffer_i(1).dbuffer(138);
	--	s_dataset_double_buffer(1)(8).data(3)   <= window_double_buffer_i(1).dbuffer(139);
	--	s_dataset_double_buffer(1)(8).data(4)   <= window_double_buffer_i(1).dbuffer(140);
	--	s_dataset_double_buffer(1)(8).data(5)   <= window_double_buffer_i(1).dbuffer(141);
	--	s_dataset_double_buffer(1)(8).data(6)   <= window_double_buffer_i(1).dbuffer(142);
	--	s_dataset_double_buffer(1)(8).data(7)   <= window_double_buffer_i(1).dbuffer(143);
	--	s_dataset_double_buffer(1)(8).data(8)   <= window_double_buffer_i(1).dbuffer(144);
	--	s_dataset_double_buffer(1)(8).data(9)   <= window_double_buffer_i(1).dbuffer(145);
	--	s_dataset_double_buffer(1)(8).data(10)  <= window_double_buffer_i(1).dbuffer(146);
	--	s_dataset_double_buffer(1)(8).data(11)  <= window_double_buffer_i(1).dbuffer(147);
	--	s_dataset_double_buffer(1)(8).data(12)  <= window_double_buffer_i(1).dbuffer(148);
	--	s_dataset_double_buffer(1)(8).data(13)  <= window_double_buffer_i(1).dbuffer(149);
	--	s_dataset_double_buffer(1)(8).data(14)  <= window_double_buffer_i(1).dbuffer(150);
	--	s_dataset_double_buffer(1)(8).data(15)  <= window_double_buffer_i(1).dbuffer(151);
	--	s_dataset_double_buffer(1)(8).mask      <= window_double_buffer_i(1).dbuffer(152);
	--	-- dataset buffer 9
	--	s_dataset_double_buffer(1)(9).data(0)   <= window_double_buffer_i(1).dbuffer(153);
	--	s_dataset_double_buffer(1)(9).data(1)   <= window_double_buffer_i(1).dbuffer(154);
	--	s_dataset_double_buffer(1)(9).data(2)   <= window_double_buffer_i(1).dbuffer(155);
	--	s_dataset_double_buffer(1)(9).data(3)   <= window_double_buffer_i(1).dbuffer(156);
	--	s_dataset_double_buffer(1)(9).data(4)   <= window_double_buffer_i(1).dbuffer(157);
	--	s_dataset_double_buffer(1)(9).data(5)   <= window_double_buffer_i(1).dbuffer(158);
	--	s_dataset_double_buffer(1)(9).data(6)   <= window_double_buffer_i(1).dbuffer(159);
	--	s_dataset_double_buffer(1)(9).data(7)   <= window_double_buffer_i(1).dbuffer(160);
	--	s_dataset_double_buffer(1)(9).data(8)   <= window_double_buffer_i(1).dbuffer(161);
	--	s_dataset_double_buffer(1)(9).data(9)   <= window_double_buffer_i(1).dbuffer(162);
	--	s_dataset_double_buffer(1)(9).data(10)  <= window_double_buffer_i(1).dbuffer(163);
	--	s_dataset_double_buffer(1)(9).data(11)  <= window_double_buffer_i(1).dbuffer(164);
	--	s_dataset_double_buffer(1)(9).data(12)  <= window_double_buffer_i(1).dbuffer(165);
	--	s_dataset_double_buffer(1)(9).data(13)  <= window_double_buffer_i(1).dbuffer(166);
	--	s_dataset_double_buffer(1)(9).data(14)  <= window_double_buffer_i(1).dbuffer(167);
	--	s_dataset_double_buffer(1)(9).data(15)  <= window_double_buffer_i(1).dbuffer(168);
	--	s_dataset_double_buffer(1)(9).mask      <= window_double_buffer_i(1).dbuffer(169);
	--	-- dataset buffer 10
	--	s_dataset_double_buffer(1)(10).data(0)  <= window_double_buffer_i(1).dbuffer(170);
	--	s_dataset_double_buffer(1)(10).data(1)  <= window_double_buffer_i(1).dbuffer(171);
	--	s_dataset_double_buffer(1)(10).data(2)  <= window_double_buffer_i(1).dbuffer(172);
	--	s_dataset_double_buffer(1)(10).data(3)  <= window_double_buffer_i(1).dbuffer(173);
	--	s_dataset_double_buffer(1)(10).data(4)  <= window_double_buffer_i(1).dbuffer(174);
	--	s_dataset_double_buffer(1)(10).data(5)  <= window_double_buffer_i(1).dbuffer(175);
	--	s_dataset_double_buffer(1)(10).data(6)  <= window_double_buffer_i(1).dbuffer(176);
	--	s_dataset_double_buffer(1)(10).data(7)  <= window_double_buffer_i(1).dbuffer(177);
	--	s_dataset_double_buffer(1)(10).data(8)  <= window_double_buffer_i(1).dbuffer(178);
	--	s_dataset_double_buffer(1)(10).data(9)  <= window_double_buffer_i(1).dbuffer(179);
	--	s_dataset_double_buffer(1)(10).data(10) <= window_double_buffer_i(1).dbuffer(180);
	--	s_dataset_double_buffer(1)(10).data(11) <= window_double_buffer_i(1).dbuffer(181);
	--	s_dataset_double_buffer(1)(10).data(12) <= window_double_buffer_i(1).dbuffer(182);
	--	s_dataset_double_buffer(1)(10).data(13) <= window_double_buffer_i(1).dbuffer(183);
	--	s_dataset_double_buffer(1)(10).data(14) <= window_double_buffer_i(1).dbuffer(184);
	--	s_dataset_double_buffer(1)(10).data(15) <= window_double_buffer_i(1).dbuffer(185);
	--	s_dataset_double_buffer(1)(10).mask     <= window_double_buffer_i(1).dbuffer(186);
	--	-- dataset buffer 11
	--	s_dataset_double_buffer(1)(11).data(0)  <= window_double_buffer_i(1).dbuffer(187);
	--	s_dataset_double_buffer(1)(11).data(1)  <= window_double_buffer_i(1).dbuffer(188);
	--	s_dataset_double_buffer(1)(11).data(2)  <= window_double_buffer_i(1).dbuffer(189);
	--	s_dataset_double_buffer(1)(11).data(3)  <= window_double_buffer_i(1).dbuffer(190);
	--	s_dataset_double_buffer(1)(11).data(4)  <= window_double_buffer_i(1).dbuffer(191);
	--	s_dataset_double_buffer(1)(11).data(5)  <= window_double_buffer_i(1).dbuffer(192);
	--	s_dataset_double_buffer(1)(11).data(6)  <= window_double_buffer_i(1).dbuffer(193);
	--	s_dataset_double_buffer(1)(11).data(7)  <= window_double_buffer_i(1).dbuffer(194);
	--	s_dataset_double_buffer(1)(11).data(8)  <= window_double_buffer_i(1).dbuffer(195);
	--	s_dataset_double_buffer(1)(11).data(9)  <= window_double_buffer_i(1).dbuffer(196);
	--	s_dataset_double_buffer(1)(11).data(10) <= window_double_buffer_i(1).dbuffer(197);
	--	s_dataset_double_buffer(1)(11).data(11) <= window_double_buffer_i(1).dbuffer(198);
	--	s_dataset_double_buffer(1)(11).data(12) <= window_double_buffer_i(1).dbuffer(199);
	--	s_dataset_double_buffer(1)(11).data(13) <= window_double_buffer_i(1).dbuffer(200);
	--	s_dataset_double_buffer(1)(11).data(14) <= window_double_buffer_i(1).dbuffer(201);
	--	s_dataset_double_buffer(1)(11).data(15) <= window_double_buffer_i(1).dbuffer(202);
	--	s_dataset_double_buffer(1)(11).mask     <= window_double_buffer_i(1).dbuffer(203);
	--	-- dataset buffer 12
	--	s_dataset_double_buffer(1)(12).data(0)  <= window_double_buffer_i(1).dbuffer(204);
	--	s_dataset_double_buffer(1)(12).data(1)  <= window_double_buffer_i(1).dbuffer(205);
	--	s_dataset_double_buffer(1)(12).data(2)  <= window_double_buffer_i(1).dbuffer(206);
	--	s_dataset_double_buffer(1)(12).data(3)  <= window_double_buffer_i(1).dbuffer(207);
	--	s_dataset_double_buffer(1)(12).data(4)  <= window_double_buffer_i(1).dbuffer(208);
	--	s_dataset_double_buffer(1)(12).data(5)  <= window_double_buffer_i(1).dbuffer(209);
	--	s_dataset_double_buffer(1)(12).data(6)  <= window_double_buffer_i(1).dbuffer(210);
	--	s_dataset_double_buffer(1)(12).data(7)  <= window_double_buffer_i(1).dbuffer(211);
	--	s_dataset_double_buffer(1)(12).data(8)  <= window_double_buffer_i(1).dbuffer(212);
	--	s_dataset_double_buffer(1)(12).data(9)  <= window_double_buffer_i(1).dbuffer(213);
	--	s_dataset_double_buffer(1)(12).data(10) <= window_double_buffer_i(1).dbuffer(214);
	--	s_dataset_double_buffer(1)(12).data(11) <= window_double_buffer_i(1).dbuffer(215);
	--	s_dataset_double_buffer(1)(12).data(12) <= window_double_buffer_i(1).dbuffer(216);
	--	s_dataset_double_buffer(1)(12).data(13) <= window_double_buffer_i(1).dbuffer(217);
	--	s_dataset_double_buffer(1)(12).data(14) <= window_double_buffer_i(1).dbuffer(218);
	--	s_dataset_double_buffer(1)(12).data(15) <= window_double_buffer_i(1).dbuffer(219);
	--	s_dataset_double_buffer(1)(12).mask     <= window_double_buffer_i(1).dbuffer(220);
	--	-- dataset buffer 13
	--	s_dataset_double_buffer(1)(13).data(0)  <= window_double_buffer_i(1).dbuffer(221);
	--	s_dataset_double_buffer(1)(13).data(1)  <= window_double_buffer_i(1).dbuffer(222);
	--	s_dataset_double_buffer(1)(13).data(2)  <= window_double_buffer_i(1).dbuffer(223);
	--	s_dataset_double_buffer(1)(13).data(3)  <= window_double_buffer_i(1).dbuffer(224);
	--	s_dataset_double_buffer(1)(13).data(4)  <= window_double_buffer_i(1).dbuffer(225);
	--	s_dataset_double_buffer(1)(13).data(5)  <= window_double_buffer_i(1).dbuffer(226);
	--	s_dataset_double_buffer(1)(13).data(6)  <= window_double_buffer_i(1).dbuffer(227);
	--	s_dataset_double_buffer(1)(13).data(7)  <= window_double_buffer_i(1).dbuffer(228);
	--	s_dataset_double_buffer(1)(13).data(8)  <= window_double_buffer_i(1).dbuffer(229);
	--	s_dataset_double_buffer(1)(13).data(9)  <= window_double_buffer_i(1).dbuffer(230);
	--	s_dataset_double_buffer(1)(13).data(10) <= window_double_buffer_i(1).dbuffer(231);
	--	s_dataset_double_buffer(1)(13).data(11) <= window_double_buffer_i(1).dbuffer(232);
	--	s_dataset_double_buffer(1)(13).data(12) <= window_double_buffer_i(1).dbuffer(233);
	--	s_dataset_double_buffer(1)(13).data(13) <= window_double_buffer_i(1).dbuffer(234);
	--	s_dataset_double_buffer(1)(13).data(14) <= window_double_buffer_i(1).dbuffer(235);
	--	s_dataset_double_buffer(1)(13).data(15) <= window_double_buffer_i(1).dbuffer(236);
	--	s_dataset_double_buffer(1)(13).mask     <= window_double_buffer_i(1).dbuffer(237);
	--	-- dataset buffer 14
	--	s_dataset_double_buffer(1)(14).data(0)  <= window_double_buffer_i(1).dbuffer(238);
	--	s_dataset_double_buffer(1)(14).data(1)  <= window_double_buffer_i(1).dbuffer(239);
	--	s_dataset_double_buffer(1)(14).data(2)  <= window_double_buffer_i(1).dbuffer(240);
	--	s_dataset_double_buffer(1)(14).data(3)  <= window_double_buffer_i(1).dbuffer(241);
	--	s_dataset_double_buffer(1)(14).data(4)  <= window_double_buffer_i(1).dbuffer(242);
	--	s_dataset_double_buffer(1)(14).data(5)  <= window_double_buffer_i(1).dbuffer(243);
	--	s_dataset_double_buffer(1)(14).data(6)  <= window_double_buffer_i(1).dbuffer(244);
	--	s_dataset_double_buffer(1)(14).data(7)  <= window_double_buffer_i(1).dbuffer(245);
	--	s_dataset_double_buffer(1)(14).data(8)  <= window_double_buffer_i(1).dbuffer(246);
	--	s_dataset_double_buffer(1)(14).data(9)  <= window_double_buffer_i(1).dbuffer(247);
	--	s_dataset_double_buffer(1)(14).data(10) <= window_double_buffer_i(1).dbuffer(248);
	--	s_dataset_double_buffer(1)(14).data(11) <= window_double_buffer_i(1).dbuffer(249);
	--	s_dataset_double_buffer(1)(14).data(12) <= window_double_buffer_i(1).dbuffer(250);
	--	s_dataset_double_buffer(1)(14).data(13) <= window_double_buffer_i(1).dbuffer(251);
	--	s_dataset_double_buffer(1)(14).data(14) <= window_double_buffer_i(1).dbuffer(252);
	--	s_dataset_double_buffer(1)(14).data(15) <= window_double_buffer_i(1).dbuffer(253);
	--	s_dataset_double_buffer(1)(14).mask     <= window_double_buffer_i(1).dbuffer(254);
	--	-- dataset buffer 15
	--	s_dataset_double_buffer(1)(15).data(0)  <= window_double_buffer_i(1).dbuffer(255);
	--	s_dataset_double_buffer(1)(15).data(1)  <= window_double_buffer_i(1).dbuffer(256);
	--	s_dataset_double_buffer(1)(15).data(2)  <= window_double_buffer_i(1).dbuffer(257);
	--	s_dataset_double_buffer(1)(15).data(3)  <= window_double_buffer_i(1).dbuffer(258);
	--	s_dataset_double_buffer(1)(15).data(4)  <= window_double_buffer_i(1).dbuffer(259);
	--	s_dataset_double_buffer(1)(15).data(5)  <= window_double_buffer_i(1).dbuffer(260);
	--	s_dataset_double_buffer(1)(15).data(6)  <= window_double_buffer_i(1).dbuffer(261);
	--	s_dataset_double_buffer(1)(15).data(7)  <= window_double_buffer_i(1).dbuffer(262);
	--	s_dataset_double_buffer(1)(15).data(8)  <= window_double_buffer_i(1).dbuffer(263);
	--	s_dataset_double_buffer(1)(15).data(9)  <= window_double_buffer_i(1).dbuffer(264);
	--	s_dataset_double_buffer(1)(15).data(10) <= window_double_buffer_i(1).dbuffer(265);
	--	s_dataset_double_buffer(1)(15).data(11) <= window_double_buffer_i(1).dbuffer(266);
	--	s_dataset_double_buffer(1)(15).data(12) <= window_double_buffer_i(1).dbuffer(267);
	--	s_dataset_double_buffer(1)(15).data(13) <= window_double_buffer_i(1).dbuffer(268);
	--	s_dataset_double_buffer(1)(15).data(14) <= window_double_buffer_i(1).dbuffer(269);
	--	s_dataset_double_buffer(1)(15).data(15) <= window_double_buffer_i(1).dbuffer(270);
	--	s_dataset_double_buffer(1)(15).mask     <= window_double_buffer_i(1).dbuffer(271);

end architecture RTL;
