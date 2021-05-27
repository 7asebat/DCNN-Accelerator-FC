module TSB #(parameter ARRAY_SIZE=120, parameter WORD_SIZE=16) (
  input [0: ARRAY_SIZE-1][WORD_SIZE-1: 0] in,
  input en,
  output [0: ARRAY_SIZE-1][WORD_SIZE-1: 0] out
);
  assign out = en ? in : {(ARRAY_SIZE * WORD_SIZE){1'bz}};
endmodule