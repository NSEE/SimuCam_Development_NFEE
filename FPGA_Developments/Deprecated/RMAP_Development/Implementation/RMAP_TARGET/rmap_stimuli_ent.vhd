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
		data2,
		data_crc,
		eop,
		idle
	);

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

			if (field_counter <= 1000) then

				v_rmap_machine  := header;
				v_field_counter := 0;
				v_crc           := x"00";

			elsif (field_counter <= 2000) then

				--				v_header(0)   := x"FE"; -- target logical address
				--				v_header(1)   := x"01"; -- protocol identifier
				--				v_header(2)   := x"6C"; -- instruction
				--				v_header(3)   := x"00"; -- key
				--				v_header(4)   := x"67"; -- initiator logical address
				--				v_header(5)   := x"00"; -- transaction identifier ms
				--				v_header(6)   := x"00"; -- transaction identifier ls 
				--				v_header(7)   := x"00"; -- extended address
				--				v_header(8)   := x"A0"; -- address ms
				--				v_header(9)   := x"00"; -- address
				--				v_header(10)  := x"00"; -- address
				--				v_header(11)  := x"00"; -- address ls
				--				v_header(12)  := x"00"; -- data length ms
				--				v_header(13)  := x"00"; -- data length 
				--				v_header(14)  := x"10"; -- data length ls
				--				v_header_size := 14;
				--				v_header(15)  := x"9F"; -- header CRC
				--
				--				v_data(0)   := x"01";   -- data
				--				v_data(1)   := x"23";   -- data
				--				v_data(2)   := x"45";   -- data
				--				v_data(3)   := x"67";   -- data
				--				v_data(4)   := x"89";   -- data
				--				v_data(5)   := x"AB";   -- data
				--				v_data(6)   := x"CD";   -- data
				--				v_data(7)   := x"EF";   -- data
				--				v_data(8)   := x"10";   -- data
				--				v_data(9)   := x"11";   -- data
				--				v_data(10)  := x"12";   -- data
				--				v_data(11)  := x"13";   -- data
				--				v_data(12)  := x"14";   -- data
				--				v_data(13)  := x"15";   -- data
				--				v_data(14)  := x"16";   -- data
				--				v_data(15)  := x"17";   -- data
				--				v_data_size := 15;
				--				v_data(16)  := x"56";   -- data crc

				v_header(0)   := x"FE"; -- target logical address
				v_header(1)   := x"01"; -- protocol identifier
--				v_header(2)   := x"6C"; -- instruction
--				v_header(2)   := "01100000"; -- instruction
--				v_header(2)   := "01100100"; -- instruction
--				v_header(2)   := "01101000"; -- instruction
--				v_header(2)   := "01101100"; -- instruction
--				v_header(2)   := "01110000"; -- instruction
--				v_header(2)   := "01110100"; -- instruction
--				v_header(2)   := "01111000"; -- instruction
				v_header(2)   := "01111100"; -- instruction
				v_header(3)   := x"00"; -- key
				v_header(4)   := x"67"; -- initiator logical address
				v_header(5)   := x"00"; -- transaction identifier ms
				v_header(6)   := x"00"; -- transaction identifier ls 
				v_header(7)   := x"00"; -- extended address
				v_header(8)   := x"A0"; -- address ms
				v_header(9)   := x"00"; -- address
				v_header(10)  := x"00"; -- address
				v_header(11)  := x"05"; -- address ls
				v_header(12)  := x"00"; -- data length ms
				v_header(13)  := x"00"; -- data length 
				v_header(14)  := x"10"; -- data length ls
				v_header_size := 14;
				v_header(15)  := x"9F"; -- header CRC

				v_data(0)   := x"01";   -- data
				v_data(1)   := x"23";   -- data
				v_data(2)   := x"45";   -- data
				v_data(3)   := x"67";   -- data
				v_data(4)   := x"89";   -- data
				v_data(5)   := x"AB";   -- data
				v_data(6)   := x"CD";   -- data
				v_data(7)   := x"EF";   -- data
				v_data(8)   := x"10";   -- data
				v_data(9)   := x"11";   -- data
				v_data(10)  := x"12";   -- data
				v_data(11)  := x"13";   -- data
				v_data(12)  := x"14";   -- data
				v_data(13)  := x"15";   -- data
				v_data(14)  := x"16";   -- data
				v_data(15)  := x"17";   -- data
				v_data_size := 15;
				v_data(16)  := x"56";   -- data crc

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
						--						spw_tx_control.data  <= v_header(v_field_counter);
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
						--						spw_tx_control.data  <= v_data(v_field_counter);
						spw_tx_control.data  <= v_crc;
--						spw_tx_control.data  <= x"67";
						v_crc                := x"00";
						v_field_counter      := 0;

					when data2 =>
						v_rmap_machine       := data2;
						spw_tx_control.write <= '1';
						spw_tx_control.flag  <= '0';
						spw_tx_control.data  <= v_data(v_field_counter);
						v_crc                := RMAP_CalculateCRC(v_crc, v_data(v_field_counter));
						if (v_field_counter = v_data_size) then
							v_rmap_machine := eop;
						else
							v_field_counter := v_field_counter + 1;
						end if;

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

			elsif (field_counter <= 3000) then

				if (field_counter = 2001) then
					v_rmap_machine := header;
				end if;

				v_header(0)   := x"FE"; -- target logical address
				v_header(1)   := x"01"; -- protocol identifier
				v_header(2)   := x"4C"; -- instruction
				v_header(3)   := x"00"; -- key
				v_header(4)   := x"67"; -- initiator logical address
				v_header(5)   := x"00"; -- transaction identifier ms
				v_header(6)   := x"01"; -- transaction identifier ls 
				v_header(7)   := x"00"; -- extended address
				v_header(8)   := x"A0"; -- address ms
				v_header(9)   := x"00"; -- address
				v_header(10)  := x"00"; -- address
				v_header(11)  := x"00"; -- address ls
				v_header(12)  := x"00"; -- data length ms
				v_header(13)  := x"00"; -- data length 
				v_header(14)  := x"10"; -- data length ls
				v_header_size := 14;
				v_header(15)  := x"C9"; -- header CRC

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
						--						spw_tx_control.data  <= v_header(v_field_counter);
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
						--						spw_tx_control.data  <= v_data(v_field_counter);
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

			elsif (field_counter <= 4000) then

				if (field_counter = 3001) then
					v_rmap_machine := header;
				end if;

				v_header(0)   := x"FE"; -- target logical address
				v_header(1)   := x"01"; -- protocol identifier
				v_header(2)   := x"6E"; -- instruction
				v_header(3)   := x"00"; -- key
				v_header(4)   := x"00"; -- reply spacewire address
				v_header(5)   := x"99"; -- reply spacewire address
				v_header(6)   := x"AA"; -- reply spacewire address
				v_header(7)   := x"BB"; -- reply spacewire address
				v_header(8)   := x"CC"; -- reply spacewire address
				v_header(9)   := x"DD"; -- reply spacewire address
				v_header(10)  := x"EE"; -- reply spacewire address
				v_header(11)  := x"00"; -- reply spacewire address
				v_header(12)  := x"67"; -- initiator logical address
				v_header(13)  := x"00"; -- transaction identifier ms
				v_header(14)  := x"02"; -- transaction identifier ls 
				v_header(15)  := x"00"; -- extended address
				v_header(16)  := x"A0"; -- address ms
				v_header(17)  := x"00"; -- address
				v_header(18)  := x"00"; -- address
				v_header(19)  := x"10"; -- address ls
				v_header(20)  := x"00"; -- data length ms
				v_header(21)  := x"00"; -- data length 
				v_header(22)  := x"10"; -- data length ls
				v_header_size := 22;
				v_header(23)  := x"7F"; -- header CRC

				v_data(0)   := x"A0";   -- data
				v_data(1)   := x"A1";   -- data
				v_data(2)   := x"A2";   -- data
				v_data(3)   := x"A3";   -- data
				v_data(4)   := x"A4";   -- data
				v_data(5)   := x"A5";   -- data
				v_data(6)   := x"A6";   -- data
				v_data(7)   := x"A7";   -- data
				v_data(8)   := x"A8";   -- data
				v_data(9)   := x"A9";   -- data
				v_data(10)  := x"AA";   -- data
				v_data(11)  := x"AB";   -- data
				v_data(12)  := x"AC";   -- data
				v_data(13)  := x"AD";   -- data
				v_data(14)  := x"AE";   -- data
				v_data(15)  := x"AF";   -- data
				v_data_size := 15;
				v_data(16)  := x"B4";   -- data crc

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
						--						spw_tx_control.data  <= v_header(v_field_counter);
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
						--						spw_tx_control.data  <= v_data(v_field_counter);
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

				if (field_counter = 4001) then
					v_rmap_machine := header;
				end if;

				v_header(0)   := x"FE"; -- target logical address
				v_header(1)   := x"01"; -- protocol identifier
				v_header(2)   := x"4D"; -- instruction
				v_header(3)   := x"00"; -- key
				v_header(4)   := x"99"; -- reply spacewire address
				v_header(5)   := x"AA"; -- reply spacewire address
				v_header(6)   := x"BB"; -- reply spacewire address
				v_header(7)   := x"CC"; -- reply spacewire address
				v_header(8)   := x"67"; -- initiator logical address
				v_header(9)   := x"00"; -- transaction identifier ms
				v_header(10)  := x"03"; -- transaction identifier ls 
				v_header(11)  := x"00"; -- extended address
				v_header(12)  := x"A0"; -- address ms
				v_header(13)  := x"00"; -- address
				v_header(14)  := x"00"; -- address
				v_header(15)  := x"10"; -- address ls
				v_header(16)  := x"00"; -- data length ms
				v_header(17)  := x"00"; -- data length 
				v_header(18)  := x"10"; -- data length ls
				v_header_size := 18;
				v_header(19)  := x"F7"; -- header CRC

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
						--						spw_tx_control.data  <= v_header(v_field_counter);
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
						--						spw_tx_control.data  <= v_data(v_field_counter);
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
