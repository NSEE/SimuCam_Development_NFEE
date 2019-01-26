-- TODO: adicionar delays
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity masking_machine_ent is
	port(
		clk_i                         : in  std_logic;
		rst_i                         : in  std_logic;
		current_timecode_i            : in  std_logic_vector(7 downto 0);
		window_data_i                 : in  std_logic_vector(63 downto 0);
		window_mask_i                 : in  std_logic_vector(63 downto 0);
		window_data_ready_i           : in  std_logic;
		window_mask_ready_i           : in  std_logic;
		masking_buffer_clear_i        : in  std_logic;
		masking_buffer_rdreq_i        : in  std_logic;
		window_data_read_o            : out std_logic;
		window_mask_read_o            : out std_logic;
		masking_buffer_almost_empty_o : out std_logic;
		masking_buffer_empty_o        : out std_logic;
		masking_buffer_rddata_o       : out std_logic_vector(7 downto 0)
	);
end entity masking_machine_ent;

architecture RTL of masking_machine_ent is

	function f_pixel_msb_change_timecode(pixel_msb_i : in std_logic_vector; timecode_i : in std_logic_vector) return std_logic_vector is
		variable v_new_pixel_msb : std_logic_vector(7 downto 0);
	begin

		-- generic pixel pattern (according to PLATO-DLR-PL-ICD-0002, issue 1.2):
		-- |  timecode[2:0] |       ccd      |      side      |    row[4:0]    |   column[4:0]  |
		-- |  15 downto 13  |  12 downto 11  |       10       |   9 downto  5  |   4 downto  0  |
		--
		-- pixel msb pattern:
		-- |  timecode[2:0] |       ccd      |      side      |    row[4:3]    |
		-- |   7 downto  5  |   4 downto  3  |        2       |   1 downto  0  |
		--
		-- pixel lsb pattern:
		-- |    row[2:0]    |   column[4:0]  |
		-- |   7 downto  5  |   4 downto  0  |
		--
		-- timecode pixel msb replacement:
		-- s_new_pixel_msb(7 downto 5) <= s_timecode(2 downto 0);
		-- s_new_pixel_msb(4 downto 0) <= s_old_pixel_msb(4 downto 0);

		-- timecode pixel msb replacement:
		v_new_pixel_msb(7 downto 5) := timecode_i(2 downto 0);
		v_new_pixel_msb(4 downto 0) := pixel_msb_i(4 downto 0);

		return v_new_pixel_msb;
	end function f_pixel_msb_change_timecode;

	-- TODO: adicionar delays
	type t_masking_machine_fsm is (
		IDLE,
		MASK_FETCH,
		DATA_FETCH,
		PIXEL_0_BYTE_MSB,
		PIXEL_0_BYTE_LSB,
		PIXEL_1_BYTE_MSB,
		PIXEL_1_BYTE_LSB,
		PIXEL_2_BYTE_MSB,
		PIXEL_2_BYTE_LSB,
		PIXEL_3_BYTE_MSB,
		PIXEL_3_BYTE_LSB
		--		LINE_DELAY,
		--		COLUMN_DELAY,
		--		ADC_DELAY,
	);

	signal s_masking_machine_state : t_masking_machine_fsm;

	signal s_registered_window_data : std_logic_vector(63 downto 0);
	signal s_registered_window_mask : std_logic_vector(63 downto 0);

	signal s_mask_counter : natural range 0 to 63;

	signal s_delay : std_logic;

begin

	p_masking_machine : process(clk_i, rst_i) is
	begin
		if (rst_i = '1') then
			window_data_read_o       <= '0';
			window_mask_read_o       <= '0';
			spw_txwrite_o            <= '0';
			spw_txflag_o             <= '0';
			spw_txdata_o             <= (others => '0');
			s_masking_machine_state  <= IDLE;
			s_registered_window_data <= (others => '0');
			s_registered_window_mask <= (others => '0');
			s_mask_counter           <= 0;
			s_delay                  <= '0';
		elsif rising_edge(clk_i) then

			window_data_read_o <= '0';
			window_mask_read_o <= '0';
			spw_txwrite_o      <= '0';
			spw_txflag_o       <= '0';
			spw_txdata_o       <= (others => '0');
			s_delay            <= '0';

			-- TODO: adicionar delays
			case (s_masking_machine_state) is

				when IDLE =>
					s_masking_machine_state <= IDLE;
					s_mask_counter          <= 0;
					-- check if the windowing buffer is ready
					if ((window_data_ready_i = '1') and (window_mask_ready_i = '1')) then
						-- fetch mask and data
						window_mask_read_o      <= '1';
						s_masking_machine_state <= MASK_FETCH;
					end if;

				when MASK_FETCH =>
					-- check if the delay for the data fetch already happened
					if (s_delay = '1') then
						-- delay happened
						s_delay                  <= '0';
						-- register buffer mask data
						s_registered_window_mask <= window_mask_i;
						window_data_read_o       <= '1';
						s_masking_machine_state  <= DATA_FETCH;
					else
						-- delay not happened yet
						s_delay                 <= '1';
						s_masking_machine_state <= MASK_FETCH;
					end if;

				when DATA_FETCH =>
					-- check if the delay for the data fetch already happened
					if (s_delay = '1') then
						-- delay happened
						s_delay                  <= '0';
						-- register buffer pixel data
						s_registered_window_data <= window_data_i;
						s_masking_machine_state  <= PIXEL_0_BYTE_MSB;
					else
						-- delay not happened yet
						s_delay                 <= '1';
						s_masking_machine_state <= DATA_FETCH;
					end if;

				when PIXEL_0_BYTE_MSB =>
					s_masking_machine_state <= PIXEL_0_BYTE_MSB;
					-- TODO: mudar para fifo
					if ((spw_txrdy_i = '1') and (spw_txhalff_i = '0')) then
						-- check if the bit is masked
						if (s_registered_window_mask(s_mask_counter) = '1') then
							spw_txwrite_o <= '1';
							spw_txflag_o  <= '0';
							spw_txdata_o  <= f_pixel_msb_change_timecode(s_registered_window_data(7 downto 0), current_timecode_i);
						end if;
						s_masking_machine_state <= PIXEL_0_BYTE_LSB;
					end if;

				when PIXEL_0_BYTE_LSB =>
					s_masking_machine_state <= PIXEL_0_BYTE_LSB;
					-- TODO: mudar para fifo
					if ((spw_txrdy_i = '1') and (spw_txhalff_i = '0')) then
						-- check if the bit is masked
						if (s_registered_window_mask(s_mask_counter) = '1') then
							spw_txwrite_o <= '1';
							spw_txflag_o  <= '0';
							spw_txdata_o  <= s_registered_window_data(15 downto 8);
						end if;
						s_mask_counter          <= s_mask_counter + 1;
						s_masking_machine_state <= PIXEL_1_BYTE_MSB;
					end if;

				when PIXEL_1_BYTE_MSB =>
					s_masking_machine_state <= PIXEL_1_BYTE_MSB;
					-- TODO: mudar para fifo
					if ((spw_txrdy_i = '1') and (spw_txhalff_i = '0')) then
						-- check if the bit is masked
						if (s_registered_window_mask(s_mask_counter) = '1') then
							spw_txwrite_o <= '1';
							spw_txflag_o  <= '0';
							spw_txdata_o  <= f_pixel_msb_change_timecode(s_registered_window_data(23 downto 16), current_timecode_i);
						end if;
						s_masking_machine_state <= PIXEL_1_BYTE_LSB;
					end if;

				when PIXEL_1_BYTE_LSB =>
					s_masking_machine_state <= PIXEL_1_BYTE_LSB;
					-- TODO: mudar para fifo
					if ((spw_txrdy_i = '1') and (spw_txhalff_i = '0')) then
						-- check if the bit is masked
						if (s_registered_window_mask(s_mask_counter) = '1') then
							spw_txwrite_o <= '1';
							spw_txflag_o  <= '0';
							spw_txdata_o  <= s_registered_window_data(31 downto 24);
						end if;
						s_mask_counter          <= s_mask_counter + 1;
						s_masking_machine_state <= PIXEL_2_BYTE_MSB;
					end if;

				when PIXEL_2_BYTE_MSB =>
					s_masking_machine_state <= PIXEL_2_BYTE_MSB;
					-- TODO: mudar para fifo
					if ((spw_txrdy_i = '1') and (spw_txhalff_i = '0')) then
						-- check if the bit is masked
						if (s_registered_window_mask(s_mask_counter) = '1') then
							spw_txwrite_o <= '1';
							spw_txflag_o  <= '0';
							spw_txdata_o  <= f_pixel_msb_change_timecode(s_registered_window_data(39 downto 32), current_timecode_i);
						end if;
						s_masking_machine_state <= PIXEL_2_BYTE_LSB;
					end if;

				when PIXEL_2_BYTE_LSB =>
					s_masking_machine_state <= PIXEL_2_BYTE_LSB;
					-- TODO: mudar para fifo
					if ((spw_txrdy_i = '1') and (spw_txhalff_i = '0')) then
						-- check if the bit is masked
						if (s_registered_window_mask(s_mask_counter) = '1') then
							spw_txwrite_o <= '1';
							spw_txflag_o  <= '0';
							spw_txdata_o  <= s_registered_window_data(47 downto 40);
						end if;
						s_mask_counter          <= s_mask_counter + 1;
						s_masking_machine_state <= PIXEL_3_BYTE_MSB;
					end if;

				when PIXEL_3_BYTE_MSB =>
					s_masking_machine_state <= PIXEL_3_BYTE_MSB;
					-- TODO: mudar para fifo
					if ((spw_txrdy_i = '1') and (spw_txhalff_i = '0')) then
						-- check if the bit is masked
						if (s_registered_window_mask(s_mask_counter) = '1') then
							spw_txwrite_o <= '1';
							spw_txflag_o  <= '0';
							spw_txdata_o  <= f_pixel_msb_change_timecode(s_registered_window_data(55 downto 48), current_timecode_i);
						end if;
						s_masking_machine_state <= PIXEL_3_BYTE_LSB;
					end if;

				when PIXEL_3_BYTE_LSB =>
					s_masking_machine_state <= PIXEL_3_BYTE_LSB;
					-- TODO: mudar para fifo
					if ((spw_txrdy_i = '1') and (spw_txhalff_i = '0')) then
						-- check if the bit is masked
						if (s_registered_window_mask(s_mask_counter) = '1') then
							spw_txwrite_o <= '1';
							spw_txflag_o  <= '0';
							spw_txdata_o  <= s_registered_window_data(63 downto 56);
						end if;
						-- check mask counter
						if (s_mask_counter < 63) then
							s_mask_counter <= s_mask_counter + 1;
						else
							s_mask_counter <= 0;
						end if;

						-- check if the windowing buffer is ready
						if (window_data_ready_i = '1') then
							-- fetch mask and data
							-- check if the current mask ended, fetch new mask
							if (s_mask_counter = 63) then
								-- current mask ended
								-- check if there is more mask available
								if (window_mask_ready_i = '1') then
									window_mask_read_o      <= '1';
									s_masking_machine_state <= MASK_FETCH;
								else
									s_masking_machine_state <= IDLE;
								end if;
							else
								-- current mask have not ended yet, fetch more data
								window_data_read_o      <= '1';
								s_masking_machine_state <= DATA_FETCH;
							end if;
						else
							s_masking_machine_state <= IDLE;
						end if;
					end if;

				when others =>
					s_masking_machine_state <= IDLE;

			end case;

		end if;
	end process p_masking_machine;

end architecture RTL;
