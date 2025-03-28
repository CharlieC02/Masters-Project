#!/bin/bash 
# Basic parameters: job name, parallel environment and cores, queue, used shell, 
# current working directory,output files (.err, .out), email.
#$ -N fhi-aims
#$ -pe smp 32
#$ -q iqtc09.q
#$ -S /bin/bash
#$ -cwd 
#$ -o fhi-aims.out 
#$ -e fhi-aims.err 
# Remove the first '#' of the following 2 lines if you want to receive an email when the job ends.
##$ -m e 
##$ -M yourmail@ub.edu

# Load the modules needed 
. /etc/profile
module load fhi-aims/150518_ompi

# Copy inputs and files needed to the directory where the jobs will run

export old=$PWD

cd $TMPDIR
cp -r $old/* .

# Run the job 

export OMP_NUM_THREADS=1
ulimit -l unlimited
mpirun -np $NSLOTS aims.150518.scalapack.mpi.x > optimization.out
cp * $old
