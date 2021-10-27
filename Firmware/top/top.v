// 1st order sigma delta DAC sine wave generator.
`timescale 1ns/1ns
`include "pll.v"
`ifndef __SINE_LUT_INCLUDE__
`include "../sine_lut/sine_lut.v"
`endif
`ifndef __COUNTER_MOD2_INCLUDE__
`include "../counter_mod2/counter_mod2.v"
`endif
`ifndef __MOD2_DAC_INCLUDE__
`include "../mod2_dac/mod2_dac.v"
`endif
`ifndef __SHIFT_INCLUDE__
`include "../shift/shift.v"
`endif
`ifndef __PSD_MIXER_INCLUDE__
`include "../psd_mixer/psd_mixer.v"
`endif
`ifndef __CIC_INCLUDE__
`include "../cic/cic.v"
`endif
`ifndef __CIC_PRUNED_INCLUDE__
`include "../cic/cic_pruned.v"
`endif
`ifndef __FIFO_INCLUDE__
`include "../fifo/fifo.v"
`endif
`ifndef __MIN_TRANSMIT_FSM_INCLUDE__
`include "../min/min_transmit_fsm.v"
`endif
`include "../uart/osdvu/uart.v"

module top(
	clk,

	i_sclk,
	i_sw_rst, i_sw_cal, i_sw_trig, i_sw_aux,
	i_sd_a,	i_sd_b,
	i_RS232_RX,

	o_sclk,
	o_en,
	o_test,
	o_led, o_led_en, o_led_busy, o_led_tx, o_led_aux,
	o_dac,
	o_adc_en_n,	o_adc_zero,	o_adc_cal, o_adc_rst,
	o_RS232_TX
);
	
input wire clk, i_sclk, i_sw_rst, i_sw_cal, i_sw_trig, i_sw_aux, i_sd_a, i_sd_b, i_RS232_RX;
output wire o_sclk, o_en, o_led_en, o_led_busy, o_led_tx, o_led_aux, o_dac, o_adc_en_n, o_adc_zero, o_adc_cal, o_adc_rst, o_RS232_TX;
output wire [7:0] o_led;
output wire [3:0] o_test;

reg rst, en;
wire sclk;

initial begin
	rst = 0;
	en = 1;

    o_en = 0;
    o_led_en = 0;
    o_led_busy = 0;
    o_led_tx = 0;
    o_led_aux = 0;
    
    o_RS232_TX = 0;
end

always @(*) 
begin
	o_led_en <= ~i_sw_rst;
	o_led_busy <= ~i_sw_cal;
	o_led_tx <= ~i_sw_trig;
	o_led_aux <= ~i_sw_aux;
end

// Sampling clock generation

wire locked, clk25;
wire[15:0] clk25div;

pll pll_25mhz (
	.clock_in(clk),
	.clock_out(clk25),
	.locked(locked)
);

counter_mod2 #(
	.WIDTH(16)
) clk25_divider (
	.i_clk(clk25),
	.i_en(en),
	.i_rst(rst),
	.i_up(1'b1),
	.i_ld(1'b0),
	.o_data(clk25div)
);

assign sclk = clk25div[1];

// Sine wave generator

wire[10:0] phase;
wire[15:0] sin;
wire[15:0] cos;

assign phase = clk25div[13:3];
assign o_test[0] = sclk;
assign o_test[1] = phase[10];

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

// Sigma-delta DAC

mod2_dac #(
    .WIDTH(16)
) dac (
    .i_clk(sclk),
    .i_en(en),
    .i_rst(rst),
    .i_data(sin),
    .o_sd(o_dac)
);

endmodule