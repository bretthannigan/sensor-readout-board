///////////////////////////////////////////////////////////////////////////////
// $Author: BH $    $Date: 2020-06-26 $    $Revision: 1 $
//
// Module: dff.v
// Project: iCESDM (Sigma Delta Modulator for Lattice iCE40)
// Description: D flip-flop.
//
// Change history:  2020-06-26 Created file.
//                  2021-03-05 Added conditional compilation flag.
//
// ©2023 ETH Zurich, Brett Hannigan; D-HEST; Biomedical and Mobile Health Technology (BMHT) Lab; Carlo Menon
//
///////////////////////////////////////////////////////////////////////////////

`ifndef __DFF_INCULDE__
`define __DFF_INCLUDE__
`endif

module dff(i_clk, i_rst, i_d, o_q);
    parameter WIDTH = 1;
    input i_clk, i_rst;
    input [WIDTH-1:0] i_d;
    output [WIDTH-1:0] o_q;
    reg [WIDTH-1:0] q;

    initial begin
        q <= {WIDTH{1'b0}};
    end

    always @(posedge i_clk)
    begin
        if (i_rst)
            q <= {WIDTH{1'b0}};
        else
            q <= i_d;
    end
    assign o_q = q;
endmodule