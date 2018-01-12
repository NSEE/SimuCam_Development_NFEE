
--N�cleo de Sistemas Embarcados - Instituto Mau� de Tecnologia
--projeto: Simulador FEE
--nome do programa: 
--finalidade: Finalidade do programa
--vers�o: 1.0
--autor: Tiago Sanches da Silva
--		   <tiago.eem@gmail.com>
--data: 16-03-11

--Resumo: Este bloco tem como finalidade ser um simples latch
-------------------------------------------------------------------------------
-- ======================
-- Modificacoes - Corsi
-- ======================
-- PLATO 2.0 - set/2014
-------------------------------------------------------------------------------
-- removido atualizacao do valor em borda de decida, isso implica em melhor
-- desempenho. 
-- Removido registradores extras colocado quando os sianis eram alterados em 
-- borda de subida
-------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Latch_CRC IS
	PORT
	(
		clear		: IN STD_LOGIC ;
		enable		: IN STD_LOGIC ;
		clock		: IN STD_LOGIC ;
		resto_in	: IN STD_LOGIC_VECTOR (7 DOWNTO 0); -- o bit mais significativo(8) nao faz parte to CRC, pois e sempre zero , vide diviso binaria
		crc_out		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		
		ready_in	: in std_logic;
		
		ready_out	: out std_logic
	);
END Latch_CRC;

architecture CRC_Latch of Latch_CRC is

begin

	carregar_valores: process(clock,clear)
	begin
	
		if (clear = '1') then
			crc_out <= (others => '0');
		elsif rising_edge(clock) then
			if (enable = '1') then
				crc_out <= resto_in;
			end if;
		end if;
		
	end process carregar_valores;	

--	process(clock,clear)
--	begin
--	
--		if (clear = '1') then
--			ready_out <= '0';		
--		elsif falling_edge(clock) then
--			ready_out <= ready_in;			
--		end if;
--		
--	end process;
	
	ready_out <= ready_in;			

	
end architecture CRC_Latch;