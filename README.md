Solaris 11 Automatic STIG Checker
=========
[![STIG: Solaris 11](https://img.shields.io/badge/STIG-Solaris%2011-informational)](https://ncp.nist.gov/checklist/668/download/10006)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)]([https://www.gnu.org/licenses/gpl-3.0](https://github.com/dimaswell/Solaris-11-STIG/blob/main/LICENSE))
![Maintenance](https://img.shields.io/maintenance/yes/2023)

## Introduction

A bash script written for Solaris 11 to check all the DISA STIGs for the Oracle Solaris 11 STIG from 2018. This script fixes the incorrect commands that DISA (usually) has in their STIGS. 

It was designed for use on systems that do not have internet connectivity, such as a SCIF, and can be run against any number of hosts. It was tested and used extensivly in an environment with 200+ Solaris machines and it ran well. Below is a sample from the `html_combine.sh`:

<img width="1720" alt="image" src="https://user-images.githubusercontent.com/41294610/231830166-822e8673-45c6-4c7f-84a6-9500f1f8cae2.png">

NOTE: These scripts are intentially designed to be low overhead and use only default commands and utilities built into Solaris.

## Composition

This repo is comprised of 4 core components: 

| File | Details   |
|-----:|-----------|
| `launcher_S11.sh` | This is what you run if you are running against more than one machine. The `launcher_S11` script calls the `checks_S11` script. You should not use this script for just one machine, as it's not efficient and has too much overhead for a single machine audit. |
| `checks_S11.sh`   | This contains all the checks, and is called on by the launcher script. It can be run standalone for a single machine.    |
| `review_S11.sh`   | This is a helper script for if you would like to combine multiple output files and view in a sorted manner. It must be edited manually within the script to point to the output path       |
| `html_combine.sh` | This does what it says, combines the results into an nicely formatted HTML page for easy viewing. Looks for results in same working directory |

---
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
cat yourFileName.txt
```

---

## Multi-Machine Run
Run this as you would any bash script. For closed environments and air gapped systems, simply download this repo as a .`zip` and extract. Since running for multiple machines, use the launcher script. You do not have to extract to same folder you run from, as the launcher will ask you to input the path to `checks_S11.sh` script. 

1. Change permissions on the scripts and make exectuable:

```bash
sudo chmod a+x checks_S11.sh launcher_S11.sh review_S11.sh
```

2. Create the `hosts.txt` file and save anywhere (you will input the path to this file when you launch the script). You may also use an existing one, providing it is formatting correctly. The `hosts.txt` file should be formatted such, with a host on each line:

```bash
host1.example.com
host2.example.com
192.168.1.10
192.168.1.11
```

3. Launch the checks_S11.sh, it needs to be launched with elevated permissions so that the commands can execute properly:

```bash
sudo ./launcher_S11.sh
```

4. Review findings; this is done as an option in the launcher. When the background tasks and all checks finish, it will ask if you'd like to review the combined findings. If you click no, and want to still combine the fingings and review (instead of having to `cat` each one), you can configure and run the `review_S11.sh` script. First, change the line to point to the path where the output files are:

```bash
vim review_S11.sh
```
Then run as normal:

```bash
 ./review_S11.sh
```


---

## Future Work
While this script is good, improvements can always be made. Please feel free to improve and also submit bugs. 
New Update Here
