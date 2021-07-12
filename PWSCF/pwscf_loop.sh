#!/bin/bash
#SBATCH --account=project_2002888
#SBATCH -J PWSCF
#SBATCH --partition=medium
#SBATCH --nodes=1
#SBATCH --ntasks=32
#SBATCH --ntasks-per-node=32
#SBATCH --time=2:00:00


module load gcc
module load openmpi
module load fftw
module load netlib-scalapack
module load openblas


for i in 800 840 880 920 960 1000 1040 1080 1120 1160
do
    f=latvec_$i
    cp -r input $f
    cd $f
    sed -i "s/{}/${i}/g" in.pwscf
    srun /projappl/project_2002888/espresso/bin/pw.x -n 32 < in.pwscf  > out.pwscf
    #srun /projappl/project_2002888/espresso/bin/pp.x < in.pp
    cd ..
done

