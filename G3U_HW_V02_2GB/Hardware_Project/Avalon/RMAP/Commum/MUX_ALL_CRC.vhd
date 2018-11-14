--N�cleo de Sistemas Embarcados - Instituto Mau� de Tecnologia
--projeto: Simulador FEE
--nome do programa: 
--finalidade: Finalidade do programa
--vers�o: 1.0
--autor: Tiago Sanches da Silva
--                 <tiago.eem@gmail.com>
--data: 01-08-11


-- este bloco quando em modo de erro ele troca o bit mais e menos significativo

library ieee;
use ieee.std_logic_1164.all;

entity MUX_ALL_CRC1 is
  port
    (
     -- clock : in std_logic;

      ALL_or_CRC_EEP_EOP : in  std_logic_vector(1 downto 0);  --(00: ALL; 01:CRC; 10:EEP; 11:EOP)
      Error_Mode         : in  std_logic;
      data_ALL_in        : in  std_logic_vector(7 downto 0);
      data_CRC_in        : in  std_logic_vector(7 downto 0);
      data_OUT           : out std_logic_vector(8 downto 0)
      );
end MUX_ALL_CRC1;

architecture basico of MUX_ALL_CRC1 is
begin

  -- process(clock)
  -- begin
    -- if (rising_edge(clock)) then
      -- case ALL_or_CRC_EEP_EOP is
        -- when "00" =>
          -- data_OUT <= '0' & data_ALL_in;
        -- when "01" =>
          -- if (Error_Mode = '1') then
            -- data_OUT <= '0' & not(data_CRC_in(7)) & data_CRC_in(6) & data_CRC_in(5) &
                                -- data_CRC_in(4) & data_CRC_in(3) & data_CRC_in(2) &
                                -- data_CRC_in(1) & not(data_CRC_in(0));
          -- else
            -- data_OUT <= '0' & data_CRC_in;
          -- end if;
        -- when "10" =>
          -- data_OUT <= "100000000";
        -- when others =>
          -- data_OUT <= "100000001";
      -- end case;
    -- end if;
  -- end process;
	
	data_OUT <= '0' & data_ALL_in when 	ALL_or_CRC_EEP_EOP = "00" else								
				'0' & not(data_CRC_in(7)) & data_CRC_in(6) & data_CRC_in(5) &
					data_CRC_in(4) & data_CRC_in(3) & data_CRC_in(2) &
					data_CRC_in(1) & not(data_CRC_in(0)) when 
								((ALL_or_CRC_EEP_EOP = "01") and (Error_Mode = '1')) else	
				'0' & data_CRC_in when ALL_or_CRC_EEP_EOP = "01" else
				"100000000" when ALL_or_CRC_EEP_EOP = "10" else
				"100000001";
	

end architecture basico;
