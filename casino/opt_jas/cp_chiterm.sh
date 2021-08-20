#!/bin/bash

# F TERM
cd opt_f/
for dir in $(seq 0.5 0.5 3) ; do
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
   3.00000000000000                0
 Parameter values  ;  Optimizable (0=NO; 1=YES)
  1.095272966474611E-002           1       ! alpha_0,1
  4.046466176844927E-003           1       ! alpha_2,1
 -2.907694647692557E-003           1       ! alpha_3,1
  1.200574030186677E-003           1       ! alpha_4,1
  1.969425558934070E-002           1       ! alpha_0,2
  3.950966314827489E-003           1       ! alpha_2,2
 -2.305862818519734E-003           1       ! alpha_3,2
  1.199490162084715E-003           1       ! alpha_4,2
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
   2.00000000000000                0
 Parameter values  ;  Optimizable (0=NO; 1=YES)
  1.513617642265328E-002           1       ! beta_0,1,1
 -2.380723262364061E-002           1       ! beta_2,1,1
  2.407244940892380E-002           1       ! beta_3,1,1
 -2.751244882669937E-003           1       ! beta_4,1,1
  1.938980998652370E-002           1       ! beta_0,2,1
 -3.342530592819039E-002           1       ! beta_2,2,1
  1.708970259194147E-002           1       ! beta_3,2,1
  3.150685040939947E-003           1       ! beta_4,2,1
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