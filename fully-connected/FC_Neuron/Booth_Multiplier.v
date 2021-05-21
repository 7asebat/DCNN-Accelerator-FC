module Booth_Multiplier #(parameter SIZE = 32) (
  input signed [SIZE-1: 0] multiplicand,
  input signed [SIZE-1: 0] multiplier,
  output signed [2*SIZE-1: 0] product
);
  reg [2*SIZE:0] r_A;
  reg [2*SIZE:0] r_S;
  reg signed [2*SIZE:0] r_P;

  initial begin
    r_A = {(2*SIZE + 1){1'b0}};
    r_S = {(2*SIZE + 1){1'b0}};
    r_P = {(2*SIZE + 1){1'b0}};
  end

  integer i;
  always @(multiplicand, multiplier) begin
    r_A = {multiplicand, {(SIZE + 1){1'b0}}};
    r_S = {-multiplicand, {(SIZE + 1){1'b0}}};
    r_P = {{(SIZE){1'b0}}, multiplier, 1'b0};

    for (i = 0; i < SIZE; i = i+1) begin
      case (r_P[1:0])
        2'b01: r_P = r_P + r_A;
        2'b10: r_P = r_P + r_S;
        default:;
      endcase

      r_P = r_P >>> 1;
    end
  end

  assign product = r_P[2*SIZE:1];
endmodule