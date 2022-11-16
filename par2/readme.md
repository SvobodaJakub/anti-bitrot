# PAR2

A [Parchive](https://en.wikipedia.org/wiki/Parchive) is a file containing error-correcting codes. PAR2 is a particular format that is the (currently and for the past ~20 years) most-used Parchive format. Except for RAR's *Volume recovery* `.rev` files and *Recovery record* inside `.rar` files, there are no other **as widely** used error-correction formats in existence.

# Linux

The scripts in this directory recursively scan for files `.PAR2PROTECT_DPT1` and `.PAR2PROTECT_NOR` and check or create PAR2 files. For `.PAR2PROTECT_DPT1`, it's in first-level subdirectories relative to the `.PAR2PROTECT_DPT1` files (each subdirectory is then protected recursively into a single set of PAR2 files in the first-level subdirectory), and for `.PAR2PROTECT_NOR`, it creates PAR2 files protecting files in the same directory as each `.PAR2PROTECT_NOR` file.

The scripts try to be smart about choosing block count so that the right balance between efficiency and performance is chosen. The more blocks, the slower the PAR2 operations are, but the less blocks, especially with small files, the less space-efficient the PAR2 files are.

The scripts require [par2cmdline](https://github.com/Parchive/par2cmdline), `bash`, and GNU `find`.

* `par2-create.sh` recursively creates PAR2 files.
* `par2-check.sh` recursively checks PAR2 files and immediately prints output without too much detail.
* `par2-check-and-log.sh` recursively checks PAR2 files, logs full output to `/tmp/par2verify.log`, and once the checks are finished, prints relevant excerpts to the terminal. Obviously, don't run multiple instances of this script concurrently, because they would overwrite their logs and neither would provide useful results.
* `par2-check-and-log-2.sh` is the same, but logs to `/tmp/par2verify2.log`
* `par2-list-newer-files.sh` lists files and directories that were changed more recently than their respective PAR2 files. This can help you identify which PAR2 files need regenerating to cover newly-added files.
* `par2-recreate-for-outdated.sh` regenerates PAR2 files in directories with changes more recent than the respective PAR2 files.

I use the scripts like this:

* Create empty `.PAR2PROTECT_DPT1` and `.PAR2PROTECT_NOR` files where I need them.
* Run `par2-create.sh` to create the PAR2 files to protect the data.
* Before doing changes in a directory, I run `par2-check-and-log.sh`. Usually, I run it from one directory up to make sure it picks up the `.PAR2PROTECT_DPT1` and `.PAR2PROTECT_NOR` files correctly.
* Once in a while, I run `par2-list-newer-files.sh` to see where I made changes and forgot about the PAR2 files.
* Once in a while or always before regenerating files, I run `par2-check-and-log.sh` and review the output. Most of the times, all reported errors are due to deliberate operations (file changes, file deletes). Sometimes, I see something that was not deliberate, and this is my chance to recover directly from PAR2 files, or from backups. I do this often enough so that I vaguely remember what I changed in the protected directories, so that it isn't confusing for me. For recovery, I use `par2repair` directly.
* When I'm sure the integrity of my files is OK, I run `par2-recreate-for-outdated.sh`.


# Windows

Try [QuickPar](https://en.wikipedia.org/wiki/QuickPar) or [MultiPar](https://github.com/Yutaka-Sawada/MultiPar). QuickPar is the original widely-used tool, while MultiPar is a separate newer tool that handles Unicode correctly and identically to par2cmdline. I prefer MultiPar.
