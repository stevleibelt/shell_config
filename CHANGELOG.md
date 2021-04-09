# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [Open]

### To Add

* replace usage of packagemanager where needed with BASE_DISTRIBUTION ("arch", "debian" etc.)
* add `gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook -dNOPAUSE -dBATCH -dColorImageResolution=150 -sOutputFile=output.pdf someBigFile.pdf` as `net_bazzline_compress_pdf` (@see: https://opensource.com/article/20/8/reduce-pdf)
* extend "cd"
    * if you cd to a file, use the base path to cd into that directory
* *if* zfs is installed and root pool configured
    * make a snapshot before the upgrade and delete previous one
* create a unified backup function
    * creates a file ~/.config/net_bazzline/last_backup_to_$hostname
    * expectes following list of arguments
        * target\_hostname
        * target\_path
        * target\_ssh_key_path
        * target\_username
        * source\_path [source\_path[...]]
    * handles the synchronisation by using rsync
* create a function called "organize_dcim" which
    * loops starting from $(current_year - 10) until $(current_year) (if no argument provided)
    * checks if there are files matching the pattern "*_201910_*
    * if there is at least one file (grep -c)
    * check if there is a directory called "2019_10" and creates if it does not exist
    * moves all files for the pattern into this path
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

## [Unreleased]

### Added

* CHANGELOG.md
* created setting values NET_BAZZLINE_ZFS_DEFAULT_POOL and NET_BAZZLINE_ZFS_AVAILABLE (NET_BAZZLINE_ZFS_AVAILABLE is set automatically be default)
* creation of .bash_profile during the installation
* dedicated installation script for pacget
* dedicated installation script for reflector
* converting to rav1e codec

### Changed

* removed `automatic_start`
* refactored alias handling and streamlined function loading
    * introduced more system variables
    * moved variable dependend aliases into dedicated files
* refactored zfs filesystem functions and moved zfs pool value from mandatory to optional everywhere
* refactored deleteListOfDatedZfsSnapshots
    * list all snapshots fitting for this pool and store it in an array
    * use this array to check if this dated snapshot exists

## [1.0.0](https://github.com/stevleibelt/shell_config/tree/1.0.0) - released at 23.04.2016

* initial release
