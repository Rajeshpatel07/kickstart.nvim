#!/bin/bash
set -e

# Ensure we are only running C++
[[ "$2" == "cpp" ]] || { echo -e "\033[0;31mError: This script is exclusively for C++.\033[0m"; exit 1; }

# Paths & Variables
d="$3" bin="$d/bin/${1%.*}"
in="$d/test_cases.txt" exp="$d/output.txt" act="$d/actual_output.txt"
R='\033[0;31m' G='\033[0;32m' N='\033[0m' # ANSI Colors

# Compile
mkdir -p "$d/bin"
g++ "$d/$1" -o "$bin" -O2 -std=c++17 -Wall -Weffc++ -Wextra -Wconversion -Wsign-conversion -pedantic-errors || { echo -e "${R}Compilation failed${N}"; exit 1; }
echo -e "Compilation Completed..."

# Validate inputs and execute
[[ -f "$in" && -f "$exp" ]] || { echo -e "${R}Error: test_cases.txt or output.txt missing in $d${N}"; exit 1; }
"$bin" < "$in" > "$act" || { echo -e "${R}Execution failed (Runtime Error / Crash)${N}"; exit 1; }

# Compare output
paste "$act" "$exp" | awk -F'\t' -v G="$G" -v R="$R" -v N="$N" '
BEGIN {
    printf "%-15s | %-15s | %s\n", "Myoutput", "expected", "verdict"
    print "--------------------------------------------------"
}
{
    gsub(/^[ \t]+|[ \t]+$/, "", $1)
    gsub(/^[ \t]+|[ \t]+$/, "", $2)
    
    if ($1 == "" && $2 == "") next
    
    printf "%-15s | %-15s | %s\n", $1, $2, ($1==$2) ? G"PASSED"N : R"FAILED"N
}'
