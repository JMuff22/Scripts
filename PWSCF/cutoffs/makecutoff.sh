#!/bin/bash
cd /scratch/project_2002888/jakemuff/Si/cutoffs
for cutoff in $(seq 300 100 3000) ; do
  mkdir $cutoff
  cd $cutoff
  cp /scratch/project_2002888/jakemuff/Si/kpoints_222/pw2casino.dat .
  cp /scratch/project_2002888/jakemuff/Si/kpoints_222/Si.He.ccECP.upf .
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
   conv_thr = 1.0d-12
   mixing_mode='plain'
   mixing_beta=0.7
/
CELL_PARAMETERS alat
0.5 0.5 0.0
0.0 0.5 0.5
0.5 0.0 0.5
ATOMIC_SPECIES
Si 28.0855 Si.He.ccECP.upf
ATOMIC_POSITIONS alat 
Si 0.00 0.00 0.00
Si 0.25 0.25 0.25
K_POINTS automatic
2 2 2 0 0 0
EOF
cd ..
done
