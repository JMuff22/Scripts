import numpy as np
import sys
import argparse

def get_args():

  args_parser = argparse.ArgumentParser()

  args_parser.add_argument(
    '--fsymmat',
    help='File containing sytmmetry matrices..',
    type=str,
    default='SYMMAT.txt'
  )

  args_parser.add_argument(
    '--fktot',
    help='File containing the total BZ.',
    type=str,
    default='fktot.txt'
  )

  args_parser.add_argument(
    '--fred',
    help='File containing the reduced BZ.',
    type=str,
    default='fred.txt'
  )

  return args_parser.parse_args()

def parse_symmat(file):
    symmat=[]
    with open(file) as f:
        lines=f.readlines()
        for i in range(len(lines)):
            if(lines[i][1:12]=="cart.    s("):
              mat=np.zeros((3,3))
              for j in range(3): # Row index
                words=lines[i+j].split()
                if(j==0):
                  if(len(words)>9): # Check if fractions present 
                    fraction=True
                  else:
                    fraction=False
                if(fraction):
                  f=float(words[-2])
                else:
                  f=1.0
                for k in range(3): # Column index
                  if(j==0):
                    if(len(symmat)<9):
                      mat[j,k]=f*float(words[5+k])
                    else:
                      mat[j,k]=f*float(words[4+k])
                  else:
                    mat[j,k]=f*float(words[1+k])
              symmat.append(mat)

    return symmat

def parse_kpoints(file):
  kvecs=[]
  with open(file) as f:
        lines=f.readlines()
        for i in range(len(lines)):
          words=lines[i].split()
          if(len(words)>0 and words[0]=="k("):
            vec=np.zeros((4,))
            for j in range(3):
              vec[j]=float(words[4+j][:6])
            vec[3]=float(words[9])
            kvecs.append(vec)
  return np.array(kvecs)

def main():

    args=get_args()

    symmat=parse_symmat(args.fsymmat)
    ktot=parse_kpoints(args.fktot)
    kred=parse_kpoints(args.fred)
    
    #print(kred.shape)

    #sys.exit("------")

    aa=np.zeros((kred.shape[0],))
    for i in range(ktot.shape[0]):
      ogvec=ktot[i,:]
      print("\nVector {}: ({}, {}, {}), w={}".format(i+1,ogvec[0],ogvec[1],ogvec[2],ogvec[3]))
      for j in range(0,kred.shape[0]):
        redvec=kred[j,:]
        for iim in range(len(symmat)):
          im=symmat[iim]
          newvec=np.matmul(im,redvec[:3])
          if(np.linalg.norm(newvec-ogvec[:3])<0.000001):
            aa[j]+=1
            print("   *   symmat {}, redvec {}  :   ({}, {}, {}), w={}".format(iim+1,j+1,redvec[0],redvec[1],redvec[2],redvec[3]))
            break

    print(aa)

if __name__=='__main__':
    main()
