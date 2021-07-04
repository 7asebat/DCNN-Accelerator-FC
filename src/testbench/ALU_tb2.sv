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

module ALU_TB2 #(parameter SIZE=16, parameter PRECISION=11, parameter INPUT_SZ=120) ();
  reg clk;
  reg [0: INPUT_SZ][SIZE-1: 0] values;
  reg [1: 0] load_enable;
  reg [SIZE-1: 0] value;
  reg enable, clear;
  reg [SIZE-1: 0] expected;

  ALU #(SIZE, PRECISION, INPUT_SZ) alu(clk,
                                       values, 
                                       load_enable,
                                       enable, 
                                       clear, 
                                       value);

  localparam LOAD_VALUES       = 2'd0;
  localparam LOAD_BIAS_WEIGHTS = 2'd1;
  localparam LOAD_UD           = 2'd2;

  initial begin
    expected = File_Utility#(SIZE, 1)::read_array("testbench/F6_Layer_Values.txt");
    clk = 1;

    load_enable = LOAD_VALUES;
    values[0: INPUT_SZ-1] = File_Utility#(SIZE, INPUT_SZ)::read_array("testbench/FC_Layer_Inputs.txt");
    values[INPUT_SZ] = {SIZE {1'b0}};
    #10 clk = 0;

    #10 clk = 1;
    load_enable = LOAD_BIAS_WEIGHTS;
    values = File_Utility#(SIZE, INPUT_SZ+1)::read_array("testbench/Memory_Values.txt");
    #10 clk = 0;

    #10 clk = 1;
    assert(value == 'he487) 
      $display("PASS");
    else 
      $error("FAIL");
  end
endmodule
