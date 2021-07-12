#!/bin/bash
#SBATCH --account=project_2002888
#SBATCH -J PWSCF_copt
#SBATCH --partition=medium
#SBATCH --nodes=1
##SBATCH --ntasks=128
#SBATCH --time=4:00:00
#SBATCH --ntasks-per-node=128
##SBATCH --cpus-per-task=128

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

module load gcc
module load openmpi
module load fftw
module load netlib-scalapack
module load openblas

## LAT VEC OPT
cd /scratch/project_2002888/jakemuff/Si/atom/cutoff_opt
for cutoff in $(seq 600 100 1000) ; do
  mkdir cutoff_$cutoff
  cd cutoff_$cutoff
  cp /scratch/project_2002888/jakemuff/Si/bulk/kpoints_222/pw2casino.dat .
  cp /scratch/project_2002888/jakemuff/Si/bulk/kpoints_222/Si.He.ccECP.upf .
  cp /scratch/project_2002888/jakemuff/Si/bulk/kpoints_222/in.pp .
  cp /scratch/project_2002888/jakemuff/Si/bulk/kpoints_222/si_pp.data .

  cat > in.pwscf << EOF
&CONTROL
   prefix='silicon'
   restart_mode='from_scratch'
   calculation='scf'
   pseudo_dir='./'
   wf_collect = .true.
   outdir='./'
 /
 &system
   ibrav=0
   input_dft='PBE'
   celldm(1) = 10.261212
   nat= 1, ntyp= 1,
   ecutwfc = $cutoff,
   nosym=.true.
   noinv=.true.
   occupations      = 'smearing'
   smearing         = 'gaussian'
   degauss          = 0.022
 /
 &electrons
   diagonalization='cg'
   conv_thr = 1.0d-13
   mixing_mode='plain'
   mixing_beta=0.7
 /
CELL_PARAMETERS alat
5 0 0
0 5 0
0 0 5
ATOMIC_SPECIES
Si 28.086 Si.He.ccECP.upf
ATOMIC_POSITIONS crystal
Si 0.50 0.50 0.50
K_POINTS Gamma
EOF
cd ..
done


for i in 600 700 800 900 1000
do
    cd cutoff_$i
    srun /projappl/project_2002888/espresso/bin/pw.x -pw2casino -n 128 < in.pwscf  > out.pwscf
    # srun /projappl/project_2002888/espresso/bin/pp.x < in.pp
    echo "cutoff=" $i
    grep '! *total energy' out.pwscf | tail -n 1 | awk -v cutoff_var="$i" '{print cutoff_var" "$5}' >> ../energies.txt
    cd ..
done

