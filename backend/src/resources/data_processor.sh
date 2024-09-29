#!/bin/bash

input_dir="raw"
output_dir="ready"

# Create the output directory if it doesn't exist
mkdir -p "$output_dir"
rm $output_dir/*

# Loop through all JSON files in the input directory
for file in "$input_dir"/*.json; do
    # Prepare output file names
    base_filename=$(basename "$file" .json)
    metadata_output="$output_dir/${base_filename}_metadata.json"
    rows_output="$output_dir/${base_filename}_data.json"

    # Process the JSON file
    formatted_json=$(jq '.' "$file")

    # Extract the columns (assuming all objects have the same keys)
    columns=$(echo "$formatted_json" | jq '.[0] | keys')

    # Count the number of rows
    num_rows=$(echo "$formatted_json" | jq '. | length')

    # Write metadata (columns and row count) to the metadata file
    echo "{" > "$metadata_output"
    echo "  \"columns\": $columns," >> "$metadata_output"
    echo "  \"numDataRows\": $num_rows" >> "$metadata_output"
    echo "}" >> "$metadata_output"
    
    # Use jq to format each object correctly and avoid extra commas
    echo "$formatted_json" | jq -c '.[]' | sed '1d;$d' >> "$rows_output"
    # sed '/^\s*[\[\]]\s*$/d; /^\s*$/d' $rows_output

    # Display the results for each file
    echo "Processed: $filename"
    echo "  Metadata written to: $metadata_output"
    echo "  Data written to: $rows_output"
done