module DMA #(parameter BUFFER_SIZE = 20, parameter MEM_ADDRESS_WIDTH=10, parameter COUNT_WIDTH=16, parameter MEM_WIDTH=16)(
  input   reg                         i_read,
  input   [MEM_ADDRESS_WIDTH-1 : 0]   i_address,
  input   reg [COUNT_WIDTH-1 : 0]     i_count,
  input   reg                         clk,

  input   [MEM_WIDTH-1:0]             i_mem_data,
  output  [MEM_ADDRESS_WIDTH-1 : 0]   o_mem_addr,

  output  reg [MEM_WIDTH-1 : 0]       o_buffer [BUFFER_SIZE-1 : 0],
  output  reg                         o_ready
);

  reg read;
  reg [COUNT_WIDTH-1 : 0] count;
  reg [MEM_ADDRESS_WIDTH-1 : 0] address;
  reg [MEM_ADDRESS_WIDTH-1 : 0] mem_addr;

  integer mem_idx;

  always @(posedge i_read) begin
    read <= i_read;
    count <= i_count;
    address <= i_address;
    mem_idx <= 0;
  end

  always @(posedge clk) begin
    if (read == 1) begin
      if (mem_idx < count) begin
        mem_addr <= mem_idx + address;

      end else begin
        read <= 0;
        o_ready <= 1;
      end
    end
  end

  always @(negedge clk) begin
    if (read == 1) begin
      if (mem_idx < count) begin
        o_buffer[mem_idx] <= i_mem_data;
        mem_idx <= mem_idx + 1;
      end
    end
    o_ready <= 0;
  end

  assign o_mem_addr = mem_addr;

endmodule