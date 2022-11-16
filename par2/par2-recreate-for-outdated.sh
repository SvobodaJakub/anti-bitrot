#!/bin/bash

scriptdir="$(dirname "$0")"
# get absolute path
scriptdir="$( realpath "$scriptdir" || readlink -f "$scriptdir" || { cd "$scriptdir" >/dev/null 2>&1 || exit 2 ; pwd || exit 2 ; cd - >/dev/null 2>&1  || exit 2 ; } )"

echo "This is a dangerous operation. Wait 30 seconds if you really want to do this, or ctrl+c NOW to stop it."
echo "(Dangerous because you will lose the PAR2 files that can recover your data. First check that there is nothing you want to recover.)"
sleep 30


# Compatible with versions of these utilities from Fedora.
command -v par2verify >/dev/null 2>&1 || { echo >&2 "par2cmdline not installed, aborting."; exit 1; }
command -v par2create >/dev/null 2>&1 || { echo >&2 "par2cmdline not installed, aborting."; exit 1; }
command -v find >/dev/null 2>&1 || { echo >&2 "find not installed, aborting."; exit 1; }
command -v du >/dev/null 2>&1 || { echo >&2 "du not installed, aborting."; exit 1; }
command -v pwd >/dev/null 2>&1 || { echo >&2 "pwd not installed, aborting."; exit 1; }
command -v awk >/dev/null 2>&1 || { echo >&2 "awk not installed, aborting."; exit 1; }


# setting up a protection system for protecting immediate subdirectories of selected directories


## find files and folders that are newer than their respective PAR2 files and delete the PAR2 files there

find . -type f -name ".PAR2PROTECT_DPT1" -not -path '*/EXAMPLE-EXCLUDE-PATH/Files/backups-tmp-home/*' -exec bash -c '
    cd "$( dirname "$1" )" && 
    find . -mindepth 1 -maxdepth 1 -type d -exec bash -c '"'"'
        cd "$1" && 
        if [[ -e "PAR2.par2" ]] ; then
            if [[ "$( find "$(pwd)" -newer PAR2.par2 )" != "" ]] ; then
                pwd && 
                rm -f PAR2.par2 PAR2.vol*.par2 ; 
            fi ;
        fi ;
    '"'"' _ {""} ";" 
' _ {} ";" 


# setting up a protection system for protecting files in selected directories without recursion


## find files and folders that are newer than their respective PAR2 files and delete the PAR2 files there

find . -type f -name ".PAR2PROTECT_NOR" -not -path '*/EXAMPLE-EXCLUDE-PATH/Files/backups-tmp-home/*' -exec bash -c '
    cd "$( dirname "$1" )" && 
    if [[ -e "PAR2.par2" ]] ; then
        if [[ "$( 
            { 
                find "$(pwd)" -maxdepth 0  -type d -newer PAR2.par2 ; 
                find "$(pwd)" -maxdepth 1 -type f -newer PAR2.par2 ; 
            } 
        )" != "" ]] ; then
            pwd && 
            rm -f PAR2.par2 PAR2.vol*.par2 ; 
        fi ;
    fi ;
' _ {} ";" 



# create new par2 files in their place

bash "$scriptdir/par2-create.sh"

