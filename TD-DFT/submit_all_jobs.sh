#!/bin/bash

# Define the base directory where the folders 1-50 are located
BASE_DIR="/home/g16ccoleman/pyroxene_4/UVCalcs"

# Loop through each directory numbered from 1 to 50
for i in {1..50}
do
    # Define the directory path
    DIR_PATH="${BASE_DIR}/${i}"

    # Check if the directory exists
    if [ -d "$DIR_PATH" ]; then
        # Change to the directory
        cd "$DIR_PATH"

        # Check if the script_send_uv.sh script is present
        if [ -f "script_send_uv.sh" ]; then
            # Submit the calculation job
            qsub -N "UV_${i}_calc" "script_send_uv.sh"
        else
            echo "script_send_uv.sh not found in ${DIR_PATH}"
        fi
    else
        echo "Directory ${DIR_PATH} does not exist"
    fi
done

echo "All jobs have been submitted."
