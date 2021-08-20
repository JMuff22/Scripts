#!/bin/bash
#SBATCH --account=project_2002888
#SBATCH -J PCF.sh
#SBATCH --partition=medium
#SBATCH --nodes=1
#SBATCH --ntasks=128
#SBATCH --time=1:00:00
##SBATCH --ntasks-per-node=32
##SBATCH --cpus-per-task=32


mkdir -v PCF
cd PCF
# echo "Start: " $PWD
for dir in $(seq 1 1 20) ; do
	echo "Start:" $dir $PWD
	mkdir $dir
	cd $dir
	echo $PWD
	mkdir vmc
	cd vmc
	echo $PWD
	cp -v ../../../vmc/bwfn.data.bin . 
	cp -v ../../../vmc/si_pp.data . 
	cp -v ../../../vmc/input .
	cp -v ../../../vmc/correlation.data .
	cd ..   
	mkdir dmc
	cd dmc
	echo $PWD
	cp -v ../../../dmc/bwfn.data.bin . 
	cp -v ../../../dmc/si_pp.data . 
	cp -v ../../../dmc/input .
	cp -v ../../../dmc/correlation.data . 
	cd ..
	echo $PWD
	cd ..
	echo "end:" $dir $PWD
done


for dir in $(seq 1 1 20) ; do
	cd $dir
	cd dmc
	runqmc -T 7h -p 384 --shm=128 --user.queue=medium
	cd ..
	cd vmc 
	runqmc -T 7h -p 640 --shm=128 --user.queue=medium
	cd ..
	cd ..
done  
