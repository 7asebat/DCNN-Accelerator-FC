module Controller #(parameter MEM_ADDRESS_WIDTH=10, parameter LAYER_SZ=7) (
  input clk,    // Clock
  input clk_en, // Clock Enable
  input rst,  // Asynchronous reset

  // Signals that the output from the CNN stage is ready at the buffer
  input CNN_ready,

  // DMA control signals
  output o_DMA_read,
  output [MEM_ADDRESS_WIDTH-1: 0] o_DMA_address,
  output [LAYER_SZ-1: 0] o_DMA_count,
  input DMA_ready,

  // ALU control signals
  output o_ALU_clear,
  output o_ALU_en,
  output [1:0] o_ALU_load,

  // Neuron control signals
  // 00: 84 neurons
  // 01: 120 neurons
  // 1X: undefined
  output [1:0] o_Neuron_en,
  output [LAYER_SZ-1: 0] o_Neuron_address,

  output [1:0] o_datasrc,
  output o_done
);
  // Stores which stage the module is in currently
  reg [1:0]  stage;
  reg [LAYER_SZ-1: 0]  stage_progress;
  reg [LAYER_SZ-1: 0]  calc_progress;
  localparam STAGE_120_84  = 2'd0;
  localparam STAGE_84_10   = 2'd1;
  localparam STAGE_SOFTMAX = 2'd2;

  reg DMA_read;
  assign o_DMA_read = DMA_read;
  reg [MEM_ADDRESS_WIDTH-1: 0] DMA_address;
  assign o_DMA_address = DMA_address;
  reg [LAYER_SZ-1: 0] DMA_count;
  assign o_DMA_count = DMA_count;

  // TODO(Abdelrahman) Assign these
  localparam ADR_120_84_BIAS    = 'h1;
  localparam ADR_120_84_WEIGHTS = 'h2;
  localparam ADR_84_10_BIAS     = 'h3;
  localparam ADR_84_10_WEIGHTS  = 'h4;

  reg [1:0] ALU_clear;
  assign o_ALU_clear = ALU_clear;
  reg [1:0] ALU_en;
  assign o_ALU_en = ALU_en;
  reg [1:0] ALU_load;
  localparam ALULOAD_VALUES  = 2'd0;
  localparam ALULOAD_BIAS    = 2'd1;
  localparam ALULOAD_WEIGHTS = 2'd2;
  assign o_ALU_load = ALU_load;

  reg [1:0] Neuron_en;
  assign o_Neuron_en = Neuron_en;
  reg [LAYER_SZ-1 :0] Neuron_address;
  assign o_Neuron_address = Neuron_address;

  reg [1:0]  datasrc;
  localparam DATASRC_120 = 0;
  localparam DATASRC_84  = 1;
  localparam DATASRC_10  = 2;
  localparam DATASRC_DMA = 3;
  assign o_datasrc = datasrc;

  reg done;
  assign o_done = done;

  initial begin
    // Start at the initial stage
    stage = STAGE_120_84;
    stage_progress = 0;
    calc_progress = 0;

    DMA_address = 0;
    DMA_read = 0;
    DMA_count = 0;

    ALU_clear = 0;
    ALU_en = 0;
    ALU_load = 0;

    Neuron_en = 0;

    datasrc = 0;
    done = 0;
  end

  always @(posedge clk) begin
    if (clk_en) begin
      if (stage == STAGE_120_84) begin
        if (stage_progress == 0 & CNN_ready) begin
          // Feed 120 values to ALU
          ALU_load <= ALULOAD_VALUES;
          datasrc <= DATASRC_120;

          // Request bias
          DMA_address <= ADR_120_84_BIAS;
          DMA_count <= 1;
          DMA_read <= 1;

          stage_progress <= stage_progress + 1;
        end

        // Bias is received
        else if (stage_progress == 1 & DMA_ready) begin
          // Feed bias to ALU
          datasrc <= DATASRC_DMA;
          ALU_load <= ALULOAD_BIAS;
          ALU_clear <= 1;

          // Request first batch of weights
          DMA_address <= ADR_120_84_WEIGHTS;
          DMA_count <= 120;

          stage_progress <= stage_progress + 1;
        end

        // First batch of weights is received
        else if (stage_progress == 2 & DMA_ready) begin
          // Feed weights to ALU
          datasrc <= DATASRC_DMA;
          ALU_load <= ALULOAD_WEIGHTS;

          // Request following weights
          DMA_address <= DMA_address + 120;

          // Calculate and write first neuron
          ALU_en <= 1;
          ALU_clear <= 0;
          Neuron_en <= STAGE_120_84;
          Neuron_address <= calc_progress;

          calc_progress <= calc_progress + 1;
          stage_progress <= stage_progress + 1;
        end

        // Subsequent batches of weights are receieved
        else if (stage_progress == 3 & DMA_ready) begin
          // Advance to next stage
          if (calc_progress == 120) begin
            stage <= STAGE_84_10;
            stage_progress <= 0;
            calc_progress <= 0;

          end else begin
            // Request following weights
            DMA_address <= DMA_address + 120;

            // Calculate and write subsequent neuron
            Neuron_address <= calc_progress;

            calc_progress <= calc_progress + 1;
          end
        end
      end

      else if (stage == STAGE_84_10) begin
        if (stage_progress == 0) begin
          // Feed 84 values to ALU
          ALU_load <= ALULOAD_VALUES;
          datasrc <= DATASRC_84;

          // Request bias
          DMA_address <= ADR_84_10_BIAS;
          DMA_count <= 1;
          DMA_read <= 1;

          stage_progress <= stage_progress + 1;
        end

        // Bias is received
        else if (stage_progress == 1 & DMA_ready) begin
          // Feed bias to ALU
          datasrc <= DATASRC_DMA;
          ALU_load <= ALULOAD_BIAS;
          ALU_clear <= 1;

          // Request first batch of weights
          DMA_address <= ADR_84_10_WEIGHTS;
          DMA_count <= 84;

          stage_progress <= stage_progress + 1;
        end

        // First batch of weights is received
        else if (stage_progress == 2 & DMA_ready) begin
          // Feed weights to ALU
          datasrc <= DATASRC_DMA;
          ALU_load <= ALULOAD_WEIGHTS;

          // Request following weights
          DMA_address <= DMA_address + 84;

          // Calculate and write first neuron
          ALU_clear <= 0;
          ALU_en <= 1;
          Neuron_en <= STAGE_84_10;
          Neuron_address <= calc_progress;

          calc_progress <= calc_progress + 1;
          stage_progress <= stage_progress + 1;
        end

        // Subsequent batches of weights are receieved
        else if (stage_progress == 3 & DMA_ready) begin
          // Advance to next stage
          if (calc_progress == 84) begin
            stage <= STAGE_SOFTMAX;
            stage_progress <= 0;
            calc_progress <= 0;

          end else begin
            // Request following weights
            DMA_address <= DMA_address + 84;

            // Calculate and write subsequent neuron
            Neuron_address <= calc_progress;

            calc_progress <= calc_progress + 1;
          end
        end
      end

      else if (stage == STAGE_SOFTMAX) begin
        datasrc <= DATASRC_10;
        done <= 1;
      end

    end
  end

endmodule