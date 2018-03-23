# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [Open]

### To Add

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
* create a value ZFS_DEFAULT_POOL which is used in the delete[List]ZfsSnapshot functions

### To Change

## [Unreleased]

### Added

* CHANGELOG.md
* creation of .bash_profile during the installation
* dedicated installation script for pacget
* dedicated installation script for reflector

### Changed

## [1.0.0](https://github.com/stevleibelt/shell_config/tree/1.0.0) - released at 23.04.2016

* initial release
