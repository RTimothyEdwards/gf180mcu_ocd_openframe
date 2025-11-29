// SPDX-FileCopyrightText: 2025 Open Circuit Design, LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//	http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

`default_nettype none

/*
 *--------------------------------------------------------------------
 * A local variation on the gf180mcu_ocd_io fill10 I/O cell, with
 * the vertical metal2 power supply lines cut back enough to make
 * room for two pass-through signal lines.
 *--------------------------------------------------------------------
 */

module gf180mcu_ocd_io__fill10z (
`ifdef USE_POWER_PINS
	inout DVDD,
	inout DVSS,
	inout VDD,
	inout VSS,
`endif
	inout thru0,
	inout thru1
);

	/* This module contains only moscap devices */

	/* Enumerate the decap cells for LVS only */
	`ifdef LVS
		cap_nmos_06v0 #(
			.c_length(6e-06),
			.c_width(2.24e-04)
		) vdd_decap (
			.1(VDD),
			.2(VSS)
		);

	`endif

endmodule
