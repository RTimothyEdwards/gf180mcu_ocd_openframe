# Tcl script for setting up LVS for the ring oscillator
if {[catch {set PDK_ROOT $::env(PDK_ROOT)}]} {set PDK_ROOT /usr/share/pdk} 
if {[catch {set PDK $::env(PDK)}]} {set PDK gf180mcuD}

# Note:  The ring oscillator should probably be completely self-contained, but
# for now its verilog source is in the parent project.

# Read defs.v as a verilog file to set the format to verilog for the entire
# netlist and to set global definitions like USE_POWER_PINS.

set circuit2 [readnet verilog defs.v]
readnet spice ${PDK_ROOT}/${PDK}/libs.ref/gf180mcu_as_sc_mcu7t3v3/spice/gf180mcu_as_sc_mcu7t3v3.spice $circuit2
readnet verilog ../../../verilog/rtl/ring_osc2x13.v $circuit2

set circuit1 [readnet spice ../magic/ring_osc2x13.spice]

lvs "$circuit1 ring_osc2x13" "$circuit2 ring_osc2x13" \
${PDK_ROOT}/${PDK}/libs.tech/netgen/${PDK}_setup.tcl comp.out

