# Ansible scripts

## Kickstart

```bash
ansible-config init --disabled > ~/.ansible.cfg

# add pacman support
ansible-galaxy collection install community.general

# add aur support
ansible-galaxy collection install kewlfft.aur

# install packages
# replace --verbose with -vvv[vvv] if you want to know more
ansible-playbook --ask-become-pass --verbose system_setup.yml

# update packages
# replace --verbose with -vvv[vvv] if you want to know more
ansible-playbook --ask-become-pass --verbose system_upgrade.yml
```

## Links

* [ansible: wiki.archlinux.org](https://wiki.archlinux.org/title/Ansible) - 20230611
* [ansible-aur: github.com](https://github.com/kewlfft/ansible-aur) - 20230611
* [community.general.pacman module: docs.ansible.com](https://docs.ansible.com/ansible/latest/collections/community/general/pacman_module.html) - 20230611
* [community.general.zfs module: docs.ansible.com](https://docs.ansible.com/ansible/latest/collections/community/general/zfs_module.html#ansible-collections-community-general-zfs-module) - 20230611
