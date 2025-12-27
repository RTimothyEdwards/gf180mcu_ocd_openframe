#!/bin/bash
#
# Run layout extraction on caravel_openframe
# Run this script from the magic/ directory.
#
echo ${PDK_ROOT:=/usr/share/pdk} > /dev/null
echo ${PDK:=gf180mcuD} > /dev/null

echo "Running netlist extraction (for LVS) on caravel_openframe"
magic -dnull -noconsole -rcfile ${PDK_ROOT}/${PDK}/libs.tech/magic/${PDK}.magicrc << EOF
drc off
crashbackups stop
locking disable
load caravel_openframe
select top cell
# extract unique notopports
extract unique
extract path extfiles
extract no all
extract all
ext2spice lvs
ext2spice short resistor
ext2spice -p extfiles
quit -noprompt
EOF
rm -rf extfiles
mv caravel_openframe.spice ../netlist/layout/
echo "Done"
exit 0
