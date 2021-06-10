module Neuron_Layer #(parameter SIZE=16, parameter LAYER_SZ=84) (
  input clk,  // Synchronous clock

  input load_en,
  input [SIZE-1: 0] load_value,
  input [SIZE-1: 0] load_address, // BUG: should this be [log2(LAYER_SZ) - 1 : 0]??

  input reset,

  // Neuron's current value
  output reg [0: LAYER_SZ-1][SIZE-1: 0] o_values
);
  reg [SIZE-1: 0] reg_address;

  integer i;

  always @(posedge clk) begin
    if(reset == 1'b1) begin
      for (i = 0; i < LAYER_SZ; i = i + 1) begin
        o_values[i] <= 0;
      end
    end else begin
      if (load_en) begin
        o_values[load_address] <= load_value;
      end
      reg_address <= load_address;
    end
  end
endmodule
