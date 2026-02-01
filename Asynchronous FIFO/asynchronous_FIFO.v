`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.10.2025 11:52:52
// Design Name: 
// Module Name: asynchronous_FIFO
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


module asynchronous_FIFO(wr_clk,wr_rst,wr_en,data_in,
                            rd_clk,rd_rst,rd_en,data_out,full,empty );
  parameter size=3;
  input wr_clk,rd_clk;
  input wr_rst,wr_en,rd_rst,rd_en;
  input [3:0]data_in;
  reg [2:0]wr_addr,rd_addr;
  
  reg [3:0] wr_ptr,rd_ptr;
  integer max=8;
  
  output reg [3:0] data_out;
  output full,empty;
  
  reg [3:0]mem[0:7];
  
  wire [size:0]gray_wr_ptr, syn_gray_wr_ptr, syn_wr_ptr;
  
  wire [size:0]gray_rd_ptr, syn_gray_rd_ptr, syn_rd_ptr;
  
          Bin_to_Gray bg1(wr_ptr,gray_wr_ptr);
          two_flop_synchronizer Syn1(gray_wr_ptr,rd_clk,syn_gray_wr_ptr); 
          Grey_to_Binary gb1(syn_gray_wr_ptr,syn_wr_ptr);
          
          
          Bin_to_Gray bg2(rd_ptr,gray_rd_ptr);
          two_flop_synchronizer Syn2(gray_rd_ptr,wr_clk,syn_gray_rd_ptr); 
          Grey_to_Binary gb2(syn_gray_rd_ptr,syn_rd_ptr);
          

//memory write and write pointer increment
//Write Block
always @(posedge wr_clk,negedge wr_rst) begin :write_memory_block
if(!wr_rst)
    begin
        wr_addr<=0;
        
    end
else if(wr_en  && !full)
    begin
        wr_addr<=(wr_addr+1)%(max);
        mem[wr_addr[size-1:0]]<=data_in;
    end
end :write_memory_block

always@(posedge wr_clk,negedge wr_rst) begin : wr_pointer_block
if(!wr_rst)
    wr_ptr<=0;
else if((wr_en==1)&&(full!=1))
begin
    wr_ptr<=(wr_ptr+1)%(2*max);
 end
 end : wr_pointer_block
 
 
 //memory read & read pointer increment
 //Read Block
always @(posedge rd_clk,negedge rd_rst) begin :read_memory_block
if(!rd_rst)
    begin
        rd_addr<=0;
    end
else if(rd_en && !empty)
    begin
        data_out<=mem[rd_addr[size-1:0]];
        rd_addr<= (rd_addr +1)% max;
    end
end :read_memory_block

always @(posedge rd_clk,negedge rd_rst)
begin: read_pointer_block
if(!rd_rst)
    rd_ptr<=0;
else if((rd_en==1)&&(empty!=1))
begin
    rd_ptr<=(rd_ptr+1)%(2*max);
end
end:read_pointer_block

//empty generate block and full generate block
         
assign empty=(syn_wr_ptr == rd_ptr)?1:0;
assign full= (wr_ptr =={~(syn_rd_ptr[size]),syn_rd_ptr[size-1:0]})?1:0;

endmodule

//Binary to Gray
module Bin_to_Gray(b_in,g_out);
parameter size=3;
input [size:0]b_in;
output [size:0]g_out;

generate
genvar g;
    for(g=0;g<size;g=g+1)begin
       assign g_out[g]=b_in[g]^b_in[g+1];
     end
endgenerate
assign g_out[size]=b_in[size];
endmodule


// Gray to Binary
module Grey_to_Binary(g_in,b_out);
parameter size=3;

input [size:0] g_in;
output [size:0] b_out;
genvar i;
generate

    for(i=0;i<=size;i=i+1) begin
        assign b_out[i]= ^(g_in[size:i]);
    end
 endgenerate

endmodule

// 2 Flop Synchronizer
module two_flop_synchronizer #(parameter size =3)(in,clk,out);
//parameter size=3;
input [size:0] in;
input clk;
output reg [size:0] out;
reg [size:0]q;

always@(posedge clk)
	begin
		q<=in;
		out<=q;
	end
endmodule
