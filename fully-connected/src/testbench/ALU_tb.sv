module ALU_TB #(parameter SIZE=16, parameter PRECISION=11, parameter INPUT_SZ=2) ();
  reg [INPUT_SZ-1: 0][SIZE-1: 0] weights;
  reg [INPUT_SZ-1: 0][SIZE-1: 0] inputs;
  reg [SIZE-1: 0] bias;
  reg [SIZE-1: 0] value;

  reg enable, clear, done;

  ALU #(SIZE, PRECISION, INPUT_SZ) neuron(weights, 
                                          inputs, 
                                          bias, 
                                          enable, 
                                          clear, 
                                          value);

  typedef struct packed {
    bit [INPUT_SZ-1: 0][SIZE-1: 0] weights;
    bit [INPUT_SZ-1: 0][SIZE-1: 0] inputs;
    bit [SIZE-1: 0] bias;
    bit [SIZE-1: 0] value;
  } testcase;

  const testcase [0:1] tests = '{
    '{ '{ 'h8_00, 'h4_00 }, '{ 'h18_00, 'h20_00 }, 'hC_00, 'h34_00 },
    '{ '{ 'h8_00, 'h8_00 }, '{ 'h8_00, 'h8_00 }, 'h8_00, 'h18_00 }
  };

  initial begin
    for (int i = 0; i < $size(tests); i++) begin
      weights = tests[i].weights;
      inputs = tests[i].inputs;
      bias = tests[i].bias;


      clear = 1;
      #10 clear = 0;

      enable = 1;
      #10 enable = 0;

      assert(value == tests[i].value) 
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
