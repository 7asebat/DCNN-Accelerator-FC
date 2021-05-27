/**
 * Reads values on posedge clk
 */
module ALU #(parameter SIZE=16, parameter PRECISION=11, parameter INPUT_SZ=4) (
  input clk,
  input [0: INPUT_SZ][SIZE-1: 0] i_values,
  input [1: 0] load_enable,
  input enable,
  input clear,

  output [SIZE-1: 0] value
);
  localparam LOAD_VALUES       = 2'd0;
  localparam LOAD_BIAS_WEIGHTS = 2'd1;
  localparam LOAD_UD           = 2'd2;

  reg [2*SIZE-1: 0] r_accumulator;
  reg [0: INPUT_SZ-1][SIZE-1: 0] r_weights;
  reg [0: INPUT_SZ-1][SIZE-1: 0] r_values;
  reg [SIZE-1: 0] r_bias;

  always @(negedge clk) begin
    case (load_enable)
      LOAD_VALUES: r_values <= i_values[0: INPUT_SZ-1];

      // Load bias and weights
      LOAD_BIAS_WEIGHTS: begin
        r_bias <= i_values[0];
        r_weights <= i_values[1: INPUT_SZ];
      end

      default: /* default */;
    endcase
  end

  always @(posedge clear) begin
    r_weights <= {INPUT_SZ * SIZE {1'b0}};
    r_bias <= 0;
    r_accumulator <= 0;
  end

  always @(*) begin
    r_accumulator = {{(SIZE-PRECISION){1'b0}}, r_bias, {(PRECISION){1'b0}}};

    for (int i = 0; i < INPUT_SZ; i++) begin
      r_accumulator += r_weights[i] * r_values[i];
    end
  end

  assign value = r_accumulator[PRECISION + SIZE - 1: PRECISION];
endmodule
