virtual class File_Utility #(parameter WORD_SIZE=16, parameter ARRAY_SIZE=120);
  static function [0: ARRAY_SIZE-1][WORD_SIZE-1: 0] read_array(string fname);
    reg signed [31:0] line;

    int fd = $fopen(fname, "r");
    if (!fd) begin 
      $fatal("FAILED to open %s", fname);
    end


    for (int i = 0; i < ARRAY_SIZE; i++) begin
      line = $fscanf(fd, "%h\n", read_array[i]);
    end

    $fclose(fd);
  endfunction
endclass // File_Utility

module FC_Top_Module_TB ();
  localparam FC_INPUT_SIZE = 120;
  localparam WORD_SIZE = 16;
  localparam MEM_ADDRESS_WIDTH = 16;
  localparam MEM_SIZE = 12000;

  reg clk;
  reg rst;
  reg CNN_ready;
  reg [0: FC_INPUT_SIZE-1][WORD_SIZE-1: 0] FC_inputs;


  reg [0: MEM_SIZE-1][WORD_SIZE-1: 0] memory;
  reg [WORD_SIZE - 1: 0] mem_data;
  reg [MEM_ADDRESS_WIDTH - 1: 0] mem_addr;

  reg [3: 0] FC_output; // index from 0 to 9 (inclusive)
  reg [3: 0] expected;
  reg done;

  FC_Top_Module #(FC_INPUT_SIZE, WORD_SIZE, MEM_ADDRESS_WIDTH) fc(
    clk,
    rst,

    CNN_ready,
    FC_inputs,

    mem_data,
    mem_addr,
    FC_output,
    done
  );

  initial begin
    expected = File_Utility#(WORD_SIZE, 1)::read_array("testbench/Softmax_Layer_Values.txt");
    FC_inputs = File_Utility#(WORD_SIZE, FC_INPUT_SIZE)::read_array("testbench/FC_Layer_Inputs.txt");
    memory = File_Utility#(WORD_SIZE, MEM_SIZE)::read_array("testbench/Memory_Values.txt");

    CNN_ready = 1;
    rst = 0;
    clk = 0;

    #2.23us;
    assert(FC_output == expected) 
      $display("PASS");
    else 
      $error("FAIL");

  end

  always #50 clk = ~clk;
  assign mem_data = memory[mem_addr];

endmodule