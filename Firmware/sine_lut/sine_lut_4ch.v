///////////////////////////////////////////////////////////////////////////////
// $Author: BH $    $Date: 2022-06-01 $    $Revision: 0 $
//
// Module: sine_lut_4ch.v
// Project: iCESDM (Sigma Delta Modulator for Lattice iCE40)
// Description: Quarter-wave sine lookup table.
// See also: https://zipcpu.com/dsp/2017/08/26/quarterwave.html
//
// Change history:  2022-06-01 Created file (adapted from sine_lut_2ch.v).
//
///////////////////////////////////////////////////////////////////////////////

`ifndef __SINE_LUT_4CH_INCLUDE__
`define __SINE_LUT_4CH_INCLUDE__
`endif
`ifndef __ROM_8CH_INCLUDE__
`include "../rom/rom_8ch.v"
`endif
`ifndef __SINE_LUT_QUARTERWAVE_LOGIC_INCLUDE__
`include "sine_lut_quarterwave_logic.v"
`endif

module sine_lut_4ch(i_clk, i_rst, i_en, i_phase_a, i_phase_b, i_phase_c, i_phase_d, o_sin_a, o_cos_a, o_sin_b, o_cos_b, o_sin_c, o_cos_c, o_sin_d, o_cos_d);
    parameter I_WIDTH = 13;
    parameter O_WIDTH = 12;
    parameter LOAD_PATH = "";
    input i_clk, i_rst, i_en;
    input wire [(I_WIDTH-1):0] i_phase_a, i_phase_b, i_phase_c, i_phase_d;
    output wire signed [(O_WIDTH-1):0] o_sin_a, o_cos_a, o_sin_b, o_cos_b, o_sin_c, o_cos_c, o_sin_d, o_cos_d;

    wire [(O_WIDTH-1):0] data_sin_a, data_cos_a, data_sin_b, data_cos_b, data_sin_c, data_cos_c, data_sin_d, data_cos_d;
    reg [(I_WIDTH-3):0] addr_sin_a, addr_cos_a, addr_sin_b, addr_cos_b, addr_sin_c, addr_cos_c, addr_sin_d, addr_cos_d;

    rom_8ch #(
        .ADDR_WIDTH(I_WIDTH-2), // Divide by 4 due to sine wave symmetry.
        .DATA_WIDTH(O_WIDTH),
        .LOAD_PATH(LOAD_PATH)
    ) lut (
        .i_clk(i_clk),
        .i_en(i_en),
        .i_addr_a(addr_sin_a),
        .i_addr_b(addr_cos_a),
        .i_addr_c(addr_sin_b),
        .i_addr_d(addr_cos_b),
        .i_addr_e(addr_sin_c),
        .i_addr_f(addr_cos_c),
        .i_addr_g(addr_sin_d),
        .i_addr_h(addr_cos_d),
        .o_data_a(data_sin_a),
        .o_data_b(data_cos_a),
        .o_data_c(data_sin_b),
        .o_data_d(data_cos_b),
        .o_data_e(data_sin_c),
        .o_data_f(data_cos_c),
        .o_data_g(data_sin_d),
        .o_data_h(data_cos_d)
    );

    sine_lut_quarterwave_logic #(
        .I_WIDTH(I_WIDTH),
        .O_WIDTH(O_WIDTH)
    ) quarterwave_logic_a (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_en(i_en),
        .i_phase(i_phase_a),
        .i_data_sin(data_sin_a),
        .i_data_cos(data_cos_a),
        .o_addr_sin(addr_sin_a),
        .o_addr_cos(addr_cos_a),
        .o_sin(o_sin_a),
        .o_cos(o_cos_a)
    );

    sine_lut_quarterwave_logic #(
        .I_WIDTH(I_WIDTH),
        .O_WIDTH(O_WIDTH)
    ) quarterwave_logic_b (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_en(i_en),
        .i_phase(i_phase_b),
        .i_data_sin(data_sin_b),
        .i_data_cos(data_cos_b),
        .o_addr_sin(addr_sin_b),
        .o_addr_cos(addr_cos_b),
        .o_sin(o_sin_b),
        .o_cos(o_cos_b)
    );

    sine_lut_quarterwave_logic #(
        .I_WIDTH(I_WIDTH),
        .O_WIDTH(O_WIDTH)
    ) quarterwave_logic_c (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_en(i_en),
        .i_phase(i_phase_c),
        .i_data_sin(data_sin_c),
        .i_data_cos(data_cos_c),
        .o_addr_sin(addr_sin_c),
        .o_addr_cos(addr_cos_c),
        .o_sin(o_sin_c),
        .o_cos(o_cos_c)
    );

    sine_lut_quarterwave_logic #(
        .I_WIDTH(I_WIDTH),
        .O_WIDTH(O_WIDTH)
    ) quarterwave_logic_d (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_en(i_en),
        .i_phase(i_phase_d),
        .i_data_sin(data_sin_d),
        .i_data_cos(data_cos_d),
        .o_addr_sin(addr_sin_d),
        .o_addr_cos(addr_cos_d),
        .o_sin(o_sin_d),
        .o_cos(o_cos_d)
    );
    
endmodule