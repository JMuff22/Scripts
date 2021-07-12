#!/usr/bin/bash
rm energies.txt
for cutoff in 700 1000 ; do
cat > scf.$cutoff.in << EOF
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
   input_dft='HF'
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
   conv_thr = 1.0d-14
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
/home/jakemuff/q-e-qe-6.1.0/bin/pw.x -pw2casino < scf.$cutoff.in > scf.$cutoff.out
# echo $cutoff >> energies.txt
# grep '!!' scf.$cutoff.out >> energies.txt
echo $cutoff
grep '!* *total energy' scf.$cutoff.out | tail -n 1 | awk -v cutoff_var="$cutoff" '{print cutoff_var" "$5}' >> energies.txt
done
