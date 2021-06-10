module Softmax #(parameter SIZE=16, parameter LAYER_SZ=2) (
  input signed [0: LAYER_SZ-1][SIZE-1: 0] values,
  output [SIZE-1: 0] class_out
);
  reg signed [SIZE-1: 0] max;
  reg [SIZE-1: 0] max_out;

  integer i;
  always @(*) begin
    // SIZE_MIN
    max = {(SIZE) {1'b0}};
    max[SIZE-1] = 1'b1;

    // -1
    max_out = {(SIZE) {1'b1}};

    for (i = 0; i < LAYER_SZ; i = i+1) begin
      // @note(Abdelrahman) No idea why we have to use $signed on something
      // that's declared signed, but we have to
      if ($signed(values[i]) > max) begin
        max = values[i];
        max_out = i;
      end
    end

  end
  assign class_out = max_out;
endmodule
