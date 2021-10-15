-------------------------------------------------------------------------------
-- Title      : ELEC4406 LAB DAC DIGILENT INTERFACE
-- Project    : ELEC4406 LAB DEV Project
-- Summary    : VHDL source files
-------------------------------------------------------------------------------
-- File       : adc_qsys_interface_sim.vhd
-- Author     :   <antonio.cantoni@uwa.edu.au>
-- Company    : UWA (2020) 
-- Last update: 30/01/2020
-- Platform   : ModelSim EE 6.0
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Wrapper for quartus adc_qys converter. Convert one channel as defined by adc_chnl . 
-- Channel confirmation on complete in adc_chnl_out.
-- Data in adc_data.
-- adc_qsys signals also out for checking correct operation.
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- $Id$
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
-------------------------------------------------------------------------------
entity adc_qsys_interface_sim is

  port (
    rst_L      		: in  std_logic;
	 adc_init			: in  std_logic;
	 CLK        		: in std_logic;
	 adc_chnl       	: in std_logic_vector(4 downto 0); -- adc channel select
    adc_start_L  		: in std_logic ;
    adc_data       	: out std_logic_vector(11 downto 0); -- data to input port
    adc_data_busy 	: out std_logic;
	 adc_chnl_out     : out std_logic_vector(4 downto 0);   -- channel converted
	 adc_qsys_cmd_vld : out std_logic;							-- ADC_QSYS COMMAND VALID - for checking
	 adc_qsys_resp_vld : out std_logic;							-- ADC_QSYS RESPONSE VALID - for checking
	 adc_qsys_cmd_rdy : out std_logic);                   -- ADC_QSYS COMMAND READY - for checking

end adc_qsys_interface_sim;

-------------------------------------------------------------------------------

architecture bhv of adc_qsys_interface_sim is
-- for simulation
  -----------------------------------------------------------------------------
  -- Component Declarations
  -----------------------------------------------------------------------------
component sin_rom is
    port ( 
	RST_L 		: in std_logic;
	CLK 		: in std_logic;
	ARG		: in STD_LOGIC_VECTOR (7 downto 0);
	SIN_VALUE	: out STD_LOGIC_VECTOR(15 downto 0));
end component sin_rom ;

constant CONV_DELAY : STD_LOGIC_VECTOR(11 downto 0) := "000010000000";
  -----------------------------------------------------------------------------
  -- Signal Declarations
  -----------------------------------------------------------------------------
type 		DAC_SM_TYPE is (S_WAIT_DATA,S_ADC_START,S_NOT_BUSY);

signal  ADC_DATA_TEMP	: STD_LOGIC_VECTOR(11 downto 0);
signal  adc_data_busy_int  					: std_logic ;  
signal  adc_start_L_old						: std_logic ;
signal  ADC_STATE      : DAC_SM_TYPE :=S_ADC_START ;
signal  CONV_COUNT	: STD_LOGIC_VECTOR(11 downto 0) ;
signal  SIN_VALUE	: STD_LOGIC_VECTOR(15 downto 0);
signal  SIN_ARG		: STD_LOGIC_VECTOR(7 downto 0) ;
signal adc_init_int  : std_logic;
begin  -- BHV
  -----------------------------------------------------------------------------
  -- Input Concurrent Statements
  -----------------------------------------------------------------------------
adc_init_int <= not adc_init;
  -----------------------------------------------------------------------------
  -- Component Instances
  -----------------------------------------------------------------------------

SINE: sin_rom
port map ( 
	RST_L=>RST_L,
	CLK=>CLK,
	ARG=>SIN_ARG,
	SIN_VALUE=>SIN_VALUE);

  -----------------------------------------------------------------------------
  -- Concurrent Processes
  -----------------------------------------------------------------------------

ADC_PROCESS : process(CLK,RST_L,ADC_DATA_TEMP,adc_data_busy_int,CONV_COUNT,SIN_ARG)
begin
	if (RST_L = '0') then
		adc_data_busy_int<='0';
		adc_start_L_old<='0';
		ADC_STATE<=S_ADC_START;
		ADC_DATA_TEMP<=(others => '0');
		CONV_COUNT<=(others => '0');
 		SIN_ARG<=(others => '0');
	elsif CLK'event and CLK = '1' then 
	   adc_start_L_old<=adc_start_L;

     	case ADC_STATE is
		when S_ADC_START=>
				if(adc_start_L='0' and adc_start_L_old ='1' ) then

	   		if( SIN_ARG = "11111111") then
					SIN_ARG<=(others => '0');
				else
					SIN_ARG<=SIN_ARG+1;
	   		end if;

				CONV_COUNT<=(others => '0');
				ADC_STATE<=S_WAIT_DATA;
				adc_data_busy_int<='1';
				else
				ADC_STATE<=S_ADC_START;
				end if;			
		when S_WAIT_DATA  =>
				if(CONV_COUNT = CONV_DELAY) then
					ADC_DATA_TEMP<=SIN_VALUE(15 downto 4);
					ADC_STATE<=S_NOT_BUSY;
				else
					CONV_COUNT<=CONV_COUNT+1;
					ADC_STATE<=S_WAIT_DATA;
				end if;
		when S_NOT_BUSY  =>
					adc_data_busy_int<='0';
					ADC_STATE<=S_ADC_START ;
	  end  case;	
	else
		ADC_DATA_TEMP<=ADC_DATA_TEMP;
		adc_data_busy_int<=adc_data_busy_int;
		CONV_COUNT<=CONV_COUNT;
		SIN_ARG<=SIN_ARG;
   end if;
end process ADC_PROCESS;


    ---------------------------------------------------------------------------
    --               OUTPUT CONCURRENT SIGNAL ASSIGNMENTS                    --
    ---------------------------------------------------------------------------

   adc_data<=ADC_DATA_TEMP;
	adc_chnl_out <=adc_chnl;
	adc_data_busy<=(adc_data_busy_int and rst_L and adc_init_int);
	adc_qsys_cmd_vld<='0';
	adc_qsys_resp_vld<='0';
	adc_qsys_cmd_rdy <='0';

end bhv;


-------------------------------------------------------------------------------
-- Configuration Statement
-------------------------------------------------------------------------------

configuration adc_qsys_interface_sim_CON of adc_qsys_interface_sim is
  for bhv
  end for;
end adc_qsys_interface_sim_CON;
-------------------------------------------------------------------------------




