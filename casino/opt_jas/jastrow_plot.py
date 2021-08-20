import numpy as np 
import matplotlib.pyplot as plt
import pandas as pd 
import os 

def read_file(path: str) -> np.ndarray:
    return pd.read_csv(
        path,
        header=None,
        skipinitialspace=True,
        sep=' '
    ).to_numpy()


def main():
    file = read_file("jastrow_value_chi_1.dat")
    print(file.shape)
    # print(file[:,0])
    x = file[:,0]
    y = file[:,1]
    print(x[0], y[0])

    plt.figure()
    plt.plot(x,y)
    plt.xlabel('chi_value x')
    plt.ylabel('chi_value y')
    plt.savefig('jastrow_plot.png')
    # https://vallico.net/casino-forum/viewtopic.php?f=4&t=22


if __name__ == "__main__":
    main()
    plt.show()
