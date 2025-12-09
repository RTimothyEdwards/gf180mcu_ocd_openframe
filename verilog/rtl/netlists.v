// SPDX-FileCopyrightText: 2025 Open Circuit Design, LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

/*
 *----------------------------------------------------------------
 * netlists.v
 *
 * Top level list of includes for all modules used in the GF
 * openframe.
 *----------------------------------------------------------------
 */

`timescale 1 ns / 1 ps

`define UNIT_DELAY #1
`define USE_POWER_PINS
`define OPENFRAME_IO_PADS 44

/* Primitive devices from the PDK, used in verilog for LVS purposes */
`include "primitives.v"

/* PDK libraries.  Need to pass the PDK root directory to iverilog with option -I */
`include "libs.ref/gf180mcu_ocd_io/verilog/gf180mcu_ocd_io.v"
`include "libs.ref/gf180mcu_fd_sc_mcu7t5v0/verilog/primitives.v"
`include "libs.ref/gf180mcu_fd_sc_mcu7t5v0/verilog/gf180mcu_fd_sc_mcu7t5v0.v"
`include "libs.ref/gf180mcu_as_sc_mcu7t3v3/verilog/gf180mcu_as_sc_mcu7t3v3.v"

/* Layout blocks (no behavioral or functional content) */
`include "caravel_logo.v"
`include "caravel_motto.v"
`include "copyright_block.v"
`include "user_id_textblock.v"

/* Basic building blocks */
`include "constant_block.v"
`include "lvlshift_down.v"

/* Padframe replacement cells */
`include "gf180mcu_ocd_io__fill10x.v"
`include "gf180mcu_ocd_io__fill10y.v"
`include "gf180mcu_ocd_io__fill10z.v"

/* ROM program for project ID */
`include "user_id_programming.v"

/* Simple POR */
`include "../../ip/simple_por/verilog/simple_por.v"

/* User project wrapper */
`include "openframe_project_wrapper.v"

/* User project */
`include "openframe_user_project.v"

/* Padframe */
`include "gf180mcu_padframe.v"

/* Top level */
`include "caravel_openframe.v"
