///////////////////////////////////////////////////////////////////////////////
// $Author: BH $    $Date: 2020-04-15 $    $Revision: 2 $
//
// Module: sine_lut.v
// Project: iCESDM (Sigma Delta Modulator for Lattice iCE40)
// Description: Quarter-wave sin lookup table.
// See also: https://zipcpu.com/dsp/2017/08/26/quarterwave.html
//
// Change history:  2020-04-15 Created file.
//                  2021-03-05 Added conditional compilation flag.
//                  2022-02-09 Separated quarter-wave logic into own module.
//                             Changed name from sine_lut_2.v to sine_lut.v.
//
///////////////////////////////////////////////////////////////////////////////

`ifndef __SINE_LUT_INCLUDE__
`define __SINE_LUT_INCLUDE__
`endif
`ifndef __ROM_2CH_INCLUDE__
`include "../rom/rom_2ch.v"
`endif
`ifndef __SINE_LUT_QUARTERWAVE_LOGIC_INCLUDE__
`include "sine_lut_quarterwave_logic.v"
`endif

module sine_lut(i_clk, i_rst, i_en, i_phase, o_sin, o_cos);
    parameter I_WIDTH = 13;
    parameter O_WIDTH = 12;
    parameter LOAD_PATH = "";
    input i_clk, i_rst, i_en;
    input wire [(I_WIDTH-1):0] i_phase;
    output wire signed [(O_WIDTH-1):0] o_sin, o_cos;
    
    wire [(O_WIDTH-1):0] data_sin, data_cos;
    wire [(I_WIDTH-3):0] addr_sin, addr_cos;

    rom_2ch #(
        .ADDR_WIDTH(I_WIDTH-2), // Divide by 4 due to sine wave symmetry.
        .DATA_WIDTH(O_WIDTH),
        .LOAD_PATH(LOAD_PATH)
    ) lut (
        .i_clk(i_clk),
        .i_en(i_en),
        .i_addr_a(addr_sin),
        .i_addr_b(addr_cos),
        .o_data_a(data_sin),
        .o_data_b(data_cos)
    );

    sine_lut_quarterwave_logic #(
        .I_WIDTH(I_WIDTH),
        .O_WIDTH(O_WIDTH)
    ) quarterwave_logic (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_en(i_en),
        .i_phase(i_phase),
        .i_data_sin(data_sin),
        .i_data_cos(data_cos),
        .o_addr_sin(addr_sin),
        .o_addr_cos(addr_cos),
        .o_sin(o_sin),
        .o_cos(o_cos)
    );

endmodule