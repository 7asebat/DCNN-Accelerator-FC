module Neuron_Layer_TB #(parameter SIZE=16, parameter LAYER_SZ=2) ();
  reg clk;
  reg load_en;
  reg [SIZE-1: 0] load_value;
  reg [SIZE-1: 0] load_address;

  // Neuron's current value
  reg [0: LAYER_SZ-1][SIZE-1: 0] values;

  reg reset;

  Neuron_Layer #(SIZE, LAYER_SZ) layer(clk, load_en, load_value, load_address, reset, values);

  typedef struct packed {
    bit [SIZE-1: 0] load_value;
    bit [SIZE-1: 0] load_address;
    bit [0: LAYER_SZ-1][SIZE-1: 0] values;
  } testcase;

  const testcase [0:3] tests = '{
    '{ 'h80_00, 0, '{ 'h80_00, 'h00_00 }},
    '{ 'h00_08, 1, '{ 'h80_00, 'h00_08 }},
    '{ 'h11_11, 1, '{ 'h80_00, 'h11_11 }},
    '{ 'h00_08, 0, '{ 'h00_08, 'h11_11 }}
  };

  initial begin
    load_en = 1;
    clk = 0;
    
    reset = 1;
    #10
    clk = 1;
    #10;
    reset = 0;
    clk = 0;

    for (int i = 0; i < $size(tests); i++) begin
      load_value = tests[i].load_value;
      load_address = tests[i].load_address;

      #10 clk = 1;
      #10 clk = 0;

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