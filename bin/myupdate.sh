#!/bin/bash



BEEP="${HOME}/.local/share/pop.wav"
beep="aplay $BEEP"

# new
sudo dnf upgrade -y && notify-send "Software updates" "System is up-to-date."

$beep &> /dev/null

# remove old
sudo dnf autoremove -y && sudo dnf clean all && \
notify-send "Software updates" "Unnecessary packages removed."

$beep &> /dev/null
exit
