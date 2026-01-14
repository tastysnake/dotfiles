#!/bin/sh

# single parameter, any text
# if empty, just shows whether if mounted or not
# if something, then mount if unmounted and viceversa

# for example: myextdrive.sh --mount

mount="$1"
string="$(mount|grep Ext)"

message () {
    xmessage -center "$1"
}

if [ -z "$string" ]; then

    info="Not mounted."

    # -n = non-zero string
    if [ -n "$mount" ]; then
        sudo mount /mnt/External
        if [ $? -ne 0 ]; then
            info="$info Tried to mount but got mounting error."
        else
            info="$info Mounted successfully."
        fi
    fi

    message "$info"

else

    info="Mounted."

    # -n = non-zero string
    if [ -n "$mount" ]; then
        sudo umount /mnt/External
        if [ $? -ne 0 ]; then
            info="$info Tried to unmount but got mounting error."
        else
            info="$info Unmounted successfully."
        fi
    fi

    message "$info"

fi
