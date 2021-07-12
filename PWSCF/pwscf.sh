#!/bin/bash
#SBATCH --account=project_2002888
#SBATCH -J PWSCF
#SBATCH --partition=medium
#SBATCH --nodes=1
#SBATCH --ntasks=128
#SBATCH --time=1:00:00
##SBATCH --ntasks-per-node=32
##SBATCH --cpus-per-task=32

module load gcc
module load openmpi
module load fftw
module load netlib-scalapack
module load openblas

srun /projappl/project_2002888/espresso/bin/pw.x -pw2casino -n 128 < in.pwscf  > out.pwscf

# srun /projappl/project_2002888/espresso/bin/pp.x < in.pp  > out.pp


