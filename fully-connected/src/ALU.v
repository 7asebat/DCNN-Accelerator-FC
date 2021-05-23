module ALU #(parameter SIZE=16, parameter PRECISION=11, parameter INPUT_SZ=4) (
  input reg [INPUT_SZ-1: 0][SIZE-1: 0] weights,
  input reg [INPUT_SZ-1: 0][SIZE-1: 0] inputs,
  input reg [SIZE-1: 0] bias,
  input enable,
  input clear,

  output [SIZE-1: 0] value
);
  // TODO(Abdelrahman) Should we add a `done` signal here?

  integer i;
  reg [2*SIZE-1: 0] r_accumulator;

  always @(*) begin
    if (clear) begin
      r_accumulator = {{(SIZE-PRECISION){1'b0}}, bias, {(PRECISION){1'b0}}};
    end

    else if (enable) begin
      for (i = 0; i < INPUT_SZ; i = i + 1) begin
        r_accumulator = r_accumulator + weights[i] * inputs[i];
      end
    end
  end

  assign value = r_accumulator[PRECISION + SIZE - 1: PRECISION];
endmodule
