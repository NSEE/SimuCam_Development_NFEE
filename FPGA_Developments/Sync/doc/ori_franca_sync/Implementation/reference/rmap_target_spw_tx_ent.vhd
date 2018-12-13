--=============================================================================
--! @file rmap_target_spw_tx_ent.vhd
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
-- unit name: RMAP Target SpaceWire Tx (rmap_target_spw_tx_ent)
--
--! @brief Entity for the abstraction of the Target RMAP Codec SpaceWire Tx 
--! operation. To allow the codec to adapt to different spacewires modules, 
--! this entity performs the actual spacewire tx (writing to codec fifo),  
--! while the RMAP codec only work with control bits and status flags. If the  
--! spacewire tx needs to be changed, only this block needs to be modified.
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
--! Entity declaration for RMAP Target SpaceWire Tx
--============================================================================

entity rmap_target_spw_tx_ent is
	port(
		-- Global input signals
		--! Local clock used by the RMAP Codec
		clk_i         : in  std_logic;  --! Local rmap clock
		reset_n_i     : in  std_logic;  --! Reset = '0': reset active; Reset = '1': no reset

		spw_control_i : in  t_rmap_target_spw_tx_control;
		codec_ready_i : in  std_logic;
		-- global output signals

		spw_flag_o    : out t_rmap_target_spw_tx_flag;
		codec_write_o : out std_logic;
		codec_flag_o  : out std_logic;
		codec_data_o  : out std_logic_vector(7 downto 0)
		-- data bus(es)
	);
end entity rmap_target_spw_tx_ent;

--============================================================================
-- ! architecture declaration
--============================================================================
architecture rtl of rmap_target_spw_tx_ent is

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
	p_rmap_target_spw_tx_process : process(clk_i)
	begin
		if (reset_n_i = '0') then       -- asynchronous reset
			-- reset to default value
			spw_flag_o.error <= '0';
		elsif (rising_edge(clk_i)) then -- synchronous process
			-- generate clock signal and LED output
		end if;
	end process p_rmap_target_spw_tx_process;

	-- signal assingment

	spw_flag_o.ready <= codec_ready_i;

	codec_write_o <= spw_control_i.write;
	codec_flag_o  <= spw_control_i.flag;
	codec_data_o  <= spw_control_i.data;

end architecture rtl;
--============================================================================
-- architecture end
--============================================================================
