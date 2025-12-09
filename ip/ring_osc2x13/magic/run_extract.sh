#!/bin/bash
#
# Run layout extraction on the ring oscillator layout
#
echo ${PDK_ROOT:=/usr/share/pdk} > /dev/null
echo ${PDK:=gf180mcuD} > /dev/null

echo "Running netlist extraction on ring_osc2x13"
magic -dnull -noconsole -rcfile ${PDK_ROOT}/${PDK}/libs.tech/magic/${PDK}.magicrc << EOF
load ring_osc2x13
select top cell
extract unique notopports
extract path extfiles
extract no all
extract all
ext2spice lvs
ext2spice -p extfiles
quit -noprompt
EOF
rm -rf extfiles
echo "Done"
