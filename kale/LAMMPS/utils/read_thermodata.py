#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jun  3 13:03:46 2021

Read LAMMPS thermo data into a Python dictionary.

@author: aakurone
"""
import numpy as np
import matplotlib.pyplot as plt



def read_thermodata(fn):
    """  
    Read in LAMMPS log file 'fn' and pick the data on lines starting with
    string 'ec'. Returns a dictionary with keys obtained from LAMMPS thermo
    header line and values as the corresponding thermo data on 'ec' lines..
    
    Assumes that the first data column is 'Step'.
    """
    
    # Count the 'ec' lines
    nl=0
    first_ec=True
    with open(fn,mode='r') as f:
        for line in f:
            if line[0:4]=='Step':
                header=line
            if line[0:2]=='ec':
                nl+=1
                if first_ec:
                    ecline=line
    
    # Read the data into a numpy array
    nf=len(ecline.split())-1
    thdata=np.zeros(shape=(nl,nf))
    header=header[:-1]
    
    nl=0
    with open(fn,mode='r') as f:
        for line in f:
            if line[0:2]=='ec':
                thdata[nl,:]=[float(s) for s in line[2:-1].split()]
                nl+=1

    thd=dict([(k,thdata[:,i]) for i,k in enumerate(header.split())])
    return thd

if __name__=='__main__':
    d=read_thermodata('case1/case1.log')
    print(d.keys())
    plt.plot(d['Step'],d['Temp'])
    plt.xlabel('Time step')
    plt.ylabel('Temperature (K)')
