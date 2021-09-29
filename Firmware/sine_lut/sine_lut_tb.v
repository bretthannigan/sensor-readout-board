///////////////////////////////////////////////////////////////////////////////
// $Author: BH $    $Date: 2020-04-17 $    $Revision: 0 $
//
// Module: sine_lut_tb.v
// Project: iCESDM (Sigma Delta Modulator for Lattice iCE40)
// Description: Test bench for sine wave LUT.
//
// Change history: 2020-04-17 Created file.
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ns
`include "sine_lut.v"
module sine_lut_tb();

reg clk, rst, en;
reg [7:0] phase;
wire [7:0] dout_sin, dout_cos;

sine_lut #(
    .I_WIDTH(8),
    .O_WIDTH(8)
) DUT (
    .i_clk(clk),
    .i_rst(rst),
    .i_en(en),
    .i_phase(phase),
    .o_sin(dout_sin),
    .o_cos(dout_cos)
);

always
#10 clk = ~clk;

always 
#40 phase = phase + 8'b1;

initial
begin
    clk = 0;
    en = 1;
    rst = 0;
    phase = 8'd0;
end

initial 
begin
    #10000 $stop;
end

initial
begin
    $dumpfile("out.vcd");
    $dumpvars(0,DUT);
end
 
initial
$monitor($stime,, rst,, clk,, phase,, dout_sin,, dout_cos);

endmodule