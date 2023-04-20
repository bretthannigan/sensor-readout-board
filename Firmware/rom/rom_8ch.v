///////////////////////////////////////////////////////////////////////////////
// $Author: BH $    $Date: 2022-06-01 $    $Revision: 0 $
//
// Module: rom_8ch.v
// Project: iCESDM (Sigma Delta Modulator for Lattice iCE40)
// Description: 8-channel read only memory.
//
// Change history:  2022-06-31 Created file (adapted from rom_4ch.v).
//
// ©2023 ETH Zurich, Brett Hannigan; D-HEST; Biomedical and Mobile Health Technology (BMHT) Lab; Carlo Menon
//
///////////////////////////////////////////////////////////////////////////////

`ifndef __ROM_8CH_INCLUDE__
`define __ROM_8CH_INCLUDE__
`endif

module rom_8ch(i_clk, i_en, i_addr_a, i_addr_b, i_addr_c, i_addr_d, i_addr_e, i_addr_f, i_addr_g, i_addr_h, o_data_a, o_data_b, o_data_c, o_data_d, o_data_e, o_data_f, o_data_g, o_data_h);
    parameter ADDR_WIDTH = 9;
    parameter DATA_WIDTH = 8;
    parameter LOAD_PATH = "";
    input i_clk, i_en;
    input [(ADDR_WIDTH-1):0] i_addr_a, i_addr_b, i_addr_c, i_addr_d, i_addr_e, i_addr_f, i_addr_g, i_addr_h;
    output reg [(DATA_WIDTH-1):0] o_data_a, o_data_b, o_data_c, o_data_d, o_data_e, o_data_f, o_data_g, o_data_h;
    reg [(DATA_WIDTH-1):0] mem [0:((1<<ADDR_WIDTH)-1)];

    initial if (LOAD_PATH) $readmemh(LOAD_PATH, mem);

    always @(posedge i_clk)
    begin
        if (i_en)
            o_data_a <= mem[i_addr_a];
            o_data_b <= mem[i_addr_b];
            o_data_c <= mem[i_addr_c];
            o_data_d <= mem[i_addr_d];
            o_data_e <= mem[i_addr_e];
            o_data_f <= mem[i_addr_f];
            o_data_g <= mem[i_addr_g];
            o_data_h <= mem[i_addr_h];
    end
endmodule