module TSB_TB #(parameter ARRAY_SIZE=2, parameter WORD_SIZE=8) ();
  reg [0: 2][0: ARRAY_SIZE-1][WORD_SIZE-1: 0] in;
  reg [0: 2] en;
  wire [0: ARRAY_SIZE-1][WORD_SIZE-1: 0] out;

  TSB #(ARRAY_SIZE, WORD_SIZE) tsb0(in[0], en[0], out);
  TSB #(ARRAY_SIZE, WORD_SIZE) tsb1(in[1], en[1], out);
  TSB #(ARRAY_SIZE, WORD_SIZE) tsb2(in[2], en[2], out);

  typedef struct packed {
    bit [0: 2][0: ARRAY_SIZE-1][WORD_SIZE-1: 0] in;
    bit [0: 2] en;
    bit [0: ARRAY_SIZE-1][WORD_SIZE-1: 0] out;
  } testcase;

  const testcase [0:2] tests = '{
    '{
      '{
        '{ 'h80_00, 'h00_00 }, 
        '{ 'h00_00, 'h00_08 }, 
        '{ 'h00_0F, 'hF0_00 }
       },
       3'b100,
      '{ 'h80_00, 'h00_00 }
    },

    '{
      '{
        '{ 'h80_00, 'h00_00 }, 
        '{ 'h00_00, 'h00_08 }, 
        '{ 'h00_0F, 'hF0_00 }
       },
       3'b010,
      '{ 'h00_00, 'h00_08 } 
    },

    '{
      '{
        '{ 'h80_00, 'h00_00 }, 
        '{ 'h00_00, 'h00_08 }, 
        '{ 'h00_0F, 'hF0_00 }
       },
       3'b001,
      '{ 'h00_0F, 'hF0_00 }
    }
  };

  initial begin
    for (int i = 0; i < $size(tests); i++) begin
      in = tests[i].in;
      en = tests[i].en;

      #10 assert(out == tests[i].out) 
        $display("PASS %h, %b => %h", 
                 tests[i].in, 
                 tests[i].en, 
                 out);
      else 
        $error("FAIL %h, %b => \n%h expected \n%h", 
               tests[i].in, 
               tests[i].en, 
               out, 
               tests[i].out);
      #1ns;
    end
  end
endmodule
