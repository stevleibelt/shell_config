# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [Open]

### To Add

#### Priority High

* unify all `show`, `display` and `watch` commands
* for all video conversion
    * create directories "in_progres", "done" and "with_error" (last one maybe)
    * add handling for sighalt
    * move functions into `_source/function/media/video`
* implement usage of `net_bazzline_run_in_parallel_when_available` for image processing
    * `ls *.wav | parallel ffmpeg -i {} {.}.flac`
    * [see](https://www.freecodecamp.org/news/how-to-supercharge-your-bash-workflows-with-gnu-parallel-53aab0aea141/)
* *if* zfs is installed and root pool configured
    * make a snapshot before the upgrade and delete previous one
* create a function called "organize_dcim" which
    * loops starting from $(current_year - 10) until $(current_year) (if no argument provided)
    * checks if there are files matching the pattern "*_201910_*
    * if there is at least one file (grep -c)
    * check if there is a directory called "2019_10" and creates if it does not exist
    * moves all files for the pattern into this path
* create a unified backup function
    * creates a file ~/.config/net_bazzline/last_backup_to_$hostname
    * expectes following list of arguments
        * target\_hostname
        * target\_path
        * target\_ssh_key_path
        * target\_username
        * source\_path [source\_path[...]]
    * handles the synchronisation by using rsync

#### Priority Medium

* extend "cd"
    * if you cd to a file, use the base path to cd into that directory

#### Priority Low

* add `gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook -dNOPAUSE -dBATCH -dColorImageResolution=150 -sOutputFile=output.pdf someBigFile.pdf` as `net_bazzline_compress_pdf` (@see: https://opensource.com/article/20/8/reduce-pdf)
* replace usage of packagemanager where needed with BASE_DISTRIBUTION ("arch", "debian" etc.)

#### Not organized yet

* create a way to easily change settings based on the environment (like "work" and "home")
* create function "regular_start" with dedicated processing steps (function calls defined via local.settings) to do, as example
    * disable touchpad
    * start wifi (if configured by using netctl configuration file via shell configuration)
    * update system
* for the function file as test
    * split this file up into logical units (source/function/filesystem/{luks, zfs}, source/function/media/image ...)
    * create bash script that glues them all together to the known function file
    * based on the configuration value, comment out or comment in the net_bazzline_record_function_usage
    * prefix all variables with "local "
    * move fitting code into c++ code
    * align output by using arch installation style ":: [A-Z"
    * implement bash auto completion (tricky part -> per user to support individual settings!)  support like "net_bazzline filesystem zfs list-available-snapshots" :O
* read each line in source or local.source and load them via source
* create caching 
    * that puts all files into one merged file below .config/net_bazzline/shell_config/merged_config
    * cache is cleared on "reloadBashEnvironment" and "clearCache"
    * can be enabled or disabled via setting
* extend update.sh
    * removes existing adaption of the bashrc
    * recalls install.sh
    * instead of adding more and more migration code (depending on the current installed version), why not do it this way:
        * create a tag per version
        * each tag has its migration section
        * the update script itself is iterating over the tags,
            checking this tag out and executing the migration section 
            (or the dedicated migration script) until the most up to date version is reached
            (and stored in .current_installed_version file)
        * steps
            * move migration code from update.sh to migrate.sh
            * write the current tag into the .current_installed_version
            * rewrite the update.sh to fetch all tags and iterate over them
* create script to manage local settings (configure.sh)
    * check system status (is sysstat, zfs, pacman, pacaur, etc.) installed
    * creates a system dependend alias file from (alias.source, alias/zfs.source, alias/software-pacaur.source, alias/software-pacman.source etc.)
    * creates a system dependend function file from (function.source, function/zfs.source, function/software-pacaur.source, function/software-pacman.source etc.)
* create clean
    * removes local.\* files
* create configuration to enable or disable things like zfs aliases
* deal with statistic data
    * enable/disable (disable is default)
    * analyze statistic data
    * delete statistic data
* installation
    * ask if .bash_profile should be created
    * ask if .bashrc should be created

### To Change

* change detection for libx256 or libx254 movies
    * instead of checking the filename, implement a dependency (or check if it exists) and use mediainfo
    * `mediainfo <filepath> | grep x265`
        * ore `ffprobe <filename> | grep codec_name`

## [Unreleased]

### Added

* Added `watchForSync`
* Added `NET_BAZZLINE_FWUPDMGR_IS_AVAILABLE` and fitting alias `firmware-update` if `fwupdmgr` is available on the system
* Added function to rip a cd as mp3 using cyanrip with alias `ripCdAsMp3`
* Added alias `ripDvdAsMkv` using `vobcopy` and `ffmpeg`
* Added `set -o vi`
* Added alias `createSha512SumFromFile`
* Added alias `bootstrapShellConfigurationInVerboseMode`
* Create script to manage `local setting` (configure_local_setting.sh)[bin/configure.sh]
  * Currently supports initial setting of `NET_BAZZLINE_PACKAGE_MANAGER`
* Added check for path provided in `net_bazzline_cd`
  * If path is a file, we use `dirname` to change into the directory of the file
  * Usecase: We are lazy, have used `vim foo/bar` and just want to replace  vim` with `cd` :-)
* Added `net_bazzline_network_ssh_to_host`
  * For each provided ip address as comma separated list
    * Checks if ssh is running on this host
    * If so, ssh into it
  * Example `net_bazzline_network_ssh_to_host 'ssh -i ~/.ssh/my_private_key user' '192.168.178.212,10.1.10.4'
* Added logic into the bootstrap files of the alias and the function section to only load what needed
  * Drawback, duplicated places where the almost same logic exists
  * Idea, move sections together like
    * `_source/windows/{bootstrap|filesystem_function|filesystem_alias}`
* Added `net_bazzline_robocopy` with my default values
  * Only available for windows systems
* Started alias section `cpu`
* Started alias section `network`
* Added function `net_bazzline_network_list_open_ports`

### Changed

* Changed arch linux keyring reinstalltion from 28 to 14 days
* Added optional parameters "number of retries if host is down" and "number of seconds between retries" for function `net_bazzline_network_ssh_to_host`
* Commented out `LESS_TERMCAP_*` settings section in file `setting`
* Moved `install.sh`, `update.sh` and `upgrade.sh` into [bin](bin/)

## [3.0.0](https://github.com/stevleibelt/shell_config/tree/3.0.0) - released at 20220315

### Added

* for arch linux package manager function, added check if provided packagemanager command exists (use case, yay was not installed)
* added usage of last_system_update file for arch linux
    * if file exists and timestamp is older than 28 days, `archlinux-keyring` will be reinstalled
* added `NET_BAZZLINE_CACHE_PATH`
* added screen wrapper when updating arch linux package managers or apt
* added `_source/alias/process.sh`
* added `net_bazzline_media_book_compress_pdf`
* added `net_bazzline_process_list_runtime`
* added `net_bazzline_process_list_memory_usage`
* added `NET_BAZZLINE_OPERATION_SYSTEM_IS_LINUX` and `NET_BAZZLINE_OPERATION_SYSTEM_IS_WINDOWS`

### Changed

* changed verbosity switch for `net_bazzline_shell_config_bootstrap`, call it from with an shell with `net_bazzline_shell_config_bootstrap 1` to enable verbosity
* changed alias from `diffDirectories` to `diffTwoPaths`
* changed function names from `net_bazzline_diff_directory` to `net_bazzline_diff_two_paths`
* changed the way we do an apt system update, now it is `apt update; apt upgrade` instead of `apt update && apt upgrade`
* renamed function `net_bazzline_list_biggest_directory` to `net_bazzline_list_filesystem_biggest_directory` and moved it into filesystem function section
* renamed function `net_bazzline_list_biggest_swapspace_consumers` to `net_bazzline_list_filesystem_biggest_swapspace_consumers` and moved it into filesystem function section
* renamed function `net_bazzline_load_ssh_keys_in_keychain` to `net_bazzline_load_ssh_key_in_keychain`
    * changed parameters, now second argument is timeout
* renamed "install" to "add" in the package manager section
* removed `vendor` option since I am not going to use it
* removed legacy local configuration file name support like `setting.local`
* updated reflector to latest configuration settings

## [2.0.0](https://github.com/stevleibelt/shell_config/tree/2.0.0) - released at 20210421

### Added

* CHANGELOG.md
* created setting values NET_BAZZLINE_ZFS_DEFAULT_POOL and NET_BAZZLINE_ZFS_AVAILABLE (NET_BAZZLINE_ZFS_AVAILABLE is set automatically be default)
* creation of .bash_profile during the installation
* dedicated installation script for pacget
* dedicated installation script for reflector
* converting to rav1e codec
* added support for third party vendor source

### Changed

* removed `automatic_start`
* refactored alias handling and streamlined function loading
    * introduced more system variables
    * moved variable dependend aliases into dedicated files
* refactored zfs filesystem functions and moved zfs pool value from mandatory to optional everywhere
* refactored deleteListOfDatedZfsSnapshots
    * list all snapshots fitting for this pool and store it in an array
    * use this array to check if this dated snapshot exists
* renamed `installation` to `setup` to ease up calling `install.sh`
* sorry I have to add this, but `and much more`

## [1.0.0](https://github.com/stevleibelt/shell_config/tree/1.0.0) - released at 20160423

* initial release
