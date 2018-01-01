#!/bin/bash


# exit on empty variables
set -u

# exit on non-zero status
set -e

TOOLPATH="/home/user/.local/bin/file_recursive_hash_integrity_db"
TOOLGEN="$TOOLPATH/generate_file_hashes_specific.sh"


#bash "$TOOLGEN" "watched path" "save state in a directory by this name in current dir"
bash "$TOOLGEN" "/home/user/Pictures" "Pictures"
bash "$TOOLGEN" "/home/user/Documents" "Documents"
bash "$TOOLGEN" "/home/user/SomeImportantData" "SomeImportantData"


origdir=$( pwd ; )

cd "$origdir"
for d in * ; do
    cd "$d" 2>/dev/null && cd ..  && cp "$d/last_new.txt" "./o_new_${d}.txt" && cp "$d/last_deleted.txt" "./o_deleted_${d}.txt" && cp "$d/last_new_wo_moved_or_dups.txt" "./o_new_wo_moved_or_dups_${d}.txt" && cp "$d/last_deleted_wo_moved_or_dups.txt" "./o_deleted_wo_moved_or_dups_${d}.txt" && cp "$d/last_moved.txt" "./o_moved_${d}.txt" && cp "$d/last_changed.txt" "./o_changed_${d}.txt" || true
    cd "$origdir"
done



