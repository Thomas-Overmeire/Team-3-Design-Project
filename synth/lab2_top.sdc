#**************************************************************
# This .sdc file is created by Terasic Tool.
# Users are recommended to modify this file to match users logic.
#**************************************************************

#**************************************************************
# Create Clock
#**************************************************************
create_clock -period "50.0 MHz" [get_ports clk_in]
#create_clock -period "10.0 MHz" [get_ports ADC_CLK_10]

#**************************************************************
# Create Generated Clock
#**************************************************************
derive_pll_clocks
create_generated_clock   -name clk_div:CLKDIV|int_clk -source [get_ports {clk_in}] -divide_by 4 [get_pins {clk_div:CLKDIV|int_clk|q}]
#create_generated_clock   -name uprog_sys:UPROG_SEQ|reg:CWAREG|q[0]  -source [get_ports {clk_in}] -divide_by 100 [get_pins {uprog_sys:UPROG_SEQ|reg:CWAREG|q[0]}]
#create_generated_clock   -name dac_module:DAC_OUT_DO|DA2_controller:DAC_OUT|clk_counter[1] -source [ get_pins {clk_div:CLKDIV|int_clk|q}] -divide_by 2 [get_pins {DA2_controller:DAC_OUT|clk_counter[1]|q}]
#create_generated_clock   -name DA2_controller:CLK_OUT -source [get_ports {clk_in}] -divide_by 4 [get_pins {dac_module:DAC_OUT_DO|DA2_controller:DAC_OUT|clk_counter[1]|q}]
#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************
derive_clock_uncertainty



#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************



#**************************************************************
# Set Load
#**************************************************************






