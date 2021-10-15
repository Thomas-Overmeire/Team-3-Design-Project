-------------------------------------------------------------------------------
-- Title      : synch_logic
-- Project    : Digital Systems Laboratory 1
-------------------------------------------------------------------------------
-- File       : synch_logic.vhd
-- Author     : Antonio Cantoni
-- Company    : UWA
-- Last update: 
-- Platform   : 
-------------------------------------------------------------------------------
-- Description: Synchroniser logic for rst_L
--              Produces system reset signal synchornised to negative
--              edge of clk_in
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description

-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity rst_synch_logic is
  
  port (
    rst_in_L 	    : in  std_logic;
    clk_in         : in  std_logic;
    clk            : in  std_logic;
    rst_out_L      : out std_logic;
    rst_out_L_clk_in      : out std_logic);

end rst_synch_logic;

architecture rtl of rst_synch_logic is

  signal synchFFp : std_logic;
  signal synchFFn1 : std_logic;
  signal synchFFn2 : std_logic;
  signal synchFFn : std_logic;
  signal synchClk1 : std_logic;
  signal synchClk : std_logic;
begin  -- rtl

  SYNCH_FFp : process (rst_in_L,clk_in, synchFFp)
  begin 
    if(rst_in_L='0')  then
	 synchFFp <='0';
    elsif clk_in'event and clk_in = '0' then
      synchFFp <= rst_in_L;
    else
      synchFFp <= synchFFp;    
    end if;
  end process;

  SYNCH_FFn : process (rst_in_L,clk_in, synchFFp,synchFFn,synchFFn1,synchFFn2)
  begin  -- process
    if(rst_in_L='0')  then
	synchFFn  <='0';
	synchFFn1 <='0';
	synchFFn2 <='0';
    elsif clk_in'event and clk_in = '0' then
      synchFFn1 <= synchFFp;
      synchFFn2 <= synchFFn1;
      synchFFn <= synchFFn2;   --- release reset after two positive edges
    else
      synchFFn1 <= synchFFn1;
      synchFFn2 <=synchFFn2;
      synchFFn <= synchFFn;
    end if;
  end process;
  
rst_out_L_clk_in<= synchFFn;

 CLK_SYNCH : process (rst_in_L,synchFFn,clk, synchClk,synchClk1)
  begin 
    if(rst_in_L='0')  then
	 synchClk1 <='0';
	 synchClk <='0';
    elsif clk'event and clk = '0' then
      synchClk1<= synchFFn;
      synchClk<= synchClk1;
    else
      synchClk <= synchClk; 
      synchClk1 <= synchClk1;   
    end if;
  end process;
  
rst_out_L <= synchClk;
  
end rtl;







