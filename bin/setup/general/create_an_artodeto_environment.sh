#!/bin/bash
####
# Create an environment artodeto can work with
####

exec &> >(tee "create_an_artodeto_environment.log")

####
# @param <string: current_step_journal_file_name>
# @param <int: current_step_version>
####
function _step_was_not_done ()
{
  #@todo
  #think about a logic  add a kind of migration from version 1 to 2
  # maybe have two functions? one for "step configuration exists" and "fetch version"
  # cat journal file | grep current_step_journal_file_name:current_step_version

  return 0
}

function _main () 
{
  local CURRENT_WORKING_DIRECTORY=$(pwd)
  local FILE_PATH_TO_THE_INSTALLATION_JOURNAL="${HOME}/.config/net_bazzline/setup/journal.txt"
  local PATH_TO_THIS_SCRIPT=$(cd $(dirname "${0}"); pwd)

  if [[ ! -f /usr/bin/pacman ]];
  then
    echo ":: Sorry, we need pacman to work."

    return 1
  fi

  #stage 1
  echo ":: Creating basic environment."
  
  if [[ ! -f ~/.bashrc ]];
  then
    cp /etc/bash.bashrc ~/.bashrc
  fi

  mkdir -p ~/document ~/media/{audio,book,image,video} ~/network/net.bazzline.cloud ~/software/source/com/github/stevleibelt ~/temporary/download

  localectl set-x11-keymap de

  bash "${PATH_TO_THIS_SCRIPT}/slock_on_suspend.sh"
  bash "${PATH_TO_THIS_SCRIPT}/../zfs/setup.sh"
  bash "${PATH_TO_THIS_SCRIPT}/../zfs/set_arc_size_max.sh"

  #stage2
  echo ":: Installing mandatory software."
  bash "${PATH_TO_THIS_SCRIPT}/install_packages.sh"

  #stage3
  echo ":: Adding github stored knowledge and settings."
  cd ~/software/source/com/github/stevleibelt

  cd shell_config
  git pull
  bash shell_config/bin/install.sh
  bash shell_config/bin/configure_local_settings.sh
  vimdiff shell_config/setting shell_config/local.setting
  cd ..
  
  if [[ ! -d settings ]];
  then
    git clone https://github.com/stevleibelt/settings
    # ref: https://git-scm.com/book/de/v2/Git-Tools-Submodule
    git submodule init
    git submodule update
  else
    cd settings
    git pull
    cd ..
  fi
  if [[ ! -d general_howtos ]];
  then
    git clone https://github.com/stevleibelt/general_howtos
  else
    cd general_howtos
    git pull
    cd ..
  fi
  if [[ ! -d examples ]];
  then
    git clone https://github.com/stevleibelt/examples
  else
    cd examples
    git pull
    cd ..
  fi

  bash settings/git/setup.sh
  bash settings/gnome-terminal-colors/install.sh
  bash settings/i3/install.sh
  bash settings/i3status/install.sh
  bash settings/screen/install.sh
  bash settings/vim/install.sh
  bash settings/xdg/install.sh

  # bo: ommd nohang
  yay -S nohang
  sudo systemctl enable nohang-desktop.service 
  sudo systemctl start nohang-desktop.service 
  # eo: ommd nohang

  # bo: docker
  sudo gpasswd -a ${USER} docker
  # eo: docker

  # bo: ssh agent
  # ref: https://wiki.archlinux.org/title/SSH_keys#Start_ssh-agent_with_systemd_user
  if [[ ! -f ~/.config/systemd/user/ssh-agent.service ]];
  then
    cat > ~/.config/systemd/user/ssh-agent.service <<DELIM
[Unit]
Description=SSH key agent

[Service]
Type=simple
Environment=SSH_AUTH_SOCK=%t/ssh-agent.socket
# DISPLAY required for ssh-askpass to work
Environment=DISPLAY=:0
ExecStart=/usr/bin/ssh-agent -D -a \$SSH_AUTH_SOCK

[Install]
WantedBy=default.target
DELIM
    echo 'export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/ssh-agent.socket' >> ~/software/source/com/github/stevleibelt/shell_config/local.export

    systemctl --user enable ssh-agent.service
    systemctl --user start ssh-agent.service
  fi
  # eo: ssh agent

  echo ":: @todo"
  echo "   Add >>NOPASSWD: /usr/bin/light<< to created user"

  cd "${CURRENT_WORKING_DIRECTORY}"
}

_main ${@}
