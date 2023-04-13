Solaris-11-STIG
=========
[![STIG: Solaris 11](https://img.shields.io/badge/STIG-Solaris%2011-informational)](https://ncp.nist.gov/checklist/668/download/10006)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)]([https://www.gnu.org/licenses/gpl-3.0](https://github.com/dimaswell/Solaris-11-STIG/blob/main/LICENSE))
![Maintenance](https://img.shields.io/maintenance/yes/2023)

## Introduction

A bash script written for Solaris 11 to check all the DISA STIGs for the Oracle Solaris 11 STIG from 2018. This script fixes the incorrect commands that DISA (usually) has in their STIGS. It was designed for use on systems that do not have internet connectivity, such as a SCIF, and can be run against any number of hosts. It was tested and used extensivly in an environment with 200+ Solaris machines and it ran well. 

It is comprised of two components: 

1. launcher_S11.sh
2. checks_S11.sh

The `launcher_S11` script calls the checks script. The `checks_S11` script contains all the checks and can be run as a standalone script. You should not use the `launcher_S11` script for just one machine, as it's not efficient and has too much overhead for a single machine audit. 

## Single Machine Run

Run this as you would any bash script. For closed environments and air gapped systems, simply download this repo as a .`zip` and extract. 

1. Change permissions on the scripts and make exectuable:

```bash
sudo chmod a+x checks_S11.sh
```

2. Launch the checks_S11.sh, it needs to be launched with elevated permissions so that the commands can execute properly:

```bash
sudo ./checks_S11.sh
```

3. Review findings:

```bash
cat insertfilenamehere.txt
```

## Multi-Machine Run
Run this as you would any bash script. For closed environments and air gapped systems, simply download this repo as a .`zip` and extract. Since running for multiple machines, use the launcher script. You do not have to extract to same folder you run from, as the launcher will ask you to input the path to `checks_S11.sh` script. 

1. Change permissions on the scripts and make exectuable:

```bash
sudo chmod a+x checks_S11.sh launcher_S11.sh
```

2. Launch the checks_S11.sh, it needs to be launched with elevated permissions so that the commands can execute properly:

```bash
sudo ./launcher_S11.sh
```

3. Review findings; this is done as an option in the launcher. When the background tasks and all checks finish, it will ask if you'd like to review the combined findings. If you click no, and want to still combine the fingings and review (instead of `cat`ing each one), you can run the script below: 

```bash
#!/bin/bash

# Enter the directory where the result files are stored
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

```

## Future Work
While this script is good, improvements can always be made. Please feel free to improve and also submit bugs. 
