///////////////////////////////////////////////////////////////////////////////
// $Author: BH $    $Date: 2020-10-20 $    $Revision: 0 $
//
// Module: CIC_tb2.v
// Project: iCESDM (Sigma Delta Modulator for Lattice iCE40)
// Description: Test bench for cascaded integrator comb filter with (1, 3, 5) configuration.
//
// Change history:  2020-10-25 Created file.
//                  2021-05-26 Tested against MATLAB dsp.CICDecimator(32,1,3,'FixedPointDataType','Specify word lengths','SectionWordLengths',[16 16 16],'OutputWordLength',16).
//                             Seems to be correct for impulse and step responses.
//                             Decimated impulse and step responses are sensitive to starting point. Must begin step/impulse at next rising edge of clk after dec_clk goes high.
//
// ©2023 ETH Zurich, Brett Hannigan; D-HEST; Biomedical and Mobile Health Technology (BMHT) Lab; Carlo Menon
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ns
`include "cic.v"
module cic_tb();

reg clk, en, rst, test;
reg [1:0] sd;
wire s_clk;
wire [7:0] data;
wire [23:0] data_long;

cic #(
    .I_WIDTH(2),
    .ORDER(3),
    .DECIMATION_BITS(5)
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
    #50000 $stop;
end

initial
begin
    $dumpfile("out.vcd");
    $dumpvars(0,DUT);
end

 initial
 $monitor($stime,, rst,, en,, clk,, data,, sd);

endmodule