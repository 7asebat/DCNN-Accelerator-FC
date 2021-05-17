module Decompress (DataIn, DataOut,clk);
    input [15:0]  DataIn;       //20
    output reg [15:0] DataOut;
    input clk;
    reg CurrentDigit = 0;
    reg x =0;
    integer i = 0;
    reg [15:0] Remain;
    reg [15:0] Result;

    always@(clk) begin
        if(x==0) begin
            Remain = DataIn;
            x=1;
        end
        if(Remain>16) begin
            Remain = Remain -16;
            //x=16;
            DataOut = {16{CurrentDigit}} ;
        end
        else if(Remain >0)begin 
            //x=Remain;
            //DataOut = {Remain{CurrentDigit}} ;
            for (i = 0; i < Remain; i = i+1) begin
		        DataOut[i] = CurrentDigit ;
            end 
            Remain =0;
        end
        else begin
            CurrentDigit = !(CurrentDigit);
            x=0;
            i=0;
        end
    end
    //assign DataOut = Result ;
    //assign out = Result;*      
endmodule

/*
Sending 20 zeros takes 3 clock cycles instead of 2 ??
*/





/*

vsim -gui work.Decompress
# End time: 03:54:42 on May 17,2021, Elapsed time: 0:00:24
# Errors: 0, Warnings: 0
# vsim -gui work.Decompress 
# Start time: 03:54:42 on May 17,2021
# Loading work.Decompress
# End time: 03:51:18 on May 17,2021, Elapsed time: 0:01:20
# Errors: 0, Warnings: 0
# vsim -gui work.Decompress 
# Start time: 03:51:18 on May 17,2021
# Loading work.Decompress
# vsim -gui work.Decompress 
# Start time: 03:46:04 on May 17,2021
# Loading work.Decompress
add wave -position insertpoint  \
sim:/Decompress/DataIn \
sim:/Decompress/DataOut \
sim:/Decompress/clk \
sim:/Decompress/CurrentDigit \
sim:/Decompress/i \
sim:/Decompress/n \
sim:/Decompress/Remain
force -freeze sim:/Decompress/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/Decompress/DataIn 16'd20 0
run
run
run

*/