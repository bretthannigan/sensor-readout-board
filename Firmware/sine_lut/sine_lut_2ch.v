///////////////////////////////////////////////////////////////////////////////
// $Author: BH $    $Date: 2022-02-09 $    $Revision: 0 $
//
// Module: sine_lut_2ch.v
// Project: iCESDM (Sigma Delta Modulator for Lattice iCE40)
// Description: Quarter-wave sine lookup table.
// See also: https://zipcpu.com/dsp/2017/08/26/quarterwave.html
//
// Change history:  2022-02-09 Created file (adapted from sine_lut.v).
//
// ©2023 ETH Zurich, Brett Hannigan; D-HEST; Biomedical and Mobile Health Technology (BMHT) Lab; Carlo Menon
//
///////////////////////////////////////////////////////////////////////////////

`ifndef __SINE_LUT_2CH_INCLUDE__
`define __SINE_LUT_2CH_INCLUDE__
`endif
`ifndef __ROM_4CH_INCLUDE__
`include "../rom/rom_4ch.v"
`endif
`ifndef __SINE_LUT_QUARTERWAVE_LOGIC_INCLUDE__
`include "sine_lut_quarterwave_logic.v"
`endif

module sine_lut_2ch(i_clk, i_rst, i_en, i_phase_a, i_phase_b, o_sin_a, o_cos_a, o_sin_b, o_cos_b);
    parameter I_WIDTH = 13;
    parameter O_WIDTH = 12;
    parameter LOAD_PATH = "";
    input i_clk, i_rst, i_en;
    input wire [(I_WIDTH-1):0] i_phase_a, i_phase_b;
    output wire signed [(O_WIDTH-1):0] o_sin_a, o_cos_a, o_sin_b, o_cos_b;

    wire [(O_WIDTH-1):0] data_sin_a, data_cos_a, data_sin_b, data_cos_b;
    reg [(I_WIDTH-3):0] addr_sin_a, addr_cos_a, addr_sin_b, addr_cos_b;

    rom_4ch #(
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
        .o_data_a(data_sin_a),
        .o_data_b(data_cos_a),
        .o_data_c(data_sin_b),
        .o_data_d(data_cos_b)
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
    
endmodule