library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.ftdi_umft601a_pkg.all;
use work.ftdi_data_fifo_pkg.all;

entity ftdi_umft601a_controller_ent is
	port(
		-- basic signals
		clk_i                  : in  std_logic;
		reset_i                : in  std_logic;
		-- umft601a input signals
		umft601a_status_i      : in  t_ftdi_umft601a_status;
		umft601a_rx_data_i     : in  t_ftdi_umft601a_data;
		-- data fifo input signals
		data_fifo_wr_status_i  : in  t_ftdi_data_fifo_wr_status;
		data_fifo_rd_status_i  : in  t_ftdi_data_fifo_rd_status;
		data_fifo_rd_data_i    : in  t_ftdi_data_fifo_data;
		-- fpga output signals
		fpga_output_enable_o   : out std_logic;
		-- umft601a output signals
		umft601a_control_o     : out t_ftdi_umft601a_control;
		umft601a_tx_data_o     : out t_ftdi_umft601a_data;
		-- data fifo output signals
		data_fifo_wr_control_o : out t_ftdi_data_fifo_wr_control;
		data_fifo_wr_data_o    : out t_ftdi_data_fifo_data;
		data_fifo_rd_control_o : out t_ftdi_data_fifo_rd_control
	);
end entity ftdi_umft601a_controller_ent;

architecture rtl of ftdi_umft601a_controller_ent is

	type t_ftdi_umft601a_controller_state is (
		IDLE,
		DELAY_RX,
		ACTIVATE_UMFT_OE,
		FETCH_RX_DATA,
		RECEIVING,
		DELAY_TX,
		ACTIVATE_FPGA_OE,
		FETCH_TX_DATA,
		TRANSMITTING
	);
	signal s_ftdi_umft601a_controller_state : t_ftdi_umft601a_controller_state; -- current state

	signal s_delay_cnt : natural range 0 to 2 := 0;

begin

	p_ftdi_umft601a_controller_FSM_state : process(clk_i, reset_i)
	begin
		-- on asynchronous reset in any state we jump to the idle state
		if (reset_i = '1') then
			s_ftdi_umft601a_controller_state <= IDLE;
			s_delay_cnt                      <= 0;
		-- state transitions are always synchronous to the clock
		elsif (rising_edge(clk_i)) then
			case (s_ftdi_umft601a_controller_state) is

				-- state "IDLE"
				when IDLE =>
					-- does nothing until there is data and space available for a transaction
					-- default state transition
					s_ftdi_umft601a_controller_state <= IDLE;
					-- default internal signal values
					s_delay_cnt                      <= 0;
					-- conditional state transition and internal signal values
					-- check if the UMFT601A module have tx data and the data fifo can receive
					if ((umft601a_status_i.rxf_n = '0') and (data_fifo_wr_status_i.wrfull = '0')) then
						-- UMFT601A module have tx data and the data fifo can receive
						s_ftdi_umft601a_controller_state <= DELAY_RX;
						s_delay_cnt                      <= 2;
					else
						-- UMFT601A module does not have tx data or the data fifo can not receive
						-- check if the UMFT601A module can transmit and the data fifo have data
						if ((umft601a_status_i.txe_n = '0') and (data_fifo_rd_status_i.rdempty = '0')) then
							-- UMFT601A module can transmit and the data fifo have data
							s_ftdi_umft601a_controller_state <= DELAY_TX;
							s_delay_cnt                      <= 2;
						else
							-- UMFT601A module can not transmit or the data fifo does not have data
							s_ftdi_umft601a_controller_state <= IDLE;
						end if;
					end if;

				-- state "DELAY_RX"
				when DELAY_RX =>
					-- 3 clock cicle delay for UMFT601A module (for rx)
					-- default state transition
					s_ftdi_umft601a_controller_state <= DELAY_RX;
					-- default internal signal values
					s_delay_cnt                      <= 0;
					-- conditional state transition and internal signal values
					-- check if the delay is finished
					if (s_delay_cnt > 0) then
						-- delay has not finished yet
						s_delay_cnt <= s_delay_cnt - 1;
					else
						-- delay finished, go to output enable
						s_ftdi_umft601a_controller_state <= ACTIVATE_UMFT_OE;
					end if;

				-- state "ACTIVATE_UMFT_OE"
				when ACTIVATE_UMFT_OE =>
					-- activate output enable for the UMFT601A module (for receiving)
					-- default state transition
					s_ftdi_umft601a_controller_state <= FETCH_RX_DATA;
					-- default internal signal values
					s_delay_cnt                      <= 0;
				-- conditional state transition and internal signal values

				-- state "FETCH_RX_DATA"
				when FETCH_RX_DATA =>
					-- fetch the rx data from the UMFT601A module
					-- default state transition
					s_ftdi_umft601a_controller_state <= RECEIVING;
					-- default internal signal values
					s_delay_cnt                      <= 0;
				-- conditional state transition and internal signal values

				-- state "RECEIVING"
				when RECEIVING =>
					-- receive rx data and write in the data fifo
					-- default state transition
					s_ftdi_umft601a_controller_state <= RECEIVING;
					-- default internal signal values
					s_delay_cnt                      <= 0;
					-- conditional state transition and internal signal values
					-- check if the UMFT601A module still have tx data and the data fifo can still receive
					if ((umft601a_status_i.rxf_n = '0') and (data_fifo_wr_status_i.wrfull = '0')) then
						-- UMFT601A module still have tx data and the data fifo can still receive
						s_ftdi_umft601a_controller_state <= RECEIVING;
					else
						-- UMFT601A module does not have tx data or the data fifo can not receive
						-- check if the UMFT601A module can transmit and the data fifo have data
						if ((umft601a_status_i.txe_n = '0') and (data_fifo_rd_status_i.rdempty = '0')) then
							-- UMFT601A module can transmit and the data fifo have data
							s_ftdi_umft601a_controller_state <= DELAY_TX;
							s_delay_cnt                      <= 2;
						else
							-- UMFT601A module can not transmit or the data fifo does not have data
							s_ftdi_umft601a_controller_state <= IDLE;
						end if;
					end if;

				-- state "DELAY_TX"
				when DELAY_TX =>
					-- 3 clock cicle delay for UMFT601A module (for tx)
					-- default state transition
					s_ftdi_umft601a_controller_state <= DELAY_TX;
					-- default internal signal values
					s_delay_cnt                      <= 0;
					-- conditional state transition and internal signal values
					-- check if the delay is finished
					if (s_delay_cnt > 0) then
						-- delay has not finished yet
						s_delay_cnt <= s_delay_cnt - 1;
					else
						-- delay finished, go to output enable
						s_ftdi_umft601a_controller_state <= ACTIVATE_FPGA_OE;
					end if;

				-- state "ACTIVATE_FPGA_OE"
				when ACTIVATE_FPGA_OE =>
					-- activate the output enable for the FPGA (for transmitting)
					-- default state transition
					s_ftdi_umft601a_controller_state <= FETCH_TX_DATA;
					-- default internal signal values
					s_delay_cnt                      <= 0;
				-- conditional state transition and internal signal values

				-- state "FETCH_TX_DATA"
				when FETCH_TX_DATA =>
					-- fetch the tx data from the DC DATA FIFO
					-- default state transition
					s_ftdi_umft601a_controller_state <= TRANSMITTING;
					-- default internal signal values
					s_delay_cnt                      <= 0;
				-- conditional state transition and internal signal values

				-- state "TRANSMITTING"
				when TRANSMITTING =>
					-- read from data fifo and write tx data
					-- default state transition
					s_ftdi_umft601a_controller_state <= TRANSMITTING;
					-- default internal signal values
					s_delay_cnt                      <= 0;
					-- conditional state transition and internal signal values
					-- check if the UMFT601A module can still transmit and the data fifo still have data
					if ((umft601a_status_i.txe_n = '0') and (data_fifo_rd_status_i.rdempty = '0')) then
						-- UMFT601A module can transmit and the data fifo have data
						s_ftdi_umft601a_controller_state <= TRANSMITTING;
					else
						-- UMFT601A module can not transmit or the data fifo does not have data
						-- check if the UMFT601A module have tx data and the data fifo can receive
						if ((umft601a_status_i.rxf_n = '0') and (data_fifo_wr_status_i.wrfull = '0')) then
							-- UMFT601A module have tx data and the data fifo can receive
							s_ftdi_umft601a_controller_state <= DELAY_RX;
							s_delay_cnt                      <= 2;
						else
							-- UMFT601A module does not have tx data or the data fifo can not receive
							s_ftdi_umft601a_controller_state <= IDLE;
						end if;
					end if;

				-- all the other states (not defined)
				when others =>
					-- jump to save state (ERROR?!)
					s_ftdi_umft601a_controller_state <= IDLE;

			end case;
		end if;
	end process p_ftdi_umft601a_controller_FSM_state;

	p_ftdi_umft601a_controller_FSM_output : process(s_ftdi_umft601a_controller_state, umft601a_status_i, umft601a_rx_data_i, data_fifo_rd_status_i.rdempty, data_fifo_wr_status_i.wrfull, data_fifo_rd_data_i, reset_i)
	begin
		-- asynchronous reset
		if (reset_i = '1') then
			fpga_output_enable_o         <= '0';
			umft601a_control_o.reset_n   <= '0';
			umft601a_control_o.wr_n      <= '1';
			umft601a_control_o.rd_n      <= '1';
			umft601a_control_o.oe_n      <= '1';
			umft601a_control_o.siwu_n    <= '1';
			umft601a_control_o.wakeup_n  <= '1';
			umft601a_control_o.gpio      <= (others => '1');
			umft601a_tx_data_o.data      <= (others => '0');
			umft601a_tx_data_o.be        <= (others => '0');
			data_fifo_wr_control_o.wrreq <= '0';
			data_fifo_wr_data_o.data     <= (others => '0');
			data_fifo_wr_data_o.be       <= (others => '0');
			data_fifo_rd_control_o.rdreq <= '0';
		-- output generation when s_ftdi_umft601a_controller_state changes
		else
			case (s_ftdi_umft601a_controller_state) is

				-- state "IDLE"
				when IDLE =>
					-- does nothing until there is data and space available for a transaction
					-- default output signals
					fpga_output_enable_o         <= '0';
					umft601a_control_o.reset_n   <= '1';
					umft601a_control_o.wr_n      <= '1';
					umft601a_control_o.rd_n      <= '1';
					umft601a_control_o.oe_n      <= '1';
					umft601a_control_o.siwu_n    <= '1';
					umft601a_control_o.wakeup_n  <= '1';
					umft601a_control_o.gpio      <= (others => '1');
					umft601a_tx_data_o.data      <= (others => '0');
					umft601a_tx_data_o.be        <= (others => '0');
					data_fifo_wr_control_o.wrreq <= '0';
					data_fifo_wr_data_o.data     <= (others => '0');
					data_fifo_wr_data_o.be       <= (others => '0');
					data_fifo_rd_control_o.rdreq <= '0';
				-- conditional output signals

				-- state "DELAY_RX"
				when DELAY_RX =>
					-- 3 clock cicle delay for UMFT601A module (for rx)
					-- default output signals
					fpga_output_enable_o         <= '0';
					umft601a_control_o.reset_n   <= '1';
					umft601a_control_o.wr_n      <= '1';
					umft601a_control_o.rd_n      <= '1';
					umft601a_control_o.oe_n      <= '1';
					umft601a_control_o.siwu_n    <= '1';
					umft601a_control_o.wakeup_n  <= '1';
					umft601a_control_o.gpio      <= (others => '1');
					umft601a_tx_data_o.data      <= (others => '0');
					umft601a_tx_data_o.be        <= (others => '0');
					data_fifo_wr_control_o.wrreq <= '0';
					data_fifo_wr_data_o.data     <= (others => '0');
					data_fifo_wr_data_o.be       <= (others => '0');
					data_fifo_rd_control_o.rdreq <= '0';
				-- conditional output signals

				-- state "ACTIVATE_UMFT_OE"
				when ACTIVATE_UMFT_OE =>
					-- activate output enable for the UMFT601A module (for receiving)
					-- default output signals
					fpga_output_enable_o         <= '0';
					umft601a_control_o.reset_n   <= '1';
					umft601a_control_o.wr_n      <= '1';
					umft601a_control_o.rd_n      <= '1';
					umft601a_control_o.oe_n      <= '0';
					umft601a_control_o.siwu_n    <= '1';
					umft601a_control_o.wakeup_n  <= '1';
					umft601a_control_o.gpio      <= (others => '1');
					umft601a_tx_data_o.data      <= (others => '0');
					umft601a_tx_data_o.be        <= (others => '0');
					data_fifo_wr_control_o.wrreq <= '0';
					data_fifo_wr_data_o.data     <= (others => '0');
					data_fifo_wr_data_o.be       <= (others => '0');
					data_fifo_rd_control_o.rdreq <= '0';
				-- conditional output signals

				-- state "FETCH_RX_DATA"
				when FETCH_RX_DATA =>
					-- fetch the rx data from the UMFT601A module
					-- default output signals
					fpga_output_enable_o         <= '0';
					umft601a_control_o.reset_n   <= '1';
					umft601a_control_o.wr_n      <= '1';
					umft601a_control_o.rd_n      <= '1';
					umft601a_control_o.oe_n      <= '0';
					umft601a_control_o.siwu_n    <= '1';
					umft601a_control_o.wakeup_n  <= '1';
					umft601a_control_o.gpio      <= (others => '1');
					umft601a_tx_data_o.data      <= (others => '0');
					umft601a_tx_data_o.be        <= (others => '0');
					data_fifo_wr_control_o.wrreq <= '0';
					data_fifo_wr_data_o.data     <= (others => '0');
					data_fifo_wr_data_o.be       <= (others => '0');
					data_fifo_rd_control_o.rdreq <= '0';
				-- conditional output signals

				-- state "RECEIVING"
				when RECEIVING =>
					-- receive rx data and write in the data fifo
					-- default output signals
					fpga_output_enable_o         <= '0';
					umft601a_control_o.reset_n   <= '1';
					umft601a_control_o.wr_n      <= '1';
					umft601a_control_o.rd_n      <= '0';
					umft601a_control_o.oe_n      <= '0';
					umft601a_control_o.siwu_n    <= '1';
					umft601a_control_o.wakeup_n  <= '1';
					umft601a_control_o.gpio      <= (others => '1');
					umft601a_tx_data_o.data      <= (others => '0');
					umft601a_tx_data_o.be        <= (others => '0');
					data_fifo_wr_control_o.wrreq <= '0';
					data_fifo_wr_data_o.data     <= (others => '0');
					data_fifo_wr_data_o.be       <= (others => '0');
					data_fifo_rd_control_o.rdreq <= '0';
					-- conditional output signals
					-- check if the UMFT601A module have rx data and the data fifo can receive
					if ((umft601a_status_i.rxf_n = '0') and (data_fifo_wr_status_i.wrfull = '0')) then
						-- UMFT601A module have rx data and the data fifo can receive
						umft601a_control_o.rd_n      <= '0';
						umft601a_control_o.oe_n      <= '0';
						data_fifo_wr_control_o.wrreq <= '1';
						data_fifo_wr_data_o.data     <= umft601a_rx_data_i.data;
						data_fifo_wr_data_o.be       <= umft601a_rx_data_i.be;
					end if;

				-- state "DELAY_TX"
				when DELAY_TX =>
					-- 3 clock cicle delay for UMFT601A module (for tx)
					-- default output signals
					fpga_output_enable_o         <= '0';
					umft601a_control_o.reset_n   <= '1';
					umft601a_control_o.wr_n      <= '1';
					umft601a_control_o.rd_n      <= '1';
					umft601a_control_o.oe_n      <= '1';
					umft601a_control_o.siwu_n    <= '1';
					umft601a_control_o.wakeup_n  <= '1';
					umft601a_control_o.gpio      <= (others => '1');
					umft601a_tx_data_o.data      <= (others => '0');
					umft601a_tx_data_o.be        <= (others => '0');
					data_fifo_wr_control_o.wrreq <= '0';
					data_fifo_wr_data_o.data     <= (others => '0');
					data_fifo_wr_data_o.be       <= (others => '0');
					data_fifo_rd_control_o.rdreq <= '0';
				-- conditional output signals

				-- state "ACTIVATE_FPGA_OE"
				when ACTIVATE_FPGA_OE =>
					-- activate the output enable for the FPGA (for transmitting)
					-- default output signals
					fpga_output_enable_o         <= '1';
					umft601a_control_o.reset_n   <= '1';
					umft601a_control_o.wr_n      <= '1';
					umft601a_control_o.rd_n      <= '1';
					umft601a_control_o.oe_n      <= '1';
					umft601a_control_o.siwu_n    <= '1';
					umft601a_control_o.wakeup_n  <= '1';
					umft601a_control_o.gpio      <= (others => '1');
					umft601a_tx_data_o.data      <= (others => '0');
					umft601a_tx_data_o.be        <= (others => '0');
					data_fifo_wr_control_o.wrreq <= '0';
					data_fifo_wr_data_o.data     <= (others => '0');
					data_fifo_wr_data_o.be       <= (others => '0');
					data_fifo_rd_control_o.rdreq <= '0';
				-- conditional output signals

				-- state "FETCH_TX_DATA"
				when FETCH_TX_DATA =>
					-- fetch the tx data from the DC DATA FIFO
					-- default output signals
					fpga_output_enable_o         <= '1';
					umft601a_control_o.reset_n   <= '1';
					umft601a_control_o.wr_n      <= '1';
					umft601a_control_o.rd_n      <= '1';
					umft601a_control_o.oe_n      <= '1';
					umft601a_control_o.siwu_n    <= '1';
					umft601a_control_o.wakeup_n  <= '1';
					umft601a_control_o.gpio      <= (others => '1');
					umft601a_tx_data_o.data      <= (others => '0');
					umft601a_tx_data_o.be        <= (others => '0');
					data_fifo_wr_control_o.wrreq <= '0';
					data_fifo_wr_data_o.data     <= (others => '0');
					data_fifo_wr_data_o.be       <= (others => '0');
					data_fifo_rd_control_o.rdreq <= '0';
				-- conditional output signals

				-- state "TRANSMITTING"
				when TRANSMITTING =>
					-- read from data fifo and write tx data
					-- default output signals
					fpga_output_enable_o         <= '1';
					umft601a_control_o.reset_n   <= '1';
					umft601a_control_o.wr_n      <= '1';
					umft601a_control_o.rd_n      <= '1';
					umft601a_control_o.oe_n      <= '1';
					umft601a_control_o.siwu_n    <= '1';
					umft601a_control_o.wakeup_n  <= '1';
					umft601a_control_o.gpio      <= (others => '1');
					umft601a_tx_data_o.data      <= (others => '0');
					umft601a_tx_data_o.be        <= (others => '0');
					data_fifo_wr_control_o.wrreq <= '0';
					data_fifo_wr_data_o.data     <= (others => '0');
					data_fifo_wr_data_o.be       <= (others => '0');
					data_fifo_rd_control_o.rdreq <= '0';
					-- conditional output signals
					-- check if the UMFT601A module can transmit and the data fifo have data
					--if ((umft601a_status_i.txe_n = '0') and (data_fifo_rd_status_i.rdempty = '0')) then
					if (data_fifo_rd_status_i.rdempty = '0') then
						-- UMFT601A module can transmit and the data fifo have data
						data_fifo_rd_control_o.rdreq <= '1';
						umft601a_control_o.wr_n      <= '0';
						umft601a_tx_data_o.data      <= data_fifo_rd_data_i.data;
						umft601a_tx_data_o.be        <= data_fifo_rd_data_i.be;
					end if;

				-- all the other states (not defined)
				when others =>
					null;

			end case;
		end if;
	end process p_ftdi_umft601a_controller_FSM_output;

end architecture rtl;
