#!/bin/bash

mkdir opt_u 
mkdir opt_f 
mkdir opt_chi

export UP_ELEC=4  
export DOWN_ELEC=4
export cell='1 1 1'

cat > input << EOF 
#-------------------#
# CASINO input file #
#-------------------#

# Silicon 1x1x1plane wave basis)
# PP: ccECP Silicon w/ Ne core
#

# SYSTEM
neu               : $UP_ELEC             #*! Number of up electrons (Integer)
ned               : $DOWN_ELEC             #*! Number of down electrons (Integer)
periodic          : T              #*! Periodic boundary conditions (Boolean)
atom_basis_type   : blip     #*! Basis set type (Text)
%block npcell
$cell
%endblock npcell
psi_s             : slater         #*! Type of [anti]symmetrizing wfn (Text)
complex_wf        : F              #*! Wave function real or complex (Boolean)

KWARN	: T

# RUN
runtype           : vmc_opt       #*! Type of calculation (Text)
newrun            : T              #*! New run or continue old (Boolean)
testrun           : F              #*! Test run flag (Boolean)
block_time        : 0.0 s          #*! VMC/DMC block time (Physical)

# VMC
vmc_equil_nstep   : 200           #*! Number of equilibration steps (Integer)
vmc_nstep         : 50000           #*! Number of steps (Integer)
vmc_nblock        : 1              #*! Number of checkpoints (Integer)
vmc_nconfig_write : 10000             #*! Number of configs to write (Integer)
#vmc_decorr_period : 10
writeout_vmc_hist : F

# DMC
dmc_equil_nstep   : 2000           #*! Number of steps (Integer)
dmc_equil_nblock  : 1              #*! Number of checkpoints (Integer)
dmc_stats_nstep   : 10000          #*! Number of steps (Integer)
dmc_stats_nblock  : 1              #*! Number of checkpoints (Integer)
dmc_target_weight : 1000.d0        #*! Total target weight in DMC (Real)
dtdmc             : 0.003          #*! DMC time step (Real)
use_tmove         : F              #*! Casula nl pp for DMC (Boolean)

# RMC

# OPTIMIZATION
opt_method        : varmin_linjas         #*! Opt method (varmin/madmin/emin/...)
opt_cycles        : 5              #*! Number of optimization cycles (Integer)
opt_jastrow       : T              #*! Optimize Jastrow factor (Boolean)
opt_det_coeff     : F              #*! Optimize determinant coeffs (Boolean)
opt_backflow      : F              #*! Optimize backflow parameters (Boolean)
opt_orbitals      : F              #*! Optimize orbital parameters (Boolean)
opt_info          : 5              #*! Amount of information from minimization

# GENERAL PARAMETERS
use_jastrow       : T              #*! Use a Jastrow function (Boolean)
backflow          : F              #*! Use backflow corrections (Boolean)
expot             : F              #*! Use external potential (Boolean)
timing_info       : F              #*! Activate subroutine timers (Boolean)
esupercell        : F              #*! Energy/supercell in output (Boolean)
neighprint        : 0              #*! Neighbour analysis (Integer)
mpc_cutoff        : 30.d0 hartree  #*! G vector cutoff for MPC (Physical)
interaction       : ewald          #*! Interaction type (Text)
finite_size_corr  : F              #*! Eval. finite size correction (Boolean)
forces            : F              #*! Evaluate forces on atoms (Boolean)
checkpoint        : 1              #*! Checkpoint level (Integer)
hartree_xc        : F              #*! XC and Hartree if SF or MPC (Boolean)

# EXPECTATION VALUES
density           : F              #*! Accumulate density (Boolean)
spin_density      : F              #*! Accumulate spin densities (Boolean)
pair_corr         : F              #*! Accumulate rec. space PCF (Boolean)
pair_corr_sph     : F              #*! Accumulate sph. real space PCF (Boolean)
loc_tensor        : F              #*! Accumulate localization tensor (Boolean)
structure_factor  : F              #*! Accumulate structure factor (Boolean)
struc_factor_sph  : F              #*! Accumulate sph. struc. factor (Boolean)
onep_density_mat  : F              #*! Accumulate 1p density matrix (Boolean)
twop_density_mat  : F              #*! Accumulate 2p density matrix (Boolean)
cond_fraction     : F              #*! Accumulate cond fraction (Boolean)
twop_dm_mom       : F              #*! Accum 2p momentum density (Boolean)
cond_fraction_mom : F              #*! Accum strict 2p momentum density (Boo...
dipole_moment     : F              #*! Accumulate elec. dipole moment (Boolean)
expval_cutoff     : 30.d0 hartree  #*! G vector cutoff for expval (Physical)
permit_den_symm   : F              #*! Symmetrize QMC charge data (Boolean)
qmc_density_mpc   : F              #*! Use QMC density in MPC int (Boolean)
contact_den       : F


%block plot_expval
2
200 200
0 0 0
10.26 10.26 0
0 10.26 10.26
%endblock plot_expval
# BLOCK INPUT
%block jastrow_plot
1
2
1
%endblock jastrow_plot
EOF


# U TERMS
cd opt_u
touch energies.dat
for dir in $(seq 1 1 6) ; do 
	mkdir $dir
	cd $dir
	cat > correlation.data << EOF 
 START HEADER
 No title given.
 END HEADER
 
 START VERSION
   1
 END VERSION
 
 START JASTROW
 Title
 Optimising Jastrow factor (u term) $PWD $(date)
 Truncation order C
   3
 START U TERM
 Number of sets
   1
 START SET 1
 Spherical harmonic l,m
   0 0
 Expansion order N_u
   4
 Spin dep (0->uu=dd=ud; 1->uu=dd/=ud; 2->uu/=dd/=ud)
   1
 Cutoff (a.u.)     ;  Optimizable (0=NO; 1=YES)
   $dir                0
 Parameter values  ;  Optimizable (0=NO; 1=YES)
 END SET 1
 END U TERM
 START CHI TERM
 Number of sets ; labelling (1->atom in s. cell; 2->atom in p. cell; 3->species)
   1 3
 START SET 1
 Spherical harmonic l,m
   0 0
 Number of species in set
   1
 Label of the species in this set
    1
 Impose electron-nucleus cusp (0=NO; 1=YES)
   0
 Expansion order N_chi
   4
 Spin dep (0->u=d; 1->u/=d)
   1
 Cutoff (a.u.)     ;  Optimizable (0=NO; 1=YES)
   1.00000000000000                0
 Parameter values  ;  Optimizable (0=NO; 1=YES)
 END SET 1
 END CHI TERM
 START F TERM
 Number of sets ; labelling (1->atom in s. cell; 2->atom in p. cell; 3->species)
   1 3
 START SET 1
 Number of species in set
   1
 Label of the species in this set
    1
 Prevent duplication of u term (0=NO; 1=YES)
   0
 Prevent duplication of chi term (0=NO; 1=YES)
   0
 Electron-nucleus expansion order N_f_eN
   2
 Electron-electron expansion order N_f_ee
   2
 Spin dep (0->uu=dd=ud; 1->uu=dd/=ud; 2->uu/=dd/=ud)
   1
 Cutoff (a.u.)     ;  Optimizable (0=NO; 1=YES)
  0.500000000000000                1
 Parameter values  ;  Optimizable (0=NO; 1=YES)
 END SET 1
 END F TERM
 END JASTROW
 
EOF
cd ..
done


# CHI TERM
cd ../opt_chi/
touch energies.dat
for dir in $(seq 1 1 6) ; do 
	mkdir $dir
	cd $dir
	cat > correlation.data << EOF 
 START HEADER
 No title given.
 END HEADER
 
 START VERSION
   1
 END VERSION
 
 START JASTROW
 Title
 Optimising Jastrow factor (chi term) $PWD $(date)
 Truncation order C
   3
 START U TERM
 Number of sets
   1
 START SET 1
 Spherical harmonic l,m
   0 0
 Expansion order N_u
   4
 Spin dep (0->uu=dd=ud; 1->uu=dd/=ud; 2->uu/=dd/=ud)
   1
 Cutoff (a.u.)     ;  Optimizable (0=NO; 1=YES)
   1.0000                0
 Parameter values  ;  Optimizable (0=NO; 1=YES)
 END SET 1
 END U TERM
 START CHI TERM
 Number of sets ; labelling (1->atom in s. cell; 2->atom in p. cell; 3->species)
   1 3
 START SET 1
 Spherical harmonic l,m
   0 0
 Number of species in set
   1
 Label of the species in this set
    1
 Impose electron-nucleus cusp (0=NO; 1=YES)
   0
 Expansion order N_chi
   4
 Spin dep (0->u=d; 1->u/=d)
   1
 Cutoff (a.u.)     ;  Optimizable (0=NO; 1=YES)
   $dir                0
 Parameter values  ;  Optimizable (0=NO; 1=YES)
 END SET 1
 END CHI TERM
 START F TERM
 Number of sets ; labelling (1->atom in s. cell; 2->atom in p. cell; 3->species)
   1 3
 START SET 1
 Number of species in set
   1
 Label of the species in this set
    1
 Prevent duplication of u term (0=NO; 1=YES)
   0
 Prevent duplication of chi term (0=NO; 1=YES)
   0
 Electron-nucleus expansion order N_f_eN
   2
 Electron-electron expansion order N_f_ee
   2
 Spin dep (0->uu=dd=ud; 1->uu=dd/=ud; 2->uu/=dd/=ud)
   1
 Cutoff (a.u.)     ;  Optimizable (0=NO; 1=YES)
  0.500000000000000                1
 Parameter values  ;  Optimizable (0=NO; 1=YES)
 END SET 1
 END F TERM
 END JASTROW
 
EOF
cd ..
done

cd ../opt_f/
touch energies.dat
for dir in $(seq 0.5 0.5 3) ; do 
	mkdir $dir
	cd $dir
	cat > correlation.data << EOF 
 START HEADER
 No title given.
 END HEADER
 
 START VERSION
   1
 END VERSION
 
 START JASTROW
 Title
 Optimising Jastrow factor (f term) $PWD $(date)
 Truncation order C
   3
 START U TERM
 Number of sets
   1
 START SET 1
 Spherical harmonic l,m
   0 0
 Expansion order N_u
   4
 Spin dep (0->uu=dd=ud; 1->uu=dd/=ud; 2->uu/=dd/=ud)
   1
 Cutoff (a.u.)     ;  Optimizable (0=NO; 1=YES)
   1.0000                0
 Parameter values  ;  Optimizable (0=NO; 1=YES)
 END SET 1
 END U TERM
 START CHI TERM
 Number of sets ; labelling (1->atom in s. cell; 2->atom in p. cell; 3->species)
   1 3
 START SET 1
 Spherical harmonic l,m
   0 0
 Number of species in set
   1
 Label of the species in this set
    1
 Impose electron-nucleus cusp (0=NO; 1=YES)
   0
 Expansion order N_chi
   4
 Spin dep (0->u=d; 1->u/=d)
   1
 Cutoff (a.u.)     ;  Optimizable (0=NO; 1=YES)
   1.00000000000000                0
 Parameter values  ;  Optimizable (0=NO; 1=YES)
 END SET 1
 END CHI TERM
 START F TERM
 Number of sets ; labelling (1->atom in s. cell; 2->atom in p. cell; 3->species)
   1 3
 START SET 1
 Number of species in set
   1
 Label of the species in this set
    1
 Prevent duplication of u term (0=NO; 1=YES)
   0
 Prevent duplication of chi term (0=NO; 1=YES)
   0
 Electron-nucleus expansion order N_f_eN
   2
 Electron-electron expansion order N_f_ee
   2
 Spin dep (0->uu=dd=ud; 1->uu=dd/=ud; 2->uu/=dd/=ud)
   1
 Cutoff (a.u.)     ;  Optimizable (0=NO; 1=YES)
  $dir                1
 Parameter values  ;  Optimizable (0=NO; 1=YES)
 END SET 1
 END F TERM
 END JASTROW
 
EOF
cd ..
done
echo $PWD
cd ../
echo $PWD

for dir in $(seq 1 1 6) ; do
	cp -v ../gen_blip/si_pp.data opt_u/$dir/
	cp -v ../gen_blip/bwfn.data.bin opt_u/$dir/
	cp -v input opt_u/$dir/
	cp -v ../gen_blip/si_pp.data opt_chi/$dir/
	cp -v ../gen_blip/bwfn.data.bin opt_chi/$dir/
	cp -v input opt_chi/$dir/
done

for dir in $(seq 0.5 0.5 3) ; do
	cp -v ../gen_blip/si_pp.data opt_f/$dir/
	cp -v ../gen_blip/bwfn.data.bin opt_f/$dir/
	cp -v input opt_f/$dir/
done


