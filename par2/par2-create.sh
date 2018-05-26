#!/bin/bash


# setting up a protection system for protecting immediate subdirectories of selected directories

## create PAR2 files in immediate subdirectories for those directories where there is a ".PAR2PROTECT_DPT1" file

# first using default number of blocks


find . -type f -name ".PAR2PROTECT_DPT1" -exec bash -c '
    echo "$1" ; 
    cd "$( dirname "$1" )" && 
    pwd && 
    find . -mindepth 1 -maxdepth 1 -type d -exec bash -c '"'"'
        cd "$1" && 
        pwd && 
        [[ -e "PAR2.par2" ]] || 
            par2create -aPAR2 -r2 -n1 -u -R -- .
    '"'"' _ {""} ";" 
' _ {} ";" 

# some directories have too many files, raise the number of blocks (it lowers the efficiency or speed)

# 4000

find . -type f -name ".PAR2PROTECT_DPT1" -exec bash -c '
    echo "$1" ; 
    cd "$( dirname "$1" )" && 
    pwd && 
    find . -mindepth 1 -maxdepth 1 -type d -exec bash -c '"'"'
        cd "$1" && 
        pwd && 
        [[ -e "PAR2.par2" ]] || 
            par2create -aPAR2 -r2 -n1 -b4000 -u -R -- .
    '"'"' _ {""} ";" 
' _ {} ";" 


# 8000

find . -type f -name ".PAR2PROTECT_DPT1" -exec bash -c '
    echo "$1" ; 
    cd "$( dirname "$1" )" && 
    pwd && 
    find . -mindepth 1 -maxdepth 1 -type d -exec bash -c '"'"'
        cd "$1" && 
        pwd && 
        [[ -e "PAR2.par2" ]] || 
            par2create -aPAR2 -r2 -n1 -b8000 -u -R -- .
    '"'"' _ {""} ";" 
' _ {} ";" 


# 16000

find . -type f -name ".PAR2PROTECT_DPT1" -exec bash -c '
    echo "$1" ; 
    cd "$( dirname "$1" )" && 
    pwd && 
    find . -mindepth 1 -maxdepth 1 -type d -exec bash -c '"'"'
        cd "$1" && 
        pwd && 
        [[ -e "PAR2.par2" ]] || 
            par2create -aPAR2 -r2 -n1 -b16000 -u -R -- .
    '"'"' _ {""} ";" 
' _ {} ";" 


# 32000

find . -type f -name ".PAR2PROTECT_DPT1" -exec bash -c '
    echo "$1" ; 
    cd "$( dirname "$1" )" && 
    pwd && 
    find . -mindepth 1 -maxdepth 1 -type d -exec bash -c '"'"'
        cd "$1" && 
        pwd && 
        [[ -e "PAR2.par2" ]] || 
            par2create -aPAR2 -r2 -n1 -b32000 -u -R -- .
    '"'"' _ {""} ";" 
' _ {} ";" 



# setting up a protection system for protecting files in selected directories without recursion

## create PAR2 files for those directories where there is a ".PAR2PROTECT_NOR" file


find . -type f -name ".PAR2PROTECT_NOR" -exec bash -c '
    echo "$1" ; 
    cd "$( dirname "$1" )" && 
    pwd && 
    [[ -e "PAR2.par2" ]] || 
        par2create -aPAR2 -r2 -n1 -u -- *  
' _ {} ";" 

# some directories have too many files, raise the number of blocks (it lowers the efficiency or speed)

# 4000

find . -type f -name ".PAR2PROTECT_NOR" -exec bash -c '
    echo "$1" ; 
    cd "$( dirname "$1" )" && 
    pwd && 
    [[ -e "PAR2.par2" ]] || 
        par2create -aPAR2 -r2 -n1 -b4000 -u -- *  
' _ {} ";" 


# 8000

find . -type f -name ".PAR2PROTECT_NOR" -exec bash -c '
    echo "$1" ; 
    cd "$( dirname "$1" )" && 
    pwd && 
    [[ -e "PAR2.par2" ]] || 
        par2create -aPAR2 -r2 -n1 -b8000 -u -- *  
' _ {} ";" 


# 16000

find . -type f -name ".PAR2PROTECT_NOR" -exec bash -c '
    echo "$1" ; 
    cd "$( dirname "$1" )" && 
    pwd && 
    [[ -e "PAR2.par2" ]] || 
        par2create -aPAR2 -r2 -n1 -b16000 -u -- *  
' _ {} ";" 


# 32000

find . -type f -name ".PAR2PROTECT_NOR" -exec bash -c '
    echo "$1" ; 
    cd "$( dirname "$1" )" && 
    pwd && 
    [[ -e "PAR2.par2" ]] || 
        par2create -aPAR2 -r2 -n1 -b32000 -u -- *  
' _ {} ";" 






