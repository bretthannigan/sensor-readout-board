///////////////////////////////////////////////////////////////////////////////
// $Author: BH $    $Date: 2022-02-09 $    $Revision: 0 $
//
// Module: sine_lut2_tb.v
// Project: iCESDM (Sigma Delta Modulator for Lattice iCE40)
// Description: Test bench for comparing sine wave LUT with and without separate quarter-wave logic.
//
// Change history: 2022-02-09 Created file.
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ns
`include "sine_lut_old.v"
`include "sine_lut.v"
module sine_lut_tb2();

reg clk, rst, en;
reg [10:0] phase;
wire [15:0] dout_sin, dout_cos, dout_sin2, dout_cos2;;

sine_lut #(
    .I_WIDTH(11),
    .O_WIDTH(16),
    .LOAD_PATH("quarterwave_11_16_5.hex")
) DUT1 (
    .i_clk(clk),
    .i_rst(rst),
    .i_en(en),
    .i_phase(phase),
    .o_sin(dout_sin),
    .o_cos(dout_cos)
);

sine_lut2 #(
    .I_WIDTH(11),
    .O_WIDTH(16),
    .LOAD_PATH("quarterwave_11_16_5.hex")
) DUT2 (
    .i_clk(clk),
    .i_rst(rst),
    .i_en(en),
    .i_phase(phase),
    .o_sin(dout_sin2),
    .o_cos(dout_cos2)
);

always
#10 clk = ~clk;

always 
#40 phase = phase + 11'd2;

initial
begin
    clk = 0;
    en = 1;
    rst = 0;
    phase = 11'd0;
end

initial 
begin
    #60000 $stop;
end

initial
begin
    $dumpfile("out.vcd");
    $dumpvars(0);
end
 
initial
$monitor($stime,, rst,, clk,, phase,, dout_sin,, dout_cos);

endmodule