#!/bin/bash

#for i in $(ls *.xyz); do if grep -q "free_energy" $i; then a=3; else rm $i; fi; done


a=1

for i in $(ls -v *.xyz);

do
energy=$(grep free_energy $i | awk '{print $NF}' | cut -d '=' -f2)
#energy=$(grep free_energy $i | awk '{print $8}' | cut -d '=' -f2)
#energy=$(head -n2 $i | tail -n1)
#energy=$(head -n2 $i | tail -n1 | awk '{print $1}')

#energy=$(head -n2 $i | tail -n1 | cut -d '/' -f2 )

#sed -i "/free_energy/c\/$energy" $i

mv $i ${a}.xyz

echo $a $energy >> total

a=$(($a+1))

done

a=$(($a-1))


structures_sorter.py

cd sorted_structures

for i in $(seq 1 1 $a); 

do 
echo $i
z=$(ls *_${i}.xyz | cut -d '_' -f2)

preparar_gulp_no_opt.sh was_${z}_is_${i}.xyz; gulp < input.gin > output ; sed -i 's/-/ -/g' output ; extreure_freq_gulp output ; sed -i '1,6d' extracted_frequencies;  
phonons_new3.py extracted_frequencies 0 4000 1 10 > ir_was_${z}_is_${i}; done

mkdir ir_data

mv ir* ir_data

cd ir_data

#differentiate_ir_good.py $a

mkdir structures_different_ir

a=$(($a-1))
l=1
for i in $(seq 1 1 $a); do 
z=$(ls *_${i} | cut -d '_' -f3); 
j=$(($i+1)); 
f=$(ls *is_${j} | cut -d '_' -f3); 
g=$(are_different.py ir_was_${z}_is_${i} ir_was_${f}_is_${j}); 
if [ "$g" == "yes" ]; then 
cp ../was_${z}_is_${i}.xyz structures_different_ir/was_${z}_is_${i}_real_${l}.xyz; l=$(($l+1)); fi;  
done
a=$(($a+1))

z=$(ls *_${a} | cut -d '_' -f3);
cp ../*_is_${a}.xyz structures_different_ir/was_${z}_is_${i}_real_${l}.xyz;








