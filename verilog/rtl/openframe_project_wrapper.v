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
 * openframe_project_wrapper ---
 *
 * RTL verilog definition of the user project area for the open-frame
 * version of the Caravel harness chip, GF180MCU process, dual voltage
 * (3.3V core, 5.0V pad) padframe.
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

module openframe_project_wrapper (
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

	// Declare a user project by defining HAS_USER_PROJECT
	// and specifying the "netlists.v" file to include the
	// RTL source code for it.

	`ifdef HAS_USER_PROJECT
	    openframe_user_project user_project (
		`ifdef USE_POWER_PINS
		    // Power buses
		    .vddio(vddio),	// Core 5.0V supply
		    .vssio(vssio),	// Core 5.0V ground
		    .vccd(vccd),	// Core 3.3V supply
		    .vssd(vssd),	// Core 3.3V ground
		`endif

		// Core infrastructure
		.resetb_core(resetb_core),
		.porb_h(porb_h),
		.por_h(por_h),
		.porb_l(porb_l),
		.mask_rev(mask_rev),
		.resetb_loopback_zero(resetb_loopback_zero),
		.resetb_loopback_one(resetb_loopback_one),
		.resetb_pullup(resetb_pullup),
		.resetb_pulldown(resetb_pulldown),
		
		// User project IOs
		.gpio_out(gpio_out),
		.gpio_oe(gpio_oe),
		.gpio_ie(gpio_ie),
		.gpio_schmitt(gpio_schmitt),
		.gpio_slew(gpio_slew),
		.gpio_pullup(gpio_pullup),
		.gpio_pulldown(gpio_pulldown),
		.gpio_drive0(gpio_drive0),
		.gpio_drive1(gpio_drive1),
		.gpio_in(gpio_in),
		.gpio_ana(gpio_ana),
		.gpio_loopback_zero(gpio_loopback_zero),
		.gpio_loopback_one(gpio_loopback_one)
	);
	`endif

endmodule
// `default_nettype wire
