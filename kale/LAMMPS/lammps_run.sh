#!/bin/bash
#SBATCH --job-name=lammps
##SBATCH -o result-%j.out
#SBATCH -p medium
#SBATCH --nodes=1
#SBATCH -t 10:00:00
#SBATCH --ntasks-per-node=64

export BIN_DIR=/proj/jakemuff/lammps/build/bin/bin
export OMP_NUM_THREADS=64

module load fgci-common
module load openmpi

INPUT=$1
# OUTPUT=$2

mpirun -np ${SLURM_NTASKS} $BIN_DIR/lmp -in ${INPUT}

