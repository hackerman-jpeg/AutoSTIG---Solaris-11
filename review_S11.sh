#!/bin/bash

# This script is designed to allow for the reviewing of the combined output files. It must be edited manually.

# CHANGE THE BELOW: Enter the directory where the result files are stored
results_dir="/path/to/result/files"

# Create a file to store the combined results
combined_results="combined_results.txt"
touch "$combined_results"

# Process each result file
for file in "$results_dir"/*; do
  hostname=$(basename "$file" | cut -d '_' -f 2)
  grep -E '(FINDING|PASS)' "$file" | sed "s/^/$hostname /" >> "$combined_results"
done

# Sort the results by check and hostname
sorted_results="sorted_results.txt"
sort -k 2 -k 1 "$combined_results" > "$sorted_results"

# Display the sorted results
cat "$sorted_results"
