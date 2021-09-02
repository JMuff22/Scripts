### Using Twist-Averaging with CASINO

First gather a symmterical k point grid for your twists by running a quick `in.pwscf` with low cutoff and low convergence. We are using this to just generate our symmetric k points. Then use `extract_kpoints.sh` to get these from `out.pwscf`. I usually do this in a `qe_test` directory.



If on mahti, remember to `module load python-singularity`

Using `script.sh`, which is a bash script for using `python $CASINO_HOME/positron_utils/twist_qe_input.py`.

```bash
if [ "$#" -ne 2 ]; then
    echo " "
    echo "Usage: "
    echo "./script <twist> <operation>, "
    echo "where"
    echo "<twist>:      the number of twists to each direction,"
    echo "<operation>:  either"
    echo "    * twist  | generate twists and copy to qe_<twist>x<twist>x<twist>"
    echo "    * qe     | run quantum espresso, both pw.x and pp.x"
    echo "    * atsup  | run atsup"
    echo "    * qmc    | run casino."
    echo " "
    exit
fi
```

!! `atsup` and `casino` parts of this script are deprecated. So run with `./script 4 twist`. Because of how the script is currently written this creates 8 twists in each k point. 


