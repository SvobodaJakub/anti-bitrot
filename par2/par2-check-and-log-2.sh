#!/bin/bash


# Compatible with versions of these utilities from Fedora.
command -v par2verify >/dev/null 2>&1 || { echo >&2 "par2cmdline not installed, aborting."; exit 1; }
command -v par2create >/dev/null 2>&1 || { echo >&2 "par2cmdline not installed, aborting."; exit 1; }
command -v find >/dev/null 2>&1 || { echo >&2 "find not installed, aborting."; exit 1; }
command -v du >/dev/null 2>&1 || { echo >&2 "du not installed, aborting."; exit 1; }
command -v pwd >/dev/null 2>&1 || { echo >&2 "pwd not installed, aborting."; exit 1; }
command -v awk >/dev/null 2>&1 || { echo >&2 "awk not installed, aborting."; exit 1; }


# setting up a protection system for protecting immediate subdirectories of selected directories

## recursively check PAR2 files in immediate subdirectories for those directories where there is a ".PAR2PROTECT_DPT1" file

find . -type f -name ".PAR2PROTECT_DPT1" -not -path '*/EXAMPLE-EXCLUDE-PATH/Files/backups-tmp-home/*' -exec bash -c '
    echo "$1" ; 
    cd "$( dirname "$1" )" && 
    pwd && 
    find . -mindepth 1 -maxdepth 1 -type d -exec bash -c '"'"'
        cd "$1" && 
        pwd && 
        [[ -e "PAR2.par2" ]] && 
            par2verify -q PAR2.par2 ; 
        pwd
    '"'"' _ {""} ";" 
' _ {} ";"  > /tmp/par2verify2.log



# setting up a protection system for protecting files in selected directories without recursion

## recursively check PAR2 files for those directories where there is a ".PAR2PROTECT_NOR" file

find . -type f -name ".PAR2PROTECT_NOR" -not -path '*/EXAMPLE-EXCLUDE-PATH/Files/backups-tmp-home/*' -exec bash -c '
    echo "$1" ; 
    cd "$( dirname "$1" )" && 
    pwd && 
    [[ -e "PAR2.par2" ]] && 
        par2verify -q PAR2.par2 ; 
    pwd 
' _ {} ";"  >> /tmp/par2verify2.log

## see whether something needs repair

grep -E ' - missing| - no data found| - damaged|Repair is required' -A2 /tmp/par2verify2.log

