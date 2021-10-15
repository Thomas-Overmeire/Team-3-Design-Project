-------------------------------------------------------------------------------
-- Title      : uart_vgen
-- Project    : 
-------------------------------------------------------------------------------
-- File       : uart_vgen.vhd
-- Author     :   <Tony@watri.org.au>
-- Company    : 
-- Last update: 2020/03/27
-- Platform   : 
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2020/03/24  1.0      Tony    Created
------------------------------------------------------------------------------

library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.std_logic_unsigned.all;

entity uart_control is
    Port (
      clk      : in std_logic;	-- System Clock (50MHz)     
      RST_L		: in std_logic;
      START	   : in std_logic; 
      UART_DONE :in std_logic; 
      DONE     : out std_logic
		);
end uart_control;

architecture bhv of uart_control is 
 

------------------------------------------------------------------------------------ 
		  type states is (Idle,	 TransmitOutStart, 	TransmitOutDone);  
		  signal current_state : states;
		  signal next_state : states;
		  signal enParalelLoad : std_logic;



begin
-----------------------------------------------------------------------------------
--
-- Title      : SYNC_PROC
--
-- Description: This is the process were the states are changed synchronously. At 
--              reset the current state becomes Idle state.
--	
-----------------------------------------------------------------------------------			
SYNC_PROC: process (clk, rst_L)
   begin
      if (clk'event and clk = '1') then
         if (rst_l= '0') then
            current_state <= Idle;
         else
            current_state <= next_state;
         end if;        
      end if;
   end process;
	
-----------------------------------------------------------------------------------
--
-- Title      : OUTPUT_DECODE
--
-- Description: This is the process were the output signals are generated
--              unsynchronously based on the state only (Moore State Machine).
--	
-----------------------------------------------------------------------------------		
OUTPUT_DECODE: process (current_state)
   begin
      if current_state = Idle then
			DONE <='1';
		elsif current_state = TransmitOutStart then
			DONE <='0';
		else
			DONE <='1';
		end if;
   end process;
	
-----------------------------------------------------------------------------------
--
-- Title      : NEXT_STATE_DECODE
--
-- Description: This is the process were the next state logic is generated 
--              depending on the current state and the input signals.
--	
-----------------------------------------------------------------------------------	
	NEXT_STATE_DECODE: process (current_state, START,UART_DONE)
   begin
      
      next_state <= current_state;  --default is to stay in current state
     
      case (current_state) is
         when Idle =>
            if START = '1' then
               next_state <= TransmitOutStart;
            end if;
         when TransmitOutStart =>
            if UART_DONE = '0' then
               next_state <= TransmitOutDone;
	    else
		next_state <= TransmitOutStart;
            end if;
         when TransmitOutDone =>
	    if UART_DONE = '1' then
              next_state <= Idle;
            else 
		next_state <= TransmitOutDone;
	    end if;
      end case;      
   end process;
	end bhv;

-------------------------------------------------------------------------------
--                         CONFIGURATION STATEMENT                           --
-------------------------------------------------------------------------------

configuration uart_control_CON of uart_control is
    for bhv
    
    end for;
end uart_control_CON;

-------------------------------------------------------------------------------
