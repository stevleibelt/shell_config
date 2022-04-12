# stev leibelt config for shell

This repository divides shell configuration into logical parts to gain overview and configuration flexibility.

The current change log can be found [here](CHANGELOG.md).

# Flavor it your taste

The code comes with a predefined set of configuration settings.

The logical parts are:

* setting
* variable
* source
* export
* function
* alias

You can overwrite or extend a logical part by creating a "local.<logical part file name>" file. This file is loaded after the original file.

If you want to see what is loaded and what is skipped, call `net_bazzline_shell_config_bootstrap 1` or use the build in alias `bootstrapShellConfigurationInVerboseMode`.

# Installation

```
git clone https://github.com/stevleibelt/shell_config .
./shell_config/bin/install.sh
```

# Updating

```
updateShellConfiguration
```

# Links

* [bash-config](https://github.com/victorbrca/bash-config) - 20210409
