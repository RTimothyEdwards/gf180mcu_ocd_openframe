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

`default_nettype none

// This module represents a programmed mask revision
// block that is configured with via programming on the
// chip top level.  This module is the equivalent of
// the module of the same name in the ../rtl/ directory
// but implements a fixed project ID value, generated
// by running the "set_user_id.py" script.  The parameter
// name USER_PROJECT_ID is maintained for syntax
// compatibility with the original, but the parameter
// value is unused.

module user_id_programming #(
    parameter USER_PROJECT_ID = 32'h0	/* unused */
) (
`ifdef USE_POWER_PINS
    inout VDD,
    inout VSS,
`endif
    output wire [31:0] mask_rev
);
    wire [31:0] user_proj_id_high;
    wire [31:0] user_proj_id_low;

    // For the mask revision input, use an array of digital constant logic cells
    // These must be manually placed in pairs, always in the same order.

    gf180mcu_as_sc_mcu7t3v3__tieh_4 mask_rev_value_one [31:0] (
	`ifdef USE_POWER_PINS
            .VDD(VDD),
            .VSS(VSS),
	    .VNW(VDD),
	    .VPW(VSS),
	`endif
            .ONE(user_proj_id_high)
    );

    gf180mcu_as_sc_mcu7t3v3__tiel_4 mask_rev_value_zero [31:0] (
	`ifdef USE_POWER_PINS
            .VDD(VDD),
            .VSS(VSS),
	    .VNW(VDD),
	    .VPW(VSS),
	`endif
            .ZERO(user_proj_id_low)
    );

    /* Individual assignments based on the actual
     * assigned value for the user project ID.  Does not
     * depend on the USER_PROJECT_ID parameter.  If
     * all assignments are to "user_proj_id_low" signals,
     * then the project ID has not been set, and the
     * script "set_user_id.py" needs to be run.
     */

    assign mask_rev[31] = user_proj_id_low[31];
    assign mask_rev[30] = user_proj_id_low[30];
    assign mask_rev[29] = user_proj_id_low[29];
    assign mask_rev[28] = user_proj_id_high[28];
    assign mask_rev[27] = user_proj_id_low[27];
    assign mask_rev[26] = user_proj_id_low[26];
    assign mask_rev[25] = user_proj_id_high[25];
    assign mask_rev[24] = user_proj_id_low[24];
    assign mask_rev[23] = user_proj_id_low[23];
    assign mask_rev[22] = user_proj_id_low[22];
    assign mask_rev[21] = user_proj_id_low[21];
    assign mask_rev[20] = user_proj_id_low[20];
    assign mask_rev[19] = user_proj_id_high[19];
    assign mask_rev[18] = user_proj_id_low[18];
    assign mask_rev[17] = user_proj_id_low[17];
    assign mask_rev[16] = user_proj_id_high[16];
    assign mask_rev[15] = user_proj_id_low[15];
    assign mask_rev[14] = user_proj_id_low[14];
    assign mask_rev[13] = user_proj_id_high[13];
    assign mask_rev[12] = user_proj_id_low[12];
    assign mask_rev[11] = user_proj_id_low[11];
    assign mask_rev[10] = user_proj_id_low[10];
    assign mask_rev[9]  = user_proj_id_low[9];
    assign mask_rev[8]  = user_proj_id_low[8];
    assign mask_rev[7]  = user_proj_id_low[7];
    assign mask_rev[6]  = user_proj_id_low[6];
    assign mask_rev[5]  = user_proj_id_high[5];
    assign mask_rev[4]  = user_proj_id_low[4];
    assign mask_rev[3]  = user_proj_id_low[3];
    assign mask_rev[2]  = user_proj_id_high[2];
    assign mask_rev[1]  = user_proj_id_low[1];
    assign mask_rev[0]  = user_proj_id_high[0];

`ifdef LVS
    /* Enumerate the fillcap cells for LVS only */

    gf180mcu_as_sc_mcu7t3v3__fillcap_4 user_id_fillcap [23:0] (
    `ifdef USE_POWER_PINS
            .VDD(VDD),
            .VSS(VSS),
	    .VNW(VDD),
	    .VPW(VSS)
    `endif
    );
`endif

endmodule
`default_nettype wire
