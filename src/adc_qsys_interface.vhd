-------------------------------------------------------------------------------
-- Title      : ELEC4406 LAB DAC DIGILENT INTERFACE
-- Project    : ELEC4406 LAB DEV Project
-- Summary    : VHDL source files
-------------------------------------------------------------------------------
-- File       : adc_qsys_interface.vhd
-- Author     : <antonio.cantoni@uwa.edu.au>
-- Company    : UWA (2020) 
-- Last update: 30/01/2020
-- Platform   : ModelSim EE 6.0
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Wrapper for quartus adc_qys converter. Convert one channel as defined by adc_chnl . 
-- Channel confirmation on complete in adc_chnl_out.
-- Data in adc_data.
-- adc_qsys signals also out for checking correct operation.
--
-- Wrapped ADC has  the following timing
--
--					              ---------       ------------------------------             
--                                           xxxxxxxxxxxxxxxxxxxxxxxxxx
-- adc_start_L                        ---------------------------------     ---------------------
--
--                                    START ON DOWN EDGE of adc_start_L
--
--				                             -------------------------
--
-- adc_start_data_busy ------------------                         ------------------
--					             
--
-- adc_data   DiDiDiDiDiDiDiDiDiDiDiDiDiXXXXXXXXXXXXXXXXXXXXXXXXXD2D2D2D2D2D2D2D2D2D2
--
--
-- $Id$
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

-------------------------------------------------------------------------------
entity adc_qsys_interface is

  port (
    rst_L      		: in  std_logic;
	 adc_init      		: in  std_logic;
	 CLK        		: in std_logic;	
	 adc_chnl       	: in std_logic_vector(4 downto 0); -- adc channel select
    adc_start_L  		: in std_logic ;
    adc_data       	: out std_logic_vector(11 downto 0); -- data to input port
    adc_data_busy 	: out std_logic;
	 adc_chnl_out     : out std_logic_vector(4 downto 0);   -- channel converted
	 adc_qsys_cmd_vld : out std_logic;							-- ADC_QSYS COMMAND VALID - for checking
	 adc_qsys_resp_vld : out std_logic;							-- ADC_QSYS RESPONSE VALID - for checking
	 adc_qsys_cmd_rdy : out std_logic);                   -- ADC_QSYS COMMAND READY - for checking

end adc_qsys_interface;


-------------------------------------------------------------------------------

architecture bhv of adc_qsys_interface is

  -----------------------------------------------------------------------------
  -- Component Declarations
  -----------------------------------------------------------------------------
component adc_qsys is
		port (
			clk_clk                              : in  std_logic                     := 'X';             -- clk
			clock_bridge_sys_out_clk_clk         : out std_logic;                                        -- clk
			modular_adc_0_command_valid          : in  std_logic                     := 'X';             -- valid
			modular_adc_0_command_channel        : in  std_logic_vector(4 downto 0)  := (others => 'X'); -- channel
			modular_adc_0_command_startofpacket  : in  std_logic                     := 'X';             -- startofpacket
			modular_adc_0_command_endofpacket    : in  std_logic                     := 'X';             -- endofpacket
			modular_adc_0_command_ready          : out std_logic;                                        -- ready
			modular_adc_0_response_valid         : out std_logic;                                        -- valid
			modular_adc_0_response_channel       : out std_logic_vector(4 downto 0);                     -- channel
			modular_adc_0_response_data          : out std_logic_vector(11 downto 0);                    -- data
			modular_adc_0_response_startofpacket : out std_logic;                                        -- startofpacket
			modular_adc_0_response_endofpacket   : out std_logic;                                        -- endofpacket
			reset_reset_n                        : in  std_logic                     := 'X'              -- reset_n
		);
end component adc_qsys;

  -----------------------------------------------------------------------------
  -- Signal Declarations
  -----------------------------------------------------------------------------
type 		DAC_SM_TYPE is (S_WAIT_COMND_DONE,S_WAIT_DATA,S_ADC_START,S_NOT_BUSY);

signal  ADC_DATA_TEMP	: STD_LOGIC_VECTOR(11 downto 0);
signal  ADC_CHAN_CONV	: STD_LOGIC_VECTOR(4 downto 0);
signal BRIDGE_CLK 							: std_logic ; 
signal ADC_0_command_valid 				: std_logic ;     
signal ADC_0_command_channel 				: std_logic_vector(4 downto 0) ;                        
signal ADC_0_command_startofpacket 		: std_logic ;                        
signal ADC_0_command_endofpacket 		: std_logic ;                          
signal ADC_0_command_ready 				: std_logic ;                         
signal ADC_0_response_valid 				: std_logic ;    
signal ADC_0_response_channel 			: std_logic_vector(4 downto 0);                          
signal ADC_0_response_data 				: std_logic_vector(11 downto 0);                           
signal ADC_0_response_startofpacket 	: std_logic ;                         
signal ADC_0_response_endofpacket 		: std_logic ; 
signal adc_data_busy_int  					: std_logic ;  
signal adc_start_L_old						: std_logic ;
signal adc_chnl_int							: std_logic_vector(4 downto 0) ;

signal   ADC_STATE       	 : DAC_SM_TYPE :=S_ADC_START ;
signal adc_init_int  : std_logic;
begin  -- RTL
  -----------------------------------------------------------------------------
  -- Input Concurrent Statements
  -----------------------------------------------------------------------------
adc_init_int<= '1';
  -----------------------------------------------------------------------------
  -- Component Instances
  -----------------------------------------------------------------------------

ADC_INPUT: component adc_qsys
port map (
	clk_clk                              => CLK,                              --                      
	clock_bridge_sys_out_clk_clk         => BRIDGE_CLK,         -- 
	modular_adc_0_command_valid          => ADC_0_command_valid,          --    
	modular_adc_0_command_channel        => ADC_0_command_channel,        --                         
	modular_adc_0_command_startofpacket  => ADC_0_command_startofpacket,  --                         
	modular_adc_0_command_endofpacket    => ADC_0_command_endofpacket,    --                         
	modular_adc_0_command_ready          => ADC_0_command_ready,          --                         
	modular_adc_0_response_valid         => ADC_0_response_valid,         --   
	modular_adc_0_response_channel       => ADC_0_response_channel,       --                         
	modular_adc_0_response_data          => ADC_0_response_data,          --                         
	modular_adc_0_response_startofpacket => ADC_0_response_startofpacket, --                         
	modular_adc_0_response_endofpacket   => ADC_0_response_endofpacket,   --                         
	reset_reset_n                        => RST_L                         --                    
		);

  -----------------------------------------------------------------------------
  -- Concurrent Processes
  -----------------------------------------------------------------------------

ADC_PROCESS : process(CLK,RST_L,ADC_DATA_TEMP,adc_data_busy_int,adc_chnl_int)
begin
	if (RST_L = '0') then
		adc_data_busy_int<='0';
		adc_start_L_old<='0';
		ADC_STATE<=S_ADC_START;
		ADC_0_command_valid <='0';
		ADC_DATA_TEMP<=(others => '0');
		adc_chnl_int<=(others => '0');
	elsif CLK'event and CLK = '1' then 
	   --adc_start_L_old<=adc_start_L;
		adc_start_L_old<='1';
		--adc_init_int<='1';
     	case ADC_STATE is
		when S_ADC_START=>
				if(adc_start_L='0' and adc_start_L_old ='1' and adc_init_int='1') then
				ADC_STATE<=S_WAIT_COMND_DONE;
				adc_chnl_int<=adc_chnl;
				adc_data_busy_int<='1';
				ADC_0_command_valid <='1';
				else
				ADC_STATE<=S_ADC_START;
				end if;			
	  	 when S_WAIT_COMND_DONE  =>
				if(ADC_0_command_ready = '1') then
				ADC_STATE<=S_WAIT_DATA;
				ADC_0_command_valid <='0';
				else
				ADC_STATE<=S_WAIT_COMND_DONE;
				end if;
		when S_WAIT_DATA  =>
				if(ADC_0_response_valid = '1') then
				ADC_DATA_TEMP<=ADC_0_response_data;
				ADC_CHAN_CONV<=ADC_0_response_channel;
				adc_data_busy_int<='0';
				ADC_STATE<=S_NOT_BUSY ;
				else
				ADC_STATE<=S_WAIT_DATA;
				end if;
		when S_NOT_BUSY  =>
				adc_data_busy_int<='0';
				ADC_STATE<=S_ADC_START ;
	end case;	
	else
		ADC_DATA_TEMP<=ADC_DATA_TEMP;
		adc_data_busy_int<=adc_data_busy_int;
		adc_chnl_int<=adc_chnl_int;
    end if;
end process ADC_PROCESS;


    ---------------------------------------------------------------------------
    --               OUTPUT CONCURRENT SIGNAL ASSIGNMENTS                    --
    ---------------------------------------------------------------------------
	ADC_0_command_startofpacket<='1';
	ADC_0_command_endofpacket<='1';
	ADC_0_command_channel<= adc_chnl_int;
   adc_data<=ADC_DATA_TEMP;
	adc_chnl_out <=ADC_CHAN_CONV;
	adc_data_busy<=adc_data_busy_int;
	adc_qsys_cmd_vld<=ADC_0_command_valid;
	adc_qsys_resp_vld<=ADC_0_response_valid;
	adc_qsys_cmd_rdy <=ADC_0_command_ready;


end bhv;




