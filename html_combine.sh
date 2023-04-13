#!/bin/bash

#################
##
## This script will generate an HTML version of the combined findings for easier viewing. It is designed to be very basic for maximum compatiblity. 
##
################

output_file="combined_results_S11.html"

echo "<!DOCTYPE html>
<html>
<head>
<style>
  table {
    width: 100%;
    border-collapse: collapse;
  }
  th, td {
    border: 1px solid black;
    padding: 15px;
    text-align: left;
  }
  th {
    background-color: #f2f2f2;
  }
  .PASS {
    background-color: #90ee90;
  }
  .FINDING {
    background-color: #ffcccb;
  }
</style>
</head>
<body>

<h2>Combined STIG Results</h2>

<table>
  <tr>
    <th>Check ID</th>
    <th>Description</th>
    <th>Hostname</th>
    <th>Result</th>
  </tr>" > "$output_file"

for result_file in *.txt; do
  hostname=$(basename "$result_file" .txt)
  check_id=""
  check_desc=""
  result=""
  while IFS= read -r line; do
    if [[ $line =~ ^V- ]]; then
      check_id=$(echo "$line" | awk '{print $1}')
      check_desc=$(echo "$line" | cut -d' ' -f3-)
    elif [[ $line =~ ^(PASS|FINDING|NOT APPLICABLE)$ ]]; then
      result="$line"
      echo "  <tr>
    <td>$check_id</td>
    <td>$check_desc</td>
    <td>$hostname</td>
    <td class=\"$result\">$result</td>
  </tr>" >> "$output_file"
    fi
  done < "$result_file"
done

echo "</table>
</body>
</html>" >> "$output_file"

# Determine the default web browser on the system
if [[ $(command -v xdg-open) ]]; then
  xdg-open "$output_file"
elif [[ $(command -v gnome-open) ]]; then
  gnome-open "$output_file"
elif [[ $(command -v kde-open) ]]; then
  kde-open "$output_file"
else
  echo "Could not determine the default web browser. Please open the file $output_file manually."
fi
