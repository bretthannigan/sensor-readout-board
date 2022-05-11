`timescale 1ns/1ns
`include "pll.v"
`ifndef __SINE_LUT_2ch_INCLUDE__
`include "../sine_lut/sine_lut_2ch.v"
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

// Options for synthesis

`define _USE_DELAY_LINES_
`define _USE_PRUNED_CIC_FILTERS_

module top_2f(
	clk,

	i_sclk,
	i_sw_rst, i_sw_cal, i_sw_trig, i_sw_aux,
	i_sd_a,	i_sd_b, i_sd_dval,
	i_RS232_RX,

	o_sclk,
	o_en,
	o_test,
	o_led, o_led_en, o_led_busy, o_led_tx, o_led_aux,
	o_dac,
	o_adc_en_n,	o_adc_zero,	o_adc_cal, o_adc_rst,
	o_RS232_TX
);

localparam DELAY_COMPENSATION_LENGTH = 16;
	
input wire clk, i_sclk, i_sw_rst, i_sw_cal, i_sw_trig, i_sw_aux, i_sd_a, i_sd_b, i_sd_dval, i_RS232_RX;
output wire o_sclk, o_en, o_led_en, o_led_busy, o_led_tx, o_led_aux, o_dac, o_adc_en_n, o_adc_zero, o_adc_cal, o_adc_rst, o_RS232_TX;
output wire [7:0] o_led;
output wire [3:0] o_test;

wire rst, en;
wire lclk, sclk;

assign o_led_busy = ~i_sd_dval;
assign o_led_aux = ~i_sd_dval;

// Enable
assign en = 1;
assign o_led_en = en;
assign o_en = en;
assign o_adc_en_n = ~en;
// Reset
assign o_sclk = sclk;
assign rst = ~i_sw_rst;

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

assign sclk = clk25div[1]; // 6.375 MHz clock

// Sine wave generator

wire[10:0] phase0, phase1;
wire signed [15:0] sin0, cos0, sin1, cos1;

assign phase0 = clk25div[13:3];
assign phase1 = clk25div[10:0];
assign o_test[0] = sclk;
// assign o_test[1] = phase0[10];
// assign o_test[2] = phase1[10];

sine_lut_2ch #(
	.I_WIDTH(11),
	.O_WIDTH(16),
	.LOAD_PATH("quarterwave_11_16.hex")
) sine_11_16 (
	.i_clk(sclk),
	.i_en(en),
	.i_phase_a(phase0),
	.i_phase_b(phase1),
	.o_sin_a(sin0),
	.o_cos_a(cos0),
	.o_sin_b(sin1),
	.o_cos_b(cos1)
);

// Sigma-delta DAC

mod2_dac #(
    .WIDTH(16)
) dac (
    .i_clk(sclk),
    .i_en(en),
    .i_rst(rst),
    .i_data((sin0 >>> 1) + (sin1 >>> 1)),
    .o_sd(o_dac)
);

// Delay line

`ifdef _USE_DELAY_LINES_

wire signed [15:0] sin_delay, cos_delay;

shift #(
	.WIDTH(16),
	.LENGTH(DELAY_COMPENSATION_LENGTH)
) sin_delay_line (
	.i_clk(sclk),
	.i_en(en),
	.i_rst(rst),
	.i_data(sin0),
	.o_ser(sin_delay)
);

shift #(
	.WIDTH(16),
	.LENGTH(DELAY_COMPENSATION_LENGTH)
) cos_delay_line (
	.i_clk(sclk),
	.i_en(en),
	.i_rst(rst),
	.i_data(cos0),
	.o_ser(cos_delay)
);

`else

// No delay line:
reg signed [15:0] sin_delay, cos_delay;
always @(posedge sclk)
begin 
	sin_delay <= sin0;
	cos_delay <= cos0;
end

`endif

assign o_test[2] = sin_delay[15];

// Phase-sensitive detector

wire signed [15:0] i0, q0;

psd_mixer #(
	.DATA_WIDTH(1),
	.SIN_WIDTH(16),
	.ONEBIT_TO_BIPOLAR(1)
) psd (
	.i_clk(sclk),
	.i_en(en),
	.i_rst(rst),
	.i_data(i_sd_a),
	.i_sin(sin_delay),
	.i_cos(cos_delay),
	.o_i(i0),
	.o_q(q0)
);

// Decimation Filter

wire [15:0] i0_short, q0_short;
wire dclk;

`ifdef _USE_PRUNED_CIC_FILTERS_

localparam CIC_OUTPUT_WIDTH = 17;
wire signed [(CIC_OUTPUT_WIDTH-1):0] i0_long, q0_long;

cic_pruned #(
	.I_WIDTH(16),
	.ORDER(3),
	.DECIMATION_BITS(18),
	.REG_WIDTHS({8'd17, 8'd19, 8'd20, 8'd21, 8'd32, 8'd64, 8'd70})
) cic_i0 (
	.i_clk(sclk),
	.i_en(en),
	.i_rst(rst),
	.i_data(i0),
	.o_data(i0_long),
	.o_clk(dclk)
);

cic_pruned #(
	.I_WIDTH(16),
	.ORDER(3),
	.DECIMATION_BITS(18),
	.REG_WIDTHS({8'd17, 8'd19, 8'd20, 8'd21, 8'd32, 8'd64, 8'd70})
) cic_q0 (
	.i_clk(sclk),
	.i_en(en),
	.i_rst(rst),
	.i_data(q0),
	.o_data(q0_long)
);

`else

localparam CIC_OUTPUT_WIDTH = 70;
wire signed [(CIC_OUTPUT_WIDTH-1):0] i0_long, q0_long;

cic #(
	.I_WIDTH(16),
	.ORDER(3),
	.DECIMATION_BITS(18)
) cic_i0 (
	.i_clk(sclk),
	.i_en(en),
	.i_rst(rst),
	.i_data(i0),
	.o_data(i0_long),
	.o_clk(dclk)
);

cic #(
	.I_WIDTH(16),
	.ORDER(3),
	.DECIMATION_BITS(18)
) cic_q0 (
	.i_clk(sclk),
	.i_en(en),
	.i_rst(rst),
	.i_data(q0),
	.o_data(q0_long)
);

`endif

assign i0_short = i0_long[(CIC_OUTPUT_WIDTH-2)-:16];
assign q0_short = q0_long[(CIC_OUTPUT_WIDTH-2)-:16];
assign o_led = q0_long[(CIC_OUTPUT_WIDTH-1)-:8]; // new

// Output streaming

wire [7:0] min_data;
wire istx;

reg[31:0] iq_buffer;

// Pipeline buffer that solved issue of corrupted/noisy data being sent over serial.
always @(posedge sclk)
begin
	iq_buffer <= {i0_short, q0_short};
end

reg dclk_delay, packet_trigger;
always @(posedge sclk)
begin
	dclk_delay <= dclk;
	packet_trigger <= (dclk && !dclk_delay) && en;
end

min_transmit_fsm #(
	.N_DATA_BYTE(4)
) min (
	.i_clk(sclk),
	.i_rst(rst),
	.i_en(packet_trigger),
	.i_id(8'h01),
	.i_data(iq_buffer),
	.o_istx(istx),
	.o_data(min_data)
);

wire fifo_empty, fifo_full, is_transmitting;
wire [7:0] fifo_data;
reg pull_byte, pull_byte_delay, tx_wait = 0;

always @(posedge sclk)
begin
	pull_byte_delay <= pull_byte;
	if (!is_transmitting)
	begin
		if (!fifo_empty && !tx_wait)
		begin
			pull_byte <= 1;
			tx_wait <= 1;
		end
		else 
			pull_byte <= 0;
	end
	else
		tx_wait <= 0;
end

fifo #(
	.ADDR_WIDTH(6),
	.DATA_WIDTH(8),
	.OVERWRITE_OLD(1)
) transmit_fifo (
	.i_clk(sclk),
	.i_en(en),
	.i_rst(rst),
	.i_wr(istx),
	.i_rd(pull_byte),
	.i_data(min_data),
	.o_empty(fifo_empty),
	.o_full(fifo_full),
	.o_data(fifo_data)
);

localparam integer UART_BAUD_RATE =  9_600;
localparam integer UART_CLOCK_DIVIDE = $ceil(25_500_000/(4*UART_BAUD_RATE));

uart #(
	.CLOCK_DIVIDE(166)
) uart (
	.clk(sclk),
	.rst(rst),
	.rx(i_RS232_RX),
	.tx(o_RS232_TX),
	.transmit(pull_byte_delay),
	.is_transmitting(is_transmitting),
	.tx_byte(fifo_data)
);

//assign o_test[2] = is_transmitting;
//assign o_test[3] = q0_long[CIC_OUTPUT_WIDTH-1];
assign o_test[3] = dclk;

endmodule