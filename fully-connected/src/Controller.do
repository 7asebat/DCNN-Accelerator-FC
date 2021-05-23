# vsim Controller 
restart
delete wave *
add wave -hex -position end sim:/Controller/clk \
  sim:/Controller/clk_en \
  sim:/Controller/stage \
  sim:/Controller/stage_progress \
  sim:/Controller/calc_progress \
  sim:/Controller/CNN_ready \
  sim:/Controller/DMA_ready \
  sim:/Controller/DMA_read \
  sim:/Controller/DMA_address \
  sim:/Controller/DMA_count \
  sim:/Controller/ALU_clear \
  sim:/Controller/ALU_en \
  sim:/Controller/ALU_load \
  sim:/Controller/Neuron_en \
  sim:/Controller/Neuron_address \
  sim:/Controller/datasrc \
  sim:/Controller/done 

force -freeze sim:/Controller/clk 1 0, 0 {100 ps} -r 200
# 0.75 cycle
run 150
force -freeze sim:/Controller/clk_en 1 0
force -freeze sim:/Controller/CNN_ready 1 0
run
force -freeze sim:/Controller/DMA_ready 1 0
run 43ns;
