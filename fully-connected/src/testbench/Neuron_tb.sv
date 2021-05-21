module Neuron_Layer_TB #(parameter SIZE=16, parameter LAYER_SZ=2, parameter OUTPUT_SZ=1) ();
  reg [SIZE-1: 0] load_value;
  reg [SIZE-1: 0] load_address;
  reg load_enable;

  // Neuron's current value
  reg [OUTPUT_SZ-1: 0][SIZE-1: 0] values;

  Neuron_Layer #(SIZE, LAYER_SZ, OUTPUT_SZ) layer(load_value, load_address, load_enable, values);

  typedef struct packed {
    bit [SIZE-1: 0] load_value;
    bit [SIZE-1: 0] load_address;
    bit [OUTPUT_SZ-1: 0][SIZE-1: 0] values;
  } testcase;

  const testcase [0:3] tests = '{
    '{ 'h80_00, 0, '{ 'h80_00 }},
    '{ 'h00_08, 1, '{ 'h00_08 }},
    '{ 'hCC_CC, 0, '{ 'hCC_CC }},
    '{ 'h11_11, 1, '{ 'h11_11 }}
  };

  initial begin
    load_enable = 0;

    for (int i = 0; i < $size(tests); i++) begin
      load_value = tests[i].load_value;
      load_address = tests[i].load_address;
      load_enable = 1;

      #10 load_enable = 0;
      assert(values == tests[i].values) 
        $display("PASS %h, %h => %h", 
                 tests[i].load_value, 
                 tests[i].load_address, 
                 values);
      else 
        $error("FAIL %h, %h => \n%h expected \n%h", 
               tests[i].load_value, 
               tests[i].load_address, 
               values, 
               tests[i].values);
      #1ns;
    end
  end

endmodule