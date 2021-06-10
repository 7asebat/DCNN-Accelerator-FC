typedef reg[15:0] arr_t[$];
virtual class File_Utility #(parameter WORD_SIZE=16, parameter ARRAY_SIZE=120);
  static function arr_t read_array(string fname);
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

module ALU_TB #(parameter SIZE=16, parameter PRECISION=11, parameter INPUT_SZ=120) ();
  reg clk;
  reg [SIZE-1: 0] values [0: INPUT_SZ];
  reg [1: 0] load_enable;
  reg [SIZE-1: 0] value;
  reg [SIZE-1: 0] expected;
  reg clear;

  ALU alu(clk,
          // Standard version
          // values[1: INPUT_SZ],

          // Synthesized version
          values[1],
          values[2],
          values[3],
          values[4],
          values[5],
          values[6],
          values[7],
          values[8],
          values[9],
          values[10],
          values[11],
          values[12],
          values[13],
          values[14],
          values[15],
          values[16],
          values[17],
          values[18],
          values[19],
          values[20],
          values[21],
          values[22],
          values[23],
          values[24],
          values[25],
          values[26],
          values[27],
          values[28],
          values[29],
          values[30],
          values[31],
          values[32],
          values[33],
          values[34],
          values[35],
          values[36],
          values[37],
          values[38],
          values[39],
          values[40],
          values[41],
          values[42],
          values[43],
          values[44],
          values[45],
          values[46],
          values[47],
          values[48],
          values[49],
          values[50],
          values[51],
          values[52],
          values[53],
          values[54],
          values[55],
          values[56],
          values[57],
          values[58],
          values[59],
          values[60],
          values[61],
          values[62],
          values[63],
          values[64],
          values[65],
          values[66],
          values[67],
          values[68],
          values[69],
          values[70],
          values[71],
          values[72],
          values[73],
          values[74],
          values[75],
          values[76],
          values[77],
          values[78],
          values[79],
          values[80],
          values[81],
          values[82],
          values[83],
          values[84],
          values[85],
          values[86],
          values[87],
          values[88],
          values[89],
          values[90],
          values[91],
          values[92],
          values[93],
          values[94],
          values[95],
          values[96],
          values[97],
          values[98],
          values[99],
          values[100],
          values[101],
          values[102],
          values[103],
          values[104],
          values[105],
          values[106],
          values[107],
          values[108],
          values[109],
          values[110],
          values[111],
          values[112],
          values[113],
          values[114],
          values[115],
          values[116],
          values[117],
          values[118],
          values[119],
          values[120],

          values[0],
          load_enable,
          clear,
          value);


  localparam LOAD_VALUES       = 2'd0;
  localparam LOAD_BIAS_WEIGHTS = 2'd1;
  localparam LOAD_UD           = 2'd2;

  initial begin
    clk = 1;
    clear = 1;
    #10 clk = 0;
    #10 clk = 1;
    clear = 0;

    expected = File_Utility#(SIZE, 1)::read_array("F6_Layer_Values.txt")[0];
    clk = 1;

    load_enable = LOAD_VALUES;
    values[1: INPUT_SZ] = File_Utility#(SIZE, INPUT_SZ)::read_array("FC_Layer_Inputs.txt");
    values[0] = {SIZE {1'b0}};
    #10 clk = 0;

    #10 clk = 1;
    load_enable = LOAD_BIAS_WEIGHTS;
    values = File_Utility#(SIZE, INPUT_SZ+1)::read_array("Memory_Values.txt");
    #10 clk = 0;

    #10 clk = 1;
    assert(value == expected) 
      $display("PASS");
    else 
      $error("FAIL");
  end
endmodule
