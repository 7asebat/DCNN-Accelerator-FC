vsim work.DMA
# vsim work.DMA 
# Start time: 01:57:10 on May 22,2021
# Loading sv_std.std
# Loading work.DMA
add wave -position insertpoint  \
sim:/DMA/read \
sim:/DMA/o_ready \
sim:/DMA/o_mem_addr \
sim:/DMA/o_buffer \
sim:/DMA/MEM_WIDTH \
sim:/DMA/mem_idx \
sim:/DMA/MEM_ADDRESS_WIDTH \
sim:/DMA/mem_addr \
sim:/DMA/i_read \
sim:/DMA/i_mem_data \
sim:/DMA/i_count \
sim:/DMA/i_address \
sim:/DMA/COUNT_WIDTH \
sim:/DMA/count \
sim:/DMA/clk \
sim:/DMA/BUFFER_SIZE \
sim:/DMA/address
force -freeze sim:/DMA/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/DMA/i_address 0 0
force -freeze sim:/DMA/i_count 111 0
force -freeze sim:/DMA/i_mem_data 10 0
run
run
run
force -freeze sim:/DMA/i_read 1 0
run 6ns