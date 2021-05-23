module DMA_TB #(parameter BUFFER_SIZE = 120, parameter WORD_SIZE=16, parameter MEM_ADDRESS_WIDTH=3) ();
  reg read;
  reg clk;
  reg [MEM_ADDRESS_WIDTH - 1 : 0] address;
  reg [MEM_ADDRESS_WIDTH - 1 : 0] count;

  reg [WORD_SIZE - 1 : 0] memory [2 ** MEM_ADDRESS_WIDTH - 1 : 0] 
    = '{16'd7, 16'd6, 16'd5, 16'd4, 16'd3, 16'd2, 16'd1, 16'd0};

  reg [MEM_ADDRESS_WIDTH - 1 : 0] mem_addr;
  reg [WORD_SIZE - 1 : 0] mem_data;

  reg [WORD_SIZE-1 : 0] dma_buffer [BUFFER_SIZE-1 : 0];
  reg dma_ready;

  DMA #(BUFFER_SIZE, WORD_SIZE, MEM_ADDRESS_WIDTH) dma(
    .i_read(read), 
    .i_address(address),
    .i_count(count),
    .clk(clk),
    .i_mem_data(mem_data),
    .o_mem_addr(mem_addr),
    .o_buffer(dma_buffer),
    .o_ready(dma_ready)
  );

  initial begin
    read = 0;
    address = 0;
    count = 0;
    clk = 0;
    #20;
  end

  always #20 clk = ~clk;

  initial begin
    address = 1;
    count = 4;
    #20

    read = 1;
    
    wait(dma_ready == 1'b1);

    for(int i = 0; i < count; i++) begin
      assert($unsigned(dma_buffer[i]) == $unsigned(memory[address + i]))
        $display("PASS #%d: dma_buffer[i] = %h, memory[i] = %h", i, dma_buffer[i], memory[address + i]);
      else
        $error("FAIL #%d: dma_buffer[i] = %h, memory[i] = %h", i, dma_buffer[i], memory[address + i]);
    end

  end

  assign mem_data = memory[mem_addr];


endmodule