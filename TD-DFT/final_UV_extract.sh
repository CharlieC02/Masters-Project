#!/bin/bash

# Define the base directory where the folders 1-50 are located
BASE_DIR="/home/g16ccoleman/pyroxene_4/UVCalcs"

# Define the directory where the extract_data.sh script is located
SCRIPT_DIR="/home/g16ccoleman/pyroxene_4/UVCalcs/UV_scripts"

# Define the directory to store all final output files
OUTPUT_DIR="/home/g16ccoleman/pyroxene_4/UVCalcs/final_uv_data"

# Create the final output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Loop through each directory numbered from 1 to 50
for i in {1..50}
do
    # Define the directory path
    DIR_PATH="${BASE_DIR}/${i}"

    # Check if the directory exists
    if [ -d "$DIR_PATH" ]; then
        # Define the source file path for the .xyz file
        SOURCE_FILE="${DIR_PATH}/final_${i}.xyz"

        # Check if the source .xyz file exists
        if [ -f "$SOURCE_FILE" ]; then
            # Copy and rename the .xyz file to structures_x.xyz
            cp "$SOURCE_FILE" "$DIR_PATH/structures_${i}.xyz"

            # Copy the extract_data.sh script to the folder
            cp "${SCRIPT_DIR}/extract_data.sh" "$DIR_PATH/"

            # Ensure out.log is available for extract_data.sh
            # This is a crucial step: ensure out.log exists here
            if [ -f "${DIR_PATH}/out.log" ]; then
                # Change to the directory
                cd "$DIR_PATH"

                # Run the extract_data.sh script
                ./extract_data.sh

                # Copy the output files to the final output directory and rename
                cp out.log "${OUTPUT_DIR}/out_${i}.log"
                cp signals.txt "${OUTPUT_DIR}/signals_${i}.txt"
                cp relevantSignals.txt "${OUTPUT_DIR}/relevantSignals_${i}.txt"
            else
                echo "out.log not found in ${DIR_PATH}"
            fi
        else
            echo "File ${SOURCE_FILE} not found"
        fi
    else
        echo "Directory ${DIR_PATH} does not exist"
    fi
done

echo "Processing completed for all directories."
