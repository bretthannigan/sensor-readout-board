///////////////////////////////////////////////////////////////////////////////
// $Author: BH $    $Date: 2021-12-01 $    $Revision: 0 $
//
// Module: FIR_CSD_logic_varcoef.v
// Project: iCESDM (Sigma Delta Modulator for Lattice iCE40)
// Description: Logic for multiplierless FIR filter with variable coefficients.
//
// Change history:  2021-12-01 Created file from fir_csd_logic.v.
//
// ©2023 ETH Zurich, Brett Hannigan; D-HEST; Biomedical and Mobile Health Technology (BMHT) Lab; Carlo Menon
//
///////////////////////////////////////////////////////////////////////////////

`ifndef __FIR_CSD_LOGIC_INCLUDE__
`define __FIR_CSD_LOGIC_INCLUDE__
`endif

module fir_csd_logic_varcoef(i_clk, i_en, i_data, o_data);
    parameter I_WIDTH = 16;
    parameter O_WIDTH = 16;
    parameter ORDER = 17;
    parameter N_SHIFT = 9;
    localparam N_ADD = ORDER*N_SHIFT;
    localparam INTERNAL_WIDTH = I_WIDTH + N_SHIFT;
    `include "coefficients.vh"
    
    input i_clk, i_en;
    input wire [(I_WIDTH*ORDER-1):0] i_data;
    output [(O_WIDTH-1):0] o_data;
    reg [(INTERNAL_WIDTH-1):0] filt;

    wire [(INTERNAL_WIDTH-1):0] to_add [0:(N_ADD-1)];

    genvar i, j;
    generate
        for (i=0; i<ORDER; i=i+1)
        begin
            for (j=0; j<N_SHIFT; j=j+1)
            begin
                if (COEF_VEC[2*(N_SHIFT*i+j)+:2]==2'b01) // +1
                    assign to_add[(N_SHIFT*i+j)] = i_data[(i*I_WIDTH)+:I_WIDTH] <<< j;
                else if (COEF_VEC[2*(N_SHIFT*i+j)+:2]==2'b11) // -1
                    assign to_add[(N_SHIFT*i+j)] = (-i_data[(i*I_WIDTH)+:I_WIDTH]) <<< j;
                else // 0
                    assign to_add[(N_SHIFT*i+j)] = {INTERNAL_WIDTH{1'b0}};
            end
        end
    endgenerate

    integer l;

    always @(posedge i_clk)
    begin
        filt = 0;
        for (l=0; l<N_ADD; l=l+1)
        begin
            filt = filt + to_add[l];
        end
    end

    assign o_data = filt[(INTERNAL_WIDTH-1)-:O_WIDTH];

endmodule