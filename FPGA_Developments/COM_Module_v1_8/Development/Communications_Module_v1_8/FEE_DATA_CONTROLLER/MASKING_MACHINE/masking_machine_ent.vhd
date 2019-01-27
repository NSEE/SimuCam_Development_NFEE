-- TODO: adicionar delays
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity masking_machine_ent is
	port(
		clk_i                         : in  std_logic;
		rst_i                         : in  std_logic;
		-- general inputs
		sync_signal_i                 : in  std_logic;
		fee_clear_signal_i            : in  std_logic;
		fee_stop_signal_i             : in  std_logic;
		fee_start_signal_i            : in  std_logic;
		-- others
		fee_start_masking_i           : in  std_logic;
		masking_machine_hold_i        : in  std_logic;
		fee_ccd_x_size_i              : in  std_logic_vector(15 downto 0);
		fee_ccd_y_size_i              : in  std_logic_vector(15 downto 0);
		fee_line_delay_i              : in  std_logic_vector(15 downto 0);
		fee_column_delay_i            : in  std_logic_vector(15 downto 0);
		fee_adc_delay_i               : in  std_logic_vector(15 downto 0);
		current_timecode_i            : in  std_logic_vector(7 downto 0);
		window_data_i                 : in  std_logic_vector(63 downto 0);
		window_mask_i                 : in  std_logic_vector(63 downto 0);
		window_data_ready_i           : in  std_logic;
		window_mask_ready_i           : in  std_logic;
		--		masking_buffer_clear_i        : in  std_logic;
		masking_buffer_rdreq_i        : in  std_logic;
		window_data_read_o            : out std_logic;
		window_mask_read_o            : out std_logic;
		masking_buffer_almost_empty_o : out std_logic;
		masking_buffer_empty_o        : out std_logic;
		masking_buffer_rddata_o       : out std_logic_vector(7 downto 0)
	);
end entity masking_machine_ent;

architecture RTL of masking_machine_ent is

	-- function to change the timecode from the pattern pixels
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

	-- masking fifo record type
	type t_masking_fifo is record
		data  : std_logic_vector(7 downto 0);
		sclr  : std_logic;
		wrreq : std_logic;
		full  : std_logic;
		usedw : std_logic_vector(14 downto 0);
	end record t_masking_fifo;

	-- masking fifo signals
	signal s_masking_fifo : t_masking_fifo;

	-- TODO: adicionar delays

	-- masking machine fsm type
	type t_masking_machine_fsm is (
		STOPPED,
		NOT_STARTED,
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

	-- masking machine fsm state
	signal s_masking_machine_state : t_masking_machine_fsm;

	signal s_registered_window_data : std_logic_vector(63 downto 0);
	signal s_registered_window_mask : std_logic_vector(63 downto 0);

	signal s_mask_counter : natural range 0 to 63;

	signal s_delay : std_logic;

	signal s_fee_remaining_data_bytes : std_logic_vector(24 downto 0);

begin

	-- masking buffer instantiation
	masking_machine_sc_fifo_inst : entity work.masking_machine_sc_fifo
		port map(
			aclr  => rst_i,
			clock => clk_i,
			data  => s_masking_fifo.data,
			rdreq => masking_buffer_rdreq_i,
			sclr  => s_masking_fifo.sclr,
			wrreq => s_masking_fifo.wrreq,
			empty => masking_buffer_empty_o,
			full  => s_masking_fifo.full,
			q     => masking_buffer_rddata_o,
			usedw => s_masking_fifo.usedw
		);

	p_masking_machine : process(clk_i, rst_i) is
	begin
		if (rst_i = '1') then
			window_data_read_o         <= '0';
			window_mask_read_o         <= '0';
			s_masking_fifo.data        <= (others => '0');
			s_masking_fifo.rdreq       <= '0';
			s_masking_fifo.wrreq       <= '0';
			s_masking_machine_state    <= STOPPED;
			s_registered_window_data   <= (others => '0');
			s_registered_window_mask   <= (others => '0');
			s_mask_counter             <= 0;
			s_delay                    <= '0';
			s_fee_remaining_data_bytes <= (others => '0');
		elsif rising_edge(clk_i) then

			window_data_read_o      <= '0';
			window_mask_read_o      <= '0';
			s_masking_machine_state <= IDLE;
			s_delay                 <= '0';

			-- TODO: adicionar delays
			case (s_masking_machine_state) is

				when STOPPED =>
					-- stopped state. do nothing and reset
					window_data_read_o         <= '0';
					window_mask_read_o         <= '0';
					s_masking_fifo.data        <= (others => '0');
					s_masking_fifo.rdreq       <= '0';
					s_masking_fifo.wrreq       <= '0';
					s_masking_machine_state    <= STOPPED;
					s_registered_window_data   <= (others => '0');
					s_registered_window_mask   <= (others => '0');
					s_mask_counter             <= 0;
					s_delay                    <= '0';
					s_fee_remaining_data_bytes <= (others => '0');
					-- check if a start was issued
					if (fee_start_signal_i = '1') then
						-- start issued, go to idle
						s_masking_machine_state <= IDLE;
					end if;

				when NOT_STARTED =>
					window_data_read_o         <= '0';
					window_mask_read_o         <= '0';
					s_masking_fifo.data        <= (others => '0');
					s_masking_fifo.rdreq       <= '0';
					s_masking_fifo.wrreq       <= '0';
					s_masking_machine_state    <= STOPPED;
					s_registered_window_data   <= (others => '0');
					s_registered_window_mask   <= (others => '0');
					s_mask_counter             <= 0;
					s_delay                    <= '0';
					s_fee_remaining_data_bytes <= (others => '0');
					-- check if the fee requested the start of the masking
					if (fee_start_masking_i = '1') then
						-- set the remaining data bytes counter to the ccd size 
						s_fee_remaining_data_bytes <= std_logic_vector(resize(unsigned(fee_ccd_x_size_i) * unsigned(fee_ccd_y_size_i) * 2, s_fee_remaining_data_bytes'length));
						-- go to idle
						s_masking_machine_state    <= IDLE;
					end if;

				when IDLE =>
					s_masking_machine_state <= IDLE;
					s_mask_counter          <= 0;
					-- check if the windowing machine is released and the windowing buffer is ready
					if ((masking_machine_hold_i = '0') and (window_data_ready_i = '1') and (window_mask_ready_i = '1')) then
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
					-- check if masking fifo is not full
					if (s_masking_fifo.full = '0') then
						-- masking fifo has space
						-- check if the bit is masked
						if (s_registered_window_mask(s_mask_counter) = '1') then
							s_masking_fifo.wrreq       <= '1';
							s_masking_fifo.data        <= f_pixel_msb_change_timecode(s_registered_window_data(7 downto 0), current_timecode_i);
							-- decrement remaining data bytes counter
							s_fee_remaining_data_bytes <= std_logic_vector(unsigned(s_fee_remaining_data_bytes) - 1);
						end if;
						s_masking_machine_state <= PIXEL_0_BYTE_LSB;
					end if;

				when PIXEL_0_BYTE_LSB =>
					s_masking_machine_state <= PIXEL_0_BYTE_LSB;
					-- check if masking fifo is not full
					if (s_masking_fifo.full = '0') then
						-- masking fifo has space
						-- check if the bit is masked
						if (s_registered_window_mask(s_mask_counter) = '1') then
							s_masking_fifo.wrreq       <= '1';
							s_masking_fifo.data        <= s_registered_window_data(15 downto 8);
							-- decrement remaining data bytes counter
							s_fee_remaining_data_bytes <= std_logic_vector(unsigned(s_fee_remaining_data_bytes) - 1);
						end if;
						s_mask_counter          <= s_mask_counter + 1;
						s_masking_machine_state <= PIXEL_1_BYTE_MSB;
					end if;

				when PIXEL_1_BYTE_MSB =>
					s_masking_machine_state <= PIXEL_1_BYTE_MSB;
					-- check if masking fifo is not full
					if (s_masking_fifo.full = '0') then
						-- masking fifo has space
						-- check if the bit is masked
						if (s_registered_window_mask(s_mask_counter) = '1') then
							s_masking_fifo.wrreq       <= '1';
							s_masking_fifo.data        <= f_pixel_msb_change_timecode(s_registered_window_data(23 downto 16), current_timecode_i);
							-- decrement remaining data bytes counter
							s_fee_remaining_data_bytes <= std_logic_vector(unsigned(s_fee_remaining_data_bytes) - 1);
						end if;
						s_masking_machine_state <= PIXEL_1_BYTE_LSB;
					end if;

				when PIXEL_1_BYTE_LSB =>
					s_masking_machine_state <= PIXEL_1_BYTE_LSB;
					-- check if masking fifo is not full
					if (s_masking_fifo.full = '0') then
						-- masking fifo has space
						-- check if the bit is masked
						if (s_registered_window_mask(s_mask_counter) = '1') then
							s_masking_fifo.wrreq       <= '1';
							s_masking_fifo.data        <= s_registered_window_data(31 downto 24);
							-- decrement remaining data bytes counter
							s_fee_remaining_data_bytes <= std_logic_vector(unsigned(s_fee_remaining_data_bytes) - 1);
						end if;
						s_mask_counter          <= s_mask_counter + 1;
						s_masking_machine_state <= PIXEL_2_BYTE_MSB;
					end if;

				when PIXEL_2_BYTE_MSB =>
					s_masking_machine_state <= PIXEL_2_BYTE_MSB;
					-- check if masking fifo is not full
					if (s_masking_fifo.full = '0') then
						-- masking fifo has space
						-- check if the bit is masked
						if (s_registered_window_mask(s_mask_counter) = '1') then
							s_masking_fifo.wrreq       <= '1';
							s_masking_fifo.data        <= f_pixel_msb_change_timecode(s_registered_window_data(39 downto 32), current_timecode_i);
							-- decrement remaining data bytes counter
							s_fee_remaining_data_bytes <= std_logic_vector(unsigned(s_fee_remaining_data_bytes) - 1);
						end if;
						s_masking_machine_state <= PIXEL_2_BYTE_LSB;
					end if;

				when PIXEL_2_BYTE_LSB =>
					s_masking_machine_state <= PIXEL_2_BYTE_LSB;
					-- check if masking fifo is not full
					if (s_masking_fifo.full = '0') then
						-- masking fifo has space
						-- check if the bit is masked
						if (s_registered_window_mask(s_mask_counter) = '1') then
							s_masking_fifo.wrreq       <= '1';
							s_masking_fifo.data        <= s_registered_window_data(47 downto 40);
							-- decrement remaining data bytes counter
							s_fee_remaining_data_bytes <= std_logic_vector(unsigned(s_fee_remaining_data_bytes) - 1);
						end if;
						s_mask_counter          <= s_mask_counter + 1;
						s_masking_machine_state <= PIXEL_3_BYTE_MSB;
					end if;

				when PIXEL_3_BYTE_MSB =>
					s_masking_machine_state <= PIXEL_3_BYTE_MSB;
					-- check if masking fifo is not full
					if (s_masking_fifo.full = '0') then
						-- masking fifo has space
						-- check if the bit is masked
						if (s_registered_window_mask(s_mask_counter) = '1') then
							s_masking_fifo.wrreq       <= '1';
							s_masking_fifo.data        <= f_pixel_msb_change_timecode(s_registered_window_data(55 downto 48), current_timecode_i);
							-- decrement remaining data bytes counter
							s_fee_remaining_data_bytes <= std_logic_vector(unsigned(s_fee_remaining_data_bytes) - 1);
						end if;
						s_masking_machine_state <= PIXEL_3_BYTE_LSB;
					end if;

				when PIXEL_3_BYTE_LSB =>
					s_masking_machine_state <= PIXEL_3_BYTE_LSB;
					-- check if masking fifo is not full
					if (s_masking_fifo.full = '0') then
						-- masking fifo has space
						-- check if the bit is masked
						if (s_registered_window_mask(s_mask_counter) = '1') then
							s_masking_fifo.wrreq       <= '1';
							s_masking_fifo.data        <= s_registered_window_data(63 downto 56);
							-- decrement remaining data bytes counter
							s_fee_remaining_data_bytes <= std_logic_vector(unsigned(s_fee_remaining_data_bytes) - 1);
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
								-- current mask ended, one full data block parsed
								-- check if data bytes for the read-out cycle ended
								if (s_fee_remaining_data_bytes = (others => '0')) then
									-- data bytes for the read-out cycle ended, stop masking
									s_masking_machine_state <= NOT_STARTED;
								else
									-- more data in the read-out cycle, keep masking
									-- check if the windowing machine is released and there is more mask available
									if ((masking_machine_hold_i = '0') and (window_mask_ready_i = '1')) then
										window_mask_read_o      <= '1';
										s_masking_machine_state <= MASK_FETCH;
									else
										s_masking_machine_state <= IDLE;
									end if;
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

			-- check if a stop was issued
			if (fee_stop_signal_i = '1') then
				-- stop issued, go to stopped
				s_masking_machine_state <= STOPPED;
			end if;

		end if;
	end process p_masking_machine;

	-- masking fifo sclear signal reset
	s_masking_fifo.sclr <= ('1') when (rst_i = '1') else (fee_clear_signal_i);

	-- masking fifo almost empty signal
	masking_buffer_almost_empty_o <= ('0') when (rst_i = '1')
		else ('1') when (s_masking_fifo.usedw = std_logic_vector(to_unsigned(1, s_masking_fifo.usedw'length)))
		else ('0');

end architecture RTL;
