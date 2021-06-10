/*
 * Created by 
   ../bin/Linux-x86_64-O/oasysGui 19.2-p002 on Wed May  5 23:11:33 2021
 * (C) Mentor Graphics Corporation
 */
/* CheckSum: 957267170 */

module Softmax(\values[0] , \values[1] , class_out);
   input [15:0]\values[0] ;
   input [15:0]\values[1] ;
   output [15:0]class_out;

   wire n_0_0_0;
   wire n_0_0_1;
   wire n_0_0_2;
   wire n_0_0_3;
   wire n_0_0_4;
   wire n_0_0_5;
   wire n_0_0_6;
   wire n_0_0_7;
   wire n_0_0_8;
   wire n_0_0_9;
   wire n_0_0_10;
   wire n_0_0_11;
   wire n_0_0_12;
   wire n_0_0_13;
   wire n_0_0_14;
   wire n_0_0_15;
   wire n_0_0_16;
   wire n_0_0_17;
   wire n_0_0_18;
   wire n_0_0_19;
   wire n_0_0_20;
   wire n_0_0_21;
   wire n_0_0_22;
   wire n_0_0_23;
   wire n_0_0_24;
   wire n_0_0_25;
   wire n_0_0_26;
   wire n_0_0_27;
   wire n_0_0_28;
   wire n_0_0_29;
   wire n_0_0_30;
   wire n_0_0_31;
   wire n_0_0_32;
   wire n_0_0_33;
   wire n_0_0_34;
   wire n_0_0_35;
   wire n_0_0_36;
   wire n_0_0_37;
   wire n_0_0_38;
   wire n_0_0_39;
   wire n_0_0_40;
   wire n_0_0_41;
   wire n_0_0_42;
   wire n_0_0_43;
   wire n_0_0_44;
   wire n_0_0_45;

   assign class_out[15] = class_out[1];
   assign class_out[14] = class_out[1];
   assign class_out[13] = class_out[1];
   assign class_out[12] = class_out[1];
   assign class_out[11] = class_out[1];
   assign class_out[10] = class_out[1];
   assign class_out[9] = class_out[1];
   assign class_out[8] = class_out[1];
   assign class_out[7] = class_out[1];
   assign class_out[6] = class_out[1];
   assign class_out[5] = class_out[1];
   assign class_out[4] = class_out[1];
   assign class_out[3] = class_out[1];
   assign class_out[2] = class_out[1];

   NAND2_X1 i_0_0_0 (.A1(n_0_0_5), .A2(n_0_0_0), .ZN(class_out[0]));
   NOR2_X1 i_0_0_1 (.A1(n_0_0_6), .A2(n_0_0_0), .ZN(class_out[1]));
   NAND4_X1 i_0_0_2 (.A1(n_0_0_4), .A2(n_0_0_3), .A3(n_0_0_2), .A4(n_0_0_1), 
      .ZN(n_0_0_0));
   NOR4_X1 i_0_0_3 (.A1(\values[0] [7]), .A2(\values[0] [6]), .A3(\values[0] [5]), 
      .A4(\values[0] [4]), .ZN(n_0_0_1));
   NOR4_X1 i_0_0_4 (.A1(\values[0] [3]), .A2(\values[0] [2]), .A3(\values[0] [1]), 
      .A4(\values[0] [0]), .ZN(n_0_0_2));
   AND4_X1 i_0_0_5 (.A1(\values[0] [15]), .A2(n_0_0_45), .A3(n_0_0_44), .A4(
      n_0_0_43), .ZN(n_0_0_3));
   NOR4_X1 i_0_0_6 (.A1(\values[0] [11]), .A2(\values[0] [10]), .A3(
      \values[0] [9]), .A4(\values[0] [8]), .ZN(n_0_0_4));
   INV_X1 i_0_0_7 (.A(n_0_0_6), .ZN(n_0_0_5));
   AOI21_X1 i_0_0_8 (.A(n_0_0_7), .B1(n_0_0_9), .B2(n_0_0_8), .ZN(n_0_0_6));
   NOR2_X1 i_0_0_9 (.A1(\values[0] [15]), .A2(n_0_0_34), .ZN(n_0_0_7));
   AOI22_X1 i_0_0_10 (.A1(n_0_0_45), .A2(\values[1] [14]), .B1(\values[0] [15]), 
      .B2(n_0_0_34), .ZN(n_0_0_8));
   OAI221_X1 i_0_0_11 (.A(n_0_0_10), .B1(n_0_0_44), .B2(\values[1] [13]), 
      .C1(n_0_0_45), .C2(\values[1] [14]), .ZN(n_0_0_9));
   NAND2_X1 i_0_0_12 (.A1(n_0_0_12), .A2(n_0_0_11), .ZN(n_0_0_10));
   AOI22_X1 i_0_0_13 (.A1(n_0_0_43), .A2(\values[1] [12]), .B1(n_0_0_44), 
      .B2(\values[1] [13]), .ZN(n_0_0_11));
   OAI21_X1 i_0_0_14 (.A(n_0_0_13), .B1(n_0_0_43), .B2(\values[1] [12]), 
      .ZN(n_0_0_12));
   OAI21_X1 i_0_0_15 (.A(n_0_0_14), .B1(n_0_0_16), .B2(n_0_0_15), .ZN(n_0_0_13));
   NAND2_X1 i_0_0_16 (.A1(n_0_0_42), .A2(\values[1] [11]), .ZN(n_0_0_14));
   OAI22_X1 i_0_0_17 (.A1(n_0_0_42), .A2(\values[1] [11]), .B1(n_0_0_41), 
      .B2(\values[1] [10]), .ZN(n_0_0_15));
   AOI221_X1 i_0_0_18 (.A(n_0_0_17), .B1(n_0_0_41), .B2(\values[1] [10]), 
      .C1(n_0_0_40), .C2(\values[1] [9]), .ZN(n_0_0_16));
   AOI21_X1 i_0_0_19 (.A(n_0_0_18), .B1(n_0_0_20), .B2(n_0_0_19), .ZN(n_0_0_17));
   OAI22_X1 i_0_0_20 (.A1(n_0_0_39), .A2(\values[1] [8]), .B1(n_0_0_40), 
      .B2(\values[1] [9]), .ZN(n_0_0_18));
   AOI22_X1 i_0_0_21 (.A1(n_0_0_39), .A2(\values[1] [8]), .B1(n_0_0_38), 
      .B2(\values[1] [7]), .ZN(n_0_0_19));
   OAI211_X1 i_0_0_22 (.A(n_0_0_21), .B(n_0_0_22), .C1(n_0_0_38), .C2(
      \values[1] [7]), .ZN(n_0_0_20));
   NAND2_X1 i_0_0_23 (.A1(\values[0] [6]), .A2(n_0_0_33), .ZN(n_0_0_21));
   OAI221_X1 i_0_0_24 (.A(n_0_0_23), .B1(\values[0] [6]), .B2(n_0_0_33), 
      .C1(\values[0] [5]), .C2(n_0_0_32), .ZN(n_0_0_22));
   NAND2_X1 i_0_0_25 (.A1(n_0_0_25), .A2(n_0_0_24), .ZN(n_0_0_23));
   AOI22_X1 i_0_0_26 (.A1(\values[0] [4]), .A2(n_0_0_31), .B1(\values[0] [5]), 
      .B2(n_0_0_32), .ZN(n_0_0_24));
   OAI211_X1 i_0_0_27 (.A(n_0_0_26), .B(n_0_0_27), .C1(\values[0] [4]), .C2(
      n_0_0_31), .ZN(n_0_0_25));
   NAND2_X1 i_0_0_28 (.A1(n_0_0_37), .A2(\values[1] [3]), .ZN(n_0_0_26));
   OAI221_X1 i_0_0_29 (.A(n_0_0_28), .B1(n_0_0_37), .B2(\values[1] [3]), 
      .C1(n_0_0_36), .C2(\values[1] [2]), .ZN(n_0_0_27));
   OAI21_X1 i_0_0_30 (.A(n_0_0_29), .B1(\values[0] [0]), .B2(n_0_0_30), .ZN(
      n_0_0_28));
   AOI22_X1 i_0_0_31 (.A1(n_0_0_36), .A2(\values[1] [2]), .B1(n_0_0_35), 
      .B2(\values[1] [1]), .ZN(n_0_0_29));
   OAI21_X1 i_0_0_32 (.A(\values[1] [0]), .B1(n_0_0_35), .B2(\values[1] [1]), 
      .ZN(n_0_0_30));
   INV_X1 i_0_0_33 (.A(\values[1] [4]), .ZN(n_0_0_31));
   INV_X1 i_0_0_34 (.A(\values[1] [5]), .ZN(n_0_0_32));
   INV_X1 i_0_0_35 (.A(\values[1] [6]), .ZN(n_0_0_33));
   INV_X1 i_0_0_36 (.A(\values[1] [15]), .ZN(n_0_0_34));
   INV_X1 i_0_0_37 (.A(\values[0] [1]), .ZN(n_0_0_35));
   INV_X1 i_0_0_38 (.A(\values[0] [2]), .ZN(n_0_0_36));
   INV_X1 i_0_0_39 (.A(\values[0] [3]), .ZN(n_0_0_37));
   INV_X1 i_0_0_40 (.A(\values[0] [7]), .ZN(n_0_0_38));
   INV_X1 i_0_0_41 (.A(\values[0] [8]), .ZN(n_0_0_39));
   INV_X1 i_0_0_42 (.A(\values[0] [9]), .ZN(n_0_0_40));
   INV_X1 i_0_0_43 (.A(\values[0] [10]), .ZN(n_0_0_41));
   INV_X1 i_0_0_44 (.A(\values[0] [11]), .ZN(n_0_0_42));
   INV_X1 i_0_0_45 (.A(\values[0] [12]), .ZN(n_0_0_43));
   INV_X1 i_0_0_46 (.A(\values[0] [13]), .ZN(n_0_0_44));
   INV_X1 i_0_0_47 (.A(\values[0] [14]), .ZN(n_0_0_45));
endmodule
