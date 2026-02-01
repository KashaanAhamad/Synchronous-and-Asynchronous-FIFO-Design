`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.10.2025 12:47:15
// Design Name: 
// Module Name: async_FIFO_tb
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


module async_FIFO_tb();

reg rd_clk=0;
    reg wr_clk=0;
    reg [3:0] data_in;
    reg wr_en,rd_en;
    reg wr_rst,rd_rst;
    
    wire empty,full;
    wire [3:0] data_out;
    
    asynchronous_FIFO SFTE(wr_clk,wr_rst,wr_en,data_in
                                ,rd_clk,rd_rst,rd_en,data_out,full,empty);
                                
    initial 
        forever #2 rd_clk=~rd_clk;
        
    initial
        forever #5 wr_clk=~wr_clk;
        
 initial
    begin
    wr_en=1;
    rd_en=0;
    #20 rd_en=1;
    #20 rd_en=0; wr_en=1;
    #20 rd_en=1; wr_en=1;
    #20 rd_en=1; wr_en=0;
 end
 
 initial
 begin
    wr_rst=0;rd_rst=0;
    #1 wr_rst=1; rd_rst=1;
 end
 
 initial
    begin
        $monitor("time=%d ,data_in=%d write_en=%d , read_en=%d , data_out=%d, full=%d, empty=%d",$time,data_in,wr_en,rd_en,data_out,full, empty);
        #4 data_in=0;
        #30 data_in=11;
        #11 data_in =6;
        #10 data_in=5;
                #10 data_in=9;
                #10 data_in=11;
                #10 data_in=11;
                #10 data_in=8;
                #10 data_in=2;
                #10 data_in=3;
                #10 data_in=13;
                #10 data_in=11;
                #10 data_in=5;
            #10 data_in=6;
                #10 data_in=9;
                #10 data_in=7;
                #10 data_in=5;
              #10 data_in=11;
                #10 data_in=8;
                #10 data_in=2;
                #10 data_in=3;
                #10 data_in=13;
                 
    end
endmodule
