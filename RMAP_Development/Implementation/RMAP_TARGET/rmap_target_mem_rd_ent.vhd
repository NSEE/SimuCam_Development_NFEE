--=============================================================================
--! @file rmap_target_mem_rd_ent.vhd
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
-- unit name: RMAP Target Memory Read (rmap_target_mem_rd_ent)
--
--! @brief Entity for the abstraction of the Target RMAP Codec Memory Read 
--! operation. To allow the codec to adapt to different memories, this entity 
--! performs the actual memory read, while the codec only work with control 
--! bits and status flags. If the memory read needs to be changed, only this 
--! block needs to be modified.
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
--! Entity declaration for RMAP Target Memory Read
--============================================================================

entity rmap_target_mem_rd_ent is
	generic(
		g_MEMORY_ADDRESS_WIDTH : natural range 0 to c_WIDTH_EXTENDED_ADDRESS := 32;
		g_MEMORY_ACCESS_WIDTH  : natural range 0 to c_WIDTH_MEMORY_ACCESS    := 2
	);
	port(
		-- Global input signals
		--! Local clock used by the RMAP Codec
		clk_i            : in  std_logic; --! Local rmap clock
		reset_n_i        : in  std_logic; --! Reset = '0': reset active; Reset = '1': no reset

		mem_control_i    : in  t_rmap_target_mem_rd_control;
		memory_data_i    : in  std_logic_vector(((8 * (2 ** c_WIDTH_MEMORY_ACCESS)) - 1) downto 0);
		mem_byte_address_i : in  std_logic_vector((g_MEMORY_ADDRESS_WIDTH + g_MEMORY_ACCESS_WIDTH - 1) downto 0);
		-- global output signals

		mem_flag_o       : out t_rmap_target_mem_rd_flag;
		memory_address_o   : out std_logic_vector((g_MEMORY_ADDRESS_WIDTH - 1) downto 0)
		-- data bus(es)
	);
end entity rmap_target_mem_rd_ent;

--============================================================================
-- ! architecture declaration
--============================================================================
architecture rtl of rmap_target_mem_rd_ent is

	alias a_memory_address is mem_byte_address_i((g_MEMORY_ADDRESS_WIDTH + g_MEMORY_ACCESS_WIDTH - 1) downto g_MEMORY_ACCESS_WIDTH);
	alias a_byte_address is mem_byte_address_i((g_MEMORY_ACCESS_WIDTH - 1) downto 0);

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
	p_rmap_target_mem_rd_process : process(clk_i)
	begin
		if (reset_n_i = '0') then       -- asynchronous reset
			-- reset to default value
			mem_flag_o.error <= '0';
			mem_flag_o.valid <= '1';
			mem_flag_o.data  <= (others => '0');
		elsif (rising_edge(clk_i)) then -- synchronous process
			
			if (mem_control_i.read = '1') then
				mem_flag_o.data  <= memory_data_i(((8 * (1 + a_byte_address)) - 1) downto (8 * a_byte_address));
			end if;
			
		end if;
	end process p_rmap_target_mem_rd_process;

	-- signal assingment

	memory_address_o <= a_memory_address;
	

end architecture rtl;
--============================================================================
-- architecture end
--============================================================================
