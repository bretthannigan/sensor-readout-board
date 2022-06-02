///////////////////////////////////////////////////////////////////////////////
// $Author: BH $    $Date: 2020-04-15 $    $Revision: 2 $
//
// Module: sine_lut_old.v
// Project: iCESDM (Sigma Delta Modulator for Lattice iCE40)
// Description: Quarter-wave sin lookup table with integrated logic.
// See also: https://zipcpu.com/dsp/2017/08/26/quarterwave.html
//
// Change history:  2020-04-15 Created file.
//                  2021-03-05 Added conditional compilation flag.
//                  2022-02-09 Changed name from sine_lut.v to sine_lut_old.v.
//
///////////////////////////////////////////////////////////////////////////////

`ifndef __SINE_LUT_OLD_INCLUDE__
`define __SINE_LUT_OLD_INCLUDE__
`endif
`ifndef __ROM_2CH_INCLUDE__
`include "../rom/rom_2ch.v"
`endif

module sine_lut_old(i_clk, i_rst, i_en, i_phase, o_sin, o_cos);
    parameter I_WIDTH = 13;
    parameter O_WIDTH = 12;
    parameter LOAD_PATH = "";
    input i_clk, i_rst, i_en;
    input wire [(I_WIDTH-1):0] i_phase;
    output reg signed [(O_WIDTH-1):0] o_sin, o_cos;
    wire [(O_WIDTH-1):0] data_sin, data_cos;
    reg signed [(O_WIDTH-1):0] sin, cos;
    reg [(I_WIDTH-3):0] addr_sin, addr_cos;
    reg [1:0] negate_sin, negate_cos;

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

    always @(posedge i_clk)
    begin
        if (i_rst)
        begin
            negate_sin = 2'b0;
            negate_cos = 2'b0;
            addr_sin = 0;
            addr_cos = 0;
            sin = 0;
            cos = 0;
        end
        else if (i_en)
        begin
            // Clock 1
            negate_sin[0] <= i_phase[(I_WIDTH-1)];
            negate_cos[0] <= i_phase[I_WIDTH-1] ^ i_phase[I_WIDTH-2];
            if (i_phase[(I_WIDTH-2)])
            begin
                addr_sin <= ~i_phase[(I_WIDTH-3):0];
                addr_cos <= i_phase[(I_WIDTH-3):0];
            end
            else
            begin
                addr_sin <= i_phase[(I_WIDTH-3):0];
                addr_cos <= ~i_phase[(I_WIDTH-3):0];
            end
            // Clock 2
            sin <= data_sin;
            cos <= data_cos;
            negate_sin[1] <= negate_sin[0];
            negate_cos[1] <= negate_cos[0];
            // Clock 3
            if (negate_sin[1])
                o_sin <= ~sin;
            else
                o_sin <= sin;
            if (negate_cos[1])
                o_cos <= ~cos;
            else
                o_cos <= cos;
        end
    end
endmodule