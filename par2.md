
# par2cmdline

Detects and repairs bitrot. Generates error-correcting codes for specified files into par2 files. Doesn't compare mtime so it reports as corrupted both bitrotten and intentionally changed files.

# prerequisites

* https://github.com/Parchive/par2cmdline/
* GNU find (untested on other variants, it might or might not work)

## create PAR2 file in current directory

`par2create -aPAR2 -r2 -u -R -- .`

## create PAR2 files in immediate subdirectories

`find . -mindepth 1 -maxdepth 1 -type d -exec bash -c 'cd "$1" ; pwd ; [[ -e "PAR2.par2" ]] || par2create -aPAR2 -r2 -u -R -- .' _ {} ';' `

Handy e.g. for photos that are organized in a flat structure of subfolders named by date or by event name with the occassional subsubdirectories. Not good for a deep tree structure. It creates PAR2 files in the immediate subdirectories for all files inside the subdirectories recursively (the PAR2 files are placed only in the immediate subdirs and files are watched recursively to the deepest subdirs).

Set to 2% size of the original data (`-r2`). Skips if `PAR2.par2` already exists (`[[ -e "PAR2.par2" ]] || `).

If it complains about block size, you probably have too many files and need to adjust the parameters (`man par2`).

## recursively check PAR2 files

`find . -type d -exec bash -c 'cd "$1" ; pwd ; [[ -e "PAR2.par2" ]] && par2verify -q PAR2.par2 ; pwd' _ {} ';' > /tmp/par2verify.log`

## see whether something needs repair

`grep -E 'missing|no data found|damaged|Repair is required' -A2 /tmp/par2verify.log`

## recursively check PAR2 files without logging to a file

`find . -type d -exec bash -c 'cd "$1" ; [[ -e "PAR2.par2" ]] && { par2verify -q PAR2.par2 || pwd ; } | tail -n 2' _ {} ';'`

Prints the final messages of par2verify and also prints the directory if there is an error.

## recursively check and repair PAR2 files

`find . -type d -exec bash -c 'cd "$1" ; pwd ; [[ -e "PAR2.par2" ]]  && par2repair PAR2.par2 ' _ {} ';' > /tmp/par2verify.log`

Beware, it will rename the original corrupted files by appending `.1` to their filenames.


# setting up a protection system for protecting immediate subdirectories of selected directories

Extending the above to a semi-automated system.

## create PAR2 files in immediate subdirectories for those directories where there is a ".PAR2PROTECT_DPT1" file

`find . -type f -name ".PAR2PROTECT_DPT1" -exec bash -c 'echo "$1" ; cd "$( dirname "$1" )" && pwd && find . -mindepth 1 -maxdepth 1 -type d -exec bash -c '"'"'cd "$1" && pwd && [[ -e "PAR2.par2" ]] || par2create -aPAR2 -r2 -n1 -u -R -- .'"'"' _ {""} ";" ' _ {} ";" `

This way, it is enough to think once what should be protected on the computer, and create the appropriate ".PAR2PROTECT_DPT1" files. On subsequent runs, new directories are added to the protection.

There's a problem, however - if files are added to an already-protected directory, they are not automatically included in the protection. It is possible to either manually delete PAR2 files in that subdirectory:

`rm -f PAR2.par2 PAR2.vol*.par2`

Or you can first check the other existing PAR2 files and (if they are all ok), re-create all PAR2 files.

## find files and folders that are newer than their respective PAR2 files

`find . -type f -name ".PAR2PROTECT_DPT1" -exec bash -c 'cd "$( dirname "$1" )" && find . -mindepth 1 -maxdepth 1 -type d -exec bash -c '"'"'cd "$1" && find "$PWD" -newer PAR2.par2 '"'"' _ {""} ";" ' _ {} ";" `

## recursively check PAR2 files in immediate subdirectories for those directories where there is a ".PAR2PROTECT_DPT1" file

`find . -type f -name ".PAR2PROTECT_DPT1" -exec bash -c 'echo "$1" ; cd "$( dirname "$1" )" && pwd && find . -mindepth 1 -maxdepth 1 -type d -exec bash -c '"'"'cd "$1" && pwd && [[ -e "PAR2.par2" ]] && par2verify -q PAR2.par2 ; pwd'"'"' _ {""} ";" ' _ {} ";"  > /tmp/par2verify.log`

## see whether something needs repair

`grep -E 'missing|no data found|damaged|Repair is required' -A2 /tmp/par2verify.log`

## recursively check PAR2 files in immediate subdirectories for those directories where there is a ".PAR2PROTECT_DPT1" file without logging to a file

`find . -type f -name ".PAR2PROTECT_DPT1" -exec bash -c 'cd "$( dirname "$1" )" && find . -mindepth 1 -maxdepth 1 -type d -exec bash -c '"'"'cd "$1" && [[ -e "PAR2.par2" ]] && { par2verify -q PAR2.par2 || pwd ; } | tail -n 2 | grep -vF "All files are correct, repair is not required." | grep -vE "^$"  '"'"' _ {""} ";" ' _ {} ";" `

## re-create PAR2 files in immediate subdirectories for those directories where there is a ".PAR2PROTECT_DPT1"

`find . -type f -name ".PAR2PROTECT_DPT1" -exec bash -c 'echo "$1" ; cd "$( dirname "$1" )" && pwd && find . -mindepth 1 -maxdepth 1 -type d -exec bash -c '"'"'cd "$1" && pwd && rm -f PAR2.par2 PAR2.vol*.par2 ; par2create -aPAR2 -r2 -n1 -u -R -- .'"'"' _ {""} ";" ' _ {} ";" `


# setting up a protection system for protecting files in selected directories without recursion

Extending the above to a semi-automated system.

## create PAR2 files for those directories where there is a ".PAR2PROTECT_NOR" file

`find . -type f -name ".PAR2PROTECT_NOR" -exec bash -c 'echo "$1" ; cd "$( dirname "$1" )" && pwd && [[ -e "PAR2.par2" ]] || par2create -aPAR2 -r2 -n1 -u -- *  ' _ {} ";" `

This way, it is enough to think once what should be protected on the computer, and create the appropriate ".PAR2PROTECT_NOR" files. On subsequent runs, new directories are added to the protection.

There's a problem, however - if files are added to an already-protected directory, they are not automatically included in the protection. It is possible to either manually delete PAR2 files in that directory:

`rm -f PAR2.par2 PAR2.vol*.par2`

Or you can first check the other existing PAR2 files and (if they are all ok), re-create all PAR2 files.

## find files and folders that are newer than their respective PAR2 files

`find . -type f -name ".PAR2PROTECT_NOR" -exec bash -c 'cd "$( dirname "$1" )" && { find "$PWD" -maxdepth 0  -type d -newer PAR2.par2 ; find "$PWD" -maxdepth 1 -type f -newer PAR2.par2 ; } ' _ {} ";" `

## recursively check PAR2 files for those directories where there is a ".PAR2PROTECT_NOR" file

`find . -type f -name ".PAR2PROTECT_NOR" -exec bash -c 'echo "$1" ; cd "$( dirname "$1" )" && pwd && [[ -e "PAR2.par2" ]] && par2verify -q PAR2.par2 ; pwd ' _ {} ";"  > /tmp/par2verify.log`

## see whether something needs repair

`grep -E 'missing|no data found|damaged|Repair is required' -A2 /tmp/par2verify.log`

## recursively check PAR2 files for those directories where there is a ".PAR2PROTECT_NOR" file without logging to a file

`find . -type f -name ".PAR2PROTECT_NOR" -exec bash -c 'cd "$( dirname "$1" )" && [[ -e "PAR2.par2" ]] && { par2verify -q PAR2.par2 || pwd ; } | tail -n 2 | grep -vF "All files are correct, repair is not required." | grep -vE "^$"  ' _ {} ";" `

## re-create PAR2 files for those directories where there is a ".PAR2PROTECT_NOR"

`find . -type f -name ".PAR2PROTECT_NOR" -exec bash -c 'echo "$1" ; cd "$( dirname "$1" )" && pwd && rm -f PAR2.par2 PAR2.vol*.par2 ; par2create -aPAR2 -r2 -n1 -u -R -- . ' _ {} ";" `

# why one-liners?

Because I can :)

Also, it's interesting to see which parts of the arguments are evaluated by which programs at the various levels of nesting. Such crazy examples can really test your knowledge of bash string expansion.

**More multi-line scripts are in the `par2` directory.**


