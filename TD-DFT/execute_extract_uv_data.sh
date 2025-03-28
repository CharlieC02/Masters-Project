#!/bin/bash

# Define the script source and target directories
SCRIPT_SOURCE="/home/g16ccoleman/pyroxene_4/UVCalcs/UV_scripts/extract_data.sh"
TARGET_DIR="/home/g16ccoleman/pyroxene_4/UVCalcs"

# Loop through each directory numbered from 1 to 50
for i in {1..50}; do
    # Define the target folder path
    FOLDER_PATH="${TARGET_DIR}/${i}"

    # Check if the folder exists
    if [ -d "$FOLDER_PATH" ]; then
        # Copy the script to the folder
        cp "$SCRIPT_SOURCE" "$FOLDER_PATH"

        # Change to the directory
        cd "$FOLDER_PATH"

        # Run the script with the folder number as an argument
        ./extract_data.sh $i
    else
        echo "Folder ${FOLDER_PATH} not found"
    fi
done

echo "Process completed for all directories."
