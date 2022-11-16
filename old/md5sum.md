
# md5sum

Detects bitrot. Doesn't compare mtime so it reports as corrupted both bitrotten and intentionally changed files.

Use sha256sum instead, if you want to trade security for performance.

## generate hashes

`find . -xdev -type f -exec md5sum "{}" "+" > md5sum.txt`

or

`rm -f md5.txt ; find . -type f -not -path './md5.txt' -exec md5sum '{}' ';' > md5.txt`

## check for changed and missing files

`LANG=C md5sum --quiet -c md5sum.txt`

or recursively

`find . -type f -iname 'md5*.txt' -exec bash -c 'cd "$( dirname "$1" )" && { md5sum --quiet -c md5*txt || { echo "ERROR in $PWD"; echo ;  } ; } ;' _ '{}' ';'`

## check for changed files only

`LANG=C md5sum --quiet -c md5sum.txt 2>/dev/null | grep -E 'FAILED$'`

