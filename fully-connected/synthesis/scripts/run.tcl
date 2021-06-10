set top_module DMA
set top_module_rtl { DMA.sv }
set module_rtl_dir DMA

source scripts/0_init_design.tcl
source scripts/1_read_design.tcl
source scripts/2_synthesize_optimize.tcl
source scripts/3_export_design.tcl
