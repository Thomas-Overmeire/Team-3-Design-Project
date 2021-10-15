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

library ieee;
use ieee.std_logic_1164.all;

entity LAB2_TOP is
--	GENERIC(
--	d_width : INTEGER := 32); --data bus width
--	
--  
  port (
	clk_in         	: in std_logic;
	rst_in_L        	: in std_logic;
	single_step_in  	: in std_logic;
	one_step_in			: in std_logic;
	nosin            	: in std_logic_vector(6 downto 0);
	internalSource		: in  std_logic;
	strb_nos       	: in std_logic; -- assumed to be debounced (e.g. KEY1 on DE1 board)
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
	TRIG_OUT				: out std_logic;
	FRAME_SYNC			: out std_logic;
	SENSE1				: out STD_LOGIC;
	SENSE2				: out STD_LOGIC;
	SENSE3				: out STD_LOGIC;
   SENSE4				: out STD_LOGIC;
	adc_qsys_cmd_vld 	: out std_logic;
	adc_qsys_resp_vld : out std_logic;
	adc_qsys_cmd_rdy 	: out std_logic;
	clk_enable                      :   IN    std_logic;
   coeffs_in                       :   IN   std_logic_vector(13 DOWNTO 0);  -- sfix14_En13
   write_address                   :   IN    std_logic_vector(7 DOWNTO 0);  -- uint8
   write_enable                    :   IN    std_logic;
   write_done                      :   IN    std_logic;
   filter_in                       :   IN    std_logic_vector(13 DOWNTO 0);  -- sfix14_En13
   ce_out                          :   OUT   std_logic;
   filter_out                      :   OUT   std_logic_vector(14 DOWNTO 0); -- sfix15_En13
	reg_data_out      : out std_logic_vector(11 downto 0);
	led_out				: out std_logic_vector(9 downto 0) := (others=>'1'); -- generate signal internal
	busy       : OUT     STD_LOGIC;                      --indicates when transactions with DAC can be initiated
   mosi       : OUT     STD_LOGIC;                      --SPI bus to DAC: master out, slave in (DIN)	
	mosi_a       : OUT     STD_LOGIC;                      --SPI bus to DAC: master out, slave in (DIN)
   mosi_b       : OUT     STD_LOGIC;                      --SPI bus to DAC: master out, slave in (DIN)		
	sclk       : BUFFER  STD_LOGIC;                      --SPI bus to DAC: serial clock (SCLK)
   ss_n       : BUFFER  STD_LOGIC_VECTOR(0 DOWNTO 0);   --SPI bus to DAC: slave select (~SYNC)
--	rx_data    : OUT    STD_LOGIC_VECTOR(d_width-1 DOWNTO 0); --data received
--	spi_tx_data_dac: OUT STD_LOGIC_VECTOR(31 downto 0);
   selectH										:	 IN		std_logic :='0';
   selectL                             :   IN      std_logic :='0';
	displays_7seg : OUT  STD_LOGIC_VECTOR(13 DOWNTO 0); --outputs to 7 segment displays
	switch_in     : in   std_logic_vector(7 downto 0);  -- 7 bit
	
	
	in_strb 	  : out std_logic);
  
end LAB2_TOP;

architecture bhv of LAB2_TOP is
  
  -----------------------------------------------------------------------------
  -- Component Declarations
  -----------------------------------------------------------------------------
 -- Altera attributes
attribute chip_pin         		: string;
attribute altera_attribute 		: string;
attribute preserve         		: boolean;

attribute chip_pin of clk_in    				: signal is "P11";
--attribute chip_pin of clk_in    				: signal is "A7";  --for testing to see clk by clk process

--attribute chip_pin of strb_nos				: signal is  "A7";   -- key 1
--attribute chip_pin of single_step_in  		: signal is  "B8";   -- key 0
--
--attribute chip_pin of one_step_in			: signal is "A14";   -- sw 7
attribute chip_pin of internalSource		: signal is "B14";   -- sw 8
attribute chip_pin of rst_in_L 	 			: signal is "F15";   -- sw 9
--attribute chip_pin of switch_in  				: signal is "A14,A13,B12,A12,C12,D12,C11,C10";
--attribute chip_pin of in_strb 	 			: signal is "C10";   -- sw 0

--attribute chip_pin of SCL						: signal is "AA20";	-- not used
--attribute chip_pin of SDA						: signal is "AB21";	-- not used

--attribute chip_pin of USBCTS					: signal is "AB20";	-- not used
--attribute chip_pin of USBV5					: signal is "Y19";	-- not used
--attribute chip_pin of USBTXD					: signal is "AA19";	-- not used
--attribute chip_pin of USBRXD					: signal is "AB19";
--attribute chip_pin of USBDTR					: signal is "AA17";	-- not used

attribute chip_pin of adc_qsys_cmd_vld  	: signal is "AB17";	-- not used
attribute chip_pin of adc_qsys_resp_vld 	: signal is "AA12";	-- not used
attribute chip_pin of adc_qsys_cmd_rdy  	: signal is "AA11";	-- not used

--attribute chip_pin of SENSE1					: signal is "Y10"; 	-- not used  
--attribute chip_pin of SENSE2					: signal is "AB9"; 	-- not used   
--attribute chip_pin of SENSE3					: signal is "AB8";	-- not used
--attribute chip_pin of SENSE4					: signal is "AB7"; 	-- not used
--
--attribute chip_pin of FRAME_SYNC				: signal is "AB6";
--attribute chip_pin of TRIG_OUT				: signal is "AB5";





--attribute chip_pin of switch_in  				: signal is "A14,A13,B12,A12,C12,D12,C11,C10";
--attribute chip_pin of nosin   	      		: signal is "A13,B12,A12,C12,D12,C11,C10";   -- seven bits


attribute chip_pin of led_out    		: signal is "B11,A11,D14,E14,C13,D13,B10,A10,A9,A8";
attribute chip_pin of mosi_a  : signal is "AA19";
--attribute chip_pin of busy  : signal is "Y19";
attribute chip_pin of mosi_b  : signal is "Y19";  
attribute chip_pin of SS_n  : signal is "AB19";
attribute chip_pin of sclk  : signal is "AB20";
attribute chip_pin of selectL			: signal is "C10";   -- sw 0
attribute chip_pin of selectH		   : signal is "C11";   -- sw 1
--attribute chip_pin of dac_data_a15      : signal is "AB21";
attribute chip_pin of filter_out          : signal is "AB5";  -- data out from spi on arduino IO0
--attribute chip_pin of spi_tx_data_dac  : signal is "AB6";  -- data into spi on arduino IO1
attribute chip_pin of displays_7seg         	: signal is "C18,D18,E18,B16,A17,A18,B17,C14,E15,C15,C16,E16,D17,C17";





--attribute chip_pin of ssd_LODOT         	: signal is "F17,F20,F19,H19,J18,E19,E20,F18";
--attribute chip_pin of ssd_HIDOT         	: signal is "L19,N20,N19,M20,N18,L18,K20,J20";
----attribute chip_pin of ssd_PC_LODOT       	: signal is "D15,C17,D17,E16,C16,C15,E15,C14";
--attribute chip_pin of ssd_PC_HIDOT       	: signal is "A16,B17,A18,A17,B16,E18,D18,C18";
--
--attribute chip_pin of ssd_RAM_LODOT		: signal is "A19,B22,C22,B21,A21,B19,A20,B20";
--attribute chip_pin of ssd_RAM_HIDOT		: signal is "D22,E17,D19,C20,C19,E21,E22,F21";
--attribute chip_pin of ssd_filterout       

--"L19,N20,N19,M20,N18,L18,K20,J20,F17,F20,F19,H19,J18,E19,E20,F18,D22,E17,D19,C20,C19,E21,E22,F21,A19,B22,C22,B21,A21,B19,A20,B20,A16,B17,A18,A17,B16,E18,D18,C18,D15,C17,D17,E16,C16,C15,E15,C14";



constant  CONTROL 		: std_logic_vector(3 downto 0) := X"0";
constant  ADC_CHANNEL_SELECT	: std_logic_vector(4 downto 0) := "00001";
constant  DAC_CMD_SELECT      : std_logic_vector(3 downto 0) := "0011";  --write to and update DAC channel N
--constant  DAC_ADDR_SELECT      : std_logic_vector(3 downto 0) := "0000"; --DAC A SELECT
constant  DAC_ADDR_SELECT      : std_logic_vector(3 downto 0) := "1111"; --ALL DACS SELECT
constant	 frameBit		: natural :=1;
component clk_div
   generic (
     CLK_IN_TICKS_PER_HALF_CLK : std_logic_vector(23 downto 0));
   port (
	  rst_L  :  in std_logic;
     clk_in : in  std_logic;
     clk    : out std_logic);
  end component;

    component rst_synch_logic is
  
  port (
    rst_in_L 	    : in  std_logic;
    clk_in         : in  std_logic;
	 clk            : in  std_logic;
    rst_out_L        : out std_logic;
    rst_out_L_clk_in      : out std_logic);
  end component rst_synch_logic;
--  
--component uprog_sys 
--  generic (     
--      DATA_WIDTH : natural:=12);
--  port (
--	clk		        	: in std_logic;
--	clk_in         	: in std_logic;
--	rst_in_L        	: in std_logic;
--	
--	single_step_in  	: in std_logic;
--	one_step_in			: in std_logic;
--	
--	nosin            	: in std_logic_vector(6 downto 0);
--	strb_nos       	: in std_logic; -- assumed to be debounced (e.g. KEY1 on DE1 board)
--	
--   in_data   			: in  std_logic_vector(11 downto 0);
--   in_busy   			: in  std_logic;                     -- conv. done at falling edge
--   in_strb 				: out std_logic;                     -- start conversion (active low)
--	in_init    		   : out  std_logic;
--
--   out_done          : in  std_logic;
--   out_data  			: out std_logic_vector(11 downto 0);  -- DAC data iput
--   out_strb  			: out std_logic;  
--   ssd       			: out std_logic_vector(11 downto 0);
--	prog_cnt   			: out std_logic_vector(5 downto 0);
--   data_bus_disp		: out std_logic_vector(DATA_WIDTH-1 downto 0);
--	DOUT_data 			: out std_logic_vector(7 downto 0);
--	DOUT_strb_ext     : out std_logic	
--	);
--end component;	


  -- general purpose register
  component reg
    generic (
      DATA_WIDTH : natural;
      INIT_VAL   : std_logic_vector);
    port (
      ld_reg   : in  std_logic;
      rst_L    : in  std_logic;
      clk      : in  std_logic;
      reg_din  : in  std_logic_vector(DATA_WIDTH-1 downto 0);
      reg_dout : out std_logic_vector(DATA_WIDTH-1 downto 0));
  end component reg;

component  in_module
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
end component;

--component pmod_dac_ad5628
--   GENERIC(
--    clk_freq    : INTEGER := 50;  --system clock frequency in MHz
----	 d_width : INTEGER := 32;      --data bus width
--    spi_clk_div : INTEGER := 1);  --spi_clk_div = clk_freq/100 (answer rounded up)
--	 PORT(
--    clk        : IN      STD_LOGIC;                      --system clock
--    reset_n    : IN      STD_LOGIC;                      --active low asynchronous reset
--    dac_tx_ena : IN      STD_LOGIC;                      --enable transaction with DAC
--    dac_cmd    : IN      STD_LOGIC_VECTOR(3 DOWNTO 0);   --command to send to DAC
--    dac_addr   : IN      STD_LOGIC_VECTOR(3 DOWNTO 0);   --address to send to DAC
--    dac_data   : IN      STD_LOGIC_VECTOR(11 DOWNTO 0);  --data value to send to DAC
--    busy       : OUT     STD_LOGIC;                      --indicates when transactions with DAC can be initiated
--    mosi       : OUT     STD_LOGIC;                      --SPI bus to DAC: master out, slave in (DIN)
--    sclk       : BUFFER  STD_LOGIC;                      --SPI bus to DAC: serial clock (SCLK)
----	 rx_data    : OUT     STD_LOGIC_VECTOR(d_width-1 DOWNTO 0); -- data out from spi
----	 spi_tx_data_dac: OUT STD_LOGIC_VECTOR(31 downto 0);    -- data into spi
--    ss_n       : BUFFER  STD_LOGIC_VECTOR(0 DOWNTO 0));  --SPI bus to DAC: slave select (~SYNC)
--END component pmod_dac_ad5628;

component pmod_dac121S101 IS
  GENERIC(
    clk_freq    : INTEGER := 50;  --system clock frequency in MHz
--	 clk_freq    : INTEGER := 50;  --system clock frequency in MHz
    spi_clk_div : INTEGER := 1);  --spi_clk_div = clk_freq/60 (answer rounded up)
  PORT(
    clk        : IN      STD_LOGIC;                      --system clock
    reset_n    : IN      STD_LOGIC;                      --active low asynchronous reset
    dac_tx_ena : IN      STD_LOGIC;                      --enable transaction with DACs
--    dac_data_a15 : IN      STD_LOGIC_VECTOR(14 DOWNTO 0);  --data value to send to DAC A
	 dac_data_a : IN      STD_LOGIC_VECTOR(11 DOWNTO 0);  --data value to send to DAC A
    dac_data_b : IN      STD_LOGIC_VECTOR(11 DOWNTO 0);  --data value to send to DAC B
    busy       : OUT     STD_LOGIC;                      --indicates when transactions with DACs can be initiated
    mosi_a     : OUT     STD_LOGIC;                      --SPI bus to DAC A: master out, slave in (DIN A)
    mosi_b     : OUT     STD_LOGIC;                      --SPI bus to DAC B: master out, slave in (DIN B)
    sclk       : BUFFER  STD_LOGIC;                      --SPI bus to DAC: serial clock (SCLK)
    ss_n       : BUFFER  STD_LOGIC_VECTOR(0 DOWNTO 0));  --SPI bus to DAC: slave select (~SYNC)
	
END component pmod_dac121S101;

	

component Programmable_FIR_via_Registers_adc is
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          clk_enable                      :   IN    std_logic;
          coeffs_in                       :   IN    std_logic_vector(13 DOWNTO 0);  -- sfix14_En13
          write_address                   :   IN    std_logic_vector(7 DOWNTO 0);  -- uint8
          write_enable                    :   IN    std_logic;
          write_done                      :   IN    std_logic;
          filter_in                       :   IN    std_logic_vector(13 DOWNTO 0);  -- sfix14_En13
          ce_out                          :   OUT   std_logic;
          filter_out                      :   OUT   std_logic_vector(14 DOWNTO 0)  -- sfix15_En13
        );
end  component Programmable_FIR_via_Registers_adc;
--
component generator is
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        firselect                         :   IN    std_logic_vector(1 DOWNTO 0);  -- sfix14_En13
        enb_gen                               :   IN    std_logic;
        write_address_gen                     :   OUT   std_logic_vector(7 DOWNTO 0);  -- uint8
--      write_enable                      :   OUT   std_logic;
        coeffs_single_out                 :  buffer   std_logic_vector(13 DOWNTO 0)  -- sfix14_En13 [7]
        );
end  component generator;
--

 
--component nibble_to_uart is
--port (
--    start     		: in  std_logic;
--    enable        : in  std_logic;
--    data_in     	: in  std_logic_vector(11 downto 0);
--	 frame_start	: in std_logic;
--    clk   			: in  std_logic;
--    rst_l 			: in  std_logic;
--	 done          : out std_logic;
--	 serial_out   	: out std_logic;
--	 data_ready		: out std_logic;
--    data_out		: out  std_logic_vector(7 downto 0));
--end component;

   
--component  two_seven_seg 
--  port (		
--	coded_in     		: in std_logic_vector(7 downto 0);
--	dot_lo_in			: in std_logic;
--	disp_out_lo			: out std_logic_vector(7 downto 0);
--	dot_hi_in			: in std_logic;
--	disp_out_hi			: out std_logic_vector(7 downto 0));
--end component;



	

signal    in_data   			:  std_logic_vector(11 downto 0);
signal    in_busy   			:  std_logic;                     -- conv. done at falling edge
signal    in_strb_1				:  std_logic;
signal    out_done          : std_logic;
signal    in_init    		   :   std_logic;


signal    out_data_int  	:  std_logic_vector(11 downto 0);  -- DAC data iput
signal    out_strb  			:  std_logic;                      -- DAC write enable (active low)
	
signal    ssd       			:  std_logic_vector(11 downto 0);
signal    prog_cnt   		:  std_logic_vector(5 downto 0);
signal    data_bus_disp		:  std_logic_vector(11 downto 0);

signal rst_L         : std_logic;
signal adc_init      : std_logic;
signal adc_chnl 	   : std_logic_vector(4 downto 0);
signal 	adc_start_L : std_logic;
signal 	adc_data    : std_logic_vector(11 downto 0);
signal  adc_chnl_out : std_logic_vector(4 downto 0);
signal adc_data_busy : std_logic;
signal rst_not       :std_logic;
--  signal RAMHI       : std_logic_vector(6 downto 0); 
--  signal RAMLO        : std_logic_vector(6 downto 0); 
--  signal SSD_RAM_LO     : std_logic_vector(6 downto 0); 
--  signal SSD_RAM_HI    : std_logic_vector(6 downto 0);
--  signal PCHI       : std_logic_vector(6 downto 0); 
--  signal PCLO        : std_logic_vector(6 downto 0);
--  signal SSD_PC_LO     : std_logic_vector(6 downto 0); 
--  signal SSD_PC_HI    : std_logic_vector(6 downto 0);
--
--signal  SSD_NOS_LO_coded: std_logic_vector(6 downto 0);
--signal  SSD_NOS_HI_coded: std_logic_vector(6 downto 0);
--signal   ssd_nos_LO : std_logic_vector(7 downto 0);
--signal   ssd_nos_HI : std_logic_vector(7 downto 0);
--signal   ssd_nos : std_logic_vector(11 downto 0);
signal 	serial_data_in: std_logic_vector(7 downto 0);
signal 	serial_out_int: std_logic;
signal   serial_data_int: std_logic_vector(7 downto 0);
signal	prog_cnt_int : std_logic_vector(7 downto 0);
signal    rst_out_L_clk_in_int :std_logic;
signal    clk: std_logic;
signal  uart_data_ready: std_logic;
signal  DOUT_data :  std_logic_vector(7 downto 0);
signal  DOUT_strb_ext       :  std_logic	;
signal adc_data_in          : std_logic_vector(11 downto 0);
signal adc_qsys_resp_vld_signal    : std_logic;
signal reg_data_out_1       : std_logic_vector(11 downto 0);
signal ld_reg_signal        : std_logic;
signal coeffs_in_gen        : std_logic_vector(13 downto 0);
signal firselect            : std_logic_vector(1 downto 0);
signal filter_in_slave :std_logic_vector(13 DOWNTO 0);
signal filter_2_msb    :std_logic_vector(1 DOWNTO 0);
signal firselect_1     :std_logic_vector(1 downto 0);
signal filter_out_1    :std_logic_vector(14 downto 0);
signal dac_data_from_filter :std_logic_vector(11 downto 0);
signal ce_out_1          :std_logic;
--testing dac signals via switch input
signal dac_data_in_4_msb    : std_logic_vector(3 downto 0);
signal switch_in_signal     : std_logic_vector(7 downto 0);
signal dac_data_in          : std_logic_vector(11 downto 0);
signal write_address_gen    : std_logic_vector(7 DOWNTO 0);

begin  -- top


in_strb_1<='1';
in_init<='1';
rst_not<=not(rst_L);
RSTSYNCH: rst_synch_logic  port map (
    rst_in_L 	 => rst_in_L,
    clk_in      => clk_in,
	 clk         => clk,
    rst_out_L   => rst_L,
    rst_out_L_clk_in =>rst_out_L_clk_in_int);
	 
CLKDIV : clk_div generic map (
    CLK_IN_TICKS_PER_HALF_CLK => "000000000000000000000001")
  port map (
    rst_l  => rst_out_L_clk_in_int,
    clk_in => clk_in,
    clk    => clk);
	 
--dac_connection: pmod_dac_ad5628 generic map(
--   clk_freq    => 50,  --system clock frequency in MHz
----	d_width     =>32, --data bus width
--   spi_clk_div => 1)   --spi_clk_div = clk_freq/100 (answer rounded up)
--  port map(
--    clk         =>   clk_in,                       --system clock
--    reset_n     =>   rst_L,                        --active low asynchronous reset
----    dac_tx_ena  => ld_reg_signal,                  --enable transaction with DAC
--    dac_tx_ena  => '1',                  --enable transaction with DAC
--    dac_cmd  	 => DAC_CMD_SELECT,                 --command to send to DAC
--    dac_addr    => DAC_ADDR_SELECT,                --address to send to DAC
--    dac_data    => adc_data_in,                 --data value to send to DAC dac_data_in
--	 --dac_data    => dac_data_in_4_msb & switch_in,                 --data value to send to DAC with swtich input for testing
--    busy        => busy,                           --indicates when transactions with DAC can be initiated
--    mosi        => mosi,                           --SPI bus to DAC: master out, slave in (DIN)
--    sclk        => sclk,                           --SPI bus to DAC: serial clock (SCLK)
----	 rx_data     => rx_data,                        --SPI data output 
----	 spi_tx_data_dac => spi_tx_data_dac,             --SPI data input 
--    ss_n        => ss_n);                          --SPI bus to DAC: slave select (~SYNC)
	 
	dac_connection: pmod_dac121S101 generic map(
   clk_freq    => 50,  --system clock frequency in MHz
--	d_width     =>32, --data bus width
   spi_clk_div => 1)   --spi_clk_div = clk_freq/100 (answer rounded up)
  port map(
    clk         =>   clk_in,                       --system clock
    reset_n     =>   rst_in_L,                        --active low asynchronous reset
    dac_tx_ena  => ce_out_1,                  --enable transaction with DAC
   -- dac_tx_ena  => '1',                  --enable transaction with DAC
--    dac_cmd  	 => DAC_CMD_SELECT,                 --command to send to DAC
--    dac_addr    => DAC_ADDR_SELECT,                --address to send to DAC
    dac_data_a    =>   dac_data_from_filter,                 --data value to send to DAC dac_data_in
	 dac_data_b      => adc_data_in,                 --data value to send to DAC dac_data_in
	 --dac_data    => dac_data_in_4_msb & switch_in,                 --data value to send to DAC with swtich input for testing
    busy        => busy,                           --indicates when transactions with DAC can be initiated
    mosi_a        => mosi_a,                           --SPI bus to DAC: master out, slave in (DIN)
	 mosi_b        => mosi_b,                           --SPI bus to DAC: master out, slave in (DIN)
    sclk        => sclk,                           --SPI bus to DAC: serial clock (SCLK)
--	 rx_data     => rx_data,                        --SPI data output 
--	 spi_tx_data_dac => spi_tx_data_dac,             --SPI data input 
    ss_n        => ss_n);                          --SPI bus to DAC: slave select (~SYNC)
    
--	 -- Component Declarations

--UPROG_SEQ: uprog_sys   generic map (     
--      DATA_WIDTH => 12)
--  port map (
--	clk        			=>clk,
--	clk_in        		=>clk_in,
--	rst_in_L				=>rst_L,
--	
--	single_step_in  	=>single_step_in,
--	one_step_in			=>one_step_in,
--	
--	nosin            	=>nosin,
--	strb_nos       	=>strb_nos,
--	
--   in_data   			=>in_data ,
--   in_busy   			=>in_busy , 
--   in_strb 			   =>in_strb_1,
--	in_init    		   =>in_init ,
--
--   out_done          =>out_done,
--   out_data  			=>out_data_int,
--   out_strb  		 	=>out_strb,
--   ssd       			=>ssd ,
--	prog_cnt   			=>prog_cnt ,
--   data_bus_disp		=>data_bus_disp,
--	DOUT_data 			=>DOUT_data,
--	DOUT_strb_ext     =>DOUT_strb_ext
--	);
--	
--  -----------------------------------------------------------------------------
--  -- data output port 
--  -----------------------------------------------------------------------------
--
--NIBBLE_DO : nibble_to_uart port map(
--    start  			=>out_strb,
--    enable 	      => '1',
--    data_in     	=> out_data_int,
--	 frame_start	=> DOUT_data(frameBit),
--    clk   			=> clk,
--    rst_l 			=> rst_L,
--	 serial_out		=> serial_out_int,
--	 done	      	=> out_done,
--	 data_ready		=> uart_data_ready,
--    data_out		=> serial_data_int);
	 
	-- Handshake register for ADC to FIR
  ADCREG: reg generic map (
    DATA_WIDTH => 12,
    INIT_VAL => "000000000000")
  port map (
    --ld_reg   => '1', -- always load
    ld_reg   => ld_reg_signal,
    rst_L    => rst_L,
    clk      => clk_in,
    reg_din  => adc_data_in,
    reg_dout => reg_data_out_1); 
	
	with in_busy select
		ld_reg_signal 	<=	'0'  when 	'1',		--adc data is busy register is not loaded
								'1'	when	'0',		--adc data is ready, register is loaded
	                     '0'   when  others;
								
		  
  -----------------------------------------------------------------------------
  -- data input port
  -----------------------------------------------------------------------------
      
MY_INPUT: in_module
port map (
   rst_L      		=> rst_out_L_clk_in_int,
	adc_init       =>in_init,
	CLK        		=> clk_in,
	adc_chnl 		=> ADC_CHANNEL_SELECT,
	internalSource  =>internalSource,
	adc_start	 	=> in_strb_1,
	adc_data       =>  adc_data_in  ,
	adc_chnl_out	=> adc_chnl_out,
   adc_data_busy 		=>  in_busy ,
	adc_qsys_cmd_vld 	=> adc_qsys_cmd_vld,
	adc_qsys_resp_vld	=> adc_qsys_resp_vld_signal,
	adc_qsys_cmd_rdy 	=> adc_qsys_cmd_rdy);   
   adc_qsys_resp_vld <= adc_qsys_resp_vld_signal;

u_Programmable_FIR_via_Registers : Programmable_FIR_via_Registers_adc
    PORT MAP( clk => clk_in,
              --reset => '0',
				  reset => rst_not,
              clk_enable => adc_qsys_resp_vld_signal,
              coeffs_in => coeffs_in_gen,  -- sfix14_En13
              write_address => write_address_gen,  -- uint8
              write_enable =>'1',
              write_done => '1',
              filter_in => filter_in_slave,  -- sfix14_En13
              ce_out => ce_out_1,
              filter_out => filter_out_1);  -- sfix15_En13
       
				  
generator_connection : component generator
		port map (
			clk                               => clk_in, 
			reset                             => rst_not, 
--       reset                             => '0', 
			firselect                         => firselect_1 , 
			enb_gen                           => adc_qsys_resp_vld_signal, 
			write_address_gen                 => write_address_gen, 
--      	write_enable                      => sop, 
			coeffs_single_out                 => coeffs_in_gen);

--DATABUSDISP: two_seven_seg
--port map (
--	coded_in     		=>data_bus_disp(7 downto 0),
--	dot_lo_in			=>'0',
--	disp_out_lo			=>ssd_RAM_LODOT,
--	dot_hi_in			=>'1',
--	disp_out_hi			=>ssd_RAM_HIDOT);

	
--	prog_cnt_int <= "00"&prog_cnt;
	
--PCDISP: two_seven_seg
--port map (
--	coded_in     		=>prog_cnt_int,
--	dot_lo_in			=>'1',
--	disp_out_lo			=>ssd_PC_LODOT,
--	dot_hi_in			=>'1',
--	disp_out_hi			=>ssd_PC_HIDOT);				 
					 

--NOSDISP: two_seven_seg
--port map (
--	coded_in     		=>ssd(7 downto 0),
--	dot_lo_in			=>'0',
--	disp_out_lo			=>ssd_LODOT,
--	dot_hi_in			=>'1',
--	disp_out_hi			=>ssd_HIDOT);

	 
  
--	USBRXD<=serial_out_int;
--	led_out<=adc_data_in(9 downto 0);
   led_out<=adc_data_in(9 downto 0);					
	TRIG_OUT<=DOUT_data(0);
	FRAME_SYNC<=DOUT_data(1);
   SENSE1<=in_strb_1; 
	SENSE2<=in_busy;
	SENSE3<=out_done;
	SENSE4<=out_stRb;
	firselect_1  <= selectH & selectL;
--  filter_out <= Filter_Out_1;
  filter_2_msb <= "00";
  filter_in_slave <= filter_2_msb & adc_data_in;
  dac_data_in_4_msb <="0000";
  --switch_in_signal  <=switch_in;
  dac_data_in <= dac_data_in_4_msb & switch_in;
  dac_data_from_filter <= filter_out_1(14 downto 3);
--  filter_out<=filter_out_1;

--  
  with firselect_1 select
		displays_7seg 	<=	"10010000011000"  when 	"00",		--HP
								"11100010011000"	when	"01",		--LP
								"11000000011000"	when	"10",		--BP
								"11000001101100"	when	"11",		--BS
								"11111111111111"	when	others;
	
end bhv;

-------------------------------------------------------------------------------
-- Configuration Statement
-------------------------------------------------------------------------------

configuration LAB2_TOP_CON of LAB2_TOP is
  for bhv
  end for;
end LAB2_TOP_CON;
---------------------------------------------------------------------------------
