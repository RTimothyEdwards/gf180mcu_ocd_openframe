#!/bin/bash
#
# Run layout GDS generation on caravel_openframe_top
# Run this script from the magic/ directory
#
# Important note!  This script uses "cif *hier write disable"
# and "cif *array write disable" to greatly speed up GDS
# writing by ignoring hierarchical output adjustments.  This
# assumes that no adjustments are necessary.  The assumption
# is valid only if all cells in the GDS path are "readonly"
# ("vendor") cells which are dropped verbatim into the output,
# or else are digital standard cell layouts which are known
# to be DRC clean by design.  The simple_por block has been
# converted to a read-only layout for this purpose.  All
# I/O, standard cells, and memory are read as read-only
# layouts from the PDK.  No layout remains that requires
# hierarchical adjustments.
#
echo ${PDK_ROOT:=/usr/share/pdk} > /dev/null
echo ${PDK:=gf180mcuD} > /dev/null

echo "Generating GDS for caravel_openframe_top"

magic -dnull -noconsole -rcfile ${PDK_ROOT}/${PDK}/libs.tech/magic/${PDK}.magicrc << EOF
drc off
crashbackups stop
locking disable
addpath ../ip/wafer_space/magic
addpath ../ip/simple_por/magic
load caravel_openframe_top
select top cell
snap internal
cif *hier write disable
cif *array write disable
gds compress 9
gds write caravel_openframe_top
quit -noprompt
EOF
mv caravel_openframe_top.gds.gz ../gds/
echo "Done!"
exit 0
