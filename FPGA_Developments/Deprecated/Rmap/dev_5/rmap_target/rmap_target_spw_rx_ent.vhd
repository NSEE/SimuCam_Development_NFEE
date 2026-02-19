--=============================================================================
--! @file rmap_target_spw_rx_ent.vhd
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
-- unit name: RMAP Target SpaceWire Rx (rmap_target_spw_rx_ent)
--
--! @brief Entity for the abstraction of the Target RMAP Codec SpaceWire Rx 
--! operation. To allow the codec to adapt to different spacewires modules, 
--! this entity performs the actual spacewire rx (reading from codec fifo),  
--! while the RMAP codec only work with control bits and status flags. If the  
--! spacewire rx needs to be changed, only this block needs to be modified.
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
--! Entity declaration for RMAP Target SpaceWire Rx
--============================================================================

entity rmap_target_spw_rx_ent is
	port(
		-- Global input signals
		--! Local clock used by the RMAP Codec
		clk_i         : in  std_logic;  --! Local rmap clock
		reset_n_i     : in  std_logic;  --! Reset = '0': reset active; Reset = '1': no reset

		spw_control_i : in  t_rmap_target_spw_rx_control;
		codec_valid_i : in  std_logic;
		codec_flag_i  : in  std_logic;
		codec_data_i  : in  std_logic_vector(7 downto 0);
		-- global output signals

		spw_flag_o    : out t_rmap_target_spw_rx_flag;
		codec_read_o  : out std_logic
		-- data bus(es)
	);
end entity rmap_target_spw_rx_ent;

--============================================================================
-- ! architecture declaration
--============================================================================
architecture rtl of rmap_target_spw_rx_ent is

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
	p_rmap_target_spw_rx_process : process(clk_i)
	begin
		if (reset_n_i = '0') then       -- asynchronous reset
			-- reset to default value
			spw_flag_o.error <= '0';
		elsif (rising_edge(clk_i)) then -- synchronous process
			-- generate clock signal and LED output
		end if;
	end process p_rmap_target_spw_rx_process;

	-- signal assingment

	spw_flag_o.valid <= codec_valid_i;
	spw_flag_o.flag  <= codec_flag_i;
	spw_flag_o.data  <= codec_data_i;

	codec_read_o <= spw_control_i.read;

end architecture rtl;
--============================================================================
-- architecture end
--============================================================================
