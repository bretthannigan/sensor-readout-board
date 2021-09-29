///////////////////////////////////////////////////////////////////////////////
// $Author: BH $    $Date: 2020-10-20 $    $Revision: 0 $
//
// Module: CIC_tb.v
// Project: iCESDM (Sigma Delta Modulator for Lattice iCE40)
// Description: Test bench for cascaded integrator comb filter
// See also: https://www.dsprelated.com/showarticle/1171.php
//
// Change history:  2020-10-20 Created file.
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ns
`include "cic.v"
module cic_tb();

reg clk, en, rst;
wire s_clk;
wire [18:0] data;
wire [7:0] data2;
reg [7:0] sd;

cic #(
    .I_WIDTH(8),
    .ORDER(5),
    .DECIMATION_BITS(2)
    ) DUT (
    .i_clk(clk),
    .i_en(en),
    .i_rst(rst),
    .i_data(sd),
    .o_data(data),
    .o_clk(s_clk)
);

always
#10 clk = ~clk;

// initial
// begin
//     clk = 0;
//     rst = 1;
//     en = 1;
//     sd = 0;
//     // Test 1: impulse response
//     // o_data[1] = (D + S - 1)!/(D!*(S - 1)!) - S
//     // Where D: decimation ratio, S: order
//     // For D=4, S=5: o_data[1] = 0x00041
//     #40 rst = 0;
//     #990 sd = 1;
//     #20 sd = 0;
//     // Test 2: step response
//     // S non-zero samples followed by constant sequence of D^S valued samples
//     // For D=4, S=5: o_data[4] = 0x00400
//     #1000 sd = 1;
// end

initial
begin
    clk = 0;
    rst = 1;
    en = 1;
    sd = 0;
    // Test 1: impulse response
    // o_data[1] = (D + S - 1)!/(D!*(S - 1)!) - S
    // Where D: decimation ratio, S: order
    // For D=4, S=5: o_data[1] = 0x00041
    #40 rst = 0;
    #990 sd = 8'h7f;
end

initial
begin
    #4000 $stop;
end

initial
begin
    $dumpfile("out.vcd");
    $dumpvars(0,DUT);
end

 initial
 $monitor($stime,, rst,, en,, clk,, data,, sd);

endmodule