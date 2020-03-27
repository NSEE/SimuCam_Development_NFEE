library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rmap_fifo_stimuli is
	port(
		clk_i                   : in  std_logic;
		rst_i                   : in  std_logic;
		rmap_fifo_wrdata_flag_o : out std_logic;
		rmap_fifo_wrdata_data_o : out std_logic_vector(7 downto 0);
		rmap_fifo_wrreq_o       : out std_logic
	);
end entity rmap_fifo_stimuli;

architecture RTL of rmap_fifo_stimuli is
	-- ccd image data
	constant c_RMAP_FIFODATA_LENGTH : natural                                         := 26;
	signal s_rmap_fifodata_cnt      : natural range 0 to (c_RMAP_FIFODATA_LENGTH - 1) := 0;
	type t_rmap_fifodata is array (0 to (c_RMAP_FIFODATA_LENGTH - 1)) of std_logic_vector(8 downto 0);
	constant c_RMAP_FIFODATA        : t_rmap_fifodata                                 := (
		"010000001",
		"000000001",
		"010100000",
		"010100001",
		"010100010",
		"010100011",
		"010100100",
		"010100101",
		"010100110",
		"010100111",
		"010101000",
		"010101001",
		"100000000",
		"001010011",
		"000000001",
		"010110000",
		"010110001",
		"010110010",
		"010110011",
		"010110100",
		"010110101",
		"010110110",
		"010110111",
		"010111000",
		"010111001",
		"100000000"
	);

	signal s_counter : natural := 0;

begin

	p_rmap_fifo_stimuli : process(clk_i, rst_i) is
	begin
		if (rst_i = '1') then

			rmap_fifo_wrdata_flag_o <= '0';
			rmap_fifo_wrdata_data_o <= (others => '0');
			rmap_fifo_wrreq_o       <= '0';
			s_rmap_fifodata_cnt     <= 0;
			s_counter               <= 0;
		--						s_counter              <= 5000;

		elsif rising_edge(clk_i) then

			rmap_fifo_wrdata_flag_o <= '0';
			rmap_fifo_wrdata_data_o <= (others => '0');
			rmap_fifo_wrreq_o       <= '0';
			s_counter               <= s_counter + 1;

			case (s_counter) is

				when 1500 =>
					rmap_fifo_wrdata_flag_o <= c_RMAP_FIFODATA(s_rmap_fifodata_cnt)(8);
					rmap_fifo_wrdata_data_o <= c_RMAP_FIFODATA(s_rmap_fifodata_cnt)(7 downto 0);
					rmap_fifo_wrreq_o       <= '1';

				when 1501 =>
					s_counter <= 1500;
					if (s_rmap_fifodata_cnt = (c_RMAP_FIFODATA_LENGTH - 1)) then
						s_rmap_fifodata_cnt <= 0;
						s_counter           <= 5000;
					else
						s_rmap_fifodata_cnt <= s_rmap_fifodata_cnt + 1;
					end if;

				when others =>
					null;

			end case;

		end if;
	end process p_rmap_fifo_stimuli;

end architecture RTL;
