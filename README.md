# stev leibelt config for shell

This repostiry devides shell configuration into logical parts to gain overview and configuration flexibility.

The code comes with a predefined set of configuration settings.

The logical parts are:

* setting
* variable
* source
* export
* function
* alias
* automatic_start

You can overwrite or extend a logical part by creating a "local.<logical part file name>" file. This file is loaded after the original file.

# Installation

* git clone the repository int /your/path.
* execute install.sh

# Updating

* execute update.sh

# To Do

* extend update.sh
    * removes existing adaption of the bashrc
    * recalls install.sh
    * instead of adding more and more migration code (depending on the current installed version), why not do it this way:
        * create a tag per version
        * each tag has its migration section
        * the update script itself is iterating over the tags, checking this tag out and executing the migration section (or the dedicated migration script) until the most up to date version is reached (and stored in .current_installed_version file)
        * steps
            * move migration code from update.sh to migrate.sh
            * write the current tag into the .current_installed_version
            * rewrite the update.sh to fetch all tags and iterate over them
* create script to manage local settings
* create clean
    * removes local.\* files
* create configuration to enable or disable things like zfs aliases
* statistic data
    * enable/disable (disable is default)
    * analyze statistic data
    * delete statistic data
