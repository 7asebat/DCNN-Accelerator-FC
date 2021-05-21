set top_module FC_Neuron
set top_module_rtl { FC_Neuron.v }
set module_rtl_dir FC_Neuron

source scripts/0_init_design.tcl
source scripts/1_read_design.tcl
source scripts/2_synthesize_optimize.tcl
source scripts/3_export_design.tcl
