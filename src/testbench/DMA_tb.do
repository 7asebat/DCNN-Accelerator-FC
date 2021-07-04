vsim work.DMA_TB
# vsim work.DMA_TB 
# Start time: 13:47:53 on May 23,2021
# Loading sv_std.std
# Loading work.DMA_TB
# Loading work.DMA
add wave -position insertpoint  \
sim:/DMA_TB/WORD_SIZE \
sim:/DMA_TB/read \
sim:/DMA_TB/memory \
sim:/DMA_TB/mem_data \
sim:/DMA_TB/MEM_ADDRESS_WIDTH \
sim:/DMA_TB/mem_addr \
sim:/DMA_TB/dma_ready \
sim:/DMA_TB/dma_buffer \
sim:/DMA_TB/count \
sim:/DMA_TB/clk \
sim:/DMA_TB/BUFFER_SIZE \
sim:/DMA_TB/address
run
run
run
