#!/bin/bash

# Usage: codeforces.sh <filename> <language> <directory>
set -e

filename="$1"
language="$2"
dir="$3"
bin_dir="$dir/bin"
base_name="${filename%.*}"

# ANSI Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Ensure we are only running C++
if [ "$language" != "cpp" ]; then
  echo -e "${RED}Error: This script is exclusively for C++.${NC}"
  exit 1
fi

mkdir -p "$bin_dir"
output_bin="$bin_dir/$base_name"
input_file="$dir/test_cases.txt"
expected_file="$dir/output.txt"
actual_file="$dir/actual_output.txt"

# Fast Compilation (-O2 and standard C++17)
g++ "$dir/$filename" -o "$output_bin" -O2 -std=c++17 -Wall || { echo -e "${RED}Compilation failed${NC}"; exit 1; }

echo -e "Compilation Completed..."

# Validate test cases exist
if [ ! -f "$input_file" ] || [ ! -f "$expected_file" ]; then
  echo -e "${RED}Error: test_cases.txt or output.txt missing in $dir${NC}"
  exit 1
fi

# Run binary, pipe input, and save actual output
if ! "$output_bin" < "$input_file" > "$actual_file"; then
  echo -e "${RED}Execution failed (Runtime Error / Crash)${NC}"
  exit 1
fi

# Compare actual output and expected output line-by-line using paste and awk
paste "$actual_file" "$expected_file" | awk -F'\t' -v green="$GREEN" -v red="$RED" -v nc="$NC" '
BEGIN {
    # Print the table header
    printf "%-15s | %-15s | %s\n", "Myoutput", "expected", "verdict"
    print "--------------------------------------------------"
}
{
    actual = $1
    expected = $2

    # Trim leading and trailing whitespaces for clean comparison
    gsub(/^[ \t]+|[ \t]+$/, "", actual)
    gsub(/^[ \t]+|[ \t]+$/, "", expected)
    
    # Ignore completely empty lines at the end of both files
    if (actual == "" && expected == "") {
        next
    }

    # Determine verdict
    if (actual == expected) {
        verdict = green "PASSED" nc
    } else {
        verdict = red "FAILED" nc
    }
    
    # Print formatted row
    printf "%-15s | %-15s | %s\n", actual, expected, verdict
}'

exit 0
