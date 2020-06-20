library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.cbuf_tb_avs_pkg.all;
use work.comm_avm_cbuf_pkg.all;
use work.comm_cbuf_pkg.all;

entity testbench_top is
end entity testbench_top;

architecture RTL of testbench_top is

	-- clk and rst signals
	signal clk100 : std_logic := '0';
	signal rst    : std_logic := '1';

	-- dut signals

	-- cbuf signals
	signal s_cbuf_flush                : std_logic;
	signal s_cbuf_read                 : std_logic;
	signal s_cbuf_write                : std_logic;
	signal s_cbuf_wrdata               : std_logic_vector((c_COMM_CBUF_DATAW_SIZE - 1) downto 0);
	signal s_cbuf_size                 : std_logic_vector((c_COMM_CBUF_WUSED_SIZE - 1) downto 0);
	signal s_cbuf_addr_offset          : std_logic_vector((c_COMM_AVM_CBUF_ADRESS_SIZE - 1) downto 0);
	signal s_cbuf_avm_slave_rd_status  : t_comm_avm_cbuf_slave_rd_status;
	signal s_cbuf_avm_slave_wr_status  : t_comm_avm_cbuf_slave_wr_status;
	signal s_cbuf_empty                : std_logic;
	signal s_cbuf_usedw                : std_logic_vector((c_COMM_CBUF_WUSED_SIZE - 1) downto 0);
	signal s_cbuf_full                 : std_logic;
	signal s_cbuf_ready                : std_logic;
	signal s_cbuf_rddata               : std_logic_vector((c_COMM_CBUF_DATAW_SIZE - 1) downto 0);
	signal s_cbuf_datavalid            : std_logic;
	signal s_cbuf_avm_slave_rd_control : t_comm_avm_cbuf_slave_rd_control;
	signal s_cbuf_avm_slave_wr_control : t_comm_avm_cbuf_slave_wr_control;

	-- avm signals
	signal s_cbuf_tb_avs_memory_area : t_cbuf_tb_avs_memory_area;

begin

	clk100 <= not clk100 after 5 ns;    -- 100 MHz
	rst    <= '0' after 100 ns;

	cbuf_stimuli_inst : entity work.cbuf_stimuli
		port map(
			clk_i              => clk100,
			rst_i              => rst,
			cbuf_empty_i       => s_cbuf_empty,
			cbuf_usedw_i       => s_cbuf_usedw,
			cbuf_full_i        => s_cbuf_full,
			cbuf_ready_i       => s_cbuf_ready,
			cbuf_rddata_i      => s_cbuf_rddata,
			cbuf_datavalid_i   => s_cbuf_datavalid,
			cbuf_flush_o       => s_cbuf_flush,
			cbuf_read_o        => s_cbuf_read,
			cbuf_write_o       => s_cbuf_write,
			cbuf_wrdata_o      => s_cbuf_wrdata,
			cbuf_size_o        => s_cbuf_size,
			cbuf_addr_offset_o => s_cbuf_addr_offset
		);

	comm_cbuf_top_inst : entity work.comm_cbuf_top
		port map(
			clk_i                       => clk100,
			rst_i                       => rst,
			cbuf_flush_i                => s_cbuf_flush,
			cbuf_read_i                 => s_cbuf_read,
			cbuf_write_i                => s_cbuf_write,
			cbuf_wrdata_i               => s_cbuf_wrdata,
			cbuf_size_i                 => s_cbuf_size,
			cbuf_addr_offset_i          => s_cbuf_addr_offset,
			cbuf_avm_slave_rd_status_i  => s_cbuf_avm_slave_rd_status,
			cbuf_avm_slave_wr_status_i  => s_cbuf_avm_slave_wr_status,
			cbuf_empty_o                => s_cbuf_empty,
			cbuf_usedw_o                => s_cbuf_usedw,
			cbuf_full_o                 => s_cbuf_full,
			cbuf_ready_o                => s_cbuf_ready,
			cbuf_rddata_o               => s_cbuf_rddata,
			cbuf_datavalid_o            => s_cbuf_datavalid,
			cbuf_avm_slave_rd_control_o => s_cbuf_avm_slave_rd_control,
			cbuf_avm_slave_wr_control_o => s_cbuf_avm_slave_wr_control
		);

	cbuf_tb_avs_read_ent_inst : entity work.cbuf_tb_avs_read_ent
		port map(
			clk_i                               => clk100,
			rst_i                               => rst,
			cbuf_tb_avs_avalon_mm_i.address     => s_cbuf_avm_slave_rd_control.address,
			cbuf_tb_avs_avalon_mm_i.read        => s_cbuf_avm_slave_rd_control.read,
			cbuf_tb_avs_avalon_mm_i.byteenable  => (others => '1'),
			cbuf_tb_avs_memory_area_i           => s_cbuf_tb_avs_memory_area,
			cbuf_tb_avs_avalon_mm_o.readdata    => s_cbuf_avm_slave_rd_status.readdata,
			cbuf_tb_avs_avalon_mm_o.waitrequest => s_cbuf_avm_slave_rd_status.waitrequest
		);

	cbuf_tb_avs_write_ent_inst : entity work.cbuf_tb_avs_write_ent
		port map(
			clk_i                               => clk100,
			rst_i                               => rst,
			cbuf_tb_avs_avalon_mm_i.address     => s_cbuf_avm_slave_wr_control.address,
			cbuf_tb_avs_avalon_mm_i.write       => s_cbuf_avm_slave_wr_control.write,
			cbuf_tb_avs_avalon_mm_i.writedata   => s_cbuf_avm_slave_wr_control.writedata,
			cbuf_tb_avs_avalon_mm_i.byteenable  => (others => '1'),
			cbuf_tb_avs_avalon_mm_o.waitrequest => s_cbuf_avm_slave_wr_status.waitrequest,
			cbuf_tb_avs_memory_area_o           => s_cbuf_tb_avs_memory_area
		);

end architecture RTL;
