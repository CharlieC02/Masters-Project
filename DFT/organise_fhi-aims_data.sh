#!/bin/bash

# Define the base directory where the folders are located
BASE_DIR="/home/g16ccoleman/pyroxene_4/DFTCalcs"

# Define the destination directory for the organized data
FINAL_DIR="${BASE_DIR}/final_fhi-aims_data"

# Create the final directory if it doesn't exist
mkdir -p "$FINAL_DIR"

# Loop through each directory numbered from 1 to 50
for i in {1..50}; do
    # Define the directory path for source files
    DIR_PATH="${BASE_DIR}/${i}"

    # Define the target directory path within final_fhi-aims_data
    TARGET_PATH="${FINAL_DIR}/${i}"

    # Create the target directory
    mkdir -p "$TARGET_PATH"

    # Check if the source directory exists
    if [ -d "$DIR_PATH" ]; then
        # List of files to be copied
        declare -a files=("control.in" "fhi-aims.err" "fhi-aims.out" "final_${i}.xyz" "geometry.in" "geometry.in.next_step" "Mulliken.out" "optimization.out")

        # Loop through the files array
        for file in "${files[@]}"; do
            # Define the full path to the source file
            SOURCE_FILE="${DIR_PATH}/${file}"

            # Check if the source file exists
            if [ -f "$SOURCE_FILE" ]; then
                # Copy the file to the target directory
                cp "$SOURCE_FILE" "$TARGET_PATH/"
            else
                echo "File ${SOURCE_FILE} not found"
            fi
        done
    else
        echo "Directory ${DIR_PATH} not found"
    fi
done

echo "Data has been organized into ${FINAL_DIR}."
