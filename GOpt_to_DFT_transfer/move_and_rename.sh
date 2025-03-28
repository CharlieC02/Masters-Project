#!/bin/bash

# Define the base directory
BASE_DIR="/home/g16ccoleman/Global_opt_calcs"

# Define the destination directory
DEST_DIR="${BASE_DIR}/post_opt_all"

# Create the destination directory if it doesn't exist
mkdir -p "$DEST_DIR"

# Define offsets for each calculation set
declare -A offsets=( ["6"]=50 ["14"]=100 ["21"]=150 ["33"]=200 )

# Loop through the offsets array
for key in "${!offsets[@]}"
do
    # Define the source directory
    SOURCE_DIR="${BASE_DIR}/calculation_${key}E/lowest_50_structures"
    
    # Check if the source directory exists
    if [ -d "$SOURCE_DIR" ]; then
        # Loop through each .xyz file in the source directory
        for file in "$SOURCE_DIR"/*.xyz
        do
            # Check if the file is a regular file
            if [ -f "$file" ]; then
                # Extract the number from the filename
                number=$(echo $(basename "$file") | sed -n 's/.*real_\([0-9]*\)\.xyz/\1/p')
                
                # Calculate new number by adding the offset
                new_number=$((number + offsets[$key]))
                
                # Define new filename
                new_filename="L${new_number}.xyz"
                
                # Copy and rename the file to the destination directory
                cp "$file" "$DEST_DIR/$new_filename"
            fi
        done
    else
        echo "Directory $SOURCE_DIR does not exist"
    fi
done

echo "Files have been renamed and copied successfully."

