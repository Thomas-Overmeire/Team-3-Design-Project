
-------------------------------------------------------------------------------
--                                                              Copyright 1997.
--                                                     Atmosphere Networks Inc.
--                                                         All Rights Reserved.
--                                                                            .
--
--   File Name:     uart_enable.vhd
--
--   Title:         RTL - Entity/Architecture for UART_ENABLE.
--   Designer:      Stephen Fischer
--   Created:       Sun Oct 17 1997
--   Template Rev:  1.1
--
--   Description: 
--
--
--
--   !! VERSION specific code at bottom of file
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
--  Revision /main/4  Mon, Oct 8, 9:11:27, 2001  justin
--  Changed back to 19.2kbps
--
--  Revision /main/3  Sat, Oct 6, 10:29:12, 2001  justin
--  Changed UART baud rate to 115kbps
--
--  Revision /main/2  Wed, Oct 3, 13:48:15, 2001  justin
--  Changed to 16MHz clock
--
--  Revision /main/1  Mon, Oct 1, 19:49:7, 2001  stevenv
--  Initial Revision.
--
--
-------------------------------------------------------------------------------

library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.std_logic_unsigned.all;
    use work.func_pack.all;

-------------------------------------------------------------------------------
entity UART_ENABLE is
  generic (
    CLK_FREQ : real ;
    BAUD : integer );           --Baud Rate of the UART
    port
    (
        SYSRSTZ : in std_logic;
        CLK : in std_logic;
        UART_ENBL : buffer std_logic
    );
end UART_ENABLE;

-------------------------------------------------------------------------------
architecture RTL of UART_ENABLE is

 
    ---------------------------------------------------------------------------
    --                 CONSTANT, TYPE AND GENERIC DEFINITIONS                --
    ---------------------------------------------------------------------------

  constant MAX : integer := integer(CLK_FREQ/(16.0*real(BAUD))); --
                            --Maximum value of counter
  constant N : integer := Log2(MAX);    --Number of digits required for counter
  
    constant CNT_INIT : std_logic_vector(N-1 downto 0) := (others=>'0');

    constant CNT_MAX : std_logic_vector(N-1 downto 0) := conv_std_logic_vector(MAX-1,N);
    -- assert for one clock period every 81 clocks (19200 baud) for 25 MHZ
    -- CNT_MAX = 80 to achieve this
    -- constant CNT_MAX : std_logic_vector(6 downto 0) := "1010000";

    -- assert for one clock period every 52 clocks (19200 baud) for 16 MHZ
    -- CNT_MAX = 51 to achieve this
    -- constant CNT_MAX : std_logic_vector(6 downto 0) := "0110011";
    
    -- assert for one clock period every 16 clocks (115000 baud) for 16 MHZ
    -- CNT_MAX = 16 to achieve this
    -- constant CNT_MAX : std_logic_vector(6 downto 0) := "0001000";

    ---------------------------------------------------------------------------
    --                          SIGNAL DECLARATIONS                          --
    ---------------------------------------------------------------------------

    signal CNT : std_logic_vector(N-1 downto 0);
    
    ---------------------------------------------------------------------------
    --                        COMPONENT DECLARATIONS                         --
    ---------------------------------------------------------------------------

begin
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
    --  Process:  UART_ENABLE_PROCESS 
    --  Purpose:  
    --  Inputs:   
    --  Outputs:  
    ---------------------------------------------------------------------------
    UART_ENABLE_PROCESS : process(CLK,SYSRSTZ)
        
    begin

        if (SYSRSTZ = '0') then
            CNT <= CNT_INIT;
            UART_ENBL <= '0';
        elsif (CLK'event and CLK='1') then

            if (CNT=CNT_MAX) then
                UART_ENBL <= '1';
                CNT <= CNT_INIT ;
            else
                UART_ENBL <= '0';
                CNT <= CNT + "1";
            end if;
        end if;

    end process UART_ENABLE_PROCESS;

    ---------------------------------------------------------------------------
    --               OUTPUT CONCURRENT SIGNAL ASSIGNMENTS                    --
    ---------------------------------------------------------------------------

end RTL;
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
--                         CONFIGURATION STATEMENT                           --
-------------------------------------------------------------------------------

configuration UART_ENABLE_CON of UART_ENABLE is
    for RTL

    end for;
end UART_ENABLE_CON;

-------------------------------------------------------------------------------



