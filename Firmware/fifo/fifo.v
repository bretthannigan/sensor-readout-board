///////////////////////////////////////////////////////////////////////////////
// $Author: BH $    $Date: 2021-03-09 $    $Revision: 2 $
//
// Module: fifo.v
// Project: iCESDM (Sigma Delta Modulator for Lattice iCE40)
// Description: First-in-first-out queue.
// See also: based off the slides from https://zipcpu.com/tutorial/lsn-10-fifo.pdf
//
// Change history:  2021-03-09 Created file.
//                  2021-03-09 Added OVERWITE_OLD parameter.
//                  2021-05-07 Moved increment of addr_rd to read block to fix
//                             "multiply driven" error.
//
///////////////////////////////////////////////////////////////////////////////

`default_nettype none

`ifndef __FIFO_INCLUDE__
`define __FIFO_INCLUDE__
`endif

module fifo(i_clk, i_en, i_rst, i_wr, i_rd, i_data, o_full, o_empty, o_data);
    parameter ADDR_WIDTH = 8;
    parameter DATA_WIDTH = 8;
    parameter OVERWRITE_OLD = 0; // Set to 1 to keep most recent values in memory.
    input i_clk, i_en, i_rst, i_wr, i_rd;
    input [(DATA_WIDTH-1):0] i_data;
    output reg o_full, o_empty;
    output reg [(DATA_WIDTH-1):0] o_data;

    reg	[(DATA_WIDTH-1):0] mem [0:((1<<ADDR_WIDTH)-1)];
    reg	[ADDR_WIDTH:0] addr_rd, addr_wr, o_fill;

    initial
    begin
        addr_wr = 0;
        addr_rd = 0;
    end

    always @(*) 
        o_fill <= addr_wr - addr_rd;

    always @(*)
    begin
        o_empty = (o_fill == 0);
        o_full = (o_fill == {1'b1, {(ADDR_WIDTH){1'b0}}});
    end

    wire wr, rd;
    assign wr = i_wr && (!o_full || OVERWRITE_OLD);
    assign rd = i_rd && !o_empty;

    // Write
    always @(posedge i_clk)
    begin
        if (i_en)
        begin
            if (i_rst)
                addr_wr = 0;
            if (wr)
            begin
                addr_wr <= addr_wr + 1;
                mem[addr_wr[(ADDR_WIDTH-1):0]] <= i_data;
            end
        end
    end

    // Read
    always @(posedge i_clk)
    begin
        if (i_en)
        begin
            if (i_rst)
                addr_rd = 0;
            if (rd)
            begin
                addr_rd <= addr_rd + 1;
                o_data <= mem[addr_rd[(ADDR_WIDTH-1):0]];
            end
            else if (o_full && OVERWRITE_OLD)
                addr_rd = addr_rd + 1;
        end
    end

endmodule