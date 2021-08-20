Instructions for calculating the pair correlation functional and positron lifetimes.

Remember to add `pair_corr_sph: T` in casino input file.

To start with you want 20x DMC and 20x VMC runs with casino with the best statistics possible. You can set this up with the `PCF.sh` in mahti. This script also submits the casino batch files. 

Once all 40 runs are completed:

1. Copy and extract the expvals using `cp_pcf.sh`. This also sets up the analysis directory structures. It should have 20 folders each with a vmc/ and dmc/ sub-dir. Each sub dir should contain the correspoding `expval.data` fiels from completed runs on mahti. 
2. Then to extract information from the `expval.data` files use the `plot_expval` casino utility. Only we script this utility via `script.sh` and `loop.sh` which call another python script `gather_lineplot.py`. This generates the lineplot.data files in each of the directories. 
3. Now calculate positron lifetimes from `plyfit.py`. See below for usage. 










##Usage of scripts

- `PCF.sh`  is submitted as a batch scripts, i.e `sbatch PCF.sh` and it created and copies over the correct files, then submited the casino batch scripts. 

- `cp_pcf.sh` is run from local computer (may need to `chmod +x` it) and it uses `scp` to copy files from the `expval` directories. Much easier with ssh keys set up.

- `script.sh` simply takes command line arguments for `loop.sh` 

- `loop.sh` goes through each directory using command line argument i.e `1/vmc` if `vmc` is given as a command line argument for `script.sh`. It then called the python script `gather_lineplot.py` from the positron utils directory. This produces `gvmc_1.npy` or `gdmc_1.npy` and `r_1.npy`. These are numpy array files and are used in calculating the positron lifetime. 


- `plyfit.py` is a polynomial fitting python script for fitting data from the previous scripts. It has a lot of command line arguments: 
	- `--vmcfile` : this is your `gvmc_*.npy` 
	- `--dmcfile` : this is your `gdmc_*.npy` 
	- `--rfile` : this is your `r_1.npy` file from before. 
	- `--lat-vec`: BOOL. 1 or 0. 
	- `--fit-range` : The fit range of your fit. A Good value is the wigner-seitz cell radius e.g 4.4 for Si. This does require further analysis though...
	- `--volume` :Volume of simulation cell. You can find it in one of the `expval.data` files. 
	- `--max-pol` : The max polynomial to calculate up to. 
	- `--min-pol` : The min polynomial to calculate up to. 
	- `--plot` : Produce a plot via matplot lib or not. 
	- `--num-e`: Total number of electrons in simulation cell. e.g 16 atom silicon with 12 valence electrons = 192 
	- `--metal` : BOOL. If the element is metal or not 
	- `--verbosity` : How verbose the output will be. 
	- `--corepart` : Technically it is the total valence electrons/ total electrons. However, is often approximated e.g 12 valence electrons/ 14 = 0.85... but ~1.00 
	- `--table` : Prints latex table or not. Default -1 --> does not. 




## Example input

```bash
python /home/jakemuff/casino_positrons/positron_utils/pcf_fit/plyfit.py --vmcfile gvmc_1.npy --dmcfile gdmc_1.npy --rfile r_1.npy --lat-vec 1 --fit-range 1.5 --volume 2.1608567484189534E+03 --max-pol 9 --min-pol 5 --plot 0 --num-e 192 --metal 0 --verbosity 0 --corepart 1 
```

## Example output

```bash
========================================
Polynomial degree: 5
Mean error: 0.04754, Mean squared error: 0.04754
--> BEST
----------------------------------------
PCF        : 0.9102
STD        : 0.0265
----------------------------------------
Lifetime   : 250.1818
STD        : 7.6537
 
========================================
Polynomial degree: 7
Mean error: 29.81066, Mean squared error: 29.81066
----------------------------------------
PCF        : 0.9343
STD        : 0.0336
----------------------------------------
Lifetime   : 246.0770
STD        : 9.3481
 
========================================
Polynomial degree: 9
Mean error: 272826060153644242430711186446381009191779498098425856.00000, Mean squared error: 272826060153644242430711186446381009191779498098425856.00000
----------------------------------------
PCF        : 0.9907
STD        : 0.0404
----------------------------------------
Lifetime   : 233.7529
STD        : 9.8700
 
All done.

```