--Ncleo de Sistemas Embarcados - Instituto Mau de Tecnologia
--projeto: Simulador FEE
--nome do programa: 
--finalidade: Finalidade do programa
--verso: 1.0
--autor: Tiago Sanches da Silva
--                 <tiago.eem@gmail.com>
--data: 31-07-11

-- este bloco implementa os 25 pre-scan pixels

library ieee;
use ieee.std_logic_1164.all;
use work.all;

entity DC_FIFO_TOP is
  port (
    clock   : in  std_logic;
    aclr    : in  std_logic := '0';
    data    : in  std_logic_vector (31 downto 0);
    rdclk   : in  std_logic;
    rdreq   : in  std_logic;
    wrclk   : in  std_logic;
    wrreq   : in  std_logic;
    q       : out std_logic_vector (7 downto 0);
    rdempty : out std_logic;
    rdusedw : out std_logic_vector (12 downto 0);
    wrfull  : out std_logic;
    wrusedw : out std_logic_vector (12 downto 0)
    );
end DC_FIFO_TOP;

architecture rtl of DC_FIFO_TOP is
  signal q_in_signal : std_logic_vector (7 downto 0);

  COMPONENT dc_fifo_altera
	PORT
	(
		aclr		: IN STD_LOGIC  := '0';
		data		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		rdclk		: IN STD_LOGIC ;
		rdreq		: IN STD_LOGIC ;
		wrclk		: IN STD_LOGIC ;
		wrreq		: IN STD_LOGIC ;
		q			: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		rdempty		: OUT STD_LOGIC ;
		rdusedw		: OUT STD_LOGIC_VECTOR (12 DOWNTO 0);
		wrfull		: OUT STD_LOGIC ;
		wrusedw		: OUT STD_LOGIC_VECTOR (10 DOWNTO 0)
	);
END COMPONENT;

begin

  dc :  dc_fifo_altera
    port map (
      aclr          => aclr,
      wrclk        	=> wrclk,
      rdclk        	=> rdclk,
      data          => data,
      wrreq         => wrreq,
      rdreq         => rdreq,
      q          	=> q, --
	  wrfull		=> wrfull,	
--      full          => open,
      rdempty       => rdempty,
      rdusedw		=> rdusedw,
      wrusedw		=> wrusedw(10 downto 0)
      );
      wrusedw(12 downto 11) <= (others => '0');
end rtl;
