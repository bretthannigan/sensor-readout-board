///////////////////////////////////////////////////////////////////////////////
// $Author: BH $    $Date: 2020-06-26 $    $Revision: 0 $
//
// Module: counter_modn.v
// Project: iCESDM (Sigma Delta Modulator for Lattice iCE40)
// Description: Arbitrary counter register.
//
// Change history:  2020-06-26 Created file.
//                  2021-03-05 Added conditional compilation flag.
//
///////////////////////////////////////////////////////////////////////////////

`ifndef __COUNTER_MODN_INCLUDE__
`define __COUNTER_MODN_INCLUDE__
`endif

module counter_modn(i_clk, i_en, i_rst, i_ld, i_data, o_data);
    parameter WIDTH = 4;
    parameter N = 10;
    input i_clk, i_en, i_rst, i_ld;
    input [WIDTH-1:0] i_data;
    output [WIDTH-1:0] o_data;
    reg [WIDTH-1:0] next;

    initial
    begin
        next = {WIDTH{1'b0}};
    end

    always @(posedge i_clk)
    begin
        if (i_en) begin
            if (i_rst)
                next <= {WIDTH{1'b0}};
            else if (i_ld)
                next <= i_data;
            else if (next == N-1)
                next <= {WIDTH{1'b0}};
            else
                next <= next + 1'b1;
        end
    end
    assign o_data = next;
endmodule