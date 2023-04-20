///////////////////////////////////////////////////////////////////////////////
// $Author: BH $    $Date: 2020-10-20 $    $Revision: 0 $
//
// Module: CIC.v
// Project: iCESDM (Sigma Delta Modulator for Lattice iCE40)
// Description: Cascaded integrator comb filter.
//
// Change history:  2020-10-20 Created file.
//                  2021-03-03 Switched to using int.v integrator with EXTEND parameter.
//                  2021-03-05 Added conditional compilation flags.
//                  2021-05-26 Removed sign extension for i_data (caused overflow with 1-bit I_WIDTH).
//                  2021-06-01 Replaced sign extension for i_data.
//
// ©2023 ETH Zurich, Brett Hannigan; D-HEST; Biomedical and Mobile Health Technology (BMHT) Lab; Carlo Menon
//
///////////////////////////////////////////////////////////////////////////////

`ifndef __CIC_INCLUDE__
`define __CIC_INCLUDE__
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

module cic(i_clk, i_en, i_rst, i_data, o_data, o_clk);
    parameter I_WIDTH = 1;
    parameter ORDER = 3; // 'M'
    parameter DECIMATION_BITS = 5; // 'R', decimation ratio = 2^(DECIMATION_BITS)
    parameter REG_WIDTH = I_WIDTH + ORDER*DECIMATION_BITS;
    input i_clk, i_en, i_rst;
    input signed [(I_WIDTH-1):0] i_data;
    output o_clk;
    output signed [(REG_WIDTH-1):0] o_data;

    wire dec_clk;
    wire [(DECIMATION_BITS-1):0] dec;
    wire [(REG_WIDTH-1):0] i_data_ext;
    wire [(REG_WIDTH-1):0] int_stage [ORDER:0];
    wire [(REG_WIDTH-1):0] comb_stage [ORDER:0];
    wire [(REG_WIDTH):0] o_int;
    reg [(REG_WIDTH):0] test;

    assign i_data_ext = { {(REG_WIDTH-I_WIDTH){i_data[I_WIDTH-1]}}, i_data };
    //assign i_data_ext = { {(REG_WIDTH-I_WIDTH){1'b0}}, i_data };
    assign int_stage[0][(REG_WIDTH-1):0] = i_data_ext;

    genvar i;
    generate
        for (i=0; i<ORDER; i=i+1)
        begin
            int #(
                .I_WIDTH(REG_WIDTH), 
                .EXTEND(0)
            ) int (
                .i_clk(i_clk),
                .i_en(i_en), 
                .i_rst(i_rst), 
                .i_x(int_stage[i][(REG_WIDTH-1):0]), 
                .o_y(int_stage[i+1][(REG_WIDTH-1):0]) 
            );
        end
    endgenerate

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

    always @(posedge dec_clk)
    begin
        test <= int_stage[ORDER][(REG_WIDTH-1):0];
    end

    assign comb_stage[0][(REG_WIDTH-1):0] = test;

    genvar j;
    generate
        for (j=0; j<ORDER; j=j+1)
        begin
            cic_comb #(
                .WIDTH(REG_WIDTH)
            ) comb (
                .i_clk(dec_clk),
                .i_en(i_en),
                .i_rst(i_rst),
                .i_data(comb_stage[j][(REG_WIDTH-1):0]),
                .o_data(comb_stage[j+1][(REG_WIDTH-1):0])
            );
        end
    endgenerate

    assign o_clk = dec_clk;
    assign o_data = comb_stage[ORDER][(REG_WIDTH-1):0];

endmodule