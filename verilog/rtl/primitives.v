// Primitive device definitions for LVS

`ifdef LVS

/* MOSCAP (used in padframe spacer cells) */

module cap_nmos_06v0 #(
	c_length = 1e-6,
	c_width = 1e-6
) (
    inout 1,
    inout 2
);

	/* No content, for LVS identification only */

endmodule

`endif // LVS
