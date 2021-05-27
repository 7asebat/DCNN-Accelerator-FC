module Decoder_TB #(parameter SIZE=2, parameter OUT_SZ=4) ();
  reg [SIZE-1: 0] in;
  reg [OUT_SZ-1: 0] out;

  Decoder #(SIZE, OUT_SZ) dec(in, out);

  typedef struct packed {
    bit [SIZE-1: 0] in;
    bit [OUT_SZ-1: 0] out;
  } testcase;

  const testcase [0:3] tests = '{
    '{ 2'd0, 4'b0001 },
    '{ 2'd1, 4'b0010 },
    '{ 2'd2, 4'b0100 },
    '{ 2'd3, 4'b1000 }
  };

  initial begin
    for (int i = 0; i < $size(tests); i++) begin
      in = tests[i].in;

      #10 assert(out == tests[i].out) 
        $display("PASS %h => %h", 
                 tests[i].in, 
                 out);
      else 
        $error("FAIL %h => \n%h expected \n%h", 
               tests[i].in, 
               out, 
               tests[i].out);
      #1ns;
    end
  end
endmodule
