// ©2023 ETH Zurich, Brett Hannigan; D-HEST; Biomedical and Mobile Health Technology (BMHT) Lab; Carlo Menon

// Main version for paper.
`timescale 1ns/1ns
`include "pll.v"
`ifndef __SINE_LUT_4CH_INCLUDE__
`include "../sine_lut/sine_lut_4ch.v"
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

module top(
	clk,

	i_sclk,
	i_trig_n,
	i_sw_rst_n, i_sw_cal_n, i_sw_trig_n, i_sw_aux_n,
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

localparam DELAY_COMPENSATION_LENGTH_0 = 16;
localparam DELAY_COMPENSATION_LENGTH_1 = 17;
localparam DELAY_COMPENSATION_LENGTH_2 = 17;
localparam DELAY_COMPENSATION_LENGTH_3 = 17;
	
input wire clk, i_sclk, i_trig_n, i_sw_rst_n, i_sw_cal_n, i_sw_trig_n, i_sw_aux_n, i_sd_a, i_sd_b, i_sd_dval, i_RS232_RX;
output wire o_sclk, o_en, o_led_en, o_led_busy, o_led_tx, o_led_aux, o_dac, o_adc_en_n, o_adc_zero, o_adc_cal, o_adc_rst, o_RS232_TX;
output wire [7:0] o_led;
output wire [3:0] o_test;

wire rst, en;
wire lclk, sclk;

// Enable
assign en = 1;
assign o_en = en;
assign o_adc_en_n = ~en;
// Reset
assign o_sclk = sclk;
assign rst = ~i_sw_rst_n;

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

wire[10:0] phase0, phase1, phase2, phase3;
wire signed [15:0] sin0, cos0, sin1, cos1, sin2, cos2, sin3, cos3;

assign phase0 = {clk25div[7:0], 3'b0}; // 99.609 kHz
assign phase1 = {clk25div[8:0], 2'b0}; // 49.805 kHz
assign phase2 = {clk25div[9:0], 1'b0}; // 24.902 kHz
assign phase3 = clk25div[10:0]; // 12.451 kHz
assign o_test[0] = sclk;

sine_lut_4ch #(
	.I_WIDTH(11),
	.O_WIDTH(16),
	.LOAD_PATH("quarterwave_11_16.hex")
) sine_11_16 (
	.i_clk(sclk),
	.i_en(en),
	.i_phase_a(phase0),
	.i_phase_b(phase1),
	.i_phase_c(phase2),
	.i_phase_d(phase3),
	.o_sin_a(sin0),
	.o_cos_a(cos0),
	.o_sin_b(sin1),
	.o_cos_b(cos1),
	.o_sin_c(sin2),
	.o_cos_c(cos2),
	.o_sin_d(sin3),
	.o_cos_d(cos3)
);

// Sigma-delta DAC

mod2_dac #(
    .WIDTH(16)
) dac (
    .i_clk(sclk),
    .i_en(en),
    .i_rst(rst),
    .i_data((sin0 >>> 2) + (sin1 >>> 2) + (sin2 >>> 2) + (sin3 >>> 2)),
    .o_sd(o_dac)
);

// Delay line

`ifdef _USE_DELAY_LINES_

wire signed [15:0] sin0_delay, cos0_delay, sin1_delay, cos1_delay, sin2_delay, cos2_delay, sin3_delay, cos3_delay;

shift #(
	.WIDTH(16),
	.LENGTH(DELAY_COMPENSATION_LENGTH_0)
) sin0_delay_line (
	.i_clk(sclk),
	.i_en(en),
	.i_rst(rst),
	.i_data(sin0),
	.o_ser(sin0_delay)
);

shift #(
	.WIDTH(16),
	.LENGTH(DELAY_COMPENSATION_LENGTH_0)
) cos0_delay_line (
	.i_clk(sclk),
	.i_en(en),
	.i_rst(rst),
	.i_data(cos0),
	.o_ser(cos0_delay)
);

shift #(
	.WIDTH(16),
	.LENGTH(DELAY_COMPENSATION_LENGTH_1)
) sin1_delay_line (
	.i_clk(sclk),
	.i_en(en),
	.i_rst(rst),
	.i_data(sin1),
	.o_ser(sin1_delay)
);

shift #(
	.WIDTH(16),
	.LENGTH(DELAY_COMPENSATION_LENGTH_1)
) cos1_delay_line (
	.i_clk(sclk),
	.i_en(en),
	.i_rst(rst),
	.i_data(cos1),
	.o_ser(cos1_delay)
);

shift #(
	.WIDTH(16),
	.LENGTH(DELAY_COMPENSATION_LENGTH_2)
) sin2_delay_line (
	.i_clk(sclk),
	.i_en(en),
	.i_rst(rst),
	.i_data(sin2),
	.o_ser(sin2_delay)
);

shift #(
	.WIDTH(16),
	.LENGTH(DELAY_COMPENSATION_LENGTH_2)
) cos2_delay_line (
	.i_clk(sclk),
	.i_en(en),
	.i_rst(rst),
	.i_data(cos2),
	.o_ser(cos2_delay)
);

shift #(
	.WIDTH(16),
	.LENGTH(DELAY_COMPENSATION_LENGTH_3)
) sin3_delay_line (
	.i_clk(sclk),
	.i_en(en),
	.i_rst(rst),
	.i_data(sin3),
	.o_ser(sin3_delay)
);

shift #(
	.WIDTH(16),
	.LENGTH(DELAY_COMPENSATION_LENGTH_3)
) cos3_delay_line (
	.i_clk(sclk),
	.i_en(en),
	.i_rst(rst),
	.i_data(cos3),
	.o_ser(cos3_delay)
);


`else

// No delay line:
reg signed [15:0] sin0_delay, cos0_delay, sin1_delay, cos1_delay, sin2_delay, cos2_delay, sin3_delay, cos3_delay;
always @(posedge sclk)
begin 
	sin0_delay <= sin0;
	cos0_delay <= cos0;
	sin1_delay <= sin1;
	cos1_delay <= cos1;
	sin2_delay <= sin2;
	cos2_delay <= cos2;
	sin3_delay <= sin3;
	cos3_delay <= cos3;
end

`endif

// Phase-sensitive detectors

wire signed [15:0] i0, q0, i1, q1, i2, q2, i3, q3;

psd_mixer #(
	.DATA_WIDTH(1),
	.SIN_WIDTH(16),
	.ONEBIT_TO_BIPOLAR(1)
) psd0 (
	.i_clk(sclk),
	.i_en(en),
	.i_rst(rst),
	.i_data(i_sd_a),
	.i_sin(sin0_delay),
	.i_cos(cos0_delay),
	.o_i(i0),
	.o_q(q0)
);

psd_mixer #(
	.DATA_WIDTH(1),
	.SIN_WIDTH(16),
	.ONEBIT_TO_BIPOLAR(1)
) psd1 (
	.i_clk(sclk),
	.i_en(en),
	.i_rst(rst),
	.i_data(i_sd_a),
	.i_sin(sin1_delay),
	.i_cos(cos1_delay),
	.o_i(i1),
	.o_q(q1)
);

psd_mixer #(
	.DATA_WIDTH(1),
	.SIN_WIDTH(16),
	.ONEBIT_TO_BIPOLAR(1)
) psd2 (
	.i_clk(sclk),
	.i_en(en),
	.i_rst(rst),
	.i_data(i_sd_a),
	.i_sin(sin2_delay),
	.i_cos(cos2_delay),
	.o_i(i2),
	.o_q(q2)
);

psd_mixer #(
	.DATA_WIDTH(1),
	.SIN_WIDTH(16),
	.ONEBIT_TO_BIPOLAR(1)
) psd3 (
	.i_clk(sclk),
	.i_en(en),
	.i_rst(rst),
	.i_data(i_sd_a),
	.i_sin(sin3_delay),
	.i_cos(cos3_delay),
	.o_i(i3),
	.o_q(q3)
);

// Decimation Filter

wire [15:0] i0_short, q0_short, i1_short, q1_short, i2_short, q2_short, i3_short, q3_short;
wire dclk;

`ifdef _USE_PRUNED_CIC_FILTERS_

localparam CIC_OUTPUT_WIDTH = 17;
localparam PRUNING_WIDTHS = {8'd17, 8'd19, 8'd20, 8'd21, 8'd32, 8'd64, 8'd70};
wire signed [(CIC_OUTPUT_WIDTH-1):0] i0_long, q0_long, i1_long, q1_long, i2_long, q2_long, i3_long, q3_long;

cic_pruned #(
	.I_WIDTH(16),
	.ORDER(3),
	.DECIMATION_BITS(18),
	.REG_WIDTHS(PRUNING_WIDTHS)
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
	.REG_WIDTHS(PRUNING_WIDTHS)
) cic_q0 (
	.i_clk(sclk),
	.i_en(en),
	.i_rst(rst),
	.i_data(q0),
	.o_data(q0_long)
);

cic_pruned #(
	.I_WIDTH(16),
	.ORDER(3),
	.DECIMATION_BITS(18),
	.REG_WIDTHS(PRUNING_WIDTHS)
) cic_i1 (
	.i_clk(sclk),
	.i_en(en),
	.i_rst(rst),
	.i_data(i1),
	.o_data(i1_long)
);

cic_pruned #(
	.I_WIDTH(16),
	.ORDER(3),
	.DECIMATION_BITS(18),
	.REG_WIDTHS(PRUNING_WIDTHS)
) cic_q1 (
	.i_clk(sclk),
	.i_en(en),
	.i_rst(rst),
	.i_data(q1),
	.o_data(q1_long)
);

cic_pruned #(
	.I_WIDTH(16),
	.ORDER(3),
	.DECIMATION_BITS(18),
	.REG_WIDTHS(PRUNING_WIDTHS)
) cic_i2 (
	.i_clk(sclk),
	.i_en(en),
	.i_rst(rst),
	.i_data(i2),
	.o_data(i2_long)
);

cic_pruned #(
	.I_WIDTH(16),
	.ORDER(3),
	.DECIMATION_BITS(18),
	.REG_WIDTHS(PRUNING_WIDTHS)
) cic_q2 (
	.i_clk(sclk),
	.i_en(en),
	.i_rst(rst),
	.i_data(q2),
	.o_data(q2_long)
);

cic_pruned #(
	.I_WIDTH(16),
	.ORDER(3),
	.DECIMATION_BITS(18),
	.REG_WIDTHS(PRUNING_WIDTHS)
) cic_i3 (
	.i_clk(sclk),
	.i_en(en),
	.i_rst(rst),
	.i_data(i3),
	.o_data(i3_long)
);

cic_pruned #(
	.I_WIDTH(16),
	.ORDER(3),
	.DECIMATION_BITS(18),
	.REG_WIDTHS(PRUNING_WIDTHS)
) cic_q3 (
	.i_clk(sclk),
	.i_en(en),
	.i_rst(rst),
	.i_data(q3),
	.o_data(q3_long)
);

`else

localparam CIC_OUTPUT_WIDTH = 70;
wire signed [(CIC_OUTPUT_WIDTH-1):0] i0_long, q0_long, i1_long, q1_long, i2_long, q2_long, i3_long, q3_long;

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

cic #(
	.I_WIDTH(16),
	.ORDER(3),
	.DECIMATION_BITS(18)
) cic_i1 (
	.i_clk(sclk),
	.i_en(en),
	.i_rst(rst),
	.i_data(i1),
	.o_data(i1_long),
);

cic #(
	.I_WIDTH(16),
	.ORDER(3),
	.DECIMATION_BITS(18)
) cic_q1 (
	.i_clk(sclk),
	.i_en(en),
	.i_rst(rst),
	.i_data(q1),
	.o_data(q1_long)
);

cic #(
	.I_WIDTH(16),
	.ORDER(3),
	.DECIMATION_BITS(18)
) cic_i2 (
	.i_clk(sclk),
	.i_en(en),
	.i_rst(rst),
	.i_data(i2),
	.o_data(i2_long),
);

cic #(
	.I_WIDTH(16),
	.ORDER(3),
	.DECIMATION_BITS(18)
) cic_q2 (
	.i_clk(sclk),
	.i_en(en),
	.i_rst(rst),
	.i_data(q2),
	.o_data(q2_long)
);

cic #(
	.I_WIDTH(16),
	.ORDER(3),
	.DECIMATION_BITS(18)
) cic_i3 (
	.i_clk(sclk),
	.i_en(en),
	.i_rst(rst),
	.i_data(i3),
	.o_data(i3_long),
);

cic #(
	.I_WIDTH(16),
	.ORDER(3),
	.DECIMATION_BITS(18)
) cic_q3 (
	.i_clk(sclk),
	.i_en(en),
	.i_rst(rst),
	.i_data(q3),
	.o_data(q3_long)
);

`endif

//assign o_led = q1_long[(CIC_OUTPUT_WIDTH-1)-:8]; // new, seems to fix bug?
assign o_led = i0_long[(CIC_OUTPUT_WIDTH-1)-:8] & q0_long[(CIC_OUTPUT_WIDTH-1)-:8] & i1_long[(CIC_OUTPUT_WIDTH-1)-:8] & q1_long[(CIC_OUTPUT_WIDTH-1)-:8] & i2_long[(CIC_OUTPUT_WIDTH-1)-:8] & q2_long[(CIC_OUTPUT_WIDTH-1)-:8] & i3_long[(CIC_OUTPUT_WIDTH-1)-:8] & q3_long[(CIC_OUTPUT_WIDTH-1)-:8];

assign i0_short = i0_long[(CIC_OUTPUT_WIDTH-2)-:16];
assign q0_short = q0_long[(CIC_OUTPUT_WIDTH-2)-:16];
assign i1_short = i1_long[(CIC_OUTPUT_WIDTH-2)-:16];
assign q1_short = q1_long[(CIC_OUTPUT_WIDTH-2)-:16];
assign i2_short = i2_long[(CIC_OUTPUT_WIDTH-2)-:16];
assign q2_short = q2_long[(CIC_OUTPUT_WIDTH-2)-:16];
assign i3_short = i3_long[(CIC_OUTPUT_WIDTH-2)-:16];
assign q3_short = q3_long[(CIC_OUTPUT_WIDTH-2)-:16];

// Output streaming

wire [7:0] min_data;
wire istx;

reg[127:0] iq_buffer;

// Pipeline buffer that solved issue of corrupted/noisy data being sent over serial.
always @(posedge sclk)
begin
	iq_buffer <= {i0_short, q0_short, i1_short, q1_short, i2_short, q2_short, i3_short, q3_short};
end

reg dclk_delay, packet_trigger;
always @(posedge sclk)
begin
	dclk_delay <= dclk;
	packet_trigger <= (dclk && !dclk_delay) && en;
end

// Enable pull-up resistor for trigger input.
wire ext_trigger_n;

SB_IO #(
	.PIN_TYPE(6'b0000_01),
	.PULLUP(1'b1)
) trigger_input (
	.PACKAGE_PIN(i_trig_n),
	.D_IN_0(ext_trigger_n)
);

wire any_trigger;
assign any_trigger = ~i_sw_trig_n || ~ext_trigger_n;

min_transmit_fsm #(
	.N_DATA_BYTE(16)
) min (
	.i_clk(sclk),
	.i_rst(rst),
	.i_en(packet_trigger),
	.i_id({3'b0, any_trigger, 4'b1}),
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

// LED Outputs
assign o_led_en = en;
assign o_led_busy = ~i_sd_dval;
assign o_led_tx = is_transmitting;
assign o_led_aux = any_trigger;

assign o_test[1] = phase3[10];
assign o_test[3] = dclk;

endmodule