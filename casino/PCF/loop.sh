#!/bin/bash

# This loop goes into each vmc/dmc (depending on input) and uses the casino util plot_expval to extract data from
# expval.data and turn it into lineplot.dat. It uses 1-3 particle pairs, and plots the input data with no reblocking.
# It then moves the lineplot.dat to the number directory and runs the positron util gather_lineplot.py
# which takes the lineplot.dat from each directory and creates 2 exported numpy arrays. 1 for the radius which 
# is the same for both vmc and dmc (col 0) and the 2nd file is the col 1 array from vmc/dmc. 

for i in {1..20}
do
    echo $i
    cd $i/$2
    #clearup -f; rm -f expval.data
    #runqmc -p 40 -T 40m
    plot_expval <<EOF
3
$1

EOF
    mv lineplot.dat ..
    cd ..
    cd ..
done

python $HOME/casino_positrons/positron_utils/gather_lineplot.py --files 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 --gfile g${2}_${1}.npy --write_r 1

mv r.npy r_${1}.npy
