
# md5sum

I use this to detect all kinds of changes that happen after creating the md5 files (except for detecting new files, which I don't care about). Sometimes, I use a photo manager the wrong way and it modifies photos. Sometimes, I accidentally drag&drop things elsewhere. Sometimes, I accidentaly change or delete files. And sometimes, there's a true transient failure-induced case of bitrot. All of these are trivially detectable by the two following snippets.

MD5 is not cryptographically secure. If that's what you want, use sha256sum. I use md5sum because it's really fast.

These snippets work in GNU/Linux with a bash shell.

## generate hashes

```bash
rm -f md5.txt ; find . -type f -not -path './md5.txt' -exec md5sum '{}' ';' > md5.txt ; exit # create md5
```

## check for changed and missing files

```bash
find . -type f -iname 'md5*.txt' -exec bash -c 'cd "$( dirname "$1" )" && { md5sum --quiet -c md5*txt || { echo "ERROR in $PWD"; echo ;  } ; } ;' _ '{}' ';' # check md5
```

# Windows or Linux GUI

On Windows (or if you want to only use GUI on GNU/Linux), the easiest open-source option is to use [Double Commander](https://github.com/doublecmd/doublecmd) to generate and check MD5 or SHA2_256 files. It works recursively on directories, too. [Here's a how-to with screenshots](https://www.trishtech.com/2021/10/how-to-calculate-file-checksums-with-doublecommander/).
