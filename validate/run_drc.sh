#!/bin/bash
#
# Run klayout DRC on the openframe test chip final version
# GDS is caravel_openframe_filled.gds.gz, top level cell name is
# caravel_openframe_top
#
echo ${PDK_ROOT:=/usr/share/pdk} > /dev/null
echo ${PDK:=gf180mcuD} > /dev/null

klayout -b -zz -r ${PDK_ROOT}/${PDK}/libs.tech/klayout/tech/drc/gf180mcu.drc -rd input=../gds/caravel_openframe_filled.gds.gz -rd report=../validate/caravel_openframe_drc_klayout.lyrdb -rd feol=True -rd beol=True -rd conn_drc=True -rd wedge=True -rd run_mode=deep -rd thr=16 -rd topcell=caravel_openframe_top

echo "Done!"
exit 0
