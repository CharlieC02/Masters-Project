#!/bin/bash

# Define the base directory where the folders are located
BASE_DIR="/home/g16ccoleman/pyroxene_4/UVCalcs"

# Loop through each directory named from 1 to 50
for i in {1..50}; do
    # Define the directory path
    DIR_PATH="${BASE_DIR}/${i}"

    # Define the path for the existing out.log file
    OUT_LOG_PATH="${DIR_PATH}/out.log"

    # Check if the out.log file exists in the directory
    if [ -f "$OUT_LOG_PATH" ]; then
        # Rename out.log to out_x.log where x is the folder name
        mv "$OUT_LOG_PATH" "${DIR_PATH}/out_${i}.log"
    else
        echo "out.log not found in ${DIR_PATH}"
    fi
done

echo "Renaming completed for all directories."
