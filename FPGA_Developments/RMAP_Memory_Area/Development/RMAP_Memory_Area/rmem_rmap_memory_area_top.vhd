-- rmem_rmap_memory_area_top.vhd

-- This file was auto-generated as a prototype implementation of a module
-- created in component editor.  It ties off all outputs to ground and
-- ignores all inputs.  It needs to be edited to make it do something
-- useful.
-- 
-- This file will not be automatically regenerated.  You should check it in
-- to your version control system if you want to keep it.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.avalon_mm_spacewire_pkg.all;
use work.rmap_mem_area_nfee_pkg.all;

entity rmem_rmap_memory_area_top is
	port(
		reset_i                     : in  std_logic                     := '0'; --          --                   reset_sink.reset
		clk_100_i                   : in  std_logic                     := '0'; --          --            clock_sink_100mhz.clk
		avs_0_rmap_address_i        : in  std_logic_vector(11 downto 0) := (others => '0'); --          avalon_rmap_slave_0.address
		avs_0_rmap_write_i          : in  std_logic                     := '0'; --          --                             .write
		avs_0_rmap_read_i           : in  std_logic                     := '0'; --          --                             .read
		avs_0_rmap_readdata_o       : out std_logic_vector(31 downto 0); --                 --                             .readdata
		avs_0_rmap_writedata_i      : in  std_logic_vector(31 downto 0) := (others => '0'); --                             .writedata
		avs_0_rmap_waitrequest_o    : out std_logic; --                                     --                             .waitrequest
		avs_0_rmap_byteenable_i     : in  std_logic_vector(3 downto 0)  := (others => '0'); --                             .byteenable
		fee_0_rmap_wr_address_i     : in  std_logic_vector(31 downto 0) := (others => '0'); -- conduit_end_fee_rmap_slave_0.wr_address_signal
		fee_0_rmap_write_i          : in  std_logic                     := '0'; --          --                             .write_signal
		fee_0_rmap_writedata_i      : in  std_logic_vector(7 downto 0)  := (others => '0'); --                             .writedata_signal
		fee_0_rmap_rd_address_i     : in  std_logic_vector(31 downto 0) := (others => '0'); --                             .rd_address_signal
		fee_0_rmap_read_i           : in  std_logic                     := '0'; --          --                             .read_signal
		fee_0_rmap_wr_waitrequest_o : out std_logic; --                                     --                             .wr_waitrequest_signal
		fee_0_rmap_readdata_o       : out std_logic_vector(7 downto 0); --                  --                             .readdata_signal
		fee_0_rmap_rd_waitrequest_o : out std_logic; --                                     --                             .rd_waitrequest_signal
		fee_1_rmap_wr_address_i     : in  std_logic_vector(31 downto 0) := (others => '0'); -- conduit_end_fee_rmap_slave_1.wr_address_signal
		fee_1_rmap_write_i          : in  std_logic                     := '0'; --          --                             .write_signal
		fee_1_rmap_writedata_i      : in  std_logic_vector(7 downto 0)  := (others => '0'); --                             .writedata_signal
		fee_1_rmap_rd_address_i     : in  std_logic_vector(31 downto 0) := (others => '0'); --                             .rd_address_signal
		fee_1_rmap_read_i           : in  std_logic                     := '0'; --          --                             .read_signal
		fee_1_rmap_wr_waitrequest_o : out std_logic; --                                     --                             .wr_waitrequest_signal
		fee_1_rmap_readdata_o       : out std_logic_vector(7 downto 0); --                  --                             .readdata_signal
		fee_1_rmap_rd_waitrequest_o : out std_logic; --                                     --                             .rd_waitrequest_signal
		fee_2_rmap_wr_address_i     : in  std_logic_vector(31 downto 0) := (others => '0'); -- conduit_end_fee_rmap_slave_2.wr_address_signal
		fee_2_rmap_write_i          : in  std_logic                     := '0'; --          --                             .write_signal
		fee_2_rmap_writedata_i      : in  std_logic_vector(7 downto 0)  := (others => '0'); --                             .writedata_signal
		fee_2_rmap_rd_address_i     : in  std_logic_vector(31 downto 0) := (others => '0'); --                             .rd_address_signal
		fee_2_rmap_read_i           : in  std_logic                     := '0'; --          --                             .read_signal
		fee_2_rmap_wr_waitrequest_o : out std_logic; --                                     --                             .wr_waitrequest_signal
		fee_2_rmap_readdata_o       : out std_logic_vector(7 downto 0); --                  --                             .readdata_signal
		fee_2_rmap_rd_waitrequest_o : out std_logic; --                                     --                             .rd_waitrequest_signal
		fee_3_rmap_wr_address_i     : in  std_logic_vector(31 downto 0) := (others => '0'); -- conduit_end_fee_rmap_slave_3.wr_address_signal
		fee_3_rmap_write_i          : in  std_logic                     := '0'; --          --                             .write_signal
		fee_3_rmap_writedata_i      : in  std_logic_vector(7 downto 0)  := (others => '0'); --                             .writedata_signal
		fee_3_rmap_rd_address_i     : in  std_logic_vector(31 downto 0) := (others => '0'); --                             .rd_address_signal
		fee_3_rmap_read_i           : in  std_logic                     := '0'; --          --                             .read_signal
		fee_3_rmap_wr_waitrequest_o : out std_logic; --                                     --                             .wr_waitrequest_signal
		fee_3_rmap_readdata_o       : out std_logic_vector(7 downto 0); --                  --                             .readdata_signal
		fee_3_rmap_rd_waitrequest_o : out std_logic; --                                     --                             .rd_waitrequest_signal
		fee_4_rmap_wr_address_i     : in  std_logic_vector(31 downto 0) := (others => '0'); -- conduit_end_fee_rmap_slave_4.wr_address_signal
		fee_4_rmap_write_i          : in  std_logic                     := '0'; --          --                             .write_signal
		fee_4_rmap_writedata_i      : in  std_logic_vector(7 downto 0)  := (others => '0'); --                             .writedata_signal
		fee_4_rmap_rd_address_i     : in  std_logic_vector(31 downto 0) := (others => '0'); --                             .rd_address_signal
		fee_4_rmap_read_i           : in  std_logic                     := '0'; --          --                             .read_signal
		fee_4_rmap_wr_waitrequest_o : out std_logic; --                                     --                             .wr_waitrequest_signal
		fee_4_rmap_readdata_o       : out std_logic_vector(7 downto 0); --                  --                             .readdata_signal
		fee_4_rmap_rd_waitrequest_o : out std_logic; --                                     --                             .rd_waitrequest_signal
		fee_5_rmap_wr_address_i     : in  std_logic_vector(31 downto 0) := (others => '0'); -- conduit_end_fee_rmap_slave_5.wr_address_signal
		fee_5_rmap_write_i          : in  std_logic                     := '0'; --          --                             .write_signal
		fee_5_rmap_writedata_i      : in  std_logic_vector(7 downto 0)  := (others => '0'); --                             .writedata_signal
		fee_5_rmap_rd_address_i     : in  std_logic_vector(31 downto 0) := (others => '0'); --                             .rd_address_signal
		fee_5_rmap_read_i           : in  std_logic                     := '0'; --          --                             .read_signal
		fee_5_rmap_wr_waitrequest_o : out std_logic; --                                     --                             .wr_waitrequest_signal
		fee_5_rmap_readdata_o       : out std_logic_vector(7 downto 0); --                  --                             .readdata_signal
		fee_5_rmap_rd_waitrequest_o : out std_logic; --                                     --                             .rd_waitrequest_signal
		fee_6_rmap_wr_address_i     : in  std_logic_vector(31 downto 0) := (others => '0'); -- conduit_end_fee_rmap_slave_6.wr_address_signal
		fee_6_rmap_write_i          : in  std_logic                     := '0'; --          --                             .write_signal
		fee_6_rmap_writedata_i      : in  std_logic_vector(7 downto 0)  := (others => '0'); --                             .writedata_signal
		fee_6_rmap_rd_address_i     : in  std_logic_vector(31 downto 0) := (others => '0'); --                             .rd_address_signal
		fee_6_rmap_read_i           : in  std_logic                     := '0'; --          --                             .read_signal
		fee_6_rmap_wr_waitrequest_o : out std_logic; --                                     --                             .wr_waitrequest_signal
		fee_6_rmap_readdata_o       : out std_logic_vector(7 downto 0); --                  --                             .readdata_signal
		fee_6_rmap_rd_waitrequest_o : out std_logic; --                                     --                             .rd_waitrequest_signal
		fee_7_rmap_wr_address_i     : in  std_logic_vector(31 downto 0) := (others => '0'); -- conduit_end_fee_rmap_slave_7.wr_address_signal
		fee_7_rmap_write_i          : in  std_logic                     := '0'; --          --                             .write_signal
		fee_7_rmap_writedata_i      : in  std_logic_vector(7 downto 0)  := (others => '0'); --                             .writedata_signal
		fee_7_rmap_rd_address_i     : in  std_logic_vector(31 downto 0) := (others => '0'); --                             .rd_address_signal
		fee_7_rmap_read_i           : in  std_logic                     := '0'; --          --                             .read_signal
		fee_7_rmap_wr_waitrequest_o : out std_logic; --                                     --                             .wr_waitrequest_signal
		fee_7_rmap_readdata_o       : out std_logic_vector(7 downto 0); --                  --                             .readdata_signal
		fee_7_rmap_rd_waitrequest_o : out std_logic ---                                     --                             .rd_waitrequest_signal
	);
end entity rmem_rmap_memory_area_top;

architecture rtl of rmem_rmap_memory_area_top is

	-- alias --
	alias a_avs_clock is clk_100_i;
	alias a_reset is reset_i;

	-- signals --

	-- rmap memory signals
	signal s_rmap_mem_wr_area          : t_rmap_memory_wr_area;
	signal s_rmap_mem_rd_area          : t_rmap_memory_rd_area;
	-- avs 0 signals
	signal s_avs_0_rmap_wr_waitrequest : std_logic;
	signal s_avs_0_rmap_rd_waitrequest : std_logic;
	-- fee rmap signals
	signal s_fee_wr_rmap_in            : t_fee_rmap_write_in;
	signal s_fee_wr_rmap_out           : t_fee_rmap_write_out;
	signal s_fee_rd_rmap_in            : t_fee_rmap_read_in;
	signal s_fee_rd_rmap_out           : t_fee_rmap_read_out;
	-- avs rmap signals
	signal s_avalon_mm_wr_rmap_in      : t_avalon_mm_spacewire_write_in;
	signal s_avalon_mm_wr_rmap_out     : t_avalon_mm_spacewire_write_out;
	signal s_avalon_mm_rd_rmap_in      : t_avalon_mm_spacewire_read_in;
	signal s_avalon_mm_rd_rmap_out     : t_avalon_mm_spacewire_read_out;

begin

	rmap_mem_area_nfee_arbiter_ent_inst : entity work.rmap_mem_area_nfee_arbiter_ent
		port map(
			clk_i                             => a_avs_clock,
			rst_i                             => a_reset,
			fee_0_wr_rmap_i.address           => fee_0_rmap_wr_address_i,
			fee_0_wr_rmap_i.write             => fee_0_rmap_write_i,
			fee_0_wr_rmap_i.writedata         => fee_0_rmap_writedata_i,
			fee_0_rd_rmap_i.address           => fee_0_rmap_rd_address_i,
			fee_0_rd_rmap_i.read              => fee_0_rmap_read_i,
			fee_1_wr_rmap_i.address           => fee_1_rmap_wr_address_i,
			fee_1_wr_rmap_i.write             => fee_1_rmap_write_i,
			fee_1_wr_rmap_i.writedata         => fee_1_rmap_writedata_i,
			fee_1_rd_rmap_i.address           => fee_1_rmap_rd_address_i,
			fee_1_rd_rmap_i.read              => fee_1_rmap_read_i,
			fee_2_wr_rmap_i.address           => fee_2_rmap_wr_address_i,
			fee_2_wr_rmap_i.write             => fee_2_rmap_write_i,
			fee_2_wr_rmap_i.writedata         => fee_2_rmap_writedata_i,
			fee_2_rd_rmap_i.address           => fee_2_rmap_rd_address_i,
			fee_2_rd_rmap_i.read              => fee_2_rmap_read_i,
			fee_3_wr_rmap_i.address           => fee_3_rmap_wr_address_i,
			fee_3_wr_rmap_i.write             => fee_3_rmap_write_i,
			fee_3_wr_rmap_i.writedata         => fee_3_rmap_writedata_i,
			fee_3_rd_rmap_i.address           => fee_3_rmap_rd_address_i,
			fee_3_rd_rmap_i.read              => fee_3_rmap_read_i,
			fee_4_wr_rmap_i.address           => fee_4_rmap_wr_address_i,
			fee_4_wr_rmap_i.write             => fee_4_rmap_write_i,
			fee_4_wr_rmap_i.writedata         => fee_4_rmap_writedata_i,
			fee_4_rd_rmap_i.address           => fee_4_rmap_rd_address_i,
			fee_4_rd_rmap_i.read              => fee_4_rmap_read_i,
			fee_5_wr_rmap_i.address           => fee_5_rmap_wr_address_i,
			fee_5_wr_rmap_i.write             => fee_5_rmap_write_i,
			fee_5_wr_rmap_i.writedata         => fee_5_rmap_writedata_i,
			fee_5_rd_rmap_i.address           => fee_5_rmap_rd_address_i,
			fee_5_rd_rmap_i.read              => fee_5_rmap_read_i,
			fee_6_wr_rmap_i.address           => fee_6_rmap_wr_address_i,
			fee_6_wr_rmap_i.write             => fee_6_rmap_write_i,
			fee_6_wr_rmap_i.writedata         => fee_6_rmap_writedata_i,
			fee_6_rd_rmap_i.address           => fee_6_rmap_rd_address_i,
			fee_6_rd_rmap_i.read              => fee_6_rmap_read_i,
			fee_7_wr_rmap_i.address           => fee_7_rmap_wr_address_i,
			fee_7_wr_rmap_i.write             => fee_7_rmap_write_i,
			fee_7_wr_rmap_i.writedata         => fee_7_rmap_writedata_i,
			fee_7_rd_rmap_i.address           => fee_7_rmap_rd_address_i,
			fee_7_rd_rmap_i.read              => fee_7_rmap_read_i,
			avalon_0_mm_wr_rmap_i.address     => avs_0_rmap_address_i,
			avalon_0_mm_wr_rmap_i.write       => avs_0_rmap_write_i,
			avalon_0_mm_wr_rmap_i.writedata   => avs_0_rmap_writedata_i,
			avalon_0_mm_wr_rmap_i.byteenable  => avs_0_rmap_byteenable_i,
			avalon_0_mm_rd_rmap_i.address     => avs_0_rmap_address_i,
			avalon_0_mm_rd_rmap_i.read        => avs_0_rmap_read_i,
			avalon_0_mm_rd_rmap_i.byteenable  => avs_0_rmap_byteenable_i,
			fee_wr_rmap_i                     => s_fee_wr_rmap_out,
			fee_rd_rmap_i                     => s_fee_rd_rmap_out,
			avalon_mm_wr_rmap_i               => s_avalon_mm_wr_rmap_out,
			avalon_mm_rd_rmap_i               => s_avalon_mm_rd_rmap_out,
			fee_0_wr_rmap_o.waitrequest       => fee_0_rmap_wr_waitrequest_o,
			fee_0_rd_rmap_o.readdata          => fee_0_rmap_readdata_o,
			fee_0_rd_rmap_o.waitrequest       => fee_0_rmap_rd_waitrequest_o,
			fee_1_wr_rmap_o.waitrequest       => fee_1_rmap_wr_waitrequest_o,
			fee_1_rd_rmap_o.readdata          => fee_1_rmap_readdata_o,
			fee_1_rd_rmap_o.waitrequest       => fee_1_rmap_rd_waitrequest_o,
			fee_2_wr_rmap_o.waitrequest       => fee_2_rmap_wr_waitrequest_o,
			fee_2_rd_rmap_o.readdata          => fee_2_rmap_readdata_o,
			fee_2_rd_rmap_o.waitrequest       => fee_2_rmap_rd_waitrequest_o,
			fee_3_wr_rmap_o.waitrequest       => fee_3_rmap_wr_waitrequest_o,
			fee_3_rd_rmap_o.readdata          => fee_3_rmap_readdata_o,
			fee_3_rd_rmap_o.waitrequest       => fee_3_rmap_rd_waitrequest_o,
			fee_4_wr_rmap_o.waitrequest       => fee_4_rmap_wr_waitrequest_o,
			fee_4_rd_rmap_o.readdata          => fee_4_rmap_readdata_o,
			fee_4_rd_rmap_o.waitrequest       => fee_4_rmap_rd_waitrequest_o,
			fee_5_wr_rmap_o.waitrequest       => fee_5_rmap_wr_waitrequest_o,
			fee_5_rd_rmap_o.readdata          => fee_5_rmap_readdata_o,
			fee_5_rd_rmap_o.waitrequest       => fee_5_rmap_rd_waitrequest_o,
			fee_6_wr_rmap_o.waitrequest       => fee_6_rmap_wr_waitrequest_o,
			fee_6_rd_rmap_o.readdata          => fee_6_rmap_readdata_o,
			fee_6_rd_rmap_o.waitrequest       => fee_6_rmap_rd_waitrequest_o,
			fee_7_wr_rmap_o.waitrequest       => fee_7_rmap_wr_waitrequest_o,
			fee_7_rd_rmap_o.readdata          => fee_7_rmap_readdata_o,
			fee_7_rd_rmap_o.waitrequest       => fee_7_rmap_rd_waitrequest_o,
			avalon_0_mm_wr_rmap_o.waitrequest => s_avs_0_rmap_wr_waitrequest,
			avalon_0_mm_rd_rmap_o.readdata    => avs_0_rmap_readdata_o,
			avalon_0_mm_rd_rmap_o.waitrequest => s_avs_0_rmap_rd_waitrequest,
			fee_wr_rmap_o                     => s_fee_wr_rmap_in,
			fee_rd_rmap_o                     => s_fee_rd_rmap_in,
			avalon_mm_wr_rmap_o               => s_avalon_mm_wr_rmap_in,
			avalon_mm_rd_rmap_o               => s_avalon_mm_rd_rmap_in
		);
	avs_0_rmap_waitrequest_o <= (s_avs_0_rmap_wr_waitrequest) and (s_avs_0_rmap_rd_waitrequest);

	rmap_mem_area_nfee_read_inst : entity work.rmap_mem_area_nfee_read
		port map(
			clk_i               => a_avs_clock,
			rst_i               => a_reset,
			fee_rmap_i          => s_fee_rd_rmap_in,
			avalon_mm_rmap_i    => s_avalon_mm_rd_rmap_in,
			rmap_registers_wr_i => s_rmap_mem_wr_area,
			rmap_registers_rd_i => s_rmap_mem_rd_area,
			fee_rmap_o          => s_fee_rd_rmap_out,
			avalon_mm_rmap_o    => s_avalon_mm_rd_rmap_out
		);

	rmap_mem_area_nfee_write_inst : entity work.rmap_mem_area_nfee_write
		port map(
			clk_i               => a_avs_clock,
			rst_i               => a_reset,
			fee_rmap_i          => s_fee_wr_rmap_in,
			avalon_mm_rmap_i    => s_avalon_mm_wr_rmap_in,
			fee_rmap_o          => s_fee_wr_rmap_out,
			avalon_mm_rmap_o    => s_avalon_mm_wr_rmap_out,
			rmap_registers_wr_o => s_rmap_mem_wr_area
		);

end architecture rtl;                   -- of rmem_rmap_memory_area_top
