--Núcleo de Sistemas Embarcados - Instituto Mauá de Tecnologia
--projeto: Simulador FEE
--nome do programa: 
--finalidade: Finalidade do programa
--versão: 1.0
--autor: Tiago Sanches da Silva
--                 <tiago.eem@gmail.com>
--data: 25-07-11

-- este bloco implementa o ccd identify

-- 8 bits = que serão ignorados
--      8 bits = 2 LSB para identificaçao do CCD
-- 16 bits = contador para o sinal de sincronismo

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CCD_identify_Top is
  port (

    clock : in std_logic;
    aclr  : in std_logic;

    -- (00,01,10,11)
    --  ( 1, 2, 3, 4)
    -- será atualizada pelo bloco de timeCode
    CCD_number : in std_logic_vector(1 downto 0);
    en_update  : in std_logic;

    -- transmitido pelo bloco SubControl_DataBody
    en_data       : in  std_logic;
    data_out      : out std_logic_vector(7 downto 0)
    );
end CCD_identify_Top;



architecture rtl of CCD_identify_Top is

  type T_identify is array (0 to 1) of std_logic_vector(15 downto 0);  --X"0002",X"005A" apenas para simulaçao
  signal Identify_data : T_identify := (X"0000", X"0000");

  type state_type is (Spare, ccd_Ident, MSB_counter, LSB_counter, Finalize, void_clock);
  signal state_Id_ccd : state_type := Spare;


begin


  process(clock, aclr)
  begin
    
    if (aclr = '1') then
      Identify_data <= (X"0002", X"005A");  --X"0002",X"005A" apenas para simulaçao
      state_Id_ccd  <= Spare;
      
    elsif (rising_edge(clock)) then
      
      if (en_update = '1') then
        Identify_data(0) <= "00000000000000" & CCD_number(1) & CCD_number(0);
        state_Id_ccd     <= Spare;
      else
        case state_Id_ccd is
          when Spare =>
            if en_data = '1' then
              state_Id_ccd <= ccd_Ident;
            else
              state_Id_ccd <= Spare;
            end if;
          when ccd_Ident =>
            if en_data = '1' then
              state_Id_ccd <= MSB_counter;
            else
              state_Id_ccd <= ccd_Ident;
            end if;
          when MSB_counter =>
            if en_data = '1' then
              state_Id_ccd <= LSB_counter;
            else
              state_Id_ccd <= MSB_counter;
            end if;
          when LSB_counter =>
            if en_data = '1' then
              state_Id_ccd <= Finalize;
            else
              state_Id_ccd <= LSB_counter;
            end if;
          when Finalize =>
            if (Identify_data(1) = X"FFFF") then
              Identify_data(1) <= X"0000";
            else
              Identify_data(1) <= std_logic_vector(unsigned(Identify_data(1)) + to_unsigned(1, 1));
            end if;
            state_Id_ccd  <= void_clock;
          when void_clock =>
            state_Id_ccd <= Spare;
            
        end case;
      end if;
    end if;
  end process;

  data_out <= Identify_data(0)(15) & Identify_data(0)(14) & Identify_data(0)(13) & Identify_data(0)(12) & Identify_data(0)(11) & Identify_data(0)(10) & Identify_data(0)(09) & Identify_data(0)(08)
                                                when state_Id_ccd = Spare else
                                                Identify_data(0)(7) & Identify_data(0)(6) & Identify_data(0)(5) & Identify_data(0)(4) & Identify_data(0)(3) & Identify_data(0)(2) & Identify_data(0)(1) & Identify_data(0)(0)
                                                when state_Id_ccd = ccd_Ident else
                                                Identify_data(1)(15) & Identify_data(1)(14) & Identify_data(1)(13) & Identify_data(1)(12) & Identify_data(1)(11) & Identify_data(1)(10) & Identify_data(1)(09) & Identify_data(1)(08)
                                                when state_Id_ccd = MSB_counter else
                                                Identify_data(1)(7) & Identify_data(1)(6) & Identify_data(1)(5) & Identify_data(1)(4) & Identify_data(1)(3) & Identify_data(1)(2) & Identify_data(1)(1) & Identify_data(1)(0)
                                                when state_Id_ccd = LSB_counter else
                                                X"00";
  

end rtl;
