-- Copyright (C) 2018  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details.

-- ***************************************************************************
-- This file contains a Vhdl test bench template that is freely editable to   
-- suit user's needs .Comments are provided in each section to help the user  
-- fill out necessary details.                                                
-- ***************************************************************************
-- Generated on "09/26/2021 11:31:03"
                                                            
-- Vhdl Test Bench template for design  :  ADC
-- 
-- Simulation tool : ModelSim-Altera (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY ADC_vhd_tst IS
END ADC_vhd_tst;
ARCHITECTURE ADC_arch OF ADC_vhd_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL clk_clk : STD_LOGIC;
SIGNAL cmd_ready : STD_LOGIC;
SIGNAL dout : STD_LOGIC_VECTOR(11 DOWNTO 0);
SIGNAL reg_data_out : STD_LOGIC_VECTOR(11 DOWNTO 0);
SIGNAL reset_reset_n : STD_LOGIC;
SIGNAL rsp_eop : STD_LOGIC;
SIGNAL rsp_sop : STD_LOGIC;
SIGNAL rsp_valid : STD_LOGIC;
COMPONENT ADC
	PORT (
	clk_clk : IN STD_LOGIC;
	cmd_ready : BUFFER STD_LOGIC;
	dout : BUFFER STD_LOGIC_VECTOR(11 DOWNTO 0);
	reg_data_out : BUFFER STD_LOGIC_VECTOR(11 DOWNTO 0);
	reset_reset_n : IN STD_LOGIC;
	rsp_eop : BUFFER STD_LOGIC;
	rsp_sop : BUFFER STD_LOGIC;
	rsp_valid : BUFFER STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : ADC
	PORT MAP (
-- list connections between master ports and signals
	clk_clk => clk_clk,
	cmd_ready => cmd_ready,
	dout => dout,
	reg_data_out => reg_data_out,
	reset_reset_n => reset_reset_n,
	rsp_eop => rsp_eop,
	rsp_sop => rsp_sop,
	rsp_valid => rsp_valid
	);
init : PROCESS                                               
-- variable declarations                                     
BEGIN                                                        
        -- code that executes only once                      
WAIT;                                                       
END PROCESS init;                                           
always : PROCESS                                              
-- optional sensitivity list                                  
-- (        )                                                 
-- variable declarations                                      
BEGIN                                                         
        -- code executes for every event on sensitivity list  
WAIT;                                                        
END PROCESS always;                                          
END ADC_arch;
