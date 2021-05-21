module Neuron_Layer #(parameter SIZE=16, parameter LAYER_SZ=10, parameter OUTPUT_SZ=4) (
  input [SIZE-1: 0] load_value,
  input [SIZE-1: 0] load_address,
  input load_enable,

  // Neuron's current value
  output [OUTPUT_SZ-1: 0][SIZE-1: 0] values
);
  reg [LAYER_SZ-1: 0][SIZE-1: 0] reg_data;
  reg [SIZE-1: 0] reg_address;

  always @(*) begin
    if (load_enable) begin
      reg_data[load_address] = load_value;
    end
    reg_address = load_address;
  end

  genvar gi;
  for (gi = 0; gi < OUTPUT_SZ; gi = gi + 1) begin
    assign values[gi] = reg_data[reg_address + gi];
  end
endmodule
