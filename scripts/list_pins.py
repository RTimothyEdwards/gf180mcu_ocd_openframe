#!/bin/env python3
#
# List ports of gf180mcu_padframe.mag.
# Generate an output of ports in numerical index order.
# Report on any errors.

import io
import sys

vectors = {}
maxport = 0
with open('../magic/gf180mcu_padframe.mag', 'r') as ifile:
    ilines = ifile.read().splitlines()
    for line in ilines:
        if line.startswith('flabel'):
            portname = line.split()[12]
        elif line.startswith('rlabel'):
            portname = line.split()[8]
            print('Warning: port ' + portname + ' is on an rlabel')
        elif line.startswith('port'):
            portnum = line.split()[1]
            try:
                badport = vectors[portname]
            except:
                vectors[portname] = portnum
                if int(portnum) > maxport:
                    maxport = int(portnum)
            else:
                if badport != portnum:
                    print('Bad port ' + portname + ' indexes ' + portnum + ', ' + badport)

vindexes = []
for i in range(0, maxport + 1):
    vindexes.append("")

for vector in vectors.keys():
    portnum = vectors[vector]
    pnum = int(portnum)
    if vindexes[pnum] != "":
        if vector != vindexes[pnum]:
            print('Bad index ' + portnum + ' vectors ' + vector + ', ' + vindexes[pnum])
    else:
        vindexes[pnum] = vector
    
for i in range(0, maxport + 1):
    if vindexes[i] != "":
        print('Port ' + str(i) + ' signal ' + vindexes[i])


