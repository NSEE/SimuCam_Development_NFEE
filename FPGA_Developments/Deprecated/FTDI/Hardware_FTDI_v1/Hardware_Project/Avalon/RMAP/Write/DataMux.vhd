--N�cleo de Sistemas Embarcados - Instituto Mau� de Tecnologia
--projeto: Simulador FEE
--nome do programa: 
--finalidade: Finalidade do programa
--vers�o: 1.0
--autor: Tiago Sanches da Silva
--		   <tiago.eem@gmail.com>
--data: 01-08-11
--
-- este bloco quando em modo de erro ele troca o bit mais e menos significativo
-------------------------------------------------------------------------------
-- ======================
-- Modificacoes	- Corsi
-- ======================
-- 1/9/2016
--      adicionado campo extra para os dados appendices que sao
--      adicionados ao inicio de cada linha
--
-- PLATO 2.0 - set/2014
-------------------------------------------------------------------------------
-- Removido os dados de Prescan e CCD identify, agora esses valores devem 
-- ser adicionados ao dado gravado na FIFO.
-- 
-- na verdade, esse mux ja nao e necessario
-------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;


ENTITY DataMux IS
	PORT(
                MuxSelect  : IN  STD_LOGIC_VECTOR(1 downto 0); 
                Append     : IN  STD_LOGIC_VECTOR(7 downto 0);
		Image	   : IN  STD_LOGIC_VECTOR(7 downto 0);
		data_OUT   : OUT STD_LOGIC_VECTOR(7 downto 0)
	);
END DataMux;

architecture basico of DataMux is
begin

        data_out <= Append when MuxSelect = "01" else
                    Image;

end basico;			
