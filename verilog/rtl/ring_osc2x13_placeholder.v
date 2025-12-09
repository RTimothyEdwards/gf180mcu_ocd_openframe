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

// Ring oscillator with 13 stages, each with two trim bits delay
// (see above).  Trim is not binary:  For trim[1:0], lower bit
// trim[0] is primary trim and must be applied first;  upper
// bit trim[1] is secondary trim and should only be applied
// after the primary trim is applied, or it has no effect.
//
// Total effective number of inverter stages in this oscillator
// ranges from 13 at trim 0 to 65 at trim 24.  The intention is
// to cover a range greater than 2x so that the midrange can be
// reached over all PVT conditions.
//
// Frequency of this ring oscillator under SPICE simulations at
// nominal PVT is maximum 214 MHz (trim 0), minimum 90 MHz (trim 24).

module ring_osc2x13(
`ifdef USE_POWER_PINS
    inout  wire		vdd,
    inout  wire		vss,
`endif
    input  wire 	reset,
    input  wire [25:0]	trim,
    output wire [1:0]	clockp
);

// NOTE:  This placeholder needs to be replaced with a macro, but
// the macro needs to be complete.  Or else at least the tristate
// inverters are needed to allow synthesis, if that's possible.
//
// In the worst case, the DLL just won't work.

assign clockp = 2'b10;

endmodule
`default_nettype wire
