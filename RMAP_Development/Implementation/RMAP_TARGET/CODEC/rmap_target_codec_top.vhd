library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.rmap_target_codec_pkg.all;

entity rmap_target_codec_top is
	port(
		clk_i                    : in  std_logic;
		rst_i                    : in  std_logic;
		-- spw codec --
		-- spw codec comunication (data receive)
		spw_rx_valid_i           : in  std_logic;
		spw_rx_flag_i            : in  std_logic;
		spw_rx_data_i            : in  std_logic_vector(7 downto 0);
		spw_rx_read_o            : out std_logic;
		-- spw codec comunication (data transmission)
		spw_tx_ready_i           : in  std_logic;
		spw_tx_flag_o            : out std_logic;
		spw_tx_data_o            : out std_logic_vector(7 downto 0);
		spw_tx_write_o           : out std_logic;
		-- spw codec error                                          
		spw_codec_error_o        : out std_logic;
		-- memory access --
		-- memory communication (read)
		mem_read_data_i          : in  rmap_target_codec_read_mem_data_type;
		mem_read_control_o       : out rmap_target_codec_read_mem_control_type;
		-- memory communication (write)                             
		mem_write_data_i         : in  rmap_target_codec_write_data_type;
		-- general --
		-- header data
		rmap_headerdata_o        : out rmap_target_codec_header_data_type;
		rmap_error_o             : out rmap_target_codec_general_error_type;
		-- header --
		-- status flags                                             
		rmap_header_flags_o      : out rmap_target_codec_header_flags_type;
		-- control flags                                            
		rmap_header_control_i    : in  rmap_target_codec_header_control_type;
		-- busy flag                                                
		rmap_header_busy_o       : out std_logic;
		-- reply --
		-- status data
		rmap_reply_data_status_i : in  std_logic_vector(7 downto 0);
		-- status flags
		rmap_reply_flags_o       : out rmap_target_codec_reply_flags_type;
		-- control flags                                            
		rmap_reply_control_i     : in  rmap_target_codec_reply_control_type;
		-- busy flag                                                
		rmap_reply_busy_o        : out std_logic;
		-- write --         
		-- status flags                                             
		rmap_write_flags_o       : out rmap_target_codec_write_flags_type;
		-- control flags                                            
		rmap_write_control_i     : in  rmap_target_codec_write_control_type;
		-- busy flag                                                
		rmap_write_busy_o        : out std_logic;
		-- read --                              
		-- status flags                                             
		rmap_read_flags_o        : out rmap_target_codec_read_flags_type;
		-- control flags                                            
		rmap_read_control_i      : in  rmap_target_codec_read_control_type;
		-- busy flag                                                
		rmap_read_busy_o         : out std_logic
	);
end entity rmap_target_codec_top;

architecture RTL of rmap_target_codec_top is

	-- spw codec --
	-- spw codec comunication (data receive)
	signal spw_rx_valid_sig    : std_logic;
	signal spw_rx_flag_sig     : std_logic;
	signal spw_rx_data_sig     : std_logic_vector(7 downto 0);
	signal spw_rx_read_sig     : std_logic;
	-- spw codec comunication (data transmission)
	signal spw_tx_ready_sig    : std_logic;
	signal spw_tx_flag_sig     : std_logic;
	signal spw_tx_data_sig     : std_logic_vector(7 downto 0);
	signal spw_tx_write_sig    : std_logic;
	-- spw codec error                                          
	signal spw_codec_error_sig : std_logic;

	-- memory access --
	-- memory communication (read)
	signal mem_read_data_sig    : rmap_target_codec_read_mem_data_type;
	signal mem_read_control_sig : rmap_target_codec_read_mem_control_type;
	-- memory communication (write)                             
	signal mem_write_data_sig   : rmap_target_codec_write_data_type;

	-- general --
	-- header data
	signal rmap_headerdata_sig : rmap_target_codec_header_data_type;
	signal rmap_error_sig      : rmap_target_codec_general_error_type;

	-- header --
	-- error flags
	signal rmap_header_error_sig   : rmap_target_codec_header_error_type;
	-- status flags                                             
	signal rmap_header_flags_sig   : rmap_target_codec_header_flags_type;
	-- control flags                                            
	signal rmap_header_control_sig : rmap_target_codec_header_control_type;
	-- busy flag                                                
	signal rmap_header_busy_sig    : std_logic;

	-- reply --
	-- status data
	signal rmap_reply_data_status_sig : std_logic_vector(7 downto 0);
	-- status flags
	signal rmap_reply_flags_sig       : rmap_target_codec_reply_flags_type;
	-- control flags                                            
	signal rmap_reply_control_sig     : rmap_target_codec_reply_control_type;
	-- busy flag                                                
	signal rmap_reply_busy_sig        : std_logic;

	-- write --         
	-- error flags
	signal rmap_write_error_sig   : rmap_target_codec_write_error_type;
	-- status flags                                             
	signal rmap_write_flags_sig   : rmap_target_codec_write_flags_type;
	-- control flags                                            
	signal rmap_write_control_sig : rmap_target_codec_write_control_type;
	-- busy flag                                                
	signal rmap_write_busy_sig    : std_logic;

	-- read --
	-- status flags                                             
	signal rmap_read_flags_sig   : rmap_target_codec_read_flags_type;
	-- control flags                                            
	signal rmap_read_control_sig : rmap_target_codec_read_control_type;
	-- busy flag                                                
	signal rmap_read_busy_sig    : std_logic;

begin

	rmap_target_codec_header_ent_inst : entity work.rmap_target_codec_header_ent
		port map(
			clk_i                 => clk_i,
			rst_i                 => rst_i,
			spw_valid_i           => spw_rx_valid_sig,
			spw_flag_i            => spw_rx_flag_sig,
			spw_data_i            => spw_rx_data_sig,
			spw_read_o            => spw_rx_read_sig,
			spw_codec_error_o     => spw_codec_error_sig,
			rmap_header_data_o    => rmap_headerdata_sig,
			rmap_header_error_o   => rmap_header_error_sig,
			rmap_header_flags_o   => rmap_header_flags_sig,
			rmap_header_control_i => rmap_header_control_sig,
			rmap_header_busy_o    => rmap_header_busy_sig
		);

	rmap_target_codec_reply_ent_inst : entity work.rmap_target_codec_reply_ent
		port map(
			clk_i                                       => clk_i,
			rst_i                                       => rst_i,
			spw_ready_i                                 => spw_tx_ready_sig,
			spw_flag_o                                  => spw_tx_flag_sig,
			spw_data_o                                  => spw_tx_data_sig,
			spw_write_o                                 => spw_tx_write_sig,
			rmap_reply_data_i.reply_spw_address         => rmap_headerdata_sig.reply_address,
			rmap_reply_data_i.reply_spw_address_is_used => rmap_headerdata_sig.reply_address_is_used,
			rmap_reply_data_i.initiator_logical_address => rmap_headerdata_sig.initiator_logical_address,
			rmap_reply_data_i.instructions              => rmap_headerdata_sig.instructions,
			rmap_reply_data_i.status                    => rmap_reply_data_status_sig,
			rmap_reply_data_i.target_logical_address    => rmap_headerdata_sig.target_logical_address,
			rmap_reply_data_i.transaction_identifier    => rmap_headerdata_sig.transaction_identifier,
			rmap_reply_data_i.data_length               => rmap_headerdata_sig.data_length,
			rmap_reply_flags_o                          => rmap_reply_flags_sig,
			rmap_reply_control_i                        => rmap_reply_control_sig,
			rmap_reply_busy_o                           => rmap_reply_busy_sig
		);

	rmap_target_codec_write_ent_inst : entity work.rmap_target_codec_write_ent
		port map(
			clk_i                                                        => clk_i,
			rst_i                                                        => rst_i,
			spw_valid_i                                                  => spw_rx_valid_sig,
			spw_flag_i                                                   => spw_rx_flag_sig,
			spw_data_i                                                   => spw_rx_data_sig,
			spw_read_o                                                   => spw_rx_read_sig,
			spw_codec_error_o                                            => spw_codec_error_sig,
			mem_write_data_o                                             => mem_write_data_sig,
			rmap_write_headerdata_i.instruction_verify_data_before_write => rmap_headerdata_sig.instructions.command.verify_data_before_write,
			rmap_write_headerdata_i.instruction_increment_address        => rmap_headerdata_sig.instructions.command.increment_address,
			rmap_write_headerdata_i.full_address                         => to_integer(unsigned(rmap_headerdata_sig.extended_address & rmap_headerdata_sig.address(4) & rmap_headerdata_sig.address(3) & rmap_headerdata_sig.address(2) & rmap_headerdata_sig.address(1))),
			rmap_write_headerdata_i.data_length                          => to_integer(unsigned(rmap_headerdata_sig.data_length(3) & rmap_headerdata_sig.data_length(2) & rmap_headerdata_sig.data_length(1))),
			rmap_write_error_o                                           => rmap_write_error_sig,
			rmap_write_flags_o                                           => rmap_write_flags_sig,
			rmap_write_control_i                                         => rmap_write_control_sig,
			rmap_write_busy_o                                            => rmap_write_busy_sig
		);

	rmap_target_codec_read_ent_inst : entity work.rmap_target_codec_read_ent
		port map(
			clk_i                                                => clk_i,
			rst_i                                                => rst_i,
			spw_ready_i                                          => spw_tx_ready_sig,
			spw_flag_o                                           => spw_tx_flag_sig,
			spw_data_o                                           => spw_tx_data_sig,
			spw_write_o                                          => spw_tx_write_sig,
			mem_read_data_i                                      => mem_read_data_sig,
			mem_read_control_o                                   => mem_read_control_sig,
			rmap_read_headerdata_i.instruction_increment_address => rmap_headerdata_sig.instructions.command.verify_data_before_write,
			rmap_read_headerdata_i.full_address                  => to_integer(unsigned(rmap_headerdata_sig.extended_address & rmap_headerdata_sig.address(4) & rmap_headerdata_sig.address(3) & rmap_headerdata_sig.address(2) & rmap_headerdata_sig.address(1))),
			rmap_read_headerdata_i.data_length                   => to_integer(unsigned(rmap_headerdata_sig.data_length(3) & rmap_headerdata_sig.data_length(2) & rmap_headerdata_sig.data_length(1))),
			rmap_read_flags_o                                    => rmap_read_flags_sig,
			rmap_read_control_i                                  => rmap_read_control_sig,
			rmap_read_busy_o                                     => rmap_read_busy_sig
		);

	-- error signal assignments
	rmap_error_sig.early_eop             <= (rmap_header_error_sig.early_eop) and (rmap_write_error_sig.early_eop);
	rmap_error_sig.eep                   <= (rmap_header_error_sig.eep) and (rmap_write_error_sig.eep);
	rmap_error_sig.header_crc            <= rmap_header_error_sig.header_crc;
	rmap_error_sig.unused_packet_type    <= rmap_header_error_sig.unused_packet_type;
	rmap_error_sig.invalid_command_code  <= rmap_header_error_sig.invalid_command_code;
	rmap_error_sig.too_much_data         <= (rmap_header_error_sig.too_much_data) and (rmap_write_error_sig.too_much_data);
	rmap_error_sig.verify_buffer_overrun <= rmap_write_error_sig.verify_buffer_overrun;
	rmap_error_sig.invalid_data_crc      <= rmap_write_error_sig.invalid_data_crc;

	rmap_target_codec_top_proc : process(clk_i, rst_i) is
	begin
		if (rst_i = '1') then
		-- reset procedures
		elsif (rising_edge(clk_i)) then
			-- signal to port assingments

			-- spw codec --
			-- spw codec comunication (data receive)
			spw_rx_valid_sig  <= spw_rx_valid_i;
			spw_rx_flag_sig   <= spw_rx_flag_i;
			spw_rx_data_sig   <= spw_rx_data_i;
			spw_rx_read_o     <= spw_rx_read_sig;
			-- spw codec comunication (data transmission)   
			spw_tx_ready_sig  <= spw_tx_ready_i;
			spw_tx_flag_o     <= spw_tx_flag_sig;
			spw_tx_data_o     <= spw_tx_data_sig;
			spw_tx_write_o    <= spw_tx_write_sig;
			-- spw codec error                              
			spw_codec_error_o <= spw_codec_error_sig;

			-- memory access --                             
			-- memory communication (read)                  
			mem_read_data_sig  <= mem_read_data_i;
			mem_read_control_o <= mem_read_control_sig;
			-- memory communication (write)                 
			mem_write_data_sig <= mem_write_data_i;

			-- general --                                   
			-- header data                                  
			rmap_headerdata_o <= rmap_headerdata_sig;
			rmap_error_o      <= rmap_error_sig;
			-- header --                                    

			-- status flags                                 
			rmap_header_flags_o     <= rmap_header_flags_sig;
			-- control flags                                
			rmap_header_control_sig <= rmap_header_control_i;
			-- busy flag                                    
			rmap_header_busy_o      <= rmap_header_busy_sig;
			-- reply --                       

			-- status data                                  
			rmap_reply_data_status_sig <= rmap_reply_data_status_i;
			-- status flags                                 
			rmap_reply_flags_o         <= rmap_reply_flags_sig;
			-- control flags                                
			rmap_reply_control_sig     <= rmap_reply_control_i;
			-- busy flag                                    
			rmap_reply_busy_o          <= rmap_reply_busy_sig;
			-- write --                       

			-- status flags                                 
			rmap_write_flags_o     <= rmap_write_flags_sig;
			-- control flags                                
			rmap_write_control_sig <= rmap_write_control_i;
			-- busy flag                                    
			rmap_write_busy_o      <= rmap_write_busy_sig;
			-- read --                  

			-- status flags                                 
			rmap_read_flags_o     <= rmap_read_flags_sig;
			-- control flags                                
			rmap_read_control_sig <= rmap_read_control_i;
			-- busy flag                                    
			rmap_read_busy_o      <= rmap_read_busy_sig;

		end if;
	end process rmap_target_codec_top_proc;

end architecture RTL;
