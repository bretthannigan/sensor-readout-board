///////////////////////////////////////////////////////////////////////////////
// $Author: BH $    $Date: 2020-06-26 $    $Revision: 1 $
//
// Module: int.v
// Project: iCESDM (Sigma Delta Modulator for Lattice iCE40)
// Description: Integrator
//
// Change history:  2020-06-26 Created file.
//                  2021-03-03 Added EXTEND parameter.
//                  2021-03-05 Added conditional compilation flag.
//
///////////////////////////////////////////////////////////////////////////////

`ifndef __INT_INCLUDE__
`define __INT_INCLUDE__
`endif
`ifndef __DFF_INCLUDE__
`include "../dff/dff.v"
`endif

module int(i_clk, i_en, i_rst, i_x, o_y);
    parameter I_WIDTH = 8;
    parameter EXTEND = 1; // Number of bits to extend accumulator and output bit widths.
    input i_clk, i_en, i_rst;
    input wire [(I_WIDTH-1):0] i_x;
    output [I_WIDTH+EXTEND-1:0] o_y;
    wire [I_WIDTH+EXTEND-1:0] i_x_ext, x_int;

    dff #(
        .WIDTH(I_WIDTH+EXTEND)
    ) zinv (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_d(x_int),
        .o_q(o_y)
    );

    assign i_x_ext = {{EXTEND{i_x[I_WIDTH-1]}}, i_x};
    assign x_int = (i_en==1) ? i_x_ext + o_y : i_x_ext;
endmodule