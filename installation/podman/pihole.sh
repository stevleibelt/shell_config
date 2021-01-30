#!/bin/bash
####
# @see: https://www.suse.com/c/pihole-podman-opensuse/
# @since 2021-01-02
# @author stev leibelt <artodeto@bazzline.net>
####

function podman_install_or_update_pihole()
{
    #begin of testing the environment
    if [[ ! -f /usr/bin/podman ]];
    then
        echo ":: Podman is not installed."
        echo "   Will install it now."

        sudo pacman -Syy podman
    fi

    #   begin of clean up
    # @see: https://aarongodfrey.dev/software/running_pihole_in_docker_on_ubuntu_server/
    sudo systemctl disable systemd-resolved.service
    sudo systemctl stop systemd-resolved.service

    if pacman -Q | grep -q pi-hole
    then
        echo ":: Found existing installation of a pi hole server."
        echo "   Removing it..."

        sudo pacman -R pi-hole-server pi-hole-ftl
    fi

    if [[ -d /etc/pihole ]];
    then
        sudo mv /etc/pihole /etc/pihole.save
    fi

    if [[ -d /etc/dnsmasq.d ]];
    then
        sudo mv /etc/dnsmasq.d /etc/dnsmasq.d.save
    fi
    #   end of clean up
    #end of testing the environment

    #begin of dynamic variables
    SERVER_IP_ADDRESS=$(hostname -i)

    echo ":: Detected following server ip address."
    echo "   ${SERVER_IP_ADDRESS}"
    echo ":: Do you want to change this? (y|N)"
    read YES_OR_NO
    echo "> ${YES_OR_NO}"

    if [[ ${YES_OR_NO} == "y" ]];
    then
        echo ":: Please insert server ip address."
        read SERVER_IP_ADDRESS
    echo "> ${SERVER_IP_ADDRESS}"
    fi

    echo ":: Please insert password for admin page."
    read -s WEB_ADMINPASSWORD_ONE

    echo ":: Please insert password for admin page again."
    read -s WEB_ADMINPASSWORD_TWO

    if [[ "${WEB_ADMINPASSWORD_ONE}" -ne "${WEB_ADMINPASSWORD_TWO}" ]];
    then
        echo ":: Passwords are not equal."
        echo "   Will abort installation. Please try it again."

        exit 1
    fi

    SERVER_TIME_ZONE="Europe/Berlin"
    #end of dynamic variables

    #begin of creating the container
    if sudo podman images | grep -q pihole
    then
        podman auto-update
    else
        echo ":: Building container"
        sudo podman run -d \
            --name=pihole \
            -e TZ=${SERVER_TIME_ZONE} \
            -e WEBPASSWORD=${WEB_ADMINPASSWORD_ONE} \
            -e SERVERIP=${SERVER_IP_ADDRESS} \
            -v pihole:/etc/pihole \
            -v dnsmasq:/etc/dnsmasq.d \
            -p 80:80 \
            -p ${SERVER_IP_ADDRESS}:53:53/tcp \
            -p ${SERVER_IP_ADDRESS}:53:53/udp \
            --restart=unless-stopped \
            pihole/pihole
    fi
    #end of creating the container

    #begin of creating systemd unit file
    echo ":: Creating systemd unit file and starting it."
    PATH_TO_THE_SYSTEMD_UNIT_FILE="/etc/systemd/system/pihole.service"

    if [[ -f "${PATH_TO_THE_SYSTEMD_UNIT_FILE}" ]];
    then
        sudo rm "${PATH_TO_THE_SYSTEMD_UNIT_FILE}"
    fi

    sudo touch "${PATH_TO_THE_SYSTEMD_UNIT_FILE}"

    sudo bash -c "cat > \"${PATH_TO_THE_SYSTEMD_UNIT_FILE}\" <<DELIM
[Unit]
Description=Pi-hole Podman container
Wants=syslog.service
[Service]
Restart=always
ExecStart=/usr/bin/podman start -a pihole
ExecStop=/usr/bin/podman stop -t 10 pihole
[Install]
WantedBy=multi-user.target
DELIM"
    #end of creating systemd unit file

    #begin of installing and enabling the systemd unit file
    sudo systemctl daemon-reload
    sudo systemctl enable pihole.service
    sudo systemctl start pihole.service
    #end of installing and enabling the systemd unit file

    echo ":: All done."
    echo "   You can access the admin page via: http://${SERVER_IP_ADDRESS}/admin"

    exit 0
}

podman_install_or_update_pihole
