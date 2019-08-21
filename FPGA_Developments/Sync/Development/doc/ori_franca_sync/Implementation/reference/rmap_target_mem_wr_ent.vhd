--=============================================================================
--! @file rmap_target_mem_wr_ent.vhd
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
-- unit name: RMAP Target Memory Write (rmap_target_mem_wr_ent)
--
--! @brief Entity for the abstraction of the Target RMAP Codec Memory Write 
--! operation. To allow the codec to adapt to different memories, this entity 
--! performs the actual memory write, while the codec only work with control 
--! bits and status flags. If the memory write needs to be changed, only this 
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
--! Entity declaration for RMAP Target Memory Write
--============================================================================

entity rmap_target_mem_wr_ent is
	generic(
		g_MEMORY_ADDRESS_WIDTH : natural range 0 to c_WIDTH_EXTENDED_ADDRESS := 32;
		g_MEMORY_ACCESS_WIDTH  : natural range 0 to c_WIDTH_MEMORY_ACCESS    := 2
	);
	port(
		-- Global input signals
		--! Local clock used by the RMAP Codec
		clk_i              : in  std_logic; --! Local rmap clock
		reset_n_i          : in  std_logic; --! Reset = '0': reset active; Reset = '1': no reset

		mem_control_i      : in  t_rmap_target_mem_wr_control;
		mem_byte_address_i : in  std_logic_vector((g_MEMORY_ADDRESS_WIDTH + g_MEMORY_ACCESS_WIDTH - 1) downto 0);
		-- global output signals

		mem_flag_o         : out t_rmap_target_mem_wr_flag;
		memory_address_o   : out std_logic_vector((g_MEMORY_ADDRESS_WIDTH - 1) downto 0);
		memory_data_o      : out std_logic_vector(((8 * (2 ** c_WIDTH_MEMORY_ACCESS)) - 1) downto 0)
		-- data bus(es)
	);
end entity rmap_target_mem_wr_ent;

--============================================================================
-- ! architecture declaration
--============================================================================
architecture rtl of rmap_target_mem_wr_ent is

	constant c_MEMORY_ACCESS_SIZE : natural := 2 ** c_WIDTH_MEMORY_ACCESS;

	alias a_memory_address is mem_byte_address_i((g_MEMORY_ADDRESS_WIDTH + g_MEMORY_ACCESS_WIDTH - 1) downto g_MEMORY_ACCESS_WIDTH);
	alias a_byte_address is mem_byte_address_i((g_MEMORY_ACCESS_WIDTH - 1) downto 0);

	signal s_memory_data    : std_logic_vector(((8 * (2 ** c_WIDTH_MEMORY_ACCESS)) - 1) downto 0);
	signal s_memory_address : std_logic_vector((g_MEMORY_ADDRESS_WIDTH - 1) downto 0);

	signal s_write_flag : std_logic;

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
	p_rmap_target_mem_wr_process : process(clk_i)
	begin
		if (reset_n_i = '0') then       -- asynchronous reset
			-- reset to default value
			mem_flag_o.error <= '0';
			mem_flag_o.ready <= '1';
			memory_address_o <= (others => '0');
			memory_data_o    <= (others => '0');
			s_memory_data    <= (others => '0');
			s_memory_address <= (others => '0');
			s_write_flag     <= '0';
		elsif (rising_edge(clk_i)) then -- synchronous process

			if (s_write_flag = '1') then
				memory_address_o <= s_memory_address;
				memory_data_o    <= s_memory_data;
				s_write_flag     <= '0';
			end if;

			if (mem_control_i.write = '1') then
				if (c_MEMORY_ACCESS_SIZE > 1) then
					-- more than one byte
					s_memory_data(((8 * (1 + a_byte_address)) - 1) downto (8 * a_byte_address)) <= mem_control_i.data;
					if (a_byte_address = (c_MEMORY_ACCESS_SIZE - 1)) then
						-- ready to write
						s_write_flag     <= '1';
						s_memory_address <= a_memory_address;
					end if;
				else
					-- one byte
					s_write_flag     <= '1';
					s_memory_address <= a_memory_address;
					s_memory_data    <= mem_control_i.data;
				end if;
			end if;

		end if;
	end process p_rmap_target_mem_wr_process;

	-- signal assingment

end architecture rtl;
--============================================================================
-- architecture end
--============================================================================
