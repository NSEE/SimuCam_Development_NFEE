
--Núcleo de Sistemas Embarcados - Instituto Mauá de Tecnologia
--projeto: Simulador FEE
--nome do programa: 
--finalidade: Finalidade do programa
--versão: 1.0
--autor: Tiago Sanches da Silva
--		   <tiago.eem@gmail.com>
--data: 23-03-11



--Resumo: Este bloco tem como finalidade calcular o crc 8 bits
--obs: algoritmo utilizado baseado no doc. ECSS-E-ST-50-11C Daft 1.3, p.85

LIBRARY ieee;
USE ieee.std_logic_1164.all;


ENTITY CRC_ECSS IS
	PORT
	(
		clear			: IN STD_LOGIC ;
		enable			: IN STD_LOGIC ;
		clock			: IN STD_LOGIC ;
		crc_anterior	: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		data_in			: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		crc_out			: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
END CRC_ECSS;


architecture CRC_Calculator of CRC_ECSS is
begin

	carregar_valores: process(clock,clear)
		variable LFSR:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	begin
	
		if clear = '1' then
			for i in 0 to 7 loop
				crc_out(i) <= '0';
			end loop;		
		elsif rising_edge(clock) then
		
			if ( enable = '1' ) then
				for i in 0 to 7 loop
					LFSR(7-i):=	crc_anterior(i);
				end loop;
				for j in 0 to 7 loop
					LFSR(7 downto 0) := 	LFSR(6 downto 2) &
												(data_in(j) xor LFSR(7) xor LFSR(1))	&
												(data_in(j) xor LFSR(7) xor LFSR(0))	&
												(data_in(j) xor LFSR(7));
				end loop;
				for i in 0 to 7 loop
					crc_out(7-i) <= LFSR(i);
				end loop;			
			end if;
			
		end if;
	
	end process carregar_valores;			
end architecture CRC_Calculator;
