#!/bin/bash

# Define the base directory where the folders 1-50 are located
BASE_DIR="/path/to/your/base/directory"

# Loop through each directory from 1 to 50
for i in {1..50}
do
    # Define the directory path
    DIR_PATH="${BASE_DIR}/$i"
    
    # Check if the directory exists
    if [ -d "$DIR_PATH" ]; then
        # Change to the directory
        cd "$DIR_PATH"
        
        # Check if the xyz file exists
        if [ -f "final_${i}.xyz" ]; then
            # Execute the command on the .xyz file
            ./xyz_to_geometry.in "final_${i}.xyz"
        else
            echo "File final_${i}.xyz not found in $DIR_PATH"
        fi
    else
        echo "Directory $DIR_PATH does not exist"
    fi
done

echo "Command executed for all applicable files."
