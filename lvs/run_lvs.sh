#!/bin/sh
#
# Run LVS on caravel_openframe (GF180MCU version)
#
# export NETGEN_COLUMNS=150
export NETGEN_COLUMNS=75

echo ${PDK_ROOT:=/usr/share/pdk} > /dev/null
echo ${PDK:=gf180mcuD} > /dev/null

netgen -batch lvs \
"../netlist/layout/caravel_openframe.spice caravel_openframe" \
"../verilog/rtl/netlists.v caravel_openframe" \
${PDK_ROOT}/${PDK}/libs.tech/netgen/${PDK}_setup.tcl \
caravel_openframe_comp.out
