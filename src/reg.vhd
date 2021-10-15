-------------------------------------------------------------------------------
-- Title      : register
-- Project    : 
-------------------------------------------------------------------------------
-- File       : reg.vhd
-- Author     : Michael Cantoni
-- Company    : The University of Melbourne
-- Last update: 2007/02/08
-- Platform   : 
-------------------------------------------------------------------------------
-- Description: register model
--              Generic const: DATA_WIDTH = system data word width
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2007/01/14  1.0      MC	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity reg is
  
  generic (
    DATA_WIDTH : natural := 8;
    INIT_VAL   : std_logic_vector);  

  port (
    -- Control signals:
    -- controls synchronous loading of register
    ld_reg : in std_logic;
    
    -- Status signal:
    -- Nil

    -- External inputs:
    -- for the synchronous data storage register
    rst_L  : in  std_logic;
    clk    : in  std_logic;

    -- External output:
    -- Nil

    -- Ports to shared system data bus:
    -- input
    reg_din  : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    -- output
    reg_dout : out std_logic_vector(DATA_WIDTH-1 downto 0));

end reg;

architecture bhv of reg is

  signal q : std_logic_vector(DATA_WIDTH-1 downto 0);
  
begin  -- bhv

  RDS: process (clk, rst_L, ld_reg, reg_din, q)
  begin  -- process REG
    if rst_L = '0' then                 -- asynchronous reset (active low)
      q <= INIT_VAL;
    elsif clk'event and clk = '1' then  -- rising clock edge
      if ld_reg = '1' then
        q <= reg_din;
      else
        q <= q;
      end if;
    else
      q <= q;
    end if;
  end process RDS;

  reg_dout <= q; 

end bhv;
