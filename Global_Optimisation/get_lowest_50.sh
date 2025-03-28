mkdir lowest_50_structures

cd different_structures

for i in $(seq 1 1 50);
do
cp *_${i}.xyz ../lowest_50_structures
done
