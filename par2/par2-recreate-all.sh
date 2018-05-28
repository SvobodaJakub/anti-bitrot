#!/bin/bash

scriptdir="$(dirname "$0")"
# get absolute path
scriptdir="$( realpath "$scriptdir" || readlink -f "$scriptdir" || { cd "$scriptdir" >/dev/null 2>&1 || exit 2 ; pwd || exit 2 ; cd - >/dev/null 2>&1  || exit 2 ; } )"

echo "This is a dangerous operation. Wait 30 seconds if you really want to do this, or ctrl+c NOW to stop it."
echo "(Dangerous because you will lose the PAR2 files that can recover your data. First check that there is nothing you want to recover.)"
sleep 30

# setting up a protection system for protecting immediate subdirectories of selected directories


## re-create PAR2 files in immediate subdirectories for those directories where there is a ".PAR2PROTECT_DPT1"

find . -type f -name ".PAR2PROTECT_DPT1" -not -path '*/EXAMPLE-EXCLUDE-PATH/Files/backups-tmp-home/*' -exec bash -c '
    echo "$1" ; 
    cd "$( dirname "$1" )" && 
    pwd && 
    find . -mindepth 1 -maxdepth 1 -type d -exec bash -c '"'"'
        cd "$1" && 
        pwd && 
        rm -f PAR2.par2 PAR2.vol*.par2 ; 
    '"'"' _ {""} ";" 
' _ {} ";" 


# setting up a protection system for protecting files in selected directories without recursion


## re-create PAR2 files for those directories where there is a ".PAR2PROTECT_NOR"

find . -type f -name ".PAR2PROTECT_NOR" -not -path '*/EXAMPLE-EXCLUDE-PATH/Files/backups-tmp-home/*' -exec bash -c '
    echo "$1" ; 
    cd "$( dirname "$1" )" && 
    pwd && 
    rm -f PAR2.par2 PAR2.vol*.par2 ; 
' _ {} ";" 


# create new par2 files in their place

bash "$scriptdir/par2-create.sh"

