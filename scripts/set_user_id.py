#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2025 Open Circuit Design, LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# SPDX-License-Identifier: Apache-2.0
#
# Original copyright of the file this was derived from:
# SPDX-FileCopyrightText: 2020 Efabless Corporation

#----------------------------------------------------------------------
#
# set_user_id.py ---
#
# Manipulate the magic database and verilog source files for the
# user_id_programming block to set the user ID number.  Specifically,
# the via programming is done in layout "user_id_vias.mag", which
# consists exclusively of the vias and nothing else, so the file can
# be wholly regenerated on demand.
#
# The user ID number is a 32-bit value that is passed to this routine
# as an 8-digit hex number.  If not given as an option, then the script
# will look for the value of the key "project_id" in the info.yaml file
# in the project top level directory.  If in "-report" mode, it will
# check the RTL top-level verilog to see if set_user_id.py has already
# been applied, and pull the value from there.
#
# user_id_vias layout map:
# Positions marked (in microns) for value = 0.  For value = 1, move
# the via 1.95um (78 internal units scaled 1/2) to the left.
# The via size is 30 x 30 (internal units, scaled 1/2)
#
# Signal        Via position (magic internal units, scaled 1/2)
# name		X      Y     
#--------------------------------
# mask_rev[0]   194 489
# mask_rev[1]	194 0
# mask_rev[2]	866 489
# mask_rev[3]	866 0
# mask_rev[4]	1426 489
# mask_rev[5]	1426 0
# mask_rev[6]	2098 489
# mask_rev[7]   2098 0
# mask_rev[8]   2658 489
# mask_rev[9]   2658 0
# mask_rev[10]  3330 489
# mask_rev[11]  3330 0
# mask_rev[12]	3890 489
# mask_rev[13]	3890 0
# mask_rev[14]	4562 489
# mask_rev[15]	4562 0
# mask_rev[16]	5122 489
# mask_rev[17]	5122 0
# mask_rev[18]	5794 489
# mask_rev[19]	5794 0
# mask_rev[20]	6354 489
# mask_rev[21]	6354 0
# mask_rev[22]	7026 489
# mask_rev[23]	7026 0
# mask_rev[24]	7586 489
# mask_rev[25]	7586 0
# mask_rev[26]	8258 489
# mask_rev[27]	8258 0
# mask_rev[28]	8818 489
# mask_rev[29]	8818 0
# mask_rev[30]	9490 489
# mask_rev[31]	9490 0
#----------------------------------------------------------------------

import os
import sys
import re
import subprocess

def usage():
    print("Usage:")
    print("set_user_id.py [<user_id_value>] [<path_to_project>]")
    print("")
    print("where:")
    print("    <user_id_value>   is a character string of eight hex digits, and")
    print("    <path_to_project> is the path to the project top level directory.")
    print("")
    print("  If <user_id_value> is not given, then it must exist in the info.yaml file.")
    print("  If <path_to_project> is not given, then it is assumed to be the cwd.")
    return 0

if __name__ == '__main__':

    # Coordinate pairs in magic internal units scaled by 5 for the zero
    # position on each bit

    mask_rev = (
	(194, 489), (194, 0), (866, 489), (866, 0),
	(1426, 489), (1426, 0), (2098, 489), (2098, 0),
	(2658, 489), (2658, 0), (3330, 489), (3330, 0),
	(3890, 489), (3890, 0), (4562, 489), (4562, 0),
	(5122, 489), (5122, 0), (5794, 489), (5794, 0),
	(6354, 489), (6354, 0), (7026, 489), (7026, 0),
	(7586, 489), (7586, 0), (8258, 489), (8258, 0),
	(8818, 489), (8818, 0), (9490, 489), (9490, 0));

    optionlist = []
    arguments = []

    debugmode = False
    reportmode = False

    for option in sys.argv[1:]:
        if option.find('-', 0) == 0:
            optionlist.append(option)
        else:
            arguments.append(option)

    if len(arguments) > 2:
        print("Wrong number of arguments given to set_user_id.py.")
        usage()
        sys.exit(0)

    if '-debug' in optionlist:
        debugmode = True
    if '-report' in optionlist:
        reportmode = True

    user_id_value = None
    user_project_path = None

    if len(arguments) > 0:
        user_id_value = arguments[0]

        # Convert to binary
        try:
            user_id_int = int('0x' + user_id_value, 0)
            user_id_bits = '{0:032b}'.format(user_id_int)[::-1]
        except:
            user_project_path = arguments[0]

    if len(arguments) == 0:
        user_project_path = os.getcwd()
    elif len(arguments) == 2:
        user_project_path = arguments[1]
    elif user_project_path == None:
        user_project_path = arguments[0]
    else:
        user_project_path = os.getcwd()

    if not os.path.isdir(user_project_path):
        print('Error:  Project path "' + user_project_path + '" does not' +
		' exist or is not readable.')
        sys.exit(1)

    # Check for valid directories

    if not user_id_value:
        if os.path.isfile(user_project_path + '/info.yaml'):
            with open(user_project_path + '/info.yaml', 'r') as ifile:
                infolines = ifile.read().splitlines()
                for line in infolines:
                    kvpair = line.split(':')
                    if len(kvpair) == 2:
                        key = kvpair[0].strip()
                        value = kvpair[1].strip()
                        if key == 'project_id':
                            user_id_value = value.strip('"\'')
                            break

            if not user_id_value:
                print('Error:  No project_id key:value pair found in project info.yaml.')
                sys.exit(1)

            try:
                user_id_int = int('0x' + user_id_value, 0)
                user_id_bits = '{0:032b}'.format(user_id_int)[::-1]
            except:
                print('Error:  Cannot parse user ID "' + user_id_value +
				'" as an 8-digit hex number.')
                sys.exit(1)

        elif reportmode:
            found = False
            idrex = re.compile("parameter USER_PROJECT_ID = 32'h([0-9A-F]+);")

            # Check if USER_PROJECT_ID has a non-zero value in caravel.v
            rtl_top_path = user_project_path + '/verilog/rtl/caravel_core.v'
            if os.path.isfile(rtl_top_path):
                with open(rtl_top_path, 'r') as ifile:
                    vlines = ifile.read().splitlines()
                    outlines = []
                    for line in vlines:
                        imatch = idrex.search(line)
                        if imatch:
                            user_id_int = int('0x' + imatch.group(1), 0)
                            found = True
                            break
            else:
                print('Error:  Cannot find top-level RTL ' + rtl_top_path + '.' +
			'  Is this script being run in the project directory?')
            if not found:
                if reportmode:
                    user_id_int = 0
                else:
                    print('Error:  No USER_PROJECT_ID found in caravel top level verilog.')
                    sys.exit(1)
        else:
            print('Error:  No info.yaml file and no user ID argument given.')
            sys.exit(1)

    if reportmode:
        print(str(user_id_int))
        sys.exit(0)

    if user_id_int == 0:
        print('Value zero is an invalid user ID.  Exiting.')
        sys.exit(1)

    print('Setting project user ID to: ' + user_id_value)

    magpath = user_project_path + '/magic'
    vpath = user_project_path + '/verilog'
    errors = 0 

    if not os.path.isdir(vpath):
        print('No directory ' + vpath + ' found (path to verilog).')
        sys.exit(1)

    if not os.path.isdir(magpath):
        print('No directory ' + magpath + ' found (path to magic databases).')
        sys.exit(1)

    print('Step 1:  Modify layout of the user_id_vias subcell')

    # Read the ID programming layout.  If a backup was made of the
    # zero-value program, then use it.

    magbak = magpath + '/user_id_vias_zero.mag'
    magfile = magpath + '/user_id_vias.mag'

    if os.path.isfile(magbak):
        with open(magbak, 'r') as ifile:
            magdata = ifile.read()
    else:
        with open(magfile, 'r') as ifile:
            magdata = ifile.read()

    for i in range(0,32):
        # Ignore any zero bits.
        if user_id_bits[i] == '0':
            continue

        coords = mask_rev[i]
        xint = coords[0]
        yint = coords[1]

        # Calculate the via corner positions

        xllint = xint
        yllint = yint
        xurint = xint + 30
        yurint = yint + 30
 
        # Get the values for the corner coordinates in magic internal units
        xlli = xllint
        ylli = yllint
        xuri = xurint
        yuri = yurint

        viaoldposdata = f"rect {xlli} {ylli} {xuri} {yuri}"

        # For "one" bits, the X position is moved 1.94 microns to the left
        newxllint = xllint - 194
        newxurint = xurint - 194

        # Get the values for the new corner coordinates in magic internal units
        newxlli = newxllint
        newxuri = newxurint

        vianewposdata = f"rect {newxlli} {ylli} {newxuri} {yuri}"

        # Diagnostic
        if debugmode:
            print('Bit ' + str(i) + ':')
            print('Via position ({0:3.2f}, {1:3.2f}) to ({2:3.2f}, {3:3.2f})'.format(xllint, yllint, xurint, yurint))
            print('Old string = "' + viaoldposdata + '"')
            print('New string = "' + vianewposdata + '"')

        # Replace the old data with the new
        if viaoldposdata not in magdata:
            if vianewposdata in magdata:
                print('Warning: via already moved at bit position ' + str(i))
            else:
                print('Error: via not found for bit position ' + str(i))
                errors += 1 
        else:
            magdata = magdata.replace(viaoldposdata, vianewposdata)

    if errors == 0:
        # Keep a copy of the original 
        if not os.path.isfile(magbak):
            os.rename(magfile, magbak)

        with open(magfile, 'w') as ofile:
            ofile.write(magdata)

        print('Done!')
            
    else:
        print('There were errors in processing.  No file written.')
        print('Ending process.')
        sys.exit(1)

    print('Step 2:  Add user project ID parameter to source verilog.')

    changed = False
    with open(vpath + '/rtl/caravel_openframe.v', 'r') as ifile:
        vlines = ifile.read().splitlines()
        outlines = []
        for line in vlines:
            oline = re.sub("parameter USER_PROJECT_ID = 32'h[0-9A-F]+;",
			"parameter USER_PROJECT_ID = 32'h" + user_id_value + ";",
			line)
            if oline != line:
                changed = True
            outlines.append(oline)

    if changed:
        with open(vpath + '/rtl/caravel_openframe.v', 'w') as ofile:
            for line in outlines:
                print(line, file=ofile)
            print('Done!')
    else:
        print('Error:  No substitutions done on verilog/rtl/caravel_openframe.v.')
        print('Ending process.')
        sys.exit(1)

    print('Step 3:  Add user project ID text to top level layout.')

    with open(magpath + '/user_id_textblock.mag', 'r') as ifile:
        maglines = ifile.read().splitlines()
        outlines = []
        digit = 0
        wasseen = {}
        for line in maglines:
            if 'alphaX_' in line:
                dchar = user_id_value[7 - digit].upper()
                oline = re.sub('alpha_[0-9A-F]', 'alpha_' + dchar, line)
                # Add path reference if cell was not previously found in the file
                if dchar not in wasseen:
                    if 'gf180mcu_ocd_alpha_large' not in oline:
                        oline += ' $PDKPATH/libs.ref/gf180mcu_ocd_alpha_large/mag'
                outlines.append(oline)
                wasseen[dchar] = True
                digit += 1
            else:
                outlines.append(line)

    if digit == 8:
        with open(magpath + '/user_id_textblock.mag', 'w') as ofile:
            for line in outlines:
                print(line, file=ofile)
        print('Done!')
    elif digit == 0:
        print('Error:  No digits were replaced in the layout.')
    else:
        print('Error:  Only ' + str(digit) + ' digits were replaced in the layout.')

    sys.exit(0)
