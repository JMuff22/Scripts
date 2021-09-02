#!/bin/bash

for i in $(seq 1 1 8)
do
	cd $i
	cd dmc
	grep "Total energy" out | tail -n 1 | awk -v file="$i" '{print file" "$4" "$6}' >> ../../dmc_energies.txt
	cd ../../
done