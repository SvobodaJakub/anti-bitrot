#!/bin/bash

# generates hashsums of the specified directory into the specified file
# usage:
# ./generate_file_hashes.sh /dir/to/be/scanned ./output_file.txt


# exit on empty variables
set -u

# exit on non-zero status
set -e

# obtain the absolute path of the output file
OUT=$( realpath "$2" ; )

# cd to the dir whose files are being hashed so that the paths are always reported as beginning with just "./"
cd "$1"

find . -xdev -type f -exec md5sum "{}" "+" > "$OUT" || true


