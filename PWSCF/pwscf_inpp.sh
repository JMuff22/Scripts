#!/bin/bash
#SBATCH --account=project_2002888
#SBATCH -J PWSCF_inpp
#SBATCH --partition=test
#SBATCH --nodes=1
#SBATCH --ntasks=32
#SBATCH --time=1:00:00
##SBATCH --ntasks-per-node=32
##SBATCH --cpus-per-task=32


echo "PWSCF POST PROCESSING"
echo $USER
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
module purge
module load gcc
module load openmpi
module load fftw
module load netlib-scalapack
module load openblas

# export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
# export KMP_AFFINITY=compact,granularity=fine,1

srun /projappl/project_2002888/espresso/bin/pp.x  < in.pp  > out.pp
