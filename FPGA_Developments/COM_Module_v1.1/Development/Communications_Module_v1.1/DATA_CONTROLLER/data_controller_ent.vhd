library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_controller_ent is
	port(
		clk_i               : in  std_logic;
		rst_i               : in  std_logic;
		window_data_i       : in  std_logic_vector(63 downto 0);
		window_mask_i       : in  std_logic_vector(63 downto 0);
		window_data_ready_i : in  std_logic;
		window_mask_ready_i : in  std_logic;
		spw_txrdy_i         : in  std_logic;
		window_data_read_o  : out std_logic;
		window_mask_read_o  : out std_logic;
		spw_txwrite_o       : out std_logic;
		spw_txflag_o        : out std_logic;
		spw_txdata_o        : out std_logic_vector(7 downto 0)
	);
end entity data_controller_ent;

architecture RTL of data_controller_ent is

	type t_data_controller_fsm is (
		IDLE,
		DATA_FETCH,
		PIXEL_0_BYTE_0,
		PIXEL_0_BYTE_1,
		PIXEL_1_BYTE_0,
		PIXEL_1_BYTE_1,
		PIXEL_2_BYTE_0,
		PIXEL_2_BYTE_1,
		PIXEL_3_BYTE_0,
		PIXEL_3_BYTE_1,
		END_OF_PACKAGE
	);

	signal s_data_controller_state : t_data_controller_fsm;

	signal s_registered_window_data : std_logic_vector(63 downto 0);

	signal s_packet_size_counter : natural range 0 to 512;

begin

	p_data_controller : process(clk_i, rst_i) is
	begin
		if (rst_i = '1') then
			window_data_read_o       <= '0';
			window_mask_read_o       <= '0';
			spw_txwrite_o            <= '0';
			spw_txflag_o             <= '0';
			spw_txdata_o             <= (others => '0');
			s_data_controller_state  <= IDLE;
			s_registered_window_data <= (others => '0');
			s_packet_size_counter    <= 0;
		elsif rising_edge(clk_i) then

			window_data_read_o <= '0';
			window_mask_read_o <= '0';
			spw_txwrite_o      <= '0';
			spw_txflag_o       <= '0';
			spw_txdata_o       <= (others => '0');

			case (s_data_controller_state) is

				when IDLE =>
					s_data_controller_state <= IDLE;
					-- check if the windowing buffer is ready
					if (window_data_ready_i = '1') then
						-- fetch data
						window_data_read_o      <= '1';
						s_data_controller_state <= DATA_FETCH;
					end if;

				when DATA_FETCH =>
					s_registered_window_data <= window_data_i;
					s_data_controller_state  <= PIXEL_0_BYTE_0;

				when PIXEL_0_BYTE_0 =>
					s_data_controller_state <= PIXEL_0_BYTE_0;
					if (spw_txrdy_i = '1') then
						spw_txwrite_o           <= '1';
						spw_txflag_o            <= '0';
						spw_txdata_o            <= s_registered_window_data(7 downto 0);
						s_packet_size_counter   <= s_packet_size_counter + 1;
						s_data_controller_state <= PIXEL_0_BYTE_1;
					end if;

				when PIXEL_0_BYTE_1 =>
					s_data_controller_state <= PIXEL_0_BYTE_1;
					if (spw_txrdy_i = '1') then
						spw_txwrite_o           <= '1';
						spw_txflag_o            <= '0';
						spw_txdata_o            <= s_registered_window_data(15 downto 8);
						s_packet_size_counter   <= s_packet_size_counter + 1;
						s_data_controller_state <= PIXEL_1_BYTE_0;
					end if;

				when PIXEL_1_BYTE_0 =>
					s_data_controller_state <= PIXEL_1_BYTE_0;
					if (spw_txrdy_i = '1') then
						spw_txwrite_o           <= '1';
						spw_txflag_o            <= '0';
						spw_txdata_o            <= s_registered_window_data(23 downto 16);
						s_packet_size_counter   <= s_packet_size_counter + 1;
						s_data_controller_state <= PIXEL_1_BYTE_1;
					end if;

				when PIXEL_1_BYTE_1 =>
					s_data_controller_state <= PIXEL_1_BYTE_1;
					if (spw_txrdy_i = '1') then
						spw_txwrite_o           <= '1';
						spw_txflag_o            <= '0';
						spw_txdata_o            <= s_registered_window_data(31 downto 24);
						s_packet_size_counter   <= s_packet_size_counter + 1;
						s_data_controller_state <= PIXEL_2_BYTE_0;
					end if;

				when PIXEL_2_BYTE_0 =>
					s_data_controller_state <= PIXEL_2_BYTE_0;
					if (spw_txrdy_i = '1') then
						spw_txwrite_o           <= '1';
						spw_txflag_o            <= '0';
						spw_txdata_o            <= s_registered_window_data(7 downto 32);
						s_packet_size_counter   <= s_packet_size_counter + 1;
						s_data_controller_state <= PIXEL_2_BYTE_1;
					end if;

				when PIXEL_2_BYTE_1 =>
					s_data_controller_state <= PIXEL_2_BYTE_1;
					if (spw_txrdy_i = '1') then
						spw_txwrite_o           <= '1';
						spw_txflag_o            <= '0';
						spw_txdata_o            <= s_registered_window_data(47 downto 40);
						s_packet_size_counter   <= s_packet_size_counter + 1;
						s_data_controller_state <= PIXEL_3_BYTE_0;
					end if;

				when PIXEL_3_BYTE_0 =>
					s_data_controller_state <= PIXEL_3_BYTE_0;
					if (spw_txrdy_i = '1') then
						spw_txwrite_o           <= '1';
						spw_txflag_o            <= '0';
						spw_txdata_o            <= s_registered_window_data(55 downto 48);
						s_packet_size_counter   <= s_packet_size_counter + 1;
						s_data_controller_state <= PIXEL_3_BYTE_1;
					end if;

				when PIXEL_3_BYTE_1 =>
					s_data_controller_state <= PIXEL_3_BYTE_1;
					if (spw_txrdy_i = '1') then
						spw_txwrite_o <= '1';
						spw_txflag_o  <= '0';
						spw_txdata_o  <= s_registered_window_data(63 downto 56);
						if (s_packet_size_counter = 127) then
							s_packet_size_counter   <= 0;
							s_data_controller_state <= END_OF_PACKAGE;
						else
							s_packet_size_counter <= s_packet_size_counter + 1;
							if (window_data_ready_i = '1') then
								window_data_read_o      <= '1';
								s_data_controller_state <= DATA_FETCH;
							else
								s_data_controller_state <= IDLE;
							end if;
						end if;
					end if;

				when END_OF_PACKAGE =>
					s_data_controller_state <= END_OF_PACKAGE;
					if (spw_txrdy_i = '1') then
						spw_txwrite_o           <= '1';
						spw_txflag_o            <= '1';
						spw_txdata_o            <= (others => '0');
						s_packet_size_counter   <= 0;
						s_data_controller_state <= IDLE;
					end if;

				when others =>
					s_data_controller_state <= IDLE;

			end case;

		end if;
	end process p_data_controller;

end architecture RTL;
