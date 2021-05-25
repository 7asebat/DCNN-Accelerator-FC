module Neuron_Layer #(parameter SIZE=16, parameter LAYER_SZ=10) (
  input clk,  // Synchronous clock

  input load_en,
  input [SIZE-1: 0] load_value,
  input [SIZE-1: 0] load_address,

  // Neuron's current value
  output reg [LAYER_SZ-1: 0][SIZE-1: 0] values
);
  reg [SIZE-1: 0] reg_address;

  integer i;
  initial begin
    for (i = 0; i < LAYER_SZ; i = i + 1) begin
      values[i] <= 0;
    end
  end

  always @(posedge clk) begin
    if (load_en) begin
      values[load_address] <= load_value;
    end
    reg_address <= load_address;
  end
endmodule
