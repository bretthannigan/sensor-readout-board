///////////////////////////////////////////////////////////////////////////////
// $Author: BH $    $Date: 2021-03-09 $    $Revision: 0 $
//
// Module: fifo_tb.v
// Project: iCESDM (Sigma Delta Modulator for Lattice iCE40)
// Description: Test bench for first-in-first-out queue.
//
// Change history: 2021-03-09 Created file.
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ns
`include "fifo.v"
module fifo_tb();

reg clk, rst, en, wr, rd;
reg [7:0] din;
wire full, empty;
wire [7:0] dout;

fifo #(
    .DATA_WIDTH(8),
    .ADDR_WIDTH(2),
    .OVERWRITE_OLD(0)
) DUT (
    .i_clk(clk),
    .i_en(en),
    .i_rst(rst),
    .i_wr(wr),
    .i_rd(rd),
    .i_data(din),
    .o_full(full),
    .o_empty(empty),
    .o_data(dout)
);

always
#10 clk = ~clk;

initial
begin
    clk = 0;
    en = 1;
    rst = 0;
    din = 8'h11;
    rd = 1;
    wr = 0;
    #20 din = 8'h12;
    #20 din = 8'h13;
    #20 din = 8'h14;
    rd = 0;
    #20 din = 8'h15;
    wr = 1;
    #20 din = 8'h16;
    #20 din = 8'h17;
    #20 din = 8'h18;
    #20 din = 8'h19;
    #20 din = 8'h1a;
    rd = 1;
    #20 din = 8'h1b;
    #20 din = 8'h1c;
    wr = 0;
end

initial 
begin
    #2000 $stop;
end

initial
begin
    $dumpfile("out.vcd");
    $dumpvars(0,DUT);
end
 
initial
$monitor($stime,, rst,, clk,, din);

endmodule