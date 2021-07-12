#!/bin/bash -l
## An example batch job for QUANTUM ESPRESSO
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
module purge
export PATH=/appl/spack/v014/install-tree/gcc-4.8.5/gcc-7.4.0-lqxq3g/bin:$PATH
export LD_LIBRARY_PATH=/appl/spack/v014/install-tree/gcc-4.8.5/gcc-7.4.0-lqxq3g/lib64:$LD_LIBRARY_PATH
source /appl/opt/cluster_studio_xe2019/compilers_and_libraries_2019.4.243/linux/bin/compilervars.sh intel64
source /appl/opt/cluster_studio_xe2019/compilers_and_libraries_2019.4.243/linux/mkl/bin/mklvars.sh intel64
source /appl/opt/cluster_studio_xe2019/compilers_and_libraries_2020.2.254/linux/mpi/intel64/bin/mpivars.sh
export PATH=/appl/soft/chem/qe/6.5/q-e-qe-6.5/bin:/appl/soft/chem/qe/6.5/q-e-qe-6.5/WANT/bin:/appl/soft/chem/qe/6.5/YAMBO/yambo-4.5.0/bin:$PATH
#
export SLURM_MPI_TYPE=pmi2
export MKL_DEBUG_CPU_TYPE=5
export KMP_AFFINITY=compact,granularity=fine,1
export I_MPI_PIN_DOMAIN=auto
export I_MPI_PIN_ORDER=bunch
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
#
srun pw.x -i Si.sample.in > Si.${SLURM_JOB_ID}.out 

