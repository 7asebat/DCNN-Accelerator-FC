module ALU_TB #(parameter SIZE=16, parameter PRECISION=11, parameter INPUT_SZ=2) ();
  reg clk;
  reg [SIZE-1: 0] values [0: INPUT_SZ-1];
  reg [SIZE-1: 0] single;
  reg [1: 0] load_enable;
  reg [SIZE-1: 0] value;
  reg clear;

  ALU alu(clk,
          values[0],
          values[1],
          single,
          load_enable,
          clear, 
          value);

  typedef struct {
    logic [SIZE-1: 0] values [0: INPUT_SZ-1];
    logic [SIZE-1: 0] bias;
    logic [SIZE-1: 0] weights [0: INPUT_SZ-1];
    logic [SIZE-1: 0] value;
  } testcase;

  const testcase tests[0:1] = '{
    '{ '{ 'h8_00, 'h4_00 }, 'hC_00, '{ 'h18_00, 'h20_00 }, 'h34_00 },
    '{ '{ 'h8_00, 'h8_00 }, 'h8_00, '{ 'h8_00, 'h8_00 }, 'h18_00 }
  };

  localparam LOAD_VALUES       = 2'd0;
  localparam LOAD_BIAS_WEIGHTS = 2'd1;
  localparam LOAD_UD           = 2'd2;

  initial begin
    clk = 1;
    clear = 1;
    #10 clk = 0;
    #10 clk = 1;
    clear = 0;

    for (int i = 0; i < $size(tests); i++) begin
      load_enable = LOAD_VALUES;
      values = tests[i].values;
      #10 clk = 0;

      #10 clk = 1;
      load_enable = LOAD_BIAS_WEIGHTS;
      single = tests[i].bias;
      values = tests[i].weights;
      #10 clk = 0;

      #10 clk = 1;
      assert(value == tests[i].value) 
        $display("PASS %p, %h, %p => %h", 
                 tests[i].values, 
                 tests[i].bias, 
                 tests[i].weights, 
                 value);
      else 
        $error("FAIL %p, %h, %p => \n%h expected \n%h", 
               tests[i].values, 
               tests[i].bias, 
               tests[i].weights, 
               value, 
               tests[i].value);
      // #1ns;
    end
  end
endmodule

