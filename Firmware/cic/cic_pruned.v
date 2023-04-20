///////////////////////////////////////////////////////////////////////////////
// $Author: BH $    $Date: 2020-10-20 $    $Revision: 0 $
//
// Module: CIC_pruned.v
// Project: iCESDM (Sigma Delta Modulator for Lattice iCE40)
// Description: Cascaded integrator comb filter with variable-length registers.
//
// Change history:  2020-06-01 Created file.
//
// ©2023 ETH Zurich, Brett Hannigan; D-HEST; Biomedical and Mobile Health Technology (BMHT) Lab; Carlo Menon
//
///////////////////////////////////////////////////////////////////////////////

`ifndef __CIC_PRUNED_INCLUDE__
`define __CIC_PRUNED_INCLUDE__
`endif
`ifndef __COUNTER_MOD2_INCLUDE__
`include "../counter_mod2/counter_mod2.v"
`endif
`ifndef __INT_INCLUDE__
`include "../int/int.v"
`endif
`ifndef __CIC_COMB_INCLUDE__
`include "cic_comb.v"
`endif

module cic_pruned(i_clk, i_en, i_rst, i_data, o_data, o_clk);
    parameter I_WIDTH = 1;
    parameter ORDER = 3; // 'M'
    parameter DECIMATION_BITS = 5; // 'R', decimation ratio = 2^(DECIMATION_BITS)
    localparam REG_WIDTH = I_WIDTH + ORDER*DECIMATION_BITS;
    // REG_WIDTHS is a (2*ORDER + 1)-element vector of 8-bit values defining the width of the output, each comb stage, and each integrator stage as follows:
    //  OUTPUT COMB[<ORDER>]  ...  COMB[2] COMB[1] INT[<ORDER>]  ...  INT[2] INT[1]
    // [      |             | ... |       |       |            | ... |      |      ]
    parameter [(ORDER*2*8+7):0] REG_WIDTHS = {(2*ORDER+1){REG_WIDTH[7:0]}};
    localparam O_WIDTH = REG_WIDTHS[(ORDER*2*8)+:8];
    input i_clk, i_en, i_rst;
    input signed [(I_WIDTH-1):0] i_data;
    output o_clk;
    output signed [(O_WIDTH-1):0] o_data;

    wire dec_clk;
    wire [(DECIMATION_BITS-1):0] dec;

    genvar i;
    generate
        for (i=0; i<ORDER; i=i+1)
        begin: intStage
            //localparam INT_STAGE_WIDTH = REG_WIDTHS[i*8+:8];
            wire signed [(REG_WIDTHS[i*8+:8]-1):0] i_stage;
            wire signed [(REG_WIDTHS[i*8+:8]-1):0] o_stage;
            int #(
                .I_WIDTH(REG_WIDTHS[i*8+:8]), 
                .EXTEND(0)
            ) int (
                .i_clk(i_clk),
                .i_en(i_en), 
                .i_rst(i_rst), 
                .i_x(intStage[i].i_stage), 
                .o_y(intStage[i].o_stage) 
            );
            // if (i==0)
            //     assign intStage[i].i_stage = {{(REG_WIDTHS[i*8+:8]-I_WIDTH){i_data[I_WIDTH-1]}}, i_data};
            // else
            if (i>0)
            begin
                //localparam PREV_INT_STAGE_WIDTH = REG_WIDTHS[(i-1)*8+:8];
                assign intStage[i].i_stage = intStage[i-1].o_stage[(REG_WIDTHS[(i-1)*8+:8]-1)-:REG_WIDTHS[i*8+:8]];
            end
        end
    endgenerate

    assign intStage[0].i_stage = {{(REG_WIDTHS[7:0]-I_WIDTH){i_data[I_WIDTH-1]}}, i_data};
    //assign intStage[0].i_stage = {{(REG_WIDTHS[7:0]-I_WIDTH){1'b0}}, i_data};


    if (DECIMATION_BITS==0)
    begin
        assign dec_clk = i_clk;
    end
    else
    begin
        counter_mod2 #(
            .WIDTH(DECIMATION_BITS)
        ) dec_cnt (
            .i_clk(i_clk),
            .i_en(i_en),
            .i_rst(i_rst),
            .i_ld(1'b0),
            .i_up(1'b1),
            .o_data(dec)
        );
        assign dec_clk = dec[DECIMATION_BITS-1];
    end

    genvar j;
    generate
        for (j=0; j<ORDER; j=j+1)
        begin: combStage
            //localparam COMB_STAGE_WIDTH = REG_WIDTHS[(j+3)*8+:8];
            wire signed [(REG_WIDTHS[(j+3)*8+:8]-1):0] i_stage;
            wire signed [(REG_WIDTHS[(j+3)*8+:8]-1):0] o_stage;
            cic_comb #(
                .WIDTH(REG_WIDTHS[(j+3)*8+:8])
            ) comb (
                .i_clk(dec_clk),
                .i_en(i_en),
                .i_rst(i_rst),
                .i_data(combStage[j].i_stage),
                .o_data(combStage[j].o_stage)
            );
            if (j>0)
            begin
                //localparam PREV_COMB_STAGE_WIDTH = REG_WIDTHS[(j+2)*8+:8];
                assign combStage[j].i_stage = combStage[j-1].o_stage[(REG_WIDTHS[(j+2)*8+:8]-1)-:REG_WIDTHS[(j+3)*8+:8]];
            end
        end
    endgenerate

    localparam LAST_INT_STAGE_WIDTH = REG_WIDTHS[(ORDER-1)*8+:8];
    localparam FIRST_COMB_STAGE_WIDTH = REG_WIDTHS[(ORDER*8)+:8];
    reg [(FIRST_COMB_STAGE_WIDTH-1):0] int_to_comb;
    always @(posedge dec_clk)
    begin
        int_to_comb <= intStage[ORDER-1].o_stage[(LAST_INT_STAGE_WIDTH-1)-:FIRST_COMB_STAGE_WIDTH];
    end
    assign combStage[0].i_stage = int_to_comb;

    localparam LAST_COMB_STAGE_WIDTH = REG_WIDTHS[((ORDER*2-1)*8)+:8];
    assign o_data = combStage[ORDER-1].o_stage[(LAST_COMB_STAGE_WIDTH-1)-:O_WIDTH];

    assign o_clk = dec_clk;

endmodule