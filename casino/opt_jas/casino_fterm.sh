#!/bin/bash
# RUNNING CASINO 


cd opt_f
for dir in $(seq 0.5 0.5 3) ; do
	cd $dir
	runqmc -T 2h -p 128 --user.queue=medium
	cd ..
done
cd ..