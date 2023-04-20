// ©2023 ETH Zurich, Brett Hannigan; D-HEST; Biomedical and Mobile Health Technology (BMHT) Lab; Carlo Menon

module cic_integrator(i_clk, i_en, i_rst, i_data, o_data);
    parameter WIDTH = 8;
    input i_clk, i_en, i_rst;
    input [(WIDTH-1):0] i_data;
    output [(WIDTH-1):0] o_data;

    reg signed [(WIDTH-1):0] int;

    initial
    begin
        int <= 0;
    end

    always @(posedge i_clk)
    begin
        if (i_en)
        begin
            if (i_rst)
            begin
                int <= 0;
            end
            else
            begin
                int <= int + i_data;
            end
        end
    end

    assign o_data = int;
endmodule
