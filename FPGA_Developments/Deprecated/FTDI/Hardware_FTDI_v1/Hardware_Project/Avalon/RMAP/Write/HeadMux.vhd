--N�cleo de Sistemas Embarcados - Instituto Mau� de Tecnologia
--projeto: Simulador FEE
--nome do programa: 
--finalidade: Finalidade do programa
--vers�o: 1.0
--autor: Tiago Sanches da Silva
--		   <tiago.eem@gmail.com>
--data: 18-07-11

LIBRARY ieee;
USE ieee.std_logic_1164.all;


ENTITY HeadMux IS
	PORT
	(
		clock	:	in std_logic;

        head_or_CRC :	IN STD_LOGIC ; --(0: Head; 1:CRC)
		Error_Mode	:	IN STD_LOGIC ;
		data_head_in:	IN STD_LOGIC_VECTOR(7 downto 0);
		data_CRC_in	:	IN STD_LOGIC_VECTOR(7 downto 0);
            data_OUT	:	OUT STD_LOGIC_VECTOR(7 downto 0)
	);
END HeadMux;


architecture basico of HeadMux is
begin
	carregar_valores: process(clock)
	begin
		if (rising_edge(clock)) then
			case head_or_CRC is
				when '0'	=>
					data_OUT	<=	data_head_in;
				when	others	=> -- 1: CRC
					if Error_Mode = '1' then
						data_OUT	<=	not(data_CRC_in(7)) & data_CRC_in(6) & data_CRC_in(5) & data_CRC_in(4) & data_CRC_in(3) & data_CRC_in(2) &
											data_CRC_in(1) & not(data_CRC_in(0));
					else
						data_OUT	<=	data_CRC_in;
					end if;
			end case;
		end if;
	end process carregar_valores;
end architecture basico;

