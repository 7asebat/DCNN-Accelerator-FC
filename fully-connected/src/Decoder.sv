module Decoder #(parameter SIZE=2, parameter OUT_SZ=4) (
  input [SIZE-1: 0] in,
  output [OUT_SZ-1: 0] out
);
  assign out = 1 << in;
endmodule