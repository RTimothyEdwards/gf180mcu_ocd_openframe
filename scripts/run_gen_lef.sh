#!/bin/bash
#
# Run layout LEF generation on the openframe project wrapper
# Run this script from the magic/ directory
#
echo ${PDK_ROOT:=/usr/share/pdk} > /dev/null
echo ${PDK:=gf180mcuD} > /dev/null

echo "Generating LEF abstract view for openframe_project_wrapper"
magic -dnull -noconsole -rcfile ${PDK_ROOT}/${PDK}/libs.tech/magic/${PDK}.magicrc << EOF
drc off
crashbackups stop
locking disable
load openframe_project_wrapper
# Remove the existing user project
select cell openframe_user_project_0
delete
select top cell
lef write -hide
quit -noprompt
EOF
mv openframe_project_wrapper.lef ../lef
echo "Done!"
exit 0
