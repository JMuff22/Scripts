#!/bin/bash
cd /scratch/project_2002888/jakemuff/Si/cutoffs
for cutoff in $(seq 300 100 2200) ; do
  cd $cutoff
  cp si.pwfn.data pwfn.data
  cd ..
done
