#!/bin/bash


# setting up a protection system for protecting immediate subdirectories of selected directories

## create PAR2 files in immediate subdirectories for those directories where there is a ".PAR2PROTECT_DPT1" file



# If there is a lot of protected data (e.g. a few large files and many very small files) and the par2 is created with a low number of blocks (the default is 2000), then each block is large and small files take as much as an entire block each and the resulting PAR2 file can be exceedingly large in some cases. Raising the block count limits this effect. On the other hand, protecting a small amount of data using too many blocks results in a few MB of wasted space, so setting the block count to the maximum outright might not be good either. So a simple logic is used to decide the number of blocks.

find . -type f -name ".PAR2PROTECT_DPT1" -not -path '*/EXAMPLE-EXCLUDE-PATH/Files/backups-tmp-home/*' -exec bash -c '
    echo "$1" ; 
    cd "$( dirname "$1" )" && 
    pwd && 
    find . -mindepth 1 -maxdepth 1 -type d -exec bash -c '"'"'
        cd "$1" && 
        pwd && 
        if [[ ! -e "PAR2.par2" ]] ; then
            _kbytes="$( du -B 1024 -s . | cut -f1 ; )" ;
            _mbytes="$( du -B 1048576 -s . | cut -f1 ; )" ;
            _files="$( find . -type f | wc -l ; )" ;
            _percent="3" ;
            _minblocks="200" ;
            if [[ "${_kbytes}" == "" ]] ; then
                _kbytes="300000" ;
            fi ;
            if [[ "${_mbytes}" == "" ]] ; then
                _mbytes="300" ;
            fi ;
            if [[ "${_files}" == "" ]] ; then
                _files="500" ;
            fi ;
            if (( _mbytes > 20 || _files > 30 )) ; then
                _minblocks="2000" ;
            fi ;
            if (( _mbytes > 100 || _files > 200 )) ; then
                _minblocks="4000" ;
            fi ;
            if (( _mbytes > 200 || _files > 400 )) ; then
                _minblocks="8000" ;
            fi ;
            if (( _mbytes > 400 || _files > 800 )) ; then
                _minblocks="16000" ;
            fi ;
            if (( _mbytes > 800 || _files > 1600 )) ; then
                _minblocks="32767" ;
            fi ;
            if (( _mbytes > 20 && _files < 31 )) ; then
                _minblocks="2000" ;
            fi ;
            if (( _kbytes < 1500 )) ; then
                _percent="10" ;
            fi ;
            if (( _kbytes < 150 )) ; then
                _percent="50" ;
            fi ;
            if (( _kbytes < 50 )) ; then
                _percent="100" ;
            fi ;
            par2create -aPAR2 -r"${_percent}" -n1 -b"${_minblocks}" -u -R -- . ||
            par2create -aPAR2 -r"${_percent}" -n1 -b32767 -u -R -- . ;
        fi ;
    '"'"' _ {""} ";" 
' _ {} ";" 




# setting up a protection system for protecting files in selected directories without recursion

## create PAR2 files for those directories where there is a ".PAR2PROTECT_NOR" file


find . -type f -name ".PAR2PROTECT_NOR" -not -path '*/EXAMPLE-EXCLUDE-PATH/Files/backups-tmp-home/*' -exec bash -c '
    echo "$1" ; 
    cd "$( dirname "$1" )" && 
    pwd && 
    if [[ ! -e "PAR2.par2" ]] ; then
        _kbytes="$( find . -maxdepth 1 -type f -print0 | du -s -B 1 --files0-from=- | awk '"'"'{ total += $1} END { printf "%.0f\n", total/1024 }'"'"' ;)" ;
        _mbytes="$( find . -maxdepth 1 -type f -print0 | du -s -B 1 --files0-from=- | awk '"'"'{ total += $1} END { printf "%.0f\n", total/1048576 }'"'"' ;)" ;
        _files="$( find . -maxdepth 1 -type f | wc -l ; )" ;
        _percent="3" ;
        _minblocks="200" ;
        if [[ "${_kbytes}" == "" ]] ; then
            _kbytes="300000" ;
        fi ;
        if [[ "${_mbytes}" == "" ]] ; then
            _mbytes="300" ;
        fi ;
        if [[ "${_files}" == "" ]] ; then
            _files="500" ;
        fi ;
        if (( _mbytes > 20 || _files > 30 )) ; then
            _minblocks="2000" ;
        fi ;
        if (( _mbytes > 100 || _files > 200 )) ; then
            _minblocks="4000" ;
        fi ;
        if (( _mbytes > 200 || _files > 400 )) ; then
            _minblocks="8000" ;
        fi ;
        if (( _mbytes > 400 || _files > 800 )) ; then
            _minblocks="16000" ;
        fi ;
        if (( _mbytes > 800 || _files > 1600 )) ; then
            _minblocks="32767" ;
        fi ;
        if (( _mbytes > 20 && _files < 31 )) ; then
            _minblocks="2000" ;
        fi ;
        if (( _kbytes < 1500 )) ; then
            _percent="10" ;
        fi ;
        if (( _kbytes < 150 )) ; then
            _percent="50" ;
        fi ;
        if (( _kbytes < 50 )) ; then
            _percent="100" ;
        fi ;
        par2create -aPAR2 -r"${_percent}" -n1 -b"${_minblocks}" -u -- * ||
        par2create -aPAR2 -r"${_percent}" -n1 -b32767 -u -- * ;
    fi ;
' _ {} ";" 







