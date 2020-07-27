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
		window_buffer_i         : in  t_windowing_buffer;
		window_data_read_i      : in  std_logic;
		window_mask_read_i      : in  std_logic;
		window_buffer_control_o : out t_windowing_buffer_control;
		window_data_o           : out std_logic_vector(15 downto 0);
		window_mask_o           : out std_logic;
		window_data_valid_o     : out std_logic;
		window_mask_valid_o     : out std_logic;
		window_data_ready_o     : out std_logic;
		window_mask_ready_o     : out std_logic;
		window_buffer_empty_o   : out std_logic;
		window_buffer_0_empty_o : out std_logic;
		window_buffer_1_empty_o : out std_logic
	);
end entity windowing_buffer_ent;

architecture RTL of windowing_buffer_ent is

	signal s_windowing_avsbuff_sc_fifo : t_windowing_avsbuff_sc_fifo;

	signal s_windowing_avsbuff_qword_data : t_windowing_avsbuff_qword_data;

	-- windowing data fifo signals
	signal s_windowing_data_fifo_control : t_windowing_fifo_control;
	signal s_windowing_data_fifo_wr_data : t_windowing_data_fifo_wr_data;
	signal s_windowing_data_fifo_status  : t_windowing_fifo_status;
	signal s_windowing_data_fifo_rd_data : t_windowing_data_fifo_rd_data;

	-- windowing mask fifo signals
	signal s_windowing_mask_fifo_control : t_windowing_fifo_control;
	signal s_windowing_mask_fifo_wr_data : t_windowing_mask_fifo_wr_data;
	signal s_windowing_mask_fifo_status  : t_windowing_fifo_status;
	signal s_windowing_mask_fifo_rd_data : t_windowing_mask_fifo_rd_data;

	-- stopped flag signal
	signal s_stopped_flag : std_logic;

	-- windowing dataset double buffer
	signal s_dataset_buffer : t_windowing_dataset_buffer;

	signal s_buffer_empty : std_logic;

	signal s_buffer_readable   : std_logic;
	signal s_avs_buffer_locked : std_logic;

	type t_buffer_write_fsm is (
		STOPPED,
		BUFFER_WRITE
	);
	signal s_buffer_write_state : t_buffer_write_fsm;

	type t_buffer_read_fsm is (
		STOPPED,
		WAITING_SYNC,
		IDLE,
		DATA_WRITE,
		DATA_DELAY,
		MASK_WRITE,
		MASK_DELAY
	);
	signal s_buffer_read_state : t_buffer_read_fsm;

	signal s_buffer_data_cnt  : natural range 0 to 15;
	signal s_buffer_qword_cnt : natural range 0 to 3;

	signal s_buffer_pixel_cnt : natural range 0 to 3;
	signal s_buffer_mask_cnt  : natural range 0 to 63;

begin

	windowing_avsbuff_sc_fifo_inst : entity work.windowing_avsbuff_sc_fifo
		port map(
			aclr  => rst_i,
			clock => clk_i,
			data  => window_buffer_i.wrdata,
			rdreq => s_windowing_avsbuff_sc_fifo.rdreq,
			sclr  => window_buffer_i.sclr,
			wrreq => window_buffer_i.wrreq,
			empty => s_windowing_avsbuff_sc_fifo.empty,
			full  => s_windowing_avsbuff_sc_fifo.full,
			q     => s_windowing_avsbuff_sc_fifo.rddata,
			usedw => s_windowing_avsbuff_sc_fifo.usedw
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
			window_buffer_control_o.locked            <= '0';
			window_data_o                             <= (others => '0');
			window_mask_o                             <= '0';
			window_data_valid_o                       <= '0';
			window_mask_valid_o                       <= '0';
			s_windowing_avsbuff_sc_fifo.rdreq         <= '0';
			s_windowing_data_fifo_control.read.rdreq  <= '0';
			s_windowing_data_fifo_control.read.sclr   <= '1';
			s_windowing_data_fifo_control.write.wrreq <= '0';
			s_windowing_data_fifo_control.write.sclr  <= '1';
			s_windowing_data_fifo_wr_data.data        <= (others => '0');
			s_windowing_mask_fifo_control.read.rdreq  <= '0';
			s_windowing_mask_fifo_control.read.sclr   <= '1';
			s_windowing_mask_fifo_control.write.wrreq <= '0';
			s_windowing_mask_fifo_control.write.sclr  <= '1';
			s_windowing_mask_fifo_wr_data.data        <= '0';
			s_stopped_flag                            <= '1';
			s_buffer_empty                            <= '1';
			s_buffer_readable                         <= '0';
			s_avs_buffer_locked                       <= '0';
			s_buffer_write_state                      <= STOPPED;
			s_buffer_read_state                       <= STOPPED;
			s_buffer_data_cnt                         <= 0;
			s_buffer_qword_cnt                        <= 0;
			s_buffer_pixel_cnt                        <= 0;
			s_buffer_mask_cnt                         <= 0;
		elsif rising_edge(clk_i) then

			-- data buffer write
			case (s_buffer_write_state) is

				when STOPPED =>
					s_buffer_write_state           <= STOPPED;
					s_buffer_empty                 <= '1';
					s_buffer_readable              <= '0';
					window_buffer_control_o.locked <= '1';
					if (fee_start_signal_i = '1') then
						s_buffer_write_state <= BUFFER_WRITE;
					end if;

				when BUFFER_WRITE =>
					s_buffer_write_state <= BUFFER_WRITE;
					if (s_windowing_avsbuff_sc_fifo.empty = '1') then
						s_buffer_readable <= '0';
						s_buffer_empty    <= '1';
					else
						s_buffer_readable <= '1';
						s_buffer_empty    <= '0';
					end if;
					--					if (s_windowing_avsbuff_sc_fifo.full = '1') then
					if ((s_windowing_avsbuff_sc_fifo.full = '1') or (unsigned(s_windowing_avsbuff_sc_fifo.usedw) >= 28)) then
						window_buffer_control_o.locked <= '1';
					else
						window_buffer_control_o.locked <= '0';
					end if;

			end case;

			-- data buffer read
			case (s_buffer_read_state) is

				when STOPPED =>
					s_buffer_read_state                       <= STOPPED;
					s_windowing_avsbuff_sc_fifo.rdreq         <= '0';
					s_windowing_data_fifo_control.write.wrreq <= '0';
					s_windowing_data_fifo_control.write.sclr  <= '0';
					s_windowing_data_fifo_wr_data.data        <= (others => '0');
					s_windowing_mask_fifo_control.write.wrreq <= '0';
					s_windowing_mask_fifo_control.write.sclr  <= '0';
					s_windowing_mask_fifo_wr_data.data        <= '0';
					s_buffer_data_cnt                         <= 0;
					s_buffer_qword_cnt                        <= 0;
					s_buffer_pixel_cnt                        <= 0;
					s_buffer_mask_cnt                         <= 0;
					s_avs_buffer_locked                       <= '0';
					if (fee_clear_signal_i = '1') then
						s_windowing_data_fifo_control.write.sclr <= '1';
						s_windowing_mask_fifo_control.write.sclr <= '1';
					elsif (fee_start_signal_i = '1') then
						s_buffer_read_state <= WAITING_SYNC;
					end if;

				when WAITING_SYNC =>
					s_buffer_read_state                       <= WAITING_SYNC;
					s_windowing_avsbuff_sc_fifo.rdreq         <= '0';
					s_windowing_data_fifo_control.write.wrreq <= '0';
					s_windowing_data_fifo_control.write.sclr  <= '0';
					s_windowing_data_fifo_wr_data.data        <= (others => '0');
					s_windowing_mask_fifo_control.write.wrreq <= '0';
					s_windowing_mask_fifo_control.write.sclr  <= '0';
					s_windowing_mask_fifo_wr_data.data        <= '0';
					s_buffer_data_cnt                         <= 0;
					s_buffer_qword_cnt                        <= 0;
					s_buffer_pixel_cnt                        <= 0;
					s_buffer_mask_cnt                         <= 0;
					s_avs_buffer_locked                       <= '0';
					if (fee_sync_signal_i = '1') then
						s_buffer_read_state <= IDLE;
					end if;

				when IDLE =>
					s_buffer_read_state                       <= IDLE;
					s_buffer_data_cnt                         <= 0;
					s_buffer_qword_cnt                        <= 0;
					s_buffer_pixel_cnt                        <= 0;
					s_buffer_mask_cnt                         <= 0;
					s_windowing_avsbuff_sc_fifo.rdreq         <= '0';
					s_windowing_data_fifo_control.write.wrreq <= '0';
					s_windowing_data_fifo_wr_data.data        <= (others => '0');
					s_windowing_mask_fifo_control.write.wrreq <= '0';
					s_windowing_mask_fifo_wr_data.data        <= '0';
					s_avs_buffer_locked                       <= '0';
					if (s_buffer_readable = '1') then
						s_buffer_read_state <= DATA_WRITE;
					end if;

				when DATA_WRITE =>
					s_buffer_read_state                       <= DATA_WRITE;
					s_windowing_avsbuff_sc_fifo.rdreq         <= '0';
					s_windowing_data_fifo_control.write.wrreq <= '0';
					s_windowing_data_fifo_wr_data.data        <= (others => '0');
					s_windowing_mask_fifo_control.write.wrreq <= '0';
					s_windowing_mask_fifo_wr_data.data        <= '0';
					if (s_avs_buffer_locked = '0') then
						if (s_windowing_data_fifo_status.write.full = '0') then
							s_buffer_read_state                       <= DATA_DELAY;
							s_windowing_data_fifo_control.write.wrreq <= '1';
							s_windowing_data_fifo_wr_data.data        <= f_pixels_data_little_to_big_endian_single(s_windowing_avsbuff_qword_data(s_buffer_qword_cnt), s_buffer_pixel_cnt);
							-- check if its the last pixel of a qword
							if (s_buffer_pixel_cnt = 3) then
								s_buffer_pixel_cnt <= 0;
								-- check if its the last qword of a sequence
								if (s_buffer_qword_cnt = 3) then
									s_buffer_qword_cnt                <= 0;
									s_windowing_avsbuff_sc_fifo.rdreq <= '1';
									s_avs_buffer_locked               <= '1';
								else
									s_buffer_qword_cnt <= s_buffer_qword_cnt + 1;
								end if;
								if (s_buffer_data_cnt = 15) then
									s_buffer_data_cnt <= 0;
								else
									s_buffer_data_cnt <= s_buffer_data_cnt + 1;
								end if;
							else
								s_buffer_pixel_cnt <= s_buffer_pixel_cnt + 1;
							end if;
						end if;
					else
						if (s_buffer_readable = '1') then
							s_avs_buffer_locked <= '0';
						end if;
					end if;

				when DATA_DELAY =>
					s_buffer_read_state                       <= DATA_WRITE;
					s_windowing_avsbuff_sc_fifo.rdreq         <= '0';
					s_windowing_data_fifo_control.write.wrreq <= '0';
					s_windowing_data_fifo_wr_data.data        <= (others => '0');
					s_windowing_mask_fifo_control.write.wrreq <= '0';
					s_windowing_mask_fifo_wr_data.data        <= '0';
					if (s_buffer_pixel_cnt = 0) then
						if (s_buffer_data_cnt = 0) then
							s_buffer_read_state <= MASK_WRITE;
						end if;
					end if;

				when MASK_WRITE =>
					s_buffer_read_state                       <= MASK_WRITE;
					s_windowing_avsbuff_sc_fifo.rdreq         <= '0';
					s_windowing_data_fifo_control.write.wrreq <= '0';
					s_windowing_data_fifo_wr_data.data        <= (others => '0');
					s_windowing_mask_fifo_control.write.wrreq <= '0';
					s_windowing_mask_fifo_wr_data.data        <= '0';
					if (s_avs_buffer_locked = '0') then
						if (s_windowing_mask_fifo_status.write.full = '0') then
							s_buffer_read_state                       <= MASK_DELAY;
							s_windowing_mask_fifo_control.write.wrreq <= '1';
							s_windowing_mask_fifo_wr_data.data        <= f_mask_conv_single(s_windowing_avsbuff_qword_data(s_buffer_qword_cnt), s_buffer_mask_cnt);
							-- check if its the last mask of a qword
							if (s_buffer_mask_cnt = 63) then
								s_buffer_mask_cnt <= 0;
								-- check if its the last qword of a sequence
								if (s_buffer_qword_cnt = 3) then
									s_buffer_qword_cnt                <= 0;
									s_windowing_avsbuff_sc_fifo.rdreq <= '1';
									s_avs_buffer_locked               <= '1';
								else
									s_buffer_qword_cnt <= s_buffer_qword_cnt + 1;
								end if;
							else
								s_buffer_mask_cnt <= s_buffer_mask_cnt + 1;
							end if;
						end if;
					else
						if (s_buffer_readable = '1') then
							s_avs_buffer_locked <= '0';
						end if;
					end if;

				when MASK_DELAY =>
					s_buffer_read_state                       <= MASK_WRITE;
					s_windowing_avsbuff_sc_fifo.rdreq         <= '0';
					s_windowing_data_fifo_control.write.wrreq <= '0';
					s_windowing_data_fifo_wr_data.data        <= (others => '0');
					s_windowing_mask_fifo_control.write.wrreq <= '0';
					s_windowing_mask_fifo_wr_data.data        <= '0';
					if (s_buffer_mask_cnt = 0) then
						s_buffer_read_state <= DATA_WRITE;
					end if;

			end case;

			-- check if the windowing buffer is stopped
			if (s_stopped_flag = '1') then
				-- windowing buffer stopped, do nothing
				-- clear signals
				window_data_o                            <= (others => '0');
				window_mask_o                            <= '0';
				window_data_valid_o                      <= '0';
				window_mask_valid_o                      <= '0';
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
				window_mask_o                            <= '0';
				window_data_valid_o                      <= '0';
				window_mask_valid_o                      <= '0';
				s_windowing_data_fifo_control.read.rdreq <= '0';
				s_windowing_mask_fifo_control.read.rdreq <= '0';
				-- check if a buffer data read was requested
				if (window_data_read_i = '1') then
					-- read data from the data buffer 0
					s_windowing_data_fifo_control.read.rdreq <= '1';
					window_data_o                            <= s_windowing_data_fifo_rd_data.q;
					window_data_valid_o                      <= '1';
				end if;
				-- check if a buffer mask read was requested	
				if (window_mask_read_i = '1') then
					-- read data from the mask buffer 0
					s_windowing_mask_fifo_control.read.rdreq <= '1';
					window_mask_o                            <= s_windowing_mask_fifo_rd_data.q;
					window_mask_valid_o                      <= '1';
				end if;

			end if;

			-- check if a stop request was received
			if (fee_stop_signal_i = '1') then
				-- stop request received
				-- set stopped flag
				s_stopped_flag       <= '1';
				s_buffer_write_state <= STOPPED;
				s_buffer_read_state  <= STOPPED;
			end if;

		end if;
	end process p_windowing_buffer;

	-- signals assignments
	s_windowing_avsbuff_qword_data(0) <= s_windowing_avsbuff_sc_fifo.rddata(((64 * 0) + 63) downto (64 * 0));
	s_windowing_avsbuff_qword_data(1) <= s_windowing_avsbuff_sc_fifo.rddata(((64 * 1) + 63) downto (64 * 1));
	s_windowing_avsbuff_qword_data(2) <= s_windowing_avsbuff_sc_fifo.rddata(((64 * 2) + 63) downto (64 * 2));
	s_windowing_avsbuff_qword_data(3) <= s_windowing_avsbuff_sc_fifo.rddata(((64 * 3) + 63) downto (64 * 3));

	-- output signals generation:
	window_buffer_empty_o   <= s_buffer_empty;
	window_buffer_0_empty_o <= s_buffer_empty;
	window_buffer_1_empty_o <= s_buffer_empty;
	window_data_ready_o     <= not (s_windowing_data_fifo_status.read.empty);
	window_mask_ready_o     <= not (s_windowing_mask_fifo_status.read.empty);

end architecture RTL;
