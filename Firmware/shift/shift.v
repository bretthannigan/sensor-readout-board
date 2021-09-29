///////////////////////////////////////////////////////////////////////////////
// $Author: BH $    $Date: 2018-11-11 $    $Revision: 0 $
//
// Module: shift.v
// Project: iCESDM (Sigma Delta Modulator for Lattice iCE40)
// Description: Shift register with parallel out.
//
// Change history:  2018-11-11 Created file.
//                  2018-11-12 Added parallel out functionality.
//                  2021-03-05 Added conditional compilation flag.
//
///////////////////////////////////////////////////////////////////////////////

`ifndef __SHIFT_INCLUDE__
`define __SHIFT_INCLUDE__
`endif

module shift(i_clk, i_en, i_rst, i_data, o_ser, o_par);
    parameter WIDTH = 1;
    parameter LENGTH = 2;
    input i_clk, i_en, i_rst;
    input [WIDTH-1:0] i_data;
    output [WIDTH-1:0] o_ser;
    output [LENGTH*WIDTH-1:0] o_par;
    reg [LENGTH*WIDTH-1:0] sreg;

    always @(posedge i_clk)
    begin
        if (i_en)
            if (i_rst)
                sreg <= 0;
            else
                sreg <= {sreg[(LENGTH-1)*WIDTH-1:0], i_data};
    end
    assign o_ser = sreg[LENGTH*WIDTH-1:(LENGTH-1)*WIDTH];
    assign o_par = sreg;
endmodule