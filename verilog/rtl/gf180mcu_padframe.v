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

/*
 *-------------------------------------------------------------------------
 * gf180mcu_padframe ---
 *
 * RTL verilog definition of the padframe for the open-frame version
 * of the Caravel harness chip, GF180MCU process.  This repository
 * acts as a reference design for use of the 3.3V-enabled libraries
 * for the gf180mcu open PDK, primarily the mixed-voltage I/O library
 * (gf180mcu_ocd_io), distributed with the GF180MCU open PDK by the
 * open_pdks installer.
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

module gf180mcu_padframe #(
	parameter USER_PROJECT_ID = 32'h00000000
) (
`ifdef USE_POWER_PINS
	// Power buses (chip pins and core side not separated)
	inout  vddio,	// Padfreame/ESD 5.0V supply
	inout  vssio,	// Padfreame/ESD 5.0V ground
	inout  vccd,	// Padframe/core 3.3V supply
	inout  vssd,	// Padframe/core 3.3V ground
`endif

	// Signal pins
	inout  [`OPENFRAME_IO_PADS-1:0] gpio,
	input  resetb,

	// Core side interface
	output porb_h,
	output por_h,
	output porb_l,
	output resetb_core,
	output [31:0] mask_rev,
	input resetb_pullup,
	input resetb_pulldown,
	output resetb_loopback_zero,
	output resetb_loopback_one,
		
	// User project IOs
	input [`OPENFRAME_IO_PADS-1:0] gpio_out,
	input [`OPENFRAME_IO_PADS-1:0] gpio_oe,
	input [`OPENFRAME_IO_PADS-1:0] gpio_ie,
	input [`OPENFRAME_IO_PADS-1:0] gpio_schmitt,
	input [`OPENFRAME_IO_PADS-1:0] gpio_slew,
	input [`OPENFRAME_IO_PADS-1:0] gpio_pullup,
	input [`OPENFRAME_IO_PADS-1:0] gpio_pulldown,
	input [`OPENFRAME_IO_PADS-1:0] gpio_drive0,
	input [`OPENFRAME_IO_PADS-1:0] gpio_drive1,
	output [`OPENFRAME_IO_PADS-1:0] gpio_in,
	inout [`OPENFRAME_IO_PADS-1:0] gpio_ana,
	output [`OPENFRAME_IO_PADS-1:0] gpio_loopback_zero,
	output [`OPENFRAME_IO_PADS-1:0] gpio_loopback_one
);
	// Instantiate power and ground pads for the two voltage
	// domains vddio/vssio (5V) and vccd/vssd (3.3V).
	// Within the pad cells, the 5V domain is DVDD/DVSS, and
	// the 3.3V domain is VDD/VSS.

    	gf180mcu_ocd_io__dvdd mgmt_vddio_pad_0 (
		.DVDD(vddio),
		.DVSS(vssio),
		.VDD(vccd),
		.VSS(vssd)
    	);

	// lies in user area---Does not belong to management domain
	// like it does on the Sky130 version.
    	gf180mcu_ocd_io__dvdd mgmt_vddio_pad_1 (
		.DVDD(vddio),
		.DVSS(vssio),
		.VDD(vccd),
		.VSS(vssd)
    	);

    	gf180mcu_ocd_io__dvdd mgmt_vdda_pad (
		.DVDD(vddio),
		.DVSS(vssio),
		.VDD(vccd),
		.VSS(vssd)
    	);

    	gf180mcu_ocd_io__vdd mgmt_vccd_pad (
		.DVDD(vddio),
		.DVSS(vssio),
		.VDD(vccd),
		.VSS(vssd)
    	);

    	gf180mcu_ocd_io__dvss mgmt_vssio_pad_0 (
		.DVDD(vddio),
		.DVSS(vssio),
		.VDD(vccd),
		.VSS(vssd)
    	);

    	gf180mcu_ocd_io__dvss mgmt_vssio_pad_1 (
		.DVDD(vddio),
		.DVSS(vssio),
		.VDD(vccd),
		.VSS(vssd)
    	);

    	gf180mcu_ocd_io__dvss mgmt_vssa_pad (
		.DVDD(vddio),
		.DVSS(vssio),
		.VDD(vccd),
		.VSS(vssd)
    	);

    	gf180mcu_ocd_io__vss mgmt_vssd_pad (
		.DVDD(vddio),
		.DVSS(vssio),
		.VDD(vccd),
		.VSS(vssd)
    	);

    	gf180mcu_ocd_io__dvdd user1_vdda_pad_0 (
		.DVDD(vddio),
		.DVSS(vssio),
		.VDD(vccd),
		.VSS(vssd)
    	);

	gf180mcu_ocd_io__dvdd user1_vdda_pad_1 (
		.DVDD(vddio),
		.DVSS(vssio),
		.VDD(vccd),
		.VSS(vssd)
    	);

    	gf180mcu_ocd_io__vdd user1_vccd_pad (
		.DVDD(vddio),
		.DVSS(vssio),
		.VDD(vccd),
		.VSS(vssd)
    	);

    	gf180mcu_ocd_io__dvss user1_vssa_pad_0 (
		.DVDD(vddio),
		.DVSS(vssio),
		.VDD(vccd),
		.VSS(vssd)
    	);


    	gf180mcu_ocd_io__dvss user1_vssa_pad_1 (
		.DVDD(vddio),
		.DVSS(vssio),
		.VDD(vccd),
		.VSS(vssd)
    	);

    	gf180mcu_ocd_io__vss user1_vssd_pad (
		.DVDD(vddio),
		.DVSS(vssio),
		.VDD(vccd),
		.VSS(vssd)
    	);

	// Instantiate power and ground pads for user 2 domain
	// 8 pads:  vdda, vssa, vccd, vssd;  One each HV and LV clamp.

    	gf180mcu_ocd_io__dvdd user2_vdda_pad (
		.DVDD(vddio),
		.DVSS(vssio),
		.VDD(vccd),
		.VSS(vssd)
    	);

    	gf180mcu_ocd_io__vdd user2_vccd_pad (
		.DVDD(vddio),
		.DVSS(vssio),
		.VDD(vccd),
		.VSS(vssd)
    	);

    	gf180mcu_ocd_io__dvss user2_vssa_pad (
		.DVDD(vddio),
		.DVSS(vssio),
		.VDD(vccd),
		.VSS(vssd)
    	);

    	gf180mcu_ocd_io__vss user2_vssd_pad (
		.DVDD(vddio),
		.DVSS(vssio),
		.VDD(vccd),
		.VSS(vssd)
    	);

	// NOTE:  Resetb is active low and should be configured as a pull-up.
	// However, the implementation has PD and PU unassigned and placed
	// next to 3.3V domain digital zero and one outputs where they can
	// be looped back or directly via-programmed to make the reset either
	// active-low or active-high.

	gf180mcu_ocd_io__in_s resetb_pad (
		.DVDD(vddio),
		.DVSS(vssio),
		.VDD(vccd),
		.VSS(vssd),
		.PU(resetb_pullup),
		.PD(resetb_pulldown),
		.PAD(resetb),
		.Y(resetb_core)
	);

	// Corner cells

	gf180mcu_ocd_io__cor padframe_corner [3:0] (
		.DVDD(vddio),
		.DVSS(vssio),
		.VDD(vccd),
		.VSS(vssd)
	);

	// Bidirectional general-purpose I/O

	gf180mcu_ocd_io__bi_a padframe_gpio [`OPENFRAME_IO_PADS-1:0] (
		`ifdef USE_POWER_PINS
			.DVDD(vddio),
			.DVSS(vssio),
			.VDD(vccd),
			.VSS(vssd),
		`endif
		.PAD(gpio),
		.CS(gpio_schmitt),
		.SL(gpio_slew),
		.IE(gpio_ie),
		.OE(gpio_oe),
		.PU(gpio_pullup),
		.PD(gpio_pulldown),
		.PDRV0(gpio_drive0),
		.PDRV1(gpio_drive1),
		.A(gpio_out),
		.ANA(gpio_ana),
		.Y(gpio_in)
	);

	// Add user ID program ROM block
	user_id_programming #(
		.USER_PROJECT_ID(USER_PROJECT_ID)
	) project_id_rom (
		`ifdef USE_POWER_PINS
			.VDD(vccd),
			.VSS(vssd),
		`endif
		.mask_rev(mask_rev)
	);

	// Add POR circuit
	simple_por por (
		`ifdef USE_POWER_PINS
			.VDD(vddio),
			.VSS(vssio),
		`endif
		.porb(porb_h),
		.por(por_h)
	);

	// Generate all fill cells with arrays (only fill5 and fill10 used)
	// These cells are filled with decap, so they are not empty and
	// are required to be present to pass LVS.

	gf180mcu_ocd_io__fill5 padframe_fill5 [2:0] (
	`ifdef USE_POWER_PINS
		.DVDD(vddio),
		.DVSS(vssio),
		.VDD(vccd),
		.VSS(vssd)
	`endif
	);

	gf180mcu_ocd_io__fill10 padframe_fill10 [968:0] (
	`ifdef USE_POWER_PINS
		.DVDD(vddio),
		.DVSS(vssio),
		.VDD(vccd),
		.VSS(vssd)
	`endif
	);

	// "fill10z" is a local variant of "fill10" with two
	// pass-through signal lines to connect the pad and
	// core areas.  Otherwise is it exactly like fill10.
	// 16 of these are needed to pass through the 32
	// user ID bits, and one to pass through the POR
	// outputs.

	gf180mcu_ocd_io__fill10z padframe_id_fill10z [15:0] (
	`ifdef USE_POWER_PINS
		.DVDD(vddio),
		.DVSS(vssio),
		.VDD(vccd),
		.VSS(vssd),
	`endif
		.thru0({mask_rev[30],mask_rev[28],mask_rev[26],mask_rev[24],mask_rev[22],mask_rev[20],mask_rev[18],mask_rev[16],mask_rev[14],mask_rev[12],mask_rev[10],mask_rev[8],mask_rev[6],mask_rev[4],mask_rev[2],mask_rev[0]}),
		.thru1({mask_rev[31],mask_rev[29],mask_rev[27],mask_rev[25],mask_rev[23],mask_rev[21],mask_rev[19],mask_rev[17],mask_rev[15],mask_rev[13],mask_rev[11],mask_rev[9],mask_rev[7],mask_rev[5],mask_rev[3],mask_rev[1]})
	);

	gf180mcu_ocd_io__fill10z padframe_por_fill10z (
	`ifdef USE_POWER_PINS
		.DVDD(vddio),
		.DVSS(vssio),
		.VDD(vccd),
		.VSS(vssd),
	`endif
		.thru0(por_h),
		.thru1(porb_h)
	);

	// "fill10x" is a local variant of "fill10" with
	// two decap pairs removed and replaced with a
	// constant output generator cell.  There are 45
	// of these that provide constant 1 and 0 in the
	// 3.3V domain for all of the GPIOs plus the
	// resetb pin (see above).

	gf180mcu_ocd_io__fill10x padframe_fill10x_gpio [43:0] (
	`ifdef USE_POWER_PINS
		.DVDD(vddio),
		.DVSS(vssio),
		.VDD(vccd),
		.VSS(vssd),
	`endif
		.one(gpio_loopback_one),
		.zero(gpio_loopback_zero)
	);

	gf180mcu_ocd_io__fill10x padframe_fill10x_resetb (
	`ifdef USE_POWER_PINS
		.DVDD(vddio),
		.DVSS(vssio),
		.VDD(vccd),
		.VSS(vssd),
	`endif
		.one(resetb_loopback_one),
		.zero(resetb_loopback_zero)
	);

	// "fill10y" is a local variant of "fill10" with
	// two decap pairs removed and replaced with a
	// level-shift-down cell.  There is one of these
	// to provide a POR signal output in the 3.3V
	// domain.

	gf180mcu_ocd_io__fill10y padframe_fill10y (
	`ifdef USE_POWER_PINS
		.DVDD(vddio),
		.DVSS(vssio),
		.VDD(vccd),
		.VSS(vssd),
	`endif
		.AH(porb_h),
		.YL(porb_l)
	);

endmodule
// `default_nettype wire
