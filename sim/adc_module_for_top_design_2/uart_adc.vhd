   
    library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.std_logic_unsigned.all;

-------------------------------------------------------------------------------
 entity uart is
    generic (
    CLK_FREQ : real := 50.0E6;
    BAUD : integer := 19200);           --Baud Rate of the UART
    port (
        SYSRSTZ 	: in std_logic;
        SYSCLK 		: in std_logic;
        TBR 		: in std_logic_vector(7 downto 0);
        UART_LPBKZ 	: in std_logic;
        RRI 		: in std_logic;
        TX_REQ  	: in std_logic;
        TREMPTY 		: out std_logic; -- transmitter register empty
	TBEMPTY 		: out std_logic; -- transmitter register empty
	TDONE 			: buffer std_logic; -- transmit done
        SROUT 		: out std_logic;
        DATAREADY		: out std_logic;
        RXDATA		: out std_logic_vector(7 downto 0);
	STOP_BITS  : in std_logic

    );
end uart;


-------------------------------------------------------------------------------
architecture RTL of uart is

    ---------------------------------------------------------------------------
    --                 CONSTANT, TYPE AND GENERIC DEFINITIONS                --
    ---------------------------------------------------------------------------

    ---------------------------------------------------------------------------
    --                          SIGNAL DECLARATIONS                          --
    ---------------------------------------------------------------------------
	signal	UART_ENBL : std_logic;
	signal  NTBRL_LPBK : std_logic;
	signal  TBR_LOADZ :  std_logic;
	signal  TBR_IN :  std_logic_vector(7 downto 0);
	signal	RRI_SYNC :  std_logic;
	signal  TBRE : std_logic; -- transmitter buffer register empty
	signal  NTBRL: std_logic;
	signal TRE  : std_logic;
	signal TRO: std_logic;
	signal DR: std_logic;
	signal RBR:  std_logic_vector(7 downto 0);
    ---------------------------------------------------------------------------
    --                        COMPONENT DECLARATIONS                         --
    ---------------------------------------------------------------------------
component UART_LPBK 
    port
    (
        CLK : in std_logic;
	SYSRSTZ : in std_logic;
        NTBRL : in std_logic;
        NTBRL_LPBK : in std_logic;
        TBR : in std_logic_vector(7 downto 0);
        RBR : in std_logic_vector(7 downto 0);
        UART_LPBKZ : in std_logic;
        TBR_LOADZ : buffer std_logic;
        TBR_IN : buffer std_logic_vector(7 downto 0)
    );
end component;

component UART_SYNC     
	port
    (
        SYSRSTZ : in std_logic;
        CLK : in std_logic;
        RRI : in std_logic;
        RRI_SYNC : buffer std_logic
    );
end component;

component uart_tx 
    port (
        SYSRSTZ : in std_logic; -- system reset
        CLK : in std_logic;
        UART_ENBL : in std_logic;
        TBR_IN : in std_logic_vector(7 downto 0); -- transmitter buffer register input bus
        TBR_LOADZ : in std_logic; -- transmitter buffer register load
        TBRE : buffer std_logic; -- transmitter buffer register empty
        TRE : buffer std_logic; -- transmitter register empty
	TDONE : buffer std_logic; -- transmit done
        TRO : buffer std_logic;
	STOP_BITS  : in std_logic
    );
end component;

component UART_ENABLE
    generic (
      CLK_FREQ : real;
      BAUD     : integer);           --Baud Rate of the UART 
    port
    (
        SYSRSTZ : in std_logic;
        CLK : in std_logic;
        UART_ENBL : buffer std_logic
    );
end component;

component UART_RX 
    port (
        SYSRSTZ 	: in std_logic;
        CLK 		: in std_logic;
        UART_ENBL 	: in std_logic;
        RRI_SYNC 	: in std_logic;
	DR			: buffer std_logic;
	NTBRL_LPBK	: buffer std_logic;
        RBR			: buffer std_logic_vector(7 downto 0)
    );
end component;

component UART_HANDSHAKE 
    port
    (
        TBRE 		: in std_logic;
        CLK 		: in std_logic;
	  SM_RESETZ	:in std_logic;
	  TX_REQ		:in std_logic;
	  NTBRL		: buffer std_logic
    );
end component;



begin
TBEMPTY<=TBRE;
TREMPTY<=TRE;
SROUT<=TRO;
DATAREADY<=DR;
RXDATA<=RBR;
    ---------------------------------------------------------------------------
    --                    INSTANTIATE COMPONENTS                             --
    ---------------------------------------------------------------------------
U1_UART_LPBK : UART_LPBK
    port map    (
		CLK	=>	SYSCLK	,
		SYSRSTZ => SYSRSTZ,
		NTBRL	=>	NTBRL	,
		NTBRL_LPBK	=>	NTBRL_LPBK	,
		TBR	=>	TBR	,
		RBR	=>	RBR	,
		UART_LPBKZ	=>	UART_LPBKZ	,
		TBR_LOADZ	=>	TBR_LOADZ	,
		TBR_IN	=>	TBR_IN
    );


U1_UART_SYNC : UART_SYNC 
	port map    (
        SYSRSTZ => SYSRSTZ,
        CLK => SYSCLK,
        RRI => RRI,
        RRI_SYNC => RRI_SYNC    
		);

U1_uart_tx : uart_tx
    port map (
		SYSRSTZ	=>	SYSRSTZ	,
		CLK	=>	SYSCLK	,
		UART_ENBL	=>	UART_ENBL	,
		TBR_IN	=>	TBR_IN	,
		TBR_LOADZ	=>	TBR_LOADZ	,
		TBRE	=>	TBRE	,
		TRE	=>	TRE	,
		TDONE 	=>TDONE,
		TRO	=>	TRO,
	        STOP_BITS =>STOP_BITS	
    );


U1_UART_ENABLE : UART_ENABLE
    generic map (
      CLK_FREQ => CLK_FREQ,
      BAUD     => BAUD)
    port map    (
        SYSRSTZ => SYSRSTZ,
        CLK => SYSCLK,
        UART_ENBL => UART_ENBL 
    );


U1_UART_RX : UART_RX
    port map (
		SYSRSTZ	=>	SYSRSTZ	,
		CLK	=>	SYSCLK	,
		UART_ENBL	=>	UART_ENBL	,
		RRI_SYNC	=>	RRI_SYNC	,
		DR	=>	DR	,
		NTBRL_LPBK	=>	NTBRL_LPBK	,
		RBR	=>	RBR	
    );

U1_UART_HANDSHAKE : UART_HANDSHAKE
    port map    (
        TBRE 		=> TBRE,
        CLK 		=> SYSCLK,
	  	SM_RESETZ	=> SYSRSTZ,
		TX_REQ		=> TX_REQ,
		NTBRL		=> NTBRL
    );


    ---------------------------------------------------------------------------
    --                INPUT CONCURRENT SIGNAL ASSIGNMENTS                    --
    ---------------------------------------------------------------------------

    ---------------------------------------------------------------------------
    --                         CONCURRENT PROCESSES                          --
    ---------------------------------------------------------------------------

    ---------------------------------------------------------------------------
    --  Process:  uart_PROCESS  
    --  Purpose:  
    --  Inputs:  
    --  Outputs:  
    ---------------------------------------------------------------------------
  

 
    ---------------------------------------------------------------------------
    --               OUTPUT CONCURRENT SIGNAL ASSIGNMENTS                    --
    ---------------------------------------------------------------------------


end RTL;
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
--                         CONFIGURATION STATEMENT                           --
-------------------------------------------------------------------------------

configuration uart_CON of uart is
    for RTL
    
    end for;
end uart_CON;

-------------------------------------------------------------------------------


