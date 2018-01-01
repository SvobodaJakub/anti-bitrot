
# md5sum

Detects bitrot. Doesn't compare mtime so it reports as corrupted both bitrotten and intentionally changed files.

Use sha256sum instead, if you want to trade security for performance.

## generate hashes

`find . -xdev -type f -exec md5sum "{}" "+" > md5sum.txt`

## check for changed and missing files

`LANG=C md5sum --quiet -c md5sum.txt`

## check for changed files only

`LANG=C md5sum --quiet -c md5sum.txt 2>/dev/null | grep -E 'FAILED$'`

