
// 	Thu May  6 03:22:10 2021
//	vlsi
//	localhost.localdomain

module Neuron_Layer (clk, load_en, load_value, load_address, reset, \values[0] , 
    \values[1] );

output [15:0] \values[0] ;
output [15:0] \values[1] ;
input clk;
input [15:0] load_address;
input load_en;
input [15:0] load_value;
input reset;
wire n_0_2;
wire n_0_3;
wire \values[15] ;
wire \values[14] ;
wire \values[13] ;
wire \values[12] ;
wire \values[11] ;
wire \values[10] ;
wire \values[9] ;
wire \values[8] ;
wire \values[7] ;
wire \values[6] ;
wire \values[5] ;
wire \values[4] ;
wire \values[3] ;
wire \values[2] ;
wire \values[1] ;
wire \values[0] ;
wire n_0_0;
wire n_0_1;
wire n_0_0_0;
wire n_0_0_1;
wire n_0_0_2;
wire n_0_0_3;
wire n_0_0_4;
wire n_0_0_5;
wire n_0_0_6;
wire n_0_0_7;


INV_X1 i_0_0_25 (.ZN (n_0_0_7), .A (reset));
INV_X1 i_0_0_24 (.ZN (n_0_0_6), .A (load_en));
INV_X1 i_0_0_23 (.ZN (n_0_0_5), .A (load_address[0]));
NOR4_X1 i_0_0_22 (.ZN (n_0_0_4), .A1 (load_address[8]), .A2 (load_address[7]), .A3 (load_address[6]), .A4 (load_address[1]));
NOR4_X1 i_0_0_21 (.ZN (n_0_0_3), .A1 (load_address[5]), .A2 (load_address[4]), .A3 (load_address[3]), .A4 (load_address[2]));
NOR4_X1 i_0_0_20 (.ZN (n_0_0_2), .A1 (n_0_0_6), .A2 (load_address[15]), .A3 (load_address[14]), .A4 (load_address[9]));
NOR4_X1 i_0_0_19 (.ZN (n_0_0_1), .A1 (load_address[13]), .A2 (load_address[12]), .A3 (load_address[11]), .A4 (load_address[10]));
NAND4_X1 i_0_0_18 (.ZN (n_0_0_0), .A1 (n_0_0_4), .A2 (n_0_0_3), .A3 (n_0_0_2), .A4 (n_0_0_1));
OAI21_X1 i_0_0_17 (.ZN (n_0_1), .A (n_0_0_7), .B1 (n_0_0_5), .B2 (n_0_0_0));
OAI21_X1 i_0_0_16 (.ZN (n_0_0), .A (n_0_0_7), .B1 (n_0_0_0), .B2 (load_address[0]));
AND2_X1 i_0_0_15 (.ZN (\values[15] ), .A1 (n_0_0_7), .A2 (load_value[15]));
AND2_X1 i_0_0_14 (.ZN (\values[14] ), .A1 (n_0_0_7), .A2 (load_value[14]));
AND2_X1 i_0_0_13 (.ZN (\values[13] ), .A1 (n_0_0_7), .A2 (load_value[13]));
AND2_X1 i_0_0_12 (.ZN (\values[12] ), .A1 (n_0_0_7), .A2 (load_value[12]));
AND2_X1 i_0_0_11 (.ZN (\values[11] ), .A1 (n_0_0_7), .A2 (load_value[11]));
AND2_X1 i_0_0_10 (.ZN (\values[10] ), .A1 (n_0_0_7), .A2 (load_value[10]));
AND2_X1 i_0_0_9 (.ZN (\values[9] ), .A1 (n_0_0_7), .A2 (load_value[9]));
AND2_X1 i_0_0_8 (.ZN (\values[8] ), .A1 (n_0_0_7), .A2 (load_value[8]));
AND2_X1 i_0_0_7 (.ZN (\values[7] ), .A1 (n_0_0_7), .A2 (load_value[7]));
AND2_X1 i_0_0_6 (.ZN (\values[6] ), .A1 (n_0_0_7), .A2 (load_value[6]));
AND2_X1 i_0_0_5 (.ZN (\values[5] ), .A1 (n_0_0_7), .A2 (load_value[5]));
AND2_X1 i_0_0_4 (.ZN (\values[4] ), .A1 (n_0_0_7), .A2 (load_value[4]));
AND2_X1 i_0_0_3 (.ZN (\values[3] ), .A1 (n_0_0_7), .A2 (load_value[3]));
AND2_X1 i_0_0_2 (.ZN (\values[2] ), .A1 (n_0_0_7), .A2 (load_value[2]));
AND2_X1 i_0_0_1 (.ZN (\values[1] ), .A1 (n_0_0_7), .A2 (load_value[1]));
AND2_X1 i_0_0_0 (.ZN (\values[0] ), .A1 (n_0_0_7), .A2 (load_value[0]));
DFF_X1 \values_reg[0][0]  (.Q (\values[0] [0] ), .CK (n_0_3), .D (\values[0] ));
DFF_X1 \values_reg[0][1]  (.Q (\values[0] [1] ), .CK (n_0_3), .D (\values[1] ));
DFF_X1 \values_reg[0][2]  (.Q (\values[0] [2] ), .CK (n_0_3), .D (\values[2] ));
DFF_X1 \values_reg[0][3]  (.Q (\values[0] [3] ), .CK (n_0_3), .D (\values[3] ));
DFF_X1 \values_reg[0][4]  (.Q (\values[0] [4] ), .CK (n_0_3), .D (\values[4] ));
DFF_X1 \values_reg[0][5]  (.Q (\values[0] [5] ), .CK (n_0_3), .D (\values[5] ));
DFF_X1 \values_reg[0][6]  (.Q (\values[0] [6] ), .CK (n_0_3), .D (\values[6] ));
DFF_X1 \values_reg[0][7]  (.Q (\values[0] [7] ), .CK (n_0_3), .D (\values[7] ));
DFF_X1 \values_reg[0][8]  (.Q (\values[0] [8] ), .CK (n_0_3), .D (\values[8] ));
DFF_X1 \values_reg[0][9]  (.Q (\values[0] [9] ), .CK (n_0_3), .D (\values[9] ));
DFF_X1 \values_reg[0][10]  (.Q (\values[0] [10] ), .CK (n_0_3), .D (\values[10] ));
DFF_X1 \values_reg[0][11]  (.Q (\values[0] [11] ), .CK (n_0_3), .D (\values[11] ));
DFF_X1 \values_reg[0][12]  (.Q (\values[0] [12] ), .CK (n_0_3), .D (\values[12] ));
DFF_X1 \values_reg[0][13]  (.Q (\values[0] [13] ), .CK (n_0_3), .D (\values[13] ));
DFF_X1 \values_reg[0][14]  (.Q (\values[0] [14] ), .CK (n_0_3), .D (\values[14] ));
DFF_X1 \values_reg[0][15]  (.Q (\values[0] [15] ), .CK (n_0_3), .D (\values[15] ));
CLKGATETST_X1 \clk_gate_values_reg[0]_reg  (.GCK (n_0_3), .CK (clk), .E (n_0_0), .SE (1'b0 ));
DFF_X1 \values_reg[1][0]  (.Q (\values[1] [0] ), .CK (n_0_2), .D (\values[0] ));
DFF_X1 \values_reg[1][1]  (.Q (\values[1] [1] ), .CK (n_0_2), .D (\values[1] ));
DFF_X1 \values_reg[1][2]  (.Q (\values[1] [2] ), .CK (n_0_2), .D (\values[2] ));
DFF_X1 \values_reg[1][3]  (.Q (\values[1] [3] ), .CK (n_0_2), .D (\values[3] ));
DFF_X1 \values_reg[1][4]  (.Q (\values[1] [4] ), .CK (n_0_2), .D (\values[4] ));
DFF_X1 \values_reg[1][5]  (.Q (\values[1] [5] ), .CK (n_0_2), .D (\values[5] ));
DFF_X1 \values_reg[1][6]  (.Q (\values[1] [6] ), .CK (n_0_2), .D (\values[6] ));
DFF_X1 \values_reg[1][7]  (.Q (\values[1] [7] ), .CK (n_0_2), .D (\values[7] ));
DFF_X1 \values_reg[1][8]  (.Q (\values[1] [8] ), .CK (n_0_2), .D (\values[8] ));
DFF_X1 \values_reg[1][9]  (.Q (\values[1] [9] ), .CK (n_0_2), .D (\values[9] ));
DFF_X1 \values_reg[1][10]  (.Q (\values[1] [10] ), .CK (n_0_2), .D (\values[10] ));
DFF_X1 \values_reg[1][11]  (.Q (\values[1] [11] ), .CK (n_0_2), .D (\values[11] ));
DFF_X1 \values_reg[1][12]  (.Q (\values[1] [12] ), .CK (n_0_2), .D (\values[12] ));
DFF_X1 \values_reg[1][13]  (.Q (\values[1] [13] ), .CK (n_0_2), .D (\values[13] ));
DFF_X1 \values_reg[1][14]  (.Q (\values[1] [14] ), .CK (n_0_2), .D (\values[14] ));
DFF_X1 \values_reg[1][15]  (.Q (\values[1] [15] ), .CK (n_0_2), .D (\values[15] ));
CLKGATETST_X1 \clk_gate_values_reg[1]_reg  (.GCK (n_0_2), .CK (clk), .E (n_0_1), .SE (1'b0 ));

endmodule //Neuron_Layer

