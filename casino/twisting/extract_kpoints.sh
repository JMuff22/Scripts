#!/bin/bash
gawk '$1=="k(" {print $5,$6,$10}' out.pwscf > symmetric_xxx_kpoints.txt
#! can also head -n 105 out.pwscf | gawk 'match($0, /k\(    1\) = \(   ([^$]+)/, arr) { print arr[1]}' 