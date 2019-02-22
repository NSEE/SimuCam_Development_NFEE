library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity send_buffer_ent is
	generic(
		g_FIFO_0_MEMORY_BLOCK_TYPE : positive range 1 to 3; -- 1=MLAB; 2=M9K; 3=M144K
		g_FIFO_1_MEMORY_BLOCK_TYPE : positive range 1 to 3 -- 1=MLAB; 2=M9K; 3=M144K
	);
	port(
		clk_i                      : in  std_logic;
		rst_i                      : in  std_logic;
		-- general inputs
		fee_clear_signal_i         : in  std_logic;
		fee_stop_signal_i          : in  std_logic;
		fee_start_signal_i         : in  std_logic;
		-- others
		fee_data_loaded_i          : in  std_logic;
		buffer_cfg_length_i        : in  std_logic_vector(15 downto 0);
		--		buffer_clear_i             : in  std_logic;
		buffer_wrdata_i            : in  std_logic_vector(7 downto 0);
		buffer_wrreq_i             : in  std_logic;
		buffer_rdreq_i             : in  std_logic;
		buffer_stat_almost_empty_o : out std_logic;
		buffer_stat_almost_full_o  : out std_logic;
		buffer_stat_empty_o        : out std_logic;
		buffer_stat_full_o         : out std_logic;
		buffer_rddata_o            : out std_logic_vector(7 downto 0);
		buffer_rdready_o           : out std_logic;
		buffer_wrready_o           : out std_logic
	);
end entity send_buffer_ent;

architecture RTL of send_buffer_ent is

	-- data fifo record type
	type t_data_fifo is record
		data         : std_logic_vector(7 downto 0);
		rdreq        : std_logic;
		sclr         : std_logic;
		wrreq        : std_logic;
		almost_empty : std_logic;
		almost_full  : std_logic;
		empty        : std_logic;
		full         : std_logic;
		q            : std_logic_vector(7 downto 0);
		usedw        : std_logic_vector(14 downto 0);
	end record t_data_fifo;

	-- data fifo 0 signals
	signal s_data_fifo_0 : t_data_fifo;

	-- data fifo 1 signals
	signal s_data_fifo_1 : t_data_fifo;

	-- send buffer write fsm type
	type t_send_buffer_write_fsm is (
		STOPPED,
		WAIT_WR_DFIFO_0,
		WRITE_DFIFO_0,
		WAIT_WR_DFIFO_1,
		WRITE_DFIFO_1
	);
	-- send buffer write fsm state
	signal s_send_buffer_write_state : t_send_buffer_write_fsm;

	-- send buffer read fsm type
	type t_send_buffer_read_fsm is (
		STOPPED,
		WAIT_RD_DFIFO_0,
		READ_DFIFO_0,
		WAIT_RD_DFIFO_1,
		READ_DFIFO_1
	);
	-- send buffer read fsm state
	signal s_send_buffer_read_state : t_send_buffer_read_fsm;

	signal s_wr_data_buffer_selection : natural range 0 to 2 := 2;
	signal s_rd_data_buffer_selection : natural range 0 to 2 := 2;

	signal s_data_fifo_0_rdhold : std_logic;
	signal s_data_fifo_1_rdhold : std_logic;

	signal s_data_fifo_0_extended_usedw : std_logic_vector(s_data_fifo_0.usedw'length downto 0);
	signal s_data_fifo_1_extended_usedw : std_logic_vector(s_data_fifo_0.usedw'length downto 0);

begin

	-- data fifo 0 instantiation
	mlab_scfifo_data_buffer_0_inst : if (g_FIFO_0_MEMORY_BLOCK_TYPE = 1) generate
		scfifo_data_buffer_0_inst : entity work.mlab_scfifo_data_buffer
			port map(
				aclr         => rst_i,
				clock        => clk_i,
				data         => s_data_fifo_0.data,
				rdreq        => s_data_fifo_0.rdreq,
				sclr         => s_data_fifo_0.sclr,
				wrreq        => s_data_fifo_0.wrreq,
				almost_empty => s_data_fifo_0.almost_empty,
				almost_full  => s_data_fifo_0.almost_full,
				empty        => s_data_fifo_0.empty,
				full         => s_data_fifo_0.full,
				q            => s_data_fifo_0.q,
				usedw        => s_data_fifo_0.usedw
			);
	end generate mlab_scfifo_data_buffer_0_inst;
	m9k_scfifo_data_buffer_0_inst : if (g_FIFO_0_MEMORY_BLOCK_TYPE = 2) generate
		scfifo_data_buffer_0_inst : entity work.m9k_scfifo_data_buffer
			port map(
				aclr         => rst_i,
				clock        => clk_i,
				data         => s_data_fifo_0.data,
				rdreq        => s_data_fifo_0.rdreq,
				sclr         => s_data_fifo_0.sclr,
				wrreq        => s_data_fifo_0.wrreq,
				almost_empty => s_data_fifo_0.almost_empty,
				almost_full  => s_data_fifo_0.almost_full,
				empty        => s_data_fifo_0.empty,
				full         => s_data_fifo_0.full,
				q            => s_data_fifo_0.q,
				usedw        => s_data_fifo_0.usedw
			);
	end generate m9k_scfifo_data_buffer_0_inst;
	m144k_scfifo_data_buffer_0_inst : if (g_FIFO_0_MEMORY_BLOCK_TYPE = 3) generate
		scfifo_data_buffer_0_inst : entity work.m144k_scfifo_data_buffer
			port map(
				aclr         => rst_i,
				clock        => clk_i,
				data         => s_data_fifo_0.data,
				rdreq        => s_data_fifo_0.rdreq,
				sclr         => s_data_fifo_0.sclr,
				wrreq        => s_data_fifo_0.wrreq,
				almost_empty => s_data_fifo_0.almost_empty,
				almost_full  => s_data_fifo_0.almost_full,
				empty        => s_data_fifo_0.empty,
				full         => s_data_fifo_0.full,
				q            => s_data_fifo_0.q,
				usedw        => s_data_fifo_0.usedw
			);
	end generate m144k_scfifo_data_buffer_0_inst;

	-- data fifo 1 instantiation		
	mlab_scfifo_data_buffer_1_inst : if (g_FIFO_1_MEMORY_BLOCK_TYPE = 1) generate
		scfifo_data_buffer_1_inst : entity work.mlab_scfifo_data_buffer
			port map(
				aclr         => rst_i,
				clock        => clk_i,
				data         => s_data_fifo_1.data,
				rdreq        => s_data_fifo_1.rdreq,
				sclr         => s_data_fifo_1.sclr,
				wrreq        => s_data_fifo_1.wrreq,
				almost_empty => s_data_fifo_1.almost_empty,
				almost_full  => s_data_fifo_1.almost_full,
				empty        => s_data_fifo_1.empty,
				full         => s_data_fifo_1.full,
				q            => s_data_fifo_1.q,
				usedw        => s_data_fifo_1.usedw
			);
	end generate mlab_scfifo_data_buffer_1_inst;
	m9k_scfifo_data_buffer_1_inst : if (g_FIFO_1_MEMORY_BLOCK_TYPE = 2) generate
		scfifo_data_buffer_1_inst : entity work.m9k_scfifo_data_buffer
			port map(
				aclr         => rst_i,
				clock        => clk_i,
				data         => s_data_fifo_1.data,
				rdreq        => s_data_fifo_1.rdreq,
				sclr         => s_data_fifo_1.sclr,
				wrreq        => s_data_fifo_1.wrreq,
				almost_empty => s_data_fifo_1.almost_empty,
				almost_full  => s_data_fifo_1.almost_full,
				empty        => s_data_fifo_1.empty,
				full         => s_data_fifo_1.full,
				q            => s_data_fifo_1.q,
				usedw        => s_data_fifo_1.usedw
			);
	end generate m9k_scfifo_data_buffer_1_inst;
	m144k_scfifo_data_buffer_1_inst : if (g_FIFO_1_MEMORY_BLOCK_TYPE = 3) generate
		scfifo_data_buffer_1_inst : entity work.m144k_scfifo_data_buffer
			port map(
				aclr         => rst_i,
				clock        => clk_i,
				data         => s_data_fifo_1.data,
				rdreq        => s_data_fifo_1.rdreq,
				sclr         => s_data_fifo_1.sclr,
				wrreq        => s_data_fifo_1.wrreq,
				almost_empty => s_data_fifo_1.almost_empty,
				almost_full  => s_data_fifo_1.almost_full,
				empty        => s_data_fifo_1.empty,
				full         => s_data_fifo_1.full,
				q            => s_data_fifo_1.q,
				usedw        => s_data_fifo_1.usedw
			);
	end generate m144k_scfifo_data_buffer_1_inst;

	-- send buffer general process
	p_send_buffer : process(clk_i, rst_i) is
	begin
		if (rst_i = '1') then
			-- output signals reset
			buffer_rdready_o           <= '0';
			buffer_wrready_o           <= '0';
			-- others
			s_wr_data_buffer_selection <= 2;
			s_rd_data_buffer_selection <= 2;
			s_data_fifo_0_rdhold       <= '1';
			s_data_fifo_1_rdhold       <= '1';
			-- states
			s_send_buffer_write_state  <= STOPPED;
			s_send_buffer_read_state   <= STOPPED;
		elsif rising_edge(clk_i) then

			-- send buffer write fsm
			case (s_send_buffer_write_state) is

				when STOPPED =>
					-- stopped state. do nothing and reset
					s_send_buffer_write_state  <= STOPPED;
					buffer_wrready_o           <= '0';
					s_wr_data_buffer_selection <= 2;
					s_data_fifo_0_rdhold       <= '1';
					s_data_fifo_1_rdhold       <= '1';
					-- check if a start was issued
					if (fee_start_signal_i = '1') then
						-- start issued, go to normal operation
						s_send_buffer_write_state <= WAIT_WR_DFIFO_0;
					end if;

				when WAIT_WR_DFIFO_0 =>
					-- wait data fifo 0 become availabe for write
					s_wr_data_buffer_selection <= 2;
					s_send_buffer_write_state  <= WAIT_WR_DFIFO_0;
					buffer_wrready_o           <= '0';
					-- check if data fifo 0 is available (empty)
					if (s_data_fifo_0.empty = '1') then
						-- data fifo 0 is available, go to write data fifo 0 
						s_wr_data_buffer_selection <= 0;
						s_send_buffer_write_state  <= WRITE_DFIFO_0;
						-- hold the data fifo 0 for read
						s_data_fifo_0_rdhold       <= '1';
						-- set the send buffer as ready for write
						buffer_wrready_o           <= '1';
					end if;

				when WRITE_DFIFO_0 =>
					-- all data write happens in data fifo 0
					s_wr_data_buffer_selection <= 0;
					s_send_buffer_write_state  <= WRITE_DFIFO_0;
					s_data_fifo_0_rdhold       <= '1';
					buffer_wrready_o           <= '1';
					-- check if the data fifo 0 is full or the fee data is loaded  (start using data fifo 1 and release data fifo 0 for read)
					if ((s_data_fifo_0_extended_usedw = buffer_cfg_length_i) or (fee_data_loaded_i = '1')) then
						-- data fifo 0 is full, go to waiting data fifo 1
						s_wr_data_buffer_selection <= 2;
						s_send_buffer_write_state  <= WAIT_WR_DFIFO_1;
						-- release data fifo 0 for read
						s_data_fifo_0_rdhold       <= '0';
						-- set the send buffer as not ready for write
						buffer_wrready_o           <= '0';
					end if;

				when WAIT_WR_DFIFO_1 =>
					-- wait data fifo 1 become availabe for write
					s_wr_data_buffer_selection <= 2;
					s_send_buffer_write_state  <= WAIT_WR_DFIFO_1;
					buffer_wrready_o           <= '0';
					-- check if data fifo 1 is available (empty)
					if (s_data_fifo_1.empty = '1') then
						-- data fifo 1 is available, go to write data fifo 1 
						s_wr_data_buffer_selection <= 1;
						s_send_buffer_write_state  <= WRITE_DFIFO_1;
						-- hold the data fifo 1 for read
						s_data_fifo_1_rdhold       <= '1';
						-- set the send buffer as ready for write
						buffer_wrready_o           <= '1';
					end if;

				when WRITE_DFIFO_1 =>
					-- all data write happens in data fifo 1
					s_wr_data_buffer_selection <= 1;
					s_send_buffer_write_state  <= WRITE_DFIFO_1;
					s_data_fifo_1_rdhold       <= '1';
					buffer_wrready_o           <= '1';
					-- check if the data fifo 1 is full or the fee data is loaded  (start using data fifo 0 and release data fifo 1 for read)
					if ((s_data_fifo_1_extended_usedw = buffer_cfg_length_i) or (fee_data_loaded_i = '1')) then
						-- data fifo 1 is full, go to waiting data fifo 0
						s_wr_data_buffer_selection <= 2;
						s_send_buffer_write_state  <= WAIT_WR_DFIFO_0;
						-- release data fifo 1 for read
						s_data_fifo_1_rdhold       <= '0';
						-- set the send buffer as not ready for write
						buffer_wrready_o           <= '0';
					end if;

			end case;

			-- send buffer read fsm

			-- send buffer write fsm
			case (s_send_buffer_read_state) is

				when STOPPED =>
					-- stopped state. do nothing and reset
					s_send_buffer_read_state   <= STOPPED;
					buffer_rdready_o           <= '0';
					s_rd_data_buffer_selection <= 2;
					-- check if a start was issued
					if (fee_start_signal_i = '1') then
						-- start issued, go to normal operation
						s_send_buffer_read_state <= WAIT_RD_DFIFO_0;
					end if;

				when WAIT_RD_DFIFO_0 =>
					-- wait until data fifo 0 is released for read
					s_rd_data_buffer_selection <= 2;
					s_send_buffer_read_state   <= WAIT_RD_DFIFO_0;
					buffer_rdready_o           <= '0';
					-- check if the data fifo 0 was released for read
					if (s_data_fifo_0_rdhold = '0') then
						-- data fifo 0 released for read, go to read data fifo 0
						s_rd_data_buffer_selection <= 0;
						s_send_buffer_read_state   <= READ_DFIFO_0;
						-- keep the data fifo 0 released for read
						s_data_fifo_0_rdhold       <= '0';
						-- set the send buffer as ready for read
						buffer_rdready_o           <= '1';
					end if;

				when READ_DFIFO_0 =>
					-- all data read happens in data fifo 0
					s_rd_data_buffer_selection <= 0;
					s_send_buffer_read_state   <= READ_DFIFO_0;
					s_data_fifo_0_rdhold       <= '0';
					buffer_rdready_o           <= '1';
					-- check if the data fifo 0 is empty (start using data fifo 1 and hold data fifo 0 for read)
					if (s_data_fifo_0.empty = '1') then
						-- data fifo 0 is empty, go to waiting data fifo 1
						s_rd_data_buffer_selection <= 2;
						s_send_buffer_read_state   <= WAIT_RD_DFIFO_1;
						-- hold data fifo 0 for read
						s_data_fifo_0_rdhold       <= '1';
						-- set the send buffer as not ready for read
						buffer_rdready_o           <= '0';
					end if;

				when WAIT_RD_DFIFO_1 =>
					-- wait until data fifo 1 is released for read
					s_rd_data_buffer_selection <= 2;
					s_send_buffer_read_state   <= WAIT_RD_DFIFO_1;
					buffer_rdready_o           <= '0';
					-- check if the data fifo 1 was released for read
					if (s_data_fifo_1_rdhold = '0') then
						-- data fifo 1 released for read, go to read data fifo 1
						s_rd_data_buffer_selection <= 1;
						s_send_buffer_read_state   <= READ_DFIFO_1;
						-- keep the data fifo 1 released for read
						s_data_fifo_1_rdhold       <= '0';
						-- set the send buffer as ready for read
						buffer_rdready_o           <= '1';
					end if;

				when READ_DFIFO_1 =>
					-- all data read happens in data fifo 1
					s_rd_data_buffer_selection <= 1;
					s_send_buffer_read_state   <= READ_DFIFO_1;
					s_data_fifo_1_rdhold       <= '0';
					buffer_rdready_o           <= '1';
					-- check if the data fifo 1 is empty (start using data fifo 0 and hold data fifo 1 for read)
					if (s_data_fifo_1.empty = '1') then
						-- data fifo 1 is empty, go to waiting data fifo 0
						s_rd_data_buffer_selection <= 2;
						s_send_buffer_read_state   <= WAIT_RD_DFIFO_0;
						-- hold data fifo 1 for read
						s_data_fifo_1_rdhold       <= '1';
						-- set the send buffer as not ready for read
						buffer_rdready_o           <= '0';
					end if;

			end case;

			-- check if a stop was issued
			if (fee_stop_signal_i = '1') then
				-- stop issued, go to stopped
				s_send_buffer_write_state <= STOPPED;
				s_send_buffer_read_state  <= STOPPED;
			end if;

		end if;
	end process p_send_buffer;

	-- data fifo 0 sclear signal reset
	s_data_fifo_0.sclr <= ('1') when (rst_i = '1') else (fee_clear_signal_i);
	-- data fifo 1 sclear signal reset
	s_data_fifo_1.sclr <= ('1') when (rst_i = '1') else (fee_clear_signal_i);

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
	--	buffer_stat_almost_empty_o <= ('0') when (rst_i = '1')
	--		else (s_data_fifo_0.almost_empty) when (s_rd_data_buffer_selection = 0)
	--		else (s_data_fifo_1.almost_empty) when (s_rd_data_buffer_selection = 1)
	--		else ('0');
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

end architecture RTL;
