// -----------------------------------------------------------------------------
// Copyright (c) 2019-2022 All rights reserved
// -----------------------------------------------------------------------------
// Author 	 : WCC 1530604142@qq.com
// File   	 : stream_aggregation
// Create 	 : 2022-09-16
// Revise 	 : 2022-
// Editor 	 : Vscode, tab size (4)
// Version	 : v1.0  create file
// Functions : stream aggregation for rx data and resp
//
// -----------------------------------------------------------------------------
`timescale 1ns / 1ps

module stream_aggregation #(
    parameter CHDR_W = 64,
    parameter USER_W = 16,
    parameter BUFFER = 0
    )(
    input clk, input reset, input clear,
    input [CHDR_W-1:0] i0_tdata, input i0_tlast, input i0_tvalid, output i0_tready,
    input [CHDR_W-1:0] i1_tdata, input i1_tlast, input i1_tvalid, output i1_tready,
    output [CHDR_W-1:0] o_tdata, output [USER_W-1:0] o_tuser, output o_tlast, output o_tvalid, input o_tready
    );

    localparam MX_IDLE = 3'b000;
    localparam MX_0    = 3'b001;
    localparam MX_1    = 3'b010;
    localparam MX_2    = 3'b100;


    localparam R0_CTRL_SID = 8'h10;
    localparam U0_CTRL_SID = 8'h30;
    localparam L0_CTRL_SID = 8'h40;
    localparam R0_DATA_SID = 8'h50;
    localparam R1_DATA_SID = 8'h60;
    localparam DEMUX_SID_MASK = 8'hf0;

    reg [2:0] 	  mx_state;

    wire [CHDR_W-1:0]    i0_tdata_int;
    wire 	             i0_tlast_int;
    wire                 i0_tvalid_int;
    wire                 i0_tready_int;

    wire [CHDR_W-1:0]    i1_tdata_int;
    wire 	             i1_tlast_int;
    wire                 i1_tvalid_int;
    wire                 i1_tready_int;

    reg [CHDR_W-1:0]    o_tdata_int;
    reg  [USER_W-1:0]   o_tuser_int;
    reg                 o_tvalid_int;
    reg 	            o_tlast_int;
    wire                o_tready_int;

    generate
        if(BUFFER == 0) begin
            assign i0_tdata_int = i0_tdata;
            assign i0_tlast_int = i0_tlast;
            assign i0_tvalid_int = i0_tvalid;
            assign i0_tready = i0_tready_int;
        end
        else
            axi_fifo #(
                .WIDTH(64+1),.SIZE(5)
            ) buffer_stream0 (
                .clk(clk), .reset(reset), .clear(1'b0),
                .i_tdata({i0_tlast,i0_tdata}), 
                .i_tvalid(i0_tvalid), .i_tready(i0_tready),
                .o_tdata({i0_tlast_int,i0_tdata_int}), 
                .o_tvalid(i0_tvalid_int), .o_tready(i0_tready_int),
                .space(), .occupied()
            );
    endgenerate

    generate
        if(BUFFER == 0) begin
            assign i1_tdata_int = i1_tdata;
            assign i1_tlast_int = i1_tlast;
            assign i1_tvalid_int = i1_tvalid;
            assign i1_tready = i1_tready_int;
        end
        else
            axi_fifo #(
                .WIDTH(64+1),.SIZE(11)
            ) buffer_stream1 (
                .clk(clk), .reset(reset), .clear(1'b0),
                .i_tdata({i1_tlast,i1_tdata}), 
                .i_tvalid(i1_tvalid), .i_tready(i1_tready),
                .o_tdata({i1_tlast_int,i1_tdata_int}), 
                .o_tvalid(i1_tvalid_int), .o_tready(i1_tready_int),
                .space(), .occupied()
            );
    endgenerate



    always @(posedge clk)
        if(reset | clear)
            mx_state <= MX_IDLE;
        else
        case (mx_state)
            MX_IDLE :
                // the resp is tx flow control
                if(i0_tvalid_int && i0_tdata_int[31:16] == 'h50 && i0_tdata_int[63]==1'b1)
                    mx_state <= MX_0;
                // the resp is ctrl resp
                else if (i0_tvalid_int & i0_tdata_int[63]==1'b1) begin
                    mx_state <= MX_1;
                end
                // this is rx data
                else if(i1_tvalid_int)
                    mx_state <= MX_2;
            MX_0 :
                if(o_tready_int & o_tvalid_int & o_tlast_int)
                    mx_state <= MX_IDLE;

            MX_1 :
                if(o_tready_int & o_tvalid_int & o_tlast_int)
                    mx_state <= MX_IDLE;

            MX_2 :
                if(o_tready_int & o_tvalid_int & o_tlast_int)
                    mx_state <= MX_IDLE;

            default :
                mx_state <= MX_IDLE;
        endcase // case (mx_state)

    // assign {i2_tready, i1_tready, i0_tready} = mx_state & {3{o_tready_int}};
        
    assign i0_tready_int = ((mx_state == MX_0) || (mx_state == MX_1)) & o_tready_int;
    assign i1_tready_int = (mx_state == MX_2) & o_tready_int;


    // stream 0 is resp will route to udp port 49200
    // stream 1 is tx flow control resp will route to port 49202
    // stream 2 is rx data stream will route to udp port 40204

    always @(*) begin
        case(mx_state)
            MX_0 : begin
                o_tvalid_int = i0_tvalid_int;
                o_tlast_int = i0_tlast_int;
                o_tdata_int = i0_tdata_int;
                o_tuser_int = 49202;
            end

            MX_1 : begin
                o_tvalid_int = i0_tvalid_int;
                o_tlast_int = i0_tlast_int;
                o_tdata_int = i0_tdata_int;
                o_tuser_int = 49200;
            end

            MX_2 : begin
                o_tvalid_int = i1_tvalid_int;
                o_tlast_int = i1_tlast_int;
                o_tdata_int = i1_tdata_int;
                o_tuser_int = 49204;
            end

            default : begin
                o_tvalid_int = 1'b0;
                o_tdata_int = 0;
                o_tlast_int = 0;
                o_tuser_int = 49200;
            end
        endcase
    end



    generate
        if(BUFFER == 0) begin
            assign o_tdata = o_tdata_int;
            assign o_tlast = o_tlast_int;
            assign o_tvalid = o_tvalid_int;
            assign o_tready_int = o_tready;
        end
        else
            axi_fifo_flop2 #(.WIDTH(CHDR_W+USER_W+1)) axi_fifo_flop2
                           (.clk(clk), .reset(reset), .clear(clear),
                            .i_tdata({o_tlast_int,o_tuser_int,o_tdata_int}), .i_tvalid(o_tvalid_int), .i_tready(o_tready_int),
                            .o_tdata({o_tlast,o_tuser,o_tdata}), .o_tvalid(o_tvalid), .o_tready(o_tready),
                            .space(), .occupied());
    endgenerate
endmodule
