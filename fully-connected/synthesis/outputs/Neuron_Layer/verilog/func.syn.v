/*
 * Created by 
   ../bin/Linux-x86_64-O/oasysGui 19.2-p002 on Thu May  6 01:21:53 2021
 * (C) Mentor Graphics Corporation
 */
/* CheckSum: 1279483142 */

module Neuron_Layer(clk, load_en, load_value, load_address, reset, \values[0] , 
      \values[1] );
   input clk;
   input load_en;
   input [15:0]load_value;
   input [15:0]load_address;
   input reset;
   output [15:0]\values[0] ;
   output [15:0]\values[1] ;

   wire n_0_2;
   wire n_0_3;
   wire [15:0]values;
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

   CLKGATETST_X1 \clk_gate_values_reg[1]_reg  (.CK(clk), .E(n_0_1), .SE(1'b0), 
      .GCK(n_0_2));
   DFF_X1 \values_reg[1][15]  (.D(values[15]), .CK(n_0_2), .Q(\values[1] [15]), 
      .QN());
   DFF_X1 \values_reg[1][14]  (.D(values[14]), .CK(n_0_2), .Q(\values[1] [14]), 
      .QN());
   DFF_X1 \values_reg[1][13]  (.D(values[13]), .CK(n_0_2), .Q(\values[1] [13]), 
      .QN());
   DFF_X1 \values_reg[1][12]  (.D(values[12]), .CK(n_0_2), .Q(\values[1] [12]), 
      .QN());
   DFF_X1 \values_reg[1][11]  (.D(values[11]), .CK(n_0_2), .Q(\values[1] [11]), 
      .QN());
   DFF_X1 \values_reg[1][10]  (.D(values[10]), .CK(n_0_2), .Q(\values[1] [10]), 
      .QN());
   DFF_X1 \values_reg[1][9]  (.D(values[9]), .CK(n_0_2), .Q(\values[1] [9]), 
      .QN());
   DFF_X1 \values_reg[1][8]  (.D(values[8]), .CK(n_0_2), .Q(\values[1] [8]), 
      .QN());
   DFF_X1 \values_reg[1][7]  (.D(values[7]), .CK(n_0_2), .Q(\values[1] [7]), 
      .QN());
   DFF_X1 \values_reg[1][6]  (.D(values[6]), .CK(n_0_2), .Q(\values[1] [6]), 
      .QN());
   DFF_X1 \values_reg[1][5]  (.D(values[5]), .CK(n_0_2), .Q(\values[1] [5]), 
      .QN());
   DFF_X1 \values_reg[1][4]  (.D(values[4]), .CK(n_0_2), .Q(\values[1] [4]), 
      .QN());
   DFF_X1 \values_reg[1][3]  (.D(values[3]), .CK(n_0_2), .Q(\values[1] [3]), 
      .QN());
   DFF_X1 \values_reg[1][2]  (.D(values[2]), .CK(n_0_2), .Q(\values[1] [2]), 
      .QN());
   DFF_X1 \values_reg[1][1]  (.D(values[1]), .CK(n_0_2), .Q(\values[1] [1]), 
      .QN());
   DFF_X1 \values_reg[1][0]  (.D(values[0]), .CK(n_0_2), .Q(\values[1] [0]), 
      .QN());
   CLKGATETST_X1 \clk_gate_values_reg[0]_reg  (.CK(clk), .E(n_0_0), .SE(1'b0), 
      .GCK(n_0_3));
   DFF_X1 \values_reg[0][15]  (.D(values[15]), .CK(n_0_3), .Q(\values[0] [15]), 
      .QN());
   DFF_X1 \values_reg[0][14]  (.D(values[14]), .CK(n_0_3), .Q(\values[0] [14]), 
      .QN());
   DFF_X1 \values_reg[0][13]  (.D(values[13]), .CK(n_0_3), .Q(\values[0] [13]), 
      .QN());
   DFF_X1 \values_reg[0][12]  (.D(values[12]), .CK(n_0_3), .Q(\values[0] [12]), 
      .QN());
   DFF_X1 \values_reg[0][11]  (.D(values[11]), .CK(n_0_3), .Q(\values[0] [11]), 
      .QN());
   DFF_X1 \values_reg[0][10]  (.D(values[10]), .CK(n_0_3), .Q(\values[0] [10]), 
      .QN());
   DFF_X1 \values_reg[0][9]  (.D(values[9]), .CK(n_0_3), .Q(\values[0] [9]), 
      .QN());
   DFF_X1 \values_reg[0][8]  (.D(values[8]), .CK(n_0_3), .Q(\values[0] [8]), 
      .QN());
   DFF_X1 \values_reg[0][7]  (.D(values[7]), .CK(n_0_3), .Q(\values[0] [7]), 
      .QN());
   DFF_X1 \values_reg[0][6]  (.D(values[6]), .CK(n_0_3), .Q(\values[0] [6]), 
      .QN());
   DFF_X1 \values_reg[0][5]  (.D(values[5]), .CK(n_0_3), .Q(\values[0] [5]), 
      .QN());
   DFF_X1 \values_reg[0][4]  (.D(values[4]), .CK(n_0_3), .Q(\values[0] [4]), 
      .QN());
   DFF_X1 \values_reg[0][3]  (.D(values[3]), .CK(n_0_3), .Q(\values[0] [3]), 
      .QN());
   DFF_X1 \values_reg[0][2]  (.D(values[2]), .CK(n_0_3), .Q(\values[0] [2]), 
      .QN());
   DFF_X1 \values_reg[0][1]  (.D(values[1]), .CK(n_0_3), .Q(\values[0] [1]), 
      .QN());
   DFF_X1 \values_reg[0][0]  (.D(values[0]), .CK(n_0_3), .Q(\values[0] [0]), 
      .QN());
   AND2_X1 i_0_0_0 (.A1(n_0_0_7), .A2(load_value[0]), .ZN(values[0]));
   AND2_X1 i_0_0_1 (.A1(n_0_0_7), .A2(load_value[1]), .ZN(values[1]));
   AND2_X1 i_0_0_2 (.A1(n_0_0_7), .A2(load_value[2]), .ZN(values[2]));
   AND2_X1 i_0_0_3 (.A1(n_0_0_7), .A2(load_value[3]), .ZN(values[3]));
   AND2_X1 i_0_0_4 (.A1(n_0_0_7), .A2(load_value[4]), .ZN(values[4]));
   AND2_X1 i_0_0_5 (.A1(n_0_0_7), .A2(load_value[5]), .ZN(values[5]));
   AND2_X1 i_0_0_6 (.A1(n_0_0_7), .A2(load_value[6]), .ZN(values[6]));
   AND2_X1 i_0_0_7 (.A1(n_0_0_7), .A2(load_value[7]), .ZN(values[7]));
   AND2_X1 i_0_0_8 (.A1(n_0_0_7), .A2(load_value[8]), .ZN(values[8]));
   AND2_X1 i_0_0_9 (.A1(n_0_0_7), .A2(load_value[9]), .ZN(values[9]));
   AND2_X1 i_0_0_10 (.A1(n_0_0_7), .A2(load_value[10]), .ZN(values[10]));
   AND2_X1 i_0_0_11 (.A1(n_0_0_7), .A2(load_value[11]), .ZN(values[11]));
   AND2_X1 i_0_0_12 (.A1(n_0_0_7), .A2(load_value[12]), .ZN(values[12]));
   AND2_X1 i_0_0_13 (.A1(n_0_0_7), .A2(load_value[13]), .ZN(values[13]));
   AND2_X1 i_0_0_14 (.A1(n_0_0_7), .A2(load_value[14]), .ZN(values[14]));
   AND2_X1 i_0_0_15 (.A1(n_0_0_7), .A2(load_value[15]), .ZN(values[15]));
   OAI21_X1 i_0_0_16 (.A(n_0_0_7), .B1(n_0_0_0), .B2(load_address[0]), .ZN(n_0_0));
   OAI21_X1 i_0_0_17 (.A(n_0_0_7), .B1(n_0_0_5), .B2(n_0_0_0), .ZN(n_0_1));
   NAND4_X1 i_0_0_18 (.A1(n_0_0_4), .A2(n_0_0_3), .A3(n_0_0_2), .A4(n_0_0_1), 
      .ZN(n_0_0_0));
   NOR4_X1 i_0_0_19 (.A1(load_address[13]), .A2(load_address[12]), .A3(
      load_address[11]), .A4(load_address[10]), .ZN(n_0_0_1));
   NOR4_X1 i_0_0_20 (.A1(n_0_0_6), .A2(load_address[15]), .A3(load_address[14]), 
      .A4(load_address[9]), .ZN(n_0_0_2));
   NOR4_X1 i_0_0_21 (.A1(load_address[5]), .A2(load_address[4]), .A3(
      load_address[3]), .A4(load_address[2]), .ZN(n_0_0_3));
   NOR4_X1 i_0_0_22 (.A1(load_address[8]), .A2(load_address[7]), .A3(
      load_address[6]), .A4(load_address[1]), .ZN(n_0_0_4));
   INV_X1 i_0_0_23 (.A(load_address[0]), .ZN(n_0_0_5));
   INV_X1 i_0_0_24 (.A(load_en), .ZN(n_0_0_6));
   INV_X1 i_0_0_25 (.A(reset), .ZN(n_0_0_7));
endmodule
