library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.rmap_target_pkg.all;
use work.rmap_target_crc_pkg.all;

entity rmap_stimuli_ent is
	port(
		clk            : in  std_logic;
		rst            : in  std_logic;
		spw_tx_flag    : in  t_rmap_target_spw_tx_flag;
		spw_tx_control : out t_rmap_target_spw_tx_control
	);
end entity rmap_stimuli_ent;

architecture RTL of rmap_stimuli_ent is

	type t_rmap_package is array (0 to 16535) of std_logic_vector(7 downto 0);
	type t_rmap_machine is (
		header,
		header_crc,
		data,
		data_crc,
		eop,
		idle
	);
	
	constant c_TIME_OFFSET   : natural range 0 to 16535     := 1500;

begin

	stimuli_proc : process(clk, rst) is
		variable field_counter   : natural range 0 to 16535     := 0;
		variable v_header        : t_rmap_package               := (others => x"00");
		variable v_data          : t_rmap_package               := (others => x"00");
		variable v_header_size   : integer                      := 0;
		variable v_data_size     : integer                      := 0;
		variable v_field_counter : integer                      := 0;
		variable v_rmap_machine  : t_rmap_machine               := header;
		variable v_crc           : std_logic_vector(7 downto 0) := x"00";
	begin
		if rst = '1' then
			spw_tx_control.write <= '0';
			spw_tx_control.flag  <= '0';
			spw_tx_control.data  <= x"00";

			v_field_counter := 0;

		elsif rising_edge(clk) then

			field_counter := field_counter + 1;

			spw_tx_control.write <= '0';
			spw_tx_control.flag  <= '0';
			spw_tx_control.data  <= x"00";

			if (field_counter <= c_TIME_OFFSET + 1000) then

				v_rmap_machine  := header;
				v_field_counter := 0;
				v_crc           := x"00";

			elsif (field_counter <= c_TIME_OFFSET + 2000) then

				v_header(0)   := x"51"; -- target logical address
				v_header(1)   := x"01"; -- protocol identifier
				v_header(2)   := x"7C"; -- instruction
				v_header(3)   := x"D1"; -- key
				v_header(4)   := x"50"; -- initiator logical address
				v_header(5)   := x"00"; -- transaction identifier ms
				v_header(6)   := x"00"; -- transaction identifier ls 
				v_header(7)   := x"00"; -- extended address
				v_header(8)   := x"00"; -- address ms
				v_header(9)   := x"00"; -- address
				v_header(10)  := x"00"; -- address
				v_header(11)  := x"38"; -- address ls
				v_header(12)  := x"00"; -- data length ms
				v_header(13)  := x"00"; -- data length 
				v_header(14)  := x"04"; -- data length ls
				v_header_size := 14;
				v_header(15)  := x"15"; -- header CRC

				v_data(0)   := x"00";   -- data
				v_data(1)   := x"00";   -- data
				v_data(2)   := x"00";   -- data
				v_data(3)   := x"00";   -- data
				v_data_size := 3;
				v_data(4)  := x"00";    -- data crc

				case v_rmap_machine is

					when header =>
						v_rmap_machine       := header;
						spw_tx_control.write <= '1';
						spw_tx_control.flag  <= '0';
						spw_tx_control.data  <= v_header(v_field_counter);
						v_crc                := RMAP_CalculateCRC(v_crc, v_header(v_field_counter));
						if (v_field_counter = v_header_size) then
							v_rmap_machine := header_crc;
						else
							v_field_counter := v_field_counter + 1;
						end if;

					when header_crc =>
						v_rmap_machine       := data;
						v_field_counter      := v_field_counter + 1;
						spw_tx_control.write <= '1';
						spw_tx_control.flag  <= '0';
						spw_tx_control.data  <= v_crc;
						v_crc                := x"00";
						v_field_counter      := 0;

					when data =>
						v_rmap_machine       := data;
						spw_tx_control.write <= '1';
						spw_tx_control.flag  <= '0';
						spw_tx_control.data  <= v_data(v_field_counter);
						v_crc                := RMAP_CalculateCRC(v_crc, v_data(v_field_counter));
						if (v_field_counter = v_data_size) then
							v_rmap_machine := data_crc;
						else
							v_field_counter := v_field_counter + 1;
						end if;

					when data_crc =>
						v_rmap_machine       := eop;
						v_field_counter      := v_field_counter + 1;
						spw_tx_control.write <= '1';
						spw_tx_control.flag  <= '0';
						spw_tx_control.data  <= v_crc;
						v_crc                := x"00";
						v_field_counter      := 0;

					when eop =>
						v_rmap_machine       := idle;
						spw_tx_control.write <= '1';
						spw_tx_control.flag  <= '1';
						spw_tx_control.data  <= x"00";

					when idle =>
						v_rmap_machine  := idle;
						v_field_counter := 0;
						v_crc           := x"00";

					when others =>
						null;

				end case;

			elsif (field_counter <= c_TIME_OFFSET + 3000) then

				if (field_counter = c_TIME_OFFSET + 2001) then
					v_rmap_machine := header;
				end if;

				v_header(0)   := x"51"; -- target logical address
				v_header(1)   := x"01"; -- protocol identifier
				v_header(2)   := x"7C"; -- instruction
				v_header(3)   := x"D1"; -- key
				v_header(4)   := x"50"; -- initiator logical address
				v_header(5)   := x"00"; -- transaction identifier ms
				v_header(6)   := x"01"; -- transaction identifier ls 
				v_header(7)   := x"00"; -- extended address
				v_header(8)   := x"00"; -- address ms
				v_header(9)   := x"00"; -- address
				v_header(10)  := x"00"; -- address
				v_header(11)  := x"3C"; -- address ls
				v_header(12)  := x"00"; -- data length ms
				v_header(13)  := x"00"; -- data length 
				v_header(14)  := x"04"; -- data length ls
				v_header_size := 14;
				v_header(15)  := x"4A"; -- header CRC

				v_data(0)   := x"06";   -- data
				v_data(1)   := x"00";   -- data
				v_data(2)   := x"00";   -- data
				v_data(3)   := x"00";   -- data
				v_data_size := 3;
				v_data(4)  := x"AA";    -- data crc

				case v_rmap_machine is

					when header =>
						v_rmap_machine       := header;
						spw_tx_control.write <= '1';
						spw_tx_control.flag  <= '0';
						spw_tx_control.data  <= v_header(v_field_counter);
						v_crc                := RMAP_CalculateCRC(v_crc, v_header(v_field_counter));
						if (v_field_counter = v_header_size) then
							v_rmap_machine := header_crc;
						else
							v_field_counter := v_field_counter + 1;
						end if;

					when header_crc =>
						v_rmap_machine       := data;
						v_field_counter      := v_field_counter + 1;
						spw_tx_control.write <= '1';
						spw_tx_control.flag  <= '0';
						spw_tx_control.data  <= v_crc;
						v_crc                := x"00";
						v_field_counter      := 0;

					when data =>
						v_rmap_machine       := data;
						spw_tx_control.write <= '1';
						spw_tx_control.flag  <= '0';
						spw_tx_control.data  <= v_data(v_field_counter);
						v_crc                := RMAP_CalculateCRC(v_crc, v_data(v_field_counter));
						if (v_field_counter = v_data_size) then
							v_rmap_machine := data_crc;
						else
							v_field_counter := v_field_counter + 1;
						end if;

					when data_crc =>
						v_rmap_machine       := eop;
						v_field_counter      := v_field_counter + 1;
						spw_tx_control.write <= '1';
						spw_tx_control.flag  <= '0';
						spw_tx_control.data  <= v_crc;
						v_crc                := x"00";
						v_field_counter      := 0;

					when eop =>
						v_rmap_machine       := idle;
						spw_tx_control.write <= '1';
						spw_tx_control.flag  <= '1';
						spw_tx_control.data  <= x"00";

					when idle =>
						v_rmap_machine  := idle;
						v_field_counter := 0;
						v_crc           := x"00";

					when others =>
						null;

				end case;

			elsif (field_counter <= c_TIME_OFFSET + 4000) then

				if (field_counter = c_TIME_OFFSET + 3001) then
					v_rmap_machine := header;
				end if;

				v_header(0)   := x"51"; -- target logical address
				v_header(1)   := x"01"; -- protocol identifier
				v_header(2)   := x"7C"; -- instruction
				v_header(3)   := x"D1"; -- key
				v_header(4)   := x"50"; -- initiator logical address
				v_header(5)   := x"00"; -- transaction identifier ms
				v_header(6)   := x"02"; -- transaction identifier ls 
				v_header(7)   := x"00"; -- extended address
				v_header(8)   := x"00"; -- address ms
				v_header(9)   := x"00"; -- address
				v_header(10)  := x"00"; -- address
				v_header(11)  := x"00"; -- address ls
				v_header(12)  := x"00"; -- data length ms
				v_header(13)  := x"00"; -- data length 
				v_header(14)  := x"04"; -- data length ls
				v_header_size := 14;
				v_header(15)  := x"BC"; -- header CRC

				v_data(0)   := x"C0";   -- data
				v_data(1)   := x"1B";   -- data
				v_data(2)   := x"71";   -- data
				v_data(3)   := x"8F";   -- data
				v_data_size := 3;
				v_data(4)  := x"94";    -- data crc
				
				case v_rmap_machine is

					when header =>
						v_rmap_machine       := header;
						spw_tx_control.write <= '1';
						spw_tx_control.flag  <= '0';
						spw_tx_control.data  <= v_header(v_field_counter);
						v_crc                := RMAP_CalculateCRC(v_crc, v_header(v_field_counter));
						if (v_field_counter = v_header_size) then
							v_rmap_machine := header_crc;
						else
							v_field_counter := v_field_counter + 1;
						end if;

					when header_crc =>
						v_rmap_machine       := data;
						v_field_counter      := v_field_counter + 1;
						spw_tx_control.write <= '1';
						spw_tx_control.flag  <= '0';
						spw_tx_control.data  <= v_crc;
						v_crc                := x"00";
						v_field_counter      := 0;

					when data =>
						v_rmap_machine       := data;
						spw_tx_control.write <= '1';
						spw_tx_control.flag  <= '0';
						spw_tx_control.data  <= v_data(v_field_counter);
						v_crc                := RMAP_CalculateCRC(v_crc, v_data(v_field_counter));
						if (v_field_counter = v_data_size) then
							v_rmap_machine := data_crc;
						else
							v_field_counter := v_field_counter + 1;
						end if;

					when data_crc =>
						v_rmap_machine       := eop;
						v_field_counter      := v_field_counter + 1;
						spw_tx_control.write <= '1';
						spw_tx_control.flag  <= '0';
						spw_tx_control.data  <= v_crc;
						v_crc                := x"00";
						v_field_counter      := 0;

					when eop =>
						v_rmap_machine       := idle;
						spw_tx_control.write <= '1';
						spw_tx_control.flag  <= '1';
						spw_tx_control.data  <= x"00";

					when idle =>
						v_rmap_machine  := idle;
						v_field_counter := 0;
						v_crc           := x"00";
						
					when others =>
						null;

				end case;

			elsif (field_counter <= c_TIME_OFFSET + 5000) then

				if (field_counter = c_TIME_OFFSET + 4001) then
					v_rmap_machine := header;
				end if;

				v_header(0)   := x"51"; -- target logical address
				v_header(1)   := x"01"; -- protocol identifier
				v_header(2)   := x"4C"; -- instruction
				v_header(3)   := x"D1"; -- key
				v_header(4)   := x"50"; -- initiator logical address
				v_header(5)   := x"00"; -- transaction identifier ms
				v_header(6)   := x"03"; -- transaction identifier ls 
				v_header(7)   := x"00"; -- extended address
				v_header(8)   := x"00"; -- address ms
				v_header(9)   := x"00"; -- address
				v_header(10)  := x"07"; -- address
				v_header(11)  := x"00"; -- address ls
				v_header(12)  := x"00"; -- data length ms
				v_header(13)  := x"00"; -- data length 
				v_header(14)  := x"80"; -- data length ls
				v_header_size := 14;
				v_header(15)  := x"EC"; -- header CRC

				case v_rmap_machine is

					when header =>
						v_rmap_machine       := header;
						spw_tx_control.write <= '1';
						spw_tx_control.flag  <= '0';
						spw_tx_control.data  <= v_header(v_field_counter);
						v_crc                := RMAP_CalculateCRC(v_crc, v_header(v_field_counter));
						if (v_field_counter = v_header_size) then
							v_rmap_machine := header_crc;
						else
							v_field_counter := v_field_counter + 1;
						end if;

					when header_crc =>
						v_rmap_machine       := eop;
						v_field_counter      := v_field_counter + 1;
						spw_tx_control.write <= '1';
						spw_tx_control.flag  <= '0';
						spw_tx_control.data  <= v_crc;
						v_crc                := x"00";
						v_field_counter      := 0;

					when eop =>
						v_rmap_machine       := idle;
						spw_tx_control.write <= '1';
						spw_tx_control.flag  <= '1';
						spw_tx_control.data  <= x"00";

					when idle =>
						v_rmap_machine  := idle;
						v_field_counter := 0;
						v_crc           := x"00";

					when others =>
						null;

				end case;

			else

				if (field_counter = c_TIME_OFFSET + 5001) then
					v_rmap_machine := header;
				end if;

				v_header(0)   := x"51"; -- target logical address
				v_header(1)   := x"01"; -- protocol identifier
				v_header(2)   := x"4C"; -- instruction
				v_header(3)   := x"D1"; -- key
				v_header(4)   := x"50"; -- initiator logical address
				v_header(5)   := x"00"; -- transaction identifier ms
				v_header(6)   := x"04"; -- transaction identifier ls 
				v_header(7)   := x"00"; -- extended address
				v_header(8)   := x"00"; -- address ms
				v_header(9)   := x"00"; -- address
				v_header(10)  := x"00"; -- address
				v_header(11)  := x"00"; -- address ls
				v_header(12)  := x"00"; -- data length ms
				v_header(13)  := x"00"; -- data length 
				v_header(14)  := x"04"; -- data length ls
				v_header_size := 14;
				v_header(15)  := x"13"; -- header CRC

				case v_rmap_machine is

					when header =>
						v_rmap_machine       := header;
						spw_tx_control.write <= '1';
						spw_tx_control.flag  <= '0';
						spw_tx_control.data  <= v_header(v_field_counter);
						v_crc                := RMAP_CalculateCRC(v_crc, v_header(v_field_counter));
						if (v_field_counter = v_header_size) then
							v_rmap_machine := header_crc;
						else
							v_field_counter := v_field_counter + 1;
						end if;

					when header_crc =>
						v_rmap_machine       := eop;
						v_field_counter      := v_field_counter + 1;
						spw_tx_control.write <= '1';
						spw_tx_control.flag  <= '0';
						spw_tx_control.data  <= v_crc;
						v_crc                := x"00";
						v_field_counter      := 0;

					when eop =>
						v_rmap_machine       := idle;
						spw_tx_control.write <= '1';
						spw_tx_control.flag  <= '1';
						spw_tx_control.data  <= x"00";

					when idle =>
						v_rmap_machine  := idle;
						v_field_counter := 0;
						v_crc           := x"00";

					when others =>
						null;

				end case;

			end if;

		end if;
	end process stimuli_proc;

end architecture RTL;
