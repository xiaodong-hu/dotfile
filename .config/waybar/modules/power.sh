#!/bin/bash

# Make sure the tlp-stat command is available
if ! command -v tlp-stat &> /dev/null; then
    echo "tlp-stat command not found. Please install tlp package."
    exit 1
fi

# Get the output of tlp-stat
tlp_output=$(sudo tlp-stat -b)

# Extract the power_now value
power_now=$(echo "$tlp_output" | grep "power_now" | awk '{print $3}' | tr -d '[]mW')

# Extract the energy_now value
energy_now=$(echo "$tlp_output" | grep "energy_now" | awk '{print $3}' | tr -d '[]mWh')

# Print the results
printf "%.2f W | %.2f Wh\n" $(echo "scale=2; $power_now/1000" | bc) $(echo "scale=2; $energy_now/1000" | bc)