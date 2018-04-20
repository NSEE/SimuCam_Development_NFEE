--Núcleo de Sistemas Embarcados - Instituto Mauá de Tecnologia
--projeto: Simulador FEE
--nome do programa: 
--finalidade: Finalidade do programa
--versão: 1.0
--autor: Tiago Sanches da Silva
--		   <tiago.eem@gmail.com>
--data: 31-07-11


LIBRARY ieee;
USE ieee.std_logic_1164.all;


ENTITY Latch_Fall_DCFIFO IS
	PORT
	(
		clock			: 	IN STD_LOGIC ;
		aclr			:	IN STD_LOGIC ;
		
		q_in			: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		q				: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
END Latch_Fall_DCFIFO;


architecture rtl of Latch_Fall_DCFIFO is
begin
			q			<=	q_in;
end rtl;
