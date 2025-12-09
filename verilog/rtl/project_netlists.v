/* Source files used by the openframe user project */

`define OPENFRAME_IO_PADS 44
`define USE_POWER_PINS

`define HAS_USER_PROJECT

`ifdef HAS_USER_PROJECT

/* PDK libraries.  Need to pass the PDK root directory to iverilog with option -I */
`include "libs.ref/gf180mcu_ocd_ip_sram/verilog/gf180mcu_ocd_ip_sram__sram512x8m8wm1.v"
`include "libs.ref/gf180mcu_ocd_ip_sram/verilog/gf180mcu_ocd_ip_sram__sram256x8m8wm1.v"

`include "clock_div.v"
`include "clock_routing.v"
`include "counter_timer_high.v"
`include "counter_timer_low.v"
`include "debug_regs.v"
`include "dll.v"
`include "dll_controller.v"
`include "gpio_vector_wb.v"
`include "gpio_wb.v"
`include "housekeeping.v"
`include "housekeeping_spi.v"
`include "intercon_wb.v"
`include "mem_wb.v"
`include "ring_osc2x13.v"
`include "simple_spi_master.v"
`include "simpleuart.v"
`include "spimemio.v"
`include "vccd_connection.v"
`include "vssd_connection.v"
`include "picosoc.v"
`include "picorv32.v"
`endif
