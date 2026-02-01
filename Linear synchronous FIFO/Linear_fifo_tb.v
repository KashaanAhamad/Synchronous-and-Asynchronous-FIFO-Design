`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.02.2026 02:22:58
// Design Name: 
// Module Name: Linear_fifo_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Linear_fifo_tb();

reg [3:0]data_in;
reg clk=0;
reg wr_en,rd_en,rst;
wire [3:0] data_out;
wire full,empty;

Linear_Synchronous_FIFO LSF(.data_out(data_out),.empty(empty),.full(full),.data_in(data_in),
								.reset(rst),.wr_en(wr_en),.rd_en(rd_en),.clk(clk));
								
initial forever #5 clk =~clk;	

initial begin
	$monitor("wr_en=%b,rd_en=%b,data_in=%d",wr_en,rd_en,data_in);
rst=1;
#3 rst=0;
#1 rst=1;

wr_en=1; data_in=1; rd_en=0;
#10 data_in=2;
#10 data_in=3;	
#10 data_in=4;	
#10 data_in=5;	
#10 data_in=6;	
#10 data_in=7;	
#10 data_in=8;

wr_en=0; rd_en=1;
#10 data_in=9;
#10 data_in=10;
#10 data_in=11;		

end						
endmodule
