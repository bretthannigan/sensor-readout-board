///////////////////////////////////////////////////////////////////////////////
// $Author: BH $    $Date: 2022-02-09 $    $Revision: 0 $
//
// Module: rom_4ch.v
// Project: iCESDM (Sigma Delta Modulator for Lattice iCE40)
// Description: 4-channel read only memory.
//
// Change history:  2022-02-09 Created file (adapted from rom_2ch.v).
//
// ©2023 ETH Zurich, Brett Hannigan; D-HEST; Biomedical and Mobile Health Technology (BMHT) Lab; Carlo Menon
//
///////////////////////////////////////////////////////////////////////////////

`ifndef __ROM_4CH_INCLUDE__
`define __ROM_4CH_INCLUDE__
`endif

module rom_4ch(i_clk, i_en, i_addr_a, i_addr_b, i_addr_c, i_addr_d, o_data_a, o_data_b, o_data_c, o_data_d);
    parameter ADDR_WIDTH = 9;
    parameter DATA_WIDTH = 8;
    parameter LOAD_PATH = "";
    input i_clk, i_en;
    input [(ADDR_WIDTH-1):0] i_addr_a, i_addr_b, i_addr_c, i_addr_d;
    output reg [(DATA_WIDTH-1):0] o_data_a, o_data_b, o_data_c, o_data_d;
    reg [(DATA_WIDTH-1):0] mem [0:((1<<ADDR_WIDTH)-1)];

    initial if (LOAD_PATH) $readmemh(LOAD_PATH, mem);

    always @(posedge i_clk)
    begin
        if (i_en)
            o_data_a <= mem[i_addr_a];
            o_data_b <= mem[i_addr_b];
            o_data_c <= mem[i_addr_c];
            o_data_d <= mem[i_addr_d];
    end
endmodule