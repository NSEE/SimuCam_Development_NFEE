library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.comm_avm_cbuf_pkg.all;
use work.comm_cbuf_pkg.all;

entity cbuf_stimuli is
	port(
		clk_i              : in  std_logic;
		rst_i              : in  std_logic;
		cbuf_empty_i       : in  std_logic;
		cbuf_usedw_i       : in  std_logic_vector((c_COMM_CBUF_WUSED_SIZE - 1) downto 0);
		cbuf_full_i        : in  std_logic;
		cbuf_ready_i       : in  std_logic;
		cbuf_rddata_i      : in  std_logic_vector((c_COMM_CBUF_DATAW_SIZE - 1) downto 0);
		cbuf_datavalid_i   : in  std_logic;
		cbuf_flush_o       : out std_logic;
		cbuf_read_o        : out std_logic;
		cbuf_write_o       : out std_logic;
		cbuf_wrdata_o      : out std_logic_vector((c_COMM_CBUF_DATAW_SIZE - 1) downto 0);
		cbuf_size_o        : out std_logic_vector((c_COMM_CBUF_WUSED_SIZE - 1) downto 0);
		cbuf_addr_offset_o : out std_logic_vector((c_COMM_AVM_CBUF_ADRESS_SIZE - 1) downto 0)
	);
end entity cbuf_stimuli;

architecture RTL of cbuf_stimuli is

	signal s_counter : natural := 0;

begin

	p_cbuf_stimuli : process(clk_i, rst_i) is
	begin
		if (rst_i = '1') then

			cbuf_flush_o       <= '0';
			cbuf_read_o        <= '0';
			cbuf_write_o       <= '0';
			cbuf_wrdata_o      <= (others => '0');
			cbuf_size_o        <= (others => '1');
			cbuf_addr_offset_o <= (others => '0');
			s_counter          <= 0;

		elsif rising_edge(clk_i) then

			cbuf_flush_o       <= '0';
			cbuf_read_o        <= '0';
			cbuf_write_o       <= '0';
			cbuf_wrdata_o      <= (others => '0');
			cbuf_addr_offset_o <= x"FFFFFFFFFFFFFFF0";
			s_counter          <= s_counter + 1;

			case s_counter is
				
				when (0) =>
				cbuf_size_o        <= std_logic_vector(to_unsigned(4, cbuf_size_o'length));
				cbuf_flush_o  <= '1';

				when (500) =>
					-- do some shit
					cbuf_write_o  <= '1';
					cbuf_wrdata_o <= x"0000";

				when (600) =>
					-- do some shit
					cbuf_write_o  <= '1';
					cbuf_wrdata_o <= x"0001";

				when (700) =>
					-- do some shit
					cbuf_write_o  <= '1';
					cbuf_wrdata_o <= x"0002";

--				when (800) =>
--					-- do some shit
--					cbuf_write_o  <= '1';
--					cbuf_wrdata_o <= x"0003";
--
--				when (900) =>
--					-- do some shit
--					cbuf_write_o  <= '1';
--					cbuf_wrdata_o <= x"0004";

				when (1500) =>
					-- do some shit
					cbuf_read_o <= '1';

				when (1600) =>
					-- do some shit
					cbuf_read_o <= '1';

				when (1700) =>
					-- do some shit
					cbuf_read_o <= '1';

				when (1800) =>
					-- do some shit
					cbuf_read_o <= '1';

				when (1900) =>
					-- do some shit
					cbuf_read_o <= '1';

					
				when (2100) =>
										cbuf_size_o        <= std_logic_vector(to_unsigned(2, cbuf_size_o'length));

				when (2500) =>
					-- do some shit
					cbuf_write_o  <= '1';
					cbuf_wrdata_o <= x"0005";

				when (2600) =>
					-- do some shit
					cbuf_write_o  <= '1';
					cbuf_wrdata_o <= x"0006";

				when (2700) =>
					-- do some shit
					cbuf_write_o  <= '1';
					cbuf_wrdata_o <= x"0007";

				when (2800) =>
					-- do some shit
					cbuf_write_o  <= '1';
					cbuf_wrdata_o <= x"0008";

				when (2900) =>
					-- do some shit
					cbuf_write_o  <= '1';
					cbuf_wrdata_o <= x"0009";

				when (3500) =>
					-- do some shit
					cbuf_read_o <= '1';

				when (3600) =>
					-- do some shit
					cbuf_read_o <= '1';

				when (3700) =>
					-- do some shit
					cbuf_read_o <= '1';

				when (3800) =>
					-- do some shit
					cbuf_read_o <= '1';

				when (3900) =>
					-- do some shit
					cbuf_read_o <= '1';

				when others =>
					null;

			end case;

		end if;
	end process p_cbuf_stimuli;

end architecture RTL;
