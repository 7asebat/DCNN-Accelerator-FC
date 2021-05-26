module FC_Top_Module #(parameter FC_INPUT_SIZE=120, parameter WORD_SIZE=16, parameter MEM_ADDRESS_WIDTH=10) (
  input [FC_INPUT_SIZE - 1 : 0] FC_inputs,
  input clk,
  input CNN_ready,

  input [WORD_SIZE - 1 : 0] mem_data,
  output [MEM_ADDRESS_WIDTH - 1 : 0] mem_addr,

  output reg [3 : 0] FC_output, // index from 0 to 9 (inclusive)
  output reg done
);

  // TODO: make sure that all the arrays have correct ordering wrt each other

  // constants
  localparam DMA_BUFFER_SIZE = 120;

  // dma
  wire dma_read, dma_ready;
  wire [MEM_ADDRESS_WIDTH - 1 : 0] dma_count;
  wire [MEM_ADDRESS_WIDTH - 1 : 0] dma_address;
  wire [WORD_SIZE - 1 : 0] dma_buffer [DMA_BUFFER_SIZE - 1 : 0];

  DMA #(DMA_BUFFER_SIZE, WORD_SIZE, MEM_ADDRESS_WIDTH) dma(
    .i_read(dma_read), 
    .i_address(address),
    .i_count(dma_count),
    .clk(clk),
    .i_mem_data(mem_data),
    .o_mem_addr(mem_addr),
    .o_buffer(dma_buffer),
    .o_ready(dma_ready)
  );

  // neuron layers

  // F6 layer (84)
  localparam F6_LAYER_SIZE=84;


  wire [WORD_SIZE - 1 : 0] F6_output_values [F6_LAYER_SIZE - 1 : 0];
  wire F6_en;
  wire [WORD_SIZE - 1 : 0] F6_load_value;
  wire [WORD_SIZE - 1 : 0] F6_load_address;

  Neuron_Layer #(WORD_SIZE, F6_LAYER_SIZE) F6_layer(
    .clk(clk),
    .load_en(F6_en),
    .load_value(F6_load_value),
    .load_address(F6_load_address),

    .values(F6_output_values)
  );

  // output layer
  localparam OLAYER_LAYER_SIZE=10;

  wire [WORD_SIZE - 1 : 0] OLAYER_output_values [OLAYER_LAYER_SIZE - 1 : 0];
  wire OLAYER_en;
  wire [WORD_SIZE - 1 : 0] OLAYER_load_value;
  wire [WORD_SIZE - 1 : 0] OLAYER_load_address;

  Neuron_Layer #(WORD_SIZE, OLAYER_LAYER_SIZE) OLAYER_layer(
    .clk(clk),
    .load_en(OLAYER_en),
    .load_value(OLAYER_load_value),
    .load_address(OLAYER_load_address),

    .values(OLAYER_output_values)
  );

  // softmax
  localparam SOFTMAX_LAYER_SIZE=10;

  wire [WORD_SIZE - 1 : 0] SOFTMAX_inputs [0 : SOFTMAX_LAYER_SIZE - 1];
  wire [WORD_SIZE - 1 : 0] SOFTMAX_output;
  Softmax #(WORD_SIZE, SOFTMAX_LAYER_SIZE) Softmax_layer(
    .values(SOFTMAX_inputs),
    .class_out(SOFTMAX_output)
  );

  // alu
  localparam ALU_PRECISION = 11;
  localparam ALU_input_size = DMA_BUFFER_SIZE;

  wire [WORD_SIZE - 1 : 0] ALU_weights [ALU_input_size - 1 : 0];
  wire [WORD_SIZE - 1 : 0] ALU_inputs  [ALU_input_size - 1 : 0];
  wire [WORD_SIZE - 1 : 0] ALU_bias;

  wire ALU_en;
  wire ALU_clr;

  wire [WORD_SIZE - 1 : 0] ALU_output;

  ALU #(WORD_SIZE, ALU_PRECISION, ALU_input_size) alu(
    .weights(ALU_weights),
    .inputs(ALU_inputs),
    .bias(ALU_bias),
    .enable(ALU_en),
    .clear(ALU_clr),
    .value(ALU_output)
  );

  // controller
  localparam CONTROLLER_LAYER_SIZE = 7; // TODO: ??? what is this

  wire CONTROL_rst;
  wire CONTROL_CNN_ready;
  wire CONTROL_clk_en;

  wire CONTROL_DMA_read;
  wire CONTROL_DMA_ready;
  wire [MEM_ADDRESS_WIDTH - 1 : 0] CONTROL_DMA_address;
  wire [WORD_SIZE - 1 : 0] CONTROL_DMA_count;

  wire CONTROL_ALU_clear;
  wire CONTROL_ALU_en;
  wire [1 : 0] CONTROL_ALU_load;

  wire [1 : 0] CONTROL_Neuron_en;
  wire [WORD_SIZE - 1 : 0] CONTROL_Neuron_address;

  wire [1 : 0] CONTROL_Bus_datasrc;
  wire CONTROL_done;

  Controller #(MEM_ADDRESS_WIDTH, CONTROLLER_LAYER_SIZE) FC_control(
    .clk(clk),
    .clk_en(CONTROL_clk_en),
    .CNN_ready(CONTROL_CNN_ready),
    .rst(CONTROL_rst),

    .DMA_read(CONTROL_DMA_read),
    .DMA_ready(CONTROL_DMA_ready),
    .DMA_address(CONTROL_DMA_address),
    .DMA_count(CONTROL_DMA_count),

    .ALU_clear(CONTROL_ALU_clear),
    .ALU_en(CONTROL_ALU_en),
    .ALU_load(CONTROL_ALU_load),

    .Neuron_en(CONTROL_Neuron_en),
    .Neuron_address(CONTROL_Neuron_address),

    .Bus_datasrc(CONTROL_Bus_datasrc), // TODO: What's this?
    .done(CONTROL_done)
  );


  // connect wires

  // dma <-> control
  assign dma_read = CONTROL_DMA_read;
  assign dma_ready = CONTROL_DMA_ready;
  assign dma_count = CONTROL_DMA_count;
  assign dma_address = CONTROL_DMA_address;

  // dma <-> alu
  assign dma_buffer = ALU_inputs;

  // alu <-> control
  assign ALU_clr = CONTROL_ALU_clear;
  assign ALU_en = CONTROL_ALU_en;

  // TODO: not sure about the CONTROL_ALU_load?? my guessing is that this is a mux signal to define which layer output is to be forwarded


  // alu <-> F6
  assign F6_load_value = ALU_output; 

  // alu <-> OLAYER
  assign OLAYER_load_value = ALU_output; // TODO: slice if necessary

  // control <-> F6
  assign F6_en = !CONTROL_Neuron_en[0]; // TODO: Make sure that this is the correct indx
  assign F6_load_address = CONTROL_Neuron_address; // TODO: should this vars be of size log2(layer_size)?, maybe set them to an upperbound

  // control <-> OLAYER
  assign OLAYER_en = CONTROL_Neuron_en[0];
  assign OLAYER_load_address = CONTROL_Neuron_address;

  // control <-> control
  assign CONTROL_rst = 0;

  // control <-> topmodule
  assign CONTROL_done = done;

  // softmax <-> topmodule
  //assign SOFTMAX_output =  // TODO: map this to a circuit to identify which index of the layer it is.

  assign SOFTMAX_inputs = OLAYER_output_values;

endmodule