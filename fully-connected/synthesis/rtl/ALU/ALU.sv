/**
 * Reads values on negedge clk
 */
module ALU #(parameter SIZE=16, parameter PRECISION=11, parameter INPUT_SZ=120) (
  input clk,
  input [SIZE-1: 0] i_values [0: INPUT_SZ-1],
  input [SIZE-1: 0] i_single,
  input [1: 0] load_enable,

  input clear,

  output [SIZE-1: 0] value
);
  localparam LOAD_VALUES       = 2'd0;
  localparam LOAD_BIAS_WEIGHTS = 2'd1;
  localparam LOAD_UD           = 2'd2;

  reg [2*SIZE-1: 0] r_accumulator;
  reg [SIZE-1: 0] r_weights [0: INPUT_SZ-1];
  reg [SIZE-1: 0] r_values [0: INPUT_SZ-1];
  reg [SIZE-1: 0] r_bias;

  integer i;
  always @(negedge clk) begin
    if (clear == 1'b1) begin
      for (i = 0; i < INPUT_SZ; i = i + 1) begin
        r_weights[i] <= {SIZE {1'b0}};
      end
      r_bias <= 0;
      r_accumulator <= 0;
    end else begin
      case (load_enable)
        LOAD_VALUES:
        for (i = 0; i < INPUT_SZ; i = i + 1) begin
          r_values[i] <= i_values[i];
        end

        // Load bias and weights
        LOAD_BIAS_WEIGHTS: begin
          r_bias <= i_single;
          for (i = 0; i < INPUT_SZ; i = i + 1) begin
            r_weights[i] <= i_values[i];
          end
        end

        default: /* default */;
      endcase
    end
  end

  wire [2*SIZE-1: 0] sums [0: INPUT_SZ];
  assign sums[0] = {{(SIZE-PRECISION){1'b0}}, r_bias, {(PRECISION){1'b0}}};

  genvar gi;
  for (gi = 0; gi < INPUT_SZ; gi = gi + 1) begin
    assign sums[gi+1] = sums[gi] + (r_weights[gi] * r_values[gi]);
  end

  assign value = sums[INPUT_SZ][PRECISION + SIZE - 1: PRECISION];
endmodule

