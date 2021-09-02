#!/bin/bash

for i in {2..10..1}; do
	cp -r exercise02_material/ $i
	cd $i
	sed -i "s/9087456/$RANDOM/g" in.si_nw_irr
	sed -i "s/1845373/$RANDOM/g" in.si_nw_irr
	sbatch $HOME/lammps_run.sh in.si_nw_irr
	cd ..
done