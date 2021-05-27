module ALU_TB #(parameter SIZE=16, parameter PRECISION=11, parameter INPUT_SZ=2) ();
  reg clk;
  reg [0: INPUT_SZ][SIZE-1: 0] values;
  reg [1: 0] load_enable;
  reg [SIZE-1: 0] value;
  reg enable, clear;

  ALU #(SIZE, PRECISION, INPUT_SZ) alu(clk,
                                       values, 
                                       load_enable,
                                       enable, 
                                       clear, 
                                       value);

  typedef struct packed {
    bit [0: INPUT_SZ-1][SIZE-1: 0] values;
    bit [SIZE-1: 0] bias;
    bit [0: INPUT_SZ-1][SIZE-1: 0] weights;
    bit [SIZE-1: 0] value;
  } testcase;

  const testcase [0:1] tests = '{
    '{ '{ 'h8_00, 'h4_00 }, 'hC_00, '{ 'h18_00, 'h20_00 }, 'h34_00 },
    '{ '{ 'h8_00, 'h8_00 }, 'h8_00, '{ 'h8_00, 'h8_00 }, 'h18_00 }
  };

  localparam LOAD_VALUES       = 2'd0;
  localparam LOAD_BIAS_WEIGHTS = 2'd1;
  localparam LOAD_UD           = 2'd2;

  initial begin
    clk = 1;

    for (int i = 0; i < $size(tests); i++) begin
      load_enable = LOAD_VALUES;
      values = { tests[i].values, { SIZE {1'b0} } };
      #10 clk = 0;

      #10 clk = 1;
      load_enable = LOAD_BIAS_WEIGHTS;
      values[0] = tests[i].bias;
      values[1: INPUT_SZ] = tests[i].weights;
      #10 clk = 0;

      #10 clk = 1;
      assert(value == tests[i].value) 
        $display("PASS %h, %h, %h => %h", 
                 tests[i].values, 
                 tests[i].bias, 
                 tests[i].weights, 
                 value);
      else 
        $error("FAIL %h, %h, %h => \n%h expected \n%h", 
               tests[i].values, 
               tests[i].bias, 
               tests[i].weights, 
               value, 
               tests[i].value);
      #1ns;
    end
  end
endmodule
