module FC_Top_Module #(parameter FC_INPUT_SIZE=120, parameter WORD_SIZE=16, parameter MEM_ADDRESS_WIDTH=10) (
  input clk,
  input rst,

  input CNN_ready,
  input [0: FC_INPUT_SIZE-1][WORD_SIZE-1: 0] FC_inputs,

  input [WORD_SIZE - 1: 0] mem_data,
  output [MEM_ADDRESS_WIDTH - 1: 0] mem_addr,

  output reg [3: 0] FC_output, // index from 0 to 9 (inclusive)
  output reg done
);

  // constants
  localparam SHARED_BUS_SIZE = FC_INPUT_SIZE + 8;
  localparam DMA_BUFFER_SIZE = SHARED_BUS_SIZE;
  localparam LAYER_F6_SIZE = 84;
  localparam LAYER_OUTPUT_SIZE = 10;
  localparam SOFTMAX_LAYER_SIZE = 10;
  localparam ALU_PRECISION = 11;
  localparam LAYER_ADDRESS_WIDTH = 7;
  // maximum size array that can be multiplied
  localparam ALU_INPUT_SIZE = SHARED_BUS_SIZE - 1;

  // controller
  wire Ctrl_rst;
  assign Ctrl_rst = rst;
  wire Ctrl_CNN_ready;
  assign Ctrl_CNN_ready = CNN_ready;
  wire Ctrl_clk_en;
  assign Ctrl_clk_en = 1;

  wire Ctrl_DMA_read;
  wire Ctrl_DMA_ready;
  wire [MEM_ADDRESS_WIDTH - 1: 0] Ctrl_DMA_address;
  wire [LAYER_ADDRESS_WIDTH - 1: 0] Ctrl_DMA_count;

  wire Ctrl_ALU_clear;
  wire Ctrl_ALU_en;
  wire [1: 0] Ctrl_ALU_load;

  wire [1: 0] Ctrl_Neuron_en;
  wire [LAYER_ADDRESS_WIDTH-1: 0] Ctrl_Neuron_address;

  wire [1: 0] Ctrl_Bus_datasrc;
  wire Ctrl_done;

  Controller #(MEM_ADDRESS_WIDTH, LAYER_ADDRESS_WIDTH) FC_control(
    .clk(clk),
    .clk_en(Ctrl_clk_en),
    .CNN_ready(Ctrl_CNN_ready),
    .rst(Ctrl_rst),

    .DMA_read(Ctrl_DMA_read),
    .DMA_ready(Ctrl_DMA_ready),
    .DMA_address(Ctrl_DMA_address),
    .DMA_count(Ctrl_DMA_count),

    .ALU_clear(Ctrl_ALU_clear),
    .ALU_en(Ctrl_ALU_en),
    .ALU_load(Ctrl_ALU_load),

    .Neuron_en(Ctrl_Neuron_en),
    .Neuron_address(Ctrl_Neuron_address),

    // This controls the top module's shared bus
    .Bus_datasrc(Ctrl_Bus_datasrc),
    .done(Ctrl_done)
  );

  wire [0: SHARED_BUS_SIZE-1][WORD_SIZE-1: 0] shared_bus;
  wire [3: 0] shared_bus_signals;
  Decoder #(2, 4) shared_bus_control(Ctrl_Bus_datasrc, shared_bus_signals);

  wire [0: SHARED_BUS_SIZE-1][WORD_SIZE-1: 0] CNN_output_values;
  assign CNN_output_values = { FC_inputs, { (SHARED_BUS_SIZE - FC_INPUT_SIZE) * WORD_SIZE {1'b0} } };
  TSB #(SHARED_BUS_SIZE, WORD_SIZE) CNN_out(CNN_output_values, shared_bus_signals[0], shared_bus);

  // dma
  wire dma_read, dma_ready;
  wire [MEM_ADDRESS_WIDTH - 1: 0] dma_count;
  wire [MEM_ADDRESS_WIDTH - 1: 0] dma_address;
  wire [0: SHARED_BUS_SIZE-1][WORD_SIZE - 1: 0] dma_buffer;

  /**
   * NOTE(Abdelrahman) The DMA buffer may contain garbage values beyond those that were requested.
   * This shouldn't affect calculation, as neuron values are padded with zeros, which nullifies
   * any undesired addition
   */
  DMA #(DMA_BUFFER_SIZE, WORD_SIZE, MEM_ADDRESS_WIDTH) dma(
    .i_read(dma_read), 
    .i_address(dma_address),
    .i_count(dma_count),
    .clk(clk),
    .i_mem_data(mem_data),
    .o_mem_addr(mem_addr),
    .o_buffer(dma_buffer),
    .o_ready(dma_ready)
  );
  TSB #(SHARED_BUS_SIZE, WORD_SIZE) DMA_out(dma_buffer, shared_bus_signals[3], shared_bus);

  // neuron layers
  // F6 layer (84)
  wire LAYER_F6_en;
  wire [WORD_SIZE - 1: 0] LAYER_F6_load_value;
  wire [WORD_SIZE - 1: 0] LAYER_F6_load_address;
  wire [0: SHARED_BUS_SIZE-1][WORD_SIZE - 1: 0] LAYER_F6_output_values;
  // Pad with zeros to match bus size
  assign LAYER_F6_output_values[LAYER_F6_SIZE: SHARED_BUS_SIZE-1] = { SHARED_BUS_SIZE - LAYER_F6_SIZE {1'b0}};

  Neuron_Layer #(WORD_SIZE, LAYER_F6_SIZE) LAYER_F6_layer(
    .clk(clk),
    .load_en(LAYER_F6_en),
    .load_value(LAYER_F6_load_value),
    .load_address(LAYER_F6_load_address),

    .values(LAYER_F6_output_values[0: LAYER_F6_SIZE-1])
  );
  TSB #(SHARED_BUS_SIZE, WORD_SIZE) LAYER_F6_out(LAYER_F6_output_values, shared_bus_signals[1], shared_bus);

  // output layer
  wire LAYER_OUTPUT_en;
  wire [WORD_SIZE - 1: 0] LAYER_OUTPUT_load_value;
  wire [WORD_SIZE - 1: 0] LAYER_OUTPUT_load_address;
  wire [0: SHARED_BUS_SIZE-1][WORD_SIZE - 1: 0] LAYER_OUTPUT_output_values;
  // Pad with zeros to match bus size
  assign LAYER_OUTPUT_output_values[LAYER_OUTPUT_SIZE: SHARED_BUS_SIZE-1] = { SHARED_BUS_SIZE - LAYER_OUTPUT_SIZE {1'b0}};

  Neuron_Layer #(WORD_SIZE, LAYER_OUTPUT_SIZE) LAYER_OUTPUT_layer(
    .clk(clk),
    .load_en(LAYER_OUTPUT_en),
    .load_value(LAYER_OUTPUT_load_value),
    .load_address(LAYER_OUTPUT_load_address),

    .values(LAYER_OUTPUT_output_values[0: LAYER_OUTPUT_SIZE - 1])
  );

  // softmax
  wire [0: SOFTMAX_LAYER_SIZE-1][WORD_SIZE-1: 0] SOFTMAX_inputs;
  wire [WORD_SIZE-1: 0] SOFTMAX_output;
  Softmax #(WORD_SIZE, SOFTMAX_LAYER_SIZE) Softmax_layer(
    .values(SOFTMAX_inputs),
    .class_out(SOFTMAX_output)
  );

  // alu
  wire [1: 0] ALU_load;
  wire ALU_en;
  wire ALU_clr;
  wire [WORD_SIZE - 1: 0] ALU_output;
  ALU #(WORD_SIZE, ALU_PRECISION, ALU_INPUT_SIZE) alu(
    .i_values(shared_bus),
    .load_enable(ALU_load),
    .enable(ALU_en),
    .clear(ALU_clr),
    .value(ALU_output)
  );


  // Connect Wires
  // dma <-> control
  assign dma_read = Ctrl_DMA_read;
  assign Ctrl_DMA_ready = dma_ready;
  assign dma_count = Ctrl_DMA_count;
  assign dma_address = Ctrl_DMA_address;

  // alu <-> control
  assign ALU_clr = Ctrl_ALU_clear;
  assign ALU_en = Ctrl_ALU_en;
  assign ALU_load = Ctrl_ALU_load;

  // alu <-> F6
  assign LAYER_F6_load_value = ALU_output; 

  // alu <-> OLAYER
  assign LAYER_OUTPUT_load_value = ALU_output;

  // control <-> F6
  assign LAYER_F6_en = ~Ctrl_Neuron_en[1] & ~Ctrl_Neuron_en[0];
  assign LAYER_F6_load_address = Ctrl_Neuron_address;

  // control <-> OLAYER
  assign LAYER_OUTPUT_en = ~Ctrl_Neuron_en[1] & Ctrl_Neuron_en[0];
  assign LAYER_OUTPUT_load_address = Ctrl_Neuron_address;

  // control <-> topmodule
  assign done = Ctrl_done;

  // softmax <-> topmodule
  assign SOFTMAX_inputs = LAYER_OUTPUT_output_values;
  assign FC_output = SOFTMAX_output[3: 0];
endmodule