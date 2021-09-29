

`timescale 1ns/1ns
`include "shift.v"
module shift_tb();

reg clk, rst, en;
reg [7:0] din;
wire [7:0] out_ser;
wire [31:0] out_par;

shift #(
    .WIDTH(8),
    .LENGTH(4)
) DUT (
    .i_clk(clk),
    .i_en(en),
    .i_rst(rst),
    .i_data(din),
    .o_ser(out_ser),
    .o_par(out_par)
);

always
#10 clk = ~clk;

initial
begin
    clk = 0;
    en = 1;
    rst = 0;
    din = 8'h11;
    #20 rst = 1'b1;
    #10 rst = 1'b0;
    #20 din = 8'h12;
    #20 din = 8'h13;
    #20 din = 8'h14;
    #20 din = 8'h15;
    #20 din = 8'h16;
    #10 rst = 1'b1;
end

initial 
begin
    #400 $stop;
end

initial
begin
    $dumpfile("out.vcd");
    $dumpvars(0,DUT);
end
 
initial
$monitor($stime,, rst,, clk,, din,, out_ser,, out_par);

endmodule