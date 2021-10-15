transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlib ADC
vmap ADC ADC
vlog -vlog01compat -work ADC +incdir+C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules {C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules/altera_reset_controller.v}
vlog -vlog01compat -work ADC +incdir+C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules {C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules/altera_reset_synchronizer.v}
vlog -vlog01compat -work ADC +incdir+C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules {C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules/ADC_mm_interconnect_0.v}
vlog -vlog01compat -work ADC +incdir+C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules {C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules/ADC_mm_interconnect_0_avalon_st_adapter.v}
vlog -vlog01compat -work ADC +incdir+C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules {C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules/ADC_PLL.v}
vlog -vlog01compat -work ADC +incdir+C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules {C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules/ADC_AvalonBridge.v}
vlog -vlog01compat -work ADC +incdir+C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules {C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules/altera_avalon_packets_to_master.v}
vlog -vlog01compat -work ADC +incdir+C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules {C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules/altera_avalon_st_packets_to_bytes.v}
vlog -vlog01compat -work ADC +incdir+C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules {C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules/altera_avalon_st_bytes_to_packets.v}
vlog -vlog01compat -work ADC +incdir+C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules {C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules/altera_avalon_st_jtag_interface.v}
vlog -vlog01compat -work ADC +incdir+C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules {C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules/altera_jtag_dc_streaming.v}
vlog -vlog01compat -work ADC +incdir+C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules {C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules/altera_jtag_sld_node.v}
vlog -vlog01compat -work ADC +incdir+C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules {C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules/altera_jtag_streaming.v}
vlog -vlog01compat -work ADC +incdir+C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules {C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules/altera_avalon_st_clock_crosser.v}
vlog -vlog01compat -work ADC +incdir+C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules {C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules/altera_std_synchronizer_nocut.v}
vlog -vlog01compat -work ADC +incdir+C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules {C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules/altera_avalon_st_idle_remover.v}
vlog -vlog01compat -work ADC +incdir+C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules {C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules/altera_avalon_st_idle_inserter.v}
vlog -vlog01compat -work ADC +incdir+C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules {C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules/ADC_ADC.v}
vlog -vlog01compat -work ADC +incdir+C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules {C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules/altera_modular_adc_sample_store.v}
vlog -vlog01compat -work ADC +incdir+C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules {C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules/altera_modular_adc_sample_store_ram.v}
vlog -vlog01compat -work ADC +incdir+C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules {C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules/altera_modular_adc_sequencer.v}
vlog -vlog01compat -work ADC +incdir+C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules {C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules/altera_modular_adc_sequencer_csr.v}
vlog -vlog01compat -work ADC +incdir+C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules {C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules/altera_modular_adc_sequencer_ctrl.v}
vlog -vlog01compat -work ADC +incdir+C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules {C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules/altera_modular_adc_control.v}
vlog -vlog01compat -work ADC +incdir+C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules {C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules/altera_modular_adc_control_avrg_fifo.v}
vlog -vlog01compat -work ADC +incdir+C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules {C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules/altera_modular_adc_control_fsm.v}
vlog -vlog01compat -work ADC +incdir+C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules {C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules/chsel_code_converter_sw_to_hw.v}
vlog -vlog01compat -work ADC +incdir+C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules {C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules/fiftyfivenm_adcblock_primitive_wrapper.v}
vlog -vlog01compat -work ADC +incdir+C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules {C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules/fiftyfivenm_adcblock_top_wrapper.v}
vlog -sv -work ADC +incdir+C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules {C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules/ADC_mm_interconnect_0_avalon_st_adapter_error_adapter_0.sv}
vlog -sv -work ADC +incdir+C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules {C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules/ADC_mm_interconnect_0_rsp_mux.sv}
vlog -sv -work ADC +incdir+C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules {C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules/altera_merlin_arbitrator.sv}
vlog -sv -work ADC +incdir+C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules {C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules/ADC_mm_interconnect_0_rsp_demux.sv}
vlog -sv -work ADC +incdir+C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules {C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules/ADC_mm_interconnect_0_cmd_mux.sv}
vlog -sv -work ADC +incdir+C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules {C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules/ADC_mm_interconnect_0_cmd_demux.sv}
vlog -sv -work ADC +incdir+C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules {C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules/altera_merlin_traffic_limiter.sv}
vlog -vlog01compat -work ADC +incdir+C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules {C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules/altera_avalon_sc_fifo.v}
vlog -vlog01compat -work ADC +incdir+C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules {C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules/altera_avalon_st_pipeline_base.v}
vlog -sv -work ADC +incdir+C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules {C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules/ADC_mm_interconnect_0_router_001.sv}
vlog -sv -work ADC +incdir+C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules {C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules/ADC_mm_interconnect_0_router.sv}
vlog -sv -work ADC +incdir+C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules {C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules/altera_merlin_slave_agent.sv}
vlog -sv -work ADC +incdir+C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules {C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules/altera_merlin_burst_uncompressor.sv}
vlog -sv -work ADC +incdir+C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules {C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules/altera_merlin_master_agent.sv}
vlog -sv -work ADC +incdir+C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules {C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules/altera_merlin_slave_translator.sv}
vlog -sv -work ADC +incdir+C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules {C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules/altera_merlin_master_translator.sv}
vlog -sv -work ADC +incdir+C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules {C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules/ADC_AvalonBridge_p2b_adapter.sv}
vlog -sv -work ADC +incdir+C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules {C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules/ADC_AvalonBridge_b2p_adapter.sv}
vlog -sv -work ADC +incdir+C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules {C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/submodules/ADC_AvalonBridge_timing_adt.sv}
vcom -93 -work work {C:/Users/Jon/Desktop/adc_module_for_top_design_2/reg_adc.vhd}
vcom -93 -work ADC {C:/Users/Jon/Desktop/adc_module_for_top_design_2/ADC/synthesis/ADC.vhd}

