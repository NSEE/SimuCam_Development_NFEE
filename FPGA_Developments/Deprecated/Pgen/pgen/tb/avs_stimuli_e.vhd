library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity avs_stimuli is
	generic(
		g_CTR_ADDRESS_WIDTH : natural range 1 to 64 := 8;
		g_CTR_DATA_WIDTH    : natural range 1 to 64 := 32;
		g_DT_ADDRESS_WIDTH  : natural range 1 to 64 := 10;
		g_DT_DATA_WIDTH     : natural range 1 to 64 := 64
	);
	port(
		clk_i                     : in  std_logic;
		rst_i                     : in  std_logic;
		-- Data port 64-bit
		avalon_mm_d_readdata_i    : in  std_logic_vector((g_DT_DATA_WIDTH - 1) downto 0);
		avalon_mm_d_waitrequest_i : in  std_logic;
		avalon_mm_d_address_o     : out std_logic_vector((g_DT_ADDRESS_WIDTH - 1) downto 0);
		avalon_mm_d_read_o        : out std_logic;
		-- Control port 32-bit
		avalon_mm_c_readdata_i    : in  std_logic_vector((g_CTR_DATA_WIDTH - 1) downto 0);
		avalon_mm_c_waitrequest_i : in  std_logic;
		avalon_mm_c_address_o     : out std_logic_vector((g_CTR_ADDRESS_WIDTH - 1) downto 0);
		avalon_mm_c_write_o       : out std_logic;
		avalon_mm_c_writedata_o   : out std_logic_vector((g_CTR_DATA_WIDTH - 1) downto 0);
		avalon_mm_c_read_o        : out std_logic
	);
end entity avs_stimuli;

architecture rtl of avs_stimuli is

	type t_read_st is (
		READ_PH1,
		READ_PH2,
		READ_PH3
	);

	-- Timeline offset	
	constant c_TIME_OFFSET : natural range 0 to 30000 := 100;

	-- Control port register writing bit mapping
	alias a_c_wr_reg     : std_logic_vector(31 downto 0) is avalon_mm_c_writedata_o(31 downto 0);
	-- Pattern Size Register (address: 1)
	alias a_c_rows       : std_logic_vector(15 downto 0) is avalon_mm_c_writedata_o(31 downto 16);
	alias a_c_columns    : std_logic_vector(15 downto 0) is avalon_mm_c_writedata_o(15 downto 0);
	-- Pattern Parameters Register (address: 2)
	alias a_c_timecode   : std_logic_vector(7 downto 0) is avalon_mm_c_writedata_o(7 downto 0);
	alias a_c_ccd_number : std_logic_vector(1 downto 0) is avalon_mm_c_writedata_o(9 downto 8);
	alias a_c_ccd_side   : std_logic is avalon_mm_c_writedata_o(10);
	alias a_c_mask_field : std_logic is avalon_mm_c_writedata_o(11);
	-- Generator Control and Status Register (address: 0)
	alias a_c_start      : std_logic is avalon_mm_c_writedata_o(4);
	alias a_c_stop       : std_logic is avalon_mm_c_writedata_o(3);
	alias a_c_reset      : std_logic is avalon_mm_c_writedata_o(2);
	alias a_c_resetted   : std_logic is avalon_mm_c_readdata_i(1);
	alias a_c_stopped    : std_logic is avalon_mm_c_readdata_i(0);

	-- Data port register reading bit mapping
	alias a_d_data : std_logic_vector(63 downto 0) is avalon_mm_d_readdata_i(63 downto 0);

begin
	p_avs_stimuli : process(clk_i, rst_i) is
		-- Timeline counter
		variable v_counter : natural range 0 to 30000 := 0;
		-- Aux reg address
		variable v_address : natural                  := 0;
		-- Aux reg value
		variable v_value   : natural                  := 0;
		-- Reading state
		variable v_read_state      : t_read_st  := READ_PH1;
		
	begin
		if (rst_i = '1') then
			-- Control port
			avalon_mm_c_address_o   <= (others => '0');
			avalon_mm_c_write_o     <= '0';
			avalon_mm_c_writedata_o <= (others => '0');
			avalon_mm_c_read_o      <= '0';
			-- Data port
			avalon_mm_d_address_o   <= (others => '0');
			avalon_mm_d_read_o      <= '0';
			-- Timeline
			v_counter               := 0;
			-- Read state
			v_read_state := READ_PH1;

		elsif rising_edge(clk_i) then
			-- Control port - outputs default level
			avalon_mm_c_address_o   <= (others => '0');
			avalon_mm_c_write_o     <= '0';
			avalon_mm_c_writedata_o <= (others => '0');
			avalon_mm_c_read_o      <= '0';
			-- Timeline counting
			v_counter             := v_counter + 1;

			case v_counter is
				when (c_TIME_OFFSET + 500) to (c_TIME_OFFSET + 501) =>
					-- Generator config
					-- Control write: Pattern Size Register (address: 1)
					v_address             := 1;
					avalon_mm_c_address_o <= std_logic_vector(to_unsigned(v_address, 8));
					-- 200 rows and 200 columns
					v_value               := 200;
					a_c_rows              <= std_logic_vector(to_unsigned(v_value, 16));
					a_c_columns           <= std_logic_vector(to_unsigned(v_value, 16));
					avalon_mm_c_write_o   <= '1';

				when (c_TIME_OFFSET + 1000) to (c_TIME_OFFSET + 1001) =>
					-- Generator config
					-- Control write: Pattern Parameters Register (address: 2)
					v_address             := 2;
					avalon_mm_c_address_o <= std_logic_vector(to_unsigned(v_address, 8));
					-- Timecode = 0
					v_value               := 0;
					a_c_timecode          <= std_logic_vector(to_unsigned(v_value, 8));
					-- Ccd number = 2
					a_c_ccd_number        <= "10";
					-- Ccd side = 0 (left)
					a_c_ccd_side          <= '0';
					-- Mask field = 0 (without mask)
					a_c_mask_field        <= '0'; 
					avalon_mm_c_write_o   <= '1';

				when (c_TIME_OFFSET + 1500) to (c_TIME_OFFSET + 1501) =>
					-- Generator reset -> update current configuration
					-- Control write: Control and Status Register (address: 0)
					v_address             := 0;
					avalon_mm_c_address_o <= std_logic_vector(to_unsigned(v_address, 8));
					a_c_reset 			  <= '1'; 
					avalon_mm_c_write_o   <= '1';

				when (c_TIME_OFFSET + 2000) to (c_TIME_OFFSET + 2001) =>
					-- Generator start
					-- Control write: Control and Status Register (address: 0)
					v_address             := 0;
					avalon_mm_c_address_o <= std_logic_vector(to_unsigned(v_address, 8));
					a_c_start 			  <= '1'; 
					avalon_mm_c_write_o   <= '1';

				when (c_TIME_OFFSET + 3000) to (c_TIME_OFFSET + 3001) =>
					-- Generator stop
					-- Control write: Control and Status Register (address: 0)
					v_address             := 0;
					avalon_mm_c_address_o <= std_logic_vector(to_unsigned(v_address, 8));
					a_c_stop 			  <= '1'; 
					avalon_mm_c_write_o   <= '1';

				when (c_TIME_OFFSET + 3100) to (c_TIME_OFFSET + 3800) =>
					v_address             := 0;
					avalon_mm_d_address_o <= std_logic_vector(to_unsigned(v_address, 10));

					case (v_read_state) is
						when READ_PH1 => 
							avalon_mm_d_read_o    <= '1';
							v_read_state := READ_PH2;

						when READ_PH2 => 
							if (avalon_mm_d_waitrequest_i = '0') then
								avalon_mm_d_read_o    <= '0';
								v_read_state := READ_PH3;	
							end if;

						when READ_PH3 => 
							v_read_state := READ_PH1;
	
						when others =>
							null;
					end case;

				when (c_TIME_OFFSET + 3801) to (c_TIME_OFFSET + 4800) =>
					-- Make sure read request is off!
					avalon_mm_d_read_o    <= '0';
					v_read_state := READ_PH1;
					-- Generator start
					-- Control write: Control and Status Register (address: 0)
					v_address             := 0;
					avalon_mm_c_address_o <= std_logic_vector(to_unsigned(v_address, 8));
					a_c_start 			  <= '1'; 
					avalon_mm_c_write_o   <= '1';

				when (c_TIME_OFFSET + 4801) to (c_TIME_OFFSET + 4802) =>
					-- Generator stop
					-- Control write: Control and Status Register (address: 0)
					v_address             := 0;
					avalon_mm_c_address_o <= std_logic_vector(to_unsigned(v_address, 8));
					a_c_stop 			  <= '1'; 
					avalon_mm_c_write_o   <= '1';

				when (c_TIME_OFFSET + 5000) to (c_TIME_OFFSET + 5700) =>
					v_address             := 0;
					avalon_mm_d_address_o <= std_logic_vector(to_unsigned(v_address, 10));

					case (v_read_state) is
						when READ_PH1 => 
							avalon_mm_d_read_o    <= '1';
							v_read_state := READ_PH2;

						when READ_PH2 => 
							if (avalon_mm_d_waitrequest_i = '0') then
								avalon_mm_d_read_o    <= '0';
								v_read_state := READ_PH3;	
							end if;

						when READ_PH3 => 
							v_read_state := READ_PH1;
	
						when others =>
							null;
					end case;

				when others =>
					null;
			end case;
		end if;
	end process p_avs_stimuli;

end architecture rtl;
