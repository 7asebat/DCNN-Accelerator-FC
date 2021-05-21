// Fraction is fixed at the first `PRECISION` bits
module FP_Multiplier #(parameter SIZE=16, parameter PRECISION=11) (
  input signed [SIZE-1: 0] multiplicand,
  input signed [SIZE-1: 0] multiplier,
  output reg signed [SIZE-1: 0] product,
  output reg overflow
);
  wire [2*SIZE-1: 0] w_bp;
  Booth_Multiplier #(SIZE) booth(multiplicand, multiplier, w_bp);

  integer i;
  always @(*) begin
    product = w_bp[PRECISION + SIZE - 1: PRECISION];
    overflow = 'b0;

    for (i = PRECISION+SIZE; i < 2*SIZE; i = i + 1) begin
      overflow = overflow | w_bp[i];
    end
  end

endmodule