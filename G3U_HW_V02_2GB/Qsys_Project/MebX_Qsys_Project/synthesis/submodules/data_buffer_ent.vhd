library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_buffer_ent is
	port(
		clk_i                      : in  std_logic;
		rst_i                      : in  std_logic;
		-- general inputs
		double_buffer_clear_i      : in  std_logic;
		double_buffer_stop_i       : in  std_logic;
		double_buffer_start_i      : in  std_logic;
		-- others
		buffer_data_loaded_i       : in  std_logic;
		buffer_cfg_length_i        : in  std_logic_vector(8 downto 0);
		buffer_wrdata_i            : in  std_logic_vector(255 downto 0);
		buffer_wrreq_i             : in  std_logic;
		buffer_rdreq_i             : in  std_logic;
		buffer_change_i            : in  std_logic;
		buffer_0_wrable_o          : out std_logic;
		buffer_0_rdable_o          : out std_logic;
		buffer_0_empty_o           : out std_logic;
		buffer_0_used_bytes_o      : out std_logic_vector(13 downto 0);
		buffer_0_free_bytes_o      : out std_logic_vector(13 downto 0);
		buffer_0_full_o            : out std_logic;
		buffer_1_wrable_o          : out std_logic;
		buffer_1_rdable_o          : out std_logic;
		buffer_1_empty_o           : out std_logic;
		buffer_1_used_bytes_o      : out std_logic_vector(13 downto 0);
		buffer_1_free_bytes_o      : out std_logic_vector(13 downto 0);
		buffer_1_full_o            : out std_logic;
		double_buffer_wrable_o     : out std_logic;
		double_buffer_rdable_o     : out std_logic;
		double_buffer_empty_o      : out std_logic;
		double_buffer_used_bytes_o : out std_logic_vector(13 downto 0);
		double_buffer_free_bytes_o : out std_logic_vector(13 downto 0);
		double_buffer_full_o       : out std_logic;
		buffer_stat_almost_empty_o : out std_logic;
		buffer_stat_almost_full_o  : out std_logic;
		buffer_stat_empty_o        : out std_logic;
		buffer_stat_full_o         : out std_logic;
		buffer_rddata_o            : out std_logic_vector(255 downto 0);
		buffer_rdready_o           : out std_logic;
		buffer_wrready_o           : out std_logic
	);
end entity data_buffer_ent;

architecture RTL of data_buffer_ent is

	-- data fifo record type
	type t_data_fifo is record
		data  : std_logic_vector(255 downto 0);
		rdreq : std_logic;
		sclr  : std_logic;
		wrreq : std_logic;
		empty : std_logic;
		full  : std_logic;
		q     : std_logic_vector(255 downto 0);
		usedw : std_logic_vector(7 downto 0);
	end record t_data_fifo;

	-- data fifo 0 signals
	signal s_data_fifo_0 : t_data_fifo;

	-- data fifo 1 signals
	signal s_data_fifo_1 : t_data_fifo;

	-- data buffer write fsm type
	type t_data_buffer_write_fsm is (
		STOPPED,
		WAIT_WR_DFIFO_0,
		WRITE_DFIFO_0,
		WAIT_WR_DFIFO_1,
		WRITE_DFIFO_1
	);
	-- data buffer write fsm state
	signal s_data_buffer_write_state : t_data_buffer_write_fsm;

	-- data buffer read fsm type
	type t_data_buffer_read_fsm is (
		STOPPED,
		WAIT_RD_DFIFO_0,
		READ_DFIFO_0,
		WAIT_RD_DFIFO_1,
		READ_DFIFO_1
	);
	-- data buffer read fsm state
	signal s_data_buffer_read_state : t_data_buffer_read_fsm;

	signal s_wr_data_buffer_selection : natural range 0 to 2 := 2;
	signal s_rd_data_buffer_selection : natural range 0 to 2 := 2;

	signal s_data_fifo_0_rdhold : std_logic;
	signal s_data_fifo_1_rdhold : std_logic;

	signal s_data_fifo_0_wrhold : std_logic;
	signal s_data_fifo_1_wrhold : std_logic;

	signal s_data_fifo_0_extended_usedw : std_logic_vector(s_data_fifo_0.usedw'length downto 0);
	signal s_data_fifo_1_extended_usedw : std_logic_vector(s_data_fifo_0.usedw'length downto 0);

begin

	-- data fifo 0 instantiation
	data_buffer_0_sc_fifo_inst : entity work.data_buffer_sc_fifo
		port map(
			aclr  => rst_i,
			clock => clk_i,
			data  => s_data_fifo_0.data,
			rdreq => s_data_fifo_0.rdreq,
			sclr  => s_data_fifo_0.sclr,
			wrreq => s_data_fifo_0.wrreq,
			empty => s_data_fifo_0.empty,
			full  => s_data_fifo_0.full,
			q     => s_data_fifo_0.q,
			usedw => s_data_fifo_0.usedw
		);

	-- data fifo 1 instantiation
	data_buffer_1_sc_fifo_inst : entity work.data_buffer_sc_fifo
		port map(
			aclr  => rst_i,
			clock => clk_i,
			data  => s_data_fifo_1.data,
			rdreq => s_data_fifo_1.rdreq,
			sclr  => s_data_fifo_1.sclr,
			wrreq => s_data_fifo_1.wrreq,
			empty => s_data_fifo_1.empty,
			full  => s_data_fifo_1.full,
			q     => s_data_fifo_1.q,
			usedw => s_data_fifo_1.usedw
		);

	-- data buffer general process
	p_data_buffer : process(clk_i, rst_i) is
	begin
		if (rst_i = '1') then
			-- output signals reset
			buffer_rdready_o           <= '0';
			buffer_wrready_o           <= '0';
			buffer_0_rdable_o          <= '0';
			buffer_0_wrable_o          <= '0';
			buffer_1_rdable_o          <= '0';
			buffer_1_wrable_o          <= '0';
			double_buffer_rdable_o     <= '0';
			double_buffer_wrable_o     <= '0';
			-- others
			s_wr_data_buffer_selection <= 2;
			s_rd_data_buffer_selection <= 2;
			s_data_fifo_0_rdhold       <= '1';
			s_data_fifo_1_rdhold       <= '1';
			s_data_fifo_0_wrhold       <= '0';
			s_data_fifo_1_wrhold       <= '0';
			-- states
			s_data_buffer_write_state  <= STOPPED;
			s_data_buffer_read_state   <= STOPPED;
		elsif rising_edge(clk_i) then

			-- data buffer write fsm
			case (s_data_buffer_write_state) is

				when STOPPED =>
					-- stopped state. do nothing and reset
					s_data_buffer_write_state  <= STOPPED;
					buffer_wrready_o           <= '0';
					buffer_0_wrable_o          <= '0';
					buffer_1_wrable_o          <= '0';
					double_buffer_wrable_o     <= '0';
					s_wr_data_buffer_selection <= 2;
					s_data_fifo_0_rdhold       <= '1';
					s_data_fifo_1_rdhold       <= '1';
					-- check if a start was issued
					if (double_buffer_start_i = '1') then
						-- start issued, go to normal operation
						s_data_buffer_write_state <= WAIT_WR_DFIFO_0;
					end if;

				when WAIT_WR_DFIFO_0 =>
					-- wait data fifo 0 become availabe for write
					s_wr_data_buffer_selection <= 2;
					s_data_buffer_write_state  <= WAIT_WR_DFIFO_0;
					buffer_wrready_o           <= '0';
					buffer_0_wrable_o          <= '0';
					double_buffer_wrable_o     <= '0';
					-- check if data fifo 0 is available (empty)
					if ((s_data_fifo_0.empty = '1') and (s_data_fifo_0_wrhold = '0')) then
						-- data fifo 0 is available, go to write data fifo 0 
						s_wr_data_buffer_selection <= 0;
						s_data_buffer_write_state  <= WRITE_DFIFO_0;
						-- hold the data fifo 0 for read
						s_data_fifo_0_rdhold       <= '1';
						--						-- keep the data fifo 0 released for write
						--						s_data_fifo_0_wrhold       <= '0';
						-- set the data buffer as ready for write
						buffer_wrready_o           <= '1';
						buffer_0_wrable_o          <= '1';
						double_buffer_wrable_o     <= '1';
					end if;

				when WRITE_DFIFO_0 =>
					-- all data write happens in data fifo 0
					s_wr_data_buffer_selection <= 0;
					s_data_buffer_write_state  <= WRITE_DFIFO_0;
					s_data_fifo_0_rdhold       <= '1';
					--					s_data_fifo_0_wrhold       <= '0';
					buffer_wrready_o           <= '1';
					buffer_0_wrable_o          <= '1';
					double_buffer_wrable_o     <= '1';
					-- check if the data fifo 0 is full or the fee data is loaded  (start using data fifo 1 and release data fifo 0 for read)
					if ((s_data_fifo_0_extended_usedw = buffer_cfg_length_i) or (buffer_data_loaded_i = '1')) then
						-- data fifo 0 is full, go to waiting data fifo 1
						s_wr_data_buffer_selection <= 2;
						s_data_buffer_write_state  <= WAIT_WR_DFIFO_1;
						-- release data fifo 0 for read
						s_data_fifo_0_rdhold       <= '0';
						--						-- hold data fifo 0 for write
						--						s_data_fifo_0_wrhold       <= '1';
						-- set the data buffer as not ready for write
						buffer_wrready_o           <= '0';
						buffer_0_wrable_o          <= '0';
						double_buffer_wrable_o     <= '0';
					end if;

				when WAIT_WR_DFIFO_1 =>
					-- wait data fifo 1 become availabe for write
					s_wr_data_buffer_selection <= 2;
					s_data_buffer_write_state  <= WAIT_WR_DFIFO_1;
					buffer_wrready_o           <= '0';
					buffer_1_wrable_o          <= '0';
					double_buffer_wrable_o     <= '0';
					-- check if data fifo 1 is available (empty)
					if ((s_data_fifo_1.empty = '1') and (s_data_fifo_1_wrhold = '0')) then
						-- data fifo 1 is available, go to write data fifo 1 
						s_wr_data_buffer_selection <= 1;
						s_data_buffer_write_state  <= WRITE_DFIFO_1;
						-- hold the data fifo 1 for read
						s_data_fifo_1_rdhold       <= '1';
						--						-- keep the data fifo 1 released for write
						--						s_data_fifo_1_wrhold       <= '0';
						-- set the data buffer as ready for write
						buffer_wrready_o           <= '1';
						buffer_1_wrable_o          <= '1';
						double_buffer_wrable_o     <= '1';
					end if;

				when WRITE_DFIFO_1 =>
					-- all data write happens in data fifo 1
					s_wr_data_buffer_selection <= 1;
					s_data_buffer_write_state  <= WRITE_DFIFO_1;
					s_data_fifo_1_rdhold       <= '1';
					--					s_data_fifo_1_wrhold       <= '0';
					buffer_wrready_o           <= '1';
					buffer_1_wrable_o          <= '1';
					double_buffer_wrable_o     <= '1';
					-- check if the data fifo 1 is full or the fee data is loaded  (start using data fifo 0 and release data fifo 1 for read)
					if ((s_data_fifo_1_extended_usedw = buffer_cfg_length_i) or (buffer_data_loaded_i = '1')) then
						-- data fifo 1 is full, go to waiting data fifo 0
						s_wr_data_buffer_selection <= 2;
						s_data_buffer_write_state  <= WAIT_WR_DFIFO_0;
						-- release data fifo 1 for read
						s_data_fifo_1_rdhold       <= '0';
						--						-- hold data fifo 1 for write
						--						s_data_fifo_1_wrhold       <= '1';
						-- set the data buffer as not ready for write
						buffer_wrready_o           <= '0';
						buffer_1_wrable_o          <= '0';
						double_buffer_wrable_o     <= '0';
					end if;

			end case;

			-- data buffer read fsm

			-- data buffer write fsm
			case (s_data_buffer_read_state) is

				when STOPPED =>
					-- stopped state. do nothing and reset
					s_data_buffer_read_state   <= STOPPED;
					buffer_rdready_o           <= '0';
					buffer_0_rdable_o          <= '0';
					buffer_1_rdable_o          <= '0';
					double_buffer_rdable_o     <= '0';
					s_rd_data_buffer_selection <= 2;
					s_data_fifo_0_wrhold       <= '0';
					s_data_fifo_1_wrhold       <= '0';
					-- check if a start was issued
					if (double_buffer_start_i = '1') then
						-- start issued, go to normal operation
						s_data_buffer_read_state <= WAIT_RD_DFIFO_0;
					end if;

				when WAIT_RD_DFIFO_0 =>
					-- wait until data fifo 0 is released for read
					s_rd_data_buffer_selection <= 2;
					s_data_buffer_read_state   <= WAIT_RD_DFIFO_0;
					buffer_rdready_o           <= '0';
					buffer_0_rdable_o          <= '0';
					double_buffer_rdable_o     <= '0';
					-- check if the data fifo 0 was released for read
					if (s_data_fifo_0_rdhold = '0') then
						-- data fifo 0 released for read, go to read data fifo 0
						s_rd_data_buffer_selection <= 0;
						s_data_buffer_read_state   <= READ_DFIFO_0;
						--						-- keep the data fifo 0 released for read
						--						s_data_fifo_0_rdhold       <= '0';
						-- hold the data fifo 0 for write
						s_data_fifo_0_wrhold       <= '1';
						-- set the data buffer as ready for read
						buffer_rdready_o           <= '1';
						buffer_0_rdable_o          <= '1';
						double_buffer_rdable_o     <= '1';
					end if;

				when READ_DFIFO_0 =>
					-- all data read happens in data fifo 0
					s_rd_data_buffer_selection <= 0;
					s_data_buffer_read_state   <= READ_DFIFO_0;
					--					s_data_fifo_0_rdhold       <= '0';
					s_data_fifo_0_wrhold       <= '1';
					buffer_rdready_o           <= '1';
					buffer_0_rdable_o          <= '1';
					double_buffer_rdable_o     <= '1';
					-- check if the data fifo 0 is empty (start using data fifo 1 and hold data fifo 0 for read)
					if ((s_data_fifo_0.empty = '1') and (buffer_change_i = '1')) then
						-- data fifo 0 is empty, go to waiting data fifo 1
						s_rd_data_buffer_selection <= 2;
						s_data_buffer_read_state   <= WAIT_RD_DFIFO_1;
						--						-- hold data fifo 0 for read
						--						s_data_fifo_0_rdhold       <= '1';
						-- release the data fifo 0 for write
						s_data_fifo_0_wrhold       <= '0';
						-- set the data buffer as not ready for read
						buffer_rdready_o           <= '0';
						buffer_0_rdable_o          <= '0';
						double_buffer_rdable_o     <= '0';
					end if;

				when WAIT_RD_DFIFO_1 =>
					-- wait until data fifo 1 is released for read
					s_rd_data_buffer_selection <= 2;
					s_data_buffer_read_state   <= WAIT_RD_DFIFO_1;
					buffer_rdready_o           <= '0';
					buffer_1_rdable_o          <= '0';
					double_buffer_rdable_o     <= '0';
					-- check if the data fifo 1 was released for read
					if (s_data_fifo_1_rdhold = '0') then
						-- data fifo 1 released for read, go to read data fifo 1
						s_rd_data_buffer_selection <= 1;
						s_data_buffer_read_state   <= READ_DFIFO_1;
						--						-- keep the data fifo 1 released for read
						--						s_data_fifo_1_rdhold       <= '0';
						-- hold the data fifo 1 for write
						s_data_fifo_1_wrhold       <= '1';
						-- set the data buffer as ready for read
						buffer_rdready_o           <= '1';
						buffer_1_rdable_o          <= '1';
						double_buffer_rdable_o     <= '1';
					end if;

				when READ_DFIFO_1 =>
					-- all data read happens in data fifo 1
					s_rd_data_buffer_selection <= 1;
					s_data_buffer_read_state   <= READ_DFIFO_1;
					--					s_data_fifo_1_rdhold       <= '0';
					s_data_fifo_1_wrhold       <= '1';
					buffer_rdready_o           <= '1';
					buffer_1_rdable_o          <= '1';
					double_buffer_rdable_o     <= '1';
					-- check if the data fifo 1 is empty (start using data fifo 0 and hold data fifo 1 for read)
					if ((s_data_fifo_1.empty = '1') and (buffer_change_i = '1')) then
						-- data fifo 1 is empty, go to waiting data fifo 0
						s_rd_data_buffer_selection <= 2;
						s_data_buffer_read_state   <= WAIT_RD_DFIFO_0;
						--						-- hold data fifo 1 for read
						--						s_data_fifo_1_rdhold       <= '1';
						-- release the data fifo 1 for write
						s_data_fifo_1_wrhold       <= '0';
						-- set the data buffer as not ready for read
						buffer_rdready_o           <= '0';
						buffer_1_rdable_o          <= '0';
						double_buffer_rdable_o     <= '0';
					end if;

			end case;

			-- check if a stop was issued
			if (double_buffer_stop_i = '1') then
				-- stop issued, go to stopped
				s_data_buffer_write_state <= STOPPED;
				s_data_buffer_read_state  <= STOPPED;
			end if;

		end if;
	end process p_data_buffer;

	-- data fifo 0 sclear signal reset
	s_data_fifo_0.sclr <= ('1') when (rst_i = '1') else (double_buffer_clear_i);
	-- data fifo 1 sclear signal reset
	s_data_fifo_1.sclr <= ('1') when (rst_i = '1') else (double_buffer_clear_i);

	-- wr buffer output signal muxing
	buffer_stat_almost_full_o <= ('0') when (rst_i = '1')
		else ('1') when ((s_data_fifo_0_extended_usedw = std_logic_vector(unsigned(buffer_cfg_length_i) - 1)) and (s_wr_data_buffer_selection = 0))
		else ('1') when ((s_data_fifo_1_extended_usedw = std_logic_vector(unsigned(buffer_cfg_length_i) - 1)) and (s_wr_data_buffer_selection = 1))
		else ('0');
	buffer_stat_full_o        <= ('0') when (rst_i = '1')
		else ('1') when ((s_data_fifo_0_extended_usedw = buffer_cfg_length_i) and (s_wr_data_buffer_selection = 0))
		else ('1') when ((s_data_fifo_1_extended_usedw = buffer_cfg_length_i) and (s_wr_data_buffer_selection = 1))
		else ('0');

	-- wr buffer input signal muxing
	-- data fifo 0 write signals
	s_data_fifo_0.data  <= (others => '0') when (rst_i = '1')
		else (buffer_wrdata_i) when (s_wr_data_buffer_selection = 0)
		else ((others => '0'));
	s_data_fifo_0.wrreq <= ('0') when (rst_i = '1')
		else (buffer_wrreq_i) when (s_wr_data_buffer_selection = 0)
		else ('0');
	-- data fifo 1 write signals
	s_data_fifo_1.data  <= (others => '0') when (rst_i = '1')
		else (buffer_wrdata_i) when (s_wr_data_buffer_selection = 1)
		else ((others => '0'));
	s_data_fifo_1.wrreq <= ('0') when (rst_i = '1')
		else (buffer_wrreq_i) when (s_wr_data_buffer_selection = 1)
		else ('0');

	-- rd buffer output signal muxing
	buffer_rddata_o            <= ((others => '0')) when (rst_i = '1')
		else (s_data_fifo_0.q) when (s_rd_data_buffer_selection = 0)
		else (s_data_fifo_1.q) when (s_rd_data_buffer_selection = 1)
		else ((others => '0'));
	buffer_stat_almost_empty_o <= ('0') when (rst_i = '1')
		else ('1') when ((s_data_fifo_0_extended_usedw = std_logic_vector(to_unsigned(1, s_data_fifo_0_extended_usedw'length))) and (s_rd_data_buffer_selection = 0))
		else ('1') when ((s_data_fifo_1_extended_usedw = std_logic_vector(to_unsigned(1, s_data_fifo_1_extended_usedw'length))) and (s_rd_data_buffer_selection = 1))
		else ('0');
	buffer_stat_empty_o        <= ('1') when (rst_i = '1')
		else (s_data_fifo_0.empty) when (s_rd_data_buffer_selection = 0)
		else (s_data_fifo_1.empty) when (s_rd_data_buffer_selection = 1)
		else ('1');

	-- rd buffer input signal muxing
	-- data fifo 0 read signals
	s_data_fifo_0.rdreq <= ('0') when (rst_i = '1')
		else (buffer_rdreq_i) when (s_rd_data_buffer_selection = 0)
		else ('0');
	-- data fifo 1 read signals
	s_data_fifo_1.rdreq <= ('0') when (rst_i = '1')
		else (buffer_rdreq_i) when (s_rd_data_buffer_selection = 1)
		else ('0');

	-- signals assingment

	-- extended usedw signals
	s_data_fifo_0_extended_usedw(s_data_fifo_0.usedw'length)                <= s_data_fifo_0.full;
	s_data_fifo_0_extended_usedw((s_data_fifo_0.usedw'length - 1) downto 0) <= s_data_fifo_0.usedw;
	s_data_fifo_1_extended_usedw(s_data_fifo_1.usedw'length)                <= s_data_fifo_1.full;
	s_data_fifo_1_extended_usedw((s_data_fifo_1.usedw'length - 1) downto 0) <= s_data_fifo_1.usedw;

	-- buffer 0 status
	buffer_0_empty_o                        <= s_data_fifo_0.empty;
	buffer_0_used_bytes_o(13 downto 5)      <= s_data_fifo_0_extended_usedw;
	buffer_0_used_bytes_o(4 downto 0)       <= (others => '0');
	buffer_0_free_bytes_o(13 downto 5)      <= std_logic_vector(unsigned(buffer_cfg_length_i) - unsigned(s_data_fifo_0_extended_usedw));
	buffer_0_free_bytes_o(4 downto 0)       <= (others => '0');
	buffer_0_full_o                         <= s_data_fifo_0.full;
	-- buffer 1 status
	buffer_1_empty_o                        <= s_data_fifo_1.empty;
	buffer_1_used_bytes_o(13 downto 5)      <= s_data_fifo_1_extended_usedw;
	buffer_1_used_bytes_o(4 downto 0)       <= (others => '0');
	buffer_1_free_bytes_o(13 downto 5)      <= std_logic_vector(unsigned(buffer_cfg_length_i) - unsigned(s_data_fifo_1_extended_usedw));
	buffer_1_free_bytes_o(4 downto 0)       <= (others => '0');
	buffer_1_full_o                         <= s_data_fifo_1.full;
	-- double buffer
	double_buffer_empty_o                   <= (s_data_fifo_0.empty) and (s_data_fifo_1.empty);
	double_buffer_used_bytes_o(13 downto 5) <= ((others => '0')) when (rst_i = '1')
		else (s_data_fifo_0_extended_usedw) when (s_rd_data_buffer_selection = 0)
		else (s_data_fifo_1_extended_usedw) when (s_rd_data_buffer_selection = 1)
		else ((others => '0'));
	double_buffer_used_bytes_o(4 downto 0)  <= (others => '0');
	double_buffer_free_bytes_o(13 downto 5) <= (buffer_cfg_length_i) when (rst_i = '1')
		else (std_logic_vector(unsigned(buffer_cfg_length_i) - unsigned(s_data_fifo_0_extended_usedw))) when (s_rd_data_buffer_selection = 0)
		else (std_logic_vector(unsigned(buffer_cfg_length_i) - unsigned(s_data_fifo_1_extended_usedw))) when (s_rd_data_buffer_selection = 1)
		else (buffer_cfg_length_i);
	double_buffer_free_bytes_o(4 downto 0)  <= (others => '0');
	double_buffer_full_o                    <= (s_data_fifo_0.full) and (s_data_fifo_1.full);

end architecture RTL;