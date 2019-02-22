library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.windowing_fifo_pkg.all;

entity windowing_buffer_ent is
	generic(
		g_WINDDATA_FIFO_0_MEMORY_BLOCK_TYPE : in positive range 1 to 3; -- 1=MLAB; 2=M9K; 3=M144K
		g_WINDMASK_FIFO_0_MEMORY_BLOCK_TYPE : in positive range 1 to 3; -- 1=MLAB; 2=M9K; 3=M144K
		g_WINDDATA_FIFO_1_MEMORY_BLOCK_TYPE : in positive range 1 to 3; -- 1=MLAB; 2=M9K; 3=M144K
		g_WINDMASK_FIFO_1_MEMORY_BLOCK_TYPE : in positive range 1 to 3 -- 1=MLAB; 2=M9K; 3=M144K
	);
	port(
		clk_i                   : in  std_logic;
		rst_i                   : in  std_logic;
		window_buffer_size_i    : in  std_logic_vector(3 downto 0);
		fee_clear_signal_i      : in  std_logic;
		fee_stop_signal_i       : in  std_logic;
		fee_start_signal_i      : in  std_logic;
		window_data_write_i     : in  std_logic;
		window_mask_write_i     : in  std_logic;
		window_data_i           : in  std_logic_vector(63 downto 0);
		window_data_read_i      : in  std_logic;
		window_mask_read_i      : in  std_logic;
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

	-- windowing data fifo 0 signals
	signal s_windowing_data_fifo_0_control : t_windowing_fifo_control;
	signal s_windowing_data_fifo_0_wr_data : t_windowing_fifo_wr_data;
	signal s_windowing_data_fifo_0_status  : t_windowing_data_fifo_status;
	signal s_windowing_data_fifo_0_rd_data : t_windowing_fifo_rd_data;

	-- windowing mask fifo 0 signals
	signal s_windowing_mask_fifo_0_control : t_windowing_fifo_control;
	signal s_windowing_mask_fifo_0_wr_data : t_windowing_fifo_wr_data;
	signal s_windowing_mask_fifo_0_status  : t_windowing_mask_fifo_status;
	signal s_windowing_mask_fifo_0_rd_data : t_windowing_fifo_rd_data;

	-- windowing data fifo 1 signals
	signal s_windowing_data_fifo_1_control : t_windowing_fifo_control;
	signal s_windowing_data_fifo_1_wr_data : t_windowing_fifo_wr_data;
	signal s_windowing_data_fifo_1_status  : t_windowing_data_fifo_status;
	signal s_windowing_data_fifo_1_rd_data : t_windowing_fifo_rd_data;

	-- windowing mask fifo 1 signals
	signal s_windowing_mask_fifo_1_control : t_windowing_fifo_control;
	signal s_windowing_mask_fifo_1_wr_data : t_windowing_fifo_wr_data;
	signal s_windowing_mask_fifo_1_status  : t_windowing_mask_fifo_status;
	signal s_windowing_mask_fifo_1_rd_data : t_windowing_fifo_rd_data;

	-- windowing buffers active signals 
	signal s_write_data_buffer_0_active : std_logic;
	signal s_write_mask_buffer_0_active : std_logic;
	signal s_read_data_buffer_0_active  : std_logic;
	signal s_read_mask_buffer_0_active  : std_logic;

	-- windowing buffers ready signals
	signal s_data_buffer_0_ready : std_logic;
	signal s_data_buffer_1_ready : std_logic;
	signal s_mask_buffer_0_ready : std_logic;
	signal s_mask_buffer_1_ready : std_logic;

	-- windowing buffers lock signals
	signal s_data_buffer_0_lock : std_logic;
	signal s_data_buffer_1_lock : std_logic;
	signal s_mask_buffer_0_lock : std_logic;
	signal s_mask_buffer_1_lock : std_logic;

	-- windowing buffers size signals
	signal s_window_mask_buffer_size : std_logic_vector(3 downto 0);
	signal s_window_data_buffer_size : std_logic_vector(7 downto 0);

	-- stopped flag signal
	signal s_stopped_flag : std_logic;

begin

	-- windowing data fifo 0 instantiation
	windowing_data_fifo_0_ent_inst : entity work.windowing_data_fifo_ent
		generic map(
			g_FIFO_MEMORY_BLOCK_TYPE => g_WINDDATA_FIFO_0_MEMORY_BLOCK_TYPE
		)
		port map(
			clk_i          => clk_i,
			rst_i          => rst_i,
			fifo_control_i => s_windowing_data_fifo_0_control,
			fifo_wr_data   => s_windowing_data_fifo_0_wr_data,
			fifo_status_o  => s_windowing_data_fifo_0_status,
			fifo_rd_data   => s_windowing_data_fifo_0_rd_data
		);

	-- windowing mask fifo 0 instantiation
	windowing_mask_fifo_0_ent_inst : entity work.windowing_mask_fifo_ent
		generic map(
			g_FIFO_MEMORY_BLOCK_TYPE => g_WINDMASK_FIFO_0_MEMORY_BLOCK_TYPE
		)
		port map(
			clk_i          => clk_i,
			rst_i          => rst_i,
			fifo_control_i => s_windowing_mask_fifo_0_control,
			fifo_wr_data   => s_windowing_mask_fifo_0_wr_data,
			fifo_status_o  => s_windowing_mask_fifo_0_status,
			fifo_rd_data   => s_windowing_mask_fifo_0_rd_data
		);

	-- windowing data fifo 1 instantiation
	windowing_data_fifo_1_ent_inst : entity work.windowing_data_fifo_ent
		generic map(
			g_FIFO_MEMORY_BLOCK_TYPE => g_WINDDATA_FIFO_1_MEMORY_BLOCK_TYPE
		)
		port map(
			clk_i          => clk_i,
			rst_i          => rst_i,
			fifo_control_i => s_windowing_data_fifo_1_control,
			fifo_wr_data   => s_windowing_data_fifo_1_wr_data,
			fifo_status_o  => s_windowing_data_fifo_1_status,
			fifo_rd_data   => s_windowing_data_fifo_1_rd_data
		);

	-- windowing mask fifo 1 instantiation
	windowing_mask_fifo_1_ent_inst : entity work.windowing_mask_fifo_ent
		generic map(
			g_FIFO_MEMORY_BLOCK_TYPE => g_WINDMASK_FIFO_1_MEMORY_BLOCK_TYPE
		)
		port map(
			clk_i          => clk_i,
			rst_i          => rst_i,
			fifo_control_i => s_windowing_mask_fifo_1_control,
			fifo_wr_data   => s_windowing_mask_fifo_1_wr_data,
			fifo_status_o  => s_windowing_mask_fifo_1_status,
			fifo_rd_data   => s_windowing_mask_fifo_1_rd_data
		);

	p_windowing_buffer : process(clk_i, rst_i) is
	begin
		if (rst_i = '1') then
			window_data_o                               <= (others => '0');
			window_mask_o                               <= (others => '0');
			s_windowing_data_fifo_0_control.read.rdreq  <= '0';
			s_windowing_data_fifo_0_control.read.sclr   <= '1';
			s_windowing_data_fifo_0_control.write.wrreq <= '0';
			s_windowing_data_fifo_0_control.write.sclr  <= '1';
			s_windowing_data_fifo_0_wr_data.data        <= (others => '0');
			s_windowing_mask_fifo_0_control.read.rdreq  <= '0';
			s_windowing_mask_fifo_0_control.read.sclr   <= '1';
			s_windowing_mask_fifo_0_control.write.wrreq <= '0';
			s_windowing_mask_fifo_0_control.write.sclr  <= '1';
			s_windowing_mask_fifo_0_wr_data.data        <= (others => '0');
			s_windowing_data_fifo_1_control.read.rdreq  <= '0';
			s_windowing_data_fifo_1_control.read.sclr   <= '1';
			s_windowing_data_fifo_1_control.write.wrreq <= '0';
			s_windowing_data_fifo_1_control.write.sclr  <= '1';
			s_windowing_data_fifo_1_wr_data.data        <= (others => '0');
			s_windowing_mask_fifo_1_control.read.rdreq  <= '0';
			s_windowing_mask_fifo_1_control.read.sclr   <= '1';
			s_windowing_mask_fifo_1_control.write.wrreq <= '0';
			s_windowing_mask_fifo_1_control.write.sclr  <= '1';
			s_windowing_mask_fifo_1_wr_data.data        <= (others => '0');
			s_write_data_buffer_0_active                <= '1';
			s_write_mask_buffer_0_active                <= '1';
			s_read_data_buffer_0_active                 <= '1';
			s_read_mask_buffer_0_active                 <= '1';
			s_data_buffer_0_ready                       <= '0';
			s_data_buffer_1_ready                       <= '0';
			s_mask_buffer_0_ready                       <= '0';
			s_mask_buffer_1_ready                       <= '0';
			s_data_buffer_0_lock                        <= '0';
			s_data_buffer_1_lock                        <= '0';
			s_mask_buffer_0_lock                        <= '0';
			s_mask_buffer_1_lock                        <= '0';
			s_stopped_flag                              <= '1';
		elsif rising_edge(clk_i) then

			-- check if the windowing buffer is stopped
			if (s_stopped_flag = '1') then
				-- windowing buffer stopped, do nothing
				-- clear signals
				window_data_o                               <= (others => '0');
				window_mask_o                               <= (others => '0');
				s_windowing_data_fifo_0_control.read.rdreq  <= '0';
				s_windowing_data_fifo_0_control.read.sclr   <= '0';
				s_windowing_data_fifo_0_control.write.wrreq <= '0';
				s_windowing_data_fifo_0_control.write.sclr  <= '0';
				s_windowing_data_fifo_0_wr_data.data        <= (others => '0');
				s_windowing_mask_fifo_0_control.read.rdreq  <= '0';
				s_windowing_mask_fifo_0_control.read.sclr   <= '0';
				s_windowing_mask_fifo_0_control.write.wrreq <= '0';
				s_windowing_mask_fifo_0_control.write.sclr  <= '0';
				s_windowing_mask_fifo_0_wr_data.data        <= (others => '0');
				s_windowing_data_fifo_1_control.read.rdreq  <= '0';
				s_windowing_data_fifo_1_control.read.sclr   <= '0';
				s_windowing_data_fifo_1_control.write.wrreq <= '0';
				s_windowing_data_fifo_1_control.write.sclr  <= '0';
				s_windowing_data_fifo_1_wr_data.data        <= (others => '0');
				s_windowing_mask_fifo_1_control.read.rdreq  <= '0';
				s_windowing_mask_fifo_1_control.read.sclr   <= '0';
				s_windowing_mask_fifo_1_control.write.wrreq <= '0';
				s_windowing_mask_fifo_1_control.write.sclr  <= '0';
				s_windowing_mask_fifo_1_wr_data.data        <= (others => '0');
				s_write_data_buffer_0_active                <= '1';
				s_write_mask_buffer_0_active                <= '1';
				s_read_data_buffer_0_active                 <= '1';
				s_read_mask_buffer_0_active                 <= '1';
				s_data_buffer_0_ready                       <= '0';
				s_data_buffer_1_ready                       <= '0';
				s_mask_buffer_0_ready                       <= '0';
				s_mask_buffer_1_ready                       <= '0';
				s_data_buffer_0_lock                        <= '0';
				s_data_buffer_1_lock                        <= '0';
				s_mask_buffer_0_lock                        <= '0';
				-- check if a clear request was received
				if (fee_clear_signal_i = '1') then
					-- clear request received
					-- clear buffer
					s_windowing_data_fifo_0_control.read.sclr  <= '1';
					s_windowing_data_fifo_0_control.write.sclr <= '1';
					s_windowing_mask_fifo_0_control.read.sclr  <= '1';
					s_windowing_mask_fifo_0_control.write.sclr <= '1';
					s_windowing_data_fifo_1_control.read.sclr  <= '1';
					s_windowing_data_fifo_1_control.write.sclr <= '1';
					s_windowing_mask_fifo_1_control.read.sclr  <= '1';
					s_windowing_mask_fifo_1_control.write.sclr <= '1';
				end if;
				-- check if a start request was received
				if (fee_start_signal_i = '1') then
					-- start request received
					-- clear stopped flag
					s_stopped_flag <= '0';
				end if;
			else
				-- windowing buffer started, normal operation
				-- check if a stop request was received
				if (fee_stop_signal_i = '1') then
					-- stop request received
					-- set stopped flag
					s_stopped_flag <= '1';
				end if;
				-- normal operation

				window_data_o                               <= (others => '0');
				window_mask_o                               <= (others => '0');
				s_windowing_data_fifo_0_control.read.rdreq  <= '0';
				s_windowing_data_fifo_0_control.read.sclr   <= '0';
				s_windowing_data_fifo_0_control.write.wrreq <= '0';
				s_windowing_data_fifo_0_control.write.sclr  <= '0';
				s_windowing_data_fifo_0_wr_data.data        <= (others => '0');
				s_windowing_mask_fifo_0_control.read.rdreq  <= '0';
				s_windowing_mask_fifo_0_control.read.sclr   <= '0';
				s_windowing_mask_fifo_0_control.write.wrreq <= '0';
				s_windowing_mask_fifo_0_control.write.sclr  <= '0';
				s_windowing_mask_fifo_0_wr_data.data        <= (others => '0');
				s_windowing_data_fifo_1_control.read.rdreq  <= '0';
				s_windowing_data_fifo_1_control.read.sclr   <= '0';
				s_windowing_data_fifo_1_control.write.wrreq <= '0';
				s_windowing_data_fifo_1_control.write.sclr  <= '0';
				s_windowing_data_fifo_1_wr_data.data        <= (others => '0');
				s_windowing_mask_fifo_1_control.read.rdreq  <= '0';
				s_windowing_mask_fifo_1_control.read.sclr   <= '0';
				s_windowing_mask_fifo_1_control.write.wrreq <= '0';
				s_windowing_mask_fifo_1_control.write.sclr  <= '0';
				s_windowing_mask_fifo_1_wr_data.data        <= (others => '0');

				----------------------------------------------------------------------------------------

				-- Windowing Buffer Write
				-- check if a window data write was requested 
				if (window_data_write_i = '1') then
					-- window data write requested
					-- check if the buffer 0 is being used
					if (s_write_data_buffer_0_active = '1') then
						-- buffer 0 is being used
						-- check if the data buffer 0 is unlocked
						if (s_data_buffer_0_lock = '0') then
							-- data buffer 0 is unlocked
							-- check if there is space in the windowing data fifo 0
							if (s_windowing_data_fifo_0_status.write.full = '0') then
								s_windowing_data_fifo_0_control.write.wrreq <= '1';
								s_windowing_data_fifo_0_wr_data.data        <= window_data_i;
								-- check if this will be the last data for the buffer 0
								if (s_windowing_data_fifo_0_status.write.usedw = s_window_data_buffer_size) then
									--							if (s_windowing_data_fifo_0_status.write.usedw = "11111111") then
									-- next data will be stored in buffer 1
									s_write_data_buffer_0_active <= '0';
									-- set the data ready flag
									s_data_buffer_0_ready        <= '1';
									-- lock the data buffer 0
									s_data_buffer_0_lock         <= '1';
								end if;
							end if;
						end if;
					else
						-- buffer 1 is being used
						-- check if a window data write was requested 
						if (window_data_write_i = '1') then
							-- window data write requested
							-- check if the data buffer 1 is unlocked
							if (s_data_buffer_1_lock = '0') then
								-- data buffer 1 is unlocked
								-- check if there is space in the windowing data fifo 1
								if (s_windowing_data_fifo_1_status.write.full = '0') then
									s_windowing_data_fifo_1_control.write.wrreq <= '1';
									s_windowing_data_fifo_1_wr_data.data        <= window_data_i;
									-- check if this will be the last data for the buffer 1
									if (s_windowing_data_fifo_1_status.write.usedw = s_window_data_buffer_size) then
										--								if (s_windowing_data_fifo_1_status.write.usedw = "11111111") then
										-- next data will be stored in buffer 0
										s_write_data_buffer_0_active <= '1';
										-- set the data ready flag
										s_data_buffer_1_ready        <= '1';
										-- lock the data buffer 1
										s_data_buffer_1_lock         <= '1';
									end if;
								end if;
							end if;
						end if;
					end if;
				-- check if a window mask write was requested 
				elsif (window_mask_write_i = '1') then
					-- window mask write requested
					-- check if the buffer 0 is being used
					if (s_write_mask_buffer_0_active = '1') then
						-- buffer 0 is being used
						-- check if the mask buffer 0 is unlocked
						if (s_mask_buffer_0_lock = '0') then
							-- mask buffer 0 is unlocked
							-- check if there is space in the windowing mask fifo 0
							if (s_windowing_mask_fifo_0_status.write.full = '0') then
								s_windowing_mask_fifo_0_control.write.wrreq <= '1';
								s_windowing_mask_fifo_0_wr_data.data        <= window_data_i;
								-- check if this will be the last data for the buffer 0
								if (s_windowing_mask_fifo_0_status.write.usedw = s_window_mask_buffer_size) then
									--							if (s_windowing_mask_fifo_0_status.write.usedw = "1111") then
									-- next data will be stored in buffer 1
									s_write_mask_buffer_0_active <= '0';
									-- set the mask ready flag
									s_mask_buffer_0_ready        <= '1';
									-- lock the data buffer 0
									s_mask_buffer_0_lock         <= '1';
								end if;
							end if;
						end if;
					else
						-- buffer 1 is being used
						-- check if a window mask write was requested 	
						if (window_mask_write_i = '1') then
							-- window mask write requested
							-- check if the mask buffer 1 is unlocked
							if (s_mask_buffer_1_lock = '0') then
								-- mask buffer 1 is unlocked
								-- check if there is space in the windowing mask fifo 1
								if (s_windowing_mask_fifo_1_status.write.full = '0') then
									s_windowing_mask_fifo_1_control.write.wrreq <= '1';
									s_windowing_mask_fifo_1_wr_data.data        <= window_data_i;
									-- check if this will be the last data for the buffer 1
									if (s_windowing_mask_fifo_1_status.write.usedw = s_window_mask_buffer_size) then
										--								if (s_windowing_mask_fifo_1_status.write.usedw = "1111") then
										-- next data will be stored in buffer 0
										s_write_mask_buffer_0_active <= '1';
										-- set the mask ready flag
										s_mask_buffer_1_ready        <= '1';
										-- lock the data buffer 1
										s_mask_buffer_1_lock         <= '1';
									end if;
								end if;
							end if;
						end if;
					end if;
				end if;

				----------------------------------------------------------------------------------------

				-- Windowing Buffer Read
				-- check if a buffer data read was requested
				if (window_data_read_i = '1') then
					-- check if the buffer 0 is being used
					if (s_read_data_buffer_0_active = '1') then
						-- buffer 0 is being used
						-- read data from the data buffer 0
						s_windowing_data_fifo_0_control.read.rdreq <= '1';
						window_data_o                              <= s_windowing_data_fifo_0_rd_data.q;
						-- check if this is the last data for the buffer 0
						if (s_windowing_data_fifo_0_status.read.usedw = "00000001") then
							-- next data will be read from buffer 1
							s_read_data_buffer_0_active <= '0';
							-- clear the data ready flag
							s_data_buffer_0_ready       <= '0';
						end if;
					else
						-- buffer 1 is being used
						-- read data from the data buffer 1
						s_windowing_data_fifo_1_control.read.rdreq <= '1';
						window_data_o                              <= s_windowing_data_fifo_1_rd_data.q;
						-- check if this is the last data for the buffer 1
						if (s_windowing_data_fifo_1_status.read.usedw = "00000001") then
							-- next data will be read from buffer 0
							s_read_data_buffer_0_active <= '1';
							-- clear the data ready flag
							s_data_buffer_1_ready       <= '0';
						end if;
					end if;
				-- check if a buffer mask read was requested	
				elsif (window_mask_read_i = '1') then
					-- check if the buffer 0 is being used
					if (s_read_mask_buffer_0_active = '1') then
						-- buffer 0 is being used
						-- read data from the mask buffer 0
						s_windowing_mask_fifo_0_control.read.rdreq <= '1';
						window_mask_o                              <= s_windowing_mask_fifo_0_rd_data.q;
						-- check if this is the last mask for the buffer 0
						if (s_windowing_mask_fifo_0_status.read.usedw = "0001") then
							-- next data will be read from buffer 1
							s_read_mask_buffer_0_active <= '0';
							-- clear the mask ready flag
							s_mask_buffer_0_ready       <= '0';
						end if;
					else
						-- buffer 1 is being used
						-- read data from the mask buffer 1
						s_windowing_mask_fifo_1_control.read.rdreq <= '1';
						window_mask_o                              <= s_windowing_mask_fifo_1_rd_data.q;
						-- check if this is the last mask for the buffer 1
						if (s_windowing_mask_fifo_1_status.read.usedw = "0001") then
							-- next data will be read from buffer 0
							s_read_mask_buffer_0_active <= '1';
							-- clear the mask ready flag
							s_mask_buffer_1_ready       <= '0';
						end if;
					end if;
				end if;

				----------------------------------------------------------------------------------------

				-- Windowing Buffer Unlock
				-- check if the data buffer 0 is empty
				if (s_windowing_data_fifo_0_status.read.empty = '1') then
					-- data buffer 0 is empty, unlock the data buffer 0
					s_data_buffer_0_lock <= '0';
				end if;
				-- check if the data buffer 1 is empty
				if (s_windowing_data_fifo_1_status.read.empty = '1') then
					-- data buffer 1 is empty, unlock the data buffer 1
					s_data_buffer_1_lock <= '0';
				end if;
				-- check if the mask buffer 0 is empty
				if (s_windowing_mask_fifo_0_status.read.empty = '1') then
					-- mask buffer 0 is empty, unlock the mask buffer 0
					s_mask_buffer_0_lock <= '0';
				end if;
				-- check if the mask buffer 1 is empty
				if (s_windowing_mask_fifo_1_status.read.empty = '1') then
					-- mask buffer 1 is empty, unlock the mask buffer 1
					s_mask_buffer_1_lock <= '0';
				end if;

			end if;

		end if;
	end process p_windowing_buffer;

	-- signals assignments
	s_window_mask_buffer_size             <= window_buffer_size_i;
	s_window_data_buffer_size(7 downto 4) <= window_buffer_size_i;
	s_window_data_buffer_size(3 downto 0) <= "1111";

	-- output signals generation:
	window_buffer_empty_o   <= (((s_windowing_data_fifo_0_status.read.empty) and (s_windowing_mask_fifo_0_status.read.empty)) or ((s_windowing_data_fifo_1_status.read.empty) and (s_windowing_mask_fifo_1_status.read.empty)));
	window_buffer_0_empty_o <= ((s_windowing_data_fifo_0_status.read.empty) and (s_windowing_mask_fifo_0_status.read.empty));
	window_buffer_1_empty_o <= ((s_windowing_data_fifo_1_status.read.empty) and (s_windowing_mask_fifo_1_status.read.empty));
	window_data_ready_o     <= ((s_data_buffer_0_ready) or (s_data_buffer_1_ready));
	window_mask_ready_o     <= ((s_mask_buffer_0_ready) or (s_mask_buffer_1_ready));

end architecture RTL;
