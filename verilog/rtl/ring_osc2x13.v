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

// Tunable ring oscillator---synthesizable (physical) version.
//
// NOTE:  This netlist cannot be simulated correctly due to lack
// of accurate timing in the digital cell verilog models.

module delay_stage(
`ifdef USE_POWER_PINS
    inout  wire		vdd,
    inout  wire		vss,
`endif
    input  wire 	in,
    input  wire [1:0]	trim,
    output wire		out
);

    wire d0, d1, d2, ts;
    wire trim0b, trim1b;

    gf180mcu_as_sc_mcu7t3v3__inv_2 trim0bar (
    `ifdef USE_POWER_PINS
	.VDD(vdd),
	.VSS(vss),
	.VPW(vss),
	.VNW(vdd),
    `endif
	.A(trim[0]),
	.Y(trim0b)
    );

    gf180mcu_as_sc_mcu7t3v3__inv_2 trim1bar (
    `ifdef USE_POWER_PINS
	.VDD(vdd),
	.VSS(vss),
	.VPW(vss),
	.VNW(vdd),
    `endif
	.A(trim[1]),
	.Y(trim1b)
    );

    gf180mcu_as_sc_mcu7t3v3__clkbuff_4 delaybuf0 (
    `ifdef USE_POWER_PINS
	.VDD(vdd),
	.VSS(vss),
	.VPW(vss),
	.VNW(vdd),
    `endif
	.A(in),
	.Y(ts)
    );

    gf180mcu_as_sc_mcu7t3v3__clkbuff_4 delaybuf1 (
    `ifdef USE_POWER_PINS
	.VDD(vdd),
	.VSS(vss),
	.VPW(vss),
	.VNW(vdd),
    `endif
	.A(ts),
	.Y(d0)
    );

    gf180mcu_as_sc_mcu7t3v3__invz_2 delayen1 (
    `ifdef USE_POWER_PINS
	.VDD(vdd),
	.VSS(vss),
	.VPW(vss),
	.VNW(vdd),
    `endif
	.A(d0),
	.EN(trim[1]),
	.Y(d1)
    );

    gf180mcu_as_sc_mcu7t3v3__invz_2 delayenb1 (
    `ifdef USE_POWER_PINS
	.VDD(vdd),
	.VSS(vss),
	.VPW(vss),
	.VNW(vdd),
    `endif
	.A(ts),
	.EN(trim1b),
	.Y(d1)
    );

    gf180mcu_as_sc_mcu7t3v3__inv_2 delayint0 (
    `ifdef USE_POWER_PINS
	.VDD(vdd),
	.VSS(vss),
	.VPW(vss),
	.VNW(vdd),
    `endif
	.A(d1),
	.Y(d2)
    );

    gf180mcu_as_sc_mcu7t3v3__invz_2 delayen0 (
    `ifdef USE_POWER_PINS
	.VDD(vdd),
	.VSS(vss),
	.VPW(vss),
	.VNW(vdd),
    `endif
	.A(d2),
	.EN(trim[0]),
	.Y(out)
    );

    gf180mcu_as_sc_mcu7t3v3__invz_2 delayenb0 (
    `ifdef USE_POWER_PINS
	.VDD(vdd),
	.VSS(vss),
	.VPW(vss),
	.VNW(vdd),
    `endif
	.A(ts),
	.EN(trim0b),
	.Y(out)
    );

    gf180mcu_as_sc_mcu7t3v3__diode_2 trim_0_antenna (
    `ifdef USE_POWER_PINS
	.VDD(vdd),
	.VSS(vss),
	.VPW(vss),
	.VNW(vdd),
    `endif
	.DIODE(trim[0])
    );

    gf180mcu_as_sc_mcu7t3v3__diode_2 trim_1_antenna (
    `ifdef USE_POWER_PINS
	.VDD(vdd),
	.VSS(vss),
	.VPW(vss),
	.VNW(vdd),
    `endif
	.DIODE(trim[1])
    );

    `ifdef LVS
    gf180mcu_as_sc_mcu7t3v3__fillcap_4 fillcap [3:0] (
    `ifdef USE_POWER_PINS
	.VDD(vdd),
	.VSS(vss),
	.VPW(vss),
	.VNW(vdd)
    `endif
    );

    `endif

endmodule

module start_stage(
`ifdef USE_POWER_PINS
    inout  wire		vdd,
    inout  wire		vss,
`endif
    input  wire		in,
    input  wire	[1:0]	trim,
    input  wire		reset,
    output wire		out
);

    wire d0, d1, d2, ctrl0b, one;
    wire trim1b;

    gf180mcu_as_sc_mcu7t3v3__inv_2 trim1bar (
    `ifdef USE_POWER_PINS
	.VDD(vdd),
	.VSS(vss),
	.VPW(vss),
	.VNW(vdd),
    `endif
	.A(trim[1]),
	.Y(trim1b)
    );

    gf180mcu_as_sc_mcu7t3v3__clkbuff_4 delaybuf0 (
    `ifdef USE_POWER_PINS
	.VDD(vdd),
	.VSS(vss),
	.VPW(vss),
	.VNW(vdd),
    `endif
	.A(in),
	.Y(d0)
    );

    gf180mcu_as_sc_mcu7t3v3__invz_2 delayen1 (
    `ifdef USE_POWER_PINS
	.VDD(vdd),
	.VSS(vss),
	.VPW(vss),
	.VNW(vdd),
    `endif
	.A(d0),
	.EN(trim[1]),
	.Y(d1)
    );

    gf180mcu_as_sc_mcu7t3v3__invz_2 delayenb1 (
    `ifdef USE_POWER_PINS
	.VDD(vdd),
	.VSS(vss),
	.VPW(vss),
	.VNW(vdd),
    `endif
	.A(in),
	.EN(trim1b),
	.Y(d1)
    );

    gf180mcu_as_sc_mcu7t3v3__inv_2 delayint0 (
    `ifdef USE_POWER_PINS
	.VDD(vdd),
	.VSS(vss),
	.VPW(vss),
	.VNW(vdd),
    `endif
	.A(d1),
	.Y(d2)
    );

    gf180mcu_as_sc_mcu7t3v3__invz_2 delayen0 (
    `ifdef USE_POWER_PINS
	.VDD(vdd),
	.VSS(vss),
	.VPW(vss),
	.VNW(vdd),
    `endif
	.A(d2),
	.EN(trim[0]),
	.Y(out)
    );

    gf180mcu_as_sc_mcu7t3v3__invz_2 delayenb0 (
    `ifdef USE_POWER_PINS
	.VDD(vdd),
	.VSS(vss),
	.VPW(vss),
	.VNW(vdd),
    `endif
	.A(in),
	.EN(ctrl0b),
	.Y(out)
    );

    gf180mcu_as_sc_mcu7t3v3__invz_2 reseten0 (
    `ifdef USE_POWER_PINS
	.VDD(vdd),
	.VSS(vss),
	.VPW(vss),
	.VNW(vdd),
    `endif
	.A(one),
	.EN(reset),
	.Y(out)
    );

    gf180mcu_as_sc_mcu7t3v3__nor2_2 ctrlen0 (
    `ifdef USE_POWER_PINS
	.VDD(vdd),
	.VSS(vss),
	.VPW(vss),
	.VNW(vdd),
    `endif
	.A(reset),
	.B(trim[0]),
	.Y(ctrl0b)
    );

    gf180mcu_as_sc_mcu7t3v3__tieh_4 const1 (
    `ifdef USE_POWER_PINS
	.VDD(vdd),
	.VSS(vss),
	.VPW(vss),
	.VNW(vdd),
    `endif
	.ONE(one)
    );

    gf180mcu_as_sc_mcu7t3v3__diode_2 trim_0_antenna (
    `ifdef USE_POWER_PINS
	.VDD(vdd),
	.VSS(vss),
	.VPW(vss),
	.VNW(vdd),
    `endif
	.DIODE(trim[0])
    );

    gf180mcu_as_sc_mcu7t3v3__diode_2 trim_1_antenna (
    `ifdef USE_POWER_PINS
	.VDD(vdd),
	.VSS(vss),
	.VPW(vss),
	.VNW(vdd),
    `endif
	.DIODE(trim[1])
    );

endmodule

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

module ring_osc2x13 (
`ifdef USE_POWER_PINS
    inout  wire		vdd,
    inout  wire		vss,
`endif
    input  wire 	reset,
    input  wire [25:0]	trim,
    `ifdef FUNCTIONAL	// behavioral model
	output reg  [1:0]	clockp
    `else
	output wire [1:0]	clockp
    `endif
);

`ifdef FUNCTIONAL	// behavioral model below

    reg hiclock;
    integer i;
    real delay;
    wire [5:0] bcount;

    assign bcount = trim[0] + trim[1] + trim[2]
		+ trim[3] + trim[4] + trim[5] + trim[6] + trim[7]
		+ trim[8] + trim[9] + trim[10] + trim[11] + trim[12]
		+ trim[13] + trim[14] + trim[15] + trim[16] + trim[17]
		+ trim[18] + trim[19] + trim[20] + trim[21] + trim[22]
		+ trim[23] + trim[24] + trim[25];

    initial begin
	hiclock <= 1'b0;
	delay = 3.0;
    end

    // Fastest operation is 214 MHz = 4.67ns
    // Delay per trim is 0.02385
    // Run "hiclock" at 2x this rate, then use positive and negative
    // edges to derive the 0 and 90 degree phase clocks.

    always #delay begin
	hiclock <= (hiclock === 1'b0);
    end

    always @(trim) begin
    	// Implement trim as a variable delay, one delay per trim bit
	delay = 1.168 + 0.012 * $itor(bcount);
    end

    always @(posedge hiclock or posedge reset) begin
	if (reset == 1'b1) begin
	    clockp[0] <= 1'b0;
	end else begin
	    clockp[0] <= (clockp[0] === 1'b0);
	end
    end

    always @(negedge hiclock or posedge reset) begin
	if (reset == 1'b1) begin
	    clockp[1] <= 1'b0;
	end else begin
	    clockp[1] <= (clockp[1] === 1'b0);
	end
    end

`else 			// !FUNCTIONAL;  i.e., gate level netlist below

    wire [12:0] d;
    wire [1:0] c;

    // Main oscillator loop stages
 
//    genvar i;
//    generate
//	for (i = 0; i < 12; i = i + 1) begin : dstage
//	    delay_stage id (
//		`ifdef USE_POWER_PINS
//		    .vdd(vdd),
//		    .vss(vss),
//		`endif
//		.in(d[i]),
//		.trim({trim[i+13], trim[i]}),
//		.out(d[i+1])
//	    );
//	end
//   endgenerate

     /* "generate" does not work well with netgen yet. */
    delay_stage id_0 (
	`ifdef USE_POWER_PINS
	    .vdd(vdd),
	    .vss(vss),
	`endif
	.in(d[0]),
	.trim({trim[13], trim[0]}),
	.out(d[1])
    );
    delay_stage id_1 (
	`ifdef USE_POWER_PINS
	    .vdd(vdd),
	    .vss(vss),
	`endif
	.in(d[1]),
	.trim({trim[14], trim[1]}),
	.out(d[2])
    );
    delay_stage id_2 (
	`ifdef USE_POWER_PINS
	    .vdd(vdd),
	    .vss(vss),
	`endif
	.in(d[2]),
	.trim({trim[15], trim[2]}),
	.out(d[3])
    );
    delay_stage id_3 (
	`ifdef USE_POWER_PINS
	    .vdd(vdd),
	    .vss(vss),
	`endif
	.in(d[3]),
	.trim({trim[16], trim[3]}),
	.out(d[4])
    );
    delay_stage id_4 (
	`ifdef USE_POWER_PINS
	    .vdd(vdd),
	    .vss(vss),
	`endif
	.in(d[4]),
	.trim({trim[17], trim[4]}),
	.out(d[5])
    );
    delay_stage id_5 (
	`ifdef USE_POWER_PINS
	    .vdd(vdd),
	    .vss(vss),
	`endif
	.in(d[5]),
	.trim({trim[18], trim[5]}),
	.out(d[6])
    );
    delay_stage id_6 (
	`ifdef USE_POWER_PINS
	    .vdd(vdd),
	    .vss(vss),
	`endif
	.in(d[6]),
	.trim({trim[19], trim[6]}),
	.out(d[7])
    );
    delay_stage id_7 (
	`ifdef USE_POWER_PINS
	    .vdd(vdd),
	    .vss(vss),
	`endif
	.in(d[7]),
	.trim({trim[20], trim[7]}),
	.out(d[8])
    );
    delay_stage id_8 (
	`ifdef USE_POWER_PINS
	    .vdd(vdd),
	    .vss(vss),
	`endif
	.in(d[8]),
	.trim({trim[21], trim[8]}),
	.out(d[9])
    );
    delay_stage id_9 (
	`ifdef USE_POWER_PINS
	    .vdd(vdd),
	    .vss(vss),
	`endif
	.in(d[9]),
	.trim({trim[22], trim[9]}),
	.out(d[10])
    );
    delay_stage id_10 (
	`ifdef USE_POWER_PINS
	    .vdd(vdd),
	    .vss(vss),
	`endif
	.in(d[10]),
	.trim({trim[23], trim[10]}),
	.out(d[11])
    );
    delay_stage id_11 (
	`ifdef USE_POWER_PINS
	    .vdd(vdd),
	    .vss(vss),
	`endif
	.in(d[11]),
	.trim({trim[24], trim[11]}),
	.out(d[12])
    );



    // Reset/startup stage
 
    start_stage iss (
	`ifdef USE_POWER_PINS
	    .vdd(vdd),
	    .vss(vss),
	`endif
	.in(d[12]),
	.trim({trim[25], trim[12]}),
	.reset(reset),
	.out(d[0])
    );

    // Buffered outputs a 0 and 90 degrees phase (approximately)

    gf180mcu_as_sc_mcu7t3v3__inv_2 ibufp00 (
    `ifdef USE_POWER_PINS
	.VDD(vdd),
	.VSS(vss),
	.VPW(vss),
	.VNW(vdd),
    `endif
	.A(d[0]),
	.Y(c[0])
    );
    gf180mcu_as_sc_mcu7t3v3__inv_6 ibufp01 (
    `ifdef USE_POWER_PINS
	.VDD(vdd),
	.VSS(vss),
	.VPW(vss),
	.VNW(vdd),
    `endif
	.A(c[0]),
	.Y(clockp[0])
    );
    gf180mcu_as_sc_mcu7t3v3__inv_2 ibufp10 (
    `ifdef USE_POWER_PINS
	.VDD(vdd),
	.VSS(vss),
	.VPW(vss),
	.VNW(vdd),
    `endif
	.A(d[6]),
	.Y(c[1])
    );
    gf180mcu_as_sc_mcu7t3v3__inv_6 ibufp11 (
    `ifdef USE_POWER_PINS
	.VDD(vdd),
	.VSS(vss),
	.VPW(vss),
	.VNW(vdd),
    `endif
	.A(c[1]),
	.Y(clockp[1])
    );

    gf180mcu_as_sc_mcu7t3v3__diode_2 reset_antenna (
    `ifdef USE_POWER_PINS
	.VDD(vdd),
	.VSS(vss),
	.VPW(vss),
	.VNW(vdd),
    `endif
	.DIODE(reset)
    );

    `ifdef LVS
    gf180mcu_as_sc_mcu7t3v3__fillcap_8 fillcap [8:0] (
    `ifdef USE_POWER_PINS
	.VDD(vdd),
	.VSS(vss),
	.VPW(vss),
	.VNW(vdd)
    `endif
    );

    gf180mcu_as_sc_mcu7t3v3__fillcap_4 fillcap2 (
    `ifdef USE_POWER_PINS
	.VDD(vdd),
	.VSS(vss),
	.VPW(vss),
	.VNW(vdd)
    `endif
    );

    `endif

`endif // !FUNCTIONAL

endmodule
`default_nettype wire
