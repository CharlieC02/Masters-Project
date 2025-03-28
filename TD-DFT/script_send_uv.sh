#!/bin/bash
# Basic parameters: job name, parallel environment and cores, queue, used shell, 
# current working directory,output files (.err, .out), email.
#$ -N UVCalc
#$ -pe smp 8
#$ -q iqtc09.q
#$ -S /bin/bash
#$ -cwd
#$ -o testl_gaus.out
#$ -e testl_gaus.err
# Remove the first '#' of the following 2 lines if you want to receive an email when the job ends.
##$ -m e 
##$ -M  yourmail@ub.edu
source /opt/modules/init/bash

# Load the modules needed
module load gaussian/g16b01
# Copy inputs and files needed to the directory where the jobs will run

old=$PWD
cd $TMPDIR
cp $old/input.in .

# Run the job
export GAUSS_SCRDIR=$TMPDIR

g16 < input.in > out.log
# Copy the results to our home directory
cp out.log $old
