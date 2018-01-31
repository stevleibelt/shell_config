# stev leibelt config for shell

This repostiry devides shell configuration into logical parts to gain overview and configuration flexibility.

The current change log can be found [here](CHANGELOG.md).

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
