#!/bin/bash

CURRENT=$PWD
QE_BIN_DIR=/projappl/project_2002888/espresso/bin
ATSUP_BIN_DIR=/projappl/project_2002888/atsup
CASINO_HOME=/projappl/project_2002888/casino_positrons/

SCRIPTS=/users/jakemuff/toffe_scripts/

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

FOLDER=qe_$1x$1x$1
FILE=${CURRENT}/$FOLDER

case "$1" in
        2)
	    twist=8
	    ;;
         
        3)
	    twist=27
	    ;;
         
        4)
	    twist=8
	    ;;
        *)
            echo $"Usage: $0 {2|3|4} {twist|qe|atsup|qmc}"
            exit 1
esac

if [ ! -d ${FOLDER} ]; then
    echo "Creating folder $FOLDER"
    mkdir $FOLDER
fi

if [ "$2" = "twist" ]; then
    if [ ! -f input/in.pwscf ]; then
	echo "in.pwscf required."
	exit 2
    fi
    cp input/in.pwscf $CURRENT
    python $CASINO_HOME/positron_utils/twist_qe_input.py --file in.pwscf --kpoints 2 2 2 --twists $1 $1 $1 --symfile symmetric_444_kpoints.txt
    rm -f ${CURRENT}/in.pwscf
fi

if [ "$2" = "atsup" ]; then
    mkdir ${FILE}/atsup
    cp input/input_atsup ${FILE}/atsup
fi

for ((i=1;i<=$twist;i++))
do
    case "$2" in
	twist)
	    echo "twist $i"
	    if [ ! -d ${FILE}/$i ]; then
		mkdir ${FILE}/${i}
		cp -r input/si.upf input/pw2casino.dat ${FILE}/$i
	    fi
	    mv in.pwscf.$i ${FILE}/${i}/in.pwscf
	    ;;
	qe)
	    if [ ! -d ${FILE}/$i ]; then
		echo "File ${FILE}/$i not found, run twisting to produce files."
		exit 3
            fi
	    echo "qe $i"
	    cd ${FILE}/$i
	    sbatch ${SCRIPTS}/pwscf.sh
	    ;;
	atsup)
	    if [ ! -d ${FILE}/$i ]; then
		echo "File ${FILE}/$i not found, run twisting to produce files."
                exit 3
            fi
	    mv ${FILE}/${i}/aln.pwfn.data ${FILE}/atsup/aln.pwfn.data.$i
	    ;;
	qmc)
	    if [ ! -d ${FILE}/$i ]; then
		echo "File ${FILE}/$i not found, run twisting to produce files."
                exit 3
            fi
	    echo "qmc $i"
	    cd ${FILE}/$i
	    clearup -f; rm -f  expval.data
	    runqmc -p 40 -T 4h
	    ;;
	*)
	    echo $"Usage: $0 {2|3|4} {twist|qe|atsup|qmc}"
            exit 4
	    ;;
    esac
done

cd $CURRENT

case "$2" in
    qe)
	echo "Performing post-processing to solve electron density in the gamma-twist..."
	cp input/in.pp ${FILE}/1
	cd ${FILE}/1
	sbatch ${SCRIPTS}/pp.sh
	;;
    atsup)
	module load cmake/3.9.6
	module swap intel gcc
	module load fftw
	module load python-env

	echo "Solving the positron state at the gamma point and constructing the pwfn.data-files..."
	mv ${FILE}/1/alncharge ${FILE}/atsup
	cd ${FILE}/atsup
	python ${ATSUP_BIN_DIR}/run_atsup.py --no_checks
	#for ((i=1;i<=$twist;i++))
	#do
	#    cp pwfn.data.$i pwfn.data
	#    blip  <<< $'2\n0\nn\nn\n'
	#    mv bwfn.data ${FILE}/$i
	#    cp ${CURRENT}/input/input ${CURRENT}/input/c_pp.data ${CURRENT}/input/correlation.data ${FILE}/$i
	#done
	;;
esac

