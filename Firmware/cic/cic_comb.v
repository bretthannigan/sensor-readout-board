`ifndef __CIC_COMB_INCLUDE__
`define __CIC_COMB_INCLUDE__
`endif

module cic_comb(i_clk, i_en, i_rst, i_data, o_data);
    parameter WIDTH = 8;
    input i_clk, i_en, i_rst;
    input [(WIDTH-1):0] i_data;
    output reg [(WIDTH-1):0] o_data;

    reg signed [(WIDTH-1):0] delay;

    initial
    begin
        delay <= 0;
    end

    always @(posedge i_clk)
    begin
        if (i_en)
        begin
            if (i_rst)
            begin
                delay <= 0;
            end
            else
            begin
                o_data <= i_data - delay;
                delay <= i_data;
            end
        end
    end
endmodule