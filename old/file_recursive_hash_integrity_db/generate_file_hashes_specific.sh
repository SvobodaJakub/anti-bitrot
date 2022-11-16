#!/bin/bash

# generates hashsums of files in the specified directory and generates reports of changes and saves all these info into the specified directory 
# usage:
# ./generate_file_hashes_specific.sh /dir/to/be/scanned ./hash/database/dir

# exit on empty variables
set -u

# exit on non-zero status
set -e

echo "$1 -> $2"

# obtain the absolute paths
WATCHEDDIR=$( realpath "$1" ; )  # capture hashes of the files in this folder
SAVEDIR=$( realpath "$2" ; )  # save hashes and reports to this folder
mkdir -p "$SAVEDIR"
cd "$SAVEDIR"

# obtain the absolute path to this script and the other scripts
scriptdirname=$( realpath $( dirname "$0" ; ) ; )
TOOLGEN="$scriptdirname/generate_file_hashes.sh"
TOOLCHNG="$scriptdirname/detect_changes.py"

# the filename prefix for the reports
now=$(date +"%y%m%d_%H%M%S")

# create an empty first file if the output folder is empty (so that there is something to compare to and the report-generating tool doesn't throw up)
ls -1 "??????_??????_hashes.txt" || { touch 000000_000000_hashes.txt ; }

# previous state to compare to
prevlastfile="$SAVEDIR/$(ls -1 ??????_??????_hashes.txt | tail -n 1 ; )"
# current state to capture
lastfile="$SAVEDIR/${now}_hashes.txt"

# capture the state
"$TOOLGEN" "$WATCHEDDIR" "$lastfile"

# compare the two states and generate reports
cd "$SAVEDIR"
"$TOOLCHNG" "$prevlastfile" "$lastfile" "${now}"

# copy the reports also under fixed names so that they can be easily copied by other tools
cp "$SAVEDIR/${now}_new.txt" "$SAVEDIR/last_new.txt"
cp "$SAVEDIR/${now}_deleted.txt" "$SAVEDIR/last_deleted.txt"
cp "$SAVEDIR/${now}_new_wo_moved_or_dups.txt" "$SAVEDIR/last_new_wo_moved_or_dups.txt"
cp "$SAVEDIR/${now}_deleted_wo_moved_or_dups.txt" "$SAVEDIR/last_deleted_wo_moved_or_dups.txt"
cp "$SAVEDIR/${now}_moved.txt" "$SAVEDIR/last_moved.txt"
cp "$SAVEDIR/${now}_changed.txt" "$SAVEDIR/last_changed.txt"

# delete hash db files older than the the last 8 sets
cd "$SAVEDIR" && rm -f $( ls -1 ??????_??????_hashes.txt | grep -vF -f <( ls -1 ??????_??????_hashes.txt | tail -n 8 ; ) | sed -r 's/_hashes\.txt$/*/' ; ) || true


