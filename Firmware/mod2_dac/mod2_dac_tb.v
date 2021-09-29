///////////////////////////////////////////////////////////////////////////////
// $Author: BH $    $Date: 2021-01-07 $    $Revision: 0 $
//
// Module: mod2_dac_tb.v
// Project: iCESDM (Sigma Delta Modulator for Lattice iCE40)
// Description: Test bench for 2nd-order sigma delta modulator
//
// Change history:  2021-01-07 Created file.
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ns
`include "mod2_dac.v"
`include "../icesdm_test_ice40/second_order_dac.v"
module mod2_dac_tb();

reg clk, en, rst;
wire sd, sd2;
reg [7:0] data;

mod2_dac #(
    .WIDTH(16)
) DUT (
    .i_clk(clk),
    .i_en(en),
    .i_rst(rst),
    .i_data(data),
    .o_sd(sd)
);

second_order_dac ref (
    .i_clk(clk),
    .i_ce(en),
    .i_res(~rst),
    .i_func(data),
    .o_DAC(sd2)
);

always
#10 clk = ~clk;

initial
begin
    clk = 0;
    rst = 1;
    en = 1;
    data = 8'h00;
    #40 rst = 0;
    #400 data = 8'h08;
    #400 data = 8'h10;
    #400 data = 8'h20;
    #400 data = 8'h40;
    #400 data = 8'h80;
    #400 data = 8'h88;
    #400 data = 8'h90;
    #400 data = 8'hA0;
    #400 data = 8'hC0;
    #400 data = 8'h80;
end

initial
begin
    #4200 $stop;
end

initial
begin
    $dumpfile("out.vcd");
    $dumpvars(0,DUT,ref);
end

 initial
 $monitor($stime,, rst,, en,, clk,, data,, sd,, sd2);

endmodule