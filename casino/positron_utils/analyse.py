import numpy as np
import matplotlib.pyplot as plt
import argparse
import sys

def get_args():
    """Define the task arguments with the default values.                         
    Returns:                                                                      
      experiment parameters                                                     
    """
    
    args_parser = argparse.ArgumentParser()
    
    # Data files arguments                                                        
    args_parser.add_argument(
        '--dft',
        help='Filename of the DFT result.',
        nargs='+',
        type=str,
        default=['acar1d_100_ave']
    )

    args_parser.add_argument(
        '--qmc',
        help='Filename of the qmc result.',
        nargs='+',
	type=str,
        default=['lineplot.dat']
    )

    args_parser.add_argument(
        '--fcore',
        help='Filename of the core electron APMD.',
        type=str,
        default='no'
    )

    args_parser.add_argument(
	'--plotcore',
        help='Plot core spectrum separately.',
	type=int,
	default=-1
    )
    
    args_parser.add_argument(
        '--vnorm',
        help='The valence electron contribution.',
        type=float,
        default=1
    )

    args_parser.add_argument(
        '--fwhm',
        help='Full width at half maximum (keV) of the resolution function, for convolution.',
	type=float,
        default=0.85
    )

    args_parser.add_argument(
        '--convrange',
        help='The width of the convolution window: [-convrange,convrange].ä',
	type=float,
        default=5.0
    )
    
    args_parser.add_argument(
        '--ylog',
        help='Plot in log scale (1) or not (0).',
        type=int,
        default=0
    )


    args_parser.add_argument(
        '--errorplot',
        help='are errors contained in the lineplot.dat-file? 1=yes, 0=no.',
	type=int,
        default=1
    )

    args_parser.add_argument(
        '--angle',
	help='Name of the projection angle.',
        type=str,
        default='?'
    )

    args_parser.add_argument(
        '--srange',
        help='The window for estimating S-parameter, given as a string a,b in eV.',
	type=str,
        default='0.0,0.4'
    )

    args_parser.add_argument(
        '--wrange',
        help='The window for estimating W-parameter, given as a string a,b in eV.',
	type=str,
        default='1.6,2.4'
    )

    args_parser.add_argument(
        '--figname',
        help='If given, the image to be plotted will be saved under this name.',
        type=str,
        default=''
    )
    
    return args_parser.parse_args()

def convolute(x,y,fwhm,convrange):
    # x and y are in range [0,xmax]. Mirror it now to range [-xmax,xmax].
    y2=np.concatenate((np.flip(y),y))
    x2=np.concatenate((-np.flip(x),x))

    # Compute the convolution function
    xx=np.arange(-convrange,convrange,x[1]-x[0])
    if(convrange>np.max(x)):
        sys.exit("Pick a smaller convolution range.")
    sigma=fwhm/2.355
    convf=np.exp(-1.0*(xx**2)/(2*sigma**2))
    
    # Convolve
    convoluted=np.convolve(y2,convf,mode='same')
    
    # Remove the mirror image
    y2=convoluted[-x.shape[0]:]
    
    # Normalize
    area=np.trapz(y2,x)
    y2=y2/area

    return np.array([x,y2])

def load_data(filelist,is_core,vnorm,core_data,sr=0):
    if(is_core and len(core_data)==1 and core_data[0]==0):
        sys.exit("Error: Trying to add core data to projection, but there is none.")
    lp=[]
    for file in filelist:
        data=np.transpose(np.loadtxt(file,skiprows=sr))
        norm=vnorm/np.trapz(data[1,:],x=data[0,:])
        data[1,:]*=norm
        if(data.shape[0]==3):
            data[2,:]*=norm
        if(is_core):
            core=np.interp(data[0,:],core_data[:,0],core_data[:,1])
            data[1,:]+=core
        lp.append(data)
        
    data=np.array(lp)
    return data

def plot_data(args,i,dft,qmc1,qmc2,qmc3,dft_icut,core_data,S1,S2,S3,W1,W2,W3,sa,sb,wa,wb):
    # qmc1= mean value, qmc2=minimum, qmc3=maximum
    ax1=plt.subplot(212)
    ax2 = plt.subplot(221)
    ax3 = plt.subplot(222)
    legends=[]

    for j in range(len(dft)):
        ax1.plot(dft[j][0,:dft_icut],dft[j][1,:dft_icut],'--')
        ax2.plot(dft[j][0,:dft_icut],dft[j][1,:dft_icut],'--')
        ax3.plot(dft[j][0,:dft_icut],dft[j][1,:dft_icut],'--')
        legends.append(args.dft[j])
    ax2.set_xlim([sa,sb])
    ax2.set_ylim([0.9,0.99])
    ax3.set_xlim([wa,wb])
    ax3.set_ylim([0.0,0.1])
    ax1.plot(qmc1[0,:],qmc1[1,:],'-')
    ax2.plot(qmc1[0,:],qmc1[1,:],'-')
    ax3.plot(qmc1[0,:],qmc1[1,:],'-')
    ax1.fill_between(qmc1[0,:],qmc2[1,:],qmc3[1,:],color='gray', alpha=0.2)
    ax2.fill_between(qmc1[0,:],qmc2[1,:],qmc3[1,:],color='gray', alpha=0.2)
    ax3.fill_between(qmc1[0,:],qmc2[1,:],qmc3[1,:],color='gray', alpha=0.2)

    ax2.text(sa+0.05,0.91,"S: {:04.4f} +- {:04.4f}".format(S1,(S2-S3)/2.0),fontsize=12)
    ax3.text(wa+0.1,0.08,"W: {:04.4f} +- {:04.4f}".format(W1,(W2-W3)/2.0),fontsize=12)

    legends.append(args.qmc[i])
    
    if(args.plotcore>0):
        ax1.plot(core_data[:,0],core_data[:,1],'g-.')
        legends.append('Core spectrum')
        
    if(not(args.ylog==0)):
        ax1.yscale('log')
    ax1.grid()
    #ax1.set_title('Diamond pmd data projection to {}'.format(args.angle))
    ax2.set_title("S-parameter area")
    ax3.set_title("W-parameter area")
    
    ax1.set_xlabel('Momentum (a.u.)')
    ax1.legend(legends)
    if(len(args.figname)>0):
        plt.savefig(args.figname, dpi=None, facecolor='w', edgecolor='w',
                    orientation='portrait', format=None,
                    transparent=False, bbox_inches=None, pad_inches=0.1,
                    metadata=None)

def getSW(X,a,b):
    from scipy.integrate import simps

    for i in range(X.shape[1]):
        if(X[0,i]>=a):
            ai=i
            break

    for	i in range(X.shape[1]):
        bi=i
        if(X[0,i]>=b):
            break

        
    return simps(X[1,ai:bi],X[0,ai:bi])
    
def main():

    args=get_args()
    
    # fwhm for convolution, keV transformed to... a.u.
    fwhm=0.54*args.fwhm
    # Range of the convolution, keV, transformed...
    grange=0.54*args.convrange

    # S-parameter window
    tempstr=args.srange.split(',')
    if(len(tempstr)<2 or len(tempstr)>2):
        sys.exit("Error: check the format of the srange-parameter given in command line.")
    sa=float(tempstr[0])
    sb=float(tempstr[1])

    # W-parameter window
    tempstr=args.wrange.split(',')
    if(len(tempstr)<2 or len(tempstr)>2):
        sys.exit("Error: check the format of the wrange-parameter given in command line.")
    wa=float(tempstr[0])
    wb=float(tempstr[1])
    
    
    # The top index up to which dft values in it's array are used
    dft_icut = 400
    
    plot_error=False
    if(args.errorplot==1):
        plot_error=True
    
    is_core=not(args.fcore=='no')
    if(is_core):
        core_data=np.loadtxt(args.fcore,skiprows=1)
    else:
        core_data=np.array((0,))
        
    if(args.plotcore>0):
        if(not(is_core)):
            sys.exit("Required core spectrum plot, but no core file provided.")
        
    dft_data=load_data(args.dft,is_core,args.vnorm,core_data=core_data,sr=2)
    qmc_data=load_data(args.qmc,is_core,args.vnorm,core_data=core_data)

    print(" ")
    print("*** S- and W-parameters for dft projection ***")
    print(" ")
    dftc=[]
    for i in range(len(args.dft)):
        print("- file: {}".format(args.dft[i]))
        dftconv=convolute(dft_data[i,0,:],dft_data[i,1,:],fwhm,grange)
        dftc.append(dftconv)
        print("S: {:04.4f}".format(getSW(dftconv,sa,sb)))
        print("W: {:04.4f}".format(getSW(dftconv,wa,wb)))

    print(" ")
    print("*** S- and W-parameters for qmc projection ***")
    print(" ")
    for i in range(len(args.qmc)):
        qmcconv1=convolute(qmc_data[i,0,:],qmc_data[i,1,:],fwhm,grange)
        qmcconv2=convolute(qmc_data[i,0,:],qmc_data[i,1,:]-qmc_data[i,2,:],fwhm,grange)
        qmcconv3=convolute(qmc_data[i,0,:],qmc_data[i,1,:]+qmc_data[i,2,:],fwhm,grange)
        S1=getSW(qmcconv1,sa,sb)
        S2=getSW(qmcconv2,sa,sb)
        S3=getSW(qmcconv3,sa,sb)
        W1=getSW(qmcconv1,wa,wb)
        W2=getSW(qmcconv2,wa,wb)
        W3=getSW(qmcconv3,wa,wb)
        print("Angle {}: S= {:04.4f} +- {:04.4f}".format(args.angle,S1,(S2-S3)/2.0))
        print("Angle {}: W= {:04.4f} +- {:04.4f}".format(args.angle,W1,(W2-W3)/2.0))
        plot_data(args,i,dftc,qmcconv1,qmcconv2,qmcconv3,dft_icut,core_data,S1,S2,S3,W1,W2,W3,sa,sb,wa,wb)
    print(" ")
    if(len(args.figname)<1):
        plt.show()
    
if __name__ == '__main__':
    main()
