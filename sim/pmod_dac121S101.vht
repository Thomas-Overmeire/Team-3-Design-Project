-- Copyright (C) 2020  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and any partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details, at
-- https://fpgasoftware.intel.com/eula.

-- ***************************************************************************
-- This file contains a Vhdl test bench template that is freely editable to   
-- suit user's needs .Comments are provided in each section to help the user  
-- fill out necessary details.                                                
-- ***************************************************************************
-- Generated on "09/03/2021 20:04:50"
                                                            
-- Vhdl Test Bench template for design  :  pmod_dac121S101
-- 
-- Simulation tool : ModelSim (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY pmod_dac121S101_vhd_tst IS
END pmod_dac121S101_vhd_tst;

ARCHITECTURE pmod_dac121S101_arch OF pmod_dac121S101_vhd_tst IS                                                                                            
COMPONENT pmod_dac121S101
	PORT (
	busy : BUFFER STD_LOGIC;
	clk : IN STD_LOGIC;
	dac_data_a : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
	dac_data_b : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
	dac_tx_ena : IN STD_LOGIC;
	mosi_a : BUFFER STD_LOGIC;
	mosi_b : BUFFER STD_LOGIC;
	reset_n : IN STD_LOGIC;
	sclk : BUFFER STD_LOGIC;
	ss_n : BUFFER STD_LOGIC_VECTOR(0 DOWNTO 0)
	);
END COMPONENT;

SIGNAL busy : STD_LOGIC;
SIGNAL clk : STD_LOGIC;
SIGNAL dac_data_a : STD_LOGIC_VECTOR(11 DOWNTO 0) :="111111000000";
SIGNAL dac_data_b : STD_LOGIC_VECTOR(11 DOWNTO 0) :="000000111111";
SIGNAL dac_tx_ena : STD_LOGIC;
SIGNAL mosi_a : STD_LOGIC;
SIGNAL mosi_b : STD_LOGIC;
SIGNAL reset_n : STD_LOGIC;
SIGNAL sclk : STD_LOGIC;
SIGNAL ss_n : STD_LOGIC_VECTOR(0 DOWNTO 0);
CONSTANT period : TIME := 100ns;-- time period    




BEGIN

	i1 : pmod_dac121S101
	PORT MAP (
-- list connections between master ports and signals
	busy => busy,
	clk => clk,
	dac_data_a => dac_data_a,
	dac_data_b => dac_data_b,
	dac_tx_ena => dac_tx_ena,
	mosi_a => mosi_a,
	mosi_b => mosi_b,
	reset_n => reset_n,
	sclk => sclk,
	ss_n => ss_n
	);

--input_gen :process
--begin
	--dac_data_a <= "101010101010" after 100ns;
	--dac_data_b <= "010101010101" after 100ns;
--end process;

clk_gen : PROCESS 
BEGIN	
	clk <= '1';
	WAIT FOR period/2;
	clk <= '0';
	WAIT FOR period/2;
END PROCESS;


res_n : process
begin
	reset_n <= '1';
	wait for 100ns;
	reset_n <= '0';
	wait for 100ns;
	reset_n <= '1';
	wait;
end process;

dac_tx_ena_gen : PROCESS
BEGIN
	dac_tx_ena <= '0';
	wait for 100ns;
	dac_tx_ena <= '1';
	WAIT;
END PROCESS;

                                                                           
END pmod_dac121S101_arch;
