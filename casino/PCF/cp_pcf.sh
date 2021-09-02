
cd /home/jakemuff/Documents/Runs/Si/He_core_ccECP-positron/PCF/dmc
echo "Switch to " $PWD

for dir in $(seq 1 1 20) ; do
	scp jakemuff@mahti.csc.fi://scratch/project_2002888/jakemuff/Si/He_blips_tests/xmul_1/2x2x2/variance_tests/2/positron/pos_lifetime/PCF/$dir/dmc/expval.data expval.data$dir
done 


cd /home/jakemuff/Documents/Runs/Si/He_core_ccECP-positron/PCF/vmc
echo "Switch to " $PWD

for dir in $(seq 1 1 20) ; do
	scp jakemuff@mahti.csc.fi://scratch/project_2002888/jakemuff/Si/He_blips_tests/xmul_1/2x2x2/variance_tests/2/positron/pos_lifetime/PCF/$dir/vmc/expval.data expval.data$dir
done 

echo "------DONE-----"