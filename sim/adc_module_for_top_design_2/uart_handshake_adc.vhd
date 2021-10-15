
-------------------------------------------------------------------------------
--                                                              Copyright 1997.
--                                                     Atmosphere Networks Inc.
--                                                         All Rights Reserved.
--                                                                            .
--
--   File Name:     uart_handshake.vhd
--
--   Title:         RTL - Entity/Architecture for UART_HANDSHAKE.
--   Designer:      Antonio Cantoni
--   Created:       
--   Template Rev:  1.1
--
--   Description: 
--
--
--
--
--   Relevant Standards: 
--   
--   Input/Output: 
--   
--   Notes: 
--   
--   The following is updated by RCS/CVS.
--   Current Revision: $Revision$
--   Modification History:
--   $Log$
--
--  Revision /main/1  Mon, Oct 1, 19:49:8, 2001  stevenv
--  Initial Revision.
--
--
-------------------------------------------------------------------------------

library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.std_logic_unsigned.all;

-------------------------------------------------------------------------------
entity UART_HANDSHAKE is
    port
    (
      TBRE 		: in std_logic;
      CLK 		: in std_logic;
	  	SM_RESETZ	:in std_logic;
		TX_REQ		:in std_logic;
		NTBRL		: buffer std_logic
    );
end UART_HANDSHAKE;

-------------------------------------------------------------------------------
architecture RTL of UART_HANDSHAKE is

    ---------------------------------------------------------------------------
    --                 CONSTANT, TYPE AND GENERIC DEFINITIONS                --
    ---------------------------------------------------------------------------

	TYPE STATE_TYPE IS (idle,req,ack,noreq);
	

    ---------------------------------------------------------------------------
    --                          SIGNAL DECLARATIONS                          --
    ---------------------------------------------------------------------------

	SIGNAL state	: STATE_TYPE;
    
    ---------------------------------------------------------------------------
    --                        COMPONENT DECLARATIONS                         --
    ---------------------------------------------------------------------------

BEGIN
    ---------------------------------------------------------------------------
    --                    INSTANTIATE COMPONENTS                             --
    ---------------------------------------------------------------------------

    ---------------------------------------------------------------------------
    --                   INPUT CONCURRENT SIGNAL ASSIGNMENTS                 --
    ---------------------------------------------------------------------------

    ---------------------------------------------------------------------------
    --                         CONCURRENT PROCESSES                          --
    ---------------------------------------------------------------------------

    ---------------------------------------------------------------------------
    --  Process:  
    --  Purpose:  
    --  Inputs:   
    --  Outputs:  
    ---------------------------------------------------------------------------
UART_HANDSHAKE_PROCESS: PROCESS(CLK,SM_RESETZ)

	BEGIN
		IF 	SM_RESETZ = '0' THEN
			state <= idle;
			NTBRL <= '1';
		ELSIF (clk'EVENT AND clk = '1') THEN
			CASE state IS
				WHEN idle=>
					IF TX_REQ = '0' THEN
							state <= idle;
							NTBRL <= '1';
					ELSE
							state <=req;
							NTBRL <= '1';
					END IF;

				WHEN req=>
					IF TBRE = '0' THEN
							state <= req;
							NTBRL <= '1';
					ELSE
							state <= ack;
							NTBRL <= '1';
					END IF;
				WHEN ack=>
					IF TBRE = '1' THEN
							state <= ack;
							NTBRL <= '0';
					ELSE
							state <= noreq;
							NTBRL <= '1';
					END IF;
				WHEN noreq=>
					IF TX_REQ = '1' THEN
							state <= noreq;
							NTBRL <= '1';
					ELSE
							state <= idle;
							NTBRL <= '1';
					END IF;

			END CASE;
		END IF;
	END PROCESS UART_HANDSHAKE_PROCESS;


    ---------------------------------------------------------------------------
    --               OUTPUT CONCURRENT SIGNAL ASSIGNMENTS                    --
    ---------------------------------------------------------------------------

end RTL;
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
--                         CONFIGURATION STATEMENT                           --
-------------------------------------------------------------------------------

configuration UART_HANDSHAKE_CON of UART_HANDSHAKE is
    for RTL

    end for;
end UART_HANDSHAKE_CON;

-------------------------------------------------------------------------------

