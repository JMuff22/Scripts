#!/bin/bash

# module load python-singularity

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
