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

// The openframe wrapper requires this definition
`define HAS_USER_PROJECT

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

	// Ensure that all GPIO inputs are properly tied off
	// When all GPIO inputs are set to zero, the GPIO is
	// turned off.  Both input and output buffers are
	// disabled, and no pullup/pulldown resistor is
	// present.

	genvar i;
	generate
	for (i = 0; i < `OPENFRAME_IO_PADS; i = i + 1) begin
		assign gpio_out[i] = gpio_loopback_zero[i];
		assign gpio_oe[i] =  gpio_loopback_zero[i];
		assign gpio_ie[i] =  gpio_loopback_zero[i];
		assign gpio_schmitt[i] =  gpio_loopback_zero[i];
		assign gpio_slew[i] =  gpio_loopback_zero[i];
		assign gpio_pullup[i] =  gpio_loopback_zero[i];
		assign gpio_pulldown[i] =  gpio_loopback_zero[i];
		assign gpio_drive0[i] =  gpio_loopback_zero[i];
		assign gpio_drive1[i] =  gpio_loopback_zero[i];
	end
	endgenerate

endmodule
// `default_nettype wire
