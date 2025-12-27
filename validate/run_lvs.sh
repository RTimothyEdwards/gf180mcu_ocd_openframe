#!/bin/sh
#
# Run LVS on caravel_openframe (GF180MCU version)
#
export NETGEN_COLUMNS=150
# export NETGEN_COLUMNS=75

# Reading the verilog side is complicated and
# the detailed setup is in the lvs_script.tcl
# file.

netgen -batch source lvs_script.tcl
