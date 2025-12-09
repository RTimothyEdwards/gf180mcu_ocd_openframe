// SPDX-FileCopyrightText: 2020 Efabless Corporation
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

`default_nettype none
/*
 *---------------------------------------------------------------------
 *
 * This module instantiates a simplified control into a GPIO padframe
 * cell, with a wishbone bus interface to the quasi-static control
 * bits.
 *
 * The GPIO interface is designed to either communicate with the
 * pad through the wishbone bus directly, or through a 3-pin interface
 * (in, out, oe).  The 3-pin interface allows the GPIO to operate as
 * part of another interface (such as SPI or UART) but gives the CPU
 * the ability to reconfigure the GPIO for another purpose.
 *
 *
 * Control bits (12):
 *
 *  11				output value
 *  10				output enable value
 *   9				input enable value
 *   8				override output
 *   7  			override output enable
 *   6				override input enable
 *   5	pad_gpio_schmitt_sel	Trip point voltage select
 *   4  pad_gpio_slew_sel	Slow output slew select
 *   3  pad_gpio_drive0_sel	Drive 0 select
 *   2  pad_gpio_drive1_sel	Drive 1 select
 *   1  pad_gpio_pulldown_sel	Pulldown mode select
 *   0  pad_gpio_pullup_sel	Pullup mode select
 *
 *---------------------------------------------------------------------
 */

module gpio_wb #(
    parameter GPIO_DEFAULTS = 12'h000,
    parameter BASE_ADR = 32'h2100_0000,
    parameter GPIO_CONFIG = 8'h00 		// quasi-static configuration
) (
    `ifdef USE_POWER_PINS
         inout VPWR,
         inout VGND,
    `endif

    // Wishbone interface signals
    input wb_clk_i,
    input wb_rst_i,
    input [31:0] wb_adr_i,
    input [31:0] wb_dat_i,
    input [3:0] wb_sel_i,
    input wb_we_i,
    input wb_cyc_i,
    input wb_stb_i,

    output wb_ack_o,
    output [31:0] wb_dat_o,

    // Core-facing signals
    output       cpu_gpio_in,		// to CPU from pad
    input        cpu_gpio_out,		// from CPU to pad
    input        cpu_gpio_oe,		// from CPU to pad
    input        cpu_gpio_ie,		// from CPU to pad

    // Primary controls
    input        pad_gpio_in,
    output       pad_gpio_out,
    output       pad_gpio_oe,
    output       pad_gpio_ie,

    // Quasi-static controls
    output	 pad_gpio_slew_sel,
    output	 pad_gpio_schmitt_sel,
    output       pad_gpio_drive0_sel,
    output       pad_gpio_drive1_sel,
    output       pad_gpio_pulldown_sel,
    output       pad_gpio_pullup_sel
);

    wire resetn;
    wire valid;
    wire ready;
    wire [3:0] iomem_we;

    assign resetn = ~wb_rst_i;
    assign valid = wb_stb_i && wb_cyc_i;

    assign iomem_we = wb_sel_i & {4{wb_we_i}};
    assign wb_ack_o = ready;

    gpio #(
	.GPIO_DEFAULTS(GPIO_DEFAULTS),
        .BASE_ADR(BASE_ADR),
        .GPIO_CONFIG(GPIO_CONFIG)
    ) gpio_ctrl (
    `ifdef USE_POWER_PINS
         .vdd(VPWR),
         .vss(VGND),
    `endif
        .clk(wb_clk_i),
        .resetn(resetn),

        .iomem_addr(wb_adr_i),
        .iomem_valid(valid),
        .iomem_wstrb(iomem_we[0]),
        .iomem_wdata(wb_dat_i),
        .iomem_rdata(wb_dat_o),
        .iomem_ready(ready),

	.pad_gpio_slew_sel(pad_gpio_slew_sel),
	.pad_gpio_schmitt_sel(pad_gpio_schmitt_sel),
	.pad_gpio_drive0_sel(pad_gpio_drive0_sel),
	.pad_gpio_drive1_sel(pad_gpio_drive1_sel),
	.pad_gpio_pullup_sel(pad_gpio_pullup_sel),
	.pad_gpio_pulldown_sel(pad_gpio_pulldown_sel),

	.pad_gpio_in(pad_gpio_in),
	.pad_gpio_out(pad_gpio_out),
	.pad_gpio_oe(pad_gpio_oe),
	.pad_gpio_ie(pad_gpio_ie),

	.cpu_gpio_in(cpu_gpio_in),
	.cpu_gpio_out(cpu_gpio_out),
	.cpu_gpio_oe(cpu_gpio_oe),
	.cpu_gpio_ie(cpu_gpio_ie)
    );

endmodule

module gpio #(
    parameter GPIO_DEFAULTS = 12'h001,
    parameter BASE_ADR  = 32'h 2100_0000,
    parameter GPIO_CONFIG = 8'h00
) (
    `ifdef USE_POWER_PINS
         inout vdd,
         inout vss,
    `endif

    input clk,
    input resetn,

    input [31:0] iomem_addr,
    input iomem_valid,
    input iomem_wstrb,
    input [31:0] iomem_wdata,
    output reg [31:0] iomem_rdata,
    output reg iomem_ready,

    output reg	 pad_gpio_slew_sel,
    output reg	 pad_gpio_schmitt_sel,
    output reg   pad_gpio_drive0_sel,
    output reg   pad_gpio_drive1_sel,
    output reg   pad_gpio_pullup_sel,
    output reg   pad_gpio_pulldown_sel,

    input  pad_gpio_in,
    output pad_gpio_out,
    output pad_gpio_oe,
    output pad_gpio_ie,

    output cpu_gpio_in,
    input  cpu_gpio_out,
    input  cpu_gpio_oe,
    input  cpu_gpio_ie
);
    /* Internally registered signals */
    reg gpio_out_override;
    reg gpio_out_value;
    reg gpio_oe_override;
    reg gpio_oe_value;
    reg gpio_ie_override;
    reg gpio_ie_value;

    wire gpio_config_sel;

    // Cast parameter to a wire array for diagnostic purposes.
    // wire [11:0] defaults;
    // assign defaults = GPIO_DEFAULTS;

    assign gpio_config_sel = (iomem_addr[7:0] == (BASE_ADR[7:0] + GPIO_CONFIG));

    always @(posedge clk or negedge resetn) begin
	if (!resetn) begin
	    gpio_out_value	 <= GPIO_DEFAULTS[11];
	    gpio_oe_value	 <= GPIO_DEFAULTS[10];
	    gpio_ie_value	 <= GPIO_DEFAULTS[9];
	    gpio_out_override	 <= GPIO_DEFAULTS[8];
	    gpio_oe_override	 <= GPIO_DEFAULTS[7];
	    gpio_ie_override	 <= GPIO_DEFAULTS[6];
	    pad_gpio_slew_sel    <= GPIO_DEFAULTS[5];
	    pad_gpio_schmitt_sel <= GPIO_DEFAULTS[4];
	    pad_gpio_drive0_sel  <= GPIO_DEFAULTS[3];
	    pad_gpio_drive1_sel  <= GPIO_DEFAULTS[2];
	    pad_gpio_pullup_sel  <= GPIO_DEFAULTS[1];
	    pad_gpio_pulldown_sel <= GPIO_DEFAULTS[0];

	end else begin
	    iomem_ready <= 0;
	    if (iomem_valid && !iomem_ready && iomem_addr[31:8] == BASE_ADR[31:8]) begin
		iomem_ready <= 1'b 1;

		if (gpio_config_sel) begin
		    iomem_rdata <= {16'd0, 	
			pad_gpio_in, pad_gpio_out, pad_gpio_oe, pad_gpio_ie,
			gpio_out_value, gpio_oe_value, gpio_ie_value,
			gpio_out_override, gpio_oe_override, gpio_ie_override,
			pad_gpio_slew_sel, pad_gpio_schmitt_sel,
			pad_gpio_drive0_sel, pad_gpio_drive1_sel,
			pad_gpio_pullup_sel, pad_gpio_pulldown_sel};
		    if (iomem_wstrb) begin
			gpio_out_value	   <= iomem_wdata[11];
			gpio_oe_value	   <= iomem_wdata[10];
			gpio_ie_value	   <= iomem_wdata[9];
			gpio_out_override  <= iomem_wdata[8];
			gpio_oe_override  <= iomem_wdata[7];
			gpio_ie_override  <= iomem_wdata[6];
			pad_gpio_slew_sel  <= iomem_wdata[5];
			pad_gpio_schmitt_sel <= iomem_wdata[4];
			pad_gpio_drive0_sel <= iomem_wdata[3];
			pad_gpio_drive1_sel <= iomem_wdata[2];
			pad_gpio_pullup_sel <= iomem_wdata[1];
			pad_gpio_pulldown_sel <= iomem_wdata[0];
		    end
		end else begin
		    iomem_rdata <= 32'd0;
		end
	    end
	end
    end

    /* Input signal just passes through */
    /* Output and outenb signals pass through but may be overridden */

    assign cpu_gpio_in = pad_gpio_in;
    assign pad_gpio_out = (gpio_out_override) ? gpio_out_value : cpu_gpio_out;
    assign pad_gpio_oe = (gpio_oe_override) ? gpio_oe_value : cpu_gpio_oe;
    assign pad_gpio_ie = (gpio_ie_override) ? gpio_ie_value : cpu_gpio_ie;
		
endmodule
`default_nettype wire
