`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.10.2025 
// Design Name: 
// Module Name: Linear_Synchronous_FIFO
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


module Linear_Synchronous_FIFO(data_out,empty,full,data_in,reset,wr_en,rd_en,clk );
//Outputs
output reg [3:0]data_out;
output  empty,full;
//Input
input [3:0]data_in;
input reset,wr_en,rd_en,clk;

reg [2:0]wr_ptr,rd_ptr;
//Memory 
reg [3:0]mem[7:0]; 

//write block
always @(posedge clk ,negedge reset)
begin
if(!reset)
    wr_ptr<=0;
else if(!full && wr_en)
    begin
        wr_ptr<= wr_ptr+1;
        mem[wr_ptr]<=data_in;
    end
end

//Read Block
always @(posedge clk ,negedge reset)
begin
if(!reset)
    rd_ptr<=0;
else if(!empty && rd_en)
    begin
        data_out<= mem[rd_ptr];
        rd_ptr<=rd_ptr+1;
    end
end
//Full and Empty Conditions
//assign full=wr_ptr>7?1:0;
assign full=(wr_ptr==3'd7)?1:0;
assign empty=(rd_ptr ==wr_ptr)?1:0;

endmodule
