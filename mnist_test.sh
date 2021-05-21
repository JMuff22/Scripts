for ((i=0; i<10; i++));
do rm -r 'num_'$i;
done


for ((i=0; i<10; i++));
do mkdir 'num'_$i;
done

for ((i=0; i<10; i++));
do mv *-num$i.png num_$i;
done

