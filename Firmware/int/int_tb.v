///////////////////////////////////////////////////////////////////////////////
// $Author: BH $    $Date: 2020-06-25 $    $Revision: 0 $
//
// Module: int_tb.v
// Project: iCESDM (Sigma Delta Modulator for Lattice iCE40)
// Description: Test bench for integrator.
//
// Change history:  2020-06-25 Created file.
//
// ©2023 ETH Zurich, Brett Hannigan; D-HEST; Biomedical and Mobile Health Technology (BMHT) Lab; Carlo Menon
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ns
`include "int.v"
module int_tb();
 
reg clk, en, rst;
reg [7:0] x;
wire [8:0] y;
 
int #(
    .I_WIDTH(8)
) DUT (
    .i_clk(clk),
    .i_en(en),
    .i_rst(rst),
    .i_x(x),s
    .o_y(y)
);
 
always
#10 clk = ~clk;
 
initial
begin
    clk = 0;
    en = 1;
    rst = 1;
    x = 8'h01;
    #60 rst = 0;
    #200 x = 8'h00;
    #40 x = 8'h0F;
end
 
initial 
begin
    #1000 $stop;
end
 
initial
begin
    $dumpfile("out.vcd");
    $dumpvars(0,DUT);
end
 
initial
$monitor($stime,, rst,, clk,,, x,, y);
 
endmodule