#!/bin/bash

# Define the base directory containing the 'lowest_50_structures' and 'DFT_scripts'
BASE_DIR="/path/to/your/base/directory"

# Define the source directory for the XYZ files
XYZ_DIR="${BASE_DIR}/lowest_50_structures"

# Define the source directory for the DFT scripts
SCRIPTS_DIR="${BASE_DIR}/DFT_scripts"

# Loop through each .xyz file in the XYZ source directory
i=1
for file in "$XYZ_DIR"/*.xyz
do
    # Check if the file is a regular file
    if [ -f "$file" ]; then
        # Create a corresponding numbered directory
        mkdir -p "${BASE_DIR}/$i"
        
        # Define new filename
        new_filename="final_${i}.xyz"
        
        # Copy the XYZ file to the new directory with the new name
        cp "$file" "${BASE_DIR}/${i}/$new_filename"
        
        # Copy all the files from DFT_scripts and its subdirectories
        cp -r "$SCRIPTS_DIR"/* "${BASE_DIR}/$i/"
    fi
    ((i++))
done

echo "Files have been copied and organized successfully."
