module FC_Neuron #(parameter SIZE=16, parameter PRECISION=11, parameter LAYER_SZ=10) (
  input [0: LAYER_SZ-1][SIZE-1: 0] weights,
  input [0: LAYER_SZ-1][SIZE-1: 0] inputs,
  input [SIZE-1: 0] bias,
  output [SIZE-1: 0] value
);
  // @note(XL3) Can we turn this into a behavioral model,
  // using only one multiplier and only one adder?
  integer i;
  reg [2*SIZE-1: 0] r_accumulator;
  always @(*) begin
    r_accumulator = {(2*SIZE){1'b0}};
    r_accumulator[PRECISION + SIZE - 1: PRECISION] = bias;

    for (i = 0; i < LAYER_SZ; i = i + 1) begin
      r_accumulator = r_accumulator + weights[i] * inputs[i];
    end

  end
  assign value = r_accumulator[PRECISION + SIZE - 1: PRECISION];
endmodule
