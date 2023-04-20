///////////////////////////////////////////////////////////////////////////////
// $Author: BH $    $Date: 2022-02-09 $    $Revision: 0 $
//
// Module: sine_lut_quarterwave_logic.v
// Project: iCESDM (Sigma Delta Modulator for Lattice iCE40)
// Description: Quarter-wave sin lookup table logic.
// See also: https://zipcpu.com/dsp/2017/08/26/quarterwave.html
//
// Change history:  2022-02-09 Created file (adapted from sine_lut.v).
//
// ©2023 ETH Zurich, Brett Hannigan; D-HEST; Biomedical and Mobile Health Technology (BMHT) Lab; Carlo Menon
//
///////////////////////////////////////////////////////////////////////////////

`ifndef __SINE_LUT_QUARTERWAVE_LOGIC_INCLUDE__
`define __SINE_LUT_QUARTERWAVE_LOGIC_INCLUDE__
`endif

module sine_lut_quarterwave_logic(i_clk, i_rst, i_en, i_phase, i_data_sin, i_data_cos, o_addr_sin, o_addr_cos, o_sin, o_cos);
    parameter I_WIDTH = 13;
    parameter O_WIDTH = 12;
    input i_clk, i_rst, i_en;
    input wire [(I_WIDTH-1):0] i_phase;
    input wire [(O_WIDTH-1):0] i_data_sin, i_data_cos;
    output reg [(I_WIDTH-3):0] o_addr_sin, o_addr_cos;
    output reg signed [(O_WIDTH-1):0] o_sin, o_cos;

    reg signed [(O_WIDTH-1):0] sin, cos;
    reg [1:0] negate_sin, negate_cos;

    always @(posedge i_clk)
    begin
        if (i_rst)
        begin
            negate_sin = 2'b0;
            negate_cos = 2'b0;
            o_addr_sin = 0;
            o_addr_cos = 0;
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
                o_addr_sin <= ~i_phase[(I_WIDTH-3):0];
                o_addr_cos <= i_phase[(I_WIDTH-3):0];
            end
            else
            begin
                o_addr_sin <= i_phase[(I_WIDTH-3):0];
                o_addr_cos <= ~i_phase[(I_WIDTH-3):0];
            end
            // Clock 2
            sin <= i_data_sin;
            cos <= i_data_cos;
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