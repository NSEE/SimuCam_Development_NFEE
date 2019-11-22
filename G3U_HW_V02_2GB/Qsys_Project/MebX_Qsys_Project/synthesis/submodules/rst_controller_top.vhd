-- rst_controller_top.vhd

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

use work.avalon_mm_rst_controller_pkg.all;
use work.avalon_mm_rst_controller_registers_pkg.all;

entity rst_controller_top is
	port(
		avalon_slave_rst_controller_address     : in  std_logic_vector(3 downto 0)  := (others => '0'); -- avalon_slave_rst_controller.address
		avalon_slave_rst_controller_write       : in  std_logic                     := '0'; --          --                            .write
		avalon_slave_rst_controller_read        : in  std_logic                     := '0'; --          --                            .read
		avalon_slave_rst_controller_writedata   : in  std_logic_vector(31 downto 0) := (others => '0'); --                            .writedata
		avalon_slave_rst_controller_readdata    : out std_logic_vector(31 downto 0); --                 --                            .readdata
		avalon_slave_rst_controller_waitrequest : out std_logic; --                                     --                            .waitrequest
		clock_sink_clk                          : in  std_logic                     := '0'; --          --                  clock_sink.clk
		reset_sink_reset                        : in  std_logic                     := '0'; --          --                  reset_sink.reset
		reset_source_simucam_reset              : out std_logic; --                                     --        reset_source_simucam.reset
		reset_source_sync_reset                 : out std_logic; --                                     --           reset_source_sync.reset     
		reset_source_rs232_reset                : out std_logic; --                                     --          reset_source_rs232.reset    
		reset_source_sd_card_reset              : out std_logic; --                                     --        reset_source_sd_card.reset  
		reset_source_comm_ch8_reset             : out std_logic; --                                     --       reset_source_comm_ch8.reset 
		reset_source_comm_ch7_reset             : out std_logic; --                                     --       reset_source_comm_ch7.reset 
		reset_source_comm_ch6_reset             : out std_logic; --                                     --       reset_source_comm_ch6.reset 
		reset_source_comm_ch5_reset             : out std_logic; --                                     --       reset_source_comm_ch5.reset 
		reset_source_comm_ch4_reset             : out std_logic; --                                     --       reset_source_comm_ch4.reset 
		reset_source_comm_ch3_reset             : out std_logic; --                                     --       reset_source_comm_ch3.reset 
		reset_source_comm_ch2_reset             : out std_logic; --                                     --       reset_source_comm_ch2.reset 
		reset_source_comm_ch1_reset             : out std_logic --                                      --       reset_source_comm_ch1.reset 
	);
end entity rst_controller_top;

architecture rtl of rst_controller_top is

	alias a_clock is clock_sink_clk;
	alias a_reset is reset_sink_reset;

	-- constants

	-- signals

	-- rst controller avalon mm read signals
	signal s_avalon_mm_rst_controller_read_waitrequest : std_logic;

	-- rst controller avalon mm write signals
	signal s_avalon_mm_rst_controller_write_waitrequest : std_logic;

	-- windowing avalon mm registers signals
	signal s_rst_controller_write_registers : t_rst_controller_write_registers;

	-- simucam reset signals
	signal s_simucam_reset : std_logic;
	signal s_reset_counter : std_logic_vector(15 downto 0);

begin

	-- rst_controller avalon mm read instantiation
	avalon_mm_rst_controller_read_ent_inst : entity work.avalon_mm_rst_controller_read_ent
		port map(
			clk_i                             => a_clock,
			rst_i                             => a_reset,
			avalon_mm_spacewire_i.address     => avalon_slave_rst_controller_address,
			avalon_mm_spacewire_i.read        => avalon_slave_rst_controller_read,
			avalon_mm_spacewire_o.readdata    => avalon_slave_rst_controller_readdata,
			avalon_mm_spacewire_o.waitrequest => s_avalon_mm_rst_controller_read_waitrequest,
			rst_controller_write_registers_i  => s_rst_controller_write_registers
		);

	-- rst_controller avalon mm write instantiation
	avalon_mm_rst_controller_write_ent_inst : entity work.avalon_mm_rst_controller_write_ent
		port map(
			clk_i                             => a_clock,
			rst_i                             => a_reset,
			avalon_mm_spacewire_i.address     => avalon_slave_rst_controller_address,
			avalon_mm_spacewire_i.write       => avalon_slave_rst_controller_write,
			avalon_mm_spacewire_i.writedata   => avalon_slave_rst_controller_writedata,
			avalon_mm_spacewire_o.waitrequest => s_avalon_mm_rst_controller_write_waitrequest,
			rst_controller_write_registers_o  => s_rst_controller_write_registers
		);

	avalon_slave_rst_controller_waitrequest <= ((s_avalon_mm_rst_controller_read_waitrequest) and (s_avalon_mm_rst_controller_write_waitrequest)) when (a_reset = '0') else ('1');

	-- simucam reset
	reset_source_simucam_reset <= (s_simucam_reset) when (a_reset = '0') else ('1');
	p_simucam_reset : process(a_clock, a_reset) is
	begin
		if (a_reset = '1') then
			s_simucam_reset <= '0';
			s_reset_counter <= (others => '0');
		elsif (rising_edge(a_clock)) then
			s_simucam_reset <= '0';
			s_reset_counter <= (others => '0');
			if (s_rst_controller_write_registers.simucam_reset.simucam_reset = '1') then
				s_simucam_reset <= '1';
				s_reset_counter <= std_logic_vector(unsigned(s_rst_controller_write_registers.simucam_reset.simucam_timer) - 1);
			end if;
			if (s_simucam_reset = '1') then
				if (s_reset_counter = std_logic_vector(to_unsigned(0, 16))) then
					s_simucam_reset <= '0';
					s_reset_counter <= (others => '0');
				else
					s_simucam_reset <= '1';
					s_reset_counter <= std_logic_vector(unsigned(s_reset_counter) - 1);
				end if;
			end if;
		end if;
	end process p_simucam_reset;

	-- devices reset
	reset_source_sync_reset     <= (s_rst_controller_write_registers.device_reset.sync_reset) when (a_reset = '0') else ('1');
	reset_source_rs232_reset    <= (s_rst_controller_write_registers.device_reset.rs232_reset) when (a_reset = '0') else ('1');
	reset_source_sd_card_reset  <= (s_rst_controller_write_registers.device_reset.sd_card_reset) when (a_reset = '0') else ('1');
	reset_source_comm_ch8_reset <= (s_rst_controller_write_registers.device_reset.comm_ch8_reset) when (a_reset = '0') else ('1');
	reset_source_comm_ch7_reset <= (s_rst_controller_write_registers.device_reset.comm_ch7_reset) when (a_reset = '0') else ('1');
	reset_source_comm_ch6_reset <= (s_rst_controller_write_registers.device_reset.comm_ch6_reset) when (a_reset = '0') else ('1');
	reset_source_comm_ch5_reset <= (s_rst_controller_write_registers.device_reset.comm_ch5_reset) when (a_reset = '0') else ('1');
	reset_source_comm_ch4_reset <= (s_rst_controller_write_registers.device_reset.comm_ch4_reset) when (a_reset = '0') else ('1');
	reset_source_comm_ch3_reset <= (s_rst_controller_write_registers.device_reset.comm_ch3_reset) when (a_reset = '0') else ('1');
	reset_source_comm_ch2_reset <= (s_rst_controller_write_registers.device_reset.comm_ch2_reset) when (a_reset = '0') else ('1');
	reset_source_comm_ch1_reset <= (s_rst_controller_write_registers.device_reset.comm_ch1_reset) when (a_reset = '0') else ('1');

end architecture rtl;                   -- of rst_controller_top
