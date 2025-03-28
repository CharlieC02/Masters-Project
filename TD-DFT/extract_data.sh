#output file with name out.log


#Obtain all the transitions (wavelength, oscillator strengths)

grep "Excited State" out.log | awk '{gsub("f=", "", $9); print $7, $9}' > signals.txt

#Obtain all the transitions between 200 and 230 nm

grep "Excited State" out.log | awk '$7 >= 200 && $7 <= 230 {gsub("f=", "", $9); print $7, $9}' > relevantSignals.txt

