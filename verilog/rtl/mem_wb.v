// SPDX-FileCopyrightText: 2025 Open Circuit Design, LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0
//
// Original SPDX-FileCopyrightText: 2020 Efabless Corporation

`ifndef MEM_WORDS
`define MEM_WORDS 768
`endif

`default_nettype none
module mem_wb (
`ifdef USE_POWER_PINS
    inout wire VPWR,
    inout wire VGND,
`endif
    input wire mem_force_ena,
    input wire wb_clk_i,
    input wire wb_rst_i,

    input wire [31:0] wb_adr_i,
    input wire [31:0] wb_dat_i,
    input wire [3:0] wb_sel_i,
    input wire wb_we_i,
    input wire wb_cyc_i,
    input wire wb_stb_i,

    output reg  wb_ack_o,
    output wire [31:0] wb_dat_o
);

    localparam ADR_WIDTH = $clog2(`MEM_WORDS);

    wire valid;
    wire ram_wen;
    wire [3:0] wen; // write enable

    assign valid = wb_cyc_i & wb_stb_i;
    assign ram_wen = wb_we_i && valid;

    assign wen = wb_sel_i & {4{ram_wen}} ;

    /*
     * Ack Generation
     *     - write transaction: asserted upon receiving adr_i & dat_i 
     *     - read transaction : asserted one clock cycle after receiving the
     *     adr_i & dat_i
     */ 

    reg wb_ack_read;

    always @(posedge wb_clk_i) begin
        if (wb_rst_i == 1'b1) begin
            wb_ack_read <= 1'b0;
            wb_ack_o <= 1'b0;
        end else begin
            // wb_ack_read <= {2{valid}} & {1'b1, wb_ack_read[1]};
            wb_ack_o    <= wb_we_i? (valid & !wb_ack_o): wb_ack_read;
            wb_ack_read <= (valid & !wb_ack_o) & !wb_ack_read;
        end
    end

    soc_mem mem (
    `ifdef USE_POWER_PINS
        .VPWR(VPWR),
        .VGND(VGND),
    `endif
        .clk(wb_clk_i),
        .ena(valid),
	.mem_force_ena(mem_force_ena),
        .wen(wen),
        .addr(wb_adr_i[ADR_WIDTH+1:2]),
        .wdata(wb_dat_i),
        .rdata(wb_dat_o)
    );

endmodule

module soc_mem ( 
`ifdef USE_POWER_PINS
    inout  wire		VPWR,
    inout  wire		VGND,
`endif
    input  wire 	clk,
    input  wire 	ena,
    input  wire 	mem_force_ena,	// Force memory to be enabled always
    input  wire [3:0]	wen,
    input  wire [9:0]	addr,
    input  wire [31:0]	wdata,
    output wire [31:0]	rdata
);

    wire [31:0] rdata0;
    wire [31:0] rdata1;

    wire [3:0] web;
    wire enb;
    wire gweb;

    assign web = ~wen;
    assign enb = ~(ena | mem_force_ena);
    assign gweb = ~(|wen);

    /* Size: 2KB, 512x32 bits */
    /* The RAM macro is 512 bytes x 8 bits, so use one macro per byte */

    gf180mcu_ocd_ip_sram__sram512x8m8wm1 sram_0 (
	`ifdef USE_POWER_PINS
	    .VDD(VPWR),
	    .VSS(VGND),
	`endif
            .CLK(clk), 
            .CEN(enb), 
            .GWEN(gweb),
            .WEN({web[0], web[0], web[0], web[0], web[0], web[0], web[0], web[0]}),
            .A(addr[8:0]),
            .D(wdata[7:0]),
            .Q(rdata0[7:0])
    );

    gf180mcu_ocd_ip_sram__sram512x8m8wm1 sram_1 (
	`ifdef USE_POWER_PINS
	    .VDD(VPWR),
	    .VSS(VGND),
	`endif
            .CLK(clk), 
            .CEN(enb), 
            .GWEN(gweb),
            .WEN({web[1], web[1], web[1], web[1], web[1], web[1], web[1], web[1]}),
            .A(addr[8:0]),
            .D(wdata[15:8]),
            .Q(rdata0[15:8])
    );

    gf180mcu_ocd_ip_sram__sram512x8m8wm1 sram_2 (
	`ifdef USE_POWER_PINS
	    .VDD(VPWR),
	    .VSS(VGND),
	`endif
            .CLK(clk), 
            .CEN(enb), 
            .GWEN(gweb),
            .WEN({web[2], web[2], web[2], web[2], web[2], web[2], web[2], web[2]}),
            .A(addr[8:0]),
            .D(wdata[23:16]),
            .Q(rdata0[23:16])
    );

    gf180mcu_ocd_ip_sram__sram512x8m8wm1 sram_3 (
	`ifdef USE_POWER_PINS
	    .VDD(VPWR),
	    .VSS(VGND),
	`endif
            .CLK(clk), 
            .CEN(enb), 
            .GWEN(gweb),
            .WEN({web[3], web[3], web[3], web[3], web[3], web[3], web[3], web[3]}),
            .A(addr[8:0]),
            .D(wdata[31:24]),
            .Q(rdata0[31:24])
    );

    /* Size: 1KB, 256x32 bits */
    /* Could use more memory here but want to exercise both macros */

    gf180mcu_ocd_ip_sram__sram256x8m8wm1 sram_4 (
	`ifdef USE_POWER_PINS
	    .VDD(VPWR),
	    .VSS(VGND),
	`endif
            .CLK(clk), 
            .CEN(enb), 
            .GWEN(gweb),
            .WEN({web[0], web[0], web[0], web[0], web[0], web[0], web[0], web[0]}),
            .A(addr[7:0]),
            .D(wdata[7:0]),
            .Q(rdata1[7:0])
    );

    gf180mcu_ocd_ip_sram__sram256x8m8wm1 sram_5 (
	`ifdef USE_POWER_PINS
	    .VDD(VPWR),
	    .VSS(VGND),
	`endif
            .CLK(clk), 
            .CEN(enb), 
            .GWEN(gweb),
            .WEN({web[1], web[1], web[1], web[1], web[1], web[1], web[1], web[1]}),
            .A(addr[7:0]),
            .D(wdata[15:8]),
            .Q(rdata1[15:8])
    );

    gf180mcu_ocd_ip_sram__sram256x8m8wm1 sram_6 (
	`ifdef USE_POWER_PINS
	    .VDD(VPWR),
	    .VSS(VGND),
	`endif
            .CLK(clk), 
            .CEN(enb), 
            .GWEN(gweb),
            .WEN({web[2], web[2], web[2], web[2], web[2], web[2], web[2], web[2]}),
            .A(addr[7:0]),
            .D(wdata[23:16]),
            .Q(rdata1[23:16])
    );

    gf180mcu_ocd_ip_sram__sram256x8m8wm1 sram_7 (
	`ifdef USE_POWER_PINS
	    .VDD(VPWR),
	    .VSS(VGND),
	`endif
            .CLK(clk), 
            .CEN(enb), 
            .GWEN(gweb),
            .WEN({web[3], web[3], web[3], web[3], web[3], web[3], web[3], web[3]}),
            .A(addr[7:0]),
            .D(wdata[31:24]),
            .Q(rdata1[31:24])
    );

      // Select bank based on address high bit.
      assign rdata = (addr[9] == 1'b1) ? rdata1 : rdata0;
endmodule
`default_nettype wire
