-------------------------------------------------------------------------------
-- Title      : 
-- Project    : 
-------------------------------------------------------------------------------
-- File       : in_module.vhd
-- Author     : Antonio cantoni
-- Company    : 
-- Last update: 
-- Platform   : 
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity  in_module is
  port (
  	rst_L      				: in  std_logic;
	adc_init    			: in  std_logic;
	CLK        				: in  std_logic;
	internalSource		   : in  std_logic;
	adc_chnl       		: in std_logic_vector(4 downto 0); -- adc channel select
 	adc_start	  			: in std_logic ;
	adc_data       		: out std_logic_vector(11 downto 0); -- data to input port
	adc_chnl_out     		: out std_logic_vector(4 downto 0);
	adc_data_busy 			: out std_logic;
	adc_qsys_cmd_vld 		: out std_logic;
	adc_qsys_resp_vld 	: out std_logic;
	adc_qsys_cmd_rdy 		: out std_logic
);
  
end in_module;

architecture bhv of in_module is
    ---------------------------------------------------------------------------
    --                 CONSTANT, TYPE AND GENERIC DEFINITIONS                --
    ---------------------------------------------------------------------------

  
    ---------------------------------------------------------------------------
    --                          SIGNAL DECLARATIONS                          --
    ---------------------------------------------------------------------------
signal   adc_qsys_data_busy 		: std_logic;
signal	adc_qsys_data      		: std_logic_vector(11 downto 0);
signal   adc_start_L					: std_logic;

signal   adc_data_sim_busy      	: std_logic;
signal	adc_data_sim       		: std_logic_vector(11 downto 0);

signal   adc_qsys_sim_cmd_vld  	: std_logic;
signal   adc_qsys_sim_resp_vld 	: std_logic;
signal   adc_qsys_sim_cmd_rdy  	: std_logic;

signal   ADC_CHAN_CONV	: STD_LOGIC_VECTOR(4 downto 0);
signal   ADC_CHAN_CONV_SIM : STD_LOGIC_VECTOR(4 downto 0);
  -----------------------------------------------------------------------------
  -- 										Component Declarations
  -----------------------------------------------------------------------------

--component adc_qsys_interface_sim is
--
--  port (
--	rst_L      		: in  std_logic;
--	adc_init    : in  std_logic;
--	CLK        		: in  std_logic;
--	adc_chnl       		: in std_logic_vector(4 downto 0); -- adc channel select
-- 	adc_start_L  		: in std_logic ;
--	adc_data       		: out std_logic_vector(11 downto 0); -- data to input port
--	adc_chnl_out     	: out std_logic_vector(4 downto 0);
--	adc_data_busy 		: out std_logic;
--	adc_qsys_cmd_vld 	: out std_logic;
--	adc_qsys_resp_vld 	: out std_logic;
--	adc_qsys_cmd_rdy 	: out std_logic);                    -- data ready signal to input port
--end component adc_qsys_interface_sim;

component adc_qsys_interface is

  port (
	rst_L      				: in  std_logic;
	adc_init    : in  std_logic;
	CLK        				: in  std_logic;
	adc_chnl       		: in std_logic_vector(4 downto 0); -- adc channel select
 	adc_start_L  			: in std_logic ;
	adc_data       		: out std_logic_vector(11 downto 0); -- data to input port
	adc_chnl_out     	: out std_logic_vector(4 downto 0);
	adc_data_busy 		: out std_logic;
	adc_qsys_cmd_vld 	: out std_logic;
	adc_qsys_resp_vld 	: out std_logic;
	adc_qsys_cmd_rdy 	: out std_logic);                    -- data ready signal to input port
end component adc_qsys_interface;

      


begin
    ---------------------------------------------------------------------------
    --                    INSTANTIATE COMPONENTS                             --
    ---------------------------------------------------------------------------


adc_start_L<= '0';
    
ADC_INPUT: adc_qsys_interface
port map (
   rst_L      		=> rst_L,
	adc_init   =>adc_init,
	CLK        		=> clk,
	adc_chnl 		=> adc_chnl,
   adc_start_L  		=> adc_start_L,
	adc_data       		=> adc_qsys_data,
	adc_chnl_out		=> ADC_CHAN_CONV,
   adc_data_busy 		=> adc_qsys_data_busy,
	adc_qsys_cmd_vld 	=> adc_qsys_cmd_vld,
	adc_qsys_resp_vld	=> adc_qsys_resp_vld,
	adc_qsys_cmd_rdy 	=> adc_qsys_cmd_rdy);    

--ADC_INPUT_SIM: adc_qsys_interface_sim
--port map (
--   rst_L      			=> rst_L,
--	adc_init   			=>adc_init,
--	CLK        			=> clk,
--	adc_chnl 		=> adc_chnl,
--	adc_start_L  		=> adc_start_L,
--	adc_data       		=> adc_data_sim,
--	adc_chnl_out		=> ADC_CHAN_CONV_SIM,
--   adc_data_busy 		=> adc_data_sim_busy,
--	adc_qsys_cmd_vld 	=> adc_qsys_sim_cmd_vld,
--	adc_qsys_resp_vld	=> adc_qsys_sim_resp_vld,
--	adc_qsys_cmd_rdy 	=> adc_qsys_sim_cmd_rdy);   

    ---------------------------------------------------------------------------
    --                INPUT CONCURRENT SIGNAL ASSIGNMENTS                    --
    ---------------------------------------------------------------------------
--adc_data <= adc_qsys_data;
--adc_data_busy <= adc_qsys_data_busy;
--adc_chnl_out <= ADC_CHAN_CONV;

  with internalSource select
    adc_data <= adc_qsys_data when '0',
                adc_data_sim when others;

  with internalSource select
    adc_data_busy <= adc_qsys_data_busy when '0',
                adc_data_sim_busy when others;
					 
  with internalSource select
    adc_chnl_out <= ADC_CHAN_CONV when '0',
                ADC_CHAN_CONV_SIM when others;
	
	 ---------------------------------------------------------------------------
    --                         CONCURRENT PROCESSES                          --
    ---------------------------------------------------------------------------


end bhv;

-------------------------------------------------------------------------------
-- Configuration Statement
-------------------------------------------------------------------------------

configuration in_module_CON of in_module is
  for bhv
  end for;
end in_module_CON;
-------------------------------------------------------------------------------
