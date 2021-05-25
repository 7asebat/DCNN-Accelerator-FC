module Controller #(parameter MEM_ADDRESS_WIDTH=10, parameter LAYER_SZ=7) (
  input clk,    // Clock
  input clk_en, // Clock Enable
  input rst,  // Asynchronous reset

  // Signals that the output from the CNN stage is ready at the buffer
  input CNN_ready,

  // DMA control signals
  output reg DMA_read,
  output reg [MEM_ADDRESS_WIDTH-1: 0] DMA_address,
  output reg [LAYER_SZ-1: 0] DMA_count,
  input DMA_ready,

  // ALU control signals
  output reg ALU_clear,
  output reg ALU_en,
  // ALU load enable
  output reg [1: 0] ALU_load,

  // Neuron input enable
  // 00: 84 layer
  // 01: 10 layer
  // 1X: undefined
  output reg [1: 0] Neuron_en,
  // Neuron address
  output reg [LAYER_SZ-1: 0] Neuron_address,

  output reg [1:0] Bus_datasrc,
  output reg done
);
  // Stores which stage the module is in currently
  reg [1:0] stage;

  // Stores how far the controller is through the stage
  reg [LAYER_SZ-1: 0] stage_progress;

  // Stores how many neurons we've processed so far
  reg [LAYER_SZ-1: 0] calc_progress;
  localparam STAGE_120_84  = 2'd0;
  localparam STAGE_84_10   = 2'd1;
  localparam STAGE_SOFTMAX = 2'd2;

  // TODO(Abdelrahman) Assign these
  localparam ADR_120_84_BIAS    = 'h1;
  localparam ADR_120_84_WEIGHTS = 'h2;
  localparam ADR_84_10_BIAS     = 'h3;
  localparam ADR_84_10_WEIGHTS  = 'h4;

  localparam ALULOAD_VALUES  = 2'd0;
  localparam ALULOAD_BIAS    = 2'd1;
  localparam ALULOAD_WEIGHTS = 2'd2;

  localparam BUS_DATASRC_120 = 0;
  localparam BUS_DATASRC_84  = 1;
  localparam BUS_DATASRC_10  = 2;
  localparam BUS_DATASRC_DMA = 3;

  initial begin
    // Start at the initial stage
    stage <= STAGE_120_84;
    stage_progress <= 0;
    calc_progress <= 0;

    DMA_address <= 0;
    DMA_read <= 0;
    DMA_count <= 0;

    ALU_clear <= 0;
    ALU_en <= 0;
    ALU_load <= 0;

    Neuron_en <= 0;

    Bus_datasrc <= 0;
    done <= 0;
  end

  always @(posedge clk) begin
    if (clk_en) case (stage)
      STAGE_120_84: begin
        case (stage_progress)
          // CNN has finished
          0: if (CNN_ready) begin
            // Feed 120 values to ALU
            ALU_load <= ALULOAD_VALUES;
            Bus_datasrc <= BUS_DATASRC_120;

            // Request bias
            DMA_address <= ADR_120_84_BIAS;
            DMA_count <= 1;
            DMA_read <= 1;

            stage_progress <= stage_progress + 1;
          end

          // Bias is received
          1: if (DMA_ready) begin
            // Feed bias to ALU
            Bus_datasrc <= BUS_DATASRC_DMA;
            ALU_load <= ALULOAD_BIAS;
            ALU_clear <= 1;

            // Request first batch of weights
            DMA_address <= ADR_120_84_WEIGHTS;
            DMA_count <= 120;

            stage_progress <= stage_progress + 1;
          end

          // First batch of weights is received
          2: if (DMA_ready) begin
            // Feed weights to ALU
            Bus_datasrc <= BUS_DATASRC_DMA;
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
          3: if (DMA_ready) begin
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
          default: /* default */;
        endcase
      end

      STAGE_84_10: begin
        case (stage_progress)
          0: begin
            // Feed 84 values to ALU
            ALU_load <= ALULOAD_VALUES;
            Bus_datasrc <= BUS_DATASRC_84;

            // Request bias
            DMA_address <= ADR_84_10_BIAS;
            DMA_count <= 1;
            DMA_read <= 1;

            stage_progress <= stage_progress + 1;
          end
        
          // Bias is received
          1: if (DMA_ready) begin
            // Feed bias to ALU
            Bus_datasrc <= BUS_DATASRC_DMA;
            ALU_load <= ALULOAD_BIAS;
            ALU_clear <= 1;

            // Request first batch of weights
            DMA_address <= ADR_84_10_WEIGHTS;
            DMA_count <= 84;

            stage_progress <= stage_progress + 1;
          end

          // First batch of weights is received
          2: if (DMA_ready) begin
            // Feed weights to ALU
            Bus_datasrc <= BUS_DATASRC_DMA;
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
          3: if (DMA_ready) begin
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

          default: /* default */;
        endcase
      end

      STAGE_SOFTMAX: begin
        Bus_datasrc <= BUS_DATASRC_10;
        done <= 1;
      end
    
      default: /* default */;
    endcase
  end
endmodule