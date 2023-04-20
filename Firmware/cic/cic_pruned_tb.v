///////////////////////////////////////////////////////////////////////////////
// $Author: BH $    $Date: 2020-10-20 $    $Revision: 0 $
//
// Module: CIC_pruned_tb.v
// Project: iCESDM (Sigma Delta Modulator for Lattice iCE40)
// Description: Test bench for pruned cascaded integrator comb filter.
//
// Change history:  2020-06-01 Created file.
//
// ©2023 ETH Zurich, Brett Hannigan; D-HEST; Biomedical and Mobile Health Technology (BMHT) Lab; Carlo Menon
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ns
`include "cic_pruned.v"
module cic_pruned_tb();

reg clk, en, rst, test;
reg [15:0] sd;
wire s_clk;
wire [7:0] data;
wire [15:0] data_long;

cic_pruned #(
    .I_WIDTH(16),
    .ORDER(3),
    .DECIMATION_BITS(16),
    .REG_WIDTHS({8'd16, 8'd18, 8'd19, 8'd20, 8'd27, 8'd42, 8'd57})
    ) DUT (
    .i_clk(clk),
    .i_en(en),
    .i_rst(rst),
    .i_data(sd),
    .o_data(data_long),
    .o_clk(s_clk)
);

always
#10 clk = ~clk;

// always 
// begin
// #20 sd = 1;
// #20 sd = -1;
// end

initial
begin
    clk = 0;
    rst = 1;
    en = 1;
    sd = 0;
    #40 rst = 0;
    sd = 0;
    #4820
    sd = 1;
    #20
    sd = 0; // Impulse response: 16'h01B3, 16'h024A, 16'h0003
    #8930
    sd = 1; // Step response: 16'h1360, 16'h68A0, 16'h8000
end

initial
begin
    #200000 $stop;
end

initial
begin
    $dumpfile("out.vcd");
    $dumpvars(0,DUT);
end

 initial
 $monitor($stime,, rst,, en,, clk,, data,, sd);

endmodule