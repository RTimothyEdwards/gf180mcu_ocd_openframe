# Tcl script for setting up LVS for the gf180mcu_ocd_openframe chip

if {[catch {set PDK_ROOT $::env(PDK_ROOT)}]} {set PDK_ROOT /usr/share/pdk} 
if {[catch {set PDK $::env(PDK)}]} {set PDK gf180mcuD}

set circuit2 [readnet spice ${PDK_ROOT}/${PDK}/libs.ref/gf180mcu_ocd_io/spice/gf180mcu_ocd_io.spice]
readnet spice ${PDK_ROOT}/${PDK}/libs.ref/gf180mcu_as_sc_mcu7t3v3/spice/gf180mcu_as_sc_mcu7t3v3.spice $circuit2
readnet spice ${PDK_ROOT}/${PDK}/libs.ref/gf180mcu_ocd_ip_sram/spice/gf180mcu_ocd_ip_sram__sram512x8m8wm1.spice $circuit2
readnet spice ${PDK_ROOT}/${PDK}/libs.ref/gf180mcu_ocd_ip_sram/spice/gf180mcu_ocd_ip_sram__sram256x8m8wm1.spice $circuit2
readnet verilog defs.v $circuit2
# "netlists.v" includes all of the verilog source files used in this project
readnet verilog ../verilog/rtl/netlists.v $circuit2

set circuit1 [readnet spice ../netlist/layout/caravel_openframe.spice]

# Avoid producing an error on layout cells being compared against
# verilog modules using the USER_PROJECT_ID parameter, which is
# gf180mcu_padframe and user_id_programming.  Note that deleting
# it as a property does not prevent it from being used as a
# verilog definition when reading the verilog.

property "$circuit2 gf180mcu_padframe" delete USER_PROJECT_ID
property "$circuit2 user_id_programming" delete USER_PROJECT_ID

# For now, don't propagate errors from user_id_programming, which may
# differ because the verilog parser does not recognize the syntax in
# the "for" loop used to generate the ROM program in verilog.

lvs "$circuit1 caravel_openframe" "$circuit2 caravel_openframe" \
${PDK_ROOT}/${PDK}/libs.tech/netgen/${PDK}_setup.tcl caravel_openframe_comp.out \
-noflatten=user_id_programming
