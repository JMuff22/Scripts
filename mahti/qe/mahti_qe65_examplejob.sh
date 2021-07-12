#!/bin/bash -l
## An example batch job for QUANTUM ESPRESSO
## Will use 8 MPI processes per compute node
## and 16 OpenMP threads per 1 MPI process.
#SBATCH -J Si5.4_2
#SBATCH -o Si5.4_2_%j.out
#SBATCH -e Si5.4_2_%j.err
#SBATCH -t 00:01:00
##
## ADD your own project id
#SBATCH --account=project_2001659
##
#SBATCH --ntasks-per-node=8
#SBATCH --ntasks-per-socket=1
#SBATCH --cpus-per-task=16
## how many nodes (maximum is 2 in the test partition)?
#SBATCH -N 2
#SBATCH --no-requeue
## in real jobs use ( #SBATCH --partition=medium ) for jobs that will use 1-20 compute nodes
#SBATCH --partition=test
#
# Do not change next two lines (module lines)
module purge
module load qe/6.5.0
#
# Thread variables
export KMP_AFFINITY=compact,granularity=fine,1
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
#
# Run the the job
srun pw.x -i Si.sample.in > Si.${SLURM_JOB_ID}.out 
