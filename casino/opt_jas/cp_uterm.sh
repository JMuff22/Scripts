#!/bin/bash

# CHI TERM
cd opt_chi/
for dir in $(seq 1 1 6) ; do
	cd $dir
	echo $PWD
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
   3.00000000000000                0
 Parameter values  ;  Optimizable (0=NO; 1=YES)
  1.114124544031759E-002           1       ! alpha_0,1
  5.705033167376579E-003           1       ! alpha_2,1
 -5.199762553647291E-003           1       ! alpha_3,1
  2.086359941943532E-003           1       ! alpha_4,1
  2.018890953940271E-002           1       ! alpha_0,2
  4.869635869899279E-003           1       ! alpha_2,2
 -3.576789145980472E-003           1       ! alpha_3,2
  1.640325825435510E-003           1       ! alpha_4,2
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