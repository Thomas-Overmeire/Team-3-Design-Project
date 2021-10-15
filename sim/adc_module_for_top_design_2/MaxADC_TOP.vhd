-------------------------------------------------------------------------------
-- Title      : Programme memory for the horizontally programmed
--              LAB2 ELEC4406
-- Project    : 
-------------------------------------------------------------------------------
-- File       : LAB2_TOP.vhd
-- Author     : Michael Cantoni & Antonio Cantoni
-- Company    : The University of Melbourne
-- Last update: 
-- Platform   : 
-------------------------------------------------------------------------------
-- Description: Programme memory for the horizontally programmed
--              LAB2 ELEC4406
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2007/02/10  1.0      MC	Created
-- 2014/01/09  2.0      MC      Modified to work with new AD/DA daughter board
--                              and ALTERA DE1 development board
--                              + updated commenting
-- 2/4/2020			Antonio	Many changes  in code and architecture
--                BIT SET adnd BIT CLEAR ROUT register
--                UART interface for displaying captured signal
--                ADC interface for MAX 10 ADC
--                DAC interface for Digilent DA2 DAC
--                Frame start signla generation.

-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2007/01/27  1.0      MC	Created
-- 2014/01/12  2.0      MC      Modified to work with new AD/DA daughter board
--                              and Altera DE1 development board. Provided
--                              additional comments 
-------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE ieee.numeric_std.all;
--USE work.Programmable_FIR_via_Registers_pkg_adc.ALL;
USE work.Programmable_FIR_via_Registers_pkg_adc.ALL;

entity MaxADC_TOP is
  
  port (
	clk_in         	: in std_logic;
	rst_in_L        	: in std_logic;
	data_in  			: in std_logic_vector(31 downto 0);
	data_out				: out std_logic_vector(14 downto 0);
--	nosin            	: in std_logic_vector(6 downto 0);
--	internalSource		: in  std_logic;
--	strb_nos       	: in std_logic; -- assumed to be debounced (e.g. KEY1 on DE1 board)
--	USBCTS				: in  STD_LOGIC;
--	USBV5					: in  STD_LOGIC;
--	USBTXD				: in  STD_LOGIC;
--	USBDTR				: in  STD_LOGIC;
--	USBRXD				: out  STD_LOGIC;
--	ssd_LODOT       	: out std_logic_vector(7 downto 0);
--	ssd_HIDOT       	: out std_logic_vector(7 downto 0);  
--	ssd_PC_LODOT      : out std_logic_vector(7 downto 0);
--	ssd_PC_HIDOT      : out std_logic_vector(7 downto 0);
--	ssd_RAM_LODOT     : out std_logic_vector(7 downto 0);
--	ssd_RAM_HIDOT     : out std_logic_vector(7 downto 0);
--	TRIG_OUT				: out std_logic;
--	FRAME_SYNC			: out std_logic;
--	SENSE1				: out STD_LOGIC;
--	SENSE2				: out STD_LOGIC;
--	SENSE3				: out STD_LOGIC;
--   SENSE4				: out STD_LOGIC;
--	adc_qsys_cmd_vld 	: out std_logic;
--	adc_qsys_resp_vld : out std_logic;
--	adc_qsys_cmd_rdy 	: out std_logic;
--	led_out				: out std_logic_vector(9 downto 0) := (others=>'1')); -- generate signal internal
          clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          clk_enable                      :   IN    std_logic;
          coeffs_in                       :   IN   std_logic_vector(13 DOWNTO 0);  -- sfix14_En13
          write_address                   :   IN    std_logic_vector(7 DOWNTO 0);  -- uint8
          write_enable                    :   IN    std_logic;
          write_done                      :   IN    std_logic;
          filter_in                       :   IN    std_logic_vector(13 DOWNTO 0);  -- sfix14_En13
          ce_out                          :   OUT   std_logic;
          filter_out                      :   OUT   std_logic_vector(14 DOWNTO 0); -- sfix15_En13
--			 coeffs_single_out                 :   OUT   std_logic_vector(13 DOWNTO 0)  -- sfix14_En13 [7]
        enb                               :   IN    std_logic;
--        coeffs_out                      :   OUT   vector_of_std_logic_vector14(0 TO 6);
		  Discrete_FIR_Filter_in          :   IN    std_logic_vector(13 DOWNTO 0);  -- sfix14_En13
        Discrete_FIR_Filter_coeff       :   IN    vector_of_std_logic_vector14(0 TO 6);  -- sfix14_En13 [7]
        Discrete_FIR_Filter_out         :   OUT   std_logic_vector(14 DOWNTO 0)  -- sfix15_En13
);
end MaxADC_TOP;

architecture bhv of MaxADC_TOP is

component ADC
   port (
		clk_clk       : in std_logic := '0'; --   clk.clk
		reset_reset_n : in std_logic := '0';  -- reset.reset_n
		dout          : buffer std_logic_vector(11 downto 0);   --***** added dout to be connected to control_internal_response_data *****
		rsp_sop       : out std_logic;							 --***** added dout to be connected to control_internal_response_data *****
		rsp_eop		  : out std_logic;							 --***** added dout to be connected to control_internal_response_data *****
		cmd_ready	  : out std_logic;							 --***** added dout to be connected to control_internal_response_data *****
		rsp_valid	  : buffer std_logic;		--***** added dout to be connected to control_internal_response_data *****
		reg_data_out  : out std_logic_vector(11 downto 0)
		--adc_data_in   : in std_logic_vector(31 downto 0) 
	);
	end component ADC;

component Programmable_FIR_via_Registers_adc is
	
  port( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
--        clk_enable                        :   IN    std_logic;
--        coeffs_in                         :   IN    std_logic_vector(13 DOWNTO 0);  -- sfix14_En13
--        write_address                     :   IN    std_logic_vector(7 DOWNTO 0);  -- uint8
--        write_enable                      :   IN    std_logic;
        write_done                        :   IN    std_logic;
        filter_in                         :   IN    std_logic_vector(13 DOWNTO 0);  -- sfix14_En13
        ce_out                            :   OUT   std_logic;
        filter_out                        :   OUT   std_logic_vector(14 DOWNTO 0);  -- sfix15_En13
--		  reg_data_out  : buffer std_logic_vector(11 downto 0);
--		  rsp_valid	  : IN std_logic;
        enb                               :   IN    std_logic;
        coeffs_in                         :   IN    std_logic_vector(13 DOWNTO 0);  -- sfix14_En13
        write_address                     :   IN    std_logic_vector(7 DOWNTO 0);  -- uint8
        write_enable                      :   IN    std_logic;
		  clk_enable                        :   IN    std_logic;
		  coeffs_out                      :   OUT   vector_of_std_logic_vector14(0 TO 6);
		  Discrete_FIR_Filter_in          :   IN    std_logic_vector(13 DOWNTO 0);  -- sfix14_En13
        Discrete_FIR_Filter_coeff       :   IN    vector_of_std_logic_vector14(0 TO 6);  -- sfix14_En13 [7]
        Discrete_FIR_Filter_out         :   OUT   std_logic_vector(14 DOWNTO 0)  -- sfix15_En13
        );
end  component Programmable_FIR_via_Registers_adc;
component switch is
	
  port( 
			rst        		: out std_logic;	--key0
			firselect		: out std_logic_vector(1 downto 0));
end  component switch;

component generator is
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        firselect                         :   buffer    std_logic_vector(1 DOWNTO 0);  -- sfix14_En13
        enb_gen                               :   IN    std_logic;
        write_address_gen                     :   OUT   std_logic_vector(7 DOWNTO 0);  -- uint8
--      write_enable                      :   OUT   std_logic;
        coeffs_single_out                 :  buffer   std_logic_vector(13 DOWNTO 0)  -- sfix14_En13 [7]
        );
end  component generator;

--component coeffs_registers_adc is
--  PORT( clk                               :   IN    std_logic;
--        reset                             :   IN    std_logic;
--        enb                               :   IN    std_logic;
--        coeffs_in                         :   IN    std_logic_vector(13 DOWNTO 0);  -- sfix14_En13
--        write_address                     :   IN    std_logic_vector(7 DOWNTO 0);  -- uint8
--        write_enable                      :   IN    std_logic
----        coeffs_out                        :   OUT   vector_of_std_logic_vector14(0 TO 6)  -- sfix14_En13 [7]
--        );
--end  component coeffs_registers_adc;
FOR ALL : generator
    USE ENTITY work.generator(rtl);
FOR ALL : switch
    USE ENTITY work.switch(bhv);
	 
FOR ALL : Programmable_FIR_via_Registers_adc
	 USE ENTITY work.Programmable_FIR_via_Registers_adc(rtl);
	 
signal register_data_out                                       : std_logic_vector(11 downto 0);
signal altpll_core_output_clock                                : std_logic;
signal avalonbridge_master_readdata_to_data_in                 : std_logic_vector(31 downto 0);
signal sop                                       					: std_logic;
signal rst								                              : std_logic;
signal firselect								                        : std_logic_vector(1 DOWNTO 0);
--signal write_address								                     : std_logic_vector(7 DOWNTO 0);
--signal coeffs_in																: std_logic_vector(13 DOWNTO 0);
signal write_address_2                                         : std_logic_vector(7 downto 0);
signal coeffs_in_gen                                           : std_logic_vector(13 DOWNTO 0);
signal ce_out_1                                                  : std_logic;
signal filter_out_signal                                              : std_logic_vector(14 DOWNTO 0);
-- coeff shadow register signals 
  SIGNAL enb_1                              : std_logic;
  SIGNAL Write_Done_1                     : std_logic;
  SIGNAL coeffs_registers_out1            : vector_of_std_logic_vector14(0 TO 6);  -- ufix14 [7]
  SIGNAL coeffs_registers_out1_signed     : vector_of_signed14(0 TO 6);  -- sfix14_En13 [7]
  SIGNAL coeffs_shadow                    : vector_of_signed14(0 TO 6);  -- sfix14_En13 [7]
  SIGNAL coeffs_shadow_1                  : vector_of_std_logic_vector14(0 TO 6);  -- ufix14 [7]
  SIGNAL Filter_Out_1                     : std_logic_vector(14 DOWNTO 0);  -- ufix15
  SIGNAL clk_enable_1                   : std_logic;



begin

  adc_fir_connection : component ADC
		port map (
			clk_clk                  	=> clk_in,                                          --            clock.clk
			reset_reset_n              => rst_in_L,         --       reset_sink.reset_n
			reg_data_out         	   => register_data_out,                                       --    adc_pll_clock.clk
			rsp_valid                  => altpll_core_output_clock
			--adc_data_in						=> avalonbridge_master_readdata_to_data_in
		);
	fir_adc_connection : component Programmable_FIR_via_Registers_adc
		port map (
			clk                 	=> clk,                                                     --            clock.clk
			reset         		   => rst_in_L  ,         --       reset_sink.reset_n
--			filter_in =>"00" & register_data_out,
         filter_in =>filter_in,			--    adc_pll_clock.clk
			filter_out => filter_out_signal,
			clk_enable => clk_enable_1,
         coeffs_in                         =>coeffs_in_gen,
         write_address                     => write_address_2,
         write_enable                      => sop,
			write_done                        =>write_done,
			ce_out => ce_out_1,
			coeffs_out => coeffs_registers_out1, 
			enb => clk_enable,
         Discrete_FIR_Filter_in => filter_in,  -- sfix14_En13
         Discrete_FIR_Filter_coeff => coeffs_shadow_1,  -- sfix14_En13 [7]
         Discrete_FIR_Filter_out => Filter_Out_1
			
		);
		switch_connection : component switch
		port map (
			rst                  		=> rst,  
			firselect                 	=> firselect
		);

--	adc_connection : component ADC
--		port map (
--			clk_clk                  	=> clk,  
--			rsp_sop                 	=> sop
--		);
	generator_connection : component generator
		port map (
			clk                               => clk, 
			reset                             => rst, 
			firselect                         => firselect, 
			enb_gen                               => sop, 
			write_address_gen                     => write_address_2, 
--      	write_enable                      => sop, 
			coeffs_single_out                 => coeffs_in_gen 
		);
		 Write_Done_1 <= write_done;

  outputgen1: FOR k IN 0 TO 6 GENERATE
    coeffs_registers_out1_signed(k) <= signed(coeffs_registers_out1(k));
  END GENERATE;

  enb_1 <= clk_enable_1;

  shadow_regs_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      coeffs_shadow <= (OTHERS => to_signed(16#0000#, 14));
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb_1 = '1' AND Write_Done_1 = '1' THEN
        coeffs_shadow <= coeffs_registers_out1_signed;
      END IF;
    END IF;
  END PROCESS shadow_regs_process;


  outputgen: FOR k IN 0 TO 6 GENERATE
    coeffs_shadow_1(k) <= std_logic_vector(coeffs_shadow(k));
  END GENERATE;
  
  ce_out_1 <= clk_enable_1;

  filter_out <= Filter_Out_1;
		
--	coeffs_register_connection : component Programmable_FIR_via_Registers_adc
--	-- coeffs_registers_adc
--		port map (
--		  clk                               => altpll_core_output_clock, 
--        reset                             => rst, 
--        enb                               => sop,
--        coeffs_in                         => coeffs_in,
--        write_address                     => write_address,
--        write_enable                      => sop
----        coeffs_out                        
--		);		
--avalonbridge_master_readdata_to_data_in <= data_in;


end bhv;