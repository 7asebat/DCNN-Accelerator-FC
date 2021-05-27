module Softmax_TB #(parameter SIZE=16, parameter LAYER_SZ=2) ();
  reg signed [0: LAYER_SZ-1][SIZE-1: 0] values;
  reg [SIZE-1: 0] class_out;

  Softmax #(SIZE, LAYER_SZ) softmax(values, class_out);

  typedef struct packed {
    bit [0: LAYER_SZ-1][SIZE-1: 0] values;
    bit [SIZE-1: 0] class_out;
  } testcase;

  const testcase [0:1] tests = '{
    '{  '{ 'h8_00, 'h9_00 }, 1 },
    '{  '{ 'h7F_00, 'h80_00 }, 0 }
  };

  initial begin
    for (int i = 0; i < $size(tests); i++) begin
      values = tests[i].values;
      #10 assert(class_out == tests[i].class_out) 
        $display("PASS %h => %h", 
                 tests[i].values, 
                 class_out);
      else 
        $error("FAIL %h => \n%h expected \n%h", 
               tests[i].values, 
               class_out, 
               tests[i].class_out);
      #1ns;
    end
  end
endmodule
