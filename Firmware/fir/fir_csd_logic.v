///////////////////////////////////////////////////////////////////////////////
// $Author: BH $    $Date: 2021-11-25 $    $Revision: 0 $
//
// Module: FIR_CSD_logic.v
// Project: iCESDM (Sigma Delta Modulator for Lattice iCE40)
// Description: Logic for multiplierless FIR filter.
//
// Change history:  2021-11-25 Created file.
//
// ©2023 ETH Zurich, Brett Hannigan; D-HEST; Biomedical and Mobile Health Technology (BMHT) Lab; Carlo Menon
//
///////////////////////////////////////////////////////////////////////////////

`ifndef __FIR_CSD_LOGIC_INCLUDE__
`define __FIR_CSD_LOGIC_INCLUDE__
`endif

module fir_csd_logic(i_clk, i_en, i_data, o_data);
    parameter I_WIDTH = 16;
    parameter ORDER = 17;
    parameter O_WIDTH = 16;
    localparam INTERNAL_WIDTH = O_WIDTH + 8;
    input i_clk, i_en;
    input wire [(I_WIDTH*ORDER-1):0] i_data;
    output [(O_WIDTH-1):0] o_data;
    reg [(INTERNAL_WIDTH-1):0] filt;

    wire [(I_WIDTH-1):0] delay_line [0:(ORDER-1)];

    genvar i;
    generate
        for (i=0; i<ORDER; i=i+1)
        begin
            assign delay_line[i] = i_data[(i*I_WIDTH)+:I_WIDTH];
        end
    endgenerate

    always @(posedge i_clk)
    begin
        filt <= (-(delay_line[0] <<< 0) + 
            (delay_line[1] <<< 1) + 
            (delay_line[2] <<< 3) + (delay_line[2] <<< 1) +
            (delay_line[3] <<< 0) + 
            -(delay_line[4] <<< 5) - (delay_line[4] <<< 0) +
            -(delay_line[5] <<< 5) - (delay_line[5] <<< 2) + 
            (delay_line[6] <<< 6) - (delay_line[6] <<< 2) +
            (delay_line[7] <<< 8) - (delay_line[7] <<< 5) - (delay_line[7] <<< 1) +
            (delay_line[8] <<< 8) + (delay_line[8] <<< 6) - (delay_line[8] <<< 4) + 
            (delay_line[9] <<< 8) - (delay_line[9] <<< 5) - (delay_line[9] <<< 1) +
            (delay_line[10] <<< 6) - (delay_line[1] <<< 2) + 
            -(delay_line[11] <<< 5) - (delay_line[11] <<< 2) +
            -(delay_line[12] <<< 5) - (delay_line[12] <<< 0) +
            (delay_line[13] <<< 0) + 
            (delay_line[14] <<< 3) + (delay_line[14] <<< 1) +
            (delay_line[15] <<< 1) + 
            -(delay_line[16] <<< 0));
    end

    assign o_data = filt[(INTERNAL_WIDTH-1)-:O_WIDTH];

endmodule