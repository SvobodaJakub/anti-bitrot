
# cshatag

Detects bitrot. Saves sha256 and mtime into file extended attributes (xattrs) and detects bitrot on subsequent runs by comparing the saved and current sha256 and mtime.

# prerequisite

https://github.com/rfjakob/cshatag

## recursively tag files in current directory

`ionice -c 3 find . -xdev -type f -exec cshatag {} \; > cshatag.log`

## check for bitrot in the last log

`grep -E '^<corrupt>' cshatag.log`

It *has to* be done after *every* `cshatag` run because it reports corrupted files only once and then it fixes the xattr to match the file contents.

## check for non-bitrot changes in folders that are supposed to stay mostly unchanged

`grep outdated cshatag.log | grep -E "GoogleDrive/backups|Dropbox/backups|Pictures/Archive|Documents/long-term"`

