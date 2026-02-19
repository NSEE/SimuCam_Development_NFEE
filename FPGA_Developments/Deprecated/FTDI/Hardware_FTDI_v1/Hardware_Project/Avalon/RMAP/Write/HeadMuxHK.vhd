
--Núcleo de Sistemas Embarcados - Instituto Mauá de Tecnologia
--projeto: Simulador FEE
--nome do programa: 
--finalidade: Finalidade do programa
--versão: 1.0
--autor: Tiago Sanches da Silva..
--                 <tiago.eem@gmail.com>
--data: 03-08-11


library ieee;
use ieee.std_logic_1164.all;

entity HeadMuxHK is
  port (
    clock : in std_logic;

    channel   : in  std_logic_vector(1 downto 0);  -- 00: Head; 01:CCDi; 10: SnapShot HK;10 and 11
    data_Head : in  std_logic_vector(7 downto 0);
    data_CCdi : in  std_logic_vector(7 downto 0);
    data_HK   : in  std_logic_vector(7 downto 0);
    data_out  : out std_logic_vector(7 downto 0)
    );
end entity HeadMuxHK;


architecture rtl of HeadMuxHK is
begin  -- architecture rtl

  data_out <= data_Head when (channel = "00") else
              data_CCdi  when (channel = "01") else
              data_HK ;
end architecture rtl;
