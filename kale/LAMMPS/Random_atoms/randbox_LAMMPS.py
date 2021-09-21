#*****************************************************
#
#   Create a starting xyz configuration for N atoms
#   in a cube with side length of L. Overlapping of
#   atoms is rejected with minimum distance of rc.
#
#   Run: python randbox.py N L rc > output.xyz
#
#   Roope Halonen 14 Sep 2017 (original version)
#   Valtteri Tikkanen 13 Sep 2021 (modified for LAMMPS)
#*****************************************************

import numpy as np
import sys
N=int(sys.argv[1]) # Number of atoms
L=float(sys.argv[2]) # Box size
rc2=np.power(float(sys.argv[3]),2) # Hotspot criterion
atype='1' # atom type name
print('LAMMPS data file \n')
print(str(N)+ ' atoms') # Write number of atoms
print('1 atom types \n') # Write number of atom types
print(str(-L/2.0)+' '+str(L/2.0)+' '+'xlo xhi') #Write box vectors
print(str(-L/2.0)+' '+str(L/2.0)+' '+'ylo yhi')
print(str(-L/2.0)+' '+str(L/2.0)+' '+'zlo zhi \n')
print('Masses \n')
print(atype+' '+str(39.948)+ '\n') # Write atom mass
print('Atoms \n')

i=1
r=[L*(np.random.rand(3)-0.5)] # first coordinates
print(str(i)+' '+atype+ ' '+str(r[0][0])+' '+str(r[0][1])+' '+str(r[0][2]))
while(i<N):
    new=L*(np.random.rand(3)-0.5) # new random coordinates
    for j in range(0,i):
        xij=new[0]-r[j][0]-L*round((new[0]-r[j][0])/L) #distance in x direction with minimum image correction
        yij=new[1]-r[j][1]-L*round((new[1]-r[j][1])/L) 
        zij=new[2]-r[j][2]-L*round((new[2]-r[j][2])/L)
        d2=xij*xij+yij*yij+zij*zij # distance between atoms squared
        if d2<rc2: # if distance is less than criterion reject the coordinates
            break
        elif j==i-1:
            r.append(new) # if all atoms are far enough accept the coordinates
            print(str(i+1)+' '+atype+ ' '+str(r[i][0])+' '+str(r[i][1])+' '+str(r[i][2]))
            i=i+1 #move on
            
