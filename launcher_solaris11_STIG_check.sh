#!/bin/bash

# Get current date, username, and hostname
current_date=$(date '+%Y-%m-%d')
username=$(whoami)
hostname=$(uname -n)

# Print the title, current date, username, and hostname
echo "=================================================================="
echo "                      SOLARIS 11 STIG LAUNCHER                    "
echo "=================================================================="
echo "Date: $current_date"
echo "User: $username"
echo "Host: $hostname"
echo "=================================================================="
echo ""
read -p "Enter the path to the STIG check script: " STIG_SCRIPT
read -p "Enter the path to the hosts file or type 'single' for a single host: " HOSTS_FILE
read -p "Enter the path to the directory where you want to store the results: " LOCAL_RESULTS_DIR

REMOTE_DIR="/tmp"

if [ "$HOSTS_FILE" == "single" ]; then
  read -p "Enter the hostname or IP address of the single host: " SINGLE_HOST
  HOSTS_LIST=("$SINGLE_HOST")
else
  mapfile -t HOSTS_LIST < "$HOSTS_FILE"
fi

TOTAL_HOSTS=${#HOSTS_LIST[@]}
PROCESSED_HOSTS=0

error_file="errors_$(date +%m:%Y-%H:%M).txt"

for HOST in "${HOSTS_LIST[@]}"; do
  echo "Processing host: $HOST"

  scp "${STIG_SCRIPT}" "${HOST}:${REMOTE_DIR}/" || { echo "Error copying STIG check script to $HOST" | tee -a "$error_file"; continue; }
  ssh "${HOST}" "chmod +x ${REMOTE_DIR}/${STIG_SCRIPT} && ${REMOTE_DIR}/${STIG_SCRIPT}" || { echo "Error running STIG check script on $HOST" | tee -a "$error_file"; continue; }
  RESULT_FILE=$(ssh "${HOST}" "ls ${REMOTE_DIR}" | grep "$(date +%m:%Y)" | grep "$(hostname)") || { echo "Error finding result file on $HOST" | tee -a "$error_file"; continue; }
  scp "${HOST}:${REMOTE_DIR}/${RESULT_FILE}" "${LOCAL_RESULTS_DIR}/" || { echo "Error copying result file from $HOST" | tee -a "$error_file"; continue; }
  ssh "${HOST}" "rm ${REMOTE_DIR}/${STIG_SCRIPT} ${REMOTE_DIR}/${RESULT_FILE}" || { echo "Error removing STIG check script and result file on $HOST" | tee -a "$error_file"; continue; }

  PROCESSED_HOSTS=$((PROCESSED_HOSTS + 1))
  PROGRESS=$((PROCESSED_HOSTS * 100 / TOTAL_HOSTS))
  printf "Overall progress: [%-50s] %d%%\r" "$(printf '#%.0s' $(seq 1 $((PROGRESS / 2))))" "$PROGRESS"
done

echo ""
echo "Execution completed."
