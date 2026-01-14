#!/bin/bash


while true; do {
    t=`(date +"%T")`
    keyboard=`(tail /var/log/syslog | grep "$t" | grep "USB Keyboard")`

    if [ -n "$keyboard" ]; then {
        $HOME/bin/mykeyboard.sh
    }
    fi
    sleep 1
}
done
