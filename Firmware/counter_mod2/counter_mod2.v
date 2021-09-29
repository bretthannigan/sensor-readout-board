///////////////////////////////////////////////////////////////////////////////
// $Author: BH $    $Date: 2018-11-04 $    $Revision: 1 $
//
// Module: counter_mod2.v
// Project: iCESDM (Sigma Delta Modulator for Lattice iCE40)
// Description: Arbitrary 2^n counter register.
//
// Change history:  2018-11-04 Created file.
//                  2018-11-11 Changed parameter name from N to WIDTH.
//                  2020-06-25 Made reset synchronous to be synthesizable on iCE40 hardware.
//                             Renamed inputs/outputs with i_/o_ prefix.
//                  2021-03-05 Added conditional compilation flag.
//
///////////////////////////////////////////////////////////////////////////////

`ifndef __COUNTER_MOD2_INCLUDE__
`define __COUNTER_MOD2_INCLUDE__
`endif

module counter_mod2(i_clk, i_en, i_rst, i_ld, i_up, i_data, o_data);
    parameter WIDTH = 4;
    parameter STEP = 1;
    input i_clk, i_en, i_rst, i_up, i_ld;
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
            else if (i_up)
                next <= next + STEP;
            else
                next <= next - STEP;
        end
    end
    assign o_data = next;
endmodule