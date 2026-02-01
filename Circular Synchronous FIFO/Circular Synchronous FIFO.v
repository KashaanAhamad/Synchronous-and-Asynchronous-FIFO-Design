`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.10.2025 13:04:05
// Design Name: 
// Module Name: Circular_Synchronous_FIFO
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


module Circular_Synchronous_FIFO(data_out,empty,full,data_in,reset,wr_en,rd_en,clk  );
`define MAX 8
//Outputs
output reg [3:0]data_out;
output  empty,full;
//Inputs
input [3:0]data_in;
input reset,wr_en,rd_en,clk;

reg [3:0] wr_ptr,rd_ptr;
//Memory
reg [3:0]mem[7:0];
reg [3:0] count;

//Empty and Full Condition
assign full= (count == `MAX && wr_ptr ==rd_ptr);
assign empty = (count ==0 && wr_ptr == rd_ptr);

//Count Handler
always @(posedge clk,negedge reset)
begin
    if(!reset) count<=0;
    else if (wr_en && !rd_en && count<`MAX)
    	count<= count+1;
    else if(!wr_en && rd_en && count >0)
    	count<= count-1;
end
//Write Block   
always@(posedge clk,negedge reset) 
begin
    if(!reset) begin
    	wr_ptr<=0;
    end
    else if(wr_en &full==0)
    begin
    	mem[wr_ptr]<=data_in;
    	wr_ptr<=(wr_ptr+1)%`MAX;
    end
end
//Read Block    
always @(posedge clk,negedge reset)
begin
    if(!reset)begin
    	rd_ptr<=0;
    end
    else if(rd_en &empty==0)
    begin
    	data_out<= mem[rd_ptr];
    	rd_ptr<=(rd_ptr +1)% `MAX;
    end
end
endmodule
