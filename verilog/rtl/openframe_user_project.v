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

/*
 *-------------------------------------------------------------------------
 * openframe_user_project ---
 *
 * This is an example user project for the GF180MCU Caravel openframe
 * (dual voltage (3.3V core, 5.0V pad) padframe).
 *
 * Written by Tim Edwards
 * November 2025
 *-------------------------------------------------------------------------
 */

// `default_nettype none

// There are 44 GPIO pads in the openframe definition.  This
// is fixed and corresponds to the standard pinout and
// packaging for the Caravel harness chip.

`define OPENFRAME_IO_PADS 44

module openframe_user_project (
	`ifdef USE_POWER_PINS
		// Power buses
		inout  vddio,	// Core 5.0V supply
		inout  vssio,	// Core 5.0V ground
		inout  vccd,	// Core 3.3V supply
		inout  vssd,	// Core 3.3V ground
	`endif

	// Core infrastructure
	input  resetb_core,
	input  porb_h,
	input  por_h,
	input  porb_l,
	input  [31:0] mask_rev,
	input  resetb_loopback_zero,
	input  resetb_loopback_one,
	output resetb_pullup,
	output resetb_pulldown,
		
	// User project IOs
	output [`OPENFRAME_IO_PADS-1:0] gpio_out,
	output [`OPENFRAME_IO_PADS-1:0] gpio_oe,
	output [`OPENFRAME_IO_PADS-1:0] gpio_ie,
	output [`OPENFRAME_IO_PADS-1:0] gpio_schmitt,
	output [`OPENFRAME_IO_PADS-1:0] gpio_slew,
	output [`OPENFRAME_IO_PADS-1:0] gpio_pullup,
	output [`OPENFRAME_IO_PADS-1:0] gpio_pulldown,
	output [`OPENFRAME_IO_PADS-1:0] gpio_drive0,
	output [`OPENFRAME_IO_PADS-1:0] gpio_drive1,
	input [`OPENFRAME_IO_PADS-1:0] gpio_in,
	inout [`OPENFRAME_IO_PADS-1:0] gpio_ana,
	input [`OPENFRAME_IO_PADS-1:0] gpio_loopback_zero,
	input [`OPENFRAME_IO_PADS-1:0] gpio_loopback_one
);

	//-----------------------------------------------------
	// Example Caravel GF180MCU openframe project wrapper
	//-----------------------------------------------------

	// Retain the inverted sense of the "resetb" pin by
	// setting pullup = high, pulldown = low

	assign resetb_pullup = resetb_loopback_one;
	assign resetb_pulldown = resetb_loopback_zero;

	//-----------------------------------------------------
	// Instantiate the PicoRV32 "picosoc"
	//-----------------------------------------------------

	picosoc picosoc (
	    `ifdef USE_POWER_PINS
		.VPWR(vccd),		/* 3.3V domain only */
		.VGND(vssd),
	    `endif
	    .porb(porb_l),		/* Power-on-reset (inverted)	*/
	    .por(~porb_l),		/* Power-on-reset (non-inverted) */
	    .resetb(resetb_core),	/* Master (pin) reset (inverted) */
	    .mask_rev(mask_rev),	/* Mask revision (via programmed ROM) */
	    .gpio_in(gpio_in),		/* Input from GPIO */
	    .gpio_out(gpio_out),	/* Output to GPIO */
	    .gpio_oe(gpio_oe),		/* GPIO output enable */
	    .gpio_ie(gpio_ie),		/* GPIO input enable */
	    .gpio_drive1_sel(gpio_drive1),	/* GPIO drive mode */
	    .gpio_drive0_sel(gpio_drive0),	/* GPIO drive mode */
	    .gpio_schmitt_sel(gpio_schmitt),	/* GPIO threshold */
	    .gpio_slew_sel(gpio_slew),		/* GPIO slew rate */
	    .gpio_pullup_sel(gpio_pullup),	/* GPIO pullup mode */
	    .gpio_pulldown_sel(gpio_pulldown),	/* GPIO pulldown mode */
	    .gpio_loopback_one(gpio_loopback_one),	/* Value 1 for loopback */
	    .gpio_loopback_zero(gpio_loopback_zero)	/* Value 0 for loopback */
	);

endmodule
// `default_nettype wire
