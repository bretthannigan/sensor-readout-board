///////////////////////////////////////////////////////////////////////////////
// $Author: BH $    $Date: 2021-03-16 $    $Revision: 0 $
//
// Module: min_transmit_fsm_unlatched.v
// Project: iCESDM (Sigma Delta Modulator for Lattice iCE40)
// Description: Transmitter finite state machine for MIN protocol.
// See also:    [1] https://github.com/min-protocol/min/wiki/Frame
//              [2] https://verilogguide.readthedocs.io/en/latest/verilog/fsm.html#verilog-mealy-regular-template
//
// Change history: 2021-03-16 Created file.
//
///////////////////////////////////////////////////////////////////////////////

`default_nettype none

`ifndef __MIN_TRANSMIT_FSM_INCLUDE__
`define __MIN_TRANSMIT_FSM_INCLUDE__
`endif

`ifndef __COUNTER_MODN_INCLUDE__
`include "../counter_modn/counter_modn.v"
`endif

module min_transmit_fsm_unlatched(i_clk, i_rst, i_en, i_id, i_data, i_crc32, o_istx, o_data);

    parameter N_DATA_BYTE = 4;
    localparam N_STATE = 8;
    localparam STATE_WIDTH = $clog2(N_STATE);
    localparam COUNTER_WIDTH = $clog2(N_DATA_BYTE + 8);
    localparam [(STATE_WIDTH-1):0]
        STATE_IDLE = 0,
        STATE_SOF0 = 1,
        STATE_SOF1 = 2,
        STATE_SOF2 = 3,
        STATE_BODY = 4,
        STATE_EOF  = 5,
        STATE_ESC0 = 6,
        STATE_ESC1 = 7;
    localparam SOF = 8'hAA;
    localparam EOF = 8'h55;

    input wire i_clk, i_rst, i_en;
    input wire [7:0] i_id;
    input wire [(N_DATA_BYTE*8-1):0] i_data;
    input wire [31:0] i_crc32;
    output reg o_istx;
    output reg [7:0] o_data;

    reg[(STATE_WIDTH-1):0] state_reg, state_next;
    reg body_counter_en, body_counter_rst;
    wire [(COUNTER_WIDTH-1):0] body_cnt;

    counter_modn #(
        .WIDTH(COUNTER_WIDTH),
        .N(N_DATA_BYTE + 8)
    ) counter (
        .i_clk(i_clk),
        .i_en(body_counter_en),
        .i_rst(body_counter_rst),
        .o_data(body_cnt)
    );

    wire [7:0] i_array [0:(N_DATA_BYTE+7)];
    assign i_array[0] = SOF;
    assign i_array[1] = i_id;
    assign i_array[2] = N_DATA_BYTE;
    genvar i;
    for (i=0; i<N_DATA_BYTE; i=i+1)
    begin
        assign i_array[3+i] = i_data[((N_DATA_BYTE-i)*8-1)-:8];
    end
    for (i=0; i<4; i=i+1)
    begin
        assign i_array[3+N_DATA_BYTE+i] = i_crc32[((4-i)*8-1)-:8];
    end
    assign i_array[7+N_DATA_BYTE] = EOF;

    initial begin
        state_reg = {STATE_WIDTH{1'b0}};
        state_next = {STATE_WIDTH{1'b0}};
        body_counter_en = 0;
        body_counter_rst = 1;
    end

    always @(posedge i_clk, posedge i_rst) begin
        if (i_rst) begin
            state_reg <= STATE_SOF0;
            body_counter_rst = 1;
        end
        else begin
            state_reg <= state_next;
        end
    end 

    always @(i_en, i_data, body_cnt, state_reg) begin 
        // Defaults:
        state_next = state_reg;
        o_data = i_array[body_cnt];
        body_counter_en = 1;
        body_counter_rst = 1;
        o_istx = 1;
        case (state_reg)
            STATE_IDLE : begin // Idle state.
                o_data = 8'h00;
                o_istx = 0;
                if (i_en)
                    state_next = STATE_SOF0;
            end
            STATE_SOF0 : begin // Start of frame byte 1.
                state_next = STATE_SOF1;
            end
            STATE_SOF1 : begin // Start of frame byte 2.
                state_next = STATE_SOF2;
            end
            STATE_SOF2 : begin // Start of frame byte 3.
                body_counter_rst = 0;
                state_next = STATE_BODY;
            end
            STATE_BODY : begin
                body_counter_rst = 0;
                if (body_cnt==(6+N_DATA_BYTE))
                begin
                    state_next = STATE_EOF;
                end
                else if (i_array[body_cnt]==SOF)
                    state_next = STATE_ESC0;
                else
                    state_next = STATE_BODY;
            end
            STATE_ESC0 : begin // First 0xAA byte.
                body_counter_rst = 0;
                if (body_cnt==(6+N_DATA_BYTE)) // Done entire payload.
                begin
                    state_next = STATE_EOF;
                end
                else if (i_array[body_cnt]==SOF)
                begin
                    state_next = STATE_ESC1;
                end
                else
                    state_next = STATE_BODY;
            end
            STATE_ESC1 : begin // Byte stuffing.
                body_counter_en = 0;
                body_counter_rst = 0;
                o_data = EOF;
                state_next = STATE_BODY;
            end
            STATE_EOF : begin // End frame.
                state_next = STATE_IDLE;
            end
        endcase
    end 

endmodule