#!/bin/bash

# Define the base directory where the folders 1-50 are located
BASE_DIR="/home/g16ccoleman/pyroxene_4/DFTCalcs"

# Loop through each directory numbered from 1 to 50
for i in {1..50}
do
    # Define the directory path
    DIR_PATH="${BASE_DIR}/$i"
    
    # Check if the directory exists
    if [ -d "$DIR_PATH" ]; then
        # Change directory to the target folder
        cd "$DIR_PATH"
        
        # Check if the extract_data.sh script is present
        if [ -f "extract_data.sh" ]; then
            # Execute the script
            bash extract_data.sh
        else
            echo "extract_data.sh not found in $DIR_PATH"
        fi
        
        # Return to the base directory
        cd "$BASE_DIR"
    else
        echo "Directory $DIR_PATH does not exist"
    fi
done

echo "Commands executed for all applicable directories."
