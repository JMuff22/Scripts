#!/bin/bash
#SBATCH --account=project_2002888
#SBATCH -J PWSCF_copt
#SBATCH --partition=medium
#SBATCH --nodes=1
##SBATCH --ntasks=128
#SBATCH --time=4:00:00
#SBATCH --ntasks-per-node=128

echo "optimising cutoffs for Si atom"
echo $PWD
echo $(date)

## https://slurm.schedmd.com/faq.html
## How could I automatically print a job's Slurm job ID to its standard output?
if [ X"$SLURM_STEP_ID" = "X" -a X"$SLURM_PROCID" = "X"0 ]
then
  echo "=========================================="
  echo "SLURM_JOB_ID = $SLURM_JOB_ID"
  echo "SLURM_JOB_NODELIST = $SLURM_JOB_NODELIST"
  echo "SLURM_SUBMIT_DIR = $SLURM_SUBMIT_DIR"
  echo "SLURM_JOB_NAME = $SLURM_JOB_NAME"
  echo "=========================================="
fi
echo "Loading Modules..."
module load gcc
module load openmpi
module load fftw
module load netlib-scalapack
module load openblas

cd cutoff_opt
for cutoff in $(seq 100 100 1000) ; do
  mkdir cutoff_$cutoff
  cd cutoff_$cutoff
  cp -v ../../inputs/pw2casino.dat .
  cp -v ../../inputs/si.upf .
  cp -v ../../inputs/in.pp .
  # cp -v ../../inputs/si_pp.data .

  cat > in.pwscf << EOF
&CONTROL
   prefix="si"
   restart_mode="from_scratch"
   calculation='scf'
   tstress=.true.
   tprnfor=.true.
   pseudo_dir="./"
   outdir="./"
 /
 &system
   input_dft='PBE'
   ibrav=0
   celldm(1) = 10.2625,
   nat= 2, ntyp= 1,
   ecutwfc = $cutoff,
   !ecutrho=720
   nosym=.true.
   noinv=.true.
/
 &electrons
   diagonalization='cg'
   conv_thr = 1.0d-8
   mixing_mode='plain'
   mixing_beta=0.7
/
CELL_PARAMETERS alat
0.5 0.5 0.0
0.0 0.5 0.5
0.5 0.0 0.5
ATOMIC_SPECIES
Si 28.0855 si.upf
ATOMIC_POSITIONS crystal
Si 0.00 0.00 0.00
Si 0.25 0.25 0.25
K_POINTS gamma
EOF
cd ..
done


for i in $(seq 100 100 1000)
do
    cd cutoff_$i
    srun /projappl/project_2002888/espresso/bin/pw.x -pw2casino -n 128 < in.pwscf  > out.pwscf
    # srun /projappl/project_2002888/espresso/bin/pp.x < in.pp
    echo "cutoff=" $i
    grep '! *total energy' out.pwscf | tail -n 1 | awk -v cutoff_var="$i" '{print cutoff_var" "$5}' >> ../energies.txt
    cd ..
done