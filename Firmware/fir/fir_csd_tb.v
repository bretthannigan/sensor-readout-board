///////////////////////////////////////////////////////////////////////////////
// $Author: BH $    $Date: 2021-12-01 $    $Revision: 0 $
//
// Module: fir_csd_tb.v
// Project: iCESDM (Sigma Delta Modulator for Lattice iCE40)
// Description: Test bench for multiplierless FIR filter.
//
// Change history: 2021-12-01 Created file.
//
// ©2023 ETH Zurich, Brett Hannigan; D-HEST; Biomedical and Mobile Health Technology (BMHT) Lab; Carlo Menon
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ns
`include "fir_csd_logic_varcoef.v"
`include "../shift/shift.v"
module fir_csd_tb();

reg clk, rst, en;
reg [15:0] din;
wire full, empty;
wire [23:0] dout;
wire [(16*17-1):0] delay;

shift #(
    .WIDTH(16),
    .LENGTH(17)
) delay_line (
    .i_clk(clk),
    .i_en(en),
    .i_rst(rst),
    .i_data(din),
    .o_par(delay)
);

fir_csd_logic_varcoef #(
    .I_WIDTH(16),
    .O_WIDTH(24),
    .ORDER(17),
    .N_SHIFT(9)
) DUT (
    .i_clk(clk),
    .i_en(en),
    .i_data(delay),
    .o_data(dout)
);

always
#10 clk = ~clk;

initial
begin
    clk = 0;
    en = 1;
    rst = 0;
    din=16'h0000;
    #400 din=16'h0001;
end

initial 
begin
    #10000 $stop;
end

initial
begin
    $dumpfile("out.vcd");
    $dumpvars(0);
end
 
initial
$monitor($stime,, rst,, clk,, din);

endmodule