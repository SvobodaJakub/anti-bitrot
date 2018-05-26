#!/bin/bash

echo "This is a dangerous operation. Modify this script if you really want to do this."
exit 1

echo "This is a dangerous operation. Wait 30 seconds if you really want to do this, or ctrl+c NOW to stop it."
sleep 30

# setting up a protection system for protecting immediate subdirectories of selected directories


## re-create PAR2 files in immediate subdirectories for those directories where there is a ".PAR2PROTECT_DPT1"

find . -type f -name ".PAR2PROTECT_DPT1" -exec bash -c '
    echo "$1" ; 
    cd "$( dirname "$1" )" && 
    pwd && 
    find . -mindepth 1 -maxdepth 1 -type d -exec bash -c '"'"'
        cd "$1" && 
        pwd && 
        rm -f PAR2.par2 PAR2.vol*.par2 ; 
        par2create -aPAR2 -r2 -n1 -u -R -- .
    '"'"' _ {""} ";" 
' _ {} ";" 


# setting up a protection system for protecting files in selected directories without recursion


## re-create PAR2 files for those directories where there is a ".PAR2PROTECT_NOR"

find . -type f -name ".PAR2PROTECT_NOR" -exec bash -c '
    echo "$1" ; 
    cd "$( dirname "$1" )" && 
    pwd && 
    rm -f PAR2.par2 PAR2.vol*.par2 ; 
    par2create -aPAR2 -r2 -n1 -u -R -- . 
' _ {} ";" 

