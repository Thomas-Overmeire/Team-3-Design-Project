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
-- Generated on "10/03/2021 08:51:45"
                                                            
-- Vhdl Test Bench template for design  :  MaxADC_TOP
-- 
-- Simulation tool : ModelSim-Altera (VHDL)
-- 

LIBRARY IEEE;
USE IEEE.std_logic_textio.ALL;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE ieee.numeric_std.all;
LIBRARY STD;
USE STD.textio.ALL;
LIBRARY work;
--USE work.Programmable_FIR_via_Registers_pkg.ALL;


ENTITY MaxADC_TOP_vhd_tst IS
END MaxADC_TOP_vhd_tst;
ARCHITECTURE rtl OF MaxADC_TOP_vhd_tst IS
FOR ALL : Programmable_FIR_via_Registers_adc
    USE ENTITY work.Programmable_FIR_via_Registers_adc(rtl);
-- constants                                                 
-- signals                                                   
SIGNAL clk_in : STD_LOGIC;
SIGNAL data_in : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL data_out : STD_LOGIC_VECTOR(14 DOWNTO 0);
SIGNAL rst_in_L : STD_LOGIC;
SIGNAL clk                              : std_logic;
  SIGNAL reset                            : std_logic;
  SIGNAL clk_enable                       : std_logic;
  SIGNAL filter_out_done                  : std_logic;  -- ufix1
  SIGNAL rdEnb                            : std_logic;
  SIGNAL filter_out_done_enb              : std_logic;  -- ufix1
  SIGNAL filter_out_addr                  : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL filter_out_active                : std_logic;  -- ufix1
  SIGNAL host_write_data_addr             : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL filter_input_addr_delay_1        : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL tb_enb_delay                     : std_logic;
  SIGNAL rawData_filter_in                : signed(13 DOWNTO 0);  -- sfix14_En13
  SIGNAL holdData_filter_in               : signed(13 DOWNTO 0);  -- sfix14_En13
  SIGNAL filter_in_offset                 : signed(13 DOWNTO 0);  -- sfix14_En13
  SIGNAL filter_in                        : signed(13 DOWNTO 0);  -- sfix14_En13
  SIGNAL filter_in_1                      : std_logic_vector(13 DOWNTO 0);  -- ufix14
  SIGNAL write_done_addr_delay_1          : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL rawData_write_done               : std_logic;
  SIGNAL holdData_write_done              : std_logic;
  SIGNAL write_done_offset                : std_logic;
  SIGNAL write_done                       : std_logic;
  SIGNAL write_enable_addr_delay_1        : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL rawData_write_enable             : std_logic;
  SIGNAL holdData_write_enable            : std_logic;
  SIGNAL write_enable_offset              : std_logic;
  SIGNAL write_enable                     : std_logic;
  SIGNAL check1_done                      : std_logic;  -- ufix1
  SIGNAL snkDonen                         : std_logic;
  SIGNAL resetn                           : std_logic;
  SIGNAL tb_enb                           : std_logic;
  SIGNAL ce_out                           : std_logic;
  SIGNAL filter_out                       : std_logic_vector(14 DOWNTO 0);  -- ufix15
  SIGNAL filter_out_enb                   : std_logic;  -- ufix1
  SIGNAL filter_out_lastAddr              : std_logic;  -- ufix1
  SIGNAL filter_out_signed                : signed(14 DOWNTO 0);  -- sfix15_En13
  SIGNAL filter_out_addr_delay_1          : unsigned(8 DOWNTO 0);  -- ufix9
 -- SIGNAL Host_Behavioral_Model_out3_addr_delay_1 : unsigned(8 DOWNTO 0);  -- ufix9
COMPONENT MaxADC_TOP
	PORT (
	clk_in : IN STD_LOGIC;
	data_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
	data_out : OUT STD_LOGIC_VECTOR(14 DOWNTO 0);
	rst_in_L : IN STD_LOGIC;
	clk      :   IN    std_logic;
          reset                           :   IN    std_logic;
          clk_enable                      :   IN    std_logic;
--          coeffs_in                       :   IN   std_logic_vector(13 DOWNTO 0);  -- sfix14_En13
--          write_address                   :   IN    std_logic_vector(7 DOWNTO 0);  -- uint8
          write_enable                    :   IN    std_logic;
          write_done                      :   IN    std_logic;
          filter_in                       :   IN    std_logic_vector(13 DOWNTO 0);  -- sfix14_En13
          ce_out                          :   OUT   std_logic;
          filter_out                      :   OUT   std_logic_vector(14 DOWNTO 0)  -- sfix15_En13
	);
END COMPONENT;
BEGIN
	i1 : MaxADC_TOP
	PORT MAP (
-- list connections between master ports and signals
	clk_in => clk_in,
	data_in => data_in,
	data_out => data_out,
	rst_in_L => rst_in_L,
	clk => clk,
              reset => reset,
              clk_enable => clk_enable,
--              coeffs_in => coeffs_in_1,  -- sfix14_En13
--              write_address => write_address_1,  -- uint8
              write_enable => write_enable,
              write_done => write_done,
              filter_in => filter_in_1,  -- sfix14_En13
              ce_out => ce_out,
              filter_out => filter_out  -- sfix15_En13
	);
	 filter_input_addr_delay_1 <= host_write_data_addr AFTER 1 ns;

  -- Data source for filter_in -This process reads in all lines ignoring bits 16 and 15 as they are always 0
  filter_in_fileread: PROCESS (filter_input_addr_delay_1, tb_enb_delay, rdEnb)
    FILE fp: TEXT open READ_MODE is "filter_in.dat";
    VARIABLE l: LINE;
    VARIABLE read_data: std_logic_vector(15 DOWNTO 0);

  BEGIN
    IF tb_enb_delay /= '1' THEN
    ELSIF rdEnb = '1' AND NOT ENDFILE(fp) THEN
      READLINE(fp, l);
      HREAD(l, read_data);
    END IF;
    rawData_filter_in <= signed(read_data(13 DOWNTO 0));
  END PROCESS filter_in_fileread;

  -- holdData reg for filter_input - data read in is held in a register hold register
  stimuli_filter_input_process: PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      holdData_filter_in <= (OTHERS => 'X');
    ELSIF clk'event AND clk = '1' THEN
      holdData_filter_in <= rawData_filter_in;
    END IF;
  END PROCESS stimuli_filter_input_process;
	-- for rdEnb 0 either holdData or rawData is transfered to filter_in_offset
  stimuli_filter_input_1: PROCESS (rawData_filter_in, rdEnb)
  BEGIN
    IF rdEnb = '0' THEN
      filter_in_offset <= holdData_filter_in;
    ELSE
      filter_in_offset <= rawData_filter_in;
    END IF;
  END PROCESS stimuli_filter_input_1;

  filter_in <= filter_in_offset AFTER 2 ns;

  filter_in_1 <= std_logic_vector(filter_in);
	-- prepare for the next process data source for write_done
  write_done_addr_delay_1 <= host_write_data_addr AFTER 1 ns;

  -- Data source for write_done -same process as with filter_in.dat reading, but with the write_done.dat into the write_done register 
  write_done_fileread: PROCESS (write_done_addr_delay_1, tb_enb_delay, rdEnb)
    FILE fp: TEXT open READ_MODE is "write_done.dat";
    VARIABLE l: LINE;
    VARIABLE read_data: std_logic;

  BEGIN
    IF tb_enb_delay /= '1' THEN
    ELSIF rdEnb = '1' AND NOT ENDFILE(fp) THEN
      READLINE(fp, l);
      READ(l, read_data);
    END IF;
    rawData_write_done <= read_data;
  END PROCESS write_done_fileread;

  -- holdData reg for write_done
  stimuli_write_done_process: PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      holdData_write_done <= 'X';
    ELSIF clk'event AND clk = '1' THEN
      holdData_write_done <= rawData_write_done;
    END IF;
  END PROCESS stimuli_write_done_process;

  stimuli_write_done_1: PROCESS (rawData_write_done, rdEnb)
  BEGIN
    IF rdEnb = '0' THEN
      write_done_offset <= holdData_write_done;
    ELSE
      write_done_offset <= rawData_write_done;
    END IF;
  END PROCESS stimuli_write_done_1;

  write_done <= write_done_offset AFTER 2 ns;

  write_enable_addr_delay_1 <= host_write_data_addr AFTER 1 ns;

  -- Data source for write_enable
  write_enable_fileread: PROCESS (write_enable_addr_delay_1, tb_enb_delay, rdEnb)
    FILE fp: TEXT open READ_MODE is "write_enable.dat";
    VARIABLE l: LINE;
    VARIABLE read_data: std_logic;

  BEGIN
    IF tb_enb_delay /= '1' THEN
    ELSIF rdEnb = '1' AND NOT ENDFILE(fp) THEN
      READLINE(fp, l);
      READ(l, read_data);
    END IF;
    rawData_write_enable <= read_data;
  END PROCESS write_enable_fileread;

  -- holdData reg for write_enable
  stimuli_write_enable_process: PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      holdData_write_enable <= 'X';
    ELSIF clk'event AND clk = '1' THEN
      holdData_write_enable <= rawData_write_enable;
    END IF;
  END PROCESS stimuli_write_enable_process;

  stimuli_write_enable_1: PROCESS (rawData_write_enable, rdEnb)
  BEGIN
    IF rdEnb = '0' THEN
      write_enable_offset <= holdData_write_enable;
    ELSE
      write_enable_offset <= rawData_write_enable;
    END IF;
  END PROCESS stimuli_write_enable_1;

  write_enable <= write_enable_offset AFTER 2 ns;

  --Host_Behavioral_Model_out3_addr_delay_1 <= host_write_data_addr AFTER 1 ns;
  -- Delay inside enable generation: register depth 1
  snkDonen <=  NOT check1_done;

  resetn <=  NOT reset;

  tb_enb <= resetn AND snkDonen;
  
  u_enable_delay_process: PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      tb_enb_delay <= '0';
    ELSIF clk'event AND clk = '1' THEN
      tb_enb_delay <= tb_enb;
    END IF;
  END PROCESS u_enable_delay_process;

  
  rdEnb <= tb_enb_delay WHEN check1_done = '0' ELSE
      '0';

  clk_enable <= rdEnb AFTER 2 ns;
  
  reset_gen: PROCESS 
  BEGIN
    reset <= '1';
    WAIT FOR 20 ns;
    WAIT UNTIL clk'event AND clk = '1';
    WAIT FOR 2 ns;
    reset <= '0';
    WAIT;
  END PROCESS reset_gen;

  clk_gen: PROCESS 
  BEGIN
    clk <= '1';

    WAIT FOR 5 ns;
    clk <= '0';

    WAIT FOR 5 ns;
    IF check1_done = '1' THEN
      clk <= '1';

      WAIT FOR 5 ns;
      clk <= '0';

      WAIT FOR 5 ns;
      WAIT;
    END IF;
  END PROCESS clk_gen;
  
--  fir_select: PROCESS
--  fir_select="00";
--  end process fir_select;

  filter_out_enb <= ce_out AND filter_out_active;

  -- Count limited, Unsigned Counter
  --  initial value   = 0
  --  step value      = 1
  --  count to value  = 500
  c_3_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      filter_out_addr <= to_unsigned(16#000#, 9);
    ELSIF clk'EVENT AND clk = '1' THEN
      IF filter_out_enb = '1' THEN
        IF filter_out_addr >= to_unsigned(16#1F4#, 9) THEN 
          filter_out_addr <= to_unsigned(16#000#, 9);
        ELSE 
          filter_out_addr <= filter_out_addr + to_unsigned(16#001#, 9);
        END IF;
      END IF;
    END IF;
  END PROCESS c_3_process;


  
  filter_out_lastAddr <= '1' WHEN filter_out_addr >= to_unsigned(16#1F4#, 9) ELSE
      '0';

  filter_out_done <= filter_out_lastAddr AND resetn;

  -- Delay to allow last sim cycle to complete
  checkDone_1_process: PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      check1_done <= '0';
    ELSIF clk'event AND clk = '1' THEN
      IF filter_out_done_enb = '1' THEN
        check1_done <= filter_out_done;
      END IF;
    END IF;
  END PROCESS checkDone_1_process;

  filter_out_signed <= signed(filter_out);

  filter_out_addr_delay_1 <= filter_out_addr AFTER 1 ns;
--u_fir_select : PROCESS                                               
---- variable declarations                                     
--BEGIN                                                        
--        fir_select="00";                      
--WAIT;                                                       
--END PROCESS u_fir_select;                                           
--always : PROCESS 
--                                             
---- optional sensitivity list                                  
---- (        )                                                 
---- variable declarations                                      
--BEGIN                                                         
--        -- code executes for every event on sensitivity list  
--WAIT;                                                        
--END PROCESS always;                                          
END rtl;
