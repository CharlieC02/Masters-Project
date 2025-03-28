#!/bin/bash

# Define the source directory where the final_x.xyz files are located
SOURCE_DIR="/home/g16ccoleman/pyroxene_4/DFTCalcs"

# Define the base directory for the new folders
BASE_DIR="/home/g16ccoleman/pyroxene_4/UVCalcs"

# Path to the prepare_input_uv.sh script
SCRIPT_PATH="/home/g16ccoleman/pyroxene_4/UVCalcs/UV_scripts/prepare_input_uv.sh"

# Create the base directory if it does not exist
mkdir -p "$BASE_DIR"

# Loop through the folder numbers
for i in {1..50}
do
    # Define the new folder path
    NEW_FOLDER="${BASE_DIR}/${i}"

    # Create the new folder
    mkdir -p "$NEW_FOLDER"

    # Define the source file path
    SOURCE_FILE="${SOURCE_DIR}/final_${i}.xyz"

    # Check if the source file exists
    if [ -f "$SOURCE_FILE" ]; then
        # Move the file to the new folder
        mv "$SOURCE_FILE" "$NEW_FOLDER/final_${i}.xyz"

        # Copy the prepare_input_uv.sh script to the new folder
        cp "$SCRIPT_PATH" "$NEW_FOLDER/prepare_input_uv.sh"

        # Change to the new folder
        cd "$NEW_FOLDER"

        # Execute the script with the file as an argument
        ./prepare_input_uv.sh "final_${i}.xyz"
    else
        echo "File ${SOURCE_FILE} not found"
    fi
done

echo "Processing completed for all files."
