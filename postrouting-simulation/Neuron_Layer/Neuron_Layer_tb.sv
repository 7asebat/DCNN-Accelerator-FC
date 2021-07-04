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

module Neuron_Layer_TB #(parameter SIZE=16, parameter LAYER_SZ=84) ();
  reg clk;
  reg load_en;
  reg [SIZE-1: 0] load_value;
  reg [SIZE-1: 0] load_address;

  // Neuron's current value
  reg [SIZE-1: 0] values [0: LAYER_SZ-1];
  reg reset;

  // Neuron's expected values
  reg [SIZE-1: 0] expected [0: LAYER_SZ-1];

  // Neuron's load values
  reg [SIZE-1: 0] load [0: LAYER_SZ-1];

  Neuron_Layer layer(clk, load_en, load_value, load_address, reset, 
    // Synthesized version
    values[0],
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
    values[83]

    // Standard version
    // values
  );

  initial begin
    expected = File_Utility#(SIZE, LAYER_SZ)::read_array("expected.txt");
    load_en = 1;

    clk = 0;
    reset = 1;
    #10 clk = 1;
    #10 clk = 0;
    reset = 0;

    for (int i = 0; i < LAYER_SZ; i++) begin
      load_value = expected[i];
      load_address = i[SIZE-1: 0];

      #10 clk = 1;
      #10 clk = 0;
    end

    assert (values == expected) $display("PASS");
    else                        $error("FAIL");
  end
endmodule
