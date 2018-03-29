--=============================================================================
--! @file sync_module_syncgen_ent.vhd
--=============================================================================
--! Standard library
library IEEE;
--! Standard packages
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--! Specific packages
use work.SYNC_MODULE_PKG.ALL;
-------------------------------------------------------------------------------
-- --
-- Instituto Mauá de Tecnologia, Núcleo de Sistemas Eletrônicos Embarcados --
-- Plato Project --
-- --
-------------------------------------------------------------------------------
--
-- unit name: SYNC Module Sync Generator (sync_module_syncgen_ent)
--
--! @brief 
--
--! @author Rodrigo França (rodrigo.franca@maua.br)
--
--! @date 06\02\2018
--
--! @version v1.0
--
--! @details
--!
--! <b>Dependencies:</b>\n
--! sync_module_pkg
--!
--! <b>References:</b>\n
--!
--! <b>Modified by:</b>\n
--! Author: Rodrigo França
-------------------------------------------------------------------------------
--! \n\n<b>Last changes:</b>\n
--! 29\03\2018 RF File Creation\n
--
-------------------------------------------------------------------------------
--! @todo <next thing to do> \n
--! <another thing to do> \n
--
-------------------------------------------------------------------------------

--============================================================================
--! Entity declaration for SYNC Module Sync Generator
--============================================================================

entity sync_module_syncgen_ent is
	port(
		-- Global input signals
		--! Local clock used by the SYNC Module
		clk_i     : in  std_logic;      --! Local sync clock
		reset_n_i : in  std_logic;      --! Reset = '0': reset active; Reset = '1': no reset

		control_i : in  t_sync_module_syncgen_control;
		configs_i : in  t_sync_module_syncgen_configs;
		-- global output signals

		flags_o   : out t_sync_module_syncgen_flags;
		error_o   : out t_sync_module_syncgen_error
		-- data bus(es)
	);
end entity sync_module_syncgen_ent;

--============================================================================
-- ! architecture declaration
--============================================================================
architecture rtl of sync_module_syncgen_ent is

	-- SYMBOLIC ENCODED state machine: s_SYNC_MODULE_SYNCGEN_STATE
	-- ===========================================================
	type t_sync_module_syncgen_state is (
		IDLE,
		SYNCGEN_FINISH_OPERATION
	);
	signal s_sync_module_syncgen_state : t_sync_module_syncgen_state; -- current state

	--============================================================================
	-- architecture begin
	--============================================================================
begin

	--============================================================================
	-- Beginning of p_rmap_target_top
	--! FIXME Top Process for RMAP Target Codec, responsible for general reset 
	--! and registering inputs and outputs
	--! read: clk_i, reset_n_i \n
	--! write: - \n
	--! r/w: - \n
	--============================================================================

	--=============================================================================
	-- Begin of SYNC Module SyncGen Finite State Machine
	-- (state transitions)
	--=============================================================================
	-- read: clk_i, s_reset_n
	-- write:
	-- r/w: s_sync_module_syncgen_state
	p_sync_module_syncgen_FSM_state : process(clk_i, reset_n_i)
	begin
		-- on asynchronous reset in any state we jump to the idle state
		if (reset_n_i = '0') then
			s_sync_module_syncgen_state <= IDLE;
		-- state transitions are always synchronous to the clock
		elsif (rising_edge(clk_i)) then
			case (s_sync_module_syncgen_state) is

				-- state "IDLE"
				when IDLE =>
					-- 
					-- default state transition
					s_sync_module_syncgen_state <= IDLE;
				-- default internal signal values
				-- conditional state transition and internal signal values

				-- state "SYNCGEN_FINISH_OPERATION"
				when SYNCGEN_FINISH_OPERATION =>
					-- 
					-- default state transition
					s_sync_module_syncgen_state <= SYNCGEN_FINISH_OPERATION;
				-- default internal signal values
				-- conditional state transition and internal signal values

				-- all the other states (not defined)
				when others =>
					-- jump to save state (ERROR?!)
					s_sync_module_syncgen_state <= IDLE;

			end case;
		end if;
	end process p_sync_module_syncgen_FSM_state;

	--=============================================================================
	-- Begin of SYNC Module SyncGen Finite State Machine
	-- (output generation)
	--=============================================================================
	-- read: s_sync_module_syncgen_state, reset_n_i
	-- write:
	-- r/w:
	p_sync_module_syncgen_FSM_output : process(s_sync_module_syncgen_state, reset_n_i)
	begin
		-- asynchronous reset
		if (reset_n_i = '0') then
		-- output generation when s_sync_module_syncgen_state changes
		else
			case (s_sync_module_syncgen_state) is

				-- state "IDLE"
				when IDLE =>
					-- 
					-- default output signals
					-- conditional output signals

					-- state "SYNCGEN_FINISH_OPERATION"
				when SYNCGEN_FINISH_OPERATION =>
					-- 
					-- default output signals
					-- conditional output signals

					-- all the other states (not defined)
				when others =>
					null;

			end case;
		end if;
	end process p_sync_module_syncgen_FSM_output;

end architecture rtl;
--============================================================================
-- architecture end
--============================================================================
