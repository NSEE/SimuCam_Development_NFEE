library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity flipflop_synchronizer_ent is
	generic(
		g_SYNCHRONIZED_SIGNAL_WIDTH : natural range 1 to 256 := 1;
		g_SYNCHRONIZATION_STAGES    : natural range 3 to 8   := 3
	);
	port(
		wrclk_i  : in  std_logic;
		rdclk_i  : in  std_logic;
		rst_i    : in  std_logic;
		rstsig_i : in  std_logic_vector((g_SYNCHRONIZED_SIGNAL_WIDTH - 1) downto 0);
		wrsig_i  : in  std_logic_vector((g_SYNCHRONIZED_SIGNAL_WIDTH - 1) downto 0);
		rdsig_o  : out std_logic_vector((g_SYNCHRONIZED_SIGNAL_WIDTH - 1) downto 0)
	);
end entity flipflop_synchronizer_ent;

architecture RTL of flipflop_synchronizer_ent is

	type t_synchronization_stages is array (1 to (g_SYNCHRONIZATION_STAGES - 1)) of std_logic_vector((g_SYNCHRONIZED_SIGNAL_WIDTH - 1) downto 0);
	signal s_synchronization_stage   : t_synchronization_stages;
	signal s_synchronization_stage_0 : std_logic_vector((g_SYNCHRONIZED_SIGNAL_WIDTH - 1) downto 0);

begin

	-- flip-flop synchronization, write side (input)
	p_wrclk_synchronization : process(wrclk_i, rst_i) is
	begin
		if (rst_i = '1') then
			s_synchronization_stage_0 <= rstsig_i;
		elsif rising_edge(wrclk_i) then
			s_synchronization_stage_0 <= wrsig_i;
		end if;
	end process p_wrclk_synchronization;

	-- flip-flop synchronization, read side (output)
	p_rdclk_synchronization : process(rdclk_i, rst_i) is
	begin
		if (rst_i = '1') then
			for stage in 1 to (g_SYNCHRONIZATION_STAGES - 1) loop
				s_synchronization_stage(stage) <= rstsig_i;
			end loop;
			rdsig_o <= rstsig_i;
		elsif rising_edge(rdclk_i) then
			s_synchronization_stage(1) <= s_synchronization_stage_0;
			for stage in 1 to (g_SYNCHRONIZATION_STAGES - 2) loop
				s_synchronization_stage(stage + 1) <= s_synchronization_stage(stage);
			end loop;
			rdsig_o                    <= s_synchronization_stage(g_SYNCHRONIZATION_STAGES - 1);
		end if;
	end process p_rdclk_synchronization;

end architecture RTL;
