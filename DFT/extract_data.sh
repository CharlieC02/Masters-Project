#Extract xyz from geometry.in.next_step into final.xyz file
grep atom geometry.in.next_step > temp_1

lin=$(cat temp_1 | wc -l)

awk '{print $5}' temp_1 > atoms

awk '{print $2, $3, $4}' temp_1 > geomet

paste atoms geomet > final.xyz

rm atoms geomet temp_1


sed -i "1s/^/posarenergia \n/" final.xyz
sed -i "1s/^/$lin \n/" final.xyz

#Get the energy
energy=$(grep "Total energy of the DFT / Hartree-" optimization.out | head -n1 | awk '{print $12}')

sed -i "s/posarenergia/$energy/g" final.xyz
