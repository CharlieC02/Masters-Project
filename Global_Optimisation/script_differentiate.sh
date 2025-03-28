#/bin/bash 
# Basic parameters: job name, parallel environment and cores, queue, used shell, 
# current working directory,output files (.err, .out), email.
#$ -N differentiate   #Name of the calculation
#$ -pe smp 1       #Number of cores to use
#$ -q iqtc06.q     #Queue to use (The code is installed in iqtc09 and iqtc06)
#$ -S /bin/bash
#$ -cwd 
#$ -o output       #Output file named "output"
#$ -e error        #Error file named "error"
# Remove the first '#' of the following 2 lines if you want to receive an email when the job ends.
##$ -m e 
##$ -M yourmail@ub.edu

# Load the modules needed 
. /etc/profile

#Modules needed for this calc
module load python/2.7.15
module load gulp/4.3_ompi

export PATH=$PATH:/home/g16joanm/scripts
export OMP_NUM_THREADS=1
ulimit -l unlimited


#Paths to libraries 
export PYTHONPATH=:"/home/g16joanm/ase":${PYTHONPATH}
export GULP_LIB=/home/g16joanm/IR_stuff/gulp-5.0/Libraries


#Run Basin_Hoppin code
cp differentiate_sort_structures.sh post_opt
cd post_opt

#Copy files to cluster
export old=$PWD
cd $TMPDIR
cp $old/* .



bash differentiate_sort_structures.sh

#Copy back the results
cp -r sorted_structures/ir_data/structures_different_ir/ ${old}/../different_structures
