---====================== Start Software License ======================---
--==                                                                  ==--
--== This license governs the use of this software, and your use of   ==--
--== this software constitutes acceptance of this license. Agreement  ==--
--== with all points is required to use this software.                ==--
--==                                                                  ==--
--== 1. You may use this software freely for personal use.            ==--
--==                                                                  ==--
--== 2. You may use this software freely to determine feasibility for ==--
--==    commercial use.                                               ==--
--==                                                                  ==--
--== 3. You may use this software for commercial use if the author    ==--
--==    has given you written consent.                                ==--
--==                                                                  ==--
--== 4. You may modify this software provided you do not remove the   ==--
--==    license and copyright notice.                                 ==--
--==                                                                  ==--
--== 5. You may distribute this software and derivative works to      ==--
--==    personal friends and work colleagues only.                    ==--
--==                                                                  ==--
--== 6. You agree that this software comes �as-is� and with no        ==--
--==    warranty whatsoever, either expressed or implied, including,  ==--
--==    but not limited to, warranties of merchantability or fitness  ==--
--==    for a particular purpose.                                     ==--
--==                                                                  ==--
--== 7. You agree that the author will not be liable for any damages  ==--
--==    relating from the use of this software, including direct,     ==--
--==    indirect, consequential or incidental. This software is used  ==--
--==    entirely at your own risk and should it prove defective, you  ==--
--==    will assume full responsibility for all costs associated with ==--
--==    servicing, repair or correction.                              ==--
--==                                                                  ==--
--== Your rights under this license are terminated immediately if you ==--
--== breach it in any way.                                            ==--
--==                                                                  ==--
---======================= End Software License =======================---


---====================== Start Copyright Notice ======================---
--==                                                                  ==--
--== Filename ..... ac_fifo_wrap.vhd                                  ==--
--== Download ..... http://www.spacewire.co.uk                        ==--
--== Author ....... Steve Haywood (steve.haywood@ukonline.co.uk)      ==--
--== Copyright .... Copyright (c) 2004 Steve Haywood                  ==--
--== Project ...... Autonomous Cascadable Dual Port FIFO              ==--
--== Version ...... 1.00                                              ==--
--== Conception ... 12 June 2004                                      ==--
--== Modified ..... N/A                                               ==--
--==                                                                  ==--
---======================= End Copyright Notice =======================---


---========================= Start Description ========================---
--==                                                                  ==--
--== This module converts a standard Xilinx dual port FIFO into an    ==--
--== Autonomous Cascadable Dual Port FIFO. The module is simply a     ==--
--== wrapper that adds the neccassary handshake logic to a standard   ==--
--== FIFO design.                                                     ==--
--==                                                                  ==--
---========================== End Description =========================---

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity reply_autonomus is
  generic(
    --== Data Width ==--

    data_width : natural := 9
    );
  port(
    --==  General Interface ==--

    rst : in std_logic;
    clk : in std_logic;

    --== Input Interface ==--

    nwrite : in  std_logic;
    full   : out std_logic;
    din    : in  std_logic_vector(data_width-1 downto 0);

    --== Output Interface ==--

    empty : out std_logic;
    nread : in  std_logic;
    dout  : out std_logic_vector(data_width-1 downto 0)
    );
end reply_autonomus;


architecture rtl of reply_autonomus is

---==========================---
--== Component Declarations ==--
---==========================---

  component fifo_verify
	PORT
	(
		aclr		: IN STD_LOGIC ;
		clock		: IN STD_LOGIC ;
		data		: IN STD_LOGIC_VECTOR (8 DOWNTO 0);
		rdreq		: IN STD_LOGIC ;
		wrreq		: IN STD_LOGIC ;
		empty		: OUT STD_LOGIC ;
		full		: OUT STD_LOGIC ;
		q			: OUT STD_LOGIC_VECTOR (8 DOWNTO 0);
		usedw		: OUT STD_LOGIC_VECTOR (10 DOWNTO 0)
	);
  end component;

---=======================---
--== Signal Declarations ==--
---=======================---

  signal empty_int : std_logic;
  signal empty_i   : std_logic;
  signal full_i    : std_logic;
  signal rd_en     : std_logic;
  signal wr_en     : std_logic;

begin

  ---====================---
  --== FIFO write logic ==--
  ---====================---

  wr_en <= not(full_i) and not(nwrite);

  full <= full_i;

  reply_fifo : fifo_verify
    port map (
		  clock => clk,
		  aclr  => rst,
		  data  => din,
		  wrreq => wr_en,
		  rdreq => rd_en,
		  q  	=> dout,
		  full  => full_i,
		  empty => empty_int,
		  usedw => OPEN
      );

  ---===================---
  --== FIFO read logic ==--
  ---===================---

  rd_en <= not(empty_int) and (empty_i or not(nread));

  process(clk)
  begin
    if RISING_EDGE(clk) then
      if (rst = '1') then
        empty_i <= '1';
      else
        empty_i <= empty_int and (empty_i or not(nread));
      end if;
    end if;
  end process;

  empty <= empty_i;

end rtl;
