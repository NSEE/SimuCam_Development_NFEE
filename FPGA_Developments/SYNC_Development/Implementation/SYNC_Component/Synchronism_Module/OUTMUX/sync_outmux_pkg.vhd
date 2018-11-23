package sync_outmux_pkg is

	type t_sync_outmux_control is record
		channel_a_enable : std_logic;
		channel_b_enable : std_logic;
		channel_c_enable : std_logic;
		channel_d_enable : std_logic;
		channel_e_enable : std_logic;
		channel_f_enable : std_logic;
		channel_g_enable : std_logic;
		channel_h_enable : std_logic;
		sync_out_enable  : std_logic;
	end record t_sync_outmux_control;

	type t_sync_outmux_output is record
		channel_a_signal : std_logic_vector(1 downto 0);
		channel_b_signal : std_logic_vector(1 downto 0);
		channel_c_signal : std_logic_vector(1 downto 0);
		channel_d_signal : std_logic_vector(1 downto 0);
		channel_e_signal : std_logic_vector(1 downto 0);
		channel_f_signal : std_logic_vector(1 downto 0);
		channel_g_signal : std_logic_vector(1 downto 0);
		channel_h_signal : std_logic_vector(1 downto 0);
		sync_out_signal  : std_logic_vector(1 downto 0);
	end record t_sync_outmux_output;

end package sync_outmux_pkg;

package body sync_outmux_pkg is

end package body sync_outmux_pkg;
