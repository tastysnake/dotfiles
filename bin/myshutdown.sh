#!/bin/bash

lock="Lock"
suspend="Suspend"
poweroff="Power off"
reboot="Reboot"
no="Abort"

answer="$(xmessage "Turn off your computer?" -center -buttons "$lock","$suspend","$poweroff","$reboot","$no" -print -default "$suspend")"

case "$answer" in
    "$lock") i3lock -fc 8e86e3;;
    "$suspend") sudo systemctl suspend && i3lock -fc 8e86e3;;
    "$poweroff") sudo systemctl poweroff;;
    "$reboot") sudo systemctl reboot;;
    "$no") ;;
esac
exit
