#!/bin/env python3

# Detects changes in files based on two outputs of sha256sum or md5sum or a similar tool.
# Generates reports in the current directory.

import os
import sys

hash_list_filename_old = sys.argv[1]  # e.g. filename of the output of `md5sum`
hash_list_filename_new = sys.argv[2]  # e.g. filename of the output of `md5sum`
output_filename_base = sys.argv[3]  # e.g. 171230_123456, so that it produces outputs like 171230_123456_changed.txt
current_path = os.getcwd()

list_files_old = []
list_files_new = []
set_files_old = set()
set_files_new = set()
hashes_files_old = {}
hashes_files_new = {}
set_hashes_old = set()
set_hashes_new = set()
paths_hashes_old = {}
paths_hashes_new = {}

with open(os.path.join(current_path, hash_list_filename_old), "r") as f:
    for line in f:
        fhash, fpath = line.strip().split(None, 1)
        fhash = fhash.strip()
        fpath = fpath.strip()
        list_files_old.append(fpath)
        set_files_old.add(fpath)
        hashes_files_old[fpath] = fhash
        set_hashes_old.add(fhash)
        paths_hashes_old[fhash] = fpath

with open(os.path.join(current_path, hash_list_filename_new), "r") as f:
    for line in f:
        fhash, fpath = line.strip().split(None, 1)
        fhash = fhash.strip()
        fpath = fpath.strip()
        list_files_new.append(fpath)
        set_files_new.add(fpath)
        hashes_files_new[fpath] = fhash
        set_hashes_new.add(fhash)
        paths_hashes_new[fhash] = fpath

new_paths = set()
with open(os.path.join(current_path, output_filename_base + "_new.txt"), "w") as f:
    for fpath in list_files_new:
        if fpath not in set_files_old:
            new_paths.add(fpath)
            f.write(fpath)
            f.write("\n")

with open(os.path.join(current_path, output_filename_base + "_deleted.txt"), "w") as f:
    for fpath in list_files_old:
        if fpath not in set_files_new:
            f.write(fpath)
            f.write("\n")

with open(os.path.join(current_path, output_filename_base + "_new_wo_moved_or_dups.txt"), "w") as f:
    for fpath in list_files_new:
        if fpath not in set_files_old:
            fhash = hashes_files_new[fpath]
            if fhash not in set_hashes_old:
                f.write(fpath)
                f.write("\n")

with open(os.path.join(current_path, output_filename_base + "_deleted_wo_moved_or_dups.txt"), "w") as f:
    for fpath in list_files_old:
        if fpath not in set_files_new:
            fhash = hashes_files_old[fpath]
            if fhash not in set_hashes_new:
                f.write(fpath)
                f.write("\n")

with open(os.path.join(current_path, output_filename_base + "_moved.txt"), "w") as f:
    for fpath in list_files_old:
        if fpath not in set_files_new:
            fhash = hashes_files_old[fpath]
            if fhash in set_hashes_new:
                for fpath_new in new_paths:
                    fhash_new = hashes_files_new[fpath_new]
                    if fhash_new == fhash:
                        break
                else:
                    # can't find the same hash among new paths, strange - so just find any path that has the hash
                    fpath_new = paths_hashes_new[fhash]
                f.write(fpath)
                f.write(" -> ")
                f.write(fpath_new)
                f.write("\n")

with open(os.path.join(current_path, output_filename_base + "_changed.txt"), "w") as f:
    for fpath in list_files_old:
        if fpath in set_files_new:
            fhash = hashes_files_old[fpath]
            fhash_new = hashes_files_new[fpath]
            if fhash != fhash_new:
                f.write(fpath)
                f.write("\n")


