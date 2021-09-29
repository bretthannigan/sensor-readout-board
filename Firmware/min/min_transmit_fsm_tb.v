///////////////////////////////////////////////////////////////////////////////
// $Author: BH $    $Date: 2021-03-16 $    $Revision: 0 $
//
// Module: min_transmit_fsm_tb.v
// Project: iCESDM (Sigma Delta Modulator for Lattice iCE40)
// Description: Test bench for transmitter finite state machine for MIN protocol.
//
// Change history: 2021-03-16 Created file.
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ns
`include "min_transmit_fsm.v"

module min_transmit_fsm_tb();

reg clk, rst, en;
reg [7:0] id;
reg [15:0] data;
wire istx;
wire [7:0] msg;

min_transmit_fsm #(
    .N_DATA_BYTE(2)
) DUT (
    .i_clk(clk),
    .i_rst(rst),
    .i_en(en),
    .i_id(id),
    .i_data(data),
    .o_istx(istx),
    .o_data(msg),
    .o_state()
);

always
#10 clk = ~clk;

initial
begin
    clk = 0;
    en = 1;
    rst = 0;
    id = 8'h01;
    data = 16'h0000;
end

initial
    #2000 $stop;

initial begin
    $dumpfile("out.vcd");
    $dumpvars(0,DUT);
end

endmodule