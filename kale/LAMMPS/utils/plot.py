#!/usr/local/Anaconda3/bin/python
import matplotlib.pyplot as plt
import numpy as np
import sys

fn=sys.argv[1]

x,y = np.loadtxt(fn, usecols=(0,1), unpack=True)

plt.plot(x,y,'b')

print('Average = '+str(np.mean(y)))

if len(sys.argv)>2:
    plt.xlabel(sys.argv[2])
    plt.ylabel(sys.argv[3])

plt.show(block=False)
input("Press enter to close")
plt.close()
