library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.comm_avm_cbuf_pkg.all;
use work.comm_cbuf_pkg.all;

entity comm_cbuf_top is
	port(
		clk_i                        : in  std_logic;
		rst_i                        : in  std_logic;
		cbuf_flush_i                 : in  std_logic;
		cbuf_read_i                  : in  std_logic;
		cbuf_write_i                 : in  std_logic;
		cbuf_wrdata_i                : in  std_logic_vector((c_COMM_CBUF_DATAW_SIZE - 1) downto 0);
		cbuf_size_i                  : in  std_logic_vector((c_COMM_CBUF_WUSED_SIZE - 1) downto 0);
		cbuf_addr_offset_i           : in  std_logic_vector((c_COMM_AVM_CBUF_ADRESS_SIZE - 1) downto 0);
		cbuf_avm_slave_readdata_i    : in  std_logic_vector(15 downto 0);
		cbuf_avm_slave_waitrequest_i : in  std_logic;
		cbuf_empty_o                 : out std_logic;
		cbuf_usedw_o                 : out std_logic_vector((c_COMM_CBUF_WUSED_SIZE - 1) downto 0);
		cbuf_full_o                  : out std_logic;
		cbuf_ready_o                 : out std_logic;
		cbuf_rddata_o                : out std_logic_vector((c_COMM_CBUF_DATAW_SIZE - 1) downto 0);
		cbuf_datavalid_o             : out std_logic;
		cbuf_avm_slave_address_o     : out std_logic_vector(63 downto 0);
		cbuf_avm_slave_write_o       : out std_logic;
		cbuf_avm_slave_writedata_o   : out std_logic_vector(15 downto 0);
		cbuf_avm_slave_read_o        : out std_logic
	);
end entity comm_cbuf_top;

architecture RTL of comm_cbuf_top is

	signal s_cbuf_avm_master_rd_status  : t_comm_avm_cbuf_master_rd_status;
	signal s_cbuf_avm_master_rd_control : t_comm_avm_cbuf_master_rd_control;
	signal s_cbuf_avm_master_wr_status  : t_comm_avm_cbuf_master_wr_status;
	signal s_cbuf_avm_master_wr_control : t_comm_avm_cbuf_master_wr_control;

	signal s_cbuf_tail_offset  : std_logic_vector((c_COMM_CBUF_WUSED_SIZE - 1) downto 0);
	signal s_cbuf_empty        : std_logic;
	signal s_cbuf_rd_busy      : std_logic;
	signal s_cbuf_rd_datavalid : std_logic;
	signal s_cbuf_head_offset  : std_logic_vector((c_COMM_CBUF_WUSED_SIZE - 1) downto 0);
	signal s_cbuf_full         : std_logic;
	signal s_cbuf_wr_busy      : std_logic;
	signal s_cbuf_wr_ready     : std_logic;

	signal s_cbuf_registered_size        : std_logic_vector((c_COMM_CBUF_WUSED_SIZE - 1) downto 0);
	signal s_cbuf_registered_addr_offset : std_logic_vector((c_COMM_AVM_CBUF_ADRESS_SIZE - 1) downto 0);

	signal s_avm_slave_rd_control_address : std_logic_vector((c_COMM_AVM_CBUF_ADRESS_SIZE - 1) downto 0);
	signal s_avm_slave_wr_control_address : std_logic_vector((c_COMM_AVM_CBUF_ADRESS_SIZE - 1) downto 0);

begin

	-- comm cbuffer reader controller instantiation
	comm_avm_cbuf_reader_controller_ent_inst : entity work.comm_avm_cbuf_reader_controller_ent
		port map(
			clk_i                         => clk_i,
			rst_i                         => rst_i,
			cbuf_rd_control_i.flush       => cbuf_flush_i,
			cbuf_rd_control_i.read        => cbuf_read_i,
			cbuf_rd_control_i.tail_offset => s_cbuf_tail_offset,
			cbuf_rd_control_i.empty       => s_cbuf_empty,
			cbuf_rd_control_i.addr_offset => s_cbuf_registered_addr_offset,
			cbuf_wr_busy_i                => s_cbuf_wr_busy,
			avm_master_rd_status_i        => s_cbuf_avm_master_rd_status,
			cbuf_rd_status_o.busy         => s_cbuf_rd_busy,
			cbuf_rd_status_o.datavalid    => s_cbuf_rd_datavalid,
			cbuf_rd_status_o.data_word    => cbuf_rddata_o,
			avm_master_rd_control_o       => s_cbuf_avm_master_rd_control
		);

	-- comm cbuffer writer controller instantiation
	comm_avm_cbuf_writer_controller_ent_inst : entity work.comm_avm_cbuf_writer_controller_ent
		port map(
			clk_i                         => clk_i,
			rst_i                         => rst_i,
			cbuf_wr_control_i.flush       => cbuf_flush_i,
			cbuf_wr_control_i.write       => cbuf_write_i,
			cbuf_wr_control_i.data_word   => cbuf_wrdata_i,
			cbuf_wr_control_i.head_offset => s_cbuf_head_offset,
			cbuf_wr_control_i.full        => s_cbuf_full,
			cbuf_wr_control_i.addr_offset => s_cbuf_registered_addr_offset,
			cbuf_rd_busy_i                => s_cbuf_rd_busy,
			avm_master_wr_status_i        => s_cbuf_avm_master_wr_status,
			cbuf_wr_status_o.busy         => s_cbuf_wr_busy,
			cbuf_wr_status_o.ready        => s_cbuf_wr_ready,
			avm_master_wr_control_o       => s_cbuf_avm_master_wr_control
		);

	-- comm avm cbuffer reader instantiation
	comm_avm_cbuf_reader_ent_inst : entity work.comm_avm_cbuf_reader_ent
		port map(
			clk_i                             => clk_i,
			rst_i                             => rst_i,
			avm_master_rd_control_i           => s_cbuf_avm_master_rd_control,
			avm_slave_rd_status_i.readdata    => cbuf_avm_slave_readdata_i,
			avm_slave_rd_status_i.waitrequest => cbuf_avm_slave_waitrequest_i,
			avm_master_rd_status_o            => s_cbuf_avm_master_rd_status,
			avm_slave_rd_control_o.address    => s_avm_slave_rd_control_address,
			avm_slave_rd_control_o.read       => cbuf_avm_slave_read_o
		);

	-- comm avm cbuffer writer instantiation
	comm_avm_cbuf_writer_ent_inst : entity work.comm_avm_cbuf_writer_ent
		port map(
			clk_i                             => clk_i,
			rst_i                             => rst_i,
			avm_master_wr_control_i           => s_cbuf_avm_master_wr_control,
			avm_slave_wr_status_i.waitrequest => cbuf_avm_slave_waitrequest_i,
			avm_master_wr_status_o            => s_cbuf_avm_master_wr_status,
			avm_slave_wr_control_o.address    => s_avm_slave_wr_control_address,
			avm_slave_wr_control_o.write      => cbuf_avm_slave_write_o,
			avm_slave_wr_control_o.writedata  => cbuf_avm_slave_writedata_o
		);

	-- comm cbuffer manager process
	p_cbuf_manager : process(clk_i, rst_i) is
		variable v_cbuf_usedw_cnt : unsigned((c_COMM_CBUF_WUSED_SIZE - 1) downto 0);
	begin
		if (rst_i = '1') then

			s_cbuf_registered_size        <= (others => '1');
			s_cbuf_registered_addr_offset <= (others => '0');
			s_cbuf_tail_offset            <= (others => '0');
			s_cbuf_full                   <= '0';
			s_cbuf_head_offset            <= (others => '0');
			s_cbuf_empty                  <= '1';
			v_cbuf_usedw_cnt              := (others => '0');
			cbuf_usedw_o                  <= (others => '0');

		elsif rising_edge(clk_i) then

			-- check if a flush was requested
			if (cbuf_flush_i = '1') then
				-- a flush was requested
				-- register the buffer configuration
				s_cbuf_registered_size        <= cbuf_size_i;
				s_cbuf_registered_addr_offset <= cbuf_addr_offset_i;
				-- clear all flags and counters
				s_cbuf_tail_offset            <= (others => '0');
				s_cbuf_full                   <= '0';
				s_cbuf_head_offset            <= (others => '0');
				s_cbuf_empty                  <= '1';
				v_cbuf_usedw_cnt              := (others => '0');
			else
				-- a flush was not requested

				-- check if the cbuf reader finised a read (read data is valid)
				if (s_cbuf_rd_datavalid = '1') then
					-- the cbuf reader finised a read (read data is valid)
					-- check if the cbuffer still have data (is not already empty)
					if (s_cbuf_empty = '0') then
						-- the cbuffer still have data (is not already empty)
						-- decrement the used words counter
						v_cbuf_usedw_cnt := v_cbuf_usedw_cnt - 1;
						-- check if the tail offset will overflow
						if (unsigned(s_cbuf_tail_offset) >= (unsigned(s_cbuf_registered_size) - 1)) then
							-- the head offset will overflow
							-- clear the tail offset
							s_cbuf_tail_offset <= (others => '0');
						else
							-- the tail offset will not overflow
							-- increment the tail offset
							s_cbuf_tail_offset <= std_logic_vector(unsigned(s_cbuf_tail_offset) + 1);
						end if;
					end if;
				end if;

				-- check if a write was issued and the cbuffer writer is ready
				if ((cbuf_write_i = '1') and (s_cbuf_wr_ready = '1')) then
					-- a write was issued and the cbuffer writer is ready
					-- check if the cbuffer still have space (is not already full)
					if (s_cbuf_full = '0') then
						-- the cbuffer still have space (is not already full)
						-- increment the used words counter
						v_cbuf_usedw_cnt := v_cbuf_usedw_cnt + 1;
						-- check if the head offset will overflow
						if (unsigned(s_cbuf_head_offset) >= (unsigned(s_cbuf_registered_size) - 1)) then
							-- the head offset will overflow
							-- clear the head offset
							s_cbuf_head_offset <= (others => '0');
						else
							-- the head offset will not overflow
							-- increment the head offset
							s_cbuf_head_offset <= std_logic_vector(unsigned(s_cbuf_head_offset) + 1);
						end if;
					end if;
				end if;

			end if;

			-- check if the cbuffer was filled
			if (v_cbuf_usedw_cnt >= unsigned(s_cbuf_registered_size)) then
				-- the cbuffer was filled
				s_cbuf_full  <= '1';
				s_cbuf_empty <= '0';
			-- check if the cbuffer was emptied 
			elsif (v_cbuf_usedw_cnt = 0) then
				-- the cbuffer was emptied
				s_cbuf_full  <= '0';
				s_cbuf_empty <= '1';
			else
				-- the cbuffer is not empty of full
				s_cbuf_full  <= '0';
				s_cbuf_empty <= '0';
			end if;
			cbuf_usedw_o <= std_logic_vector(v_cbuf_usedw_cnt);

		end if;
	end process p_cbuf_manager;

	-- Outputs Generation and Signal Assignments
	cbuf_empty_o     <= s_cbuf_empty;
	cbuf_full_o      <= s_cbuf_full;
	cbuf_ready_o     <= s_cbuf_wr_ready;
	cbuf_datavalid_o <= s_cbuf_rd_datavalid;

	-- Data Avalon Assignments
	cbuf_avm_slave_address_o <= (s_avm_slave_rd_control_address) or (s_avm_slave_wr_control_address);

end architecture RTL;
