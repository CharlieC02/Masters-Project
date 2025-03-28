#/bin/bash 
# Basic parameters: job name, parallel environment and cores, queue, used shell, 
# current working directory,output files (.err, .out), email.
#$ -N global_opt   #Name of the calculation
#$ -pe smp 1       #Number of cores to use
#$ -q iqtc09.q     #Queue to use (The code is installed in iqtc09 and iqtc06)
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
module load anaconda/2019.10
module load gulp/5.2_ompi
source activate joan


#Copy files to cluster
export old=$PWD
cd $TMPDIR
cp $old/* .

export OMP_NUM_THREADS=1
ulimit -l unlimited


#Paths to libraries 
export PYTHONPATH=:"/home/g16joanm/ase":${PYTHONPATH}
export GULP_LIB=/home/g16joanm/IR_stuff/gulp-5.0/Libraries


#Run Basin_Hoppin code
python new_bhscript.py


#Remove output and error files from the cluster to avoid overwriting
rm output error

#remove temporal directories
rm -r open*

#Copy back the results
cp -r * $old
