#!/bin/bash

# Usage: run-code.sh <filename> <language> <directory>
# Runs code based on language, compiling to bin/ if needed

set -e

# Check arguments
if [ "$#" -ne 3 ]; then
  echo "Error: Usage: $0 <filename> <language> <directory>" >&2
  exit 1
fi

filename="$1"
language="$2"
dir="$3"
bin_dir="$dir/bin"
# Validate file exists
if [ ! -f "$dir/$filename" ]; then
  echo "Error: File $dir/$filename not found" >&2
  exit 1
fi


# Handle languages
case "$language" in
  c)
    mkdir -p "$bin_dir"
    output="$bin_dir/${filename%.*}"
    gcc "$dir/$filename" -o "$output" -O1 -Wall || { echo "Compilation failed" >&2; exit 1; }
    "$output"
    ;;
  cpp)
    mkdir -p "$bin_dir"
    output="$bin_dir/${filename%.*}"
    g++ "$dir/$filename" -o "$output" -O1 -Wall || { echo "Compilation failed" >&2; exit 1; }
    "$output"
    ;;
  typescript|javascript)
    bun "$dir/$filename" || { echo "Bun execution failed" >&2; exit 1; }
    ;;
  lua)
    lua "$dir/$filename" || { echo "Lua execution failed" >&2; exit 1; }
    ;;
  python)
    python3 "$dir/$filename" || { echo "Python execution failed" >&2; exit 1; }
    ;;
  go)
    mkdir -p "$bin_dir"
    output="$bin_dir/${filename%.*}"
    go build -o "$output" "$dir/$filename" || { echo "Go build failed" >&2; exit 1; }
    "$output"
    ;;
  *)
    echo "Error: Unsupported language: $language" >&2
    echo "Supported: c, cpp, typescript, javascript, lua, python, go" >&2
    exit 1
    ;;
esac

exit 0
