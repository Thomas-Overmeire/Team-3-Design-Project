-- -------------------------------------------------------------
-- 
-- File Name: hdlsrc\dspprogfirhdl\Programmable_FIR_via_Registers.vhd
-- Created: 2021-09-08 14:26:52
-- 
-- Generated by MATLAB 9.9 and HDL Coder 3.17
-- 
-- 
-- -------------------------------------------------------------
-- Rate and Clocking Details
-- -------------------------------------------------------------
-- Model base rate: 1
-- Target subsystem base rate: 1
-- 
-- 
-- Clock Enable  Sample Time
-- -------------------------------------------------------------
-- ce_out        1
-- -------------------------------------------------------------
-- 
-- 
-- Output Signal                 Clock Enable  Sample Time
-- -------------------------------------------------------------
-- filter_out                    ce_out        1
-- -------------------------------------------------------------
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: Programmable_FIR_via_Registers
-- Source Path: dspprogfirhdl/Programmable FIR via Registers
-- Hierarchy Level: 0
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.Programmable_FIR_via_Registers_pkg_adc.ALL;

ENTITY Programmable_FIR_via_Registers_adc IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        clk_enable                        :   IN    std_logic;
        coeffs_in                         :   IN    std_logic_vector(13 DOWNTO 0);  -- sfix14_En13
        write_address                     :   IN    std_logic_vector(7 DOWNTO 0);  -- uint8
        write_enable                      :   IN    std_logic;
        write_done                        :   IN    std_logic;
        filter_in                         :   IN    std_logic_vector(13 DOWNTO 0);  -- sfix14_En13
        ce_out                            :   OUT   std_logic;
        filter_out                        :   OUT   std_logic_vector(14 DOWNTO 0)  -- sfix15_En13
----		  reg_data_out  : buffer std_logic_vector(11 downto 0);
----		  rsp_valid	  : IN std_logic
--        coeffs_out                      :   OUT   vector_of_std_logic_vector14(0 TO 6);
--		  Discrete_FIR_Filter_in          :   IN    std_logic_vector(13 DOWNTO 0);  -- sfix14_En13
--        Discrete_FIR_Filter_coeff       :   IN    vector_of_std_logic_vector14(0 TO 6);  -- sfix14_En13 [7]
--        Discrete_FIR_Filter_out         :   OUT   std_logic_vector(14 DOWNTO 0);  -- sfix15_En13
--		  enb                             :   IN    std_logic
        );
END Programmable_FIR_via_Registers_adc;


ARCHITECTURE rtl OF Programmable_FIR_via_Registers_adc IS

  -- Component Declarations
  COMPONENT coeffs_registers
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          coeffs_in                       :   IN    std_logic_vector(13 DOWNTO 0);  -- sfix14_En13
          write_address                   :   IN    std_logic_vector(7 DOWNTO 0);  -- uint8
          write_enable                    :   IN    std_logic;
          coeffs_out                      :   OUT   vector_of_std_logic_vector14(0 TO 6)  -- sfix14_En13 [7]
          );
  END COMPONENT;

  COMPONENT Discrete_FIR_Filter
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          Discrete_FIR_Filter_in          :   IN    std_logic_vector(13 DOWNTO 0);  -- sfix14_En13
          Discrete_FIR_Filter_coeff       :   IN    vector_of_std_logic_vector14(0 TO 6);  -- sfix14_En13 [7]
          Discrete_FIR_Filter_out         :   OUT   std_logic_vector(14 DOWNTO 0)  -- sfix15_En13
          );
  END COMPONENT;
  
--  --***** component generation of register/handshaking method 
--   component reg_adc is
--		generic (
--			DATA_WIDTH : natural := 12;
--			INIT_VAL   : std_logic_vector := "000000000000"
--	   );		
--		port (
--			-- Control signals:
--			-- controls synchronous loading of register
--			ld_reg : in std_logic := 'X';
--			-- Status signal:
--			-- Nil
--			-- External inputs:
--			-- for the synchronous data storage register
--			rst_L  : in  std_logic := 'X';
--			clk    : in  std_logic := 'X';
--
--			 -- External output:
--			 -- Nil
--
--			 -- Ports to shared system data bus:
--			 -- input
--			reg_din  : in  std_logic_vector(DATA_WIDTH-1 downto 0) := (others => 'X');
--			-- output
--			reg_dout : out std_logic_vector(DATA_WIDTH-1 downto 0)
--	   );
--	end component reg_adc;

  -- Component Configuration Statements
  FOR ALL : coeffs_registers
    USE ENTITY work.coeffs_registers_adc(rtl);

  FOR ALL : Discrete_FIR_Filter
    USE ENTITY work.Discrete_FIR_Filter_adc(rtl);

  -- Signals
  SIGNAL enb                             : std_logic;
  SIGNAL Write_Done_1                     : std_logic;
  SIGNAL coeffs_registers_out1            : vector_of_std_logic_vector14(0 TO 6);  -- ufix14 [7]
  SIGNAL coeffs_registers_out1_signed     : vector_of_signed14(0 TO 6);  -- sfix14_En13 [7]
  SIGNAL coeffs_shadow                    : vector_of_signed14(0 TO 6);  -- sfix14_En13 [7]
  SIGNAL coeffs_shadow_1                  : vector_of_std_logic_vector14(0 TO 6);  -- ufix14 [7]
  SIGNAL Filter_Out_1                     : std_logic_vector(14 DOWNTO 0);  -- ufix15

BEGIN
  u_coeffs_registers : coeffs_registers
    PORT MAP( clk => clk,
              reset => reset,
              enb => clk_enable,
              coeffs_in => coeffs_in,  -- sfix14_En13
              write_address => write_address,  -- uint8
              write_enable => write_enable,
              coeffs_out => coeffs_registers_out1  -- sfix14_En13 [43]
              );

  u_Discrete_FIR_Filter : Discrete_FIR_Filter
    PORT MAP( clk => clk,
              reset => reset,
              enb => clk_enable,
              Discrete_FIR_Filter_in => filter_in,  -- sfix14_En13
              Discrete_FIR_Filter_coeff => coeffs_shadow_1,  -- sfix14_En13 [43]
              Discrete_FIR_Filter_out => Filter_Out_1  -- sfix15_En13
              );

  Write_Done_1 <= write_done;

  outputgen1: FOR k IN 0 TO 6 GENERATE
    coeffs_registers_out1_signed(k) <= signed(coeffs_registers_out1(k));
  END GENERATE;

  enb <= clk_enable;

  shadow_regs_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      coeffs_shadow <= (OTHERS => to_signed(16#0000#, 14));
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' AND Write_Done_1 = '1' THEN
        coeffs_shadow <= coeffs_registers_out1_signed;
      END IF;
    END IF;
  END PROCESS shadow_regs_process;


  outputgen: FOR k IN 0 TO 6 GENERATE
    coeffs_shadow_1(k) <= std_logic_vector(coeffs_shadow(k));
  END GENERATE;

  ce_out <= clk_enable;

  filter_out <= Filter_Out_1;

END rtl;
