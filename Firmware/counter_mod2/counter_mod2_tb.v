///////////////////////////////////////////////////////////////////////////////
// $Author: BH $    $Date: 2018-11-05 $    $Revision: 0 $
//
// Module: counter_mod2_tb.v
// Project: iCESDM (Sigma Delta Modulator for Lattice iCE40)
// Description: Test bench for arbitrary 2^n counter register.
//
// Change history: 2018-11-05 Created file.
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ns
`include "counter_mod2.v"
module counter_mod2_tb();
 
reg clk, rst, up, ld, en;
reg [7:0] din;
wire [7:0] dout;
 
counter_mod2 #(
    .WIDTH(8)
) DUT (
    .i_clk(clk),
    .i_en(en),
    .i_rst(rst),
    .i_up(up),
    .i_ld(ld),
    .i_data(din),
    .o_data(dout)
);
 
always
#10 clk = ~clk;
 
initial
begin
    clk = 0;
    en = 1'b1;
    rst = 0;
    din = 8'hFE;
    up = 1'b0;
    ld = 1'b0;
    #50 ld = 1'b1;
    #60 ld = 0;
    #20 up = 1'b1;
    #15 en = 0;
    #35 rst = 1'b1;
end
 
initial 
begin
    #400 $stop;
end
 
initial
begin
    $dumpfile("out.vcd");
    $dumpvars(0,DUT);
end
 
initial
$monitor($stime,, rst,, clk,,, din,, ld,, dout);
 
endmodule