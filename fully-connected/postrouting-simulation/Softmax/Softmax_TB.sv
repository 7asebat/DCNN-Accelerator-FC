module Softmax_TB #(parameter SIZE=16, parameter LAYER_SZ=10) ();
  reg signed [0: LAYER_SZ-1][SIZE-1: 0] values;
  reg [SIZE-1: 0] class_out;

  Softmax softmax(values[0] , values[1] , values[2] , values[3] , values[4] , 
      values[5] , values[6] , values[7] , values[8] , values[9], class_out);

  typedef struct packed {
    bit [0: LAYER_SZ-1][SIZE-1: 0] values;
    bit [SIZE-1: 0] class_out;
  } testcase;

  const testcase [0:2] tests = '{
    '{  '{ 'h8_00, 'h9_00, 'h7_00, 'h4_00, 'h2_00, 'h3_00, 'h5_00, 'h0_00, 'h7_00, 'h8_00 }, 1 },
    '{  '{ 'h7F_00, 'h9_00, 'h7_00, 'h4_00, 'h2_00, 'h3_00, 'h5_00, 'h0_00, 'h7_00, 'h8_00 }, 0 },
    '{  '{ 'h7_00, 'h9_00, 'h7F_00, 'h4_00, 'h2_00, 'h3_00, 'h5_00, 'h0_00, 'h7_00, 'h8_00 }, 2 }
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
