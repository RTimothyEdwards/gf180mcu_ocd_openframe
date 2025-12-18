#!/bin/sh
#
# Run LVS on caravel_openframe (GF180MCU version)
#
# export NETGEN_COLUMNS=150
export NETGEN_COLUMNS=75

echo ${PDK_ROOT:=/usr/share/pdk} > /dev/null
echo ${PDK:=gf180mcuD} > /dev/null

# This is a very simple LVS setup and the verilog
# netlist side should be handled in a Tcl script
# to pull in SPICE netlists of all behavioral
# blocks including standard cells, SRAM, I/O,
# etc.

# netgen -batch lvs \
# "../netlist/layout/caravel_openframe.spice caravel_openframe" \
# "../verilog/rtl/netlists.v caravel_openframe" \
# ${PDK_ROOT}/${PDK}/libs.tech/netgen/${PDK}_setup.tcl \
# caravel_openframe_comp.out -noflatten=noflatten.lst

netgen -batch lvs \
"../netlist/layout/caravel_openframe.spice caravel_openframe" \
"../verilog/rtl/netlists.v caravel_openframe" \
${PDK_ROOT}/${PDK}/libs.tech/netgen/${PDK}_setup.tcl \
caravel_openframe_comp.out
