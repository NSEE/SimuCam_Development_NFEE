--N�cleo de Sistemas Embarcados - Instituto Mau� de Tecnologia
--projeto: Simulador FEE
--nome do programa: 
--finalidade: Finalidade do programa
--vers�o: 1.0
--autor: Tiago Sanches da Silva
--		   <tiago.eem@gmail.com>
--data: 16-03-11

--Resumo: Top Level - bloco CRC8

LIBRARY ieee;
USE ieee.std_logic_1164.all; 
Use work.all;

LIBRARY work;

ENTITY Modulo_crc_top IS 
	PORT
	(
		clock 			: IN  STD_LOGIC;
		clear 			: IN  STD_LOGIC;
		enable_ler_data : IN  STD_LOGIC;
		get_crc 		: IN  STD_LOGIC;
		data_in 		: IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
		CRC_out 		: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);	
		idle 			: OUT STD_LOGIC;
		CRC_ready 		: OUT STD_LOGIC
	);
END Modulo_crc_top;
	
Architecture uniao of Modulo_crc_top is
signal	resto_sinal :  STD_LOGIC_VECTOR(7 DOWNTO 0);	

type 	state_type is (S0,S1);
signal	state:	state_type 	:=S0 ;
signal	state1:	state_type 	:=S0 ;
signal	CRC_ready_signal	: std_logic := '0';
begin
		
CRC8_algoritmo_inst1 : entity CRC_ECSS			
port map	
	(
		clear			=> clear,
		enable			=> enable_ler_data,
		clock			=> clock,
		crc_anterior	=> resto_sinal,
		data_in			=> data_in,
		crc_out			=> resto_sinal
	);
	
LatchCRC_inst1 : entity Latch_CRC
port map	
	(
		clear	 =>	clear,
		enable	 =>	get_crc,
		clock	 => clock   ,
		resto_in => resto_sinal,
		crc_out  => CRC_out,

		ready_in =>	CRC_ready_signal,
		ready_out=>	CRC_ready				
	);		

	process(clock,clear)
	begin
		
		if (clear = '1') then
			CRC_ready_signal	<= '0';
			state <= s0 ;
			state1 <= s0 ;
		elsif rising_edge(clock) then
			case state is
				when s0	=>
					if (enable_ler_data = '1') then
						state <= s1 ;
--						idle_signal0 <= '0';
					else
						state <= s0 ;
--						idle_signal0 <= '1';						
					end if;
				when s1	=>
					state <= s0 ;					
			end case;			
		
			case state1 is
				when s0	=>
					if (get_crc = '1') then
						state1 				<= s1 ;
						CRC_ready_signal	<= '1';
						idle 				<= '0';
					else
						state1 				<= s0 ;
						idle 				<= '1';
						CRC_ready_signal	<= '0';
					end if;
				when s1	=>					
						state1 				<= s1 ;
						idle 				<= '1';
						CRC_ready_signal	<= '1';

			end case;				
		end if;

	end process;


END uniao;
