///////////////////////////////////////////////////////////////////////////////
// $Author: BH $    $Date: 2020-06-26 $    $Revision: 1 $
//
// Module: dff_tb.v
// Project: iCESDM (Sigma Delta Modulator for Lattice iCE40)
// Description: Test bench for D flip-flop.
//
// Change history:  2020-06-26 Created file.
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ns
`include "dff.v"
module dff_tb();
 
reg clk, rst;
reg [7:0] d;
wire [7:0] q;
 
dff #(
    .WIDTH(8)
) DUT (
    .i_clk(clk),
    .i_rst(rst),
    .i_d(d),
    .o_q(q)
);
 
 always 
 #10 clk = ~clk;

 initial 
 begin
    clk = 0;
    rst = 1;
    d = 8'h2A;
    #40 rst = 0;
    #40 d = 8'h5E;
    #20 d = 8'hCF;
    #5 rst = 1;
    #15 d = 8'h09;
    #20 d = 8'h44;
    rst = 0;
    #40 d = 8'hFF;
    #10 d = 8'h00;
 end

 initial 
 begin
    #200 $stop;
 end

 initial
 begin
    $dumpfile("out.vcd");
    $dumpvars(0,DUT);
 end

 initial
 $monitor($stime,, rst,, clk,,, d,, q);

endmodule