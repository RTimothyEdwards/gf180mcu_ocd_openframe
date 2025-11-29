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

//-------------------------------------------------------------------------
// Original copyright from upstream project caravel-gf180mcu, from which
// this work was derived: SPDX-FileCopyrightText: 2020 Efabless Corporation
// Upstream repository from which this work was derived:
// https://github.com/efabless/caravel-gf180mcu/
//-------------------------------------------------------------------------

/*--------------------------------------------------------------*/
/* caravel_openframe, a project harness for the Wafer.Space	*/
/* GF180MCU fabrication process and open source PDK             */
/*                                                              */
/* Copyright 2025 Open Circuit Design, LLC			*/
/* Written by Tim Edwards, November 2025                        */
/* This file is open source hardware released under the         */
/* Apache 2.0 license.  See file LICENSE.                       */
/*                                                              */
/* The caravel_openframe is a chip top level design conforming  */
/* to the pad locations and assignments used by the Caravel and */
/* Caravan chips top level definition.  However, it does not    */
/* define any embedded processor or other interfaces.           */
/*                                                              */
/* The padframe of caravel_openframe consists of the same 38    */
/* general-purpose I/O pads as Caravel.  The pads formerly      */
/* used by Caravel for dedicated functions of the management    */
/* SoC (flash controller CSB, SCK, IO0 and IO1, gpio, and       */
/* clock) are redefined as additional general-purpose I/O for   */
/* a total of 44 GPIO pads.  The resetb pad retains its         */
/* function as an input pin with weak pull-up with high and     */
/* low voltage domain (5.0V and 3.3V) versions of the output    */
/* exported to the chip project core.  The user may elect to    */
/* use the reset pin for a purpose other than a master reset.   */
/*                                                              */
/* The padframe implements a simple power-on reset circuit, and */
/* provides a 32-bit bus in the 3.3V digital domain consisting  */
/* of the (fixed) user project ID.                              */
/*                                                              */
/* Each GPIO pad must be configured by the user project.  The   */
/* padframe exports constant value "1" and "0" bits in the 3.3V */
/* domain for each GPIO pad that can be used by the user        */
/* project to loop back to the GPIO to set a static             */
/* configuration on power-up.                                   */
/*                                                              */
/* Every user project must instantiate a module called          */
/* "openframe_project_wrapper" that connects to all of the      */
/* signals as defined in the module call, below.  The layout    */
/* of the user project must correspond to the provided wrapper  */
/* cell layout, describing the position of signal and power     */
/* pins on the perimeter of the wrapper.                        */
/*                                                              */
/*--------------------------------------------------------------*/


// `default_nettype none

module caravel_openframe (
	`ifdef USE_POWER_PINS
		// Power buses
		inout  vddio,	// Padfreame/ESD 5.0V supply
		inout  vssio,	// Padfreame/ESD 5.0V ground
		inout  vccd,	// Padframe/core 3.3V supply
		inout  vssd,	// Padframe/core 3.3V ground
	`endif

	inout  [`OPENFRAME_IO_PADS-1:0] gpio,
	input  resetb
);

	//------------------------------------------------------------
	// This value is uniquely defined for each user project.
	//------------------------------------------------------------
	parameter USER_PROJECT_ID = 32'h00000000;

	// Project Control (pad-facing)
	wire [`OPENFRAME_IO_PADS-1:0] gpio_ie;		// input enable
	wire [`OPENFRAME_IO_PADS-1:0] gpio_oe;		// output enable
	wire [`OPENFRAME_IO_PADS-1:0] gpio_drive0;	// drive strength (bit 0)
	wire [`OPENFRAME_IO_PADS-1:0] gpio_drive1;	// drive strength (bit 1)
	wire [`OPENFRAME_IO_PADS-1:0] gpio_ana;		// direct analog connection
	wire [`OPENFRAME_IO_PADS-1:0] gpio_pullup;	// pullup enable
	wire [`OPENFRAME_IO_PADS-1:0] gpio_pulldown;	// pulldown enable
	wire [`OPENFRAME_IO_PADS-1:0] gpio_schmitt;	// schmitt trigger input enable
	wire [`OPENFRAME_IO_PADS-1:0] gpio_slew;	// slow slew rate enable
	wire [`OPENFRAME_IO_PADS-1:0] gpio_in;		// digital input
	wire [`OPENFRAME_IO_PADS-1:0] gpio_out;		// digital output
	wire [`OPENFRAME_IO_PADS-1:0] gpio_loopback_zero; // 3.3V domain digital 0
	wire [`OPENFRAME_IO_PADS-1:0] gpio_loopback_one;  // 3.3V domain digital 1

	// Power-on-reset signal.  The simple POR circuit generates these
	// three signals, uses them to enable the GPIO, and exports the
	// signals to the core.

	wire por_h;
	wire porb_h;
	wire porb_l;

	// Master reset signal.  The reset pad generates the sense-inverted
	// reset at 3.3V.

	wire resetb_l;

	// Mask revision:  Output from the padframe, exporting the 32-bit
	// user ID value.

	wire [31:0] mask_rev;

	gf180mcu_padframe #(
                .USER_PROJECT_ID(USER_PROJECT_ID)
        ) padframe (

		// Power connections (pad and core side are the same)
		`ifndef TOP_ROUTING
			// Package Pins
			.vddio(vddio),	// Common padframe/ESD supply
			.vssio(vssio),	// Common padframe/ESD ground
			.vccd(vccd),	// Common 3.3V supply
			.vssd(vssd),	// Common digital ground
		`endif

		// Pad side signals
		.gpio(gpio),
		.resetb(resetb),

		// Core side signals
		.porb_h(porb_h),
		.porb_l(porb_l),
		.por_h(por_h),
		.resetb_core(resetb_l),
		.mask_rev(mask_rev),

		.gpio_in(gpio_in),
		.gpio_out(gpio_out),
		.gpio_ana(gpio_ana),
		.gpio_oe(gpio_oe),
		.gpio_ie(gpio_ie),
		.gpio_schmitt(gpio_schmitt),
		.gpio_slew(gpio_slew),
		.gpio_pullup(gpio_pullup),
		.gpio_pulldown(gpio_pulldown),
		.gpio_drive0(gpio_drive0),
		.gpio_drive1(gpio_drive1),
		.gpio_loopback_zero(gpio_loopback_zero),
		.gpio_loopback_one(gpio_loopback_one)
	);

	/*----------------------------------------------*/
	/* Wrapper module around the user project	*/
	/*----------------------------------------------*/

	openframe_project_wrapper user_project (
		`ifdef USE_POWER_PINS
			// Power buses
			.vddio(vddio),	// Core 5.0V supply
			.vssio(vssio),	// Core 5.0V ground
			.vccd(vccd),	// Core 3.3V supply
			.vssd(vssd),	// Core 3.3V ground
		`endif

		// Core infrastructure
		.resetb_core(resetb_l),
 		.porb_h(porb_h),
		.por_h(por_h),
		.porb_l(porb_l),
		.mask_rev(mask_rev),
		
		// User project IOs
		.gpio_in(gpio_in),
		.gpio_out(gpio_out),
		.gpio_ana(gpio_ana),
		.gpio_oe(gpio_oe),
		.gpio_ie(gpio_ie),
		.gpio_schmitt(gpio_schmitt),
		.gpio_slew(gpio_slew),
		.gpio_pullup(gpio_pullup),
		.gpio_pulldown(gpio_pulldown),
		.gpio_drive0(gpio_drive0),
		.gpio_drive1(gpio_drive1)
	);

	/*--------------------------------------*/
	/* End user project instantiation	*/
	/*--------------------------------------*/




endmodule
// `default_nettype wire
