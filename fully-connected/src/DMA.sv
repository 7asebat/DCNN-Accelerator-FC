module DMA #(parameter BUFFER_SIZE = 120, parameter WORD_SIZE=16, parameter MEM_ADDRESS_WIDTH=10)(
  input                               i_read,
  input   [MEM_ADDRESS_WIDTH-1 : 0]   i_address,
  input   [MEM_ADDRESS_WIDTH-1 : 0]   i_count,
  input                               clk,

  input   [WORD_SIZE-1:0]             i_mem_data,
  output  wire [MEM_ADDRESS_WIDTH-1 : 0]   o_mem_addr,

  output  reg [0: BUFFER_SIZE-1][WORD_SIZE-1 : 0] o_buffer,
  output  reg                         o_ready
);

  reg read;
  reg [MEM_ADDRESS_WIDTH-1: 0] count;
  reg [MEM_ADDRESS_WIDTH-1: 0] address;
  wire [MEM_ADDRESS_WIDTH-1: 0] mem_addr;

  integer mem_idx;

  initial begin
    count = 0;
    address = 0;
    read = 0;
    mem_idx = 0;
    o_ready = 0;
    o_buffer = {BUFFER_SIZE * WORD_SIZE {1'b0}};
  end

  always @(posedge clk) begin
    if (o_ready == 1) begin
      o_ready <= 0;
    end

    else if (read == 0 && i_read == 1) begin
      read <= i_read;
      count <= i_count;
      address <= i_address;
      mem_idx <= 0;
      o_ready <= 0;
    end
  end

  always @(negedge clk) begin
    if (read == 1) begin
      if (mem_idx < count) begin
        o_buffer[mem_idx] <= i_mem_data;
        mem_idx <= mem_idx + 1;
      end
      if (mem_idx + 1 == count) begin
        read <= 0;
        o_ready <= 1;
      end
    end
  end

  assign mem_addr = mem_idx + address;
  assign o_mem_addr = mem_addr;

endmodule