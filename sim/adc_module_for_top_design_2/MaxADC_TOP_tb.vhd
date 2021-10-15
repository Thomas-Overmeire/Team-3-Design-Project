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
LIBRARY STD;
USE STD.textio.ALL;
LIBRARY work;
USE work.Programmable_FIR_via_Registers_pkg_adc.ALL;
USE work.Programmable_FIR_via_Registers_tb_pkg_adc.ALL;

ENTITY MaxADC_TOP_tb IS
END MaxADC_TOP_tb;
ARCHITECTURE rtl OF MaxADC_TOP_tb IS
--FOR ALL : Programmable_FIR_via_Registers_adc
--    USE ENTITY work.Programmable_FIR_via_Registers_adc(rtl);
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
  SIGNAL Host_Behavioral_Model_out3_addr_delay_1 : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL rawData_write_address            : unsigned(7 DOWNTO 0);  -- uint8
--  SIGNAL rawData_write_address_1            : unsigned(7 DOWNTO 0); 
SIGNAL rawData_write_address_1            : std_logic_vector(7 DOWNTO 0);
  SIGNAL holdData_write_address           : unsigned(7 DOWNTO 0);  -- uint8
 -- SIGNAL holdData_write_address_1           : unsigned(7 DOWNTO 0);
   SIGNAL holdData_write_address_1           : std_logic_vector(7 DOWNTO 0);
  SIGNAL write_address_offset             : unsigned(7 DOWNTO 0);  -- uint8
--   SIGNAL write_address_offset_1             : unsigned(7 DOWNTO 0);
	SIGNAL write_address_offset_1             : std_logic_vector(7 DOWNTO 0);
  SIGNAL write_address                    : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL write_address_1                  : std_logic_vector(7 DOWNTO 0);  -- ufix8
  signal write_address_2                  : std_logic_vector(7 DOWNTO 0);
  SIGNAL host_write_data_active           : std_logic;  -- ufix1
  SIGNAL host_write_data_enb              : std_logic;  -- ufix1
  SIGNAL host_write_data_addr_delay_1     : unsigned(8 DOWNTO 0);  -- ufix9
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
  signal counter				:std_logic_vector(2 downto 0);
	signal coeffs				:std_logic_vector(97 downto 0); 
	signal hold					:std_logic;
 -- SIGNAL Host_Behavioral_Model_out3_addr_delay_1 : unsigned(8 DOWNTO 0);  -- ufix9
 --SIGNAL coeffs_single_out_monitor         : std_logic_vector(13 downto 0);
 signal sop                                       					: std_logic;
signal rst								                              : std_logic;
signal firselect								                        : std_logic_vector(1 DOWNTO 0);
--signal write_address								                     : std_logic_vector(7 DOWNTO 0);
signal coeffs_in_gen																: std_logic_vector(13 DOWNTO 0);
--signals for Coeff Shadow Register
SIGNAL enb_3                              : std_logic;
  SIGNAL Write_Done_1                     : std_logic;
  SIGNAL coeffs_registers_out1            : vector_of_std_logic_vector14(0 TO 6);  -- ufix14 [7]
  SIGNAL coeffs_registers_out1_signed     : vector_of_signed14(0 TO 6);  -- sfix14_En13 [7]
  SIGNAL coeffs_shadow                    : vector_of_signed14(0 TO 6);  -- sfix14_En13 [7]
  SIGNAL coeffs_shadow_1                  : vector_of_std_logic_vector14(0 TO 6);  -- ufix14 [7]
  SIGNAL Filter_Out_1                     : std_logic_vector(14 DOWNTO 0);  -- ufix15
  -- Signals for coeffs_register vector of signed14 
  SIGNAL coeffs_in_signed                 : signed(13 DOWNTO 0);  -- sfix14_En13
  SIGNAL write_address_unsigned           : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL coeffs_regs                      : vector_of_signed14(0 TO 6);  -- sfix14_En13 [7]
  SIGNAL coeffs_assigned                  : vector_of_signed14(0 TO 6);  -- sfix14_En13 [7]
  signal coeffs_out_1                     : vector_of_std_logic_vector14(0 TO 6);



COMPONENT MaxADC_TOP
	PORT (
	clk_in : IN STD_LOGIC;
	data_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
	data_out : OUT STD_LOGIC_VECTOR(14 DOWNTO 0);
	rst_in_L : IN STD_LOGIC;
	clk      :   IN    std_logic;
          reset                           :   IN    std_logic;
          clk_enable                      :   IN    std_logic;
          coeffs_in                       :   IN   std_logic_vector(13 DOWNTO 0);  -- sfix14_En13
          write_address                   :   IN    std_logic_vector(7 DOWNTO 0);  -- uint8
          write_enable                    :   IN    std_logic;
          write_done                      :   IN    std_logic;
          filter_in                       :   IN    std_logic_vector(13 DOWNTO 0);  -- sfix14_En13
          ce_out                          :   OUT   std_logic;
          filter_out                      :   OUT   std_logic_vector(14 DOWNTO 0);  -- sfix15_En13
--			 coeffs_single_out                 :   OUT   std_logic_vector(13 DOWNTO 0)  -- sfix14_En13 [7]
-- coeffs_out                      :   OUT   vector_of_std_logic_vector14(0 TO 6);
		  Discrete_FIR_Filter_in          :   IN    std_logic_vector(13 DOWNTO 0);  -- sfix14_En13
        Discrete_FIR_Filter_coeff       :   IN    vector_of_std_logic_vector14(0 TO 6);  -- sfix14_En13 [7]
        Discrete_FIR_Filter_out         :   OUT   std_logic_vector(14 DOWNTO 0);  -- sfix15_En13
		  enb                               :   IN    std_logic
	);

END COMPONENT;
--component generator is
--  PORT( clk                               :   IN    std_logic;
--        reset                             :   IN    std_logic;
--        firselect                         :   buffer    std_logic_vector(1 DOWNTO 0);  -- sfix14_En13
--        enb                               :   IN    std_logic;
--        write_address_gen                     :   OUT   std_logic_vector(7 DOWNTO 0);  -- uint8
----      write_enable                      :   OUT   std_logic;
--        coeffs_single_out                 :   OUT   std_logic_vector(13 DOWNTO 0)   -- sfix14_En13 [7]
--        );
--end  component generator;

--FOR ALL : generator
--    USE ENTITY work.generator(rtl);
FOR ALL : MaxADC_TOP
		USE ENTITY work.MaxADC_TOP(bhv);
BEGIN
	u_MAXADC_TOP : MaxADC_TOP
	PORT MAP (
-- list connections between master ports and signals
	clk_in => clk_in,
	data_in => data_in,
	data_out => data_out,
	rst_in_L => rst_in_L,
	clk => clk,
              reset => reset,
              clk_enable => clk_enable,
              coeffs_in => coeffs_in_gen,  -- sfix14_En13
              write_address => write_address_2,  -- uint8
--				  write_address => write_address_offset_1,
              write_enable => write_enable,
              write_done => write_done,
              filter_in => filter_in_1,  -- sfix14_En13
              ce_out => ce_out,
              filter_out => filter_out,  -- sfix15_En13
--				  coeffs_single_out  => coeffs_in_gen 
--        coeffs_out => coeffs__out_1,
			enb => clk_enable,
         Discrete_FIR_Filter_in => filter_in_1,  -- sfix14_En13
         Discrete_FIR_Filter_coeff => coeffs_shadow_1,  -- sfix14_En13 [7]
         Discrete_FIR_Filter_out => Filter_Out_1                     
	);
--	ce_out_2<= clk_enable;
--	generator_connection : component generator
--		port map (
--	      clk                               => clk, 
--			reset                             => rst, 
--			firselect                         => firselect, 
--			enb                               => sop, 
--			write_address_gen                     => write_address_2,
----		   write_address  						 => write_address_offset_1,	
----      	write_enable                      => sop, 
--			coeffs_single_out                 => coeffs_in_gen
--		);
coeffs_assign_process: PROCESS (clk) 
BEGIN
IF clk'EVENT AND clk = '1' THEN
	coeffs	 <=	"00000101100111111101111011101101101111101001001100010000110110111110101111011110111000000101100111"; --when firselect = "00" else		--HP
--						"11111011000010000011100011000100100000000001101100010010010010000000000000111000110011111011000010" when firselect = "01" else		--LP
--						"11100001101101110011111010110001110101100101100001010010000111010110011100111110101111100001101101" when firselect = "10" else		--BP
--						"00010110001111001010001111011110100111101001110011000101111010011110100010100011110100010110001111" when firselect = "11" else		--BS
--						"00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
--		firselect_signal <= "00";
--
END IF;
END PROCESS coeffs_assign_process;
  coeffs_generate_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
		counter	<= "000";
    ELSIF clk'EVENT AND clk = '1' THEN
      IF rdEnb = '1' THEN
			IF counter = "111" THEN
				coeffs_in_gen <= coeffs(13 DOWNTO 0);
				rawData_write_address_1	<=	"00000" & counter;
--				firselect<=firselect_signal;
				counter <= "000";
			ELSE	
				CASE counter IS
					when "000"	=> coeffs_in_gen  <= coeffs(97 DOWNTO 84);
--					when "000"	=> coeffs_in_gen  <= "10110011100011";
					when "001"	=> coeffs_in_gen  <= coeffs(83 DOWNTO 70);
					when "010"	=> coeffs_in_gen  <= coeffs(69 DOWNTO 56);
					when "011"	=> coeffs_in_gen  <= coeffs(55 DOWNTO 42);
					when "100"	=> coeffs_in_gen  <= coeffs(41 DOWNTO 28);
					when "101"	=> coeffs_in_gen <= coeffs(27 DOWNTO 14);
					when "110"	=> coeffs_in_gen  <= coeffs(13 DOWNTO 0);
					when others =>	coeffs_in_gen  <= "00000000000000";
				END CASE;
				rawData_write_address_1	<=	"00000" & counter;
				counter <= std_logic_vector( unsigned(counter) + 1 );
--				coeffs_single_out
--				counter <= counter +'1';
	
			END IF;
      END IF;
    END IF;
  END PROCESS coeffs_generate_process;
  -- holdData reg for generator write address
  stimuli_generator_write_address_process: PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      holdData_write_address_1 <= (OTHERS => 'X');
    ELSIF clk'event AND clk = '1' THEN
      holdData_write_address_1 <= rawData_write_address_1;
    END IF;
  END PROCESS stimuli_generator_write_address_process;

  stimuli_generator_write_address_process_out3_1: PROCESS (holdData_write_address_1,rawData_write_address_1, rdEnb)
  BEGIN
    IF rdEnb = '0' THEN
      write_address_offset_1 <= holdData_write_address_1;
    ELSE
      write_address_offset_1 <= rawData_write_address_1;
    END IF;
	 
  END PROCESS stimuli_generator_write_address_process_out3_1;
  
  write_address_offset_to_write_address_2_process: PROCESS (clk,write_address_2,write_address_offset_1)
  BEGIN
  IF clk'event AND clk = '1' THEN
--  wait for 1 ns;
  write_address_2 <= write_address_offset_1;
  END IF;
  END PROCESS write_address_offset_to_write_address_2_process;
  -- coeff register process 
  coeffs_in_signed <= signed(coeffs_in_gen);

  write_address_unsigned <= unsigned(write_address_2);

  
  coeffs_assigned(0) <= coeffs_in_signed WHEN write_address_unsigned = to_unsigned(16#00#, 8) ELSE
      coeffs_regs(0);
  
  coeffs_assigned(1) <= coeffs_in_signed WHEN write_address_unsigned = to_unsigned(16#01#, 8) ELSE
      coeffs_regs(1);
  
  coeffs_assigned(2) <= coeffs_in_signed WHEN write_address_unsigned = to_unsigned(16#02#, 8) ELSE
      coeffs_regs(2);
  
  coeffs_assigned(3) <= coeffs_in_signed WHEN write_address_unsigned = to_unsigned(16#03#, 8) ELSE
      coeffs_regs(3);
  
  coeffs_assigned(4) <= coeffs_in_signed WHEN write_address_unsigned = to_unsigned(16#04#, 8) ELSE
      coeffs_regs(4);
  
  coeffs_assigned(5) <= coeffs_in_signed WHEN write_address_unsigned = to_unsigned(16#05#, 8) ELSE
      coeffs_regs(5);
  
  coeffs_assigned(6) <= coeffs_in_signed WHEN write_address_unsigned = to_unsigned(16#06#, 8) ELSE
      coeffs_regs(6);
		
	coeffs_regs_1_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      coeffs_regs <= (OTHERS => to_signed(16#0000#, 14));
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb_3 = '1' AND write_enable = '1' THEN
        coeffs_regs <= coeffs_assigned;
      END IF;
    END IF;
  END PROCESS coeffs_regs_1_process;


  outputgen: FOR k IN 0 TO 6 GENERATE
    coeffs_out_1(k) <= std_logic_vector(coeffs_regs(k));
  END GENERATE;
  coeffs_registers_out1<=coeffs_out_1;
  --Process for Shadow Register Generation
  Write_Done_1 <= write_done;

  outputgen1: FOR k IN 0 TO 6 GENERATE
    coeffs_registers_out1_signed(k) <= signed(coeffs_registers_out1(k));
  END GENERATE;

  enb_3 <= clk_enable;

  shadow_regs_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      coeffs_shadow <= (OTHERS => to_signed(16#0000#, 14));
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb_3 = '1' AND Write_Done_1 = '1' THEN
        coeffs_shadow <= coeffs_registers_out1_signed;
      END IF;
    END IF;
  END PROCESS shadow_regs_process;


  outputgen_2: FOR k IN 0 TO 6 GENERATE
    coeffs_shadow_1(k) <= std_logic_vector(coeffs_shadow(k));
  END GENERATE;
  
  ce_out <= clk_enable;

  filter_out <= Filter_Out_1;
	-- data address is writen when host_write_data_active flag is one and when the address is not equivalent to to_unsigned(16#1F4#, 9) in which case it terminates the process 
  
--  host_write_data_active <= '1' WHEN host_write_data_addr /= to_unsigned(16#1F4#, 9) ELSE
--      '0';
--
--  host_write_data_enb <= host_write_data_active AND (rdEnb AND tb_enb_delay);

	filter_out_done_enb <= filter_out_done AND rdEnb;

  
  filter_out_active <= '1' WHEN filter_out_addr /= to_unsigned(16#1F4#, 9) ELSE
      '0';
		
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
  write_done_addr_delay_1 <= host_write_data_addr; --AFTER 1 ns; *****

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

  write_done <= write_done_offset; --AFTER 2 ns; *****

  write_enable_addr_delay_1 <= host_write_data_addr; --AFTER 1 ns; *****

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
  
  Host_Behavioral_Model_out3_addr_delay_1 <= host_write_data_addr AFTER 1 ns;

  -- Data source for write_address
  write_address_fileread: PROCESS (Host_Behavioral_Model_out3_addr_delay_1, tb_enb_delay, rdEnb)
    FILE fp: TEXT open READ_MODE is "write_address.dat";
    VARIABLE l: LINE;
    VARIABLE read_data: std_logic_vector(7 DOWNTO 0);

  BEGIN
    IF tb_enb_delay /= '1' THEN
    ELSIF rdEnb = '1' AND NOT ENDFILE(fp) THEN
      READLINE(fp, l);
      HREAD(l, read_data);
    END IF;
    rawData_write_address <= unsigned(read_data(7 DOWNTO 0));
  END PROCESS write_address_fileread;
 
 -- holdData reg for Host_Behavioral_Model_out3
  stimuli_Host_Behavioral_Model_out3_process: PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      holdData_write_address <= (OTHERS => 'X');
    ELSIF clk'event AND clk = '1' THEN
      holdData_write_address <= rawData_write_address;
    END IF;
  END PROCESS stimuli_Host_Behavioral_Model_out3_process;

  stimuli_Host_Behavioral_Model_out3_1: PROCESS (rawData_write_address, rdEnb)
  BEGIN
    IF rdEnb = '0' THEN
      write_address_offset <= holdData_write_address;
    ELSE
      write_address_offset <= rawData_write_address;
    END IF;
  END PROCESS stimuli_Host_Behavioral_Model_out3_1;

  write_address <= write_address_offset AFTER 2 ns;
  
--  ce_out <= clk_enable;
  
  write_address_1 <= std_logic_vector(write_address);
	-- data address is writen when host_write_data_active flag is one and when the address is not equivalent to to_unsigned(16#1F4#, 9) in which case it terminates the process 
  
  host_write_data_active <= '1' WHEN host_write_data_addr /= to_unsigned(16#1F4#, 9) ELSE
      '0';

  host_write_data_enb <= host_write_data_active AND (rdEnb AND tb_enb_delay);

  -- Count limited, Unsigned Counter
  --  initial value   = 0
  --  step value      = 1
  --  count to value  = 500
  HostBehavioralModel_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN			--set write address to 000
      host_write_data_addr <= to_unsigned(16#000#, 9);
    ELSIF clk'EVENT AND clk = '1' THEN
      IF host_write_data_enb = '1' THEN			-- incremement address and check to see if we are at the end of the memory to_unsigned(16#1F4#, 9) as 1F4# is 500 decimal (for 500 count to value)
        IF host_write_data_addr >= to_unsigned(16#1F4#, 9) THEN 
          host_write_data_addr <= to_unsigned(16#000#, 9);
        ELSE 
          host_write_data_addr <= host_write_data_addr + to_unsigned(16#001#, 9);
        END IF;
      END IF;
    END IF;
  END PROCESS HostBehavioralModel_process;


  host_write_data_addr_delay_1 <= host_write_data_addr AFTER 1 ns;


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
  rdEnb <= '1';
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
--
--  filter_out_enb <= ce_out AND filter_out_active;
  filter_out_enb <=  filter_out_active;
--
--  -- Count limited, Unsigned Counter
--  --  initial value   = 0
--  --  step value      = 1
--  --  count to value  = 500
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
