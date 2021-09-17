/**
 * LAYER_ADDRESS_WIDTH: Number of bits needed to represent a neuron's address within
 * a layer
 */
module Controller #(parameter MEM_ADDRESS_WIDTH=16, parameter LAYER_ADDRESS_WIDTH=7) (
  input clk,    // Clock
  input clk_en, // Clock Enable
  input rst,  // Asynchronous reset

  // Signals that the output from the CNN stage is ready at the buffer
  input CNN_ready,

  // DMA control signals
  output reg DMA_read,
  output reg [MEM_ADDRESS_WIDTH-1: 0] DMA_address,
  output reg [LAYER_ADDRESS_WIDTH-1: 0] DMA_count,
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
  output reg [LAYER_ADDRESS_WIDTH-1: 0] Neuron_address,

  output reg [1:0] Bus_datasrc,
  output reg done
);
  // Stores which stage the module is in currently
  reg [1:0] stage;

  // Stores how far the controller is through the stage
  reg [2: 0] stage_progress;

  // Stores how many neurons we've processed so far
  reg [LAYER_ADDRESS_WIDTH-1: 0] calc_progress;
  localparam STAGE_LAYER_F6     = 2'd0;
  localparam STAGE_LAYER_OUTPUT = 2'd1;
  localparam STAGE_SOFTMAX      = 2'd2;
  localparam STAGE_UD           = 2'd3;

  localparam SIZE_LAYER_F6 = 84;
  localparam SIZE_LAYER_OUTPUT = 10;

  localparam ADR_LAYER_F6     = 0;
  localparam ADR_LAYER_OUTPUT = (1 + 120) * 84;

  localparam ALULOAD_VALUES       = 2'd0;
  localparam ALULOAD_BIAS_WEIGHTS = 2'd1;
  localparam ALULOAD_UD           = 2'd2;

  localparam BUS_DATASRC_120 = 0;
  localparam BUS_DATASRC_84  = 1;
  localparam BUS_DATASRC_10  = 2;
  localparam BUS_DATASRC_DMA = 3;

  initial begin
    // Start at the initial stage
    stage <= STAGE_LAYER_F6;
    stage_progress <= 0;
    calc_progress <= 0;

    DMA_address <= 0;
    DMA_read <= 0;
    DMA_count <= 0;

    ALU_clear <= 1;
    ALU_en <= 0;
    ALU_load <= 0;

    Neuron_en <= STAGE_UD;

    Bus_datasrc <= 0;
    done <= 0;
  end

  always @(posedge clk) if (clk_en) case (stage)
    STAGE_LAYER_F6: case (stage_progress)
      // CNN has finished
      0: if (CNN_ready) begin
        // Feed 120 values to ALU
        ALU_clear <= 0;
        ALU_load <= ALULOAD_VALUES;
        Bus_datasrc <= BUS_DATASRC_120;

        // Request bias and weights
        DMA_read <= 1;
        DMA_address <= ADR_LAYER_F6;
        DMA_count <= 1 + 120;

        calc_progress <= 0;
        stage_progress <= stage_progress + 1;
      end

      1: if (calc_progress != SIZE_LAYER_F6) begin
        Neuron_en <= STAGE_UD;

        if (DMA_ready) begin
          // Feed bias and weights to ALU
          ALU_en <= 1;
          ALU_load <= ALULOAD_BIAS_WEIGHTS;
          Bus_datasrc <= BUS_DATASRC_DMA;

          // Request subsequent batch
          DMA_address <= DMA_address + 121;
          DMA_count <= 1 + 120;

          Neuron_address <= calc_progress;
        end
      end
    endcase

    STAGE_LAYER_OUTPUT: case (stage_progress)
      0: begin
        // Feed 84 values to ALU
        ALU_clear <= 0;
        ALU_load <= ALULOAD_VALUES;
        Bus_datasrc <= BUS_DATASRC_84;

        // Request bias and weights
        DMA_read <= 1;
        DMA_address <= ADR_LAYER_OUTPUT;
        DMA_count <= 1 + 84;

        calc_progress <= 0;
        stage_progress <= stage_progress + 1;
      end

      1: if (calc_progress != SIZE_LAYER_OUTPUT) begin
        Neuron_en <= STAGE_UD;

        if (DMA_ready) begin
          // Feed bias and weights to ALU
          ALU_en <= 1;
          ALU_load <= ALULOAD_BIAS_WEIGHTS;
          Bus_datasrc <= BUS_DATASRC_DMA;

          // Request subsequent batch
          DMA_address <= DMA_address + 1 + 84;
          DMA_count <= 1 + 84;

          Neuron_address <= calc_progress;
        end
      end
    endcase

    STAGE_SOFTMAX: if (~rst) begin
      Bus_datasrc <= BUS_DATASRC_10;
      done <= 1;
    end else begin
      stage <= STAGE_LAYER_F6;
      done <= 0;
    end
  endcase

  always @(negedge clk) begin
    if (clk_en) case (stage)

      STAGE_LAYER_F6: case (stage_progress)
        // ALU has calculated the needed values
        1: if (calc_progress != SIZE_LAYER_F6) begin
          if (ALU_en == 1) begin
            ALU_en <= 0;
            ALU_load <= ALULOAD_UD;
            Neuron_en <= STAGE_LAYER_F6;
            // Advance
            calc_progress <= calc_progress + 1;
          end

        end else begin
          stage <= STAGE_LAYER_OUTPUT;
          stage_progress <= 0;
          calc_progress <= 0;

          ALU_en <= 0;
          ALU_clear <= 1;
          ALU_load <= ALULOAD_UD;

          Neuron_en <= STAGE_UD;
        end
      endcase

      STAGE_LAYER_OUTPUT: case (stage_progress)
        // ALU has calculated the needed values
        1: if (calc_progress != SIZE_LAYER_OUTPUT) begin
          if (ALU_en == 1) begin
            ALU_en <= 0;
            ALU_load <= ALULOAD_UD;
            Neuron_en <= STAGE_LAYER_OUTPUT;
            // Advance
            calc_progress <= calc_progress + 1;
          end

        end else begin
          stage <= STAGE_SOFTMAX;
          stage_progress <= 0;
          calc_progress <= 0;

          ALU_en <= 0;
          ALU_clear <= 1;
          ALU_load <= ALULOAD_UD;

          Neuron_en <= STAGE_UD;
        end
      endcase
    
      default: /* default */;
    endcase
  end

endmodule