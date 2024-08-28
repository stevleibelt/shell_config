#!/bin/bash
####
# Installs and configures sshd
####
# @since 2024-04-02
# @author stev leibelt <artodeto@arcor.de>
####

function install_if_needed()
{
  echo ":: Installing and configuring sshd if needed"
  if [[ ! -f /usr/bin/pacman ]];
  then
      echo "   Aborting."
      echo "   No /usr/bin/pacman installed."

      exit 1
  fi

  if [[ -f /usr/bin/sshd ]];
  then
    echo "   Sshd is installed already"
  else
    sudo pacman -S openssh
  fi

  # @todo: allow only for dedicated user groups
  #   man sshd_config
  #   AllowGroups
  echo "   Configuring sshd"
  sudo bash -c "cat > /etc/ssh/sshd_config.d/10-elbzone.conf <<DELIM
# ref: https://infosec.mozilla.org/guidelines/openssh.html
# Supported HostKey algorithms by order of preference.
HostKey /etc/ssh/ssh_host_ed25519_key
HostKey /etc/ssh/ssh_host_rsa_key
HostKey /etc/ssh/ssh_host_ecdsa_key

KexAlgorithms curve25519-sha256@libssh.org,ecdh-sha2-nistp521,ecdh-sha2-nistp384,ecdh-sha2-nistp256,diffie-hellman-group-exchange-sha256

Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr

MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-512,hmac-sha2-256,umac-128@openssh.com


# Password based logins are disabled - only public key based logins are allowed.
AuthenticationMethods publickey

# LogLevel VERBOSE logs user's key fingerprint on login. Needed to have a clear audit track of which key was using to log in.
LogLevel VERBOSE

# Log sftp level file access (read/write/etc.) that would not be easily logged otherwise.
Subsystem sftp  /usr/lib/ssh/sftp-server -f AUTHPRIV -l INFO

# Root login is not allowed for auditing reasons. This is because it's difficult to track which process belongs to which root user:
#
# On Linux, user sessions are tracking using a kernel-side session id, however, this session id is not recorded by OpenSSH.
# Additionally, only tools such as systemd and auditd record the process session id.
# On other OSes, the user session id is not necessarily recorded at all kernel-side.
# Using regular users in combination with /bin/su or /usr/bin/sudo ensure a clear audit track.
PermitRootLogin No
DELIM"

  if sudo systemctl is-active --quiet sshd.service;
  then
    echo "   Restarting sshd service"
    sudo systemctl restart sshd.service
    sudo systemctl status sshd.service
  fi
}

install_if_needed

