-- FTDI_component.vhd

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

use work.ftdi_registers_pck.all;

entity FTDI_component is
	port(
		FTDI_avalon_slave_address     : in    std_logic_vector(7 downto 0)  := (others => '0'); -- FTDI_avalon_slave.address
		FTDI_avalon_slave_read        : in    std_logic                     := '0'; --                  .read
		FTDI_avalon_slave_readdata    : out   std_logic_vector(31 downto 0); --                  .readdata
		FTDI_avalon_slave_write       : in    std_logic                     := '0'; --                  .write
		FTDI_avalon_slave_writedata   : in    std_logic_vector(31 downto 0) := (others => '0'); --                  .writedata
		FTDI_avalon_slave_waitrequest : out   std_logic; --                  .waitrequest
		clock_sink_clk                : in    std_logic                     := '0'; --   FTDI_clock_sink.clk
		reset_sink_reset              : in    std_logic                     := '0'; --   FTDI_reset_sink.reset
		FTDI_data                     : inout std_logic_vector(31 downto 0) := (others => '0'); --  FTDI_conduit_end.ftdi_data_signal
		FTDI_be                       : inout std_logic_vector(3 downto 0)  := (others => '0'); --                  .ftdi_be_signal
		FTDI_reset_n                  : out   std_logic; --                  .ftdi_reset_n_signal
		FTDI_wakeup_n                 : inout std_logic                     := '0'; --                  .ftdi_wakeup_n_signal
		FTDI_clock                    : in    std_logic                     := '0'; --                  .ftdi_clock_signal
		FTDI_rxf_n                    : in    std_logic                     := '0'; --                  .ftdi_rxf_n_signal
		FTDI_txe_n                    : in    std_logic                     := '0'; --                  .ftdi_txe_n_signal
		FTDI_gpio                     : inout std_logic_vector(1 downto 0)  := (others => '0'); --                  .ftdi_gpio_signal
		FTDI_wr_n                     : out   std_logic; --                  .ftdi_wr_n_signal
		FTDI_rd_n                     : out   std_logic; --                  .ftdi_rd_n_signal
		FTDI_oe_n                     : out   std_logic; --                  .ftdi_oe_n_signal
		FTDI_siwu_n                   : out   std_logic --                  .ftdi_siwu_n_signal
	);
end entity FTDI_component;

architecture rtl of FTDI_component is

	alias AVS_clock is clock_sink_clk;
	alias reset is reset_sink_reset;

	signal waitrequest_reset_signal : std_logic;
	signal waitrequest_write_signal : std_logic;
	signal waitrequest_read_signal : std_logic;
	
	signal read_reg  : ftdi_read_type;
	signal write_reg : ftdi_write_type;

	signal data_in_signal      : std_logic_vector(31 downto 0);
	signal data_out_signal     : std_logic_vector(31 downto 0);
	signal be_in_signal        : std_logic_vector(3 downto 0);
	signal be_out_signal       : std_logic_vector(3 downto 0);
	signal wakeup_n_in_signal  : std_logic;
	signal wakeup_n_out_signal : std_logic;
	signal gpio_in_signal      : std_logic_vector(1 downto 0);
	signal gpio_out_signal     : std_logic_vector(1 downto 0);
	signal oe_signal           : std_logic_vector(3 downto 0);

begin

	ftdi_avalon_read_ent_inst : entity work.ftdi_avalon_read_ent
		port map(
			clk                   => AVS_clock,
			rst                   => reset,
			avalon_slave_address  => FTDI_avalon_slave_address,
			avalon_slave_read     => FTDI_avalon_slave_read,
			avalon_slave_readdata => FTDI_avalon_slave_readdata,
			avalon_slave_waitrequest => waitrequest_read_signal,
			ftdi_read_register    => read_reg,
			ftdi_write_register   => write_reg
		);

	ftdi_avalon_write_ent_inst : entity work.ftdi_avalon_write_ent
		port map(
			clk                    => AVS_clock,
			rst                    => reset,
			avalon_slave_address   => FTDI_avalon_slave_address,
			avalon_slave_write     => FTDI_avalon_slave_write,
			avalon_slave_writedata => FTDI_avalon_slave_writedata,
			avalon_slave_waitrequest => waitrequest_write_signal,
			ftdi_write_register    => write_reg
		);

	data_bidir_bus_ent_inst : entity work.bidir_bus_ent
		generic map(
			BUS_WIDTH => FTDI_data'length,
			RST_STATE => '0'
		)
		port map(
			bidir_bus     => FTDI_data,
			oe            => oe_signal(0),
			clk           => FTDI_clock,
			rst           => reset,
			feedback_data => data_in_signal,
			output_data   => data_out_signal
		);

	be_bidir_bus_ent_inst : entity work.bidir_bus_ent
		generic map(
			BUS_WIDTH => FTDI_be'length,
			RST_STATE => '0'
		)
		port map(
			bidir_bus     => FTDI_be,
			oe            => oe_signal(1),
			clk           => FTDI_clock,
			rst           => reset,
			feedback_data => be_in_signal,
			output_data   => be_out_signal
		);

	wakeup_bidir_pin_ent_inst : entity work.bidir_pin_ent
		generic map(
			RST_STATE => '1'
		)
		port map(
			bidir_pin     => FTDI_wakeup_n,
			oe            => oe_signal(2),
			clk           => FTDI_clock,
			rst           => reset,
			feedback_data => wakeup_n_in_signal,
			output_data   => wakeup_n_out_signal
		);

	gpio_bidir_bus_ent_inst : entity work.bidir_bus_ent
		generic map(
			BUS_WIDTH => FTDI_gpio'length,
			RST_STATE => '0'
		)
		port map(
			bidir_bus     => FTDI_gpio,
			oe            => oe_signal(3),
			clk           => FTDI_clock,
			rst           => reset,
			feedback_data => gpio_in_signal,
			output_data   => gpio_out_signal
		);
		
	data_out_dc_bus_ent_inst : entity work.dc_bus_ent
		generic map(
			BUS_WIDTH => FTDI_data'length,
			RST_STATE => '1'
		)
		port map(
			clk_in   => AVS_clock,
			data_in  => write_reg.DATA_REG_OUT,
			clk_out  => FTDI_clock,
			data_out => data_out_signal,
			rst      => reset
		);

	be_out_dc_bus_ent_inst : entity work.dc_bus_ent
		generic map(
			BUS_WIDTH => FTDI_be'length,
			RST_STATE => '1'
		)
		port map(
			clk_in   => AVS_clock,
			data_in  => write_reg.BE_REG_OUT,
			clk_out  => FTDI_clock,
			data_out => be_out_signal,
			rst      => reset
		);

	siwu_out_dc_pin_ent_inst : entity work.dc_pin_ent
		generic map(
			RST_STATE => '1'
		)
		port map(
			clk_in   => AVS_clock,
			data_in  => write_reg.SIWU_N_REG,
			clk_out  => FTDI_clock,
			data_out => FTDI_siwu_n,
			rst      => reset
		);

	wr_out_dc_pin_ent_inst : entity work.dc_pin_ent
		generic map(
			RST_STATE => '1'
		)
		port map(
			clk_in   => AVS_clock,
			data_in  => write_reg.WR_N_REG,
			clk_out  => FTDI_clock,
			data_out => FTDI_wr_n,
			rst      => reset
		);

	rd_out_dc_pin_ent_inst : entity work.dc_pin_ent
		generic map(
			RST_STATE => '1'
		)
		port map(
			clk_in   => AVS_clock,
			data_in  => write_reg.RD_N_REG,
			clk_out  => FTDI_clock,
			data_out => FTDI_rd_n,
			rst      => reset
		);

	oe_out_dc_pin_ent_inst : entity work.dc_pin_ent
		generic map(
			RST_STATE => '1'
		)
		port map(
			clk_in   => AVS_clock,
			data_in  => write_reg.OE_N_REG,
			clk_out  => FTDI_clock,
			data_out => FTDI_oe_n,
			rst      => reset
		);

	reset_out_dc_pin_ent_inst : entity work.dc_pin_ent
		generic map(
			RST_STATE => '0'
		)
		port map(
			clk_in   => AVS_clock,
			data_in  => write_reg.RESET_N_REG,
			clk_out  => FTDI_clock,
			data_out => FTDI_reset_n,
			rst      => reset
		);

	wakeup_out_dc_pin_ent_inst : entity work.dc_pin_ent
		generic map(
			RST_STATE => '1'
		)
		port map(
			clk_in   => AVS_clock,
			data_in  => write_reg.WAKEUP_N_REG_OUT,
			clk_out  => FTDI_clock,
			data_out => wakeup_n_out_signal,
			rst      => reset
		);

	gpio_out_dc_bus_ent_inst : entity work.dc_bus_ent
		generic map(
			BUS_WIDTH => FTDI_gpio'length,
			RST_STATE => '1'
		)
		port map(
			clk_in   => AVS_clock,
			data_in  => write_reg.GPIO_REG_OUT,
			clk_out  => FTDI_clock,
			data_out => gpio_out_signal,
			rst      => reset
		);

	oe_signal_out_dc_bus_ent_inst : entity work.dc_bus_ent
		generic map(
			BUS_WIDTH => oe_signal'length,
			RST_STATE => '1'
		)
		port map(
			clk_in   => AVS_clock,
			data_in  => write_reg.OE_REG,
			clk_out  => FTDI_clock,
			data_out => oe_signal,
			rst      => reset
		);

	data_in_dc_bus_ent_inst : entity work.dc_bus_ent
		generic map(
			BUS_WIDTH => FTDI_data'length,
			RST_STATE => '0'
		)
		port map(
			clk_in   => FTDI_clock,
			data_in  => data_in_signal,
			clk_out  => AVS_clock,
			data_out => read_reg.DATA_REG_IN,
			rst      => reset
		);

	be_in_dc_bus_ent_inst : entity work.dc_bus_ent
		generic map(
			BUS_WIDTH => FTDI_be'length,
			RST_STATE => '0'
		)
		port map(
			clk_in   => FTDI_clock,
			data_in  => be_in_signal,
			clk_out  => AVS_clock,
			data_out => read_reg.BE_REG_IN,
			rst      => reset
		);

	txe_in_dc_pin_ent_inst : entity work.dc_pin_ent
		generic map(
			RST_STATE => '0'
		)
		port map(
			clk_in   => FTDI_clock,
			data_in  => FTDI_txe_n,
			clk_out  => AVS_clock,
			data_out => read_reg.TXE_N_REG,
			rst      => reset
		);

	rxf_in_dc_pin_ent_inst : entity work.dc_pin_ent
		generic map(
			RST_STATE => '0'
		)
		port map(
			clk_in   => FTDI_clock,
			data_in  => FTDI_rxf_n,
			clk_out  => AVS_clock,
			data_out => read_reg.RXF_N_REG,
			rst      => reset
		);

	wakeup_in_dc_pin_ent_inst : entity work.dc_pin_ent
		generic map(
			RST_STATE => '0'
		)
		port map(
			clk_in   => FTDI_clock,
			data_in  => wakeup_n_in_signal,
			clk_out  => AVS_clock,
			data_out => read_reg.WAKEUP_N_REG_IN,
			rst      => reset
		);

	gpio_in_dc_bus_ent_inst : entity work.dc_bus_ent
		generic map(
			BUS_WIDTH => FTDI_gpio'length,
			RST_STATE => '0'
		)
		port map(
			clk_in   => FTDI_clock,
			data_in  => gpio_in_signal,
			clk_out  => AVS_clock,
			data_out => read_reg.GPIO_REG_IN,
			rst      => reset
		);

	reset_procedure_proc : process(reset) is
	begin
		if (reset = '1') then
			waitrequest_reset_signal <= '1';
		end if;
	end process reset_procedure_proc;

	FTDI_avalon_slave_waitrequest <= waitrequest_reset_signal and waitrequest_write_signal and waitrequest_read_signal;
	
end architecture rtl;                   -- of FTDI_component
