### Usage

Scripts for running Pair Correlation functions with the python scripts in `/positron_utils/pcf/`.

First ensure that your directory has your 20x folders each with a `dmc` and `vmc` subfolder and, if necessary `gen_blip`. 

Example input:


`python $HOME/casino_positrons/positron_utils/pcf_fit/plyfit.py --vmcfile gvmc_1.npy --dmcfile gdmc_1.npy --rfile r_1.npy --lat-vec 1 --fit-range x --volume 2.1608567484189534E+03 --max-pol 9 --min-pol 5 --plot 0 --num-e 192 --metal 0 --verbosity 0 --corepart 1` 


- `vmcfile` - Generated via `./script vmc`, with `vmc` as a command line argument. Containes binned positron-electron distances from the 20x vmc runs.
- `dmcfile` - Same as above just with `vmc`. 
- `rfile` - same as above but the `r_1.npy` file.
- `lat-vec` - Still not sure what this does...
- `fit-range` - The fit range for the curve fitting. Use `/positron_utils/pcf/cross_validation.py` to find the fit range with the lowest Mean Square error. 
- `volume` - from the `expval.data`. Volume of the simulation cell.
- `max-pol` - Max polynomial to fit.
- `min-pol` - Min polynomial to fit. 
- `plot` - produce plot of the fits. 1=yes, 0=no. 
- `num-e` - Total number of electrons in the simulation cell.
- `metal` - Is the element a metal or not. Affects the PCF calculation. 
- `verbosity` - How verbose the output is. 
- `corepart` - The ratio of the valence electrons to the core electrons. This core corrects the lifetime from DFT corrections based on core electron contribution. The core electron contribution can be view via `atsup` output file. 



### Sample output


========================================
Polynomial degree: 5
Mean error: 0.01574, Mean squared error: 0.01574
----------------------------------------
PCF        : 0.8879
STD        : 0.0056
----------------------------------------
Lifetime   : 252.1639
STD        : 1.5892
 
========================================
Polynomial degree: 7
Mean error: 0.00759, Mean squared error: 0.00759
----------------------------------------
PCF        : 0.9223
STD        : 0.0072
----------------------------------------
Lifetime   : 242.8561
STD        : 1.8983
 
========================================
Polynomial degree: 9
Mean error: 0.00691, Mean squared error: 0.00691
--> BEST
----------------------------------------
PCF        : 0.9154
STD        : 0.0090
----------------------------------------
Lifetime   : 244.8441
STD        : 2.4192
 
All done.




