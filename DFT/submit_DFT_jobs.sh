#!/bin/bash

# Define the base directory where the folders 1-50 are located
BASE_DIR="/home/g16ccoleman/pyroxene_4/DFTCalcs"

# Loop through each directory from 1 to 50
for i in {1..50}
do
    # Define the directory path
    DIR_PATH="${BASE_DIR}/$i"
    
    # Check if the directory exists and contains the script_send_dft.sh
    if [ -d "$DIR_PATH" ] && [ -f "${DIR_PATH}/script_send_dft.sh" ]; then
        # Change directory to the target folder
        cd "$DIR_PATH"
        
        # Submit the calculation job
        qsub -N "DFT_${i}_calc" "script_send_dft.sh"
    else
        echo "Directory $DIR_PATH does not exist or script_send_dft.sh is missing"
    fi
done

echo "All jobs have been submitted."
