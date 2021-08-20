!#/bin/bash


for dir in $(seq 1 1 20) ; do
	mkdir $dir
	cd $dir
	mkdir dmc
	cd dmc
	scp jakemuff@mahti.csc.fi://scratch/project_2002888/jakemuff/Si/He_blips_tests/xmul_1/2x2x2/variance_tests/2/positron/pos_lifetime/PCF/$dir/dmc/expval.data expval.data
	# scp jakemuff@mahti.csc.fi://scratch/project_2002888/jakemuff/Si/He_blips_tests/xmul_1/2x2x2/variance_tests/2/positron/pos_lifetime/PCF/$dir/dmc/expval.data expval.data
	cd ..
	cd ..
done 


for dir in $(seq 1 1 20) ; do
	mkdir $dir
	cd $dir
	mkdir vmc
	cd vmc
	scp jakemuff@mahti.csc.fi://scratch/project_2002888/jakemuff/Si/He_blips_tests/xmul_1/2x2x2/variance_tests/2/positron/pos_lifetime/PCF/$dir/vmc/expval.data expval.data
	cd ..
	cd ..
done 

echo "------DONE-----"