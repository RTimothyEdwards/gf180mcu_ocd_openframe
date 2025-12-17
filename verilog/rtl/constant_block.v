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
/* 
 *---------------------------------------------------------------------
 * A simple module that generates buffered high and low outputs
 * in the 3.3V domain, using the Avalon Semiconductor standard cells.
 *---------------------------------------------------------------------
 */

module constant_block (
    `ifdef USE_POWER_PINS
         inout vdd,
         inout vss,
    `endif

    output	 one,
    output	 zero
);

    wire	one_unbuf;
    wire	zero_unbuf;

    gf180mcu_as_sc_mcu7t3v3__tieh_4 const_one (
`ifdef USE_POWER_PINS
            .VDD(vdd),
            .VSS(vss),
            .VNW(vdd),
            .VPW(vss),
`endif
            .ONE(one_unbuf)
    );

    gf180mcu_as_sc_mcu7t3v3__tiel_4 const_zero (
`ifdef USE_POWER_PINS
            .VDD(vdd),
            .VSS(vss),
            .VNW(vdd),
            .VPW(vss),
`endif
            .ZERO(zero_unbuf)
    );

    /* Buffer the constant outputs (could be synthesized) */

    gf180mcu_as_sc_mcu7t3v3__buff_12 const_one_buf (
`ifdef USE_POWER_PINS
            .VDD(vdd),
            .VSS(vss),
            .VNW(vdd),
            .VPW(vss),
`endif
            .A(one_unbuf),
            .Y(one)
    );

    gf180mcu_as_sc_mcu7t3v3__buff_12 const_zero_buf (
`ifdef USE_POWER_PINS
            .VDD(vdd),
            .VSS(vss),
            .VNW(vdd),
            .VPW(vss),
`endif
            .A(zero_unbuf),
            .Y(zero)
    );

    /* For LVS purposes, enumerate the fillcap cells */

`ifdef LVS
    gf180mcu_as_sc_mcu7t3v3__fillcap_4 const_fillcap [1:0] (
    `ifdef USE_POWER_PINS
            .VDD(vdd),
            .VSS(vss),
            .VNW(vdd),
            .VPW(vss)
    `endif
    );
`endif

endmodule
`default_nettype wire
