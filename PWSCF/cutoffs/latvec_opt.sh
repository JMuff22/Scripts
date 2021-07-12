#!/bin/bash
#SBATCH --account=project_2002888
#SBATCH -J PWSCF_latvecopt
#SBATCH --partition=medium
#SBATCH --nodes=2
#SBATCH --no-requeue
#SBATCH --ntasks-per-node=8
#SBATCH --ntasks-per-socket=1
#SBATCH --cpus-per-task=16
#SBATCH --time=4:00:00
	
echo "optimising lattice vectors for Si atom"
echo $PWD
echo $(date)
## https://slurm.schedmd.com/faq.html
## How could I automatically print a job's Slurm job ID to its standard output?
if [ X"$SLURM_STEP_ID" = "X" -a X"$SLURM_PROCID" = "X"0 ]
then
  echo "=========================================="
  echo "SLURM_CLUSTER_NAME = $SLURM_CLUSTER_NAME"
  echo "SLURM_CPUS_ON_NODE = $SLURM_CPUS_ON_NODE"
  echo "SLURM_CPUS_PER_TASK = $SLURM_CPUS_PER_TASK"
  echo "SLURM_JOB_PARTITION = $SLURM_JOB_PARTITION"
  echo "SLURM_JOB_QOS = $SLURM_JOB_QOS"
  echo "SLURM_MEM_PER_CPU = $SLURM_MEM_PER_CPU"
  echo "SLURM_MEM_PER_NODE = $SLURM_MEM_PER_NODE"
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

## LAT VEC OPT
# cd /scratch/project_2002888/jakemuff/Si/atom/latvec_opt
# for latvec in $(seq 6 1 10) ; do
#   ## mkdir latvec_$latvec
#   cd latvec_$latvec
#   # cp /scratch/project_2002888/jakemuff/Si/bulk/kpoints_222/pw2casino.dat .
#   # cp /scratch/project_2002888/jakemuff/Si/bulk/kpoints_222/Si.He.ccECP.upf .
#   # cp /scratch/project_2002888/jakemuff/Si/bulk/kpoints_222/in.pp .
#   # cp /scratch/project_2002888/jakemuff/Si/bulk/kpoints_222/si_pp.data .

#   cat > in.pwscf << EOF
# &CONTROL
#    prefix='silicon'
#    restart_mode='from_scratch'
#    calculation='scf'
#    pseudo_dir='./'
#    wf_collect = .true.
#    outdir='./'
#  /
#  &system
#    ibrav=0
#    input_dft='PBE'
#    celldm(1) = 10.261212
#    nat= 1, ntyp= 1,
#    ecutwfc = 800,
#    nosym=.true.
#    noinv=.true.
#    occupations      = 'smearing'
#    smearing         = 'gaussian'
#    degauss          = 0.022
#  /
#  &electrons
#    diagonalization='cg'
#    conv_thr = 1.0d-13
#    mixing_mode='plain'
#    mixing_beta=0.7
#  /
# CELL_PARAMETERS alat
# $latvec 0 0
# 0 $latvec 0
# 0 0 $latvec
# ATOMIC_SPECIES
# Si 28.086 Si.He.ccECP.upf
# ATOMIC_POSITIONS crystal
# Si 0.50 0.50 0.50
# K_POINTS Gamma
# EOF
# cd ..
# done


for i in 6 7 8 9 10
do
    cd latvec_$i
    srun /projappl/project_2002888/espresso/bin/pw.x -pw2casino -n 256 < in.pwscf  > out.pwscf
    # srun /projappl/project_2002888/espresso/bin/pp.x < in.pp > out.pp
    echo $i
    grep '! *total energy' out.pwscf | tail -n 1 | awk -v cutoff_var="$i" '{print cutoff_var" "$5}' >> ../energies.txt
    cd ..
done


