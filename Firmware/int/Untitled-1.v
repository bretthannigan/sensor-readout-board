// ©2023 ETH Zurich, Brett Hannigan; D-HEST; Biomedical and Mobile Health Technology (BMHT) Lab; Carlo Menon

`timescale 1ns/1ns
`include "pll.v"

module top(
    input clk,
    output LED0,
    output LED1,
    output LED2,
    output LED3,
    output LED4,
    output LED5,
    output LED6, 
    output LED7,
    output out,
    output trig
);

reg rst, en, up, ld;
wire locked, clk96;
wire[3:0] phase;
wire[7:0] dout, u, e;
wire [8:0] x_int, y;
wire[15:0] cnt_msb;

counter #(
    .WIDTH(16)
) cnt24 (
    .i_clk(clk),
    .i_en(en),
    .i_rst(rst),
    .i_up(up),
    .i_ld(ld),
    .o_data(cnt_msb)
);

sine_lut #(
    .I_WIDTH(4),
    .O_WIDTH(8)
) sine48 (
    .i_clk(clk),
    .i_en(en),
    .i_phase(phase),
    .o_sine(dout)
);

dff #(
    .WIDTH(9)
) dff8 (
    .i_clk(clk),
    .i_rst(rst),
    .i_d(x_int),
    .o_q(y)
);

pll pll96 (
    .clock_in(clk),
    .clock_out(clk96),
    .locked(locked)
);

initial begin
    rst = 0;
    en = 1;
    up = 1;
    ld = 0;
end

assign phase = cnt_msb[15:12];
assign e = dout - y[8];
assign x_int = e + y;
assign out = y[8];
assign clkpll_out = clk96;
assign trig = phase[3];
assign LED0 = dout[7];
assign LED1 = dout[6];
assign LED2 = dout[5];
assign LED3 = dout[4];
assign LED4 = dout[3];
assign LED5 = dout[2];
assign LED6 = dout[1];
assign LED7 = dout[0];

endmodule