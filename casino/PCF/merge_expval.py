import argparse
import sys
import numpy as np

def get_args():
  """Define the task arguments with the default values.                         
  Returns:                                                                      
      experiment parameters                                                     
  """

  args_parser = argparse.ArgumentParser()

  # Data files arguments                                                        
  args_parser.add_argument(
    '--files',
    help='Filenames.',
    nargs='+',
    type=str,
    default=['expval.data1','expval.data2']
  )

  return args_parser.parse_args()

def sort_expval_files(l):
  d=[]

  for f in l:
    ind=f.find('expval.data')
    if(ind==-1):
      sys.exit("Filenames are not including the string 'expval.data'.")
    d.append(int(f[ind+11:]))


  d=np.array(d)
  perm=np.argsort(d)

  newl=[]
  for i in range(d.shape[0]):
    newl.append(l[perm[i]])

  return newl

def main():
    
    def _read_expval(filename):
        gvec=[]
        pmd=[]
        pmd_sqr=[]
        with open(filename) as f:
            read_pmd2=False
            lines=f.readlines()
            for i in range(len(lines)):
                if lines[i][:39]=='START POSITRON MOMENTUM DENSITY SQUARED':
                    read_pmd2=True
                if lines[i][:19]=='Number of G-vectors':
                    Ng=int(lines[i+1])
                if lines[i][:19] == 'G-vector components':
                    for j in range(1,Ng+1):
                        components=lines[i+j].split()   
                        vec=[]
                        vec.append(float(components[0]))
                        vec.append(float(components[1]))
                        vec.append(float(components[2]))
                        gvec.append(np.array(vec))           
                if ((lines[i][:17] == 'APMD coefficients')):
                    if(read_pmd2): # Read the squared component array
                        for j in range(1,Ng+1):
                            components=lines[i+j].split()   
                            vec=[]
                            vec.append(float(components[0]))
                            vec.append(float(components[1]))
                            pmd_sqr.append(np.array(vec))
                    else: # Read the non-squared mom den
                        for j in range(1,Ng+1):
                            components=lines[i+j].split()   
                            vec=[]
                            vec.append(float(components[0]))
                            vec.append(float(components[1]))
                            pmd.append(np.array(vec))
    
        return Ng,np.array(gvec),np.array(pmd),np.array(pmd_sqr)
    
    def _read_twists(filename='k_offsets'):
        twists=[]
        with open(filename) as f:
            lines=f.readlines()
            Nconf=int(lines[0])
            for line in lines[1:]:
                words=line.split()
                vec=np.array([float(words[0]),float(words[1]),float(words[2])])
                twists.append(vec)

        return Nconf,twists                
    
    def _merge_expvals(files,file_to):
        Ng,gvec,pmd,pmd_sqr=_read_expval(files[0])
        Ng0=Ng
        Nconf,twists=_read_twists()
        i=1
        for file in files[1:]:
            Ng2,gvec2,pmd2,pmd_sqr_2=_read_expval(file)
            gvec2=gvec2+twists[i]; i+=1
            Ng=Ng+Ng2
            gvec=np.concatenate((gvec,gvec2))
            pmd=np.concatenate((pmd,pmd2))
            pmd_sqr=np.concatenate((pmd_sqr,pmd_sqr_2))

            
        with open(files[0]) as f:
            lines=f.readlines()
        
        with open(file_to,'w') as f:
            write_line=True
            i=0
            write_pmd_sqr=False
            while(write_line):
                
                if lines[i][:29] == 'END POSITRON MOMENTUM DENSITY':
                    write_pmd_sqr=True
                if lines[i][:19]=='G-vector components':
                    f.write(lines[i]); i+=1
                    for j in range(Ng):
                        if j<Ng0:
                            i+=1 
                        f.write(str(gvec[j,0])+" "+str(gvec[j,1])+" "+str(gvec[j,2])+'\n')
                    
                elif((lines[i][:17] == 'APMD coefficients')):
                    if(write_pmd_sqr):  # Write squared momentum density    
                        f.write(lines[i]); i+=1
                        for j in range(Ng):
                            if j<Ng0:
                                i+=1
                            f.write(str(pmd_sqr[j,0])+" "+str(pmd_sqr[j,1])+'\n')
                        
                    else: # Non-squared
                        f.write(lines[i]); i+=1
                        for j in range(Ng):
                            if j<Ng0:
                                i+=1
                            f.write(str(pmd[j,0])+" "+str(pmd[j,1])+'\n')
                        
                elif(lines[i][:19]=='Number of G-vectors'):
                    f.write(lines[i]); i+=1
                    f.write(str(Ng)+'\n');  i+=1
                elif(lines[i][:10]=='END EXPVAL'): # Terminate
                    f.write(lines[i])
                    write_line=False
                else:
                    f.write(lines[i]); i+=1
                
                
    args=get_args()
    
    if len(args.files)<2:
        sys.exit("Error: Less than 2 files to merge found.")
    
    for file in args.files:
      if file[:11] != "expval.data":
        sys.exit("Wrong filenames provided: "+file)
    files=sort_expval_files(args.files)
    _merge_expvals(files,'expval.data')

if __name__ == '__main__':
    main()
