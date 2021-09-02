#!/bin/bash

function usage {
    echo "usage: $programname [-h] [input directory] "
    echo "  -h      display help"
    echo "  add input directory as command line argument"
    exit 1
}

usage

find $1 -type f -name "pwfn.data" -exec rm -f {} \;
find $1 -type f -name "si.pwfn.data" -exec rm -f {} \;
find $1 -type f -name "silicon.pwfn.data" -exec rm -f {} \;
find $1 -type f -name "bwfn.data.bin" -exec rm -f {} \;
find $1 -type d -name "silicon.save" -exec rm -rf {} \;
