-- nrme_rmap_memory_nfee_area_top.vhd

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

use work.nrme_avalon_mm_rmap_nfee_pkg.all;
use work.nrme_rmap_mem_area_nfee_pkg.all;

entity nrme_rmap_memory_nfee_area_top is
	port(
		reset_i                           : in  std_logic                     := '0'; --          --                   reset_sink.reset
		clk_100_i                         : in  std_logic                     := '0'; --          --            clock_sink_100mhz.clk
		avs_0_rmap_address_i              : in  std_logic_vector(11 downto 0) := (others => '0'); --          avalon_rmap_slave_0.address
		avs_0_rmap_write_i                : in  std_logic                     := '0'; --          --                             .write
		avs_0_rmap_read_i                 : in  std_logic                     := '0'; --          --                             .read
		avs_0_rmap_readdata_o             : out std_logic_vector(31 downto 0); --                 --                             .readdata
		avs_0_rmap_writedata_i            : in  std_logic_vector(31 downto 0) := (others => '0'); --                             .writedata
		avs_0_rmap_waitrequest_o          : out std_logic; --                                     --                             .waitrequest
		avs_0_rmap_byteenable_i           : in  std_logic_vector(3 downto 0)  := (others => '0'); --                             .byteenable
		fee_0_rmap_wr_address_i           : in  std_logic_vector(31 downto 0) := (others => '0'); -- conduit_end_fee_rmap_slave_0.wr_address_signal
		fee_0_rmap_write_i                : in  std_logic                     := '0'; --          --                             .write_signal
		fee_0_rmap_writedata_i            : in  std_logic_vector(7 downto 0)  := (others => '0'); --                             .writedata_signal
		fee_0_rmap_rd_address_i           : in  std_logic_vector(31 downto 0) := (others => '0'); --                             .rd_address_signal
		fee_0_rmap_read_i                 : in  std_logic                     := '0'; --          --                             .read_signal
		fee_0_rmap_wr_waitrequest_o       : out std_logic; --                                     --                             .wr_waitrequest_signal
		fee_0_rmap_readdata_o             : out std_logic_vector(7 downto 0); --                  --                             .readdata_signal
		fee_0_rmap_rd_waitrequest_o       : out std_logic; --                                     --                             .rd_waitrequest_signal
		fee_1_rmap_wr_address_i           : in  std_logic_vector(31 downto 0) := (others => '0'); -- conduit_end_fee_rmap_slave_1.wr_address_signal
		fee_1_rmap_write_i                : in  std_logic                     := '0'; --          --                             .write_signal
		fee_1_rmap_writedata_i            : in  std_logic_vector(7 downto 0)  := (others => '0'); --                             .writedata_signal
		fee_1_rmap_rd_address_i           : in  std_logic_vector(31 downto 0) := (others => '0'); --                             .rd_address_signal
		fee_1_rmap_read_i                 : in  std_logic                     := '0'; --          --                             .read_signal
		fee_1_rmap_wr_waitrequest_o       : out std_logic; --                                     --                             .wr_waitrequest_signal
		fee_1_rmap_readdata_o             : out std_logic_vector(7 downto 0); --                  --                             .readdata_signal
		fee_1_rmap_rd_waitrequest_o       : out std_logic; --                                     --                             .rd_waitrequest_signal
		channel_hk_timecode_control_i     : in  std_logic_vector(1 downto 0); --                  --    conduit_end_channel_hk_in.timecode_control_signal
		channel_hk_timecode_time_i        : in  std_logic_vector(5 downto 0); --                  --                             .timecode_time_signal
		channel_hk_rmap_target_status_i   : in  std_logic_vector(7 downto 0); --                  --                             .rmap_target_status_signal
		channel_hk_rmap_target_indicate_i : in  std_logic; --                                     --                             .rmap_target_indicate_signal
		channel_hk_spw_link_escape_err_i  : in  std_logic; --                                     --                             .spw_link_escape_err_signal
		channel_hk_spw_link_credit_err_i  : in  std_logic; --                                     --                             .spw_link_credit_err_signal
		channel_hk_spw_link_parity_err_i  : in  std_logic; --                                     --                             .spw_link_parity_err_signal
		channel_hk_spw_link_disconnect_i  : in  std_logic; --                                     --                             .spw_link_disconnect_signal
		channel_hk_spw_link_running_i     : in  std_logic; --                                     --                             .spw_link_running_signal
		channel_hk_frame_counter_i        : in  std_logic_vector(15 downto 0); --                 --                             .frame_counter_signal
		channel_hk_frame_number_i         : in  std_logic_vector(1 downto 0) ---                  --                             .frame_number_signal
	);
end entity nrme_rmap_memory_nfee_area_top;

architecture rtl of nrme_rmap_memory_nfee_area_top is

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
	signal s_fee_wr_rmap_in            : t_nrme_nfee_rmap_write_in;
	signal s_fee_wr_rmap_out           : t_nrme_nfee_rmap_write_out;
	signal s_fee_rd_rmap_in            : t_nrme_nfee_rmap_read_in;
	signal s_fee_rd_rmap_out           : t_nrme_nfee_rmap_read_out;
	-- avs rmap signals
	signal s_avalon_mm_wr_rmap_in      : t_nrme_avalon_mm_rmap_nfee_write_in;
	signal s_avalon_mm_wr_rmap_out     : t_nrme_avalon_mm_rmap_nfee_write_out;
	signal s_avalon_mm_rd_rmap_in      : t_nrme_avalon_mm_rmap_nfee_read_in;
	signal s_avalon_mm_rd_rmap_out     : t_nrme_avalon_mm_rmap_nfee_read_out;

begin

	nrme_rmap_mem_area_nfee_arbiter_ent_inst : entity work.nrme_rmap_mem_area_nfee_arbiter_ent
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
			avalon_0_mm_wr_rmap_o.waitrequest => s_avs_0_rmap_wr_waitrequest,
			avalon_0_mm_rd_rmap_o.readdata    => avs_0_rmap_readdata_o,
			avalon_0_mm_rd_rmap_o.waitrequest => s_avs_0_rmap_rd_waitrequest,
			fee_wr_rmap_o                     => s_fee_wr_rmap_in,
			fee_rd_rmap_o                     => s_fee_rd_rmap_in,
			avalon_mm_wr_rmap_o               => s_avalon_mm_wr_rmap_in,
			avalon_mm_rd_rmap_o               => s_avalon_mm_rd_rmap_in
		);
	avs_0_rmap_waitrequest_o <= (s_avs_0_rmap_wr_waitrequest) and (s_avs_0_rmap_rd_waitrequest);

	nrme_rmap_mem_area_nfee_read_inst : entity work.nrme_rmap_mem_area_nfee_read
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

	nrme_rmap_mem_area_nfee_write_inst : entity work.nrme_rmap_mem_area_nfee_write
		port map(
			clk_i               => a_avs_clock,
			rst_i               => a_reset,
			fee_rmap_i          => s_fee_wr_rmap_in,
			avalon_mm_rmap_i    => s_avalon_mm_wr_rmap_in,
			fee_rmap_o          => s_fee_wr_rmap_out,
			avalon_mm_rmap_o    => s_avalon_mm_wr_rmap_out,
			rmap_registers_wr_o => s_rmap_mem_wr_area
		);

	-- nrme nfee rmap error clear manager
	p_nrme_nfee_rmap_error_clear_manager : process(a_avs_clock, a_reset) is
	begin
		if (a_reset) = '1' then
			s_rmap_mem_rd_area.reg_34_hk.error_flags_f_side_pixel_external_sram_buffer_is_full                         <= '0';
			s_rmap_mem_rd_area.reg_34_hk.error_flags_e_side_pixel_external_sram_buffer_is_full                         <= '0';
			s_rmap_mem_rd_area.reg_34_hk.error_flags_window_pixels_fall_outside_cdd_boundary_due_to_wrong_y_coordinate <= '0';
			s_rmap_mem_rd_area.reg_34_hk.error_flags_window_pixels_fall_outside_cdd_boundary_due_to_wrong_x_coordinate <= '0';
			s_rmap_mem_rd_area.reg_34_hk.error_flags_invalid_ccd_mode                                                  <= '0';
		elsif rising_edge(a_avs_clock) then
			-- get error values to the rmap memory area
			s_rmap_mem_rd_area.reg_34_hk.error_flags_f_side_pixel_external_sram_buffer_is_full                         <= '0';
			s_rmap_mem_rd_area.reg_34_hk.error_flags_e_side_pixel_external_sram_buffer_is_full                         <= '0';
			s_rmap_mem_rd_area.reg_34_hk.error_flags_window_pixels_fall_outside_cdd_boundary_due_to_wrong_y_coordinate <= '0';
			s_rmap_mem_rd_area.reg_34_hk.error_flags_window_pixels_fall_outside_cdd_boundary_due_to_wrong_x_coordinate <= '0';
			s_rmap_mem_rd_area.reg_34_hk.error_flags_invalid_ccd_mode                                                  <= '0';
			-- check if a error clear was requested
			if (s_rmap_mem_wr_area.reg_21_config.clear_error_flag = '1') then
				s_rmap_mem_rd_area.reg_34_hk.error_flags_f_side_pixel_external_sram_buffer_is_full                         <= '0';
				s_rmap_mem_rd_area.reg_34_hk.error_flags_e_side_pixel_external_sram_buffer_is_full                         <= '0';
				s_rmap_mem_rd_area.reg_34_hk.error_flags_window_pixels_fall_outside_cdd_boundary_due_to_wrong_y_coordinate <= '0';
				s_rmap_mem_rd_area.reg_34_hk.error_flags_window_pixels_fall_outside_cdd_boundary_due_to_wrong_x_coordinate <= '0';
				s_rmap_mem_rd_area.reg_34_hk.error_flags_invalid_ccd_mode                                                  <= '0';
			end if;
		end if;
	end process p_nrme_nfee_rmap_error_clear_manager;

	-- channel hk for rmap read area
	s_rmap_mem_rd_area.reg_32_hk.spw_status_timecode_from_spw(7 downto 6) <= channel_hk_timecode_control_i;
	s_rmap_mem_rd_area.reg_32_hk.spw_status_timecode_from_spw(5 downto 0) <= channel_hk_timecode_time_i;
	s_rmap_mem_rd_area.reg_32_hk.spw_status_rmap_target_status            <= channel_hk_rmap_target_status_i;
	s_rmap_mem_rd_area.reg_32_hk.spw_status_rmap_target_indicate          <= channel_hk_rmap_target_indicate_i;
	s_rmap_mem_rd_area.reg_32_hk.spw_status_stat_link_escape_error        <= channel_hk_spw_link_escape_err_i;
	s_rmap_mem_rd_area.reg_32_hk.spw_status_stat_link_credit_error        <= channel_hk_spw_link_credit_err_i;
	s_rmap_mem_rd_area.reg_32_hk.spw_status_stat_link_parity_error        <= channel_hk_spw_link_parity_err_i;
	s_rmap_mem_rd_area.reg_32_hk.spw_status_stat_link_disconnect          <= channel_hk_spw_link_disconnect_i;
	s_rmap_mem_rd_area.reg_32_hk.spw_status_stat_link_running             <= channel_hk_spw_link_running_i;
	s_rmap_mem_rd_area.reg_33_hk.frame_counter                            <= channel_hk_frame_counter_i;
	s_rmap_mem_rd_area.reg_33_hk.frame_number                             <= channel_hk_frame_number_i;

end architecture rtl;                   -- of nrme_rmap_memory_nfee_area_top
