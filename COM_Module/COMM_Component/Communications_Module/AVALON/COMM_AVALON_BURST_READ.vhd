library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.comm_avalon_burst_pkg.all;
use work.comm_burst_registers_pkg.all;
use work.comm_pipeline_fifo_pkg.all;
use work.comm_avs_controller_pkg.all;
use work.tran_burst_registers_pkg.all;

entity comm_avalon_burst_read_ent is
	port(
		clk                         : in  std_logic;
		rst                         : in  std_logic;
		avalon_burst_inputs         : in  comm_avalon_burst_read_inputs_type;
		avalon_burst_outputs        : out comm_avalon_burst_read_outputs_type;
		burst_read_registers        : in  comm_burst_read_registers_type;
		comm_avs_controller_inputs  : in  comm_avsdc_rx_avs_outputs_type;
		comm_avs_controller_outputs : out comm_avsdc_rx_avs_inputs_type
	);
end entity comm_avalon_burst_read_ent;

-- RX : fifo --> avs  (SpW --> Simucam)

architecture comm_avalon_burst_read_arc of comm_avalon_burst_read_ent is

	type read_state_machine_type is (
		normal_state,
		burst_state,
		fetching_state
	);

	type pipeline_state_machine_type is (
		standby_state,
		waiting_state,
		recording_state
	);

	signal pipeline_fifo_inputs_sig      : pipeline_fifo_inputs_type;
	signal pipeline_fifo_outputs_sig     : pipeline_fifo_outputs_type;
	signal pipeline_fifo_data_input_sig  : pipeline_fifo_data_type;
	signal pipeline_fifo_data_output_sig : pipeline_fifo_data_type;

	signal pipeline_fifo_rdreq_sig : std_logic;
	signal pipeline_fifo_wrreq_sig : std_logic;

	signal avs_dataused_sig        : std_logic;
	signal avs_dataused_output_sig : std_logic;

	signal burst_waitrequest_sig : std_logic;

begin

	comm_pipeline_sc_fifo_inst : entity work.comm_pipeline_sc_fifo
		port map(
			aclr  => rst,
			clock => clk,
			data  => pipeline_fifo_inputs_sig.data,
			rdreq => pipeline_fifo_inputs_sig.rdreq,
			wrreq => pipeline_fifo_inputs_sig.wrreq,
			empty => pipeline_fifo_outputs_sig.empty,
			full  => pipeline_fifo_outputs_sig.full,
			q     => pipeline_fifo_outputs_sig.q
		);

	comm_avalon_burst_read_proc : process(clk, rst) is
		procedure burst_readdata_procedure(burst_read_address_in : comm_avalon_burst_address_type; burst_bytes_enabled_in : comm_bytes_enabled_type) is
			variable burst_readdata_var : std_logic_vector((avalon_burst_outputs.readdata'length - 1) downto 0);
		begin

			-- Registers Data Read
			case (burst_read_address_in) is
				-- Case for access to all registers address

				-- SPWC Module ReadData procedure

				-- TRAN Module ReadData procedure

				--  Transparent RX Burst Data Register (64 bits):
				when (TRAN_RX_DATA_BURST_REG_ADDRESS + TRAN_BURST_REGISTERS_ADDRESS_OFFSET) =>
					--    63-57 : Reserved                   [-/-]
					burst_readdata_var(63 downto 57) := (others => '0');
					--    56-56 : SpaceWire RX Flag 3        [R/-]
					burst_readdata_var(56)           := burst_read_registers.TRAN.RX_DATA_BURST_REGISTER.SPACEWIRE_FLAG_3;
					--    55-48 : SpaceWire RX Data 3        [R/-]
					burst_readdata_var(55 downto 48) := burst_read_registers.TRAN.RX_DATA_BURST_REGISTER.SPACEWIRE_DATA_3;
					--    47-41 : Reserved                   [-/-]
					burst_readdata_var(47 downto 41) := (others => '0');
					--    40-40 : SpaceWire RX Flag 2        [R/-]
					burst_readdata_var(40)           := burst_read_registers.TRAN.RX_DATA_BURST_REGISTER.SPACEWIRE_FLAG_2;
					--    39-32 : SpaceWire RX Data 2        [R/-]
					burst_readdata_var(39 downto 32) := burst_read_registers.TRAN.RX_DATA_BURST_REGISTER.SPACEWIRE_DATA_2;
					--    31-25 : Reserved                   [-/-]
					burst_readdata_var(31 downto 25) := (others => '0');
					--    24-24 : SpaceWire RX Flag 1        [R/-]
					burst_readdata_var(24)           := burst_read_registers.TRAN.RX_DATA_BURST_REGISTER.SPACEWIRE_FLAG_1;
					--    23-16 : SpaceWire RX Data 1        [R/-]
					burst_readdata_var(23 downto 16) := burst_read_registers.TRAN.RX_DATA_BURST_REGISTER.SPACEWIRE_DATA_1;
					--    15- 9 : Reserved                   [-/-]
					burst_readdata_var(15 downto 9)  := (others => '0');
					--     8- 8 : SpaceWire RX Flag 0        [R/-]
					burst_readdata_var(8)            := burst_read_registers.TRAN.RX_DATA_BURST_REGISTER.SPACEWIRE_FLAG_0;
					--     7- 0 : SpaceWire RX Data 0        [R/-]
					burst_readdata_var(7 downto 0)   := burst_read_registers.TRAN.RX_DATA_BURST_REGISTER.SPACEWIRE_DATA_0;

				when others =>
					burst_readdata_var := (others => '0');

			end case;

			-- Byte enable operation
			if (burst_bytes_enabled_in(7) = '1') then
				avalon_burst_outputs.readdata(63 downto 56) <= burst_readdata_var(63 downto 56);
			end if;
			if (burst_bytes_enabled_in(6) = '1') then
				avalon_burst_outputs.readdata(55 downto 48) <= burst_readdata_var(55 downto 48);
			end if;
			if (burst_bytes_enabled_in(5) = '1') then
				avalon_burst_outputs.readdata(47 downto 40) <= burst_readdata_var(47 downto 40);
			end if;
			if (burst_bytes_enabled_in(4) = '1') then
				avalon_burst_outputs.readdata(39 downto 32) <= burst_readdata_var(39 downto 32);
			end if;
			if (burst_bytes_enabled_in(3) = '1') then
				avalon_burst_outputs.readdata(31 downto 24) <= burst_readdata_var(31 downto 24);
			end if;
			if (burst_bytes_enabled_in(2) = '1') then
				avalon_burst_outputs.readdata(23 downto 16) <= burst_readdata_var(23 downto 16);
			end if;
			if (burst_bytes_enabled_in(1) = '1') then
				avalon_burst_outputs.readdata(15 downto 8) <= burst_readdata_var(15 downto 8);
			end if;
			if (burst_bytes_enabled_in(0) = '1') then
				avalon_burst_outputs.readdata(7 downto 0) <= burst_readdata_var(7 downto 0);
			end if;

		end procedure burst_readdata_procedure;

		variable read_state_machine_var     : read_state_machine_type        := normal_state;
		variable pipeline_state_machine_var : pipeline_state_machine_type    := standby_state;
		variable burst_read_address_var     : comm_avalon_burst_address_type := 0;
		variable burst_burst_counter_var    : comm_burst_counter_type        := 0;
		variable burst_bytes_enabled_var    : comm_bytes_enabled_type        := (others => '0');
		variable burst_reading_started_flag : std_logic                      := '0';
	begin
		if (rst = '1') then
			burst_waitrequest_sig              <= '1';
			avalon_burst_outputs.readdatavalid <= '0';
			avalon_burst_outputs.readdata      <= (others => '0');
			read_state_machine_var             := normal_state;
			pipeline_state_machine_var         := standby_state;
			burst_read_address_var             := 0;
			burst_burst_counter_var            := 0;
			burst_bytes_enabled_var            := (others => '0');
			burst_reading_started_flag         := '0';
			pipeline_fifo_rdreq_sig            <= '0';
			pipeline_fifo_wrreq_sig            <= '0';
			avs_dataused_sig                   <= '0';
		elsif rising_edge(clk) then
			pipeline_fifo_wrreq_sig            <= '0';
			pipeline_fifo_rdreq_sig            <= '0';
			avs_dataused_sig                   <= '0';
			avalon_burst_outputs.readdatavalid <= '0';
			burst_waitrequest_sig              <= '1';

			-- Commands Pipelining
			if (avalon_burst_inputs.read = '1') then
				case (pipeline_state_machine_var) is

					when standby_state => -- aguarda um comando de leitura
						if (burst_reading_started_flag = '1') then -- burst reading já iniciado, grava a nova requisição no pipeline
							if (pipeline_fifo_outputs_sig.full = '1') then -- não existe espaço no pipeline fifo, mantém o waitrequest alto
								burst_waitrequest_sig      <= '1';
								pipeline_fifo_wrreq_sig    <= '0';
								pipeline_state_machine_var := standby_state;
							else        -- existe espaço no pipeline fifo, grava os parametros da leitura
								burst_waitrequest_sig      <= '0';
								pipeline_fifo_wrreq_sig    <= '1';
								pipeline_state_machine_var := recording_state;
							end if;
						else            -- burst reading não iniciado, prepara o inicio de uma nova leitura
--							burst_read_address_var     := to_integer(unsigned(avalon_burst_inputs.address));
							burst_read_address_var     := TRAN_RX_DATA_BURST_REG_ADDRESS + TRAN_BURST_REGISTERS_ADDRESS_OFFSET;
							burst_burst_counter_var    := to_integer(unsigned(avalon_burst_inputs.burstcount));
							burst_bytes_enabled_var    := avalon_burst_inputs.byteenable;
							burst_reading_started_flag := '1';
							burst_waitrequest_sig      <= '0';
							pipeline_fifo_wrreq_sig    <= '0';
							pipeline_state_machine_var := waiting_state;
						end if;

					when waiting_state => -- delay de um ciclo de clock para que o master retire a requisição de leitura
						pipeline_state_machine_var := standby_state;

					when recording_state => -- delay de um ciclo de clock para que o master retire a requisição de leitura
						pipeline_fifo_wrreq_sig    <= '0';
						pipeline_state_machine_var := standby_state;

				end case;
			end if;

			-- Data Reading
			if (burst_reading_started_flag = '1') then -- leitura iniciada
				case (read_state_machine_var) is

					when normal_state => -- primeira leitura de um burst ou leitura única
						if (comm_avs_controller_inputs.TRAN.datavalid = '1') then -- existe dados válidos disponíveis
							burst_readdata_procedure(burst_read_address_var, burst_bytes_enabled_var);
							avalon_burst_outputs.readdatavalid <= '1';
							if (burst_burst_counter_var > 1) then
								burst_burst_counter_var := burst_burst_counter_var - 1;
								--burst_read_address_var  := burst_read_address_var + 1;
								avs_dataused_sig        <= '1';
								read_state_machine_var  := burst_state;
							else
								avs_dataused_sig <= '0';
								if (pipeline_fifo_outputs_sig.empty = '0') then -- existem comandos disponíveis no pipeline, faz o command fetching
									pipeline_fifo_rdreq_sig    <= '1';
									burst_reading_started_flag := '1';
									read_state_machine_var     := fetching_state;
								else    -- não existe comandos disponíveis no pipeline, aguarda novo início de leitura
									burst_reading_started_flag := '0';
									read_state_machine_var     := normal_state;
								end if;
							end if;
						else
							read_state_machine_var := normal_state;
						end if;

					when burst_state => -- continuação de leitura em modo burst
						if (comm_avs_controller_inputs.TRAN.datavalid = '1') then -- existe dados válidos disponíveis, faz a leitura
							burst_readdata_procedure(burst_read_address_var, burst_bytes_enabled_var);
							avalon_burst_outputs.readdatavalid <= '1';
							avs_dataused_sig                   <= '1';
							burst_burst_counter_var            := burst_burst_counter_var - 1;
							--burst_read_address_var  := burst_read_address_var + 1;
						end if;
						if (burst_burst_counter_var > 0) then
							read_state_machine_var := burst_state;
						else
							if (pipeline_fifo_outputs_sig.empty = '0') then -- existem comandos disponíveis no pipeline, faz o command fetching
								pipeline_fifo_rdreq_sig    <= '1';
								burst_reading_started_flag := '1';
								avs_dataused_sig           <= '0';
								read_state_machine_var     := fetching_state;
							else        -- não existe comandos disponíveis no pipeline, aguarda novo início de leitura
								burst_reading_started_flag := '0';
							avs_dataused_sig                   <= '0';
								read_state_machine_var     := normal_state;
							end if;
						end if;

					when fetching_state => -- faz o fetch de um novo comando no pipeline
						avs_dataused_sig <= '1';
						if (pipeline_fifo_rdreq_sig = '1') then -- foi dado o comando de fetch, desce o trigger
							pipeline_fifo_rdreq_sig    <= '0';
							burst_reading_started_flag := '1';
							read_state_machine_var     := fetching_state;
						else            -- realizado o fetch, atualiza os dados atuais com os dados gravados
--							burst_read_address_var             := to_integer(unsigned(avalon_burst_inputs.address));
							burst_read_address_var             := TRAN_RX_DATA_BURST_REG_ADDRESS + TRAN_BURST_REGISTERS_ADDRESS_OFFSET;
							burst_burst_counter_var            := to_integer(unsigned(pipeline_fifo_data_output_sig.burstcount));
							burst_bytes_enabled_var            := pipeline_fifo_data_output_sig.byteenable;
							burst_reading_started_flag         := '1';
							burst_readdata_procedure(burst_read_address_var, burst_bytes_enabled_var);
							avalon_burst_outputs.readdatavalid <= '1';
							read_state_machine_var             := normal_state;
						end if;

				end case;
			end if;

		end if;
	end process comm_avalon_burst_read_proc;

	-- Signals assingments
	avs_dataused_output_sig                   <= (avs_dataused_sig) when not ((comm_avs_controller_inputs.TRAN.datavalid = '1') and (avalon_burst_inputs.read = '1') and (burst_waitrequest_sig = '1')) else ('1');
	comm_avs_controller_outputs.TRAN.dataused <= (avs_dataused_output_sig) when (comm_avs_controller_inputs.TRAN.datavalid = '1') else ('0');

	avalon_burst_outputs.waitrequest <= burst_waitrequest_sig;

	pipeline_fifo_inputs_sig.wrreq <= (pipeline_fifo_wrreq_sig) when (pipeline_fifo_outputs_sig.full = '0') else ('0');
	pipeline_fifo_inputs_sig.rdreq <= (pipeline_fifo_rdreq_sig) when (pipeline_fifo_outputs_sig.empty = '0') else ('0');

	pipeline_fifo_data_input_sig.address    <= avalon_burst_inputs.address(7 downto 0);
	pipeline_fifo_data_input_sig.byteenable <= avalon_burst_inputs.byteenable;
	pipeline_fifo_data_input_sig.burstcount <= avalon_burst_inputs.burstcount;

	pipeline_fifo_inputs_sig.data(23 downto 16) <= pipeline_fifo_data_input_sig.address;
	pipeline_fifo_inputs_sig.data(15 downto 8)  <= pipeline_fifo_data_input_sig.byteenable;
	pipeline_fifo_inputs_sig.data(7 downto 0)   <= pipeline_fifo_data_input_sig.burstcount;

	pipeline_fifo_data_output_sig.address    <= pipeline_fifo_outputs_sig.q(23 downto 16);
	pipeline_fifo_data_output_sig.byteenable <= pipeline_fifo_outputs_sig.q(15 downto 8);
	pipeline_fifo_data_output_sig.burstcount <= pipeline_fifo_outputs_sig.q(7 downto 0);

end architecture comm_avalon_burst_read_arc;
