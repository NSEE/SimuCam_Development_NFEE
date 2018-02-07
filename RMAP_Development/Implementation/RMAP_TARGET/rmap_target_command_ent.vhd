--=============================================================================
--! @file rmap_target_command_ent.vhd
--=============================================================================
--! Standard library
library IEEE;
--! Standard packages
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--! Specific packages
use work.RMAP_TARGET_PKG.ALL;
-------------------------------------------------------------------------------
-- --
-- Instituto Mauá de Tecnologia, Núcleo de Sistemas Eletrônicos Embarcados --
-- Plato Project --
-- --
-------------------------------------------------------------------------------
--
-- unit name: RMAP Target Command Parsing (rmap_target_command_ent)
--
--! @brief Entity for Target RMAP Command Parsing. Handles the receive of  
--! SpaceWire data (in flag + data format) and the parsing of all RMAP Command 
--! Header fields. Its purpose is to parse a incoming RMAP Command, collecting 
--! the header data and handling errors.
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
--! rmap_target_pkg
--!
--! <b>References:</b>\n
--! SpaceWire - Remote memory access protocol, ECSS-E-ST-50-52C, 2010.02.05 \n
--!
--! <b>Modified by:</b>\n
--! Author: Rodrigo França
-------------------------------------------------------------------------------
--! \n\n<b>Last changes:</b>\n
--! 06\02\2018 RF File Creation\n
--
-------------------------------------------------------------------------------
--! @todo <next thing to do> \n
--! <another thing to do> \n
--
-------------------------------------------------------------------------------

--============================================================================
--! Entity declaration for RMAP Target Command Parsing
--============================================================================

entity rmap_target_command_ent is
	port(
		-- Global input signals
		--! Local clock used by the RMAP Codec
		clk_i     : in std_logic;       --! Local rmap clock
		reset_n_i : in std_logic        --! Reset = '0': reset active; Reset = '1': no reset
		-- global output signals
		-- data bus(es)
	);
end entity rmap_target_command_ent;

--============================================================================
-- ! architecture declaration
--============================================================================
architecture rtl of rmap_target_command_ent is

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
	p_rmap_target_command_process : process(clk_i)
	begin
		if (reset_n_i = '0') then       -- asynchronous reset
			-- reset to default value
		elsif (rising_edge(clk_i)) then -- synchronous process
			-- generate clock signal and LED output
		end if;
	end process p_rmap_target_command_process;

end architecture rtl;
--============================================================================
-- architecture end
--============================================================================
