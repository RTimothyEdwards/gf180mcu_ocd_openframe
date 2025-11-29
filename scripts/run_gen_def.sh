#!/bin/bash
#
# Run layout DEF generation on the openframe project wrapper
# Run this script from the magic/ directory
#
echo ${PDK_ROOT:=/usr/share/pdk} > /dev/null
echo ${PDK:=gf180mcuD} > /dev/null

echo "Generating DEF view for openframe_project_wrapper"
magic -dnull -noconsole -rcfile ${PDK_ROOT}/${PDK}/libs.tech/magic/${PDK}.magicrc << EOF
drc off
crashbackups stop
locking disable
load openframe_project_wrapper
extract path extfiles
extract all
select top cell
def write openframe_project_wrapper
quit -noprompt
EOF
rm -r extfiles
mv openframe_project_wrapper.def ../def
echo "Done!"
exit 0
