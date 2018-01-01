
# file_recursive_hash_integrity_db

A simple tool for detecting changes in selected directories. File hashes are stored in flat files in a specified directory.

Pros: Doesn't pollute the watched directories with any more files, stores the hashes in a centralised manner. Doesn't need xattrs.

Cons: When you move the watched directory somewhere else, you have to adjust the `scan_...` script. Doesn't work nicely with watched removable media and multiple computers.

## Setup

* Copy `scan_EXAMPLE.sh` under a new descriptive name and change the watched path.
* Change TOOLPATH so that it leads to the directory with the other scripts.
* Set up your scripts / cron / whatever so that the `scan_...` script is run in such a current directory where you want the state saved in.
* If you need to trade security for performance, change `md5sum` to `sha256sum` in `generate_file_hashes.sh`. `md5sum` was originally chosen because it is extremely fast and good enough for bitrot detection.

## License

GNU GENERAL PUBLIC LICENSE Version 3

See the file `LICENSE`.