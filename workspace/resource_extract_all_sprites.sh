#!/bin/bash

set -e

# Check if the input file and resources file are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 resources_file input_file"
    exit 1
fi

RESOURCES_FILE="$1"
INPUT_FILE="$2"

# Create the output directory if it doesn't exist
mkdir -p res

while IFS=',' read -r bitmap palette; do
    # Trim any whitespace
    bitmap=$(echo "$bitmap" | xargs)
    palette=$(echo "$palette" | xargs)

    echo "Processing bitmap $bitmap with palette $palette"

    # Extract the bitmap and palette resources
    if [[ ! -f "res/$bitmap.bin" ]]; then ../resource_tool extract-resource "$RESOURCES_FILE" "$bitmap" "res/$bitmap.bin"; fi
    if [[ ! -f "res/$palette.bin" ]]; then ../resource_tool extract-resource "$RESOURCES_FILE" "$palette" "res/$palette.bin"; fi

    # Decode the image
    if [[ ! -f "res/$bitmap.png" ]]; then ../resource_tool decode-image -i true -c true "res/$bitmap.bin" "res/$palette.bin" "res/$bitmap.png"; fi

done < "$INPUT_FILE"
