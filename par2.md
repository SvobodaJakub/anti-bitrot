
# par2cmdline

Detects and repairs bitrot. Generates error-correcting codes for specified files into par2 files. Doesn't compare mtime so it reports as corrupted both bitrotten and intentionally changed files.

# prerequisite

https://github.com/Parchive/par2cmdline/

# warning

It utterly breaks if a directory in path has `"` in name and it is insecure against BASH command injection in directory names.

TODO: create a helper script that would be called from `find` and would eliminate the vulnerability.

## create PAR2 files in immediate subdirectories

`find . -mindepth 1 -maxdepth 1 -type d -exec bash -c 'cd "{}" ; pwd ; [[ -e "PAR2.par2" ]] || par2create -aPAR2 -r2 -u -R -- .' ';' `

Handy e.g. for photos that are organized in a flat structure of subfolders named by date or by event name with the occassional subsubdirectories. Not good for a deep tree structure. It creates PAR2 files in the immediate subdirectories for all files inside the subdirectories recursively (the PAR2 files are placed only in the immediate subdirs and files are watched recursively to the deepest subdirs).

Set to 2% size of the original data (`-r2`). Skips if `PAR2.par2` already exists (`[[ -e "PAR2.par2" ]] || `).

If it complains about block size, you probably have too many files and need to adjust the parameters (`man par2`).

## recursively check PAR2 files

`find . -type d -exec bash -c 'cd "{}" ; pwd ; [[ -e "PAR2.par2" ]] && par2verify -q PAR2.par2 ' ';' > /tmp/par2verify.log`

## see whether something needs repair

`grep -E 'missing|no data found|damaged|Repair is required' /tmp/par2verify.log`

## recursively check PAR2 files without logging to a file

`find . -type d -exec bash -c 'cd "{}" ; [[ -e "PAR2.par2" ]] && { par2verify -q PAR2.par2 || pwd ; } | tail -n 2' ';'`

Prints the final messages of par2verify and also prints the directory if there is an error.

## recursively check and repair PAR2 files

`find . -type d -exec bash -c 'cd "{}" ; pwd ; ls "PAR2.par2" && par2repair PAR2.par2 ' ';' > /tmp/par2verify.log`

Beware, it will rename the original corrupted files by appending `.1` to their filenames.

