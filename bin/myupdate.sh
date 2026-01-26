#!/bin/bash

BEEP="${HOME}/.local/share/pop.wav"
beep="aplay $BEEP"

DISTRO=$( grep -m 1 "^ID" /etc/os-release | cut -d'=' -f 2 )

# new
if [ "$DISTRO" == "ubuntu" ]; then
    sudo apt dist-upgrade -y
else
    sudo dnf upgrade -y
fi

notify-send "Software updates" "System is up-to-date."
$beep &> /dev/null

# remove old
if [ "$DISTRO" == "ubuntu" ]; then
    sudo apt autoremove --purge -y && sudo apt clean
else
    sudo dnf autoremove -y && sudo dnf clean all
fi

notify-send "Software updates" "Unnecessary packages removed."
$beep &> /dev/null

exit
