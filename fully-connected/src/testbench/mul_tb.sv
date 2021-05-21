module Booth_Multiplier_TB #(parameter SIZE = 32)();
  reg signed [SIZE-1: 0] multiplicand;
  reg signed [SIZE-1: 0] multiplier;
  reg signed [2*SIZE-1: 0] product;

  Booth_Multiplier #(SIZE) mul(multiplicand, multiplier, product);

  typedef struct packed {
    bit signed [SIZE-1: 0] multiplicand;
    bit signed [SIZE-1: 0] multiplier;
    bit signed [2*SIZE-1: 0] product;
  } testcase;

  const testcase [0:4] tests = '{
    '{ -4, -7, 28 },
    '{ 7, -2, -14 },
    '{ 1, 7, 7 },
    '{ 0, -3, 0 },
    '{ -9, -9, 81 }
  };

  initial begin
    for (int i = 0; i < 5; i++) begin
      multiplicand = tests[i].multiplicand;
      multiplier = tests[i].multiplier;

      #1 assert(product == tests[i].product) 
        $display("PASS %d * %d = %d", 
                 tests[i].multiplicand, 
                 tests[i].multiplier, 
                 product);
      else 
        $error("FAIL %d * %d = \n%b expected \n%b", 
               tests[i].multiplicand, 
               tests[i].multiplier, 
               product, 
               tests[i].product);
      #1ns;
    end
  end
endmodule


/**
  @note(Abdelrahman) This defines a fixed point radix with a precision of 11 bits
  radix define fx11 -fixed -fraction 11 -base decimal -signed
 */
module FP_Multiplier_TB #(parameter SIZE=16, parameter PRECISION=11)();
  reg signed [SIZE-1: 0] multiplicand;
  reg signed [SIZE-1: 0] multiplier;
  reg signed [SIZE-1: 0] product;
  reg overflow;
  
  FP_Multiplier #(SIZE, PRECISION) mul(multiplicand, multiplier, product, overflow);

  // Scaling factor
  localparam SF = 2.0**-PRECISION;

  typedef struct packed {
    bit signed [SIZE-1: 0] multiplicand;
    bit signed [SIZE-1: 0] multiplier;
    bit signed [SIZE-1: 0] product;
  } testcase;

  const testcase [0:1] tests = '{
    '{ 'b1_00000000000, 'b1_00000000000, 'b1_00000000000 },
    '{ 'b1_00100000000, 'b11_10000000000, 'b11_11110000000 }
  };

  initial begin
    for (int i = 0; i < 2; i++) begin
      multiplicand = tests[i].multiplicand;
      multiplier = tests[i].multiplier;

      #1 assert(product == tests[i].product) 
        $display("PASS %f * %f = %f", 
                 tests[i].multiplicand * SF, 
                 tests[i].multiplier * SF, 
                 product * SF);
      else 
        $error("FAIL %f * %f = \n%b expected \n%b", 
               tests[i].multiplicand * SF, 
               tests[i].multiplier * SF, 
               product, 
               tests[i].product);
      #1ns;
    end
  end

endmodule
