#!/usr/bin/bash
ELEMENT=si

DF_SUMMARY="https://casinoqmc.net/pseudo_lib/${ELEMENT}/1/summary.txt"
PPDATA="https://casinoqmc.net/pseudo_lib/${ELEMENT}/1/pp.data"

AWFNDATA_1="awfn.data_s2p2_3P"
AWFNDATA_2="awfn.data_s1p3_5S"
AWFNDATA_3="awfn.data_s2p1d1_3F"

URL_AWFNDATA_1="https://casinoqmc.net/pseudo_lib/${ELEMENT}/1/${AWFNDATA_1}"
URL_AWFNDATA_2="https://casinoqmc.net/pseudo_lib/${ELEMENT}/1/${AWFNDATA_2}"
URL_AWFNDATA_3="https://casinoqmc.net/pseudo_lib/${ELEMENT}/1/${AWFNDATA_3}"

QE_PATH=$HOME/q-e-qe-6.1.0/upftools/
upf_filename=${ELEMENT}_df_tabulated.UPF

# rm awfn.data_s2p2_3P
# rm awfn.data_s1p3_5S
# rm awfn.data_s2p1d1_3F
# rm summary.txt
# rm pp.data
# rm upf_filename


echo $(date) "Downloading Pseudopotential data"
if [ -f summary.txt ]; then
	echo "summary.txt exists"
else
	wget $DF_SUMMARY
fi
if [ -f pp.data ]; then
	echo "pp.data exists"
else
	wget $PPDATA
fi
if [ -f "$AWFNDATA_1" ]; then
	echo "$AWFNDATA_1 exists"
else
	wget $URL_AWFNDATA_1
fi
if [ -f "$AWFNDATA_2" ]; then
	echo "$AWFNDATA_2 exists"
else
	wget $URL_AWFNDATA_2
fi
if [ -f "$AWFNDATA_3" ]; then
	echo "$AWFNDATA_3 exists"
else
	wget $URL_AWFNDATA_3
fi
ls -a
echo "Download done"
echo "Converting to UPF..."

cat > inputpp << EOF
	&inputpp
	        pp_data='pp.data'
	        upf_file='${ELEMENT}_df_tabulated.UPF'
	        /
	3
	awfn.data_s2p2_3P
	awfn.data_s1p3_5S
	awfn.data_s2p1d1_3F
EOF

$QE_PATH/casino2upf.x < inputpp

cp $upf_filename ../
cp pp.data ../${ELEMENT}_pp.data