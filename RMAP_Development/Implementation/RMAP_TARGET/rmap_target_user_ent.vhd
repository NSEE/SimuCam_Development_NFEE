--=============================================================================
--! @file rmap_target_user_ent.vhd
--=============================================================================
--! Standard library
library IEEE;
--! Standard packages
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--! Specific packages
--use work.XXX.ALL;
-------------------------------------------------------------------------------
-- --
-- Instituto Mauá de Tecnologia, Núcleo de Sistemas Eletrônicos Embarcados --
-- Plato Project --
-- --
-------------------------------------------------------------------------------
--
-- unit name: RMAP Target User Application (rmap_target_user_ent)
--

--! @brief Entity for the RMAP User Application operations. It is responsible 
--! for interfacing with the final user, User Application operations (such as 
--! Target ID and Key checking, Write and Read authorization, error gathering 
--! and other) and flow control for the RMAP Codec.
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
--! None
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
--! Entity declaration for RMAP Target User Application
--============================================================================

entity rmap_target_user_ent is
	port(
		-- Global input signals
		--! Local clock used by the RMAP Codec
		clk_i     : in std_logic;       --! Local rmap clock
		reset_n_i : in std_logic        --! Reset = '0': reset active; Reset = '1': no reset
		-- global output signals
		-- data bus(es)
	);
end entity rmap_target_user_ent;

--============================================================================
-- ! architecture declaration
--============================================================================
architecture rtl of rmap_target_user_ent is

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
	p_rmap_target_user_process : process(clk_i)
	begin
		if (reset_n_i = '0') then       -- asynchronous reset
			-- reset to default value
		elsif (rising_edge(clk_i)) then -- synchronous process
			-- generate clock signal and LED output
		end if;
	end process p_rmap_target_user_process;

end architecture rtl;
--============================================================================
-- architecture end
--============================================================================
