library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_controller_ent is
	port(
		clk_i                 : in  std_logic;
		rst_i                 : in  std_logic;
		mask_enable_i         : in  std_logic;
		window_data_R_i       : in  std_logic_vector(63 downto 0);
		window_mask_R_i       : in  std_logic_vector(63 downto 0);
		window_data_R_ready_i : in  std_logic;
		window_mask_R_ready_i : in  std_logic;
		window_data_L_i       : in  std_logic_vector(63 downto 0);
		window_mask_L_i       : in  std_logic_vector(63 downto 0);
		window_data_L_ready_i : in  std_logic;
		window_mask_L_ready_i : in  std_logic;
		spw_txrdy_i           : in  std_logic;
		spw_txhalff_i         : in  std_logic;
		window_data_R_read_o  : out std_logic;
		window_mask_R_read_o  : out std_logic;
		window_data_L_read_o  : out std_logic;
		window_mask_L_read_o  : out std_logic;
		spw_txwrite_o         : out std_logic;
		spw_txflag_o          : out std_logic;
		spw_txdata_o          : out std_logic_vector(7 downto 0)
	);
end entity data_controller_ent;

architecture RTL of data_controller_ent is

	type t_data_controller_fsm is (
		IDLE,
		MASK_FETCH,
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
	signal s_registered_window_mask : std_logic_vector(63 downto 0);

	signal s_packet_size_counter : natural range 0 to 512;
	signal s_mask_counter        : natural range 0 to 63;

	signal s_windowing_buffer_side      : std_logic; -- '0' = Right, '1' = Left
	signal s_next_windowing_buffer_side : std_logic; -- '0' = Right, '1' = Left

	signal s_delay : std_logic;

begin

	p_data_controller : process(clk_i, rst_i) is
	begin
		if (rst_i = '1') then
			window_data_R_read_o         <= '0';
			window_mask_R_read_o         <= '0';
			window_data_L_read_o         <= '0';
			window_mask_L_read_o         <= '0';
			spw_txwrite_o                <= '0';
			spw_txflag_o                 <= '0';
			spw_txdata_o                 <= (others => '0');
			s_data_controller_state      <= IDLE;
			s_registered_window_data     <= (others => '0');
			s_registered_window_mask     <= (others => '0');
			s_packet_size_counter        <= 0;
			s_mask_counter               <= 0;
			s_windowing_buffer_side      <= '0';
			s_next_windowing_buffer_side <= '0';
			s_delay                      <= '0';
		elsif rising_edge(clk_i) then

			window_data_R_read_o <= '0';
			window_mask_R_read_o <= '0';
			window_data_L_read_o <= '0';
			window_mask_L_read_o <= '0';
			spw_txwrite_o        <= '0';
			spw_txflag_o         <= '0';
			spw_txdata_o         <= (others => '0');
			s_delay              <= '0';

			case (s_data_controller_state) is

				when IDLE =>
					s_data_controller_state <= IDLE;
					s_packet_size_counter   <= 0;
					s_mask_counter          <= 0;
					-- check if the masking is enabled
					if (mask_enable_i = '1') then
						-- masking enabled
						-- check next buffer side
						if (s_next_windowing_buffer_side = '0') then
							-- check if the rigth windowing buffer is ready
							if ((window_data_R_ready_i = '1') and (window_mask_R_ready_i = '1')) then
								-- fetch mask and data
								window_mask_R_read_o         <= '1';
								s_windowing_buffer_side      <= '0';
								s_next_windowing_buffer_side <= '0';
								s_data_controller_state      <= MASK_FETCH;
							-- check if the left windowing buffer is ready
							elsif ((window_data_L_ready_i = '1') and (window_mask_L_ready_i = '1')) then
								-- fetch mask and data
								window_mask_L_read_o         <= '1';
								s_windowing_buffer_side      <= '1';
								s_next_windowing_buffer_side <= '1';
								s_data_controller_state      <= MASK_FETCH;
							end if;
						else
							-- check if the left windowing buffer is ready
							if ((window_data_L_ready_i = '1') and (window_mask_L_ready_i = '1')) then
								-- fetch mask and data
								window_mask_L_read_o         <= '1';
								s_windowing_buffer_side      <= '1';
								s_next_windowing_buffer_side <= '1';
								s_data_controller_state      <= MASK_FETCH;
							-- check if the rigth windowing buffer is ready
							elsif ((window_data_R_ready_i = '1') and (window_mask_R_ready_i = '1')) then
								-- fetch mask and data
								window_mask_R_read_o         <= '1';
								s_windowing_buffer_side      <= '0';
								s_next_windowing_buffer_side <= '0';
								s_data_controller_state      <= MASK_FETCH;
							end if;
						end if;
					else
						-- masking not enabled
						-- check next buffer side
						if (s_next_windowing_buffer_side = '0') then
							-- check if the rigth windowing buffer is ready

							-- check if the rigth windowing buffer is ready
							if (window_data_R_ready_i = '1') then
								-- fetch data
								window_data_R_read_o         <= '1';
								s_windowing_buffer_side      <= '0';
								s_next_windowing_buffer_side <= '0';
								s_registered_window_mask     <= (others => '1');
								s_data_controller_state      <= DATA_FETCH;
							-- check if the left windowing buffer is ready
							elsif (window_data_L_ready_i = '1') then
								-- fetch data
								window_data_L_read_o         <= '1';
								s_windowing_buffer_side      <= '1';
								s_next_windowing_buffer_side <= '1';
								s_registered_window_mask     <= (others => '1');
								s_data_controller_state      <= DATA_FETCH;
							end if;
						else
							-- check if the left windowing buffer is ready
							if (window_data_L_ready_i = '1') then
								-- fetch data
								window_data_L_read_o         <= '1';
								s_windowing_buffer_side      <= '1';
								s_next_windowing_buffer_side <= '1';
								s_registered_window_mask     <= (others => '1');
								s_data_controller_state      <= DATA_FETCH;
							-- check if the rigth windowing buffer is ready
							elsif (window_data_R_ready_i = '1') then
								-- fetch data
								window_data_R_read_o         <= '1';
								s_windowing_buffer_side      <= '0';
								s_next_windowing_buffer_side <= '0';
								s_registered_window_mask     <= (others => '1');
								s_data_controller_state      <= DATA_FETCH;
							end if;
						end if;
					end if;

				when MASK_FETCH =>
					-- check if the delay for the data fetch already happened
					if (s_delay = '1') then
						-- delay happened
						s_delay                 <= '0';
						-- check if the used buffer is the right side
						if (s_windowing_buffer_side = '0') then
							-- right side
							s_registered_window_mask <= window_mask_R_i;
							window_data_R_read_o     <= '1';
							window_data_L_read_o <= '0';
						else
							-- left side
							s_registered_window_mask <= window_mask_L_i;
							window_data_R_read_o <= '0';
							window_data_L_read_o     <= '1';
						end if;
						s_data_controller_state <= DATA_FETCH;
					else
						-- delay not happened yet
						s_delay                 <= '1';
						s_data_controller_state <= MASK_FETCH;
					end if;

				when DATA_FETCH =>
					-- check if the delay for the data fetch already happened
					if (s_delay = '1') then
						-- delay happened
						s_delay                 <= '0';
						-- check if the used buffer is the right side
						if (s_windowing_buffer_side = '0') then
							-- right side
							s_registered_window_data <= window_data_R_i;
						else
							-- left side
							s_registered_window_data <= window_data_L_i;
						end if;
						s_data_controller_state <= PIXEL_0_BYTE_0;
					else
						-- delay not happened yet
						s_delay                 <= '1';
						s_data_controller_state <= DATA_FETCH;
					end if;

				when PIXEL_0_BYTE_0 =>
					s_data_controller_state <= PIXEL_0_BYTE_0;
					if ((spw_txrdy_i = '1') and (spw_txhalff_i = '0')) then
						-- check if the bit is masked
						if (s_registered_window_mask(s_mask_counter) = '1') then
							spw_txwrite_o <= '1';
							spw_txflag_o  <= '0';
							spw_txdata_o  <= s_registered_window_data(7 downto 0);
						end if;
						s_packet_size_counter   <= s_packet_size_counter + 1;
						s_data_controller_state <= PIXEL_0_BYTE_1;
					end if;

				when PIXEL_0_BYTE_1 =>
					s_data_controller_state <= PIXEL_0_BYTE_1;
					if ((spw_txrdy_i = '1') and (spw_txhalff_i = '0')) then
						-- check if the bit is masked
						if (s_registered_window_mask(s_mask_counter) = '1') then
							spw_txwrite_o <= '1';
							spw_txflag_o  <= '0';
							spw_txdata_o  <= s_registered_window_data(15 downto 8);
						end if;
						s_packet_size_counter   <= s_packet_size_counter + 1;
						s_mask_counter          <= s_mask_counter + 1;
						s_data_controller_state <= PIXEL_1_BYTE_0;
					end if;

				when PIXEL_1_BYTE_0 =>
					s_data_controller_state <= PIXEL_1_BYTE_0;
					if ((spw_txrdy_i = '1') and (spw_txhalff_i = '0')) then
						-- check if the bit is masked
						if (s_registered_window_mask(s_mask_counter) = '1') then
							spw_txwrite_o <= '1';
							spw_txflag_o  <= '0';
							spw_txdata_o  <= s_registered_window_data(23 downto 16);
						end if;
						s_packet_size_counter   <= s_packet_size_counter + 1;
						s_data_controller_state <= PIXEL_1_BYTE_1;
					end if;

				when PIXEL_1_BYTE_1 =>
					s_data_controller_state <= PIXEL_1_BYTE_1;
					if ((spw_txrdy_i = '1') and (spw_txhalff_i = '0')) then
						-- check if the bit is masked
						if (s_registered_window_mask(s_mask_counter) = '1') then
							spw_txwrite_o <= '1';
							spw_txflag_o  <= '0';
							spw_txdata_o  <= s_registered_window_data(31 downto 24);
						end if;
						s_packet_size_counter   <= s_packet_size_counter + 1;
						s_mask_counter          <= s_mask_counter + 1;
						s_data_controller_state <= PIXEL_2_BYTE_0;
					end if;

				when PIXEL_2_BYTE_0 =>
					s_data_controller_state <= PIXEL_2_BYTE_0;
					if ((spw_txrdy_i = '1') and (spw_txhalff_i = '0')) then
						-- check if the bit is masked
						if (s_registered_window_mask(s_mask_counter) = '1') then
							spw_txwrite_o <= '1';
							spw_txflag_o  <= '0';
							spw_txdata_o  <= s_registered_window_data(39 downto 32);
						end if;
						s_packet_size_counter   <= s_packet_size_counter + 1;
						s_data_controller_state <= PIXEL_2_BYTE_1;
					end if;

				when PIXEL_2_BYTE_1 =>
					s_data_controller_state <= PIXEL_2_BYTE_1;
					if ((spw_txrdy_i = '1') and (spw_txhalff_i = '0')) then
						-- check if the bit is masked
						if (s_registered_window_mask(s_mask_counter) = '1') then
							spw_txwrite_o <= '1';
							spw_txflag_o  <= '0';
							spw_txdata_o  <= s_registered_window_data(47 downto 40);
						end if;
						s_packet_size_counter   <= s_packet_size_counter + 1;
						s_mask_counter          <= s_mask_counter + 1;
						s_data_controller_state <= PIXEL_3_BYTE_0;
					end if;

				when PIXEL_3_BYTE_0 =>
					s_data_controller_state <= PIXEL_3_BYTE_0;
					if ((spw_txrdy_i = '1') and (spw_txhalff_i = '0')) then
						-- check if the bit is masked
						if (s_registered_window_mask(s_mask_counter) = '1') then
							spw_txwrite_o <= '1';
							spw_txflag_o  <= '0';
							spw_txdata_o  <= s_registered_window_data(55 downto 48);
						end if;
						s_packet_size_counter   <= s_packet_size_counter + 1;
						s_data_controller_state <= PIXEL_3_BYTE_1;
					end if;

				when PIXEL_3_BYTE_1 =>
					s_data_controller_state <= PIXEL_3_BYTE_1;
					if ((spw_txrdy_i = '1') and (spw_txhalff_i = '0')) then
						-- check if the bit is masked
						if (s_registered_window_mask(s_mask_counter) = '1') then
							spw_txwrite_o <= '1';
							spw_txflag_o  <= '0';
							spw_txdata_o  <= s_registered_window_data(63 downto 56);
						end if;
						if (s_mask_counter < 63) then
							s_mask_counter <= s_mask_counter + 1;
						else
							s_mask_counter <= 0;
						end if;
						if (s_packet_size_counter = 127) then
							s_packet_size_counter   <= 0;
							s_data_controller_state <= END_OF_PACKAGE;
						else
							s_packet_size_counter <= s_packet_size_counter + 1;
							-- check if the masking is enabled
							if (mask_enable_i = '1') then
								-- masking enabled
								-- check the active side
								if (s_windowing_buffer_side = '0') then
									-- rigth side activated
									-- check if the windowing buffer is ready
									if (window_data_R_ready_i = '1') then
										-- fetch mask and data
										-- check if the current mask ended, fetch new mask
										if (s_mask_counter = 63) then
											-- current mask ended
											-- check if there is more mask available
											if (window_mask_R_ready_i = '1') then
												window_mask_R_read_o    <= '1';
												s_data_controller_state <= MASK_FETCH;
											else
												s_data_controller_state <= IDLE;
											end if;
										else
											-- current mask have not ended yet, fetch more data
											window_data_R_read_o    <= '1';
											s_data_controller_state <= DATA_FETCH;
										end if;
									else
										s_data_controller_state <= IDLE;
									end if;
								else
									-- left side activated
									-- check if the windowing buffer is ready
									if (window_data_L_ready_i = '1') then
										-- fetch mask and data
										-- check if the current mask ended, fetch new mask
										if (s_mask_counter = 63) then
											-- current mask ended
											-- check if there is more mask available
											if (window_mask_L_ready_i = '1') then
												window_mask_L_read_o    <= '1';
												s_data_controller_state <= MASK_FETCH;
											else
												s_data_controller_state <= IDLE;
											end if;
										else
											-- current mask have not ended yet, fetch more data
											window_data_L_read_o    <= '1';
											s_data_controller_state <= DATA_FETCH;
										end if;
									else
										s_data_controller_state <= IDLE;
									end if;
								end if;
							else
								-- masking not enabled
								-- check the active side
								if (s_windowing_buffer_side = '0') then
									-- rigth side activated
									-- check if the windowing buffer is ready
									if (window_data_R_ready_i = '1') then
										-- fetch data
										window_data_R_read_o     <= '1';
										s_registered_window_mask <= (others => '1');
										s_data_controller_state  <= DATA_FETCH;
									else
										s_data_controller_state <= IDLE;
									end if;
								else
									-- left side activated
									-- check if the windowing buffer is ready
									if (window_data_L_ready_i = '1') then
										-- fetch data
										window_data_L_read_o     <= '1';
										s_registered_window_mask <= (others => '1');
										s_data_controller_state  <= DATA_FETCH;
									else
										s_data_controller_state <= IDLE;
									end if;
								end if;
							end if;
						end if;
					end if;

				when END_OF_PACKAGE =>
					s_data_controller_state <= END_OF_PACKAGE;
					if ((spw_txrdy_i = '1') and (spw_txhalff_i = '0')) then
						spw_txwrite_o                <= '1';
						spw_txflag_o                 <= '1';
						spw_txdata_o                 <= (others => '0');
						s_packet_size_counter        <= 0;
						s_mask_counter               <= 0;
						s_next_windowing_buffer_side <= not (s_windowing_buffer_side);
						s_data_controller_state      <= IDLE;
					end if;

				when others =>
					s_data_controller_state <= IDLE;

			end case;

		end if;
	end process p_data_controller;

end architecture RTL;
