///////////////////////////////////////////////////////////////////////////////
// $Author: BH $    $Date: 2018-11-05 $    $Revision: 0 $
//
// Module: counter_modn_tb.v
// Project: iCESDM (Sigma Delta Modulator for Lattice iCE40)
// Description: Test bench for arbitrary counter register.
//
// Change history: 2020-06-26 Created file.
//
// ©2023 ETH Zurich, Brett Hannigan; D-HEST; Biomedical and Mobile Health Technology (BMHT) Lab; Carlo Menon
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ns
`include "counter_modn.v"
module counter_modn_tb();
 
reg clk, rst, ld, en;
reg [7:0] din;
wire [7:0] dout;
 
counter_modn #(
    .WIDTH(8),
    .N(21)
) DUT (
    .i_clk(clk),
    .i_en(en),
    .i_rst(rst),
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
    din = 8'b0;
    ld = 1'b0;
    #50 ld = 1'b1;
    #60 ld = 0;
    #1005 en = 0;
    #35 rst = 1'b1;
end
 
initial 
begin
    #1200 $stop;
end
 
initial
begin
    $dumpfile("out.vcd");
    $dumpvars(0,DUT);
end
 
initial
$monitor($stime,, rst,, clk,,, din,, ld,, dout);
 
endmodule