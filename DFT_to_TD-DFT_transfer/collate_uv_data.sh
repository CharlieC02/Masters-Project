#!/bin/bash

# Define the base directory where the folders are located
BASE_DIR="/home/g16ccoleman/pyroxene_4/UVCalcs"

# Define the destination directory for the collected files
FINAL_DIR="${BASE_DIR}/final_uv_data"

# Create the final directory if it doesn't exist
mkdir -p "$FINAL_DIR"

# Loop through each directory numbered from 1 to 50
for i in {1..50}; do
    # Define the directory path for source files
    DIR_PATH="${BASE_DIR}/${i}"

    # Check if the directory exists
    if [ -d "$DIR_PATH" ]; then
        # List of file types to be copied
        declare -a files=("final_${i}.xyz" "signals_${i}.txt" "relevantSignals_${i}.txt" "out_${i}.log")

        # Loop through the files array
        for file in "${files[@]}"; do
            # Define the full path to the source file
            SOURCE_FILE="${DIR_PATH}/${file}"

            # Check if the source file exists
            if [ -f "$SOURCE_FILE" ]; then
                # Copy the file to the final directory
                cp "$SOURCE_FILE" "$FINAL_DIR/"
            else
                echo "File ${SOURCE_FILE} not found"
            fi
        done
    else
        echo "Directory ${DIR_PATH} not found"
    fi
done

echo "Files have been copied to ${FINAL_DIR}."
