#!/bin/bash

# Define the base directory where the folders 1-50 are located
BASE_DIR="/home/g16ccoleman/pyroxene_4/UVCalcs"

# Path to the script_send_uv.sh script
SCRIPT_PATH="/home/g16ccoleman/pyroxene_4/UVCalcs/UV_scripts/script_send_uv.sh"

# Parameters you might want to change
NEW_NSTATES=900  # Example: change this as needed
NEW_CHARGE=0    # Example: change this as needed
NEW_SPIN=1      # Example: change this as needed

# Loop through each directory numbered from 1 to 50
for i in {1..50}
do
    # Define the directory path
    DIR_PATH="${BASE_DIR}/${i}"

    # Check if the directory exists
    if [ -d "$DIR_PATH" ]; then
        # Check if the input.in file exists in the directory
        if [ -f "${DIR_PATH}/input.in" ]; then
            # Modify NStates in the input.in file
            sed -i "/NStates/c\NStates = ${NEW_NSTATES}" "${DIR_PATH}/input.in"

            # Modify Charge and Spin in the input.in file
            sed -i "/^0 1/c\\${NEW_CHARGE} ${NEW_SPIN}" "${DIR_PATH}/input.in"

            # Copy the script_send_uv.sh script to the folder
            cp "$SCRIPT_PATH" "${DIR_PATH}/script_send_uv.sh"
        else
            echo "input.in not found in ${DIR_PATH}"
        fi
    else
        echo "Directory ${DIR_PATH} does not exist"
    fi
done

echo "Input parameters updated and scripts copied successfully."


echo "Processing and job submission completed for all directories."
