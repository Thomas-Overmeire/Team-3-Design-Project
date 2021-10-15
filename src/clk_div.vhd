-------------------------------------------------------------------------------
-- Title      : clk_div
-- Project    : 
-------------------------------------------------------------------------------
-- File       : clk_div.vhd
-- Author     : Michael Cantoni
-- Company    : The University of Melbourne
-- Last update: 2014-01-12
-- Platform   : 
-------------------------------------------------------------------------------
-- Description: Divides incomming clk_in (27MHz) down to produce
--              1Hz clk by default. The frequency of clk produced can be
--              set via the generic constant CLK_IN_TICKS_PER_HALF_CLK
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2003/02/04  1.0      MC	Created
-- 2014/01/12  1.1      MC      Updated to suit Altera DE1 board 27MHz x-tal
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity clk_div is
  
  generic (
    -- There are 13500000 CLK_IN ticks per half second (i.e. per half default clk period)
    -- The constant here is this minus 1, because counting starts at 0
    CLK_IN_TICKS_PER_HALF_CLK : std_logic_vector(23 downto 0) := "110011011111111001011111");
  
  port (
	 rst_L : in  std_logic;
    clk_in : in  std_logic;
    clk    : out std_logic);

end clk_div;

architecture bhv of clk_div is

    signal clk_in_count : std_logic_vector(23 downto 0);
    signal int_clk : std_logic := '0';
begin  -- behavioural

 
  CLK_IN_CTR: process (clk_in,rst_L,clk_in_count,int_clk)

  begin  -- process CLK_IN_CTR
    if(rst_L = '0') then
       clk_in_count <="000000000000000000000000"; 
       int_clk<='0';
   else
      if clk_in'event and clk_in = '1' then  -- rising clock edge
      if clk_in_count = CLK_IN_TICKS_PER_HALF_CLK then  -- start counting again
        clk_in_count <="000000000000000000000000";     -- and toggle int_clk and hence clk  
        int_clk <=not int_clk;
      else
        clk_in_count <=clk_in_count + "000000000000000000000001";
        int_clk <= int_clk;
      end if;
    else
      clk_in_count <= clk_in_count;
      int_clk <=int_clk;
    end if;
    end if;
    clk <= int_clk;
 
  end process CLK_IN_CTR;
  
  
end bhv;
