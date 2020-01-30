library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package windowing_dataset_pkg is

	-- buffer size to address
	type t_buffer_size_addr is array (0 to 15) of natural range 0 to 67;
	constant c_BUFFER_SIZE_TO_ADDR : t_buffer_size_addr := (
		4, 8, 12, 16, 21, 25, 29, 33, 38, 42, 46, 50, 55, 59, 63, 67
	);

	-- windowing buffer
	type t_windowing_buffer is record
		wrdata : std_logic_vector(255 downto 0);
		wrreq  : std_logic;
		sclr   : std_logic;
	end record t_windowing_buffer;

	-- windowing buffer control
	type t_windowing_buffer_control is record
		locked : std_logic;
	end record t_windowing_buffer_control;

	-- windowing buffer dataset data
	type t_windowing_dataset_data is array (0 to 15) of std_logic_vector(63 downto 0);

	-- windowing buffer dataset
	type t_windowing_dataset is record
		data : t_windowing_dataset_data;
		mask : std_logic_vector(63 downto 0);
	end record t_windowing_dataset;

	-- windowing buffer dataset buffer
	type t_windowing_dataset_buffer is array (0 to 15) of t_windowing_dataset;

	-- windowing avsbuff sc fifo
	type t_windowing_avsbuff_sc_fifo is record
		rdreq  : std_logic;
		empty  : std_logic;
		full   : std_logic;
		rddata : std_logic_vector(255 downto 0);
		usedw  : std_logic_vector(4 downto 0);
	end record t_windowing_avsbuff_sc_fifo;

	-- windowing avsbuff qword data
	type t_windowing_avsbuff_qword_data is array (0 to 3) of std_logic_vector(63 downto 0);

	--	function f_pattern_pixels_change_timecode(pattern_pixel_data_i : in std_logic_vector; timecode_i : in std_logic_vector) return std_logic_vector;

	function f_pixels_data_little_to_big_endian(little_endian_pixel_data_i : std_logic_vector) return std_logic_vector;

	function f_pixels_data_little_to_big_endian_single(little_endian_pixel_data_i : std_logic_vector; pixel_index_i : in natural) return std_logic_vector;

	function f_mask_conv(old_mask_i : std_logic_vector) return std_logic_vector;

	function f_mask_conv_single(old_mask_i : std_logic_vector; mask_index_i : natural) return std_logic;

end package windowing_dataset_pkg;

package body windowing_dataset_pkg is

	--	function f_pattern_pixels_change_timecode(pattern_pixel_data_i : in std_logic_vector; timecode_i : in std_logic_vector) return std_logic_vector is
	--		variable v_new_pattern_pixel_data : std_logic_vector(63 downto 0);
	--	begin
	--
	--		-- generic pixel pattern (according to PLATO-DLR-PL-ICD-0002, issue 1.2):
	--		-- |  timecode[2:0] |       ccd      |      side      |    row[4:0]    |   column[4:0]  |
	--		-- |  15 downto 13  |  12 downto 11  |       10       |   9 downto  5  |   4 downto  0  |
	--		--
	--		-- pixels arrangement for little endian (avalon standart and real memory organization):
	--		-- |  pixel_3_msb |  pixel_3_lsb |  pixel_2_msb |  pixel_2_lsb |  pixel_1_msb |  pixel_1_lsb |  pixel_0_msb |  pixel_0_lsb | 
	--		-- | 63 downto 56 | 55 downto 48 | 47 downto 40 | 39 downto 32 | 31 downto 24 | 23 downto 16 | 15 downto  8 |  7 downto  0 |
	--		--
	--		-- pixel 0 pattern (in pattern data):
	--		-- |  timecode[2:0] |       ccd      |      side      |    row[4:0]    |   column[4:0]  |
	--		-- |  15 downto 13  |  12 downto 11  |       10       |   9 downto  5  |   4 downto  0  |
	--		--
	--		-- pixel 1 pattern (in pattern data):
	--		-- |  timecode[2:0] |       ccd      |      side      |    row[4:0]    |   column[4:0]  |
	--		-- |  31 downto 29  |  28 downto 27  |       26       |  25 downto 21  |  20 downto 16  |
	--		--
	--		-- pixel 2 pattern (in pattern data):
	--		-- |  timecode[2:0] |       ccd      |      side      |    row[4:0]    |   column[4:0]  |
	--		-- |  47 downto 45  |  44 downto 43  |       42       |  41 downto 37  |  36 downto 32  |
	--		--
	--		-- pixel 3 pattern (in pattern data):
	--		-- |  timecode[2:0] |       ccd      |      side      |    row[4:0]    |   column[4:0]  |
	--		-- |  63 downto 61  |  60 downto 59  |       58       |  57 downto 53  |  52 downto 48  |
	--		--
	--		-- timecode pattern replacement:
	--		-- s_new_pattern_data(63 downto 61) <= s_timecode(2 downto 0);
	--		-- s_new_pattern_data(60 downto 48) <= s_old_pattern_data(60 downto 48);
	--		-- s_new_pattern_data(47 downto 45) <= s_timecode(2 downto 0);
	--		-- s_new_pattern_data(44 downto 32) <= s_old_pattern_data(44 downto 32);
	--		-- s_new_pattern_data(31 downto 29) <= s_timecode(2 downto 0);
	--		-- s_new_pattern_data(28 downto 16) <= s_old_pattern_data(28 downto 16);
	--		-- s_new_pattern_data(15 downto 13) <= s_timecode(2 downto 0);
	--		-- s_new_pattern_data(12 downto  0) <= s_old_pattern_data(12 downto  0);
	--
	--		-- timecode pattern replacement:
	--		-- pixel 3 pattern
	--		v_new_pattern_pixel_data(63 downto 61) := timecode_i(2 downto 0);
	--		v_new_pattern_pixel_data(60 downto 48) := pattern_pixel_data_i(60 downto 48);
	--		-- pixel 2 pattern
	--		v_new_pattern_pixel_data(47 downto 45) := timecode_i(2 downto 0);
	--		v_new_pattern_pixel_data(44 downto 32) := pattern_pixel_data_i(44 downto 32);
	--		-- pixel 1 pattern
	--		v_new_pattern_pixel_data(31 downto 29) := timecode_i(2 downto 0);
	--		v_new_pattern_pixel_data(28 downto 16) := pattern_pixel_data_i(28 downto 16);
	--		-- pixel 0 pattern
	--		v_new_pattern_pixel_data(15 downto 13) := timecode_i(2 downto 0);
	--		v_new_pattern_pixel_data(12 downto 0)  := pattern_pixel_data_i(12 downto 0);
	--
	--		return v_new_pattern_pixel_data;
	--	end function f_pattern_pixels_change_timecode;

	function f_pixels_data_little_to_big_endian(little_endian_pixel_data_i : std_logic_vector) return std_logic_vector is
		variable v_big_endian_pixel_data : std_logic_vector(63 downto 0);
	begin

		-- pixels arrangement for little endian (avalon standart and real memory organization):
		-- |  pixel_3_msb |  pixel_3_lsb |  pixel_2_msb |  pixel_2_lsb |  pixel_1_msb |  pixel_1_lsb |  pixel_0_msb |  pixel_0_lsb | 
		-- | 63 downto 56 | 55 downto 48 | 47 downto 40 | 39 downto 32 | 31 downto 24 | 23 downto 16 | 15 downto  8 |  7 downto  0 |
		--
		-- pixels arrangement for big endian (for spacewire transmission):
		-- |  pixel_3_lsb |  pixel_3_msb |  pixel_2_lsb |  pixel_2_msb |  pixel_1_lsb |  pixel_1_msb |  pixel_0_lsb |  pixel_0_msb | 
		-- | 55 downto 48 | 63 downto 56 | 39 downto 32 | 47 downto 40 | 23 downto 16 | 31 downto 24 |  7 downto  0 | 15 downto  8 |
		--
		-- little endian to big endian conversion:
		-- s_big_endian(55 downto 48) <= s_little_endian(63 downto 56);
		-- s_big_endian(63 downto 56) <= s_little_endian(55 downto 48);
		-- s_big_endian(39 downto 32) <= s_little_endian(47 downto 40);
		-- s_big_endian(47 downto 40) <= s_little_endian(39 downto 32);
		-- s_big_endian(23 downto 16) <= s_little_endian(31 downto 24);
		-- s_big_endian(31 downto 24) <= s_little_endian(23 downto 16);
		-- s_big_endian( 7 downto  0) <= s_little_endian(15 downto  8);
		-- s_big_endian(15 downto  8) <= s_little_endian( 7 downto  0);

		-- little endian to big endian conversion:
		-- pixel 3 lsb
		v_big_endian_pixel_data(55 downto 48) := little_endian_pixel_data_i(63 downto 56);
		-- pixel 3 msb
		v_big_endian_pixel_data(63 downto 56) := little_endian_pixel_data_i(55 downto 48);
		-- pixel 2 lsb
		v_big_endian_pixel_data(39 downto 32) := little_endian_pixel_data_i(47 downto 40);
		-- pixel 2 msb
		v_big_endian_pixel_data(47 downto 40) := little_endian_pixel_data_i(39 downto 32);
		-- pixel 1 lsb
		v_big_endian_pixel_data(23 downto 16) := little_endian_pixel_data_i(31 downto 24);
		-- pixel 1 msb
		v_big_endian_pixel_data(31 downto 24) := little_endian_pixel_data_i(23 downto 16);
		-- pixel 0 lsb
		v_big_endian_pixel_data(7 downto 0)   := little_endian_pixel_data_i(15 downto 8);
		-- pixel 0 msb
		v_big_endian_pixel_data(15 downto 8)  := little_endian_pixel_data_i(7 downto 0);

		return v_big_endian_pixel_data;
	end function f_pixels_data_little_to_big_endian;

	function f_pixels_data_little_to_big_endian_single(little_endian_pixel_data_i : std_logic_vector; pixel_index_i : natural) return std_logic_vector is
		variable v_big_endian_pixel_data_single : std_logic_vector(15 downto 0);
	begin

		-- pixels arrangement for little endian (avalon standart and real memory organization):
		-- |  pixel_3_msb |  pixel_3_lsb |  pixel_2_msb |  pixel_2_lsb |  pixel_1_msb |  pixel_1_lsb |  pixel_0_msb |  pixel_0_lsb | 
		-- | 63 downto 56 | 55 downto 48 | 47 downto 40 | 39 downto 32 | 31 downto 24 | 23 downto 16 | 15 downto  8 |  7 downto  0 |
		--
		-- pixels arrangement for big endian (for spacewire transmission):
		-- |  pixel_3_lsb |  pixel_3_msb |  pixel_2_lsb |  pixel_2_msb |  pixel_1_lsb |  pixel_1_msb |  pixel_0_lsb |  pixel_0_msb | 
		-- | 55 downto 48 | 63 downto 56 | 39 downto 32 | 47 downto 40 | 23 downto 16 | 31 downto 24 |  7 downto  0 | 15 downto  8 |
		--
		-- little endian to big endian conversion:
		-- s_big_endian(55 downto 48) <= s_little_endian(63 downto 56);
		-- s_big_endian(63 downto 56) <= s_little_endian(55 downto 48);
		-- s_big_endian(39 downto 32) <= s_little_endian(47 downto 40);
		-- s_big_endian(47 downto 40) <= s_little_endian(39 downto 32);
		-- s_big_endian(23 downto 16) <= s_little_endian(31 downto 24);
		-- s_big_endian(31 downto 24) <= s_little_endian(23 downto 16);
		-- s_big_endian( 7 downto  0) <= s_little_endian(15 downto  8);
		-- s_big_endian(15 downto  8) <= s_little_endian( 7 downto  0);

		-- little endian to big endian conversion:
		-- pixel n lsb
		if (pixel_index_i = 0) then
			v_big_endian_pixel_data_single(7 downto 0)  := little_endian_pixel_data_i(((0 * 16) + 15) downto ((0 * 16) + 8));
			v_big_endian_pixel_data_single(15 downto 8) := little_endian_pixel_data_i(((0 * 16) + 7) downto (0 * 16));
		elsif (pixel_index_i = 1) then
			v_big_endian_pixel_data_single(7 downto 0)  := little_endian_pixel_data_i(((1 * 16) + 15) downto ((1 * 16) + 8));
			v_big_endian_pixel_data_single(15 downto 8) := little_endian_pixel_data_i(((1 * 16) + 7) downto (1 * 16));
		elsif (pixel_index_i = 2) then
			v_big_endian_pixel_data_single(7 downto 0)  := little_endian_pixel_data_i(((2 * 16) + 15) downto ((2 * 16) + 8));
			v_big_endian_pixel_data_single(15 downto 8) := little_endian_pixel_data_i(((2 * 16) + 7) downto (2 * 16));
		elsif (pixel_index_i = 3) then
			v_big_endian_pixel_data_single(7 downto 0)  := little_endian_pixel_data_i(((3 * 16) + 15) downto ((3 * 16) + 8));
			v_big_endian_pixel_data_single(15 downto 8) := little_endian_pixel_data_i(((3 * 16) + 7) downto (3 * 16));
		else
			v_big_endian_pixel_data_single := (others => '0');
		end if;

		return v_big_endian_pixel_data_single;
	end function f_pixels_data_little_to_big_endian_single;

	function f_mask_conv(old_mask_i : std_logic_vector) return std_logic_vector is
		variable v_new_mask : std_logic_vector(63 downto 0);
	begin

		-- mask bits correction:
		-- new_mask(63 downto 0) <= old_mask(0 to 63)

		v_new_mask(63) := old_mask_i(0);
		v_new_mask(62) := old_mask_i(1);
		v_new_mask(61) := old_mask_i(2);
		v_new_mask(60) := old_mask_i(3);
		v_new_mask(59) := old_mask_i(4);
		v_new_mask(58) := old_mask_i(5);
		v_new_mask(57) := old_mask_i(6);
		v_new_mask(56) := old_mask_i(7);
		v_new_mask(55) := old_mask_i(8);
		v_new_mask(54) := old_mask_i(9);
		v_new_mask(53) := old_mask_i(10);
		v_new_mask(52) := old_mask_i(11);
		v_new_mask(51) := old_mask_i(12);
		v_new_mask(50) := old_mask_i(13);
		v_new_mask(49) := old_mask_i(14);
		v_new_mask(48) := old_mask_i(15);
		v_new_mask(47) := old_mask_i(16);
		v_new_mask(46) := old_mask_i(17);
		v_new_mask(45) := old_mask_i(18);
		v_new_mask(44) := old_mask_i(19);
		v_new_mask(43) := old_mask_i(20);
		v_new_mask(42) := old_mask_i(21);
		v_new_mask(41) := old_mask_i(22);
		v_new_mask(40) := old_mask_i(23);
		v_new_mask(39) := old_mask_i(24);
		v_new_mask(38) := old_mask_i(25);
		v_new_mask(37) := old_mask_i(26);
		v_new_mask(36) := old_mask_i(27);
		v_new_mask(35) := old_mask_i(28);
		v_new_mask(34) := old_mask_i(29);
		v_new_mask(33) := old_mask_i(30);
		v_new_mask(32) := old_mask_i(31);
		v_new_mask(31) := old_mask_i(32);
		v_new_mask(30) := old_mask_i(33);
		v_new_mask(29) := old_mask_i(34);
		v_new_mask(28) := old_mask_i(35);
		v_new_mask(27) := old_mask_i(36);
		v_new_mask(26) := old_mask_i(37);
		v_new_mask(25) := old_mask_i(38);
		v_new_mask(24) := old_mask_i(39);
		v_new_mask(23) := old_mask_i(40);
		v_new_mask(22) := old_mask_i(41);
		v_new_mask(21) := old_mask_i(42);
		v_new_mask(20) := old_mask_i(43);
		v_new_mask(19) := old_mask_i(44);
		v_new_mask(18) := old_mask_i(45);
		v_new_mask(17) := old_mask_i(46);
		v_new_mask(16) := old_mask_i(47);
		v_new_mask(15) := old_mask_i(48);
		v_new_mask(14) := old_mask_i(49);
		v_new_mask(13) := old_mask_i(50);
		v_new_mask(12) := old_mask_i(51);
		v_new_mask(11) := old_mask_i(52);
		v_new_mask(10) := old_mask_i(53);
		v_new_mask(9)  := old_mask_i(54);
		v_new_mask(8)  := old_mask_i(55);
		v_new_mask(7)  := old_mask_i(56);
		v_new_mask(6)  := old_mask_i(57);
		v_new_mask(5)  := old_mask_i(58);
		v_new_mask(4)  := old_mask_i(59);
		v_new_mask(3)  := old_mask_i(60);
		v_new_mask(2)  := old_mask_i(61);
		v_new_mask(1)  := old_mask_i(62);
		v_new_mask(0)  := old_mask_i(63);

		return v_new_mask;
	end function f_mask_conv;

	function f_mask_conv_single(old_mask_i : std_logic_vector; mask_index_i : natural) return std_logic is
		variable v_new_mask_single : std_logic;
	begin

		-- mask bits correction:
		-- new_mask(63 downto 0) <= old_mask(0 to 63)

		v_new_mask_single := old_mask_i(63 - mask_index_i);

		return v_new_mask_single;
	end function f_mask_conv_single;

end package body windowing_dataset_pkg;
