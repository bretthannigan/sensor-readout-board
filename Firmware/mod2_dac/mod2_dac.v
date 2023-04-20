///////////////////////////////////////////////////////////////////////////////
// $Author: BH $    $Date: 2021-01-07 $    $Revision: 0 $
//
// Module: mod2_dac.v
// Project: iCESDM (Sigma Delta Modulator for Lattice iCE40)
// Description: 2nd-order sigma delta modulator DAC
// See also: Fig. 3.2 from [1] R. Schreier and G. C. Temes, Understanding Delta-Sigma Data Converters, vol. 53, no. 9. Wiley, 1997.
//
// Change history:  2021-01-07 Created file.
//                  2021-03-02 Fixed bugs by changing weight of feedback to second integrator to 2 (using delayed integrator structure).
//                  2021-03-05 Added conditional compilation flag.
//
// Notes: This implementation uses delaying integrators (with a_1 = a_2 = 1 and b = 2), see Fig. 3.15 in [1]
//        If instability is observed with large input, reduce i_data e.g. by a factor of 2.
//
// ©2023 ETH Zurich, Brett Hannigan; D-HEST; Biomedical and Mobile Health Technology (BMHT) Lab; Carlo Menon
//
///////////////////////////////////////////////////////////////////////////////

`ifndef __MOD2_DAC_INCLUDE__
`define __MOD2_DAC_INCLUDE__
`endif
`ifndef __INT_INCLUDE__
`include "../int/int.v"
`endif

module mod2_dac(i_clk, i_en, i_rst, i_data, o_sd);
    parameter WIDTH = 8;
    input i_clk, i_en, i_rst;
    input wire [(WIDTH-1):0] i_data;
    wire [(WIDTH+2):0] i_data_ext, e1, e2;
    wire [(WIDTH+3):0] y1, y2;
    output wire o_sd;

    int #(
        .I_WIDTH(WIDTH+3)
    ) int1 (
        .i_clk(i_clk),
        .i_en(i_en),
        .i_rst(i_rst),
        .i_x(e1),
        .o_y(y1)
    );

    int #(
        .I_WIDTH(WIDTH+3)
    ) int2 (
        .i_clk(i_clk),
        .i_en(i_en),
        .i_rst(i_rst),
        .i_x(e2),
        .o_y(y2)
    );

    assign i_data_ext = {i_data[WIDTH-1],i_data[WIDTH-1],i_data[WIDTH-1], i_data};
    assign o_sd = (i_rst==1'b0 && i_en==1'b1) ? ~y2[WIDTH+3] : 1'b0;
    assign e1 = (o_sd==1) ? i_data_ext - (2**(WIDTH-1)) : i_data_ext + (2**(WIDTH-1));
    assign e2 = (o_sd==1) ? y1[(WIDTH+3):1] - (2**(WIDTH)) : y1[(WIDTH+3):1] + (2**(WIDTH));
endmodule