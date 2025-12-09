// Black-box entry for the ring oscillator (which might not synthesize,
// and probably shouldn't even if it can).

module ring_osc2x13(reset, trim, clockp);
    input reset;
    input [25:0] trim;
    output[1:0] clockp;

endmodule;
