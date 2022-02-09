///////////////////////////////////////////////////////////////////////////////
// $Author: BH $    $Date: 2020-07-10 $    $Revision: 0 $
//
// Module: rom_2ch.v
// Project: iCESDM (Sigma Delta Modulator for Lattice iCE40)
// Description: 2-channel read only memory.
//
// Change history:  2020-07-10 Created file.
//                  2021-03-02 Parameterized data loading path.
//                  2021-03-05 Added conditional compilation flag.
//
///////////////////////////////////////////////////////////////////////////////

`ifndef __ROM_2CH_INCLUDE__
`define __ROM_2CH_INCLUDE__
`endif

module rom_2ch(i_clk, i_en, i_addr_a, i_addr_b, o_data_a, o_data_b);
    parameter ADDR_WIDTH = 9;
    parameter DATA_WIDTH = 8;
    parameter LOAD_PATH = "";
    input i_clk, i_en;
    input [(ADDR_WIDTH-1):0] i_addr_a, i_addr_b;
    output reg [(DATA_WIDTH-1):0] o_data_a, o_data_b;
    reg [(DATA_WIDTH-1):0] mem [0:((1<<ADDR_WIDTH)-1)];

    initial if (LOAD_PATH) $readmemh(LOAD_PATH, mem);

    always @(posedge i_clk)
    begin
        if (i_en)
            o_data_a <= mem[i_addr_a];
            o_data_b <= mem[i_addr_b];
    end
endmodule 