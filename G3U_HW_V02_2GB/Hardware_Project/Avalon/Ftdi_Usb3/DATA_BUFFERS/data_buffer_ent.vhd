library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_buffer_ent is
	port(
		clk_i                 : in  std_logic;
		rst_i                 : in  std_logic;
		-- general inputs
		double_buffer_clear_i : in  std_logic;
		double_buffer_stop_i  : in  std_logic;
		double_buffer_start_i : in  std_logic;
		-- others
		buffer_wrdata_i       : in  std_logic_vector(255 downto 0);
		buffer_wrreq_i        : in  std_logic;
		buffer_rdreq_i        : in  std_logic;
		buffer_wrable_o       : out std_logic;
		buffer_rdable_o       : out std_logic;
		buffer_empty_o        : out std_logic;
		buffer_used_bytes_o   : out std_logic_vector(15 downto 0);
		buffer_full_o         : out std_logic;
		buffer_stat_empty_o   : out std_logic;
		buffer_stat_full_o    : out std_logic;
		buffer_rddata_o       : out std_logic_vector(255 downto 0);
		buffer_rdready_o      : out std_logic;
		buffer_wrready_o      : out std_logic
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
		usedw : std_logic_vector(4 downto 0);
	end record t_data_fifo;

	-- data fifo 0 signals
	signal s_data_fifo : t_data_fifo;

	-- data buffer write fsm type
	type t_data_buffer_write_fsm is (
		STOPPED,
		WAIT_WR_DFIFO,
		WRITE_DFIFO
	);
	-- data buffer write fsm state
	signal s_data_buffer_write_state : t_data_buffer_write_fsm;

	-- data buffer read fsm type
	type t_data_buffer_read_fsm is (
		STOPPED,
		WAIT_RD_DFIFO,
		READ_DFIFO
	);
	-- data buffer read fsm state
	signal s_data_buffer_read_state : t_data_buffer_read_fsm;

	signal s_data_fifo_extended_usedw : std_logic_vector(s_data_fifo.usedw'length downto 0);

begin

	-- data fifo instantiation
	data_buffer_sc_fifo_inst : entity work.data_buffer_sc_fifo
		port map(
			aclr  => rst_i,
			clock => clk_i,
			data  => s_data_fifo.data,
			rdreq => s_data_fifo.rdreq,
			sclr  => s_data_fifo.sclr,
			wrreq => s_data_fifo.wrreq,
			empty => s_data_fifo.empty,
			full  => s_data_fifo.full,
			q     => s_data_fifo.q,
			usedw => s_data_fifo.usedw
		);

	-- data buffer general process
	p_data_buffer : process(clk_i, rst_i) is
	begin
		if (rst_i = '1') then
			-- output signals reset
			buffer_rdready_o          <= '0';
			buffer_wrready_o          <= '0';
			-- others
			-- states
			s_data_buffer_write_state <= STOPPED;
			s_data_buffer_read_state  <= STOPPED;
		elsif rising_edge(clk_i) then

			-- data buffer write fsm
			case (s_data_buffer_write_state) is

				when STOPPED =>
					-- stopped state. do nothing and reset
					s_data_buffer_write_state <= STOPPED;
					buffer_wrready_o          <= '0';
					-- check if a start was issued
					if (double_buffer_start_i = '1') then
						-- start issued, go to normal operation
						s_data_buffer_write_state <= WAIT_WR_DFIFO;
					end if;

				when WAIT_WR_DFIFO =>
					-- wait data fifo become availabe for write
					s_data_buffer_write_state <= WAIT_WR_DFIFO;
					buffer_wrready_o          <= '0';
					-- check if data fifo is available (not full)
					if (s_data_fifo.full = '0') then
						-- data fifo is available, go to write data fifo
						s_data_buffer_write_state <= WRITE_DFIFO;
						-- set the data buffer as ready for write
						buffer_wrready_o          <= '1';
					end if;

				when WRITE_DFIFO =>
					-- all data write happens in data fifo
					s_data_buffer_write_state <= WRITE_DFIFO;
					buffer_wrready_o          <= '1';
					-- check if the data fifo is full
					if (s_data_fifo.full = '1') then
						-- data fifo is full, go to waiting data fifo
						s_data_buffer_write_state <= WAIT_WR_DFIFO;
						-- set the data buffer as not ready for write
						buffer_wrready_o          <= '0';
					end if;

			end case;

			-- data buffer read fsm
			case (s_data_buffer_read_state) is

				when STOPPED =>
					-- stopped state. do nothing and reset
					s_data_buffer_read_state <= STOPPED;
					buffer_rdready_o         <= '0';
					-- check if a start was issued
					if (double_buffer_start_i = '1') then
						-- start issued, go to normal operation
						s_data_buffer_read_state <= WAIT_RD_DFIFO;
					end if;

				when WAIT_RD_DFIFO =>
					-- wait until data fifo is released for read
					s_data_buffer_read_state <= WAIT_RD_DFIFO;
					buffer_rdready_o         <= '0';
					-- check if the data fifo was released for read (have data)
					if (s_data_fifo.empty = '0') then
						-- data fifo released for read, go to read data fifo
						s_data_buffer_read_state <= READ_DFIFO;
						-- set the data buffer as ready for read
						buffer_rdready_o         <= '1';
					end if;

				when READ_DFIFO =>
					-- all data read happens in data fifo
					s_data_buffer_read_state <= READ_DFIFO;
					buffer_rdready_o         <= '1';
					-- check if the data fifo is empty
					if (s_data_fifo.empty = '1') then
						-- data fifo is empty, go to waiting data fifo
						s_data_buffer_read_state <= WAIT_RD_DFIFO;
						-- set the data buffer as not ready for read
						buffer_rdready_o         <= '0';
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

	-- data fifo sclear signal reset
	s_data_fifo.sclr <= ('1') when (rst_i = '1') else (double_buffer_clear_i);

	-- wr buffer output signal muxing
	--	buffer_stat_full_o <= ('0') when (rst_i = '1') else (s_data_fifo.full);
	buffer_stat_full_o <= ('0') when (rst_i = '1')
	                      else ('1') when ((s_data_fifo.full = '1') or (unsigned(s_data_fifo.usedw) >= 28))
	                      else ('0');

	-- wr buffer input signal muxing
	-- data fifo write signals
	s_data_fifo.data  <= (others => '0') when (rst_i = '1') else (buffer_wrdata_i);
	s_data_fifo.wrreq <= ('0') when (rst_i = '1') else (buffer_wrreq_i);

	-- rd buffer output signal muxing
	buffer_rddata_o     <= ((others => '0')) when (rst_i = '1') else (s_data_fifo.q);
	buffer_stat_empty_o <= ('1') when (rst_i = '1') else (s_data_fifo.empty);

	-- rd buffer input signal muxing
	-- data fifo read signals
	s_data_fifo.rdreq <= ('0') when (rst_i = '1') else (buffer_rdreq_i);

	-- signals assingment

	-- extended usedw signals
	s_data_fifo_extended_usedw(s_data_fifo.usedw'length)                <= s_data_fifo.full;
	s_data_fifo_extended_usedw((s_data_fifo.usedw'length - 1) downto 0) <= s_data_fifo.usedw;

	-- buffer status
	buffer_wrable_o                   <= not (s_data_fifo.full);
	buffer_rdable_o                   <= not (s_data_fifo.empty);
	buffer_empty_o                    <= s_data_fifo.empty;
	buffer_used_bytes_o(15 downto 11) <= (others => '0');
	buffer_used_bytes_o(10 downto 5)  <= s_data_fifo_extended_usedw;
	buffer_used_bytes_o(4 downto 0)   <= (others => '0');
	buffer_full_o                     <= s_data_fifo.full;

end architecture RTL;
