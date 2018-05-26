#!/bin/bash


# setting up a protection system for protecting immediate subdirectories of selected directories


## find files and folders that are newer than their respective PAR2 files

find . -type f -name ".PAR2PROTECT_DPT1" -exec bash -c '
    cd "$( dirname "$1" )" && 
    find . -mindepth 1 -maxdepth 1 -type d -exec bash -c '"'"'
        cd "$1" && 
        find "$(pwd)" -newer PAR2.par2 
    '"'"' _ {""} ";" 
' _ {} ";" 


# setting up a protection system for protecting files in selected directories without recursion


## find files and folders that are newer than their respective PAR2 files

find . -type f -name ".PAR2PROTECT_NOR" -exec bash -c '
    cd "$( dirname "$1" )" && 
    { 
        find "$(pwd)" -maxdepth 0  -type d -newer PAR2.par2 ; 
        find "$(pwd)" -maxdepth 1 -type f -newer PAR2.par2 ; 
    } 
' _ {} ";" 

