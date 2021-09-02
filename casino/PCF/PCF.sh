!/bin/bash
SBATCH --account=project_2002888
SBATCH -J PCF.sh
SBATCH --partition=medium
SBATCH --nodes=1
SBATCH --ntasks=128
SBATCH --time=1:00:00
#SBATCH --ntasks-per-node=32
#SBATCH --cpus-per-task=32


mkdir -v PCF
cd PCF
# echo "Start: " $PWD
for dir in $(seq 1 1 8) ; do
	echo "Start:" $dir $PWD
	mkdir $dir
	cd $dir
	echo $PWD
	mkdir gen_blip
	cd gen_blip
	cp -v ../../../gen_blip/input .
	cp -v ../../../gen_blip/si_pp.data .
	cp -v ../../../gen_blip/correlation.data .
	# scp -i ~/.ssh/id_rsa_2 jakemuff@puhti.csc.fi://scratch/project_2002888/jakemuff/Si/twists/pwfn.data.$dir pwfn.data
	clearup -f
	runqmc -T 1h -p 12 --ppn=12 --shm=12 --user.queue=medium
	cd ..
	cd ..
done


cd PCF_2
for dir in $(seq 1 1 8) ; do
	echo "Start:" $dir $PWD
	mkdir $dir
	cd $dir
	# mkdir vmc
	# cd vmc
	# echo $PWD
	# # cp -v ../../../vmc/bwfn.data.bin . 
	# cp -v ../../../vmc/si_pp.data . 
	# cp -v ../../../vmc/input .
	# cp -v ../../../vmc/correlation.data .
	# cp -v ../gen_blip/bwfn.data.bin .
	# cd ..  
	mkdir dmc
	cd dmc
	echo $PWD
	# cp -v ../../../dmc/bwfn.data.bin . 
	cp -v ../../../dmc/si_pp.data . 
	cp -v ../../../dmc/input2 input
	cp -v ../../../dmc/correlation.data .
	cp -v ../../../PCF_1/$dir/gen_blip/bwfn.data.bin .
	cd ..
	echo $PWD
	cd ..
	echo "end:" $dir $PWD
done

cd PCF_2
for dir in $(seq 1 1 8) ; do
	cd $dir
	cd dmc
	runqmc -T 36h -p 512 --shm=64 --user.queue=medium --auto-continue
	cd ..
	cd vmc
	clearup -f 
	runqmc -T 36h -p 640 --shm=64 --user.queue=medium
	cd ..
	cd ..
done  
