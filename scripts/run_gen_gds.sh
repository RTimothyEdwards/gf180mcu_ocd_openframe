#!/bin/bash
#
# Run layout GDS generation on caravel_openframe
# Run this script from the magic/ directory
#
echo ${PDK_ROOT:=/usr/share/pdk} > /dev/null
echo ${PDK:=gf180mcuD} > /dev/null

echo "Generating GDS for caravel_openframe"

magic -dnull -noconsole -rcfile ${PDK_ROOT}/${PDK}/libs.tech/magic/${PDK}.magicrc << EOF
drc off
crashbackups stop
locking disable
load caravel_openframe
select top cell
gds compress 9
gds write caravel_openframe
quit -noprompt
EOF
mv caravel_openframe.gds.gz ../gds/
echo "Done!"
exit 0
