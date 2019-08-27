library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package ftdi_protocol_crc_pkg is

	-- Constant for the initial value to the ftdi protocol CRC32, copied from the PUS CRC32 implementation
	constant c_FTDI_PROT_CRC32_START : std_logic_vector(31 downto 0) := x"FFFFFFFF";

	-- Constant to finish the calulation of the ftdi protocol CRC32, copied from the PUS CRC32 implementation
	constant c_FTDI_PROT_CRC32_FINISH : std_logic_vector(31 downto 0) := x"FFFFFFFF";

	-- Function to add a byte to the calculated ftdi protocol CRC32, copied from the PUS CRC32 implementation
	function f_ftdi_protocol_calculate_crc32_byte(
		constant crc32_i : in std_logic_vector(31 downto 0);
		constant byte_i  : in std_logic_vector(7 downto 0)
	) return std_logic_vector;

	-- Function to add a dword to the calculated ftdi protocol CRC32, copied from the PUS CRC32 implementation
	function f_ftdi_protocol_calculate_crc32_dword(
		constant crc32_i : in std_logic_vector(31 downto 0);
		constant dword_i : in std_logic_vector(31 downto 0)
	) return std_logic_vector;

	-- Function to finish the calculation of the ftdi protocol CRC32, copied from the PUS CRC32 implementation
	function f_ftdi_protocol_finish_crc32(
		constant crc32_i : in std_logic_vector(31 downto 0)
	) return std_logic_vector;

	-- CRC32 table
	type t_ftdi_prot_crc32_table is array (0 to 255) of std_logic_vector(31 downto 0);
	constant c_FTDI_PROT_CRC32_TABLE : t_ftdi_prot_crc32_table := (
		x"00000000", x"77073096", x"EE0E612C", x"990951BA", x"076DC419", x"706AF48F", x"E963A535", x"9E6495A3",
		x"0EDB8832", x"79DCB8A4", x"E0D5E91E", x"97D2D988", x"09B64C2B", x"7EB17CBD", x"E7B82D07", x"90BF1D91",
		x"1DB71064", x"6AB020F2", x"F3B97148", x"84BE41DE", x"1ADAD47D", x"6DDDE4EB", x"F4D4B551", x"83D385C7",
		x"136C9856", x"646BA8C0", x"FD62F97A", x"8A65C9EC", x"14015C4F", x"63066CD9", x"FA0F3D63", x"8D080DF5",
		x"3B6E20C8", x"4C69105E", x"D56041E4", x"A2677172", x"3C03E4D1", x"4B04D447", x"D20D85FD", x"A50AB56B",
		x"35B5A8FA", x"42B2986C", x"DBBBC9D6", x"ACBCF940", x"32D86CE3", x"45DF5C75", x"DCD60DCF", x"ABD13D59",
		x"26D930AC", x"51DE003A", x"C8D75180", x"BFD06116", x"21B4F4B5", x"56B3C423", x"CFBA9599", x"B8BDA50F",
		x"2802B89E", x"5F058808", x"C60CD9B2", x"B10BE924", x"2F6F7C87", x"58684C11", x"C1611DAB", x"B6662D3D",
		x"76DC4190", x"01DB7106", x"98D220BC", x"EFD5102A", x"71B18589", x"06B6B51F", x"9FBFE4A5", x"E8B8D433",
		x"7807C9A2", x"0F00F934", x"9609A88E", x"E10E9818", x"7F6A0DBB", x"086D3D2D", x"91646C97", x"E6635C01",
		x"6B6B51F4", x"1C6C6162", x"856530D8", x"F262004E", x"6C0695ED", x"1B01A57B", x"8208F4C1", x"F50FC457",
		x"65B0D9C6", x"12B7E950", x"8BBEB8EA", x"FCB9887C", x"62DD1DDF", x"15DA2D49", x"8CD37CF3", x"FBD44C65",
		x"4DB26158", x"3AB551CE", x"A3BC0074", x"D4BB30E2", x"4ADFA541", x"3DD895D7", x"A4D1C46D", x"D3D6F4FB",
		x"4369E96A", x"346ED9FC", x"AD678846", x"DA60B8D0", x"44042D73", x"33031DE5", x"AA0A4C5F", x"DD0D7CC9",
		x"5005713C", x"270241AA", x"BE0B1010", x"C90C2086", x"5768B525", x"206F85B3", x"B966D409", x"CE61E49F",
		x"5EDEF90E", x"29D9C998", x"B0D09822", x"C7D7A8B4", x"59B33D17", x"2EB40D81", x"B7BD5C3B", x"C0BA6CAD",
		x"EDB88320", x"9ABFB3B6", x"03B6E20C", x"74B1D29A", x"EAD54739", x"9DD277AF", x"04DB2615", x"73DC1683",
		x"E3630B12", x"94643B84", x"0D6D6A3E", x"7A6A5AA8", x"E40ECF0B", x"9309FF9D", x"0A00AE27", x"7D079EB1",
		x"F00F9344", x"8708A3D2", x"1E01F268", x"6906C2FE", x"F762575D", x"806567CB", x"196C3671", x"6E6B06E7",
		x"FED41B76", x"89D32BE0", x"10DA7A5A", x"67DD4ACC", x"F9B9DF6F", x"8EBEEFF9", x"17B7BE43", x"60B08ED5",
		x"D6D6A3E8", x"A1D1937E", x"38D8C2C4", x"4FDFF252", x"D1BB67F1", x"A6BC5767", x"3FB506DD", x"48B2364B",
		x"D80D2BDA", x"AF0A1B4C", x"36034AF6", x"41047A60", x"DF60EFC3", x"A867DF55", x"316E8EEF", x"4669BE79",
		x"CB61B38C", x"BC66831A", x"256FD2A0", x"5268E236", x"CC0C7795", x"BB0B4703", x"220216B9", x"5505262F",
		x"C5BA3BBE", x"B2BD0B28", x"2BB45A92", x"5CB36A04", x"C2D7FFA7", x"B5D0CF31", x"2CD99E8B", x"5BDEAE1D",
		x"9B64C2B0", x"EC63F226", x"756AA39C", x"026D930A", x"9C0906A9", x"EB0E363F", x"72076785", x"05005713",
		x"95BF4A82", x"E2B87A14", x"7BB12BAE", x"0CB61B38", x"92D28E9B", x"E5D5BE0D", x"7CDCEFB7", x"0BDBDF21",
		x"86D3D2D4", x"F1D4E242", x"68DDB3F8", x"1FDA836E", x"81BE16CD", x"F6B9265B", x"6FB077E1", x"18B74777",
		x"88085AE6", x"FF0F6A70", x"66063BCA", x"11010B5C", x"8F659EFF", x"F862AE69", x"616BFFD3", x"166CCF45",
		x"A00AE278", x"D70DD2EE", x"4E048354", x"3903B3C2", x"A7672661", x"D06016F7", x"4969474D", x"3E6E77DB",
		x"AED16A4A", x"D9D65ADC", x"40DF0B66", x"37D83BF0", x"A9BCAE53", x"DEBB9EC5", x"47B2CF7F", x"30B5FFE9",
		x"BDBDF21C", x"CABAC28A", x"53B39330", x"24B4A3A6", x"BAD03605", x"CDD70693", x"54DE5729", x"23D967BF",
		x"B3667A2E", x"C4614AB8", x"5D681B02", x"2A6F2B94", x"B40BBE37", x"C30C8EA1", x"5A05DF1B", x"2D02EF8D"
	);

end package ftdi_protocol_crc_pkg;

package body ftdi_protocol_crc_pkg is

	-- Function to add a byte to the calculated ftdi protocol CRC32, copied from the PUS CRC32 implementation
	function f_ftdi_protocol_calculate_crc32_byte(
		constant crc32_i : in std_logic_vector(31 downto 0);
		constant byte_i  : in std_logic_vector(7 downto 0)
	) return std_logic_vector is
		variable v_bitshifted_crc32  : std_logic_vector(31 downto 0) := x"00000000";
		variable v_crc32_table_index : std_logic_vector(7 downto 0)  := x"00";
		variable v_updated_crc32     : std_logic_vector(31 downto 0) := x"00000000";
	begin

		-- bitshift the input crc32 by 8 bits (crc32 >> 8)
		v_bitshifted_crc32(31 downto 24) := (others => '0');
		v_bitshifted_crc32(23 downto 0)  := crc32_i(31 downto 8);

		-- calculated the crc32 table index (crc32 ^ dword)
		v_crc32_table_index := (crc32_i(7 downto 0)) xor (byte_i);

		-- calculate updated crc32 ((crc32 >> 8) ^ crc32_table[(crc32 ^ dword) & 0x000000FF])
		v_updated_crc32 := (v_bitshifted_crc32) xor (c_FTDI_PROT_CRC32_TABLE(to_integer(unsigned(v_crc32_table_index))));

		return v_updated_crc32;
	end function f_ftdi_protocol_calculate_crc32_byte;

	-- Function to add a dword to the calculated ftdi protocol CRC32, copied from the PUS CRC32 implementation
	function f_ftdi_protocol_calculate_crc32_dword(
		constant crc32_i : in std_logic_vector(31 downto 0);
		constant dword_i : in std_logic_vector(31 downto 0)
	) return std_logic_vector is
		variable v_updated_crc32 : std_logic_vector(31 downto 0) := x"00000000";
		variable v_dword_byte    : std_logic_vector(7 downto 0)  := x"00";
	begin

		-- set the initial crc32 for calculation
		v_updated_crc32 := crc32_i;

		-- calculate updated crc32 for dword byte 3
		v_dword_byte    := dword_i(31 downto 24);
		v_updated_crc32 := f_ftdi_protocol_calculate_crc32_byte(v_updated_crc32, v_dword_byte);

		-- calculate updated crc32 for dword byte 2
		v_dword_byte    := dword_i(23 downto 16);
		v_updated_crc32 := f_ftdi_protocol_calculate_crc32_byte(v_updated_crc32, v_dword_byte);

		-- calculate updated crc32 for dword byte 1
		v_dword_byte    := dword_i(15 downto 8);
		v_updated_crc32 := f_ftdi_protocol_calculate_crc32_byte(v_updated_crc32, v_dword_byte);

		-- calculate updated crc32 for dword byte 0
		v_dword_byte    := dword_i(7 downto 0);
		v_updated_crc32 := f_ftdi_protocol_calculate_crc32_byte(v_updated_crc32, v_dword_byte);

		return v_updated_crc32;
	end function f_ftdi_protocol_calculate_crc32_dword;

	-- Function to finish the calculation of the ftdi protocol CRC32, copied from the PUS CRC32 implementation
	function f_ftdi_protocol_finish_crc32(
		constant crc32_i : in std_logic_vector(31 downto 0)
	) return std_logic_vector is
		variable v_updated_crc32 : std_logic_vector(31 downto 0) := x"00000000";
	begin

		-- finsih the calculation of the crc32 ((crc ^ 0xFFFFFFFF))
		v_updated_crc32 := (crc32_i) xor (c_FTDI_PROT_CRC32_FINISH);

		return v_updated_crc32;
	end function f_ftdi_protocol_finish_crc32;

end package body ftdi_protocol_crc_pkg;
