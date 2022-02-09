///////////////////////////////////////////////////////////////////////////////
// $Author: BH $    $Date: 2021-11-04 $    $Revision: 0 $
//
// Module: dsp_tb.v
// Project: iCESDM (Sigma Delta Modulator for Lattice iCE40)
// Description: Test bench for sensor readout board DSP.
// 
//
// Change history:  2020-11-04 Created file.
//
///////////////////////////////////////////////////////////////////////////////

`timescale 10ns/1ns

`include "../counter_mod2/counter_mod2.v"
`include "../sine_lut/sine_lut.v"
`include "../psd_mixer/psd_mixer.v"
`include "../cic/cic_comb.v"
`define __CIC_COMB_INCLUDE__
`include "../cic/cic.v"

module dsp_tb();

reg clk, en, rst, sd;
wire[15:0] clkdiv;

counter_mod2 #(
	.WIDTH(16)
) clk25_divider (
	.i_clk(clk),
	.i_en(en),
	.i_rst(rst),
	.i_up(1'b1),
	.i_ld(1'b0),
	.o_data(clkdiv)
);

wire[10:0] phase;
wire[15:0] sin;
wire[15:0] cos;
assign sclk = clkdiv[1];
assign phase = clkdiv[12:2];

sine_lut #(
	.I_WIDTH(11),
	.O_WIDTH(16),
	.LOAD_PATH("quarterwave_11_16_scaled.hex")
) sine_11_16 (
	.i_clk(sclk),
	.i_en(en),
	.i_phase(phase),
	.o_sin(sin),
	.o_cos(cos)
);

wire signed [15:0] i0, q0;

psd_mixer #(
	.DATA_WIDTH(1),
	.SIN_WIDTH(16),
	.ONEBIT_TO_BIPOLAR(1)
) psd (
	.i_clk(sclk),
	.i_en(en),
	.i_rst(rst),
	.i_data(sd),
	.i_sin(sin),
	.i_cos(cos),
	.o_i(i0),
	.o_q(q0)
);

localparam CIC_OUTPUT_WIDTH = 106;
wire dclk;
wire[(CIC_OUTPUT_WIDTH-1):0] i0_long;
wire[(CIC_OUTPUT_WIDTH-1):0] q0_long;

initial begin
    clk = 0;
    rst = 0;
    en = 0;
    sd = 0;
	#200 en = 1;
end

cic #(
	.I_WIDTH(16),
	.ORDER(5),
	.DECIMATION_BITS(18)
) cic_i0 (
	.i_clk(clk),
	.i_en(en),
	.i_rst(rst),
	.i_data(i0),
	.o_data(i0_long),
	.o_clk(dclk)
);

cic #(
	.I_WIDTH(16),
	.ORDER(5),
	.DECIMATION_BITS(18)
) cic_q0 (
	.i_clk(clk),
	.i_en(en),
	.i_rst(rst),
	.i_data(q0),
	.o_data(q0_long)
);

wire [15:0] i0_short, q0_short;
assign i0_short = i0_long[(CIC_OUTPUT_WIDTH-1)-:16];
assign q0_short = q0_long[(CIC_OUTPUT_WIDTH-1)-:16];

always
begin
	#3.9 clk = ~clk;
end

always @(posedge sclk)
begin
	#3.9 sd = ~sd;
end

initial
begin
    #200000 $stop;
end

initial
begin
    $dumpfile("out.vcd");
	$dumpon;
    $dumpvars;
end

endmodule