library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.pgen_avalon_pipeline_read_pkg.all;
use work.pgen_pipeline_fifo_pkg.all;

entity pgen_avalon_pipeline_read_ent is
	port(
		clk_i                            : in  std_logic;
		rst_i                            : in  std_logic;
		avalon_pipeline_control_i        : in  t_pgen_avalon_pipeline_control;
		avalon_pipeline_read_inputs_i    : in  t_pgen_avalon_pipeline_read_inputs;
		avalon_pipeline_status_o         : out t_pgen_avalon_pipeline_status;
		avalon_pipeline_read_outputs_o   : out t_pgen_avalon_pipeline_read_outputs;
		avalon_pipeline_read_pipelined_o : out t_pgen_avalon_pipeline_read_pipelined
	);
end entity pgen_avalon_pipeline_read_ent;

architecture RTL of pgen_avalon_pipeline_read_ent is

	signal s_pipeline_fifo_write : std_logic;
	signal s_pipeline_avs_read   : std_logic;

	signal s_passthrough_mode : std_logic;

	signal s_pipelined_avalon     : t_pgen_avalon_pipeline_read_pipelined;
	signal s_pipeline_waitrequest : std_logic;

	signal s_pipeline_fifo_i      : t_pipeline_fifo_inputs;
	signal s_pipeline_fifo_o      : t_pipeline_fifo_outputs;
	signal s_pipeline_fifo_data_i : t_pipeline_fifo_data;
	signal s_pipeline_fifo_data_o : t_pipeline_fifo_data;

	type t_pgen_avalon_pipeline_state is (
		PASSTROUGH,
		PIPELINE
	);
	signal s_pgen_avalon_pipeline_state : t_pgen_avalon_pipeline_state; -- current state

begin

	pgen_pipeline_sc_fifo_inst : entity work.pipeline_sc_fifo
		port map(
			aclr  => rst_i,
			clock => clk_i,
			data  => s_pipeline_fifo_i.data,
			rdreq => s_pipeline_fifo_i.rdreq,
			wrreq => s_pipeline_fifo_i.wrreq,
			empty => s_pipeline_fifo_o.empty,
			full  => s_pipeline_fifo_o.full,
			q     => s_pipeline_fifo_o.q
		);

	p_pgen_avalon_pipeline_FSM_state : process(clk_i, rst_i)
	begin
		-- on asynchronous reset in any state we jump to the idle state
		if (rst_i = '1') then
			s_pgen_avalon_pipeline_state <= PASSTROUGH;
			s_pipeline_fifo_write        <= '0';
			s_pipeline_avs_read          <= '0';
		-- state transitions are always synchronous to the clock
		elsif (rising_edge(clk_i)) then
			case (s_pgen_avalon_pipeline_state) is

				-- state "PASSTROUGH"
				when PASSTROUGH =>
					-- The avalon read signals pass trough the pipeline
					-- default state transition
					s_pgen_avalon_pipeline_state <= PASSTROUGH;
					-- default internal signal values
					-- conditional state transition and internal signal values
					s_pipeline_fifo_write        <= '0';
					s_pipeline_avs_read          <= '0';
					-- check if a avalon read request was received
					if (avalon_pipeline_read_inputs_i.read = '1') then
						-- avalon read request received
						-- check if the avalon read waitrequest signal was released
						if (avalon_pipeline_control_i.avalon_read_waitrequest = '0') then
							-- waitrequest signal released
							-- check if the avalon read became busy after a read request
							if (avalon_pipeline_control_i.avalon_read_busy = '1') then
								-- avalon read is busy, go to pipeline
								s_pgen_avalon_pipeline_state <= PIPELINE;
							end if;
						end if;
					end if;

				-- state "PIPELINE"
				when PIPELINE =>
					-- Pipeline the avalon read signals
					-- default state transition
					s_pgen_avalon_pipeline_state <= PIPELINE;
					-- default internal signal values
					s_pipeline_fifo_write        <= '0';
					s_pipeline_avs_read          <= '0';
					-- conditional state transition and internal signal values
					-- handle of an avalon read request --
					-- check if an avalon read request was received
					if (avalon_pipeline_read_inputs_i.read = '1') then
						-- avalon read request received
						-- check if the pipeline fifo has space
						if (s_pipeline_fifo_o.full = '0') then
							-- pipeline fifo has space
							-- check if the read request was recorded
							if (s_pipeline_fifo_i.wrreq = '1') then
								-- read request recorded
								s_pipeline_fifo_write <= '0';
							else
								-- read request not recorded
								s_pipeline_fifo_write <= '1';
							end if;
						else
							-- pipeline fifo is full
							-- hold wait request until pipeline fifo has space
							s_pipeline_fifo_write <= '0';
						end if;
					end if;
					-- handle the fetch of a pipelined read request --
					-- check if a read request was issued
					if (s_pipeline_avs_read = '1') then
						-- read request issued
						-- check if the avalon read waitrequest signal was released
						if (avalon_pipeline_control_i.avalon_read_waitrequest = '0') then
							-- avalon waitrequest signal released, end the pipelined read request transmission
							s_pipeline_avs_read <= '0';
							-- check if the pipeline fifo is empty
							if (s_pipeline_fifo_o.empty = '1') then
								-- pipeline fifo empty, go to passtrough
								s_pgen_avalon_pipeline_state <= PASSTROUGH;
							end if;
						else
							-- avalon waitrequest signal not released, keep the pipelined read request transmission
							s_pipeline_avs_read <= '1';
						end if;
					else
						--read request not issued
						s_pipeline_avs_read <= '0';
					end if;
					-- check if a fetch was requested 
					if (avalon_pipeline_control_i.avalon_read_fetch = '1') then
						-- fetch of the pipelined read received
						-- issue a read request for avalon read
						s_pipeline_avs_read <= '1';
					end if;

				-- all the other states (not defined)
				when others =>
					-- jump to save state (ERROR?!)
					s_pgen_avalon_pipeline_state <= PASSTROUGH;

			end case;
		end if;
	end process p_pgen_avalon_pipeline_FSM_state;

	p_pgen_avalon_pipeline_FSM_output : process(s_pgen_avalon_pipeline_state, avalon_pipeline_read_inputs_i, avalon_pipeline_control_i, s_pipeline_fifo_o, s_pipeline_fifo_write, s_pipeline_avs_read, rst_i)
	begin
		-- asynchronous reset
		if (rst_i = '1') then
			s_passthrough_mode      <= '1';
			s_pipeline_waitrequest  <= '1';
			s_pipelined_avalon.read <= '0';
			s_pipeline_fifo_i.wrreq <= '0';
		-- output generation when s_pgen_avalon_pipeline_state changes
		else
			case (s_pgen_avalon_pipeline_state) is

				-- state "PASSTROUGH"
				when PASSTROUGH =>
					-- The avalon read signals pass trough the pipeline
					-- default output signals
					s_passthrough_mode      <= '1';
					s_pipeline_waitrequest  <= '1';
					s_pipelined_avalon.read <= '0';
					s_pipeline_fifo_i.wrreq <= '0';
					-- conditional output signals
					-- check if a avalon read request was received
					if (avalon_pipeline_read_inputs_i.read = '1') then
						-- avalon read request received
						s_pipeline_waitrequest <= '0';
						-- check if the avalon read waitrequest signal was released
						if (avalon_pipeline_control_i.avalon_read_waitrequest = '0') then
							-- waitrequest signal released
							s_pipeline_waitrequest <= '1';
							-- check if the avalon read became busy after a read request
							if (avalon_pipeline_control_i.avalon_read_busy = '1') then
								-- avalon read is busy, go to pipeline
								s_passthrough_mode <= '0';
							end if;
						end if;
					end if;

				-- state "PIPELINE"
				when PIPELINE =>
					-- Pipeline the avalon read signals
					-- default output signals
					s_passthrough_mode      <= '1';
					s_pipeline_waitrequest  <= '1';
					s_pipelined_avalon.read <= '0';
					s_pipeline_fifo_i.wrreq <= '0';
					-- conditional output signals
					-- handle of an avalon read request --
					-- check if an avalon read request was received
					if (avalon_pipeline_read_inputs_i.read = '1') then
						-- avalon read request received
						-- check if the pipeline fifo has space
						if (s_pipeline_fifo_o.full = '0') then
							-- pipeline fifo has space
							-- check if the read request was recorded
							if (s_pipeline_fifo_write = '1') then
								-- read request recorded
								s_pipeline_waitrequest  <= '1';
								s_pipeline_fifo_i.wrreq <= s_pipeline_fifo_write;
							else
								-- read request not recorded
								s_pipeline_waitrequest  <= '0';
								s_pipeline_fifo_i.wrreq <= s_pipeline_fifo_write;
							end if;
						else
							-- pipeline fifo is full
							-- hold wait request until pipeline fifo has space
							s_pipeline_waitrequest  <= '1';
							s_pipeline_fifo_i.wrreq <= s_pipeline_fifo_write;
						end if;
					end if;
					-- handle the fetch of a pipelined read request --
					-- check if a read request was issued
					if (s_pipeline_avs_read = '1') then
						-- read request issued
						-- check if the avalon read waitrequest signal was released
						if (avalon_pipeline_control_i.avalon_read_waitrequest = '0') then
							-- avalon waitrequest signal released, end the pipelined read request transmission
							s_pipelined_avalon.read <= s_pipeline_avs_read;
						-- check if the pipeline fifo is empty
						else
							-- avalon waitrequest signal not released, keep the pipelined read request transmission
							s_pipelined_avalon.read <= s_pipeline_avs_read;
						end if;
					else
						--read request not issued
						s_pipelined_avalon.read <= s_pipeline_avs_read;
					end if;
					-- check if a fetch was requested 
					if (avalon_pipeline_control_i.avalon_read_fetch = '1') then
						-- fetch of the pipelined read received
						-- issue a read request for avalon read
						s_pipelined_avalon.read <= s_pipeline_avs_read;
					end if;

				-- all the other states (not defined)
				when others =>
					null;

			end case;
		end if;
	end process p_pgen_avalon_pipeline_FSM_output;

	-- signals assingment
	avalon_pipeline_read_pipelined_o.address    <= (avalon_pipeline_read_inputs_i.address) when (s_passthrough_mode = '1') else (s_pipelined_avalon.address);
	avalon_pipeline_read_pipelined_o.read       <= (avalon_pipeline_read_inputs_i.read) when (s_passthrough_mode = '1') else (s_pipelined_avalon.read);
	avalon_pipeline_read_pipelined_o.burstcount <= (avalon_pipeline_read_inputs_i.burstcount) when (s_passthrough_mode = '1') else (s_pipelined_avalon.burstcount);
	avalon_pipeline_read_pipelined_o.byteenable <= (avalon_pipeline_read_inputs_i.byteenable) when (s_passthrough_mode = '1') else (s_pipelined_avalon.byteenable);

	s_pipeline_fifo_i.data(23 downto 16) <= avalon_pipeline_read_inputs_i.address;
	s_pipeline_fifo_i.data(15 downto 8)  <= avalon_pipeline_read_inputs_i.byteenable;
	s_pipeline_fifo_i.data(7 downto 0)   <= avalon_pipeline_read_inputs_i.burstcount;

	s_pipelined_avalon.address    <= s_pipeline_fifo_o.q(23 downto 16);
	s_pipelined_avalon.byteenable <= s_pipeline_fifo_o.q(15 downto 8);
	s_pipelined_avalon.burstcount <= s_pipeline_fifo_o.q(7 downto 0);

	s_pipeline_fifo_i.rdreq <= avalon_pipeline_control_i.avalon_read_fetch;

end architecture RTL;
