module FC_Neuron_TB #(parameter SIZE=16, parameter PRECISION=11, parameter LAYER_SZ=2) ();
  reg [0: LAYER_SZ-1][SIZE-1: 0] weights;
  reg [0: LAYER_SZ-1][SIZE-1: 0] inputs;
  reg [SIZE-1: 0] bias;
  reg [SIZE-1: 0] value;

  FC_Neuron #(SIZE, PRECISION, LAYER_SZ) neuron(weights, inputs, bias, value);

  typedef struct packed {
    bit [0: LAYER_SZ-1][SIZE-1: 0] weights;
    bit [0: LAYER_SZ-1][SIZE-1: 0] inputs;
    bit [SIZE-1: 0] bias;
    bit [SIZE-1: 0] value;
  } testcase;

  const testcase [0:1] tests = '{
    '{ '{ 'h8_00, 'h8_00 }, '{ 'h8_00, 'h8_00 }, 'h8_00, 'h18_00 },
    '{ '{ 'h8_00, 'h4_00 }, '{ 'h18_00, 'h20_00 }, 'hC_00, 'h34_00 }
  };

  initial begin
    for (int i = 0; i < $size(tests); i++) begin
      weights = tests[i].weights;
      inputs = tests[i].inputs;
      bias = tests[i].bias;
      #10 assert(value == tests[i].value) 
        $display("PASS %h, %h, %h => %h", 
                 tests[i].weights, 
                 tests[i].inputs, 
                 tests[i].bias, 
                 value);
      else 
        $error("FAIL %h, %h, %h => \n%h expected \n%h", 
               tests[i].weights, 
               tests[i].inputs, 
               tests[i].bias, 
               value, 
               tests[i].value);
      #1ns;
    end
  end
endmodule
