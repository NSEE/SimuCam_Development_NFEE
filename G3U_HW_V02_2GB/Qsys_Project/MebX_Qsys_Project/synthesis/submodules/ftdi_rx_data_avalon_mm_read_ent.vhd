library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.ftdi_data_avalon_mm_pkg.all;

entity ftdi_rx_data_avalon_mm_read_ent is
	port(
		clk_i                    : in  std_logic;
		rst_i                    : in  std_logic;
		data_rx_stop_i           : in  std_logic;
		data_rx_start_i          : in  std_logic;
		ftdi_rx_data_avalon_mm_i : in  t_ftdi_rx_data_avalon_mm_read_in;
		buffer_stat_empty_i      : in  std_logic;
		buffer_rddata_i          : in  std_logic_vector(255 downto 0);
		buffer_rdready_i         : in  std_logic;
		ftdi_rx_data_avalon_mm_o : out t_ftdi_rx_data_avalon_mm_read_out;
		buffer_rdreq_o           : out std_logic
	);
end entity ftdi_rx_data_avalon_mm_read_ent;

architecture rtl of ftdi_rx_data_avalon_mm_read_ent is

	signal s_readdata_fetched : std_logic;
	signal s_first_fetch      : std_logic;
	signal s_fetch_delay      : std_logic;
	--	signal s_data_acquired    : std_logic;

	type t_ftdi_rx_data_avalon_mm_read_fsm is (
		STOPPED,
		IDLE,
		READ_DATA
	);
	signal s_ftdi_rx_data_avalon_mm_read_state : t_ftdi_rx_data_avalon_mm_read_fsm;

begin

	p_ftdi_rx_data_avalon_mm_read : process(clk_i, rst_i) is
		procedure p_reset_registers is
		begin
			buffer_rdreq_o     <= '0';
			s_readdata_fetched <= '0';
			s_first_fetch      <= '0';
			s_fetch_delay      <= '0';
		end procedure p_reset_registers;

		procedure p_flags_hold is
		begin
			null;
		end procedure p_flags_hold;

		procedure p_buffer_control is
		begin
			buffer_rdreq_o <= '0';
			if ((buffer_stat_empty_i = '1') and (s_readdata_fetched = '0')) then
				s_first_fetch <= '1';
			end if;
		end procedure p_buffer_control;

		procedure p_readdata(read_address_i : t_ftdi_data_avalon_mm_address) is
		begin
			-- Registers Data Read

			buffer_rdreq_o <= '1';
			case (read_address_i) is
				-- Case for access to all registers address

				when 0 to t_ftdi_data_avalon_mm_address'high =>

					-- check if the readdata is fetched
					if (s_readdata_fetched = '1') then
						if (s_first_fetch = '1') then
							s_first_fetch                        <= '0';
							buffer_rdreq_o                       <= '0';
							s_ftdi_rx_data_avalon_mm_read_state  <= IDLE;
							ftdi_rx_data_avalon_mm_o.readdata    <= (others => '0');
							ftdi_rx_data_avalon_mm_o.waitrequest <= '1';
						else
							s_readdata_fetched                <= '0';
							ftdi_rx_data_avalon_mm_o.readdata <= buffer_rddata_i;
							buffer_rdreq_o                    <= '0';
							-- check if the tx data buffer is empty
							if (buffer_stat_empty_i = '1') then
							-- check if the tx data buffer is ready and not empty
							elsif ((buffer_rdready_i = '1') and (buffer_stat_empty_i = '0')) then
								s_readdata_fetched <= '1';
								buffer_rdreq_o     <= '1';
							end if;
						end if;
					else
						-- readdata not fetch
						buffer_rdreq_o                       <= '0';
						s_ftdi_rx_data_avalon_mm_read_state  <= IDLE;
						ftdi_rx_data_avalon_mm_o.readdata    <= (others => '0');
						ftdi_rx_data_avalon_mm_o.waitrequest <= '1';
						-- check if a fetch is in progress
						if (s_fetch_delay = '1') then
							s_readdata_fetched <= '1';
							buffer_rdreq_o     <= '0';
							s_fetch_delay      <= '0';
						-- check if the tx data buffer is ready and not empty
						elsif ((buffer_rdready_i = '1') and (buffer_stat_empty_i = '0')) then
							s_readdata_fetched <= '0';
							buffer_rdreq_o     <= '1';
							s_fetch_delay      <= '1';
						end if;
					end if;

				when others =>
					ftdi_rx_data_avalon_mm_o.readdata <= (others => '0');

			end case;
		end procedure p_readdata;

		variable v_read_address : t_ftdi_data_avalon_mm_address := 0;
	begin
		if (rst_i = '1') then
			ftdi_rx_data_avalon_mm_o.readdata    <= (others => '0');
			ftdi_rx_data_avalon_mm_o.waitrequest <= '0';
			s_ftdi_rx_data_avalon_mm_read_state  <= STOPPED;
			v_read_address                       := 0;
			p_reset_registers;
		elsif (rising_edge(clk_i)) then

			case (s_ftdi_rx_data_avalon_mm_read_state) is

				when STOPPED =>
					s_ftdi_rx_data_avalon_mm_read_state  <= STOPPED;
					s_readdata_fetched                   <= '0';
					s_fetch_delay                        <= '0';
					ftdi_rx_data_avalon_mm_o.readdata    <= (others => '0');
					ftdi_rx_data_avalon_mm_o.waitrequest <= '0';
					buffer_rdreq_o                       <= '0';
					if (data_rx_start_i = '1') then
						s_ftdi_rx_data_avalon_mm_read_state  <= IDLE;
						ftdi_rx_data_avalon_mm_o.waitrequest <= '1';
					end if;

				when IDLE =>
					s_ftdi_rx_data_avalon_mm_read_state  <= IDLE;
					ftdi_rx_data_avalon_mm_o.readdata    <= (others => '0');
					ftdi_rx_data_avalon_mm_o.waitrequest <= '1';
					p_flags_hold;
					p_buffer_control;
					if (ftdi_rx_data_avalon_mm_i.read = '1') then
						s_ftdi_rx_data_avalon_mm_read_state  <= READ_DATA;
						ftdi_rx_data_avalon_mm_o.waitrequest <= '0';
						v_read_address                       := to_integer(unsigned(ftdi_rx_data_avalon_mm_i.address));
						p_readdata(v_read_address);
					end if;

				when READ_DATA =>
					s_ftdi_rx_data_avalon_mm_read_state  <= IDLE;
					ftdi_rx_data_avalon_mm_o.readdata    <= (others => '0');
					ftdi_rx_data_avalon_mm_o.waitrequest <= '1';
					p_flags_hold;
					p_buffer_control;

			end case;

			if (data_rx_stop_i = '1') then
				s_ftdi_rx_data_avalon_mm_read_state <= STOPPED;
			end if;

			--			ftdi_rx_data_avalon_mm_o.readdata    <= (others => '0');
			--			ftdi_rx_data_avalon_mm_o.waitrequest <= '1';
			--			p_flags_hold;
			--			p_buffer_control;
			--			s_data_acquired                      <= '0';
			--			if (ftdi_rx_data_avalon_mm_i.read = '1') then
			--				s_data_acquired <= '1';
			--				if (s_data_acquired = '0') then
			--					v_read_address                       := to_integer(unsigned(ftdi_rx_data_avalon_mm_i.address));
			--					ftdi_rx_data_avalon_mm_o.waitrequest <= '0';
			--					p_readdata(v_read_address);
			--				end if;
			--			end if;
		end if;
	end process p_ftdi_rx_data_avalon_mm_read;

end architecture rtl;
