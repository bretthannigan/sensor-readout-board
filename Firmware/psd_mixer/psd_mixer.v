///////////////////////////////////////////////////////////////////////////////
// $Author: BH $    $Date: 2020-11-17 $    $Revision: 0 $
//
// Module: psd_mixer.v
// Project: iCESDM (Sigma Delta Modulator for Lattice iCE40)
// Description: Phase-sensitive demodulator mixer.
//
// Change history:  2020-11-17 Created file.
//                  2021-03-05 Added conditional compilation flag.
//
///////////////////////////////////////////////////////////////////////////////

`ifndef __PSD_MIXER_INCLUDE__
`define __PSD_MIXER_INCLUDE__
`endif

module psd_mixer(i_clk, i_en, i_rst, i_data, i_sin, i_cos, o_i, o_q);
    parameter DATA_WIDTH = 1;
    parameter SIN_WIDTH = 8;
    localparam O_WIDTH = DATA_WIDTH + SIN_WIDTH - 1;
    input i_clk, i_en, i_rst;
    input [(DATA_WIDTH-1):0] i_data;
    input [(SIN_WIDTH-1):0] i_sin, i_cos;
    output reg [(O_WIDTH-1):0] o_i, o_q;

    always @(posedge i_clk)
    begin
        if (i_en)
        begin
            if (i_rst)
            begin
                o_i <= {O_WIDTH{1'b0}};
                o_q <= {O_WIDTH{1'b0}};
            end
            else
            begin
                o_i <= i_data*i_sin;
                o_q <= i_data*i_cos;
            end
        end
    end
endmodule