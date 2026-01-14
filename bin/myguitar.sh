#!/bin/bash

# software
guitarix &
sleep 1
gxtuner &
sleep 1

# hear regular audio (like Firefox)
pactl load-module module-jack-sink
pactl set-default-sink jack_out


# timidity for tuxguitar
if [ `ps aux|grep timidity|wc -l` == "1" ]; then
    echo "Starting timidity..."
    timidity -iAD
else
    echo "Timidity is already open. Killing and starting in Jack mode..."
    killall timidity
    timidity -iAD
fi
