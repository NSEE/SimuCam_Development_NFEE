library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity scom_sync_manager_ent is
	port(
		clk_i             : in  std_logic;
		rst_i             : in  std_logic;
		channel_sync_i    : in  std_logic;
		ch_sync_trigger_o : out std_logic;
		ch_sync_clear_o   : out std_logic
	);
end entity scom_sync_manager_ent;

architecture RTL of scom_sync_manager_ent is

	signal s_channel_sync_delayed : std_logic;

begin

	p_scom_sync_manager : process(clk_i, rst_i) is
	begin
		if (rst_i) = '1' then

			ch_sync_trigger_o      <= '0';
			s_channel_sync_delayed <= '0';
			ch_sync_clear_o        <= '0';

		elsif rising_edge(clk_i) then

			-- trigger signals			
			ch_sync_trigger_o <= '0';
			ch_sync_clear_o   <= '0';

			-- rising edge detection (trigger signal)
			if ((s_channel_sync_delayed = '0') and (channel_sync_i = '1')) then
				ch_sync_trigger_o <= '1';
			-- falling edge detection (clear signal)
			elsif ((s_channel_sync_delayed = '1') and (channel_sync_i = '0')) then
				ch_sync_clear_o <= '1';
			end if;

			-- delay signals
			s_channel_sync_delayed <= channel_sync_i;

		end if;
	end process p_scom_sync_manager;

end architecture RTL;
