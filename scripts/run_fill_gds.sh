#!/bin/bash
#
# Run the klayout fill generation on the top level chip to produce
# the final design to submit to Wafer.Space.
#
# This script is assumed to be run in the magic/ directory, as it
# cds up one directory level and then down to gds/.  It could be
# made smarter about this.

echo "Generating fill for caravel_openframe_top"

# NOTE:  Hash sums cannot be run on the compressed layout, so
# generate an uncompressed layout, run the hash sums, then
# compress the layout.

echo ${PDK_ROOT:=/usr/share/pdk} > /dev/null

cd ../gds

# Note the requirement for flag "Metal2_ignore_active", or else the
# stupid GF fill rules will not allow density to be met.

klayout -zz -r \
    ${PDK_ROOT}/gf180mcuD/libs.tech/klayout/tech/drc/filler_generation/fill_all.rb \
    -rd input=caravel_openframe_top.gds.gz \
    -rd output=caravel_openframe_filled.gds \
    -rd Metal2_ignore_active

echo "md5sum:"
md5sum caravel_openframe_filled.gds

echo "sha1sum:"
sha1sum caravel_openframe_filled.gds

echo "sha256sum:"
sha256sum caravel_openframe_filled.gds

gzip -n --best caravel_openframe_filled.gds

echo "Done!"
exit 0
